-- ============================================
-- Proyecto Semana 07: NULL y Constraints
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería
-- ============================================
PRAGMA foreign_keys = ON;

-- ============================================
-- 1. SCHEMA CON CONSTRAINTS
-- ============================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS sales_details;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS flavors;
DROP TABLE IF EXISTS branches;

CREATE TABLE branches (
    id       INTEGER PRIMARY KEY,
    name     TEXT    NOT NULL UNIQUE,
    location TEXT    NOT NULL,
    city     TEXT    NOT NULL,
    phone    TEXT,                          -- nullable: puede no tener teléfono
    manager  TEXT    DEFAULT 'Sin asignar' -- nullable: puede estar sin gerente
);

CREATE TABLE flavors (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,                       -- nullable: descripción opcional
    price       REAL    NOT NULL CHECK (price > 0),
    active      INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    flavor_id    INTEGER NOT NULL REFERENCES flavors(id),
    size         TEXT    NOT NULL CHECK (size IN ('Small', 'Medium', 'Large')),
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 100 CHECK (stock >= 0),
    discontinued INTEGER NOT NULL DEFAULT 0 CHECK (discontinued IN (0, 1))
);

CREATE TABLE sales (
    id            INTEGER PRIMARY KEY,
    date          DATE    NOT NULL,
    branch_id     INTEGER NOT NULL REFERENCES branches(id),
    customer_name TEXT,                     -- nullable: cliente puede ser anónimo
    discount      REAL    NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 1),
    notes         TEXT                      -- nullable: notas opcionales
);

CREATE TABLE sales_details (
    id         INTEGER PRIMARY KEY,
    sale_id    INTEGER NOT NULL REFERENCES sales(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    subtotal   REAL    NOT NULL CHECK (subtotal > 0)
);

CREATE TABLE reviews (
    id      INTEGER PRIMARY KEY,
    sale_id INTEGER NOT NULL REFERENCES sales(id),
    rating  INTEGER CHECK (rating >= 1 AND rating <= 5), -- nullable: puede no calificar
    comment TEXT,                                         -- nullable: comentario opcional
    date    DATE    NOT NULL
);

-- (datos del setup.sql ya cargados)

-- ============================================
-- 2. COALESCE aplicado a columnas relevantes
-- ============================================

-- Sucursales mostrando manager y teléfono, nunca NULL en el reporte
SELECT
    name                                        AS sucursal,
    city                                        AS ciudad,
    COALESCE(phone,   'Sin teléfono')           AS telefono,
    COALESCE(manager, 'Sin asignar')            AS gerente
FROM branches
ORDER BY city;

-- Sabores con descripción — NULL reemplazado por texto útil
SELECT
    name                                        AS sabor,
    COALESCE(description, 'Sin descripción')    AS descripcion,
    price                                       AS precio,
    CASE WHEN active = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado
FROM flavors
ORDER BY name;

-- ============================================
-- 3. IS NULL / IS NOT NULL con sentido de negocio
-- ============================================

-- Ventas anónimas (sin nombre de cliente) — útil para análisis de conversión
SELECT
    s.id            AS venta_id,
    s.date          AS fecha,
    b.name          AS sucursal,
    s.discount,
    s.notes
FROM sales s
JOIN branches b ON s.branch_id = b.id
WHERE s.customer_name IS NULL
ORDER BY s.date;

-- Reseñas sin calificación — pendientes de seguimiento
SELECT
    r.id        AS resena_id,
    r.sale_id,
    r.comment,
    r.date
FROM reviews r
WHERE r.rating IS NULL
ORDER BY r.date;

-- Sabores sin descripción — contenido pendiente de completar
SELECT name, price
FROM   flavors
WHERE  description IS NULL;

-- ============================================
-- 4. NULLIF — evitar división por cero
-- ============================================

-- Promedio de rating por sucursal (NULLIF evita dividir por 0 si no hay ratings)
SELECT
    b.name                                              AS sucursal,
    COUNT(r.rating)                                     AS resenas_con_nota,
    ROUND(AVG(NULLIF(r.rating, 0)), 2)                 AS rating_promedio
FROM branches b
LEFT JOIN sales        s  ON s.branch_id = b.id
LEFT JOIN reviews      r  ON r.sale_id   = s.id
GROUP BY b.id, b.name
ORDER BY rating_promedio DESC;