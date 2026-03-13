-- ============================================
-- Semana 03: DML — Ejercicio 02 — SOLUCIÓN
-- ============================================

-- ============================================
-- PASO 1: Actualizar el salario de un empleado
-- ============================================

UPDATE employees
SET    salary = 70000.00
WHERE  id = 2;

SELECT id, first_name, salary FROM employees WHERE id = 2;


-- ============================================
-- PASO 2: Actualizar múltiples columnas
-- ============================================

UPDATE employees
SET    salary    = 62000.00,
       last_name = 'Clark'
WHERE  id = 3;

SELECT id, first_name, last_name, salary FROM employees WHERE id = 3;


-- ============================================
-- PASO 3: Actualizar varias filas con condición
-- ============================================

UPDATE employees
SET    salary = salary * 1.10
WHERE  department_id = 1;

SELECT id, first_name, salary, department_id FROM employees
WHERE  department_id = 1;


-- ============================================
-- PASO 4: DELETE seguro
-- ============================================

SELECT id, first_name, email FROM employees WHERE department_id = 3;

DELETE FROM employees
WHERE  department_id = 3;


-- ============================================
-- PASO 5: Estado final
-- ============================================

SELECT * FROM employees ORDER BY id;
