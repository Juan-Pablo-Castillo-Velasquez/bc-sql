-- Semana 09: LEFT JOIN
-- Solución Ejercicio 02

-- ============================================
-- PASO 1: LEFT JOIN básico
-- ============================================

SELECT
    d.name       AS department,
    e.first_name AS employee
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id;


-- ============================================
-- PASO 2: Detectar departamentos huérfanos
-- ============================================

SELECT
    d.name AS department_sin_empleados
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
WHERE e.id IS NULL;


-- ============================================
-- PASO 3: Contar empleados por departamento
-- ============================================

SELECT
    d.name       AS department,
    COUNT(e.id)  AS total_employees
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.name
ORDER BY total_employees DESC;


-- ============================================
-- PASO 4: LEFT JOIN tres tablas + filtro en ON
-- ============================================

SELECT
    d.name       AS department,
    l.name       AS location,
    COUNT(e.id)  AS active_employees
FROM departments  d
LEFT JOIN locations  l ON d.location_id   = l.id
LEFT JOIN employees  e ON e.department_id  = d.id
                      AND e.is_active      = 1
GROUP BY d.name, l.name
ORDER BY active_employees DESC;
