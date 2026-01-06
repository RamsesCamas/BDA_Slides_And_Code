#!/usr/bin/env python3
import os
import time
import psycopg2
from psycopg2.extras import RealDictCursor

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME', 'mydb')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'postgres')

SQL_DIR = 'sql'

def wait_for_db(max_retries=30, delay=2):
    print(f"⏳ Esperando a que PostgreSQL esté listo en {DB_HOST}:{DB_PORT}...")
    
    for attempt in range(max_retries):
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                port=DB_PORT,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                connect_timeout=5
            )
            conn.close()
            print("✅ PostgreSQL está listo!")
            return True
        except psycopg2.OperationalError as e:
            print(f"  Intento {attempt + 1}/{max_retries}: {e}")
            time.sleep(delay)
    
    print("❌ No se pudo conectar a PostgreSQL después de varios intentos")
    return False

def execute_sql_file(conn, filepath, description):
    print(f"\n⚡ Ejecutando {description}: {filepath}")
    
    with open(filepath, 'r') as f:
        sql = f.read()
    
    cur = conn.cursor()
    
    try:
        cur.execute(sql)
        conn.commit()
        print(f"✅ {description} ejecutado exitosamente")
        return True
    except Exception as e:
        conn.rollback()
        print(f"❌ Error al ejecutar {description}: {e}")
        return False
    finally:
        cur.close()

def execute_and_print_query(conn, query, description):
    print(f"\n🔍 Ejecutando query: {description}")
    print("=" * 80)
    
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cur.execute(query)
        results = cur.fetchall()
        
        if not results:
            print("📭 No se encontraron resultados")
        else:
            columns = [desc[0] for desc in cur.description]
            
            print("📊 Resultados:")
            print("-" * 80)
            
            for col in columns:
                print(f"{col:<25}", end="")
            print()
            print("-" * 80)
            
            for row in results:
                for col in columns:
                    value = str(row[col]) if row[col] is not None else "NULL"
                    print(f"{value[:24]:<25}", end="")
                print()
            
            print("-" * 80)
            print(f"📈 Total filas: {len(results)}")
        
        return True
    except Exception as e:
        print(f"❌ Error al ejecutar query: {e}")
        return False
    finally:
        cur.close()

def main():
    print("🚀 Iniciando migración de base de datos")
    print("=" * 80)
    
    if not wait_for_db():
        print("\n❌ Abortando migración")
        return False
    
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            cursor_factory=RealDictCursor
        )
        
        print(f"\n✅ Conectado a PostgreSQL: {DB_HOST}:{DB_PORT}/{DB_NAME}")
        
        schema_path = os.path.join(SQL_DIR, 'schema.sql')
        seed_path = os.path.join(SQL_DIR, 'seed.sql')
        queries_path = os.path.join(SQL_DIR, 'queries.sql')
        
        if not os.path.exists(schema_path):
            print(f"❌ No se encontró {schema_path}")
            return False
        
        success = True
        
        success &= execute_sql_file(conn, schema_path, "Schema")
        
        if os.path.exists(seed_path):
            success &= execute_sql_file(conn, seed_path, "Seed")
        else:
            print("⚠️ No se encontró seed.sql, omitiendo...")
        
        if os.path.exists(queries_path):
            print(f"\n📄 Leyendo queries desde: {queries_path}")
            with open(queries_path, 'r') as f:
                queries_content = f.read()
            
            import re
            query_pattern = r'-- Query (\d+)(.*?)\n'
            
            queries = re.split(query_pattern, queries_content)
            
            for i in range(1, len(queries), 3):
                if i + 2 < len(queries):
                    qid = queries[i]
                    title = queries[i + 1].strip() if queries[i + 1] else f"Query {qid}"
                    sql = queries[i + 2].strip()
                    
                    if sql:
                        execute_and_print_query(conn, sql, f"Query {qid}: {title}")
                        time.sleep(0.5)
        else:
            print("⚠️ No se encontró queries.sql, omitiendo...")
        
        conn.close()
        
        print("\n" + "=" * 80)
        if success:
            print("🎉 Migración completada exitosamente!")
        else:
            print("⚠️ Migración completada con errores")
        
        return success
        
    except Exception as e:
        print(f"\n❌ Error durante la migración: {e}")
        return False

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
