-- ============================================
-- Proyecto Semana 08: Capstone Etapa 0
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería (branches, flavors, products, sales, sales_details, reviews)
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- ESQUEMA COMPLETO CON CONSTRAINTS JUSTIFICADOS
-- ============================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS sales_details;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS flavors;
DROP TABLE IF EXISTS branches;

-- branches: NOT NULL en name/city porque toda sucursal debe identificarse.
-- phone y manager son NULL porque pueden estar pendientes de asignar.
CREATE TABLE branches (
    id      INTEGER PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,          -- nombre único obligatorio
    city    TEXT    NOT NULL,                 -- siempre pertenece a una ciudad
    phone   TEXT,                             -- nullable: puede no tener aún
    manager TEXT    DEFAULT 'Sin asignar'     -- nullable: puesto puede estar vacante
);

-- flavors: price con CHECK > 0 porque un sabor con precio 0 sería un error de datos.
-- description es NULL porque sabores nuevos pueden no tener descripción todavía.
CREATE TABLE flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,                         -- nullable: contenido opcional
    price       REAL    NOT NULL CHECK (price > 0),
    active      INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

-- products: FK a flavors con RESTRICT para no perder historial de ventas.
-- stock >= 0 con CHECK porque no puede haber inventario negativo.
CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    flavor_id    INTEGER NOT NULL
        REFERENCES flavors(id) ON DELETE RESTRICT,
    size         TEXT    NOT NULL CHECK (size IN ('Small', 'Medium', 'Large')),
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 100 CHECK (stock >= 0),
    discontinued INTEGER NOT NULL DEFAULT 0   CHECK (discontinued IN (0, 1))
);

-- sales: customer_name nullable porque se permiten compras anónimas.
-- discount entre 0 y 1 con CHECK (representa porcentaje: 0.1 = 10%).
CREATE TABLE sales (
    id            INTEGER PRIMARY KEY,
    date          DATE    NOT NULL,
    branch_id     INTEGER NOT NULL
        REFERENCES branches(id) ON DELETE RESTRICT,
    customer_name TEXT,                       -- nullable: compras anónimas
    discount      REAL    NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 1),
    notes         TEXT                        -- nullable: observaciones opcionales
);

-- sales_details: subtotal > 0 con CHECK porque una línea de venta siempre vale algo.
CREATE TABLE sales_details (
    id         INTEGER PRIMARY KEY,
    sale_id    INTEGER NOT NULL REFERENCES sales(id)    ON DELETE RESTRICT,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    subtotal   REAL    NOT NULL CHECK (subtotal > 0)
);

-- reviews: rating nullable porque el cliente puede dejar comentario sin nota y viceversa.
CREATE TABLE reviews (
    id      INTEGER PRIMARY KEY,
    sale_id INTEGER NOT NULL REFERENCES sales(id) ON DELETE RESTRICT,
    rating  INTEGER CHECK (rating >= 1 AND rating <= 5), -- nullable
    comment TEXT,                                         -- nullable
    date    DATE    NOT NULL
);

-- ============================================
-- DATOS
-- ============================================

INSERT INTO branches VALUES
    (1, 'Sucursal Centro',     'Medellín', '(4) 260-1234', 'Carlos Ruiz'),
    (2, 'Sucursal Norte',      'Medellín', NULL,            'Maria Gomez'),
    (3, 'Sucursal El Poblado', 'Medellín', '(4) 271-5678', NULL);

INSERT INTO flavors VALUES
    (1, 'Vanilla',    'Vainilla clásica pura',    15000, 1),
    (2, 'Chocolate',  'Chocolate belga importado', 16000, 1),
    (3, 'Strawberry', 'Fresa natural',             15500, 1),
    (4, 'Pistachio',  'Pistacho premium',          18000, 0),
    (5, 'Mint Chip',  'Menta con choco chips',     16500, 1),
    (6, 'Mango',      NULL,                        17000, 0);

INSERT INTO products VALUES
    (1, 'Vanilla Scoop - Small',     1, 'Small',  8000,  50,  0),
    (2, 'Vanilla Scoop - Medium',    1, 'Medium', 12000, 100, 0),
    (3, 'Vanilla Scoop - Large',     1, 'Large',  15000, 80,  0),
    (4, 'Chocolate Scoop - Small',   2, 'Small',  9000,  60,  0),
    (5, 'Chocolate Scoop - Medium',  2, 'Medium', 13000, 90,  0),
    (6, 'Strawberry Scoop - Medium', 3, 'Medium', 12500, 0,   0),
    (7, 'Mint Chip - Large',         5, 'Large',  17500, 30,  0),
    (8, 'Pistachio Scoop - Small',   4, 'Small',  10000, 0,   1);

INSERT INTO sales VALUES
    (1,  '2024-01-15', 1, 'Juan Perez',   0.00, NULL),
    (2,  '2024-01-16', 1, NULL,           0.05, 'Descuento promoción'),
    (3,  '2024-01-17', 2, 'Maria Lopez',  0.00, NULL),
    (4,  '2024-01-18', 2, NULL,           0.00, 'Compra corporativa'),
    (5,  '2024-01-19', 3, 'Carlos Munoz', 0.10, NULL),
    (6,  '2024-01-20', 1, NULL,           0.00, NULL),
    (7,  '2024-01-21', 2, 'Ana Garcia',   0.05, NULL),
    (8,  '2024-01-22', 3, NULL,           0.00, 'Cliente frecuente'),
    (9,  '2024-01-23', 1, 'Pedro Suarez', 0.00, NULL),
    (10, '2024-01-24', 2, NULL,           0.00, NULL);

