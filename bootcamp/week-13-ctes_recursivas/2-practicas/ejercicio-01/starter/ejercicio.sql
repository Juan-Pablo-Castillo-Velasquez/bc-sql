-- ============================================
-- Semana 13: CTEs Recursivas — Ejercicios de Práctica 01 y 02
-- Motor: PostgreSQL 16
-- Estudiante: Juan Pablo Castillo
-- ============================================

-- ============================================
-- EJERCICIO 01 - PASO 1: Consulta simple — empleados y su manager
-- ============================================
SELECT
    e.employee_id,
    e.first_name,
    e.job_title,
    m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.manager_id NULLS FIRST;


-- ============================================
-- EJERCICIO 01 - PASO 2: CTE recursiva — profundidad y path
-- ============================================
WITH RECURSIVE org_chart AS (
    -- Caso base: CEO sin manager
    SELECT
        employee_id,
        first_name,
        manager_id,
        1            AS depth,
        first_name::TEXT   AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Caso recursivo: empleados cuyo manager ya está en el CTE
    SELECT
        e.employee_id,
        e.first_name,
        e.manager_id,
        oc.depth + 1,
        (oc.path || ' > ' || e.first_name)::TEXT AS path
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || first_name AS indented_name,
    path
FROM org_chart
ORDER BY path;


-- ============================================
-- EJERCICIO 01 - PASO 3: Filtrar por nivel de profundidad
-- ============================================
WITH RECURSIVE org_chart AS (
    SELECT
        employee_id,
        first_name,
        manager_id,
        1          AS depth,
        first_name::TEXT AS path
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT
        e.employee_id,
        e.first_name,
        e.manager_id,
        oc.depth + 1,
        (oc.path || ' > ' || e.first_name)::TEXT AS path
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT first_name, depth, path
FROM org_chart
WHERE depth = 3
ORDER BY path;


-- ============================================
-- EJERCICIO 01 - PASO 4: Subordinados de un empleado específico
-- ============================================
WITH RECURSIVE subordinados AS (
    SELECT employee_id, first_name, manager_id, 0 AS depth
    FROM employees
    WHERE first_name = 'Ana'
    UNION ALL
    SELECT e.employee_id, e.first_name, e.manager_id, s.depth + 1
    FROM employees e
    INNER JOIN subordinados s ON e.manager_id = s.employee_id
)
SELECT first_name, depth
FROM subordinados
ORDER BY depth, first_name;


-- ============================================
-- EJERCICIO 02 - PASO 1 al 4: Secuencias y Calendarios sin Actividad
-- ============================================

-- PASO 1: Serie numérica del 1 al 10
WITH RECURSIVE serie AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM serie
    WHERE n < 10
)
SELECT n FROM serie;

-- PASO 2 y 3: Calendario completo cruzado con Ventas Diarias usando LEFT JOIN
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

-- PASO 4: Alternativa óptima nativa de PostgreSQL usando generate_series()
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