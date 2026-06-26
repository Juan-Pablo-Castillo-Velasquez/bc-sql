-- ============================================
-- Semana 07: NULL — Ejercicio 01
-- Juan Pablo Castillo Velásquez | 3228970A
-- Dominio: Heladería
-- ============================================
PRAGMA foreign_keys = ON;

-- PASO 1: Sucursales sin teléfono registrado
SELECT id, name, city
FROM   branches
WHERE  phone IS NULL;

-- PASO 2: Sucursales que sí tienen teléfono
SELECT id, name, city, phone
FROM   branches
WHERE  phone IS NOT NULL;

-- PASO 3: COALESCE — si manager es NULL mostrar 'Sin asignar'
SELECT
    name,
    manager,
    COALESCE(manager, 'Sin asignar') AS manager_efectivo
FROM branches;

-- PASO 4: COUNT(*) vs COUNT(columna)
SELECT
    COUNT(*)        AS total_sucursales,
    COUNT(phone)    AS con_telefono,
    COUNT(manager)  AS con_manager
FROM branches;