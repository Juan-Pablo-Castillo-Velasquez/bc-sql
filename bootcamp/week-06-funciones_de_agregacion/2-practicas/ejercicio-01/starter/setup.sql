-- ============================================================
-- Proyecto Semanal — Heladería Flavors
-- Semana 06: Funciones de Agregación, GROUP BY y HAVING
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: flavors, products, sales, branches
-- ============================================================

-- ============================================================
-- ESQUEMA Y DATOS
-- ============================================================

CREATE TABLE IF NOT EXISTS flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    is_seasonal INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS products (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    flavor_id   INTEGER REFERENCES flavors(id),
    price       REAL    NOT NULL,
    category    TEXT    NOT NULL
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
    sale_date   TEXT    NOT NULL
);

INSERT OR IGNORE INTO flavors VALUES
    (1, 'Vainilla',    0), (2, 'Chocolate',   0),
    (3, 'Fresa',       0), (4, 'Mango',        1),
    (5, 'Maracuyá',    1), (6, 'Menta',        0);

INSERT OR IGNORE INTO products VALUES
    (1, 'Copa Vainilla',   1, 4500,  'copa'),
    (2, 'Copa Chocolate',  2, 4500,  'copa'),
    (3, 'Cono Fresa',      3, 3200,  'cono'),
    (4, 'Cono Mango',      4, 3500,  'cono'),
    (5, 'Paleta Maracuyá', 5, 2800,  'paleta'),
    (6, 'Paleta Menta',    6, 2800,  'paleta'),
    (7, 'Litro Vainilla',  1, 12000, 'litro'),
    (8, 'Litro Chocolate', 2, 12000, 'litro'),
    (9, 'Copa Menta',      6, 4800,  'copa'),
    (10,'Cono Vainilla',   1, 3200,  'cono');

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
    (14,10, 2, 9, 3200,  28800, '2024-02-08'),
    (15, 4, 3, 2, 3500,   7000, '2024-02-09');

-- ============================================================
-- REPORTE 1: Totales generales de la heladería
-- (mínimo 3 funciones de agregación — criterio de rúbrica)
-- ============================================================

SELECT
    COUNT(*)                    AS total_transacciones,
    SUM(total)                  AS ingresos_totales,
    ROUND(AVG(total), 2)        AS ticket_promedio,
    MIN(total)                  AS venta_minima,
    MAX(total)                  AS venta_maxima,
    SUM(quantity)               AS unidades_vendidas
FROM sales;

-- ============================================================
-- REPORTE 2: Rendimiento por sucursal
-- GROUP BY columna semánticamente relevante: branch_id / nombre
-- ============================================================

SELECT
    b.name                      AS sucursal,
    b.city                      AS ciudad,
    COUNT(s.id)                 AS num_ventas,
    SUM(s.quantity)             AS unidades_vendidas,
    SUM(s.total)                AS ingresos_totales,
    ROUND(AVG(s.total), 2)      AS ticket_promedio
FROM sales s
JOIN branches b ON s.branch_id = b.id
GROUP BY b.id, b.name, b.city
ORDER BY ingresos_totales DESC;

-- ============================================================
-- REPORTE 3: Sabores más rentables — solo los que superan
-- $20,000 en ingresos totales
-- HAVING con filtro de negocio sobre el grupo
-- ============================================================

SELECT
    f.name                      AS sabor,
    f.is_seasonal               AS es_temporada,
    COUNT(s.id)                 AS veces_vendido,
    SUM(s.quantity)             AS unidades_vendidas,
    SUM(s.total)                AS ingresos_sabor,
    ROUND(AVG(s.unit_price), 2) AS precio_promedio
FROM sales s
JOIN products p ON s.product_id = p.id
JOIN flavors  f ON p.flavor_id  = f.id
GROUP BY f.id, f.name, f.is_seasonal
HAVING SUM(s.total) > 20000         -- Solo sabores que generaron más de $20k
ORDER BY ingresos_sabor DESC;

-- ============================================================
-- REPORTE 4 (bonus): Sucursales con ticket promedio bajo
-- Identifica sucursales que podrían necesitar estrategia de upselling
-- HAVING: ticket promedio menor a $18,000
-- ============================================================

SELECT
    b.name                      AS sucursal,
    COUNT(s.id)                 AS num_ventas,
    ROUND(AVG(s.total), 2)      AS ticket_promedio
FROM sales s
JOIN branches b ON s.branch_id = b.id
GROUP BY b.id, b.name
HAVING AVG(s.total) < 18000
ORDER BY ticket_promedio ASC;