-- ============================================
-- Semana 15: Window Functions Navegación — Ejercicio 02
-- Ejecuta primero: setup.sql
-- Motor: PostgreSQL 16
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- ============================================

-- ============================================
-- PASO 1: FIRST_VALUE por sucursal
-- ============================================
-- El mayor monto de venta de cada sucursal (branch_id) se proyecta en todas sus filas.
-- FIRST_VALUE ordena por amount DESC → el primer registro de la ventana será la venta más alta.

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
-- PASO 2: LAST_VALUE con frame extendido
-- ============================================
-- Sin ROWS BETWEEN ... UNBOUNDED FOLLOWING, la función LAST_VALUE devuelve por defecto el valor 
-- de la FILA ACTUAL en lugar de la última del grupo debido al comportamiento del marco analítico.

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
-- PASO 3: Alias de ventana con WINDOW
-- ============================================
-- Definir la cláusula WINDOW w AS (...) evita repetir la misma especificación una y otra vez.
-- Tanto FIRST_VALUE como LAST_VALUE se ejecutan compartiendo la optimización de la ventana "w".

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
-- PASO 4: CREATE VIEW y consulta a la vista
-- ============================================
-- Almacena de manera lógica la query analítica como una vista reutilizable en la base de datos.
-- Permite aislar y consumir el reporte de la heladería como si fuera una tabla física.

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

-- Ejecución directa aplicando filtros específicos sobre la vista de la heladería
SELECT 
    sale_month,
    branch_id,
    amount,
    branch_best,
    branch_worst
FROM v_branch_sales_analysis
WHERE branch_id = 1
ORDER BY sale_month;