-- ============================================
-- Semana 11: Subqueries
-- Ejercicio 01 — SOLUCIÓN (Juan Pablo Castillo)
-- ============================================

-- ============================================
-- PASO 1: Subquery escalar en WHERE
-- ============================================
-- Empleados cuyo sueldo se encuentra por encima del promedio general de la empresa
SELECT
    e.first_name,
    e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(emp_inner.salary) FROM employees emp_inner)
ORDER BY e.salary DESC;


-- ============================================
-- PASO 2: Subquery escalar en SELECT
-- ============================================
-- Cada fila muestra los datos del empleado junto al promedio global de la compañía
SELECT
    e.first_name,
    e.salary,
    ROUND((SELECT AVG(emp_inner.salary) FROM employees emp_inner), 2) AS company_avg
FROM employees e
ORDER BY e.salary DESC;


-- ============================================
-- PASO 3: Filtrar con IN
-- ============================================
-- Obtener los empleados asignados a departamentos que se encuentren en estado activo (is_active = 1)
SELECT
    e.first_name,
    e.department_id
FROM employees e
WHERE e.department_id IN (
    SELECT d.id
    FROM departments d
    WHERE d.is_active = 1
);


-- ============================================
-- PASO 4: NOT IN con protección NULL
-- ============================================
-- Empleados en departamentos cuyo presupuesto NO es mayor a 100,000, protegiendo contra valores NULL
SELECT e.first_name
FROM employees e
WHERE e.department_id NOT IN (
    SELECT d.id
    FROM departments d
    WHERE d.budget > 100000
      AND d.id IS NOT NULL
);