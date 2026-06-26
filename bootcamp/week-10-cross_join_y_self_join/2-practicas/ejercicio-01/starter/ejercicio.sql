-- ============================================
-- Semana 10: CROSS JOIN — Heladería
-- Ejercicio 01 — SOLUCIÓN (Juan Pablo Castillo)
-- ============================================

-- PASO 1: CROSS JOIN básico
-- Generar la matriz completa de todas las sucursales con todos los sabores existentes
SELECT
    b.name  AS sucursal,
    f.name  AS sabor
FROM branches b
CROSS JOIN flavors f
ORDER BY b.name, f.name;


-- ============================================
-- PASO 2: Verificar el total de combinaciones
-- ============================================
-- Cuenta cuántas filas totales genera el producto cartesiano (filas de branches * filas de flavors)
SELECT COUNT(*) AS total_combinaciones
FROM branches b
CROSS JOIN flavors f;


-- ============================================
-- PASO 3: Filtrar con WHERE
-- ============================================
-- Mostrar la grilla de sabores disponibles mapeados únicamente para la sucursal 'Centro'
SELECT
    b.name  AS sucursal,
    f.name  AS sabor
FROM branches b
CROSS JOIN flavors f
WHERE b.name = 'Centro'
ORDER BY f.name;


-- ============================================
-- PASO 4: Grilla con costo/precio base estimado
-- ============================================
-- Generar la grilla de sucursales y sabores, proyectando una columna de control de negocio
SELECT
    b.name  AS sucursal,
    b.city  AS ciudad,
    f.name  AS sabor
FROM branches b
CROSS JOIN flavors f
ORDER BY b.name, f.name;