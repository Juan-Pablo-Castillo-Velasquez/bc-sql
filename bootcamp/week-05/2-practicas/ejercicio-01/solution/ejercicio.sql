-- ============================================
-- Semana 05: Operadores — Ejercicio 01 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT first_name, salary
FROM   employees
WHERE  salary BETWEEN 60000 AND 75000;

-- PASO 2
SELECT first_name, salary
FROM   employees
WHERE  salary NOT BETWEEN 60000 AND 75000;

-- PASO 3
SELECT first_name, department_id
FROM   employees
WHERE  department_id IN (1, 3);

-- PASO 4
SELECT first_name, department_id
FROM   employees
WHERE  department_id NOT IN (2);