INSERT INTO sales_details VALUES
    (1,  1, 1, 2, 16000), (2,  1, 4, 1, 9000),
    (3,  2, 2, 3, 36000), (4,  2, 7, 2, 35000),
    (5,  3, 3, 1, 15000), (6,  3, 5, 2, 26000),
    (7,  4, 5, 2, 26000), (8,  5, 1, 1, 8000),
    (9,  5, 5, 1, 13000), (10, 6, 2, 2, 24000),
    (11, 7, 7, 1, 17500), (12, 8, 4, 3, 27000),
    (13, 9, 3, 2, 25000), (14,10, 1, 4, 32000);

INSERT INTO reviews VALUES
    (1, 1, 5,    'Excelente sabor', '2024-01-16'),
    (2, 2, NULL, NULL,              '2024-01-17'),
    (3, 3, 4,    'Muy bueno',       '2024-01-18'),
    (4, 4, NULL, 'Falta vainilla',  '2024-01-19'),
    (5, 5, 5,    NULL,              '2024-01-20'),
    (6, 6, 3,    'Normal',          '2024-01-21'),
    (7, 7, NULL, NULL,              '2024-01-22'),
    (8, 8, 5,    'Me encantó',      '2024-01-23'),
    (9, 9, 4,    NULL,              '2024-01-24'),
    (10,10,NULL, NULL,              '2024-01-25');

-- ============================================
-- REPORTE 1: Resumen general de la heladería
-- (DDL + DML + 5 funciones de agregación)
-- ============================================
SELECT
    COUNT(*)                    AS total_transacciones,
    SUM(sd.subtotal)            AS ingresos_totales,
    ROUND(AVG(sd.subtotal), 2)  AS ticket_promedio,
    MIN(sd.subtotal)            AS venta_minima,
    MAX(sd.subtotal)            AS venta_maxima
FROM sales_details sd;

-- ============================================
-- REPORTE 2: Ingresos por sucursal — GROUP BY
-- ============================================
SELECT
    b.name                                      AS sucursal,
    COALESCE(b.manager, 'Sin asignar')          AS gerente,
    COUNT(DISTINCT s.id)                        AS num_ventas,
    SUM(sd.subtotal)                            AS ingresos_totales
FROM branches b
JOIN sales         s  ON s.branch_id  = b.id
JOIN sales_details sd ON sd.sale_id   = s.id
GROUP BY b.id, b.name, b.manager
ORDER BY ingresos_totales DESC;

-- ============================================
-- REPORTE 3: Sabores rentables — GROUP BY + HAVING
-- Solo sabores que superaron $30,000 en ingresos
-- ============================================
SELECT
    f.name                                      AS sabor,
    COALESCE(f.description, 'Sin descripción')  AS descripcion,
    SUM(sd.subtotal)                            AS ingresos,
    SUM(sd.quantity)                            AS unidades_vendidas
FROM flavors f
JOIN products      p  ON p.flavor_id  = f.id
JOIN sales_details sd ON sd.product_id = p.id
GROUP BY f.id, f.name, f.description
HAVING SUM(sd.subtotal) > 30000
ORDER BY ingresos DESC;

-- ============================================
-- REPORTE 4: Ventas anónimas — IS NULL
-- ============================================
SELECT
    s.id                                        AS venta_id,
    s.date                                      AS fecha,
    b.name                                      AS sucursal,
    SUM(sd.subtotal)                            AS total_venta
FROM sales s
JOIN branches      b  ON b.id        = s.branch_id
JOIN sales_details sd ON sd.sale_id  = s.id
WHERE s.customer_name IS NULL
GROUP BY s.id, s.date, b.name
ORDER BY s.date;

-- ============================================
-- REPORTE 5: Rating promedio por sucursal — NULLIF + COALESCE
-- ============================================
SELECT
    b.name                                      AS sucursal,
    COUNT(r.rating)                             AS resenas_con_nota,
    ROUND(AVG(NULLIF(r.rating, 0)), 2)          AS rating_promedio
FROM branches b
LEFT JOIN sales    s ON s.branch_id = b.id
LEFT JOIN reviews  r ON r.sale_id   = s.id
GROUP BY b.id, b.name
ORDER BY rating_promedio DESC;

-- ============================================
-- REPORTE 6: WHERE + GROUP BY + HAVING
-- Sucursales con más de $40,000 en enero 2024
-- ============================================
SELECT
    b.name                                      AS sucursal,
    SUM(sd.subtotal)                            AS ingresos_enero
FROM sales s
JOIN branches      b  ON b.id        = s.branch_id
JOIN sales_details sd ON sd.sale_id  = s.id
WHERE s.date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY b.id, b.name
HAVING SUM(sd.subtotal) > 40000
ORDER BY ingresos_enero DESC;