-- ============================================
-- PROYECTO SEMANAL: Subqueries en tu dominio
-- Semana 11 — Subqueries (Juan Pablo Castillo - 3228970A)
-- Dominio: Heladería (flavors, products, sales, branches)
-- ============================================

PRAGMA foreign_keys = ON;

-- Limpieza y reestructuración del dominio
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS flavors;
DROP TABLE IF EXISTS branches;

-- 1. TABLA: Sabores de helados
CREATE TABLE flavors (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL
);

-- 2. TABLA: Productos comerciales de heladería
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    flavor_id INTEGER NOT NULL REFERENCES flavors (id)
);

-- 3. TABLA: Sucursales físicas
CREATE TABLE branches (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    city TEXT NOT NULL
);

-- 4. TABLA: Transacciones de Ventas
CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products (id),
    branch_id INTEGER NOT NULL REFERENCES branches (id),
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- ============================================
-- INSERCIÓN DE DATOS DE PRUEBA REALISTAS
-- ============================================
INSERT INTO flavors (name, category) VALUES 
    ('Chocolate Suizo', 'Premium'),
    ('Vainilla Gourmet', 'Clásicos'),
    ('Frutos del Bosque', 'Frutales'),
    ('Arequipe Tentación', 'Premium'),
    ('Limón Herbáceo', 'Frutales'); -- Sabor sin productos (Para NOT EXISTS)

INSERT INTO products (name, price, flavor_id) VALUES 
    ('Cono Simple Chocolate', 4500.00, 1),
    ('Copa Suprema Chocolate', 8500.00, 1),
    ('Cono Clásico Vainilla', 3500.00, 2),
    ('Malteada Vainilla', 7000.00, 2),
    ('Vaso Frutos Rojos', 5000.00, 3),
    ('Barquillo Arequipe', 4000.00, 4);

INSERT INTO branches (name, city) VALUES 
    ('Centro', 'Bogótag'),
    ('Norte', 'Bogótag'),
    ('Unicentro', 'Cali');

INSERT INTO sales (product_id, branch_id, quantity) VALUES 
    (1, 1, 10), -- Cono Chocolate en Centro
    (2, 1, 5),  -- Copa Suprema en Centro
    (3, 2, 12), -- Cono Vainilla en Norte
    (5, 2, 2);  -- Vaso Frutos en Norte
    -- Nota: La sucursal 'Unicentro' no tiene ventas mapeadas para pruebas

-- ============================================
-- CONSULTA 1: Subquery escalar en WHERE
-- Objetivo: Encontrar los productos cuyo precio supera el promedio de su categoría de sabor
-- ============================================
SELECT
    p.name   AS helado,
    p.price  AS precio,
    f.category AS categoria
FROM products p
INNER JOIN flavors f ON p.flavor_id = f.id
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products p2
    INNER JOIN flavors f2 ON p2.flavor_id = f2.id
    WHERE f2.category = f.category
)
ORDER BY f.category, p.price DESC;


-- ============================================
-- CONSULTA 2: Subquery escalar en SELECT
-- Objetivo: Mostrar el catálogo con el precio promedio global de la heladería al lado
-- ============================================
SELECT
    p.name   AS helado,
    p.price  AS precio,
    ROUND((SELECT AVG(p_inner.price) FROM products p_inner), 2) AS promedio_global_helados
FROM products p
ORDER BY p.price DESC;


-- ============================================
-- CONSULTA 3: NOT EXISTS — Sabores sin uso comercial
-- Objetivo: Identificar qué sabores registrados de la heladería NO se están explotando en ningún producto
-- ============================================
SELECT
    f.name AS sabor_sin_actividad
FROM flavors f
WHERE NOT EXISTS (
    SELECT 1
    FROM products p
    WHERE p.flavor_id = f.id
);


-- ============================================
-- CONSULTA 4: Tabla derivada en FROM
-- Objetivo: Agrupar y filtrar qué sucursales han movido un volumen total de unidades vendidas superior a 10
-- ============================================
SELECT
    sucursal_stats.sucursal_nombre,
    sucursal_stats.unidades_totales
FROM (
    SELECT
        b.name        AS sucursal_nombre,
        SUM(s.quantity) AS unidades_totales
    FROM branches b
    LEFT JOIN sales s ON s.branch_id = b.id
    GROUP BY b.name
) AS sucursal_stats
WHERE sucursal_stats.unidades_totales > 10
ORDER BY sucursal_stats.unidades_totales DESC;