-- ============================================
-- Semana 06: Proyecto — Reporte de Heladería
-- Funciones de Agregación aplicadas a negocio
-- ============================================
-- Ejecuta primero los setups de ejercicio-01 y ejercicio-02

-- ============================================
-- REPORTE 1: Resumen General de Ventas
-- ============================================
SELECT
    COUNT(DISTINCT s.id) AS total_transacciones,
    COUNT(sd.id) AS items_vendidos,
    SUM(sd.subtotal) AS ingresos_totales,
    ROUND(AVG(sd.subtotal), 2) AS ticket_promedio,
    MIN(sd.subtotal) AS venta_minima,
    MAX(sd.subtotal) AS venta_maxima
FROM   sales_details sd
JOIN   sales s ON sd.sale_id = s.id;


-- ============================================
-- REPORTE 2: Desempeño por Sucursal
-- ============================================
SELECT
    b.name AS sucursal,
    b.city AS ciudad,
    COUNT(DISTINCT s.id) AS transacciones,
    COUNT(sd.id) AS items_vendidos,
    SUM(sd.subtotal) AS ingresos,
    ROUND(AVG(sd.subtotal), 2) AS promedio_por_item
FROM   sales_details sd
JOIN   sales s ON sd.sale_id = s.id
JOIN   branches b ON s.branch_id = b.id
GROUP BY s.branch_id, b.name, b.city
ORDER BY ingresos DESC;


-- ============================================
-- REPORTE 3: Ranking de Sabores por Popularidad
-- ============================================
SELECT
    f.name AS sabor,
    COUNT(sd.id) AS veces_vendido,
    SUM(sd.quantity) AS unidades_totales,
    SUM(sd.subtotal) AS ingresos_generado,
    ROUND(AVG(sd.subtotal), 2) AS ingreso_promedio_venta
FROM   sales_details sd
JOIN   products p ON sd.product_id = p.id
JOIN   flavors f ON p.flavor_id = f.id
GROUP BY f.id, f.name
ORDER BY ingresos_generado DESC;


-- ============================================
-- REPORTE 4: Análisis por Tamaño de Producto
-- ============================================
SELECT
    p.size AS tamaño,
    COUNT(sd.id) AS veces_vendido,
    SUM(sd.quantity) AS unidades_totales,
    ROUND(AVG(sd.subtotal), 2) AS precio_promedio_venta,
    SUM(sd.subtotal) AS ingresos_totales
FROM   sales_details sd
JOIN   products p ON sd.product_id = p.id
GROUP BY p.size
ORDER BY ingresos_totales DESC;


-- ============================================
-- REPORTE 5: Sabores Estrella
-- HAVING: Solo sabores con ingresos > 50.000
-- ============================================
SELECT
    f.name AS sabor,
    COUNT(sd.id) AS transacciones,
    SUM(sd.subtotal) AS ingresos_sabor
FROM   sales_details sd
JOIN   products p ON sd.product_id = p.id
JOIN   flavors f ON p.flavor_id = f.id
GROUP BY f.id, f.name
HAVING SUM(sd.subtotal) > 50000
ORDER BY ingresos_sabor DESC;