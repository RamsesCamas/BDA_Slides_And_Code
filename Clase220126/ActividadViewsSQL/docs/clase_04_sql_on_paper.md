# Clase 04 - SQL on paper

## Tablita mini
| customer | order_id | total | order_date |
| --- | --- | --- | --- |
| A | 101 | 20.00 | 2024-01-03 |
| A | 102 | 35.50 | 2024-01-08 |
| B | 103 | 15.00 | 2024-01-10 |
| B | 104 | 55.00 | 2024-01-12 |
| C | 105 | 20.00 | 2024-01-15 |
| A | 106 | 10.00 | 2024-01-20 |

## Preguntas guiadas
1) Que se agrupa?
2) Que metrica se calcula?
3) WHERE o HAVING y por que?

## Mini guion (30-45s)
- "Agrupamos por customer porque el reporte pide totales por cliente"
- "La metrica es SUM(total) porque queremos medir ingresos por cliente"
- "Usamos WHERE para filtrar fechas antes del GROUP BY y HAVING para filtrar grupos despues"

## Errores comunes
- Confundir WHERE vs HAVING
- Grain ambiguo (no queda claro que representa cada fila)
- Contar filas en lugar de entidades (COUNT vs COUNT DISTINCT)
