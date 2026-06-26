-- ============================================
-- Semana 07: Constraints — Ejercicio 02
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería
-- ============================================
PRAGMA foreign_keys = ON;

-- PASO 1: Sabores sin descripción (NULL)
SELECT id, name
FROM   flavors
WHERE  description IS NULL;

-- PASO 2: Sabores activos con descripción completa
SELECT id, name, description
FROM   flavors
WHERE  active = 1
  AND  description IS NOT NULL;

-- PASO 3: COALESCE en description + NULLIF en rating
SELECT
    f.name                                      AS sabor,
    COALESCE(f.description, 'Sin descripción')  AS descripcion,
    r.rating,
    NULLIF(r.rating, 0)                         AS rating_valido
FROM flavors f
LEFT JOIN products  p  ON p.flavor_id = f.id
LEFT JOIN sales_details sd ON sd.product_id = p.id
LEFT JOIN reviews   r  ON r.sale_id = sd.sale_id;

-- PASO 4: Ventas sin nombre de cliente (anónimas)
SELECT id, date, branch_id, discount
FROM   sales
WHERE  customer_name IS NULL;

-- PASO 5: Reseñas sin calificación (rating IS NULL)
SELECT r.id, r.sale_id, r.comment, r.date
FROM   reviews r
WHERE  r.rating IS NULL;

-- PASO 6: PRAGMA foreign_keys — intentar insertar producto con flavor_id inválido
-- (debe fallar gracias al constraint)
INSERT INTO products (name, flavor_id, size, price)
VALUES ('Producto Fantasma', 999, 'Small', 5000);