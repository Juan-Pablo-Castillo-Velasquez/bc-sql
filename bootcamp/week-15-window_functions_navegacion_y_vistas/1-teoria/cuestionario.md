# Cuestionario Semanal — Semana 15: Window Functions (Navegación y Vistas)
**Estudiante:** JUAN PABLO CASTILLO VELASQUEZ — 3228970A
**Motor:** PostgreSQL 16
**Dominio:** Heladería (Flavors, Products, Sales, Branches)

### 1. ¿Cuál es el propósito analítico de las funciones LAG() y LEAD() y cómo ayuda el parámetro por defecto (default)?
* **Propósito:** Permiten realizar análisis de tendencias temporales (como variaciones de ventas mes a mes) comparando el registro de la fila actual con filas anteriores (`LAG`) o posteriores (`LEAD`) sin necesidad de realizar costosos e ineficientes auto-joins (`SELF JOIN`).
* **Parámetro por defecto (default):** Permite especificar un valor alternativo (como `0` o `NULL`) para aquellas filas donde el desplazamiento (offset) se sale de los límites de la partición (por ejemplo, el mes de enero no tiene un mes anterior). Esto evita la proliferación indeseada de valores vacíos y simplifica operaciones aritméticas directas.

### 2. ¿Por qué la función LAST_VALUE() requiere obligatoriamente la cláusula de marco `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` para funcionar de forma correcta?
Por defecto, las funciones de ventana operan sobre un marco que se extiende desde `UNBOUNDED PRECEDING` (el inicio de la partición) hasta `CURRENT ROW` (la fila actual). 
Como el motor procesa fila por fila de forma secuencial según el `ORDER BY`, el valor de la fila actual es, en ese preciso instante, el "último valor" detectado por la ventana. Sin extender explícitamente el marco para abarcar todas las filas futuras de la partición usando `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`, `LAST_VALUE()` simplemente devolverá el valor de la fila en la que se encuentra parado, fallando en retornar el último registro real del grupo.

### 3. Explica las ventajas analíticas de implementar la cláusula WINDOW y la persistencia de estructuras mediante CREATE VIEW.
* **Cláusula WINDOW:** Permite declarar un alias reutilizable para una especificación de ventana común dentro de una misma consulta `SELECT`. Esto elimina la redundancia de código cuando múltiples funciones de navegación (como `FIRST_VALUE` y `LAST_VALUE`) comparten la misma partición y ordenamiento, facilitando el mantenimiento del script.
* **CREATE VIEW:** Es una sentencia DDL que almacena de manera lógica y con un nombre específico una consulta analítica compleja en la base de datos. No duplica los datos físicos, sino que encapsula la lógica. Sus ventajas son la reutilización de código, la simplificación de consultas secundarias para otros desarrolladores o reportes, y la optimización de la seguridad al restringir el acceso a las tablas base.