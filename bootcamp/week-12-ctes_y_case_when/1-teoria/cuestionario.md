# Cuestionario Semanal — Semana 12: CTEs y CASE WHEN
**Estudiante:** JUAN PABLO CASTILLO VELASQUEZ — 3228970A

### 1. ¿Qué es un CTE (Common Table Expression) y para qué sirve en el desarrollo de software?
Un CTE es una expresión de tabla común que actúa como un conjunto de resultados temporal y nombrado, el cual existe únicamente durante la ejecución de una consulta única (`SELECT`, `INSERT`, `UPDATE` o `DELETE`). Sirve principalmente para desglosar consultas complejas en bloques modulares legibles, actuando de forma similar a cómo declaramos variables o funciones auxiliares en lenguajes como Python o TypeScript.

### 2. ¿Cuál es la diferencia operativa entre un CTE y una tabla derivada (Subquery en el FROM)?
* **Legibilidad:** El CTE se define al inicio de la consulta usando la cláusula `WITH`, lo que permite leer el código de arriba hacia abajo de forma lineal. Las tablas derivadas obligan a leer de adentro hacia afuera, lo que dificulta el mantenimiento.
* **Reutilización:** Un mismo CTE puede ser referenciado múltiples veces en la consulta principal o por otros CTEs encadenados en el mismo flujo. Una tabla derivada tendría que duplicarse textualmente si se necesita usar más de una vez.

### 3. Explica el funcionamiento de la estructura CASE WHEN y la importancia de sus cláusulas.
`CASE WHEN` es la estructura de control condicional de SQL (equivalente a un `if/elif/else` en programación). Evalúa condiciones de manera secuencial:
* **WHEN:** Define la condición lógica a evaluar.
* **THEN:** Especifica el valor que se retornará si la condición anterior es verdadera.
* **ELSE:** Captura todos los casos remotos que no cumplieron ninguna de las condiciones anteriores, evitando que se retornen valores `NULL` inesperados.
* **END:** Finaliza obligatoriamente el bloque de la expresión condicional.