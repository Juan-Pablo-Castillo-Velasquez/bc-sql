-- ============================================
-- Semana 05: Operadores — Ejercicio 02 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT first_name, email
FROM   employees
WHERE  first_name LIKE 'A%';

-- PASO 2
SELECT first_name, last_name
FROM   employees
WHERE  last_name LIKE '%i%';

-- PASO 3
SELECT first_name
FROM   employees
WHERE  first_name LIKE '_r%';

-- PASO 4
SELECT first_name, last_name, salary, department_id
FROM   employees
WHERE  department_id IN (1, 2)
  AND  salary BETWEEN 60000 AND 80000
  AND  last_name LIKE '%i%';
