-- ============================================
-- Semana 08: Capstone — Ejercicio 01
-- DDL + DML integrado (3 tablas)
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería
-- ============================================

-- PASO 1: Activar FK + crear tabla branches
PRAGMA foreign_keys = ON;

CREATE TABLE branches (
    id      INTEGER PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,
    city    TEXT    NOT NULL DEFAULT 'Medellín',
    phone   TEXT,
    manager TEXT    DEFAULT 'Sin asignar'
);

-- PASO 2: Crear flavors con FK implícita (standalone)
CREATE TABLE flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,
    price       REAL    NOT NULL CHECK (price > 0),
    active      INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

-- PASO 3: Crear products con constraints y FK a flavors
CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    flavor_id    INTEGER NOT NULL
        REFERENCES flavors(id) ON DELETE RESTRICT,
    size         TEXT    NOT NULL CHECK (size IN ('Small', 'Medium', 'Large')),
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 100 CHECK (stock >= 0),
    discontinued INTEGER NOT NULL DEFAULT 0 CHECK (discontinued IN (0, 1))
);

-- PASO 4: Insertar datos y verificar
INSERT INTO branches (id, name, city, phone, manager) VALUES
    (1, 'Sucursal Centro',      'Medellín', '(4) 260-1234', 'Carlos Ruiz'),
    (2, 'Sucursal Norte',       'Medellín', NULL,            'Maria Gomez'),
    (3, 'Sucursal El Poblado',  'Medellín', '(4) 271-5678', NULL);

INSERT INTO flavors (id, name, description, price, active) VALUES
    (1, 'Vanilla',    'Vainilla clásica pura',        15000, 1),
    (2, 'Chocolate',  'Chocolate belga importado',     16000, 1),
    (3, 'Strawberry', 'Fresa natural',                 15500, 1),
    (4, 'Pistachio',  'Pistacho premium',              18000, 0),
    (5, 'Mint Chip',  'Menta con choco chips',         16500, 1),
    (6, 'Mango',      NULL,                            17000, 0);

INSERT INTO products (id, name, flavor_id, size, price, stock, discontinued) VALUES
    (1, 'Vanilla Scoop - Small',      1, 'Small',  8000, 50,  0),
    (2, 'Vanilla Scoop - Medium',     1, 'Medium', 12000, 100, 0),
    (3, 'Vanilla Scoop - Large',      1, 'Large',  15000, 80,  0),
    (4, 'Chocolate Scoop - Small',    2, 'Small',  9000,  60,  0),
    (5, 'Chocolate Scoop - Medium',   2, 'Medium', 13000, 90,  0),
    (6, 'Strawberry Scoop - Medium',  3, 'Medium', 12500, 0,   0),
    (7, 'Mint Chip - Large',          5, 'Large',  17500, 30,  0),
    (8, 'Pistachio Scoop - Small',    4, 'Small',  10000, 0,   1);

-- Verificar estructura
PRAGMA table_info(products);
SELECT COUNT(*) AS total_productos FROM products;
SELECT COUNT(*) AS total_sabores   FROM flavors;