-- ============================================
-- Semana 15: Window Functions Navegación — Ejercicio 01 y 02
-- Motor: PostgreSQL 16
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- ============================================

-- ============================================
-- EJERCICIO 01 - PASO 1: LAG — acceder al mes anterior
-- ============================================
-- Muestra el monto de ventas de helados del mes anterior usando LAG().
-- El valor por defecto 0 evita la generación de NULL en el primer registro histórico.

SELECT
    sale_month,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY sale_month) AS prev_amount
FROM monthly_sales
ORDER BY sale_month;


-- ============================================
-- EJERCICIO 01 - PASO 2: Calcular la diferencia (delta)
-- ============================================
-- Resta el monto actual de la heladería menos el del mes inmediatamente anterior.
-- Un delta positivo indica crecimiento en la venta de helados; uno negativo representa una caída.

SELECT
    sale_month,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY sale_month)          AS prev_amount,
    amount - LAG(amount, 1, 0) OVER (ORDER BY sale_month) AS delta
FROM monthly_sales
ORDER BY sale_month;


-- ============================================
-- EJERCICIO 01 - PASO 3: LAG por sucursal (PARTITION BY)
-- ============================================
-- La comparación temporal se reinicia para cada sucursal (branch_id).
-- Compara el comportamiento comercial de cada mes con el mes anterior de la MISMA sucursal.

SELECT
    sale_month,
    branch_id,
    amount,
    LAG(amount, 1, 0) OVER (
        PARTITION BY branch_id
        ORDER BY sale_month
    ) AS prev_branch_amount
FROM monthly_sales
ORDER BY branch_id, sale_month;


-- ============================================
-- EJERCICIO 01 - PASO 4: LEAD — ver el siguiente mes
-- ============================================
-- LEAD accede al registro del mes posterior; inyecta NULL en el último registro del año.
-- Útil en proyecciones comerciales para evaluar si el periodo actual superará al siguiente.

SELECT
    sale_month,
    amount,
    LEAD(amount, 1, NULL) OVER (ORDER BY sale_month) AS next_amount
FROM monthly_sales
ORDER BY sale_month;


-- ============================================
-- EJERCICIO 02 - PASO 1: FIRST_VALUE por sucursal
-- ============================================
-- Identifica el mes con mayor facturación de helados de cada sucursal y lo proyecta en todas sus filas.
-- Se ordena por amount DESC para asegurar que el primer registro capturado sea el más alto.

SELECT
    sale_month,
    branch_id,
    amount,
    FIRST_VALUE(amount) OVER (
        PARTITION BY branch_id
        ORDER BY amount DESC
    ) AS branch_best
FROM monthly_sales
ORDER BY branch_id, sale_month;


-- ============================================
-- EJERCICIO 02 - PASO 2: LAST_VALUE con frame extendido
-- ============================================
-- Para capturar la peor venta (monto mínimo), se extiende explícitamente el marco de filas.
-- Evita el comportamiento limitante por defecto que restringe la evaluación hasta la fila actual.

SELECT
    sale_month,
    branch_id,
    amount,
    LAST_VALUE(amount) OVER (
        PARTITION BY branch_id
        ORDER BY amount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS branch_worst
FROM monthly_sales
ORDER BY branch_id, sale_month;


-- ============================================
-- EJERCICIO 02 - PASO 3: Alias de ventana con WINDOW
-- ============================================
-- Implementa la cláusula WINDOW para declarar el alias corporativo 'w' y evitar redundancias.
-- Ambas funciones de navegación comparten de manera óptima la misma partición y el mismo frame extendido.

SELECT
    sale_month,
    branch_id,
    amount,
    FIRST_VALUE(amount) OVER w AS branch_best,
    LAST_VALUE(amount)  OVER w AS branch_worst
FROM monthly_sales
WINDOW w AS (
    PARTITION BY branch_id
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY branch_id, sale_month;


-- ============================================
-- EJERCICIO 02 - PASO 4: CREATE VIEW y consulta a la vista
-- ============================================
-- Encapsula la consulta analítica en una vista persistente en el esquema de la heladería.
-- Permite consultar el análisis simplificando el uso de filtros WHERE en sucursales específicas.

CREATE OR REPLACE VIEW v_branch_sales_analysis AS
SELECT
    sale_month,
    branch_id,
    amount,
    FIRST_VALUE(amount) OVER w AS branch_best,
    LAST_VALUE(amount)  OVER w AS branch_worst
FROM monthly_sales
WINDOW w AS (
    PARTITION BY branch_id
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);

-- Consulta analítica ejecutada directo sobre la vista generada
SELECT 
    sale_month,
    branch_id,
    amount,
    branch_best,
    branch_worst
FROM v_branch_sales_analysis
WHERE branch_id = 1
ORDER BY sale_month;