-- ============================================
-- Semana 22: JSON y JSONB
-- Ejercicio 01 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Inspeccionar la columna JSONB
-- ============================================

SELECT
    id,
    name,
    attributes
FROM products;


-- ============================================
-- PASO 2: Acceso con -> y ->>
-- ============================================

SELECT
    name,
    attributes -> 'color'  AS color_jsonb,
    attributes ->> 'color' AS color_text
FROM products
WHERE attributes ? 'color';


-- ============================================
-- PASO 3: Filtrar por valor de campo
-- ============================================

SELECT id, name, category
FROM products
WHERE attributes ->> 'color' = 'silver';


-- ============================================
-- PASO 4: Acceso anidado con #>>
-- ============================================

SELECT
    name,
    attributes #>> '{sensor, megapixels}' AS megapixels,
    attributes #>> '{sensor, type}'       AS sensor_type
FROM products
WHERE attributes ? 'sensor';
