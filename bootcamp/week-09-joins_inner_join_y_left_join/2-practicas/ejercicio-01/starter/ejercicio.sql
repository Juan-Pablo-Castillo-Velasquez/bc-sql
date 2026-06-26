-- ============================================
-- Semana 09: INNER JOIN — Heladería
-- Ejercicio 01 — SOLUCIÓN (Juan Pablo Castillo)
-- ============================================

-- PASO 1: INNER JOIN básico
-- Obtener los productos (helados) junto con el nombre de su sabor base
SELECT
    p.id    AS producto_id,
    p.name  AS helado_nombre,
    f.name  AS sabor_base
FROM products p
INNER JOIN flavors f ON p.flavor_id = f.id;


-- PASO 2: Columnas de ambas tablas + ORDER BY
-- Listar las ventas con el nombre del producto vendido y su precio ordenado de mayor cantidad a menor
SELECT
    s.id        AS venta_id,
    s.quantity  AS cantidad,
    p.name      AS producto_helado,
    p.price     AS precio_unitario
FROM sales s
INNER JOIN products p ON s.product_id = p.id
ORDER BY s.quantity DESC;


-- PASO 3: INNER JOIN + filtro WHERE
-- Filtrar solo las ventas de la sucursal llamada 'Centro'
SELECT
    s.id        AS venta_id,
    s.quantity  AS cantidad_vendida,
    b.name      AS sucursal
FROM sales s
INNER JOIN branches b ON s.branch_id = b.id
WHERE b.name = 'Centro';


-- PASO 4: JOIN de tres tablas
-- Historial completo de ventas: Qué helado se vendió, en qué sucursal y de qué ciudad
SELECT
    s.id    AS venta_id,
    p.name  AS helado,
    b.name  AS sucursal,
    b.city  AS ciudad
FROM sales s
INNER JOIN products p ON s.product_id = p.id
INNER JOIN branches b ON s.branch_id = b.id
ORDER BY b.city, b.name;