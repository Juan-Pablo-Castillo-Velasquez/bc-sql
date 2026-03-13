-- ============================================
-- Semana 17: Transacciones y ACID
-- Ejercicio 01 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Ver saldos iniciales
-- ============================================

SELECT
    id,
    owner,
    balance
FROM accounts
ORDER BY id;


-- ============================================
-- PASO 2: Transferencia exitosa con COMMIT
-- ============================================

BEGIN;
    UPDATE accounts SET balance = balance - 300 WHERE id = 1;
    UPDATE accounts SET balance = balance + 300 WHERE id = 2;
COMMIT;

SELECT id, owner, balance FROM accounts ORDER BY id;


-- ============================================
-- PASO 3: Rollback por decisión explícita
-- ============================================

BEGIN;
    UPDATE accounts SET balance = balance - 500 WHERE id = 3;
    ROLLBACK;

SELECT id, owner, balance FROM accounts WHERE id = 3;


-- ============================================
-- PASO 4: Rollback por violación de CHECK
-- ============================================

BEGIN;
    -- Esta sentencia lanza ERROR: new row for relation "accounts" violates
    -- check constraint "accounts_balance_check"
    UPDATE accounts SET balance = balance - 99999 WHERE id = 2;
ROLLBACK;

-- Los saldos no deben haber cambiado desde el PASO 2
SELECT id, owner, balance FROM accounts ORDER BY id;
