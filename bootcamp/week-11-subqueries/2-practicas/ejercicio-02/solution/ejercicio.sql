-- Semana 11: Subqueries
-- Solución Ejercicio 02

-- ============================================
-- PASO 1: EXISTS — departamentos con empleados
-- ============================================

SELECT name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
);


-- ============================================
-- PASO 2: NOT EXISTS — departamentos sin empleados
-- ============================================

SELECT name AS department_sin_empleados
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
);


-- ============================================
-- PASO 3: Tabla derivada en FROM
-- ============================================

SELECT
    dept_stats.department,
    dept_stats.avg_salary
FROM (
    SELECT
        d.name        AS department,
        AVG(e.salary) AS avg_salary
    FROM employees   e
    INNER JOIN departments d ON e.department_id = d.id
    GROUP BY d.name
) AS dept_stats
WHERE dept_stats.avg_salary > 65000
ORDER BY dept_stats.avg_salary DESC;


-- ============================================
-- PASO 4: JOIN con tabla derivada
-- ============================================

SELECT
    e.first_name,
    e.salary,
    dept_avg.avg_salary AS dept_avg_salary
FROM employees e
INNER JOIN (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg ON e.department_id = dept_avg.department_id
ORDER BY e.salary DESC;
