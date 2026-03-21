-- Semana 11: Subqueries
-- Solución Ejercicio 01

-- ============================================
-- PASO 1: Subquery escalar en WHERE
-- ============================================

SELECT
    first_name,
    salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;


-- ============================================
-- PASO 2: Subquery escalar en SELECT
-- ============================================

SELECT
    first_name,
    salary,
    ROUND((SELECT AVG(salary) FROM employees), 2) AS company_avg
FROM employees
ORDER BY salary DESC;


-- ============================================
-- PASO 3: Filtrar con IN
-- ============================================

SELECT
    first_name,
    department_id
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE is_active = 1
);


-- ============================================
-- PASO 4: NOT IN con protección NULL
-- ============================================

SELECT first_name
FROM employees
WHERE department_id NOT IN (
    SELECT id
    FROM departments
    WHERE budget > 100000
      AND id IS NOT NULL
);
