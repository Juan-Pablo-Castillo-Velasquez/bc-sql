# 📖 Glosario — Semana 01: Introducción a Bases de Datos Relacionales

Términos clave de esta semana, ordenados alfabéticamente.

> 💡 Cada término incluye: definición en español + ejemplo SQL cuando aplique.

---

## B

### **Base de datos**

Colección organizada y estructurada de datos que se almacena de forma
persistente y puede consultarse, modificarse y administrarse de manera
eficiente. En el modelo relacional, los datos se organizan en tablas
relacionadas entre sí.

_Ejemplo_: Una base de datos de una tienda contiene tablas para productos,
clientes y ventas.

---

## C

### **Clave foránea** (_Foreign Key_)

Columna (o conjunto de columnas) en una tabla que hace referencia a la
clave primaria de otra tabla. Establece la relación entre ambas tablas y
garantiza la integridad referencial de los datos.

```sql
-- La columna customer_id en orders hace referencia a la tabla customers
CREATE TABLE orders (
    id          INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

### **Clave primaria** (_Primary Key_)

Columna (o conjunto de columnas) que identifica de forma única cada fila
en una tabla. No puede contener valores `NULL` ni valores duplicados.

```sql
-- La columna id es la clave primaria de la tabla
CREATE TABLE products (
    id    INTEGER PRIMARY KEY,
    name  TEXT    NOT NULL
);
```

### **Columna** (_Column / Field_)

Estructura vertical de una tabla que define un atributo o característica
de los datos. Cada columna tiene un nombre y un tipo de dato específico.
También se conoce como **campo**.

_Ejemplo_: En una tabla `employees`, las columnas podrían ser `first_name`,
`last_name`, `salary` y `hire_date`.

### **Constraint** (Restricción de integridad)

Regla definida en una tabla para garantizar la validez e integridad de los
datos. Los constraints se aplican automáticamente al insertar o actualizar
registros.

_Tipos comunes_: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`,
`CHECK`, `DEFAULT`.

```sql
-- Ejemplo de varias constraints en una tabla
CREATE TABLE employees (
    id         INTEGER PRIMARY KEY,        -- PRIMARY KEY
    email      TEXT    NOT NULL UNIQUE,    -- NOT NULL + UNIQUE
    salary     REAL    CHECK (salary > 0), -- CHECK
    is_active  INTEGER DEFAULT 1           -- DEFAULT
);
```

---

## D

### **DDL** (Data Definition Language)

Subconjunto de SQL que se usa para **definir y modificar la estructura**
de la base de datos. Los comandos DDL crean, alteran o eliminan objetos como
tablas, índices y vistas.

_Comandos principales_: `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`,
`TRUNCATE`.

```sql
-- Ejemplo de DDL: crear una tabla
CREATE TABLE categories (
    id   INTEGER PRIMARY KEY,
    name TEXT    NOT NULL
);
```

### **DML** (Data Manipulation Language)

Subconjunto de SQL que se usa para **manipular los datos** dentro de las
tablas ya definidas. Incluye operaciones de consulta, inserción, actualización
y eliminación de registros.

_Comandos principales_: `SELECT`, `INSERT INTO`, `UPDATE`, `DELETE`.

```sql
-- Ejemplo de DML: insertar y consultar datos
INSERT INTO categories (name) VALUES ('Electrónica');
SELECT id, name FROM categories;
```

---

## F

### **Fila** (_Row / Record_)

Estructura horizontal de una tabla que representa un registro individual.
Cada fila contiene un valor para cada columna de la tabla. También se conoce
como **registro** o **tupla**.

_Ejemplo_: En una tabla `products`, una fila podría representar: id=1,
name='Laptop', price=999.99.

---

## M

### **Motor de base de datos** (_Database Engine_)

Software que gestiona el almacenamiento, consulta y administración de los
datos en una base de datos. En este bootcamp usamos **SQLite** (semanas 1–12)
y **PostgreSQL** (semanas 13–24).

---

## N

### **NULL**

Valor especial en SQL que representa la **ausencia de dato** o un valor
desconocido. `NULL` no es igual a cero, ni a una cadena vacía. Las comparaciones
con `NULL` requieren los operadores `IS NULL` o `IS NOT NULL`.

```sql
-- Correcto: buscar registros sin email registrado
SELECT name FROM employees WHERE email IS NULL;

-- Incorrecto: esto no funciona en SQL
-- SELECT name FROM employees WHERE email = NULL;
```

---

## R

### **Registro** (_Record_)

Sinónimo de **fila**. Representa una instancia individual de los datos
almacenados en una tabla.

### **Relación**

En el modelo relacional, una **relación** es sinónimo de tabla. También
se usa para describir la asociación entre dos tablas mediante claves primarias
y foráneas. El modelo relacional, creado por Edgar F. Codd en 1970, basa
toda su estructura en este concepto matemático.

---

## S

### **SELECT**

Comando SQL de DML que se usa para **consultar y recuperar datos** de una
o más tablas. Es el comando más utilizado en SQL.

```sql
-- Estructura básica de un SELECT
SELECT  first_name, last_name, salary
FROM    employees
WHERE   salary > 50000
ORDER BY last_name ASC
LIMIT   10;
```

### **SQLite**

Motor de base de datos relacional **liviano, sin servidor y de código abierto**.
Almacena toda la base de datos en un único archivo en disco. Ideal para
aprendizaje, aplicaciones móviles y proyectos pequeños. Es el motor más
desplegado del mundo.

_Sitio oficial_: https://www.sqlite.org/

---

## T

### **Tabla** (_Table_)

Estructura fundamental del modelo relacional que organiza los datos en
**filas** (registros) y **columnas** (campos). Equivale a una hoja de
cálculo, pero con reglas estrictas de tipos de datos e integridad.

```sql
-- Una tabla tiene un nombre y define sus columnas y sus tipos
CREATE TABLE products (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,
    price       REAL    NOT NULL,
    stock       INTEGER DEFAULT 0
);
```

### **Tipo de dato** (_Data Type_)

Define el **tipo de valor** que puede almacenarse en una columna. En SQLite
los tipos de afinidad son: `INTEGER`, `REAL`, `TEXT`, `BLOB` y `NULL`.

| Tipo      | Descripción                            | Ejemplo            |
| --------- | -------------------------------------- | ------------------ |
| `INTEGER` | Números enteros                        | `42`, `-5`, `0`    |
| `REAL`    | Números con decimales (punto flotante) | `3.14`, `99.99`    |
| `TEXT`    | Cadenas de texto                       | `'María'`, `'SQL'` |
| `BLOB`    | Datos binarios (imágenes, archivos)    | (datos sin tipo)   |
| `NULL`    | Ausencia de valor                      | `NULL`             |

---

> 📚 **¿Quieres profundizar?** Consulta la definición oficial de tipos de
> datos en SQLite: https://www.sqlite.org/datatype3.html
