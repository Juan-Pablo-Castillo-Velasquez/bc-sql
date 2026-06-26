-- ============================================================
-- Ejercicio 02 — GROUP BY y HAVING
-- Semana 06 | Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería (flavors, products, sales, branches)
-- ============================================================
-- Nota: ejecutar primero ejercicio-01.sql para tener los datos
-- ============================================================

-- ============================================================
-- PARTE A: GROUP BY — agrupar y agregar por categoría
-- ============================================================

-- 1. Total de ingresos por sucursal
SELECT
    b.name                  AS sucursal,
    COUNT(s.id)             AS num_ventas,
    SUM(s.total)            AS ingresos_totales
FROM sales s
JOIN branches b ON s.branch_id = b.id
GROUP BY b.id, b.name
ORDER BY ingresos_totales DESC;

-- 2. Cantidad de productos vendidos por categoría
SELECT
    p.category                  AS categoria,
    SUM(s.quantity)             AS unidades_vendidas,
    ROUND(AVG(s.unit_price), 2) AS precio_promedio
FROM sales s
JOIN products p ON s.product_id = p.id
GROUP BY p.category
ORDER BY unidades_vendidas DESC;

-- 3. Ventas por sabor (cuánto se vende cada sabor)
SELECT
    f.name              AS sabor,
    COUNT(s.id)         AS num_transacciones,
    SUM(s.quantity)     AS unidades_vendidas,
    SUM(s.total)        AS ingresos
FROM sales s
JOIN products p  ON s.product_id = p.id
JOIN flavors  f  ON p.flavor_id  = f.id
GROUP BY f.id, f.name
ORDER BY ingresos DESC;

-- 4. Ventas por mes
SELECT
    SUBSTR(sale_date, 1, 7)  AS mes,        -- formato 'YYYY-MM'
    COUNT(*)                 AS transacciones,
    SUM(total)               AS ingresos_mes
FROM sales
GROUP BY SUBSTR(sale_date, 1, 7)
ORDER BY mes;

-- 5. Conteo de productos por categoría en el catálogo
SELECT
    category                    AS categoria,
    COUNT(*)                    AS num_productos,
    MIN(price)                  AS precio_minimo,
    MAX(price)                  AS precio_maximo
FROM products
GROUP BY category
ORDER BY num_productos DESC;

-- ============================================================
-- PARTE B: HAVING — filtrar grupos DESPUÉS de agregar
-- ============================================================

-- 6. Sucursales con ingresos totales mayores a $40,000
SELECT
    b.name          AS sucursal,
    SUM(s.total)    AS ingresos_totales
FROM sales s
JOIN branches b ON s.branch_id = b.id
GROUP BY b.id, b.name
HAVING SUM(s.total) > 40000
ORDER BY ingresos_totales DESC;

-- 7. Sabores que se han vendido en más de 2 transacciones
SELECT
    f.name          AS sabor,
    COUNT(s.id)     AS num_transacciones
FROM sales s
JOIN products p ON s.product_id = p.id
JOIN flavors  f ON p.flavor_id  = f.id
GROUP BY f.id, f.name
HAVING COUNT(s.id) > 2
ORDER BY num_transacciones DESC;

-- 8. Categorías cuyo promedio de precio unitario de venta supera $4,000
SELECT
    p.category                  AS categoria,
    ROUND(AVG(s.unit_price), 2) AS precio_promedio_venta
FROM sales s
JOIN products p ON s.product_id = p.id
GROUP BY p.category
HAVING AVG(s.unit_price) > 4000;

-- 9. Meses con más de 5 transacciones registradas
SELECT
    SUBSTR(sale_date, 1, 7)  AS mes,
    COUNT(*)                 AS transacciones
FROM sales
GROUP BY SUBSTR(sale_date, 1, 7)
HAVING COUNT(*) > 5
ORDER BY mes;

-- 10. WHERE + GROUP BY + HAVING combinados
--     Ventas de febrero, agrupadas por sucursal,
--     mostrando solo las que superaron $20,000 ese mes
SELECT
    b.name          AS sucursal,
    SUM(s.total)    AS ingresos_febrero
FROM sales s
JOIN branches b ON s.branch_id = b.id
WHERE s.sale_date BETWEEN '2024-02-01' AND '2024-02-29'  -- WHERE filtra filas
GROUP BY b.id, b.name
HAVING SUM(s.total) > 20000                              -- HAVING filtra grupos
ORDER BY ingresos_febrero DESC;