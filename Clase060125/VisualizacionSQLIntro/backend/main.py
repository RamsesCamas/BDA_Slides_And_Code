import os
from typing import List, Dict, Any
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor

app = FastAPI(title="SQL Lab API - Demo", version="2.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "bda_class")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            cursor_factory=RealDictCursor
        )
        return conn
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")

def set_timeouts(conn):
    cur = conn.cursor()
    cur.execute("SET statement_timeout = '5s';")
    cur.execute("SET lock_timeout = '2s';")
    cur.execute("SET idle_in_transaction_session_timeout = '10s';")
    conn.commit()

@app.get("/api/health")
async def health_check():
    return {"status": "ok", "timestamp": os.urandom(16).hex()}

@app.get("/api/queries")
async def get_queries():
    queries_path = "/app/queries.sql"
    try:
        with open(queries_path, 'r') as f:
            content = f.read()
        return {"sql": content}
    except FileNotFoundError:
        raise HTTPException(status_code=404, detail="queries.sql not found")

class QueryRequest(BaseModel):
    qid: str

@app.post("/api/run/query")
async def run_query(request: QueryRequest):
    queries_path = "/app/queries.sql"
    try:
        with open(queries_path, 'r') as f:
            queries = f.read()
    except FileNotFoundError:
        raise HTTPException(status_code=404, detail="queries.sql not found")
    
    query_pattern = f"-- Query {request.qid}"
    query_start = queries.find(query_pattern)
    if query_start == -1:
        raise HTTPException(status_code=404, detail=f"Query {request.qid} not found")
    
    next_query_start = queries.find("-- Query", query_start + 1)
    if next_query_start == -1:
        query_sql = queries[query_start:].strip()
    else:
        query_sql = queries[query_start:next_query_start].strip()
    
    query_sql = '\n'.join([line for line in query_sql.split('\n') if not line.strip().startswith('--')])
    query_sql = query_sql.strip()
    
    conn = get_db_connection()
    set_timeouts(conn)
    cur = conn.cursor()
    
    try:
        cur.execute(query_sql)
        results = cur.fetchall()
        
        if cur.description:
            columns = [desc[0] for desc in cur.description]
        else:
            columns = []
        
        rows = [dict(row) for row in results]
        
        return {"status": "success", "columns": columns, "rows": rows, "qid": request.qid}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Query execution failed: {str(e)}")
    finally:
        conn.close()

@app.get("/api/introspect")
async def introspect():
    conn = get_db_connection()
    set_timeouts(conn)
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """)
        tables = [row["table_name"] for row in cur.fetchall()]
        
        table_info = {}
        for table in tables:
            cur.execute("""
                SELECT column_name, data_type, is_nullable, column_default
                FROM information_schema.columns
                WHERE table_schema = 'public' AND table_name = %s
                ORDER BY ordinal_position;
            """, (table,))
            table_info[table] = [dict(row) for row in cur.fetchall()]
        
        return {"schema": "public", "tables": table_info}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Introspection failed: {str(e)}")
    finally:
        conn.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
