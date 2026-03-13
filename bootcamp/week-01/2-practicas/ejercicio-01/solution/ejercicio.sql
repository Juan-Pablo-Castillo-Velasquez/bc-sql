-- ============================================
-- Semana 01: Introducción a Bases de Datos Relacionales
-- Ejercicio 01 — SOLUCIÓN
-- ============================================

-- ============================================
-- PASO 2: Ver las tablas disponibles
-- ============================================

.tables

-- ============================================
-- PASO 3: Ver la estructura de una tabla
-- ============================================

PRAGMA table_info(products);
PRAGMA table_info(categories);

-- ============================================
-- PASO 4: Ver todos los registros de una tabla
-- ============================================

SELECT id, name, price, category_id
FROM   products;

-- ============================================
-- PASO 5: Contar registros
-- ============================================

SELECT COUNT(*) AS total_products
FROM   products;
