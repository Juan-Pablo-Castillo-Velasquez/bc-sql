-- ============================================
-- Semana 21: Full-Text Search
-- Ejercicio 02 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Ranking con ts_rank()
-- ============================================

SELECT
    id,
    title,
    ts_rank(search_vector, query) AS rank
FROM articles,
     plainto_tsquery('spanish', 'índice consulta') AS query
WHERE search_vector @@ query
ORDER BY rank DESC;


-- ============================================
-- PASO 2: setweight — recalcular con pesos
-- ============================================

UPDATE articles
SET search_vector =
    setweight(to_tsvector('spanish', COALESCE(title, '')), 'A') ||
    setweight(to_tsvector('spanish', COALESCE(body,  '')), 'B');

-- Repetir búsqueda con pesos actualizados
SELECT
    id,
    title,
    ts_rank(search_vector, query) AS rank
FROM articles,
     plainto_tsquery('spanish', 'índice consulta') AS query
WHERE search_vector @@ query
ORDER BY rank DESC;


-- ============================================
-- PASO 3: ts_headline — resaltar fragmentos
-- ============================================

SELECT
    title,
    ts_headline(
        'spanish',
        body,
        plainto_tsquery('spanish', 'índice GIN'),
        'StartSel=[, StopSel=], MaxWords=25, MinWords=10'
    ) AS extracto
FROM articles
WHERE search_vector @@ plainto_tsquery('spanish', 'índice GIN');


-- ============================================
-- PASO 4: Búsqueda con frase (operador <->)
-- ============================================

-- 'base' seguida inmediatamente de 'dato'
SELECT id, title
FROM articles
WHERE search_vector @@
    to_tsquery('spanish', 'base <-> dato')
ORDER BY id;

-- 'índice' seguido de 'gin'
SELECT id, title
FROM articles
WHERE search_vector @@
    to_tsquery('spanish', 'índic <-> gin')
ORDER BY id;
