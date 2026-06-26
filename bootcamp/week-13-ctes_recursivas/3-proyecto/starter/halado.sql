-- ============================================
-- PROYECTO SEMANAL: CTEs RECURSIVAS
-- Semana 13 — AlecTours (Juan Pablo Castillo - 3228970A)
-- Dominio: Categorías de Viajes Jerárquicas y Calendario de Operaciones
-- Motor: PostgreSQL 16
-- ============================================

-- RECREACIÓN DEL ESQUEMA ADAPTADO A ALECTOURS
DROP TABLE IF EXISTS reservas_tours CASCADE;
DROP TABLE IF EXISTS categorias_destinos CASCADE;

-- 1. Tabla Auto-referencial de Categorías de Destinos (Requerimiento de Rúbrica)
CREATE TABLE categorias_destinos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    parent_category_id INTEGER REFERENCES categorias_destinos(id) ON DELETE SET NULL
);

-- 2. Tabla complementaria para transacciones de reservas diarias
CREATE TABLE reservas_tours (
    id SERIAL PRIMARY KEY,
    monto_pago NUMERIC(10,2) NOT NULL,
    fecha_reserva DATE NOT NULL
);

-- SEMILLA DE DATOS REALISTAS DE ALECTOURS
-- Jerarquía Nivel 1: Raíces principales
INSERT INTO categorias_destinos (id, nombre, parent_category_id) VALUES 
    (1, 'Turismo de Naturaleza', NULL),
    (2, 'Turismo Cultural', NULL);

-- Jerarquía Nivel 2: Subcategorías
INSERT INTO categorias_destinos (id, nombre, parent_category_id) VALUES 
    (3, 'Ecoturismo de Selva', 1),
    (4, 'Playa y Aventura Marina', 1),
    (5, 'Rutas Gastronómicas', 2),
    (6, 'Historia y Arqueología', 2);

-- Jerarquía Nivel 3: Tipos de actividades específicos (Cumple con profundidad >= 3)
INSERT INTO categorias_destinos (id, nombre, parent_category_id) VALUES 
    (7, 'Avistamiento de Delfines Rosados (Amazonas)', 3),
    (8, 'Senderismo Nativo Leticia', 3),
    (9, 'Buceo en Barreras de Coral (San Andrés)', 4),
    (10, 'Cata de Cafés Especiales (Eje Cafetero)', 5);

-- Inserción de algunas transacciones de reservas en fechas específicas del 2026
INSERT INTO reservas_tours (monto_pago, fecha_reserva) VALUES 
    (150000.00, '2026-06-01'),
    (280000.00, '2026-06-01'),
    (450000.00, '2026-06-03'),
    (120000.00, '2026-06-05'),
    (670000.00, '2026-06-06');


-- ============================================
-- CONSULTA 1: Jerarquía Completa de Categorías de AlecTours
-- Propósito: Recorrer recursivamente el árbol de categorías, calculando la profundidad (depth) y armando el path de navegación del cliente.
-- ============================================
WITH RECURSIVE jerarquia_tours AS (
    -- Caso Base: Categorías principales sin padre
    SELECT 
        id, 
        nombre, 
        parent_category_id, 
        1 AS depth, 
        nombre::TEXT AS path_navegacion
    FROM categorias_destinos
    WHERE parent_category_id IS NULL

    UNION ALL

    -- Caso Recursivo: Buscando los hijos de los nodos ya evaluados
    SELECT 
        c.id, 
        c.nombre, 
        c.parent_category_id, 
        jt.depth + 1 AS depth, 
        (jt.path_navegacion || ' > ' || c.nombre)::TEXT AS path_navegacion
    FROM categorias_destinos c
    INNER JOIN jerarquia_tours jt ON c.parent_category_id = jt.id
)
SELECT 
    id,
    depth,
    REPEAT('   ', depth - 1) || nombre AS categoria_estructurada,
    path_navegacion
FROM jerarquia_tours
ORDER BY path_navegacion;


-- ============================================
-- CONSULTA 2: Generación Dinámica de Calendario Mensual con Baches de Venta
-- Propósito: Crear una serie temporal recursiva de la primera semana de Junio de 2026 para mapear días grises sin actividad económica en AlecTours.
-- ============================================
WITH RECURSIVE calendario_operativo AS (
    -- Caso Base: Fecha de inicio del reporte analytics
    SELECT '2026-06-01'::DATE AS fecha_dia
    
    UNION ALL
    
    -- Caso Recursivo: Añadir un día secuencialmente hasta el límite determinado
    SELECT (fecha_dia + INTERVAL '1 day')::DATE
    FROM calendario_operativo
    WHERE fecha_dia < '2026-06-07'
)
SELECT 
    co.fecha_dia AS fecha_analisis,
    COALESCE(SUM(r.monto_pago), 0.00) AS ingresos_recaudados,
    COUNT(r.id) AS cantidad_reservas,
    CASE 
        WHEN COUNT(r.id) = 0 THEN 'ALERTA: Sin reservas registradas'
        ELSE 'Operación Normal'
    END AS estado_comercial
FROM calendario_operativo co
LEFT JOIN reservas_tours r ON r.fecha_reserva = co.fecha_dia
GROUP BY co.fecha_dia
ORDER BY co.fecha_dia;