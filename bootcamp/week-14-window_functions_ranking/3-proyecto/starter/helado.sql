-- ============================================
-- PROYECTO SEMANAL: WINDOW FUNCTIONS (RANKING)
-- Semana 14 — Heladería Flavors
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- Motor: PostgreSQL 16
-- ============================================

DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS flavors CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

-- 1. CREACIÓN DE TABLAS DEL DOMINIO HELADERÍA
CREATE TABLE branches (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    presentation TEXT NOT NULL -- Cono, Vaso, Litro, Torta Helada
);

CREATE TABLE flavors (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL -- Frutales, Chocolates, Premium
);

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    branch_id INTEGER REFERENCES branches(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    flavor_id INTEGER REFERENCES flavors(id) ON DELETE CASCADE,
    amount NUMERIC(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

-- 2. INSERCIÓN DE DATOS DE SIMULACIÓN (CON EMPATES INTENCIONALES)
INSERT INTO branches (id, name, city) VALUES
    (1, 'Flavors Centro', 'Bogótal'),
    (2, 'Flavors Norte', 'Bogótal');

INSERT INTO products (id, presentation) VALUES
    (1, 'Cono Simple'),
    (2, 'Vaso Grande'),
    (3, 'Litro Familiar');

INSERT INTO flavors (id, name, category) VALUES
    (1, 'Chocolate Suizo', 'Chocolates'),
    (2, 'Maracuyá Crunch', 'Frutales'),
    (3, 'Arequipe Gourmet', 'Premium'),
    (4, 'Frutos del Bosque', 'Frutales');

INSERT INTO sales (branch_id, product_id, flavor_id, amount, sale_date) VALUES
    -- Ventas en Sucursal Centro
    (1, 1, 1, 4500.00, '2026-06-01'),
    (1, 2, 3, 4500.00, '2026-06-02'), -- Empate en recaudación para evaluar comportamiento
    (1, 3, 2, 3200.00, '2026-06-03'),
    -- Ventas en Sucursal Norte
    (2, 3, 3, 7800.00, '2026-06-01'),
    (2, 2, 1, 6500.00, '2026-06-04'),
    (2, 1, 2, 6500.00, '2026-06-05'), -- Empate en recaudación
    (2, 1, 4, 1900.00, '2026-06-12');


-- ============================================
-- ANALÍTICA 1: Comportamiento de Funciones de Ventana en Ventas
-- Propósito: Evaluar diferencias exactas entre ROW_NUMBER, RANK y DENSE_RANK 
-- cuando los montos de venta de helados empatan.
-- ============================================
SELECT 
    s.id AS sale_id,
    b.name AS branch_name,
    f.name AS flavor_name,
    s.amount,
    ROW_NUMBER() OVER (ORDER BY s.amount DESC) AS row_num_global,
    RANK()       OVER (ORDER BY s.amount DESC) AS rank_global,
    DENSE_RANK() OVER (ORDER BY s.amount DESC) AS dense_rank_global
FROM sales s
INNER JOIN branches b ON s.branch_id = b.id
INNER JOIN flavors f ON s.flavor_id = f.id
ORDER BY s.amount DESC;


-- ============================================
-- ANALÍTICA 2: Top 2 de Ventas Más Altas por Categoría de Sabor
-- Propósito: Obtener mediante una CTE los 2 mayores montos facturados 
-- para cada categoría de helado (cumpliendo el patrón Top-N por grupo).
-- ============================================
WITH ventas_clasificadas AS (
    SELECT 
        f.category AS flavor_category,
        f.name AS flavor_name,
        p.presentation,
        s.amount,
        DENSE_RANK() OVER (
            PARTITION BY f.category 
            ORDER BY s.amount DESC
        ) AS puesto_categoria
    FROM sales s
    INNER JOIN flavors f ON s.flavor_id = f.id
    INNER JOIN products p ON s.product_id = p.id
)
SELECT 
    flavor_category,
    puesto_categoria,
    flavor_name,
    presentation,
    amount
FROM ventas_clasificadas
WHERE puesto_categoria <= 2
ORDER BY flavor_category, puesto_categoria;