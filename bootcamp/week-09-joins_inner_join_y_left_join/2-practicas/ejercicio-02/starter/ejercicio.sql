-- ============================================
-- Semana 09: LEFT JOIN — Heladería
-- Ejercicio 02 — SOLUCIÓN (Juan Pablo Castillo)
-- ============================================

-- PASO 1: LEFT JOIN básico
-- Mostrar todos los sabores de la heladería, tengan o no un producto asignado actualmente
SELECT
    f.name  AS sabor_disponible,
    p.name  AS helado_asociado
FROM flavors f
LEFT JOIN products p ON p.flavor_id = f.id;


-- PASO 2: Detectar elementos huérfanos
-- Encontrar sabores creados en la base de datos que NO se están usando en ningún helado
SELECT
    f.name  AS sabor_sin_utilizar
FROM flavors f
LEFT JOIN products p ON p.flavor_id = f.id
WHERE p.id IS NULL;


-- PASO 3: Contar productos por cada sabor
-- Agrupar por sabor para saber cuántos helados lo usan (debe mostrar 0 si el sabor está vacío)
SELECT
    f.name      AS sabor,
    COUNT(p.id) AS total_productos
FROM flavors f
LEFT JOIN products p ON p.flavor_id = f.id
GROUP BY f.name
ORDER BY total_productos DESC;


-- PASO 4: LEFT JOIN tres tablas + filtro en ON
-- Mostrar todas las sucursales y contar cuántas ventas grandes (cantidad >= 5) han tenido
SELECT
    b.name      AS sucursal,
    b.city      AS ciudad,
    COUNT(s.id) AS ventas_mayores
FROM branches b
LEFT JOIN sales s ON s.branch_id = b.id AND s.quantity >= 5
LEFT JOIN products p ON s.product_id = p.id
GROUP BY b.name, b.city
ORDER BY ventas_mayores DESC;