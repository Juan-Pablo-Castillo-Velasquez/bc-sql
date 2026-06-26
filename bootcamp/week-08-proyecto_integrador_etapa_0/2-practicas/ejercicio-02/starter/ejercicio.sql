-- ============================================
-- Semana 08: Capstone — Ejercicio 02
-- Reportes: SELECT + GROUP BY + HAVING + NULL
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería
-- ============================================
-- Ejecuta primero: ejercicio-01/starter/ejercicio.sql
-- ============================================
PRAGMA foreign_keys = ON;

-- Agregar tablas de ventas para los reportes
CREATE TABLE IF NOT EXISTS sales (
    id            INTEGER PRIMARY KEY,
    date          DATE    NOT NULL,
    branch_id     INTEGER NOT NULL REFERENCES branches(id),
    customer_name TEXT,
    discount      REAL    NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 1),
    notes         TEXT
);

CREATE TABLE IF NOT EXISTS sales_details (
    id         INTEGER PRIMARY KEY,
    sale_id    INTEGER NOT NULL REFERENCES sales(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    subtotal   REAL    NOT NULL CHECK (subtotal > 0)
);

INSERT INTO sales VALUES
    (1,  '2024-01-15', 1, 'Juan Perez',    0.00, NULL),
    (2,  '2024-01-16', 1, NULL,            0.05, 'Descuento promoción'),
    (3,  '2024-01-17', 2, 'Maria Lopez',   0.00, NULL),
    (4,  '2024-01-18', 2, NULL,            0.00, 'Compra corporativa'),
    (5,  '2024-01-19', 3, 'Carlos Munoz',  0.10, NULL),
    (6,  '2024-01-20', 1, NULL,            0.00, NULL),
    (7,  '2024-01-21', 2, 'Ana Garcia',    0.05, NULL),
    (8,  '2024-01-22', 3, NULL,            0.00, 'Cliente frecuente'),
    (9,  '2024-01-23', 1, 'Pedro Suarez',  0.00, NULL),
    (10, '2024-01-24', 2, NULL,            0.00, NULL);

INSERT INTO sales_details VALUES
    (1,  1, 1, 2, 16000),
    (2,  1, 4, 1, 9000),
    (3,  2, 2, 3, 36000),
    (4,  2, 7, 2, 35000),
    (5,  3, 3, 1, 15000),
    (6,  3, 5, 2, 26000),
    (7,  4, 5, 2, 26000),
    (8,  5, 1, 1, 8000),
    (9,  5, 5, 1, 13000),
    (10, 6, 2, 2, 24000),
    (11, 7, 7, 1, 17500),
    (12, 8, 4, 3, 27000),
    (13, 9, 3, 2, 25000),
    (14, 10,1, 4, 32000);

-- ============================================
-- REPORTE 1: Totales generales (5 funciones de agregación)
-- ============================================
SELECT
    COUNT(*)                 AS total_ventas,
    SUM(sd.subtotal)         AS ingresos_totales,
    ROUND(AVG(sd.subtotal), 2) AS ticket_promedio,
    MIN(sd.subtotal)         AS venta_minima,
    MAX(sd.subtotal)         AS venta_maxima
FROM sales_details sd;

-- ============================================
-- REPORTE 2: Ingresos por sucursal (GROUP BY)
-- ============================================
SELECT
    b.name                   AS sucursal,
    COALESCE(b.phone, 'Sin teléfono') AS telefono,
    COUNT(s.id)              AS num_ventas,
    SUM(sd.subtotal)         AS ingresos_totales,
    ROUND(AVG(sd.subtotal), 2) AS ticket_promedio
FROM branches b
JOIN sales         s  ON s.branch_id  = b.id
JOIN sales_details sd ON sd.sale_id   = s.id
GROUP BY b.id, b.name, b.phone
ORDER BY ingresos_totales DESC;

-- ============================================
-- REPORTE 3: Sabores más vendidos — HAVING
-- Solo sabores con más de $30,000 en ingresos
-- ============================================
SELECT
    f.name                   AS sabor,
    COUNT(sd.id)             AS transacciones,
    SUM(sd.subtotal)         AS ingresos
FROM flavors f
JOIN products      p  ON p.flavor_id  = f.id
JOIN sales_details sd ON sd.product_id = p.id
GROUP BY f.id, f.name
HAVING SUM(sd.subtotal) > 30000
ORDER BY ingresos DESC;

-- ============================================
-- REPORTE 4: Ventas anónimas (IS NULL)
-- ============================================
SELECT
    s.id       AS venta_id,
    s.date     AS fecha,
    b.name     AS sucursal,
    SUM(sd.subtotal) AS total_venta
FROM sales s
JOIN branches      b  ON b.id       = s.branch_id
JOIN sales_details sd ON sd.sale_id = s.id
WHERE s.customer_name IS NULL
GROUP BY s.id, s.date, b.name
ORDER BY s.date;

-- ============================================
-- REPORTE 5: Productos sin stock (IS NULL o stock = 0)
-- ============================================
SELECT
    p.name                                      AS producto,
    f.name                                      AS sabor,
    p.stock,
    COALESCE(f.description, 'Sin descripción')  AS descripcion_sabor
FROM products p
JOIN flavors f ON f.id = p.flavor_id
WHERE p.stock = 0 OR p.stock IS NULL
ORDER BY f.name;

-- ============================================
-- REPORTE 6: WHERE + GROUP BY + HAVING combinados
-- Sucursales que superaron $40,000 en enero 2024
-- ============================================
SELECT
    b.name           AS sucursal,
    SUM(sd.subtotal) AS ingresos_enero
FROM sales s
JOIN branches      b  ON b.id        = s.branch_id
JOIN sales_details sd ON sd.sale_id  = s.id
WHERE s.date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY b.id, b.name
HAVING SUM(sd.subtotal) > 40000
ORDER BY ingresos_enero DESC;