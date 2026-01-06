import { useState, useEffect } from 'react';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

function App() {
  const [queriesSql, setQueriesSql] = useState('');
  const [selectedQuery, setSelectedQuery] = useState(null);
  const [results, setResults] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchQueries();
  }, []);

  const fetchQueries = async () => {
    try {
      const response = await fetch(`${API_URL}/api/queries`);
      const data = await response.json();
      setQueriesSql(data.sql);
    } catch (err) {
      setError('Error al cargar las queries: ' + err.message);
    }
  };

  const extractQuery = (qid) => {
    const pattern = `-- Query ${qid}`;
    const start = queriesSql.indexOf(pattern);
    if (start === -1) return null;
    
    const nextPattern = queriesSql.indexOf("-- Query", start + 1);
    let queryText = nextPattern === -1 
      ? queriesSql.substring(start).trim()
      : queriesSql.substring(start, nextPattern).trim();
    
    return queryText.replace(pattern, '').trim();
  };

  const runQuery = async (qid) => {
    setLoading(true);
    setError('');
    setResults(null);
    setSelectedQuery(qid);
    
    try {
      const response = await fetch(`${API_URL}/api/run/query`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ qid: qid })
      });
      
      const data = await response.json();
      setResults(data);
      setError('');
    } catch (err) {
      setError('Error ejecutando query: ' + (err.message));
    } finally {
      setLoading(false);
    }
  };

  const runIntrospection = async () => {
    try {
      const response = await fetch(`${API_URL}/api/introspect`);
      const data = await response.json();
      console.log('Introspection:', data);
      alert('Introspección completada. Revisa la consola para más detalles.');
    } catch (err) {
      setError('Error en introspección: ' + err.message);
    }
  };

  const renderTable = () => {
    if (!results || !results.rows || results.rows.length === 0) {
      return (
        <div style={{
          padding: '3rem',
          background: '#fff5f5',
          borderRadius: '6px',
          border: '1px solid #feb2b2',
          textAlign: 'center',
          color: '#666'
        }}>
          📭 No se encontraron resultados
        </div>
      );
    }

    return (
      <div style={{
        marginBottom: '1rem',
        padding: '1rem',
        background: '#f0fff4',
        borderRadius: '6px',
        border: '1px solid #9ae6b4'
      }}>
        <div style={{ marginBottom: '1rem', color: '#276749', fontWeight: '600' }}>
          📈 {results.rows.length} fila{results.rows.length !== 1 ? 's' : ''} encontrada{results.rows.length !== 1 ? 's' : ''}
        </div>
        <div style={{
          overflowX: 'auto',
          maxHeight: '400px'
        }}>
          <table style={{
            width: '100%',
            borderCollapse: 'collapse',
            marginBottom: '1rem',
            fontSize: '0.85rem'
          }}>
            <thead>
              <tr style={{ background: '#f7fafc' }}>
                {results.columns && results.columns.map((col, i) => (
                  <th key={i} style={{
                    padding: '0.75rem',
                    textAlign: 'left',
                    fontWeight: '600',
                    color: '#2d3748',
                    borderBottom: '1px solid #e2e8f0'
                  }}>
                    {col}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {results.rows.map((row, i) => (
                <tr key={i} style={{
                  background: i % 2 === 0 ? '#ffffff' : '#f7fafc'
                }}>
                  {results.columns.map((col, j) => (
                    <td key={j} style={{
                      padding: '0.75rem',
                      borderBottom: '1px solid #e2e8f0',
                      textAlign: 'left'
                    }}>
                      {row[col] ? String(row[col]) : 'NULL'}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  };

  return (
    <div style={{ maxWidth: '1400px', margin: '0 auto', padding: '2rem', fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif' }}>
      <div style={{
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        color: 'white',
        padding: '2rem',
        borderRadius: '8px',
        marginBottom: '2rem'
      }}>
        <h1 style={{ margin: '0 0 1rem 0' }}>🧪 SQL Lab - Demo Visual</h1>
        <p style={{ margin: 0, opacity: 0.9 }}>Demostración visual de queries SQL para clase de BDA</p>
      </div>

      {error && (
        <div style={{
          padding: '1rem',
          background: '#fee2e2',
          border: '1px solid #fecaca',
          borderRadius: '6px',
          marginBottom: '1rem',
          color: '#c53030'
        }}>
          ❌ {error}
        </div>
      )}

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '2rem' }}>
        <div>
          <h2 style={{ marginBottom: '1rem', color: '#2d3748' }}>📋 Lista de Queries</h2>
          <div style={{ marginBottom: '1rem', padding: '1rem', background: '#f7fafc', borderRadius: '6px' }}>
            <button
              onClick={runIntrospection}
              style={{
                padding: '0.5rem 1rem',
                marginBottom: '1rem',
                background: '#4299e1',
                color: 'white',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer',
                fontWeight: '500'
              }}
            >
              🔍 Ver Esquema de la DB
            </button>
            <pre style={{
              background: '#1a1a2e',
              color: '#e6e6fa',
              padding: '1rem',
              borderRadius: '6px',
              overflow: 'auto',
              maxHeight: '400px',
              fontSize: '0.85rem',
              margin: '0'
            }}>
              {queriesSql}
            </pre>
            {[1, 2, 3, 4, 5, 6, 7].map(qid => (
              <button
                key={qid}
                onClick={() => runQuery(qid.toString())}
                style={{
                  padding: '0.5rem 1rem',
                  marginBottom: '0.5rem',
                  background: '#48bb78',
                  color: 'white',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer',
                  fontWeight: '500',
                  width: '100%',
                  textAlign: 'left'
                }}
              >
                Query {qid}
              </button>
            ))}
          </div>
        </div>

        <div>
          <h2 style={{ marginBottom: '1rem', color: '#2d3748' }}>📊 Resultados</h2>
          
          {results ? (
            <div>
              <div style={{
                marginBottom: '1rem',
                padding: '1rem',
                background: '#f7fafc',
                borderRadius: '6px',
                border: '1px solid #e2e8f0'
              }}>
                <strong>📝 Query {results.qid}:</strong>
                <pre style={{
                  background: '#1a1a2e',
                  color: '#e6e6fa',
                  padding: '1rem',
                  borderRadius: '6px',
                  overflow: 'auto',
                  maxHeight: '200px',
                  fontSize: '0.85rem',
                  margin: '0 0 1rem 0'
                }}>
                  {extractQuery(results.qid)?.split('\n')[0].substring(0, 100)}...
                </pre>
              </div>
              {renderTable()}
            </div>
          ) : loading ? (
            <div style={{
              padding: '3rem',
              textAlign: 'center',
              color: '#666'
            }}>
              ⏳ Ejecutando query...
            </div>
          ) : (
            <div style={{
              padding: '3rem',
              textAlign: 'center',
              color: '#666'
            }}>
              💡 Selecciona una query del panel izquierdo para ejecutarla
            </div>
          )}
        </div>
      </div>

      <div style={{
        marginTop: '3rem',
        padding: '2rem',
        background: '#f0f4ff',
        borderRadius: '6px',
        border: '1px solid #9ae6b4'
      }}>
        <h3 style={{ marginBottom: '1rem', color: '#2c5282' }}>ℹ️ Información:</h3>
        <ul style={{ marginLeft: '1.5rem', color: '#2c5282', lineHeight: '1.6' }}>
          <li>Esta es una demostración visual de queries SQL</li>
          <li>Haz clic en una query para ejecutarla</li>
          <li>Los resultados se muestran en la tabla de la derecha</li>
          <li>Todas las queries se ejecutan en el schema 'public'</li>
          <li>No se requiere autenticación</li>
          <li>El código SQL es visible para aprender</li>
        </ul>
      </div>
    </div>
  );
}

export default App;
