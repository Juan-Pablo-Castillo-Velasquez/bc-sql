-- ============================================
-- Semana 06: Agregación — Ejercicio 01
-- COUNT, SUM, AVG, MIN, MAX
-- Dominio: Heladería
-- ============================================
-- Ejecuta primero: setup.sql

-- ============================================
-- PASO 1: COUNT — total de ventas
-- ============================================
-- ¿Cuántas ventas registramos en total?

SELECT COUNT(*) AS total_ventas
FROM   sales;


-- ============================================
-- PASO 2: SUM y AVG del monto de ventas
-- ============================================
-- ¿Cuánto dinero en total y promedio por venta?

SELECT
    SUM(subtotal) AS ingresos_totales,
    AVG(subtotal) AS ingreso_promedio_linea
FROM sales_details;


-- ============================================
-- PASO 3: MIN y MAX de precios de productos
-- ============================================
-- ¿Cuál es el producto más caro y más barato?

SELECT
    MIN(price) AS producto_mas_barato,
    MAX(price) AS producto_mas_caro
FROM products;


-- ============================================
-- PASO 4: Agregación con WHERE
-- ============================================
-- ¿Cuánto vendimos en la sucursal Centro (branch_id = 1)?

SELECT SUM(subtotal) AS ingresos_sucursal_centro
FROM   sales_details sd
JOIN   sales s ON sd.sale_id = s.id
WHERE  s.branch_id = 1;