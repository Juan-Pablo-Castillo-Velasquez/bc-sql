-- ============================================
-- Semana 09: Producto — Consultas de Negocio Integradas
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería
-- Estilo: UPPERCASE para palabras clave, snake_case para columnas.
-- ============================================

-- 1. CONSULTA CON INNER JOIN (Criterio: Relación limpia entre 2 tablas)
-- Muestra el catálogo de helados activos junto a su respectiva categoría de sabor y precio.
SELECT 
    p.id          AS producto_id,
    p.name        AS helado,
    p.price       AS precio_unidad,
    f.name        AS tipo_sabor
FROM products p
INNER JOIN flavors f ON p.flavor_id = f.id
ORDER BY p.price DESC;


-- 2. CONSULTA CON LEFT JOIN + IS NULL (Criterio: Detección de huérfanos/vacíos)
-- Identifica de manera comercial cuáles sucursales físicas NO han registrado ninguna venta en el sistema.
SELECT 
    b.id          AS sucursal_id,
    b.name        AS sucursal_vacia,
    b.city        AS ciudad
FROM branches b
LEFT JOIN sales s ON s.branch_id = b.id
WHERE s.id IS NULL;


-- 3. CONSULTA MULTI-JOIN (Criterio: Relación de 3 tablas del dominio)
-- Reporte gerencial de facturación detallada por transacción, producto y punto de venta.
SELECT 
    s.id          AS nro_factura,
    b.name        AS punto_venta,
    p.name        AS producto_entregado,
    s.quantity    AS cantidad,
    p.price       AS precio_unitario,
    (s.quantity * p.price) AS total_recaudado
FROM sales s
INNER JOIN products p ON s.product_id = p.id
INNER JOIN branches b ON s.branch_id = b.id
ORDER BY s.id ASC;