-- ============================================
-- Semana 14: Window Functions — Ejercicio 02
-- Ejecuta primero: setup.sql
-- Motor: PostgreSQL 16
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- ============================================

-- ============================================
-- PASO 1: DENSE_RANK() por sucursal
-- ============================================
-- Clasifica los montos de ventas dentro de cada sucursal (branch_id).
-- Los empates comparten el mismo rango de venta sin saltarse posiciones.

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
-- PASO 2: El más alto por sucursal (top-1)
-- ============================================
-- Extrae la venta récord (posición #1) de cada sucursal.
-- Se usa la estructura CTE para poder filtrar por el alias 'branch_rank'.

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
SELECT 
    sale_id, 
    branch_id, 
    amount
FROM ranked
WHERE branch_rank = 1;


-- ============================================
-- PASO 3: Top-2 por sucursal
-- ============================================
-- Filtra usando '<= 2' para capturar los dos niveles de ingresos más altos por punto de venta.
-- Si hay empates en el segundo lugar, aparecerán todas las transacciones empatadas.

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
SELECT 
    sale_id, 
    branch_id, 
    amount, 
    branch_rank
FROM ranked
WHERE branch_rank <= 2
ORDER BY branch_id, branch_rank;


-- ============================================
-- PASO 4: Top-3 global de la heladería
-- ============================================
-- Al remover PARTITION BY, evaluamos de forma global el rendimiento de la empresa.
-- Retorna las transacciones que alcanzaron los 3 montos más altos en toda la cadena.

WITH global_ranked AS (
    SELECT
        id AS sale_id,
        amount,
        DENSE_RANK() OVER (ORDER BY amount DESC) AS company_rank
    FROM sales
)
SELECT 
    sale_id, 
    amount, 
    company_rank
FROM global_ranked
WHERE company_rank <= 3
ORDER BY company_rank;