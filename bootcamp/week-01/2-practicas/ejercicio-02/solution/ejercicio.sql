-- ============================================
-- Semana 01: Introducción a Bases de Datos Relacionales
-- Ejercicio 02 — SOLUCIÓN
-- ============================================

-- ============================================
-- PASO 2: SELECT con columnas específicas
-- ============================================

SELECT name, price
FROM   products;

-- ============================================
-- PASO 3: Filtrar con WHERE (numérico)
-- ============================================

SELECT name, price
FROM   products
WHERE  price <= 20;

-- ============================================
-- PASO 4: Filtrar por texto con LIKE
-- ============================================

SELECT name, price
FROM   products
WHERE  name LIKE 'S%';

-- ============================================
-- PASO 5: Ordenar con ORDER BY
-- ============================================

SELECT name, price
FROM   products
ORDER BY price DESC;

-- ============================================
-- PASO 6: Limitar resultados con LIMIT
-- ============================================

SELECT name, price
FROM   products
ORDER BY price DESC
LIMIT  3;
