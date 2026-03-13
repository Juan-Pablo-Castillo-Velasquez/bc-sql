-- Semana 10: SELF JOIN
-- Solución Ejercicio 02

-- ============================================
-- PASO 1: SELF JOIN básico (INNER JOIN)
-- ============================================

SELECT
    e.first_name  AS employee,
    m.first_name  AS manager
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id;


-- ============================================
-- PASO 2: Incluir al CEO con LEFT JOIN + COALESCE
-- ============================================

SELECT
    e.first_name                   AS employee,
    COALESCE(m.first_name, 'CEO')  AS manager
FROM employees  e
LEFT JOIN employees m ON e.manager_id = m.id
ORDER BY manager, employee;


-- ============================================
-- PASO 3: Contar reportes directos por manager
-- ============================================

SELECT
    m.first_name    AS manager,
    COUNT(e.id)     AS direct_reports
FROM employees  m
LEFT JOIN employees e ON e.manager_id = m.id
GROUP BY m.id, m.first_name
HAVING COUNT(e.id) > 0
ORDER BY direct_reports DESC;


-- ============================================
-- PASO 4: Jerarquía de dos niveles
-- ============================================

SELECT
    e.first_name   AS employee,
    m.first_name   AS manager,
    gm.first_name  AS grand_manager
FROM employees e
LEFT JOIN employees m  ON e.manager_id = m.id
LEFT JOIN employees gm ON m.manager_id = gm.id
ORDER BY gm.first_name, m.first_name, e.first_name;
