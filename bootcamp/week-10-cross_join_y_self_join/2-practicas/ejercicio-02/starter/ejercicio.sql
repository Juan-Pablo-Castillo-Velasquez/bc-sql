-- ============================================
-- Semana 10: SELF JOIN — Heladería
-- Ejercicio 02 — SOLUCIÓN (Juan Pablo Castillo)
-- ============================================

-- PASO 1: SELF JOIN básico (INNER JOIN)
-- Sabores derivados junto con el nombre de su sabor base principal
SELECT
    f.name  AS sabor_derivado,
    b.name  AS sabor_base_principal
FROM flavors f
INNER JOIN flavors b ON f.parent_flavor_id = b.id;


-- PASO 2: Incluir sabores principales con LEFT JOIN + COALESCE
-- Listar todos los sabores; si no dependen de ninguno, marcar como 'Sabor Raíz'
SELECT
    f.name                                AS sabor,
    COALESCE(b.name, 'Sabor Principal')  AS categoria_padre
FROM flavors f
LEFT JOIN flavors b ON f.parent_flavor_id = b.id
ORDER BY categoria_padre, sabor;


-- PASO 3: Contar variaciones directas por sabor base
-- Muestra cuántos sabores derivados se crearon a partir de cada sabor base
SELECT
    b.name        AS sabor_base,
    COUNT(f.id)   AS total_variaciones
FROM flavors b
LEFT JOIN flavors f ON f.parent_flavor_id = b.id
GROUP BY b.id, b.name
HAVING COUNT(f.id) > 0
ORDER BY total_variaciones DESC;


-- PASO 4: Jerarquía de dos niveles
-- Encontrar la cadena completa: Sabor nieto -> Sabor hijo -> Sabor abuelo (Base)
SELECT
    f.name   AS sabor_especial,
    m.name   AS sabor_base_directo,
    gm.name  AS sabor_raiz_original
FROM flavors f
LEFT JOIN flavors m  ON f.parent_flavor_id = m.id
LEFT JOIN flavors gm ON m.parent_flavor_id = gm.id
ORDER BY gm.name, m.name, f.name;