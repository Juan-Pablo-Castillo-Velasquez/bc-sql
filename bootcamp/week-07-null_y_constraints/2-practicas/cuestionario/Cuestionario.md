# Cuestionario — Semana 07: NULL y Constraints
**Juan Pablo Castillo Velásquez | 3228970A**

---

## 1. Diferencia entre NULL, 0 y cadena vacía

- **NULL** es ausencia total de valor. No se sabe si existe ni qué vale.
- **0** es un número conocido con valor cero.
- **''** (cadena vacía) es texto conocido, pero sin contenido.

En la heladería: un producto con `stock = 0` está agotado (sabemos que no hay). Un producto con `stock = NULL` significa que nunca se registró el inventario (no sabemos).

```sql
SELECT * FROM products WHERE stock = 0;    -- agotados (sabemos)
SELECT * FROM products WHERE stock IS NULL; -- sin dato de inventario
```

---

## 2. Comportamiento de NULL en comparaciones

Cualquier comparación con NULL devuelve `UNKNOWN`, no `TRUE` ni `FALSE`. Por eso `= NULL` nunca funciona.

```sql
-- ❌ Nunca devuelve filas, aunque haya NULLs
SELECT * FROM sales WHERE customer_name = NULL;

-- ✅ Correcto
SELECT * FROM sales WHERE customer_name IS NULL;
```

Cuidado con `NOT IN`: si la lista contiene un NULL, la consulta devuelve vacío.

```sql
-- ⚠️ Peligroso si hay NULLs en ratings
SELECT * FROM reviews WHERE rating NOT IN (1, 2, NULL); -- devuelve 0 filas
```

---

## 3. COALESCE vs IFNULL vs NULLIF

| Función | Qué hace | Ejemplo heladería |
|---|---|---|
| `COALESCE(a, b, ...)` | Devuelve el primer valor no NULL | `COALESCE(manager, 'Sin asignar')` |
| `IFNULL(a, b)` | Igual a COALESCE con 2 argumentos | `IFNULL(phone, 'Sin teléfono')` |
| `NULLIF(a, b)` | Devuelve NULL si a = b, si no devuelve a | `NULLIF(rating, 0)` evita promediar ceros |

`COALESCE` es más portable (funciona en todos los motores SQL). `IFNULL` es exclusivo de SQLite/MySQL.

---

## 4. Cuándo usar cada constraint

| Constraint | Cuándo usarlo | Ejemplo en heladería |
|---|---|---|
| `NOT NULL` | El dato siempre debe existir | `name TEXT NOT NULL` en flavors |
| `UNIQUE` | No puede repetirse el valor | `name TEXT UNIQUE` en branches |
| `PRIMARY KEY` | Identificador único de la fila | `id INTEGER PRIMARY KEY` |
| `FOREIGN KEY` | Enlazar con otra tabla | `flavor_id REFERENCES flavors(id)` |
| `CHECK` | Validar regla de negocio | `CHECK (price > 0)`, `CHECK (discount <= 1)` |
| `DEFAULT` | Valor automático si no se provee | `DEFAULT 'Sin asignar'`, `DEFAULT 1` |