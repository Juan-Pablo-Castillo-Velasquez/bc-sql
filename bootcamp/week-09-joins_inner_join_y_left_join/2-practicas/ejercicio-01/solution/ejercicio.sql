-- Semana 09: INNER JOIN
-- Solución Ejercicio 01

-- ============================================
-- PASO 1: INNER JOIN básico
-- ============================================

SELECT
    e.first_name,
    e.last_name,
    d.name AS department
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;


-- ============================================
-- PASO 2: Columnas de ambas tablas + ORDER BY
-- ============================================

SELECT
    e.first_name,
    e.salary,
    d.name   AS department,
    d.budget
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
ORDER BY e.salary DESC;


-- ============================================
-- PASO 3: INNER JOIN + filtro WHERE
-- ============================================

SELECT
    e.first_name,
    e.last_name,
    e.level
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE d.name      = 'Engineering'
  AND e.is_active = 1;


-- ============================================
-- PASO 4: JOIN de tres tablas
-- ============================================

SELECT
    e.first_name,
    d.name  AS department,
    l.name  AS location,
    l.country
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
INNER JOIN locations   l ON d.location_id   = l.id
ORDER BY l.country, d.name;
