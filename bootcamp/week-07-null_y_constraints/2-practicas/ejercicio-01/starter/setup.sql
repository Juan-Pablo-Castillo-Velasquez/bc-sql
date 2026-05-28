-- ============================================
-- Semana 07: NULL y Constraints — Setup
-- Dominio: Heladería
-- ============================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS sales_details;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS flavors;
DROP TABLE IF EXISTS branches;

-- Tabla: Sucursales
CREATE TABLE branches (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    location    TEXT    NOT NULL,
    city        TEXT    NOT NULL,
    phone       TEXT,
    manager     TEXT    DEFAULT 'Sin asignar'
);

-- Tabla: Sabores
CREATE TABLE flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,
    price       REAL    NOT NULL CHECK (price > 0),
    active      INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

-- Tabla: Productos
CREATE TABLE products (
    id        INTEGER PRIMARY KEY,
    name      TEXT    NOT NULL,
    flavor_id INTEGER NOT NULL REFERENCES flavors(id),
    size      TEXT    NOT NULL CHECK (size IN ('Small', 'Medium', 'Large')),
    price     REAL    NOT NULL CHECK (price > 0),
    stock     INTEGER NOT NULL DEFAULT 100 CHECK (stock >= 0),
    discontinued INTEGER NOT NULL DEFAULT 0 CHECK (discontinued IN (0, 1))
);

-- Tabla: Ventas
CREATE TABLE sales (
    id          INTEGER PRIMARY KEY,
    date        DATE    NOT NULL,
    branch_id   INTEGER NOT NULL REFERENCES branches(id),
    customer_name TEXT,
    discount    REAL    NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 1),
    notes       TEXT
);

-- Tabla: Detalles de Ventas
CREATE TABLE sales_details (
    id         INTEGER PRIMARY KEY,
    sale_id    INTEGER NOT NULL REFERENCES sales(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    subtotal   REAL    NOT NULL CHECK (subtotal > 0)
);

-- Tabla: Resenas
CREATE TABLE reviews (
    id          INTEGER PRIMARY KEY,
    sale_id     INTEGER NOT NULL REFERENCES sales(id),
    rating      INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment     TEXT,
    date        DATE    NOT NULL
);

INSERT INTO branches (id, name, location, city, phone, manager) VALUES
    (1, 'Sucursal Centro', 'Calle Principal 123', 'Medellin', '(4) 260-1234', 'Carlos Ruiz'),
    (2, 'Sucursal Norte', 'Avenida 80 #50-30', 'Medellin', NULL, 'Maria Gomez'),
    (3, 'Sucursal Sur', 'Cra 45 #25-80', 'Medellin', '(4) 271-5678', NULL);

INSERT INTO flavors (id, name, description, price, active) VALUES
    (1, 'Vanilla', 'Vainilla clasica pura', 15000.00, 1),
    (2, 'Chocolate', 'Chocolate belga importado', 16000.00, 1),
    (3, 'Strawberry', 'Fresa natural', 15500.00, 1),
    (4, 'Pistachio', 'Pistacho premium', 18000.00, 0),
    (5, 'Mint Chip', 'Menta con choco', 16500.00, 1),
    (6, 'Mango', NULL, 17000.00, 0);

INSERT INTO products (id, name, flavor_id, size, price, stock, discontinued) VALUES
    (1, 'Vanilla Scoop - Small', 1, 'Small', 8000.00, 50, 0),
    (2, 'Vanilla Scoop - Medium', 1, 'Medium', 12000.00, 100, 0),
    (3, 'Vanilla Scoop - Large', 1, 'Large', 15000.00, 80, 0),
    (4, 'Chocolate Scoop - Small', 2, 'Small', 9000.00, 60, 0),
    (5, 'Chocolate Scoop - Medium', 2, 'Medium', 13000.00, 90, 0),
    (6, 'Chocolate Scoop - Large', 2, 'Large', 16000.00, 70, 0),
    (7, 'Strawberry Scoop - Medium', 3, 'Medium', 12500.00, 0, 0),
    (8, 'Mint Chip - Large', 5, 'Large', 17500.00, 30, 0);

INSERT INTO sales (id, date, branch_id, customer_name, discount, notes) VALUES
    (1, '2024-01-15', 1, 'Juan Perez', 0.0, NULL),
    (2, '2024-01-16', 1, NULL, 0.05, 'Descuento por promocion'),
    (3, '2024-01-17', 2, 'Maria Lopez', 0.0, NULL),
    (4, '2024-01-18', 2, NULL, 0.0, 'Compra corporativa'),
    (5, '2024-01-19', 3, 'Carlos Munoz', 0.1, NULL),
    (6, '2024-01-20', 1, NULL, 0.0, NULL),
    (7, '2024-01-21', 2, 'Ana Garcia', 0.05, NULL),
    (8, '2024-01-22', 3, NULL, 0.0, 'Cliente frecuente'),
    (9, '2024-01-23', 1, 'Pedro Suarez', 0.0, NULL),
    (10, '2024-01-24', 2, NULL, 0.0, NULL);

INSERT INTO sales_details (id, sale_id, product_id, quantity, subtotal) VALUES
    (1, 1, 1, 2, 16000.00),
    (2, 1, 4, 1, 9000.00),
    (3, 2, 2, 3, 36000.00),
    (4, 2, 8, 2, 35000.00),
    (5, 3, 3, 1, 15000.00),
    (6, 3, 6, 2, 32000.00),
    (7, 4, 5, 2, 26000.00),
    (8, 5, 1, 1, 8000.00),
    (9, 5, 5, 1, 13000.00),
    (10, 6, 2, 2, 24000.00),
    (11, 7, 8, 1, 17500.00),
    (12, 8, 4, 3, 27000.00),
    (13, 9, 6, 2, 32000.00),
    (14, 10, 1, 4, 32000.00);

INSERT INTO reviews (id, sale_id, rating, comment, date) VALUES
    (1, 1, 5, 'Excelente sabor', '2024-01-16'),
    (2, 2, NULL, NULL, '2024-01-17'),
    (3, 3, 4, 'Muy bueno', '2024-01-18'),
    (4, 4, NULL, 'Falta vainilla', '2024-01-19'),
    (5, 5, 5, NULL, '2024-01-20'),
    (6, 6, 3, 'Normal', '2024-01-21'),
    (7, 7, NULL, NULL, '2024-01-22'),
    (8, 8, 5, 'Me encanto', '2024-01-23'),
    (9, 9, 4, NULL, '2024-01-24'),
    (10, 10, NULL, NULL, '2024-01-25');