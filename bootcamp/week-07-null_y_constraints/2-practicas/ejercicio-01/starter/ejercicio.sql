-- ============================================
-- Semana 07: NULL y Constraints - Ejercicio 01
-- Manejo de NULL
-- Dominio: Heladeria
-- ============================================
-- Ejecuta primero: setup.sql

-- ============================================
-- PASO 1: IS NULL - Encontrar datos faltantes
-- ============================================

SELECT id, name, phone
FROM   branches
WHERE  phone IS NULL;


-- ============================================
-- PASO 2: IS NOT NULL - Datos completos
-- ============================================

SELECT id, sale_id, comment
FROM   reviews
WHERE  comment IS NOT NULL;


-- ============================================
-- PASO 3: COALESCE - Valor por defecto
-- ============================================

SELECT
    id,
    date,
    COALESCE(customer_name, 'Anonimo') AS cliente,
    notes
FROM   sales
ORDER BY date;


-- ============================================
-- PASO 4: NULLIF - Convertir a NULL condicionalmente
-- ============================================

SELECT
    id,
    customer_name,
    NULLIF(discount, 0) AS descuento_aplicado
FROM   sales
WHERE  NULLIF(discount, 0) IS NOT NULL;