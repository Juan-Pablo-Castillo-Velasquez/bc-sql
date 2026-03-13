-- ============================================
-- Semana 06: Agregación — Ejercicio 02 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT
    department_id,
    COUNT(*) AS total
FROM   employees
GROUP BY department_id
ORDER BY total DESC;

-- PASO 2
SELECT
    department_id,
    COUNT(*)               AS total,
    ROUND(AVG(salary), 2)  AS promedio,
    SUM(salary)            AS masa_salarial
FROM   employees
GROUP BY department_id;

-- PASO 3
SELECT department_id, COUNT(*) AS total
FROM   employees
GROUP BY department_id
HAVING COUNT(*) > 1;

-- PASO 4
SELECT
    department_id,
    ROUND(AVG(salary), 2) AS promedio
FROM   employees
WHERE  salary > 55000
GROUP BY department_id
HAVING AVG(salary) > 65000
ORDER BY promedio DESC;
