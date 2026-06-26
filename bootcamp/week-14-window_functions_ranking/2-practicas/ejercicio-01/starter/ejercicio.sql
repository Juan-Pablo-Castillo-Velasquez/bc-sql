-- ============================================
-- Semana 14: Window Functions — Ejercicio 01 y 02 (Adaptado)
-- Motor: PostgreSQL 16
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- ============================================

-- ============================================
-- EJERCICIO 01 - PASO 1: ROW_NUMBER() global — sin PARTITION BY
-- ============================================
-- Numera todas las ventas de helados de mayor a menor monto recaudado globalmente.
-- row_num 1 = la venta de mayor valor en toda la cadena de heladerías.

SELECT
    id AS sale_id,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS global_rank
FROM sales
ORDER BY amount DESC;


-- ============================================
-- EJERCICIO 01 - PASO 2: ROW_NUMBER() con PARTITION BY
-- ============================================
-- La numeración se reinicia en 1 para cada sucursal (branch_id).
-- Ordena por monto de venta descendente dentro de cada punto físico.

SELECT
    id AS sale_id,
    branch_id,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY branch_id
        ORDER BY amount DESC
    ) AS branch_row_num
FROM sales
ORDER BY branch_id, amount DESC;


-- ============================================
-- EJERCICIO 01 - PASO 3: RANK() — compara con ROW_NUMBER()
-- ============================================
-- Si dos o más ventas de helados registran exactamente el mismo valor monetario, 
-- RANK() les asigna la misma posición y genera un salto posterior; ROW_NUMBER() las diferencia estrictamente.

SELECT
    id AS sale_id,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num,
    RANK()       OVER (ORDER BY amount DESC) AS rnk
FROM sales
ORDER BY amount DESC;


-- ============================================
-- EJERCICIO 01 - PASO 4: Las tres funciones en paralelo
-- ============================================
-- Observa detalladamente el comportamiento analítico en transacciones con montos idénticos:
-- ROW_NUMBER (secuencial) / RANK (repite rango y salta posiciones) / DENSE_RANK (repite rango continuo sin saltos)

SELECT
    id AS sale_id,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num,
    RANK()       OVER (ORDER BY amount DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rnk
FROM sales
ORDER BY amount DESC;


-- ============================================
-- EJERCICIO 02 - PASO 1: DENSE_RANK() por sucursal
-- ============================================
-- Clasifica los montos facturados dentro de cada sucursal.
-- Los empates comparten el mismo nivel sin saltarse posiciones analíticas.

SELECT
    id AS sale_id,
    branch_id,
    amount,
    DENSE_RANK() OVER (
        PARTITION BY branch_id
        ORDER BY amount DESC
    ) AS branch_rank
FROM sales
ORDER BY branch_id, amount DESC;


-- ============================================
-- EJERCICIO 02 - PASO 2: La venta más alta por sucursal (top-1)
-- ============================================
-- Evaluamos la transacción de mayor valor por punto de venta usando una CTE para poder filtrar.

WITH ranked AS (
    SELECT
        id AS sale_id,
        branch_id,
        amount,
        DENSE_RANK() OVER (
            PARTITION BY branch_id
            ORDER BY amount DESC
        ) AS branch_rank
    FROM sales
)
SELECT sale_id, branch_id, amount
FROM ranked
WHERE branch_rank = 1;


-- ============================================
-- EJERCICIO 02 - PASO 3: Top-2 de ventas por sucursal
-- ============================================
-- Extraemos los dos niveles de facturación más altos por cada heladería física.

WITH ranked AS (
    SELECT
        id AS sale_id,
        branch_id,
        amount,
        DENSE_RANK() OVER (
            PARTITION BY branch_id
            ORDER BY amount DESC
        ) AS branch_rank
    FROM sales
)
SELECT sale_id, branch_id, amount, branch_rank
FROM ranked
WHERE branch_rank <= 2
ORDER BY branch_id, branch_rank;


-- ============================================
-- EJERCICIO 02 - PASO 4: Top-3 global de facturación de la heladería
-- ============================================
-- Sin la cláusula PARTITION BY, el análisis extrae los 3 niveles de ingresos por ticket más altos de toda la empresa.

WITH global_ranked AS (
    SELECT
        id AS sale_id,
        amount,
        DENSE_RANK() OVER (ORDER BY amount DESC) AS company_rank
    FROM sales
)
SELECT sale_id, amount, company_rank
FROM global_ranked
WHERE company_rank <= 3
ORDER BY company_rank;