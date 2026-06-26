-- ============================================
-- Semana 13: CTEs Recursivas — Ejercicio 02
-- Ejecuta primero: setup.sql
-- Motor: PostgreSQL 16
-- Estudiante: Juan Pablo Castillo
-- ============================================

-- ============================================
-- PASO 1: Serie numérica del 1 al 10
-- ============================================
-- CTE recursiva que genera los números del 1 al 10 sin depender de una tabla física.
-- Caso base: n = 1
-- Caso recursivo: toma el valor anterior de 'n' e incrementa en 1, parando cuando alcanza el 10.

WITH RECURSIVE serie AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM serie
    WHERE n < 10
)
SELECT n FROM serie;


-- ============================================
-- PASO 2: Serie de fechas — primera semana
-- ============================================
-- Genera de forma dinámica los 7 días desde 2024-01-01 hasta 2024-01-07.
-- Usa INTERVAL '1 day' para sumar tiempo secuencialmente.

WITH RECURSIVE calendario AS (
    SELECT CAST('2024-01-01' AS DATE) AS dia
    UNION ALL
    SELECT (dia + INTERVAL '1 day')::DATE
    FROM calendario
    WHERE dia < '2024-01-07'
)
SELECT dia FROM calendario;


-- ============================================
-- PASO 3: Calendario con ventas — días sin actividad
-- ============================================
-- Une el calendario generado con la tabla 'daily_sales' usando un LEFT JOIN.
-- COALESCE garantiza que los días baches (sin ventas registradas) muestren 0 en lugar de NULL.

WITH RECURSIVE calendario AS (
    SELECT CAST('2024-01-01' AS DATE) AS dia
    UNION ALL
    SELECT (dia + INTERVAL '1 day')::DATE
    FROM calendario
    WHERE dia < '2024-01-07'
)
SELECT
    c.dia                      AS fecha,
    COALESCE(SUM(s.amount), 0) AS total_ventas,
    COALESCE(COUNT(s.id), 0)   AS num_transacciones
FROM calendario c
LEFT JOIN daily_sales s ON s.sale_date = c.dia
GROUP BY c.dia
ORDER BY c.dia;


-- ============================================
-- PASO 4: generate_series() — alternativa PostgreSQL
-- ============================================
-- Reemplaza por completo el CTE recursivo anterior usando la función nativa generate_series().
-- Esta opción es la mejor práctica en PostgreSQL para generar rangos debido a su alta eficiencia y claridad.

SELECT
    gs.dia::DATE               AS fecha,
    COALESCE(SUM(s.amount), 0) AS total_ventas
FROM generate_series(
    '2024-01-01'::DATE,
    '2024-01-07'::DATE,
    '1 day'::INTERVAL
) AS gs(dia)
LEFT JOIN daily_sales s ON s.sale_date = gs.dia::DATE
GROUP BY gs.dia
ORDER BY gs.dia;