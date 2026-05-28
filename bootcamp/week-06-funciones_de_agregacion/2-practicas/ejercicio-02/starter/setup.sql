-- ============================================
-- Semana 06: Agregación — Ejercicio 02 — Setup
-- Dominio: Heladería
-- ============================================
-- NOTA: Ejecuta el setup del ejercicio 01 primero
-- Este archivo amplía los datos para GROUP BY y HAVING

-- Más datos de ventas para mejor GROUP BY
INSERT INTO sales (id, date, branch_id) VALUES
    (11, '2024-01-25', 1),
    (12, '2024-01-26', 1),
    (13, '2024-01-27', 2),
    (14, '2024-01-28', 2),
    (15, '2024-01-29', 3),
    (16, '2024-01-30', 1),
    (17, '2024-01-31', 3);

-- Más detalles de ventas
INSERT INTO sales_details (id, sale_id, product_id, quantity, subtotal) VALUES
    (20, 11, 5, 2, 26000.00),
    (21, 11, 10, 1, 10000.00),
    (22, 12, 2, 4, 48000.00),
    (23, 13, 6, 1, 16000.00),
    (24, 13, 9, 2, 31000.00),
    (25, 14, 11, 3, 42000.00),
    (26, 15, 1, 5, 40000.00),
    (27, 16, 8, 2, 25000.00),
    (28, 17, 12, 2, 36000.00),
    (29, 17, 4, 1, 9000.00);