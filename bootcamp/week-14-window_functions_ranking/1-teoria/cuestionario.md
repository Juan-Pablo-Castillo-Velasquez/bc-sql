# Cuestionario Semanal — Semana 14: Window Functions (Ranking)
**Estudiante:** JUAN PABLO CASTILLO VELASQUEZ — 3228970A
**Motor:** PostgreSQL 16
**Dominio de Aplicación:** Heladería (Flavors, Products, Sales, Branches)

### 1. Explica el propósito de las cláusulas OVER() y PARTITION BY. ¿Cuál es su diferencia clave con un GROUP BY?
* **OVER():** Le indica a PostgreSQL que la función debe ejecutarse como una función de ventana, definiendo el marco o conjunto de filas sobre el cual se aplicará el cálculo analítico.
* **PARTITION BY:** Divide el conjunto de datos en grupos lógicos o particiones independientes. En nuestro dominio, permite segmentar las métricas por cada sucursal (`branch_id`) o por categoría de sabor (`category`), logrando que funciones como los rankings se reinicien automáticamente al pasar de una sucursal a otra.
* **Diferencia Clave:** `GROUP BY` colapsa o agrupa las filas originales de ventas, reduciendo el resultado a una sola fila resumen por grupo (perdiendo el detalle del ticket). En cambio, `PARTITION BY` realiza el cálculo analítico del ranking por sucursal manteniendo intacta la identidad y el detalle de cada fila de venta (`sales`) en el set de salida.

### 2. Describe las diferencias fundamentales entre ROW_NUMBER(), RANK() y DENSE_RANK() ante situaciones de empate.
Tomando como ejemplo que dos ventas de helados en la sucursal registren un monto idéntico de 6,500 en las posiciones 2 y 3, el comportamiento analítico es:
* **ROW_NUMBER():** Asigna un número secuencial único y estricto a cada fila, ignorando el empate en el valor. No repite números bajo ninguna circunstancia (las asignará como posición 2 y 3 de forma arbitraria).
* **RANK():** Asigna el mismo número de rango a las ventas empatadas, pero genera un "salto" en la numeración posterior equivalente a la cantidad de elementos empatados. La secuencia para las siguientes ventas quedaría como: 1, 2, 2, 4.
* **DENSE_RANK():** Asigna el mismo número de rango a las ventas empatadas, pero NO genera saltos en la secuencia posterior. La numeración de los niveles de facturación sigue estrictamente consecutiva: 1, 2, 2, 3.

### 3. ¿Por qué no se puede filtrar directamente una función de ventana en el WHERE de la misma consulta? Explica la solución estándar.
No se puede filtrar en el `WHERE` debido al orden de ejecución lógico (fases de procesamiento) de los motores SQL en PostgreSQL. El `WHERE` se evalúa y ejecuta mucho antes de procesar las funciones de ventana (las cuales se calculan arriba, en la fase del `SELECT`). Por lo tanto, en el momento del filtrado, la columna calculada del ranking aún no existe para el motor.
* **Solución Estándar:** Envolver la consulta primaria que calcula el ranking de ventas dentro de una Expresión de Tabla Común o CTE (`WITH ranked AS (...)`), y posteriormente aplicar la cláusula de filtrado `WHERE` en la consulta exterior apuntando al alias asignado (por ejemplo, `WHERE branch_rank <= 2` para obtener el Top-2 por sucursal).