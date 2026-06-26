-- ============================================================
-- Ejercicio 01 — Funciones de Agregación Básicas
-- Semana 06 | Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería (flavors, products, sales, branches)
-- ============================================================

-- Datos de prueba para el ejercicio
-- (Ejecutar primero para tener datos disponibles)

CREATE TABLE IF NOT EXISTS flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    is_seasonal INTEGER DEFAULT 0   -- 1 = sabor de temporada
);

CREATE TABLE IF NOT EXISTS products (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    flavor_id   INTEGER REFERENCES flavors(id),
    price       REAL    NOT NULL,
    category    TEXT    NOT NULL    -- 'copa', 'cono', 'paleta', 'litro'
);

CREATE TABLE IF NOT EXISTS branches (
    id      INTEGER PRIMARY KEY,
    city    TEXT NOT NULL,
    name    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sales (
    id          INTEGER PRIMARY KEY,
    product_id  INTEGER REFERENCES products(id),
    branch_id   INTEGER REFERENCES branches(id),
    quantity    INTEGER NOT NULL,
    unit_price  REAL    NOT NULL,
    total       REAL    NOT NULL,
    sale_date   TEXT    NOT NULL    -- 'YYYY-MM-DD'
);

INSERT OR IGNORE INTO flavors VALUES
    (1, 'Vainilla',    0),
    (2, 'Chocolate',   0),
    (3, 'Fresa',       0),
    (4, 'Mango',       1),
    (5, 'Maracuyá',    1),
    (6, 'Menta',       0);

INSERT OR IGNORE INTO products VALUES
    (1,  'Copa Vainilla',     1, 4500,  'copa'),
    (2,  'Copa Chocolate',    2, 4500,  'copa'),
    (3,  'Cono Fresa',        3, 3200,  'cono'),
    (4,  'Cono Mango',        4, 3500,  'cono'),
    (5,  'Paleta Maracuyá',   5, 2800,  'paleta'),
    (6,  'Paleta Menta',      6, 2800,  'paleta'),
    (7,  'Litro Vainilla',    1, 12000, 'litro'),
    (8,  'Litro Chocolate',   2, 12000, 'litro'),
    (9,  'Copa Menta',        6, 4800,  'copa'),
    (10, 'Cono Vainilla',     1, 3200,  'cono');

INSERT OR IGNORE INTO branches VALUES
    (1, 'Bogotá',   'Sucursal Centro'),
    (2, 'Bogotá',   'Sucursal Norte'),
    (3, 'Medellín', 'Sucursal El Poblado'),
    (4, 'Cali',     'Sucursal Chipichape');

INSERT OR IGNORE INTO sales VALUES
    (1,  1, 1, 3, 4500,  13500, '2024-01-05'),
    (2,  2, 1, 5, 4500,  22500, '2024-01-06'),
    (3,  3, 2, 8, 3200,  25600, '2024-01-07'),
    (4,  4, 2, 4, 3500,  14000, '2024-01-08'),
    (5,  5, 3, 6, 2800,  16800, '2024-01-09'),
    (6,  6, 3, 2, 2800,   5600, '2024-01-10'),
    (7,  7, 4, 1, 12000, 12000, '2024-01-11'),
    (8,  8, 4, 2, 12000, 24000, '2024-01-12'),
    (9,  1, 1, 7, 4500,  31500, '2024-02-03'),
    (10, 3, 2, 5, 3200,  16000, '2024-02-04'),
    (11, 9, 3, 3, 4800,  14400, '2024-02-05'),
    (12, 5, 1, 4, 2800,  11200, '2024-02-06'),
    (13, 2, 4, 6, 4500,  27000, '2024-02-07'),
    (14, 10,2, 9, 3200,  28800, '2024-02-08'),
    (15, 4, 3, 2, 3500,   7000, '2024-02-09');

-- ============================================================
-- PARTE A: COUNT, SUM, AVG, MIN, MAX sobre toda la tabla
-- ============================================================

-- 1. Total de registros de ventas en la tabla
SELECT COUNT(*) AS total_ventas
FROM sales;

-- 2. Total de ingresos (suma de todos los totales de venta)
SELECT SUM(total) AS ingresos_totales
FROM sales;

-- 3. Ticket promedio por venta
SELECT ROUND(AVG(total), 2) AS ticket_promedio
FROM sales;

-- 4. Venta más pequeña y venta más grande
SELECT
    MIN(total) AS venta_minima,
    MAX(total) AS venta_maxima
FROM sales;

-- 5. Precio mínimo, máximo y promedio de los productos
SELECT
    MIN(price)           AS precio_minimo,
    MAX(price)           AS precio_maximo,
    ROUND(AVG(price), 2) AS precio_promedio
FROM products;

-- 6. Total de unidades vendidas en toda la historia
SELECT SUM(quantity) AS unidades_totales
FROM sales;

-- ============================================================
-- PARTE B: Combinando con WHERE (filtrar ANTES de agregar)
-- ============================================================

-- 7. Total de ventas solo del mes de enero 2024
SELECT
    COUNT(*)    AS transacciones_enero,
    SUM(total)  AS ingresos_enero
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-01-31';

-- 8. Promedio de ventas solo en la sucursal de Bogotá Centro (branch_id = 1)
SELECT ROUND(AVG(total), 2) AS promedio_centro_bogota
FROM sales
WHERE branch_id = 1;

-- 9. Cantidad total de paletas vendidas (filtrar por category del producto)
SELECT SUM(s.quantity) AS paletas_vendidas
FROM sales s
JOIN products p ON s.product_id = p.id
WHERE p.category = 'paleta';

-- 10. Precio máximo entre los productos de tipo 'copa'
SELECT MAX(price) AS copa_mas_cara
FROM products
WHERE category = 'copa';