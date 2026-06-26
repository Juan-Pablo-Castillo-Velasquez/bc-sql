# Cuestionario Semanal — Semana 11: Subqueries
**Estudiante:** JUAN PABLO CASTILLO VELASQUEZ — 3228970A

### 1. ¿Qué es una subquery escalar y en qué cláusulas se puede implementar?
Una subquery escalar es una consulta interna anidada que devuelve exactamente **una única fila y una única columna** (un solo valor conceptual). Debido a que se comporta como una constante dinámica, se puede utilizar en cláusulas `SELECT` (para añadir columnas de cálculo global), en `WHERE` o `HAVING` (para realizar comparaciones lógicas directas como `>`, `<`, `=`), y en sentencias condicionales.

### 2. ¿Cuál es la diferencia operativa entre los operadores IN y EXISTS?
* **IN:** Evalúa si un valor coincide dentro de un conjunto o lista estática de elementos devueltos por la subquery. Es ideal para subqueries no correlacionadas e independientes.
* **EXISTS:** No evalúa valores individuales; en su lugar, verifica la **existencia de registros** que cumplan con una condición. Funciona mediante subqueries correlacionadas y detiene su escaneo en cuanto encuentra la primera coincidencia (`Short-circuit evaluation`), lo que lo hace mucho más óptimo para tablas con grandes volúmenes de datos.

### 3. ¿Por qué es obligatorio asignar un alias a una tabla derivada en la cláusula FROM?
Una subquery ubicada en la cláusula `FROM` actúa como una tabla física temporal (o vista inline) durante el tiempo de ejecución. El motor de base de datos (SQLite) exige obligatoriamente un alias para poder referenciar, identificar y resolver de forma inequívoca el nombre de las columnas de dicha estructura en las cláusulas externas como `SELECT`, `WHERE` o `JOIN`.

### 4. ¿Qué es una subquery correlacionada y cómo afecta al rendimiento de la base de datos?
Es una subconsulta que depende directamente de una o más columnas pertenecientes a la consulta exterior para poder ejecutar sus filtros. A diferencia de una subquery independiente que se ejecuta una sola vez, la subquery correlacionada **se ejecuta de forma iterativa, una vez por cada fila procesada por la consulta externa**. Si las tablas no poseen índices adecuados, esto puede degradar el rendimiento transformándose en un problema de coste computacional complejo.