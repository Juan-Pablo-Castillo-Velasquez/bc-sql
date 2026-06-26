# Cuestionario Semanal — Semana 13: CTEs Recursivas
**Estudiante:** JUAN PABLO CASTILLO VELASQUEZ — 3228970A
**Motor:** PostgreSQL 16

### 1. Identifica y explica los componentes de una CTE Recursiva (Caso Base, Caso Recursivo y la unión entre ellos).
Una CTE recursiva en PostgreSQL se compone estructuralmente de tres partes clave dentro del bloque `WITH RECURSIVE`:
* **Caso Base (Anchor Member):** Es una consulta no recursiva inicial que establece el punto de partida del conjunto de resultados (la raíz del árbol, por ejemplo, donde `parent_id IS NULL` o el valor inicial de un contador). Se ejecuta exactamente una vez.
* **UNION ALL:** Es el operador que conecta de manera obligatoria el caso base con el caso recursivo, permitiendo fusionar iterativamente las filas nuevas con las anteriores.
* **Caso Recursivo (Recursive Member):** Es la consulta que hace auto-referencia al nombre de la propia CTE. Lee las filas producidas en la iteración previa, realiza operaciones o joins, y produce un nuevo subconjunto de filas para la siguiente iteración.

### 2. Explica qué sucede si una CTE recursiva no incluye una condición de parada o filtro WHERE adecuado.
Si el miembro recursivo no cuenta con una condición de parada lógica (como `WHERE contador < 10` o un `INNER JOIN` que eventualmente se quede sin coincidencias de nodos hijos en una jerarquía física), la consulta entrará en un **bucle infinito (Infinite Loop)**. En entornos de producción, esto provocará un consumo desmedido de memoria RAM y CPU en el servidor PostgreSQL, agotando el espacio de almacenamiento temporal en disco hasta que el motor aborte la transacción por un desbordamiento o sea finalizado manualmente por el administrador de la base de datos (DBA).

### 3. ¿Cuál es la diferencia operativa fundamental entre una CTE normal y una CTE recursiva?
* **CTE Normal:** Actúa como una vista temporal estática o una subconsulta nombrada lineal. Se evalúa una sola vez y su resultado se usa como una tabla fija en la consulta exterior. No puede referenciarse a sí misma.
* **CTE Recursiva:** Es dinámica e iterativa. El motor de la base de datos mantiene un búfer de datos intermedio (Working Table) y vuelve a ejecutar el miembro recursivo de manera consecutiva, usando el output de la iteración anterior como input de la actual, hasta que la consulta recursiva retorne cero filas.