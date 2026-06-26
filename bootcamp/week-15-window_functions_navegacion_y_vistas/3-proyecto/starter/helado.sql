-- ============================================
-- PROYECTO SEMANAL: WINDOW FUNCTIONS (NAVEGACIÓN Y VISTAS)
-- Semana 15 — Heladería Flavors
-- Estudiante: JUAN PABLO CASTILLO VELASQUEZ - 3228970A
-- Dominio: Heladería (Flavors, Products, Sales, Branches)
-- Motor: PostgreSQL 16
-- ============================================

DROP VIEW IF EXISTS v_analitica_ventas_helados;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

-- 1. ESTRUCTURA DE LA BASE DE DATOS
CREATE TABLE branches (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    branch_id INTEGER REFERENCES branches(id) ON DELETE CASCADE,
    amount NUMERIC(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

-- 2. INSERCIÓN DE DATOS PARA COMPORTAMIENTO HISTÓRICO MENSUAL (AÑO 2026)
INSERT INTO branches (id, name, city) VALUES
    (1, 'Flavors Centro', 'Bogotá'),
    (2, 'Flavors Norte', 'Bogotá');

INSERT INTO sales (branch_id, amount, sale_date) VALUES
    -- Histórico Sucursal Centro
    (1, 12000.00, '2026-01-15'),
    (1, 14500.00, '2026-02-18'),
    (1, 11000.00, '2026-03-22'),
    (1, 16000.00, '2026-04-05'),
    -- Histórico Sucursal Norte
    (2, 22000.00, '2026-01-10'),
    (2, 21000.00, '2026-02-14'),
    (2, 25000.00, '2026-03-20'),
    (2, 18000.00, '2026-04-25');

-- ============================================
-- 3. ENCAPSULACIÓN DE INTELIGENCIA DE NEGOCIO MEDIANTE UNA VISTA
-- Requerimiento: Combinar LEAD, LAG, FIRST_VALUE, LAST_VALUE y WINDOW en una vista analítica
-- ============================================
CREATE OR REPLACE VIEW v_analitica_ventas_helados AS
SELECT
    s.id AS sale_id,
    b.name AS branch_name,
    s.sale_date,
    s.amount AS monto_actual,
    -- LAG extrae la venta del mes anterior de la misma sucursal
    LAG(s.amount, 1, 0.00) OVER w_temporal AS monto_anterior,
    -- Cálculo dinámico del delta de crecimiento o caída en ingresos
    s.amount - LAG(s.amount, 1, 0.00) OVER w_temporal AS delta_crecimiento,
    -- LEAD proyecta la facturación del mes siguiente
    LEAD(s.amount, 1, NULL) OVER w_temporal AS monto_siguiente,
    -- FIRST_VALUE y LAST_VALUE identifican récords históricos usando ventana optimizada por monto
    FIRST_VALUE(s.amount) OVER w_monto AS record_historico_alto,
    LAST_VALUE(s.amount)  OVER w_monto AS record_historico_bajo
FROM sales s
INNER JOIN branches b ON s.branch_id = b.id
-- Definición de las cláusulas de ventana reutilizables para cumplir con la rúbrica
WINDOW 
    w_temporal AS (
        PARTITION BY s.branch_id 
        ORDER BY s.sale_date ASC
    ),
    w_monto AS (
        PARTITION BY s.branch_id 
        ORDER BY s.amount DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    );

-- ============================================
-- 4. CONSULTA DE AUDITORÍA COMERCIAL A LA VISTA GENERADA
-- Extracción del reporte operativo de la sucursal Centro
-- ============================================
SELECT
    branch_name,
    sale_date,
    monto_actual,
    monto_anterior,
    delta_crecimiento,
    monto_siguiente,
    record_historico_alto,
    record_historico_bajo
FROM v_analitica_ventas_helados
WHERE branch_name = 'Flavors Centro'
ORDER BY sale_date ASC;