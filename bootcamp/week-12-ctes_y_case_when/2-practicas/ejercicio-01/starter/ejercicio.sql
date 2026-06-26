-- ============================================
-- Semana 12: CTEs y CASE WHEN — Ejercicio 01 y 02
-- Solución oficial de Práctica — Juan Pablo Castillo
-- ============================================

-- ============================================
-- PASO 1: CTE simple — empleados activos
-- ============================================
WITH activos AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        salary,
        department_id
    FROM employees
    WHERE is_active = 1
)
SELECT first_name, last_name, salary
FROM activos
ORDER BY salary DESC;


-- ============================================
-- PASO 2: CTE con JOIN en la consulta principal
-- ============================================
WITH activos AS (
    SELECT employee_id, first_name, salary, department_id
    FROM employees
    WHERE is_active = 1
)
SELECT
    a.first_name,
    d.name AS department_name,
    a.salary
FROM activos a
INNER JOIN departments d ON a.department_id = d.id
ORDER BY d.name, a.salary DESC;


-- ============================================
-- PASO 3: Dos CTEs encadenados
-- ============================================
WITH promedios AS (
    SELECT
        department_id,
        AVG(salary) AS avg_sal
    FROM employees
    WHERE is_active = 1
    GROUP BY department_id
),
deptos_premium AS (
    SELECT department_id
    FROM promedios
    WHERE avg_sal > 55000
)
SELECT
    e.first_name,
    e.salary
FROM employees e
WHERE e.department_id IN (SELECT department_id FROM deptos_premium)
ORDER BY e.salary DESC;


-- ============================================
-- PASO 4: CTE que resume, consulta que filtra
-- ============================================
WITH resumen_depto AS (
    SELECT
        d.name   AS department_name,
        COUNT(e.employee_id) AS total_employees,
        ROUND(AVG(e.salary), 2) AS avg_salary
    FROM departments d
    LEFT JOIN employees e ON e.department_id = d.id
    GROUP BY d.id, d.name
)
SELECT department_name, total_employees, avg_salary
FROM resumen_depto
WHERE total_employees >= 2
ORDER BY avg_salary DESC;


-- ============================================
-- EJERCICIO 02: PASO 1 al 4 REUNIDOS
-- ============================================

-- REPORTE GENERAL CON BANDAS SALARIALES Y CORTOS DE DEPTO
SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary >= 70000 THEN 'Alto'
        WHEN salary >= 50000 THEN 'Medio'
        ELSE                      'Bajo'
    END AS salary_band
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;

-- CONTÉO CONDICIONAL POR GRUPOS DE DEPARTAMENTO
SELECT
    department_id,
    COUNT(*) AS total,
    COUNT(CASE WHEN salary >= 70000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN salary BETWEEN 50000 AND 69999 THEN 1 END) AS mid_earners,
    COUNT(CASE WHEN salary < 50000 THEN 1 END) AS low_earners
FROM employees
WHERE is_active = 1
GROUP BY department_id
ORDER BY department_id;