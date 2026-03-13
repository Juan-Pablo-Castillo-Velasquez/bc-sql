-- ============================================
-- Semana 07: Constraints — Ejercicio 02 — SOLUCIÓN
-- ============================================

-- PASO 1
PRAGMA table_info(employees);

-- PASO 2
INSERT INTO employees
    (id, first_name, last_name, salary, level, department_id)
VALUES
    (10, 'Hugo', 'Reyes', 62000.00, 'mid', 2);

SELECT * FROM employees WHERE id = 10;

-- PASO 3
SELECT
    first_name,
    salary,
    COALESCE(bonus, 0)                               AS bonus,
    ROUND(
        COALESCE(bonus, 0) / NULLIF(salary, 0) * 100,
        2
    )                                                AS bonus_pct
FROM employees;

-- PASO 4
SELECT DISTINCT department_id
FROM   employees
WHERE  department_id NOT IN (SELECT id FROM departments);
