-- ============================================
-- Semana 06: Agregación — Ejercicio 01 — Setup
-- Dominio: Heladería
-- ============================================

DROP TABLE IF EXISTS sales_details;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS flavors;
DROP TABLE IF EXISTS branches;

-- Tablas base
CREATE TABLE branches (
    id       INTEGER PRIMARY KEY,
    name     TEXT    NOT NULL UNIQUE,
    location TEXT    NOT NULL,
    city     TEXT    NOT NULL
);

CREATE TABLE flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,
    price       REAL    NOT NULL CHECK (price > 0)
);

CREATE TABLE products (
    id        INTEGER PRIMARY KEY,
    name      TEXT    NOT NULL,
    flavor_id INTEGER NOT NULL REFERENCES flavors(id),
    size      TEXT    NOT NULL CHECK (size IN ('Small', 'Medium', 'Large')),
    price     REAL    NOT NULL CHECK (price > 0)
);

CREATE TABLE sales (
    id        INTEGER PRIMARY KEY,
    date      DATE    NOT NULL,
    branch_id INTEGER NOT NULL REFERENCES branches(id)
);

CREATE TABLE sales_details (
    id         INTEGER PRIMARY KEY,
    sale_id    INTEGER NOT NULL REFERENCES sales(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    subtotal   REAL    NOT NULL CHECK (subtotal > 0)
);

-- Datos de sucursales
INSERT INTO branches (id, name, location, city) VALUES
    (1, 'Sucursal Centro', 'Calle Principal 123', 'Medellín'),
    (2, 'Sucursal Norte', 'Avenida 80 #50-30', 'Medellín'),
    (3, 'Sucursal Sur', 'Cra 45 #25-80', 'Medellín');

-- Datos de sabores
INSERT INTO flavors (id, name, description, price) VALUES
    (1, 'Vanilla', 'Vainilla clásica', 15000.00),
    (2, 'Chocolate', 'Chocolate belga', 16000.00),
    (3, 'Strawberry', 'Fresa natural', 15500.00),
    (4, 'Pistachio', 'Pistacho premium', 18000.00),
    (5, 'Mint Chip', 'Menta con choco', 16500.00);

-- Datos de productos
INSERT INTO products (id, name, flavor_id, size, price) VALUES
    (1, 'Vanilla Scoop - Small', 1, 'Small', 8000.00),
    (2, 'Vanilla Scoop - Medium', 1, 'Medium', 12000.00),
    (3, 'Vanilla Scoop - Large', 1, 'Large', 15000.00),
    (4, 'Chocolate Scoop - Small', 2, 'Small', 9000.00),
    (5, 'Chocolate Scoop - Medium', 2, 'Medium', 13000.00),
    (6, 'Chocolate Scoop - Large', 2, 'Large', 16000.00),
    (7, 'Strawberry Scoop - Small', 3, 'Small', 8500.00),
    (8, 'Strawberry Scoop - Medium', 3, 'Medium', 12500.00),
    (9, 'Strawberry Scoop - Large', 3, 'Large', 15500.00),
    (10, 'Pistachio Scoop - Small', 4, 'Small', 10000.00),
    (11, 'Pistachio Scoop - Medium', 4, 'Medium', 14000.00),
    (12, 'Pistachio Scoop - Large', 4, 'Large', 18000.00);

-- Datos de ventas (10 ventas)
INSERT INTO sales (id, date, branch_id) VALUES
    (1, '2024-01-15', 1),
    (2, '2024-01-16', 1),
    (3, '2024-01-17', 2),
    (4, '2024-01-18', 2),
    (5, '2024-01-19', 3),
    (6, '2024-01-20', 1),
    (7, '2024-01-21', 2),
    (8, '2024-01-22', 3),
    (9, '2024-01-23', 1),
    (10, '2024-01-24', 2);

-- Datos de detalles de ventas
INSERT INTO sales_details (id, sale_id, product_id, quantity, subtotal) VALUES
    -- Sale 1
    (1, 1, 1, 2, 16000.00),
    (2, 1, 4, 1, 9000.00),
    -- Sale 2
    (3, 2, 2, 3, 36000.00),
    (4, 2, 8, 2, 25000.00),
    -- Sale 3
    (5, 3, 3, 1, 15000.00),
    (6, 3, 6, 2, 32000.00),
    -- Sale 4
    (7, 4, 5, 2, 26000.00),
    -- Sale 5
    (8, 5, 11, 1, 14000.00),
    (9, 5, 7, 3, 25500.00),
    -- Sale 6
    (10, 6, 2, 2, 24000.00),
    (11, 6, 5, 1, 13000.00),
    -- Sale 7
    (12, 7, 12, 1, 18000.00),
    (13, 7, 1, 4, 32000.00),
    -- Sale 8
    (14, 8, 9, 2, 31000.00),
    (15, 8, 4, 1, 9000.00),
    -- Sale 9
    (16, 9, 11, 2, 28000.00),
    (17, 9, 3, 1, 15000.00),
    -- Sale 10
    (18, 10, 6, 3, 48000.00),
    (19, 10, 8, 1, 12500.00);