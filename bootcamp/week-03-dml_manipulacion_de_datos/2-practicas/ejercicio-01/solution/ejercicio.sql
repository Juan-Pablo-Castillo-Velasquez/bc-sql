-- ============================================
-- Semana 03: DML — Ejercicio 01 — SOLUCIÓN
-- ============================================

-- ============================================
-- PASO 1: Insertar un departamento
-- ============================================

INSERT INTO departments (id, name, location)
VALUES (1, 'Engineering', 'Floor 3');


-- ============================================
-- PASO 2: Insertar múltiples departamentos
-- ============================================

INSERT INTO departments (id, name, location)
VALUES
    (2, 'Marketing', 'Floor 1'),
    (3, 'Finance',   'Floor 2');


-- ============================================
-- PASO 3: Insertar empleados
-- ============================================

INSERT INTO employees (id, first_name, last_name, email, salary, department_id)
VALUES
    (1, 'Alice', 'Johnson', 'alice@company.com', 72000.00, 1),
    (2, 'Bob',   'Smith',   'bob@company.com',   65000.00, 1),
    (3, 'Carol', 'White',   'carol@company.com', 58000.00, 2),
    (4, 'Dan',   'Brown',   'dan@company.com',   81000.00, 3);


-- ============================================
-- PASO 4: Verificar los datos insertados
-- ============================================

SELECT * FROM departments;
SELECT * FROM employees;
