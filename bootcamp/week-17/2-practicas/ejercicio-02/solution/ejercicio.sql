-- ============================================
-- Semana 17: Transacciones y ACID
-- Ejercicio 02 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: SAVEPOINT y rollback parcial
-- ============================================

BEGIN;
    INSERT INTO accounts (owner, balance) VALUES ('Nuevo A', 500.00);
    SAVEPOINT sp1;
    -- Este INSERT fallará por CHECK (balance >= 0)
    -- pero lo revertimos manualmente antes de que eso ocurra
    INSERT INTO accounts (owner, balance) VALUES ('Inválido', -100.00);
    ROLLBACK TO SAVEPOINT sp1;
COMMIT;

-- Solo 'Nuevo A' debería aparecer; 'Inválido' no existe
SELECT * FROM accounts ORDER BY id;


-- ============================================
-- PASO 2: SAVEPOINTs en cadena
-- ============================================

BEGIN;
    UPDATE accounts SET balance = balance + 100 WHERE id = 1;
    SAVEPOINT sp_a;
    UPDATE accounts SET balance = balance + 200 WHERE id = 2;
    SAVEPOINT sp_b;
    UPDATE accounts SET balance = balance + 300 WHERE id = 3;
    -- Revertimos desde sp_b: solo la actualización de id=3 se deshace
    ROLLBACK TO SAVEPOINT sp_b;
COMMIT;

-- id=1: +100, id=2: +200, id=3: sin cambio neto
SELECT id, owner, balance FROM accounts ORDER BY id;


-- ============================================
-- PASO 3: RELEASE SAVEPOINT
-- ============================================

BEGIN;
    UPDATE accounts SET balance = balance - 50 WHERE id = 1;
    SAVEPOINT sp_temporal;
    UPDATE accounts SET balance = balance - 50 WHERE id = 2;
    -- RELEASE elimina el marcador, NO los cambios
    RELEASE SAVEPOINT sp_temporal;
COMMIT;

-- Ambas actualizaciones persisten
SELECT id, owner, balance FROM accounts ORDER BY id;


-- ============================================
-- PASO 4: Transacción compleja con múltiples SAVEPOINTs
-- ============================================

BEGIN;
    -- Acreditamos 1000 a la cuenta 3
    UPDATE accounts SET balance = balance + 1000 WHERE id = 3;
    SAVEPOINT antes_descuento;
    -- Intentamos un descuento de 600
    UPDATE accounts SET balance = balance - 600  WHERE id = 3;
    -- Decidimos proteger el saldo: revertimos solo el descuento
    ROLLBACK TO SAVEPOINT antes_descuento;
COMMIT;

-- Saldo de id=3 debe reflejar solo el crédito de 1000
SELECT id, owner, balance FROM accounts WHERE id = 3;
