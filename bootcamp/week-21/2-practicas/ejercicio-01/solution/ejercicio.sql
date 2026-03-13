-- ============================================
-- Semana 21: Full-Text Search
-- Ejercicio 01 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Inspeccionar tsvector
-- ============================================

SELECT to_tsvector('spanish',
    'Las bases de datos relacionales permiten consultas SQL complejas');

SELECT to_tsvector('english',
    'Relational databases allow complex SQL queries');


-- ============================================
-- PASO 2: Agregar columna tsvector + índice GIN
-- ============================================

ALTER TABLE articles
ADD COLUMN search_vector TSVECTOR
    GENERATED ALWAYS AS (
        to_tsvector('spanish',
            COALESCE(title, '') || ' ' || COALESCE(body, ''))
    ) STORED;

CREATE INDEX idx_articles_search
    ON articles USING GIN (search_vector);

SELECT id, title, search_vector FROM articles LIMIT 2;


-- ============================================
-- PASO 3: Búsqueda básica con @@
-- ============================================

-- plainto_tsquery → AND implícito
SELECT id, title
FROM articles
WHERE search_vector @@ plainto_tsquery('spanish', 'base datos');

-- to_tsquery → operadores explícitos
SELECT id, title
FROM articles
WHERE search_vector @@ to_tsquery('spanish', 'base & datos');


-- ============================================
-- PASO 4: Operadores OR y NOT en tsquery
-- ============================================

SELECT id, title
FROM articles
WHERE search_vector @@
    to_tsquery('spanish', '(transacción | índice) & !trigger')
ORDER BY id;
