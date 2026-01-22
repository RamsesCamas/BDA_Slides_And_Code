# Clase 04 - Evidence mindset

## Que se evalua
- Explicacion: cada reporte debe decir que devuelve, su grain y la metrica.
- Verificacion: incluye consultas VERIFY que demuestren el resultado.

## Ejemplos de VERIFY validos
- COUNT de filas devueltas.
- COUNT DISTINCT de la entidad clave.
- LIMIT 5 para inspeccion visual.
- Caso puntual: elegir un id y listar su detalle para comprobar la metrica.

## Anti "corre y ya"
- Pide un caso puntual: "Muestrame un usuario del reporte y sus ordenes".
- Contrasta el total con una suma de detalle para el mismo id.
- Si el numero no cuadra, revisa joins 1:N y usa COUNT DISTINCT cuando aplique.
