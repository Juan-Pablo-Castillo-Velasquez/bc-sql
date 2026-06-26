-- ============================================
-- Semana 10: Producto — Matriz y Relaciones Jerárquicas
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería
-- Estilo: UPPERCASE para palabras clave, snake_case para columnas.
-- ============================================

-- 1. CONSULTA CON CROSS JOIN (Criterio: Producto Cartesiano de Negocio)
-- Plan de auditoría completo: Genera una fila por cada combinación posible de Sucursal y Sabor.
SELECT 
    b.name  AS sucursal_auditar,
    b.city  AS ciudad,
    f.name  AS sabor_verificar
FROM branches b
CROSS JOIN flavors f
ORDER BY b.name, f.name;


-- 2. CONSULTA CON SELF JOIN + COALESCE (Criterio: Estructura Jerárquica del Dominio)
-- Clasificación comercial de los sabores de helado indicando su procedencia o si son fórmulas base.
SELECT 
    f.id                                  AS sabor_id,
    f.name                                AS sabor_comercial,
    COALESCE(p.name, 'Fórmula Maestra')   AS derivado_de_sabor
FROM flavors f
LEFT JOIN flavors p ON f.parent_flavor_id = p.id
ORDER BY derivado_de_sabor ASC, f.name ASC;


-- 3. CONSULTA COMPUESTA (Criterio: Reporte Operacional Avanzado)
-- Cuenta cuántas ventas se han hecho uniendo Sucursales, Productos y Sabores Jerárquicos.
SELECT 
    b.name        AS punto_venta,
    p.name        AS helado_vendido,
    COUNT(s.id)   AS transacciones_realizadas,
    SUM(s.quantity) AS unidades_totales
FROM sales s
INNER JOIN branches b ON s.branch_id = b.id
INNER JOIN products p ON s.product_id = p.id
INNER JOIN flavors f  ON p.flavor_id = f.id
GROUP BY b.name, p.name
ORDER BY unidades_totales DESC;