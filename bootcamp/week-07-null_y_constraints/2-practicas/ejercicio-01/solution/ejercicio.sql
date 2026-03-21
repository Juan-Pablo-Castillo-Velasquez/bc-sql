-- ============================================
-- Semana 07: NULL — Ejercicio 01 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT id, first_name, email
FROM   employees
WHERE  email IS NULL;

-- PASO 2
SELECT id, first_name, email
FROM   employees
WHERE  email IS NOT NULL;

-- PASO 3
SELECT
    first_name,
    bonus,
    COALESCE(bonus, 0) AS bonus_efectivo
FROM employees;

-- PASO 4
SELECT
    COUNT(*)      AS total_empleados,
    COUNT(email)  AS con_email,
    COUNT(bonus)  AS con_bonus
FROM employees;
