# Cuestionario — Semana 08: Capstone Etapa 0
**Juan Pablo Castillo Velásquez | 3228970A**

---

## 1. Diferencias entre DDL y DML

**DDL (Data Definition Language)** define la *estructura* de la base de datos. Sus comandos modifican el esquema, no los datos.

| Comando DDL | Qué hace |
|---|---|
| `CREATE TABLE` | Crea una tabla nueva con sus columnas y constraints |
| `DROP TABLE` | Elimina una tabla completa (estructura + datos) |
| `ALTER TABLE` | Modifica columnas o constraints de una tabla existente |

**DML (Data Manipulation Language)** trabaja con los *datos* dentro de las estructuras ya creadas.

| Comando DML | Qué hace |
|---|---|
| `INSERT` | Agrega filas nuevas a una tabla |
| `SELECT` | Consulta y recupera datos |
| `UPDATE` | Modifica filas existentes |
| `DELETE` | Elimina filas de una tabla |

En la heladería: `CREATE TABLE products` es DDL. `INSERT INTO products VALUES (...)` es DML.

---

## 2. Justificación de constraints en el esquema

| Constraint | Dónde se usó | Por qué |
|---|---|---|
| `NOT NULL` | `branches.name`, `flavors.name`, `products.name` | Todo registro debe tener un nombre identificable |
| `UNIQUE` | `branches.name`, `flavors.name` | No puede haber dos sucursales o sabores con el mismo nombre |
| `PRIMARY KEY` | Todas las tablas (`id`) | Identifica unívocamente cada fila |
| `FOREIGN KEY` | `products.flavor_id`, `sales.branch_id` | Garantiza que no existan productos sin sabor ni ventas sin sucursal |
| `ON DELETE RESTRICT` | Todas las FK | Impide borrar un sabor o sucursal que tenga datos relacionados |
| `CHECK (price > 0)` | `flavors.price`, `products.price` | Un precio de 0 o negativo no tiene sentido de negocio |
| `CHECK (stock >= 0)` | `products.stock` | El inventario nunca puede ser negativo |
| `CHECK (discount BETWEEN 0 AND 1)` | `sales.discount` | El descuento es un porcentaje, máximo 100% |
| `DEFAULT 'Sin asignar'` | `branches.manager` | Evita NULLs inesperados; la sucursal queda funcional sin gerente |
| `DEFAULT 1` | `flavors.active` | Un sabor nuevo se asume activo hasta que se desactive explícitamente |

---

## 3. WHERE vs HAVING

`WHERE` filtra **filas individuales antes** de agrupar. No puede usar funciones de agregación.

`HAVING` filtra **grupos después** de agregar. Solo se usa junto a `GROUP BY`.

```sql
-- WHERE filtra primero (enero), luego agrupa, luego HAVING filtra el grupo
SELECT branch_id, SUM(subtotal) AS ingresos
FROM sales_details
JOIN sales ON sales.id = sales_details.sale_id
WHERE sales.date BETWEEN '2024-01-01' AND '2024-01-31'  -- fila por fila
GROUP BY branch_id
HAVING SUM(subtotal) > 40000;                           -- grupo por grupo
```

Regla: si el filtro va sobre una columna → `WHERE`. Si va sobre `SUM/COUNT/AVG` → `HAVING`.

---

## 4. COUNT(*) vs COUNT(columna) con NULLs

`COUNT(*)` cuenta **todas las filas** sin excepción, incluyendo las que tienen NULLs.

`COUNT(columna)` cuenta solo las filas donde esa columna **no es NULL**.

```sql
-- En la heladería: sales tiene customer_name NULL en varias filas
SELECT
    COUNT(*)                AS total_ventas,        -- cuenta todas (10)
    COUNT(customer_name)    AS ventas_identificadas  -- solo las con nombre (5)
FROM sales;
```

Esto es útil para saber cuántos registros tienen un dato completo vs cuántos están incompletos, sin necesidad de filtrar con `WHERE`.