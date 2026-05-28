-- ============================================
-- Semana 06: Agregación — Ejercicio 02
-- GROUP BY y HAVING
-- Dominio: Heladería
-- ============================================
-- Ejecuta primero: ejercicio-01/starter/setup.sql
-- Luego: ejercicio-02/starter/setup.sql

-- ============================================
-- PASO 1: GROUP BY básico
-- ============================================
-- ¿Cuántas ventas y cuánto dinero generó cada sucursal?

SELECT
    b.name AS sucursal,
    COUNT(DISTINCT s.id) AS total_transacciones,
    SUM(sd.subtotal) AS ingresos_totales
FROM   sales_details sd
JOIN   sales s ON sd.sale_id = s.id
JOIN   branches b ON s.branch_id = b.id
GROUP BY s.branch_id, b.name
ORDER BY ingresos_totales DESC;


-- ============================================
-- PASO 2: GROUP BY con múltiples funciones
-- ============================================
-- Por cada sabor: cantidad vendida, ingreso total, ingreso promedio

SELECT
    f.name AS sabor,
    COUNT(sd.id) AS items_vendidos,
    ROUND(AVG(sd.subtotal), 2) AS promedio_por_item,
    SUM(sd.subtotal) AS ingresos_sabor
FROM   sales_details sd
JOIN   products p ON sd.product_id = p.id
JOIN   flavors f ON p.flavor_id = f.id
GROUP BY f.id, f.name
ORDER BY ingresos_sabor DESC;


-- ============================================
-- PASO 3: HAVING — filtrar grupos
-- ============================================
-- Solo mostrar sabores que generaron más de 40.000 en ingresos

SELECT
    f.name AS sabor,
    SUM(sd.subtotal) AS ingresos_sabor
FROM   sales_details sd
JOIN   products p ON sd.product_id = p.id
JOIN   flavors f ON p.flavor_id = f.id
GROUP BY f.id, f.name
HAVING SUM(sd.subtotal) > 40000
ORDER BY ingresos_sabor DESC;


-- ============================================
-- PASO 4: WHERE + GROUP BY + HAVING
-- ============================================
-- Solo productos de tamaño Medium, agrupar por sucursal
-- Mostrar solo sucursales que vendieron más de 50.000 en Medium

SELECT
    b.name AS sucursal,
    COUNT(sd.id) AS items_medium_vendidos,
    SUM(sd.subtotal) AS ingresos_medium
FROM   sales_details sd
JOIN   sales s ON sd.sale_id = s.id
JOIN   branches b ON s.branch_id = b.id
JOIN   products p ON sd.product_id = p.id
WHERE  p.size = 'Medium'
GROUP BY s.branch_id, b.name
HAVING SUM(sd.subtotal) > 50000
ORDER BY ingresos_medium DESC;