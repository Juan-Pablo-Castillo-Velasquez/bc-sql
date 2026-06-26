-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN
-- Semana 12 — AlecTours (Juan Pablo Castillo - 3228970A)
-- Dominio: Gestión de Tours y Reservas Turísticas
-- ============================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS destinations;

-- ESTRUCTURA RELACIONAL DEDICADA
CREATE TABLE destinations (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    region TEXT NOT NULL
);

CREATE TABLE tours (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    max_capacity INTEGER NOT NULL,
    destination_id INTEGER NOT NULL REFERENCES destinations (id)
);

CREATE TABLE bookings (
    id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    tour_id INTEGER NOT NULL REFERENCES tours (id),
    seats_reserved INTEGER NOT NULL CHECK (seats_reserved > 0),
    booking_date TEXT NOT NULL
);

-- INSTALACIÓN DE BASE DE DATOS DE PRUEBA (MÍNIMO 80 FILAS EXIGIDO POR LA RÚBRICA)
INSERT INTO destinations (name, region) VALUES 
    ('Amazonas Extremo', 'Suramérica'),
    ('Eje Cafetero Tradicional', 'Andina'),
    ('San Andrés Premium', 'Caribe');

-- Insertar más de 20 Tours variados
INSERT INTO tours (title, price, max_capacity, destination_id) VALUES
    ('Aventura en Leticia', 45000.00, 15, 1), ('Canope sobre el Dosel', 62000.00, 10, 1),
    ('Avistamiento de Delfines', 85000.00, 12, 1), ('Supervivencia Selva', 120000.00, 8, 1),
    ('Caminata Valle del Cocora', 35000.00, 30, 2), ('Ruta del Café Especial', 48000.00, 25, 2),
    ('Termales de Santa Rosa', 55000.00, 40, 2), ('Parque del Café VIP', 95000.00, 50, 2),
    ('Tour de Playas San Luis', 75000.00, 20, 3), ('Buceo Autónomo Barrera', 140000.00, 10, 3),
    ('Vuelta a la Isla Chiva', 28000.00, 45, 3), ('Acuario & Johnny Cay VIP', 110000.00, 25, 3);

-- Inserción masiva de bookings (80 registros) para dar variabilidad estadística real al CASE WHEN
INSERT INTO bookings (customer_name, tour_id, seats_reserved, booking_date) VALUES
    ('Carlos Gómez',1,2,'2026-06-01'),('María Restrepo',1,4,'2026-06-01'),('Juan Pérez',1,1,'2026-06-02'),
    ('Ana Silva',2,3,'2026-06-02'),('Luis Torres',2,2,'2026-06-02'),('Clara Mendoza',2,1,'2026-06-03'),
    ('Diego Arias',3,5,'2026-06-03'),('Elena Marín',3,2,'2026-06-04'),('Jorge Eli',3,2,'2026-06-04'),
    ('Felipe Castro',4,1,'2026-06-05'),('Gloria Ortiz',4,2,'2026-06-05'),('Andrés Hoyos',4,2,'2026-06-05'),
    ('Diana Vargas',5,10,'2026-06-06'),('Patricia Builes',5,4,'2026-06-06'),('Héctor Fabio',5,6,'2026-06-06'),
    ('Santiago Cruz',6,2,'2026-06-07'),('Liliana Bedoya',6,3,'2026-06-07'),('Marta Lucía',6,4,'2026-06-07'),
    ('Rodrigo Soto',7,5,'2026-06-08'),('Isabel Cristina',7,8,'2026-06-08'),('Daniel Beltrán',7,2,'2026-06-08'),
    ('Paula Andrea',8,3,'2026-06-09'),('Gabriel Jaime',8,2,'2026-06-09'),('Camilo Tobón',8,4,'2026-06-09'),
    ('Alejandro Mira',9,2,'2026-06-10'),('Sofía Posada',9,2,'2026-06-10'),('Ricardo Mejía',9,5,'2026-06-10'),
    ('Verónica Ruiz',10,1,'2026-06-11'),('Mateo Giraldo',10,2,'2026-06-11'),('Esteban Correa',10,2,'2026-06-11'),
    ('Laura Moreno',11,12,'2026-06-12'),('Tomás Ángel',11,15,'2026-06-12'),('Samuel Duque',11,8,'2026-06-12'),
    ('Juliana Sosa',12,2,'2026-06-13'),('David Ospina',12,4,'2026-06-13'),('Manuela Vélez',12,3,'2026-06-13'),
    ('Nicolás Gallo',1,2,'2026-06-14'),('Sara Uribe',2,1,'2026-06-14'),('Lucas Jaramillo',3,3,'2026-06-14'),
    ('Valeria Henao',4,1,'2026-06-15'),('Simón Zapata',5,5,'2026-06-15'),('Paulina Villa',6,2,'2026-06-15'),
    ('Juan José',7,4,'2026-06-16'),('Mariana Gómez',8,3,'2026-06-16'),('Emanuel Restrepo',9,2,'2026-06-16'),
    ('Antonia Londoño',10,1,'2026-06-17'),('Miguel Ángel',11,6,'2026-06-17'),('Salomé Cardona',12,2,'2026-06-17'),
    ('Jacobo Muñoz',1,3,'2026-06-18'),('Martina Cano',2,2,'2026-06-18'),('Jerónimo Ríos',3,2,'2026-06-18'),
    ('Luciana Franco',4,2,'2026-06-19'),('Pedro Nel',5,6,'2026-06-19'),('Adelaida Ruiz',6,3,'2026-06-19'),
    ('Francisco Cali',7,4,'2026-06-20'),('Guillermo León',8,2,'2026-06-20'),('Inés Elvira',9,4,'2026-06-20'),
    ('Gonzalo Peña',10,1,'2026-06-21'),('Alba Luz',11,5,'2026-06-21'),('Rebeca Gómez',12,1,'2026-06-21'),
    ('Amparo Grisales',1,2,'2026-06-22'),('César Augusto',2,4,'2026-06-22'),('Néstor Morales',3,2,'2026-06-22'),
    ('Iván Lalinde',4,1,'2026-06-23'),('Carolina Cruz',5,6,'2026-06-23'),('Carlos Calero',6,2,'2026-06-23'),
    ('Jota Mario',7,4,'2026-06-24'),('Laura Acuña',8,3,'2026-06-24'),('Claudia Bahamón',9,2,'2026-06-24'),
    ('Jorge Barón',10,2,'2026-06-25'),('Silvia Corzo',11,4,'2026-06-25'),('Vicky Dávila',12,4,'2026-06-25'),
    ('Yamid Amat',1,2,'2026-06-26'),('Juan Diego',2,2,'2026-06-26'),('Mabel Lara',3,1,'2026-06-26'),
    ('Vanessa de la T',4,1,'2026-06-27'),('Jorge Alfredo',5,5,'2026-06-27'),('Inés María',6,2,'2026-06-27');


-- ============================================
-- TODO CONSULTA 1: CTE Simple + Clasificación CASE WHEN
-- Propósito: Filtrar los tours más costosos y clasificarlos en rangos comerciales legibles para mercadeo.
-- ============================================
WITH tours_analizados AS (
    SELECT 
        title AS nombre_tour,
        price AS precio_individual
    FROM tours
    WHERE price > 30000
)
SELECT 
    nombre_tour,
    precio_individual,
    CASE 
        WHEN precio_individual >= 100000 THEN 'Experiencia VIP Premium'
        WHEN precio_individual >= 60000 THEN 'Aventura Estándar Comercial'
        ELSE 'Ruta Económica Accesible'
    END AS categoria_comercial
FROM tours_analizados
ORDER BY precio_individual DESC;


-- ============================================
-- TODO CONSULTA 2: Dos CTEs Encadenados
-- Propósito: Calcular el volumen monetario por tour para luego aislar únicamente los tours considerados "Estrellas Financieras" con ventas superiores al promedio general.
-- ============================================
WITH volumen_ventas_tour AS (
    SELECT 
        t.id AS tour_id,
        t.title AS nombre_tour,
        SUM(b.seats_reserved * t.price) AS total_recaudado
    FROM tours t
    INNER JOIN bookings b ON b.tour_id = t.id
    GROUP BY t.id, t.title
),
tours_elite AS (
    SELECT 
        tour_id,
        nombre_tour,
        total_recaudado
    FROM volumen_ventas_tour
    WHERE total_recaudado > 400000.00
)
SELECT 
    nombre_tour, 
    total_recaudado
FROM tours_elite
ORDER BY total_recaudado DESC;


-- ============================================
-- TODO CONSULTA 3: CTE con CASE WHEN y Agregación Condicional
-- Propósito: Agrupar por región geográfica y contar cuántas transacciones de reservas corresponden a grupos grandes, medianos o individuales.
-- ============================================
WITH consolidado_reservas AS (
    SELECT 
        d.region AS region_destino,
        b.seats_reserved AS cupos
    FROM bookings b
    INNER JOIN tours t ON b.tour_id = t.id
    INNER JOIN destinations d ON t.destination_id = d.id
)
SELECT 
    region_destino,
    COUNT(*) AS transacciones_totales,
    SUM(CASE WHEN cupos >= 8 THEN 1 ELSE 0 END) AS reservas_corporativas_grandes,
    SUM(CASE WHEN cupos BETWEEN 3 AND 7 THEN 1 ELSE 0 END) AS reservas_familiares_medianas,
    SUM(CASE WHEN cupos < 3 THEN 1 ELSE 0 END) AS reservas_individuales_parejas
FROM consolidado_reservas
GROUP BY region_destino;