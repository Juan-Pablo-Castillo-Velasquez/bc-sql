-- ============================================
-- Semana 06: Agregación — Ejercicio 01 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT COUNT(*) AS total_empleados
FROM   employees;

-- PASO 2
SELECT
    SUM(salary) AS masa_salarial,
    AVG(salary) AS salario_promedio
FROM employees;

-- PASO 3
SELECT
    MIN(salary) AS salario_minimo,
    MAX(salary) AS salario_maximo
FROM employees;

-- PASO 4
SELECT AVG(salary) AS promedio_engineering
FROM   employees
WHERE  department_id = 1;
