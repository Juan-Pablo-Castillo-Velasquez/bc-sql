-- ============================================
-- Semana 22: JSON y JSONB
-- Ejercicio 02 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Índice GIN y contención @>
-- ============================================

CREATE INDEX idx_products_attrs ON products USING GIN (attributes);

EXPLAIN SELECT name
FROM products
WHERE attributes @> '{"color": "silver"}';

SELECT name, category
FROM products
WHERE attributes @> '{"color": "silver"}';


-- ============================================
-- PASO 2: Modificar documentos con jsonb_set
-- ============================================

UPDATE products
SET attributes = jsonb_set(attributes, '{warranty_years}', '2', TRUE)
WHERE attributes ? 'ram_gb';

SELECT name, attributes ->> 'warranty_years' AS garantia
FROM products
WHERE attributes ? 'warranty_years';


-- ============================================
-- PASO 3: jsonb_build_object y jsonb_agg
-- ============================================

SELECT
    category,
    jsonb_agg(
        jsonb_build_object(
            'id',    id,
            'name',  name,
            'color', attributes ->> 'color'
        )
    ) AS products_json
FROM products
GROUP BY category
ORDER BY category;


-- ============================================
-- PASO 4: Eliminar claves con -
-- ============================================

UPDATE products
SET attributes = attributes - 'brand'
WHERE attributes ? 'brand';

SELECT name, attributes
FROM products
WHERE name LIKE 'Laptop%';
