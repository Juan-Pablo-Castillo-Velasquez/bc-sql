# Cuestionario Semanal — Semana 10: CROSS JOIN y SELF JOIN

### 1. ¿Qué es un CROSS JOIN y cuándo se debe utilizar en el negocio?
Un `CROSS JOIN` realiza un producto cartesiano, lo que significa que combina cada fila de la primera tabla con todas las filas de la segunda tabla. Se utiliza en el negocio cuando se necesita generar una matriz o grilla completa de combinaciones posibles, por ejemplo, para planificar el inventario de todos los sabores de helado en todas las sucursales existentes.

### 2. ¿Qué es un SELF JOIN y cuál es su utilidad?
Un `SELF JOIN` es una operación donde una tabla se une consigo misma. Es de gran utilidad para modelar y consultar relaciones jerárquicas o de dependencia dentro de la misma entidad, como relacionar un sabor de helado con su "Sabor Base" o Sabor Padre dentro de la tabla de sabores.

### 3. ¿Por qué es importante usar LEFT JOIN en un SELF JOIN?
Si se usa un `INNER JOIN` en un escenario jerárquico, se excluirían los registros que están en la cima de la jerarquía (como el sabor principal que no depende de ningún otro). Al usar `LEFT JOIN`, nos aseguramos de listar todos los elementos, rellenando con `NULL` o un valor por defecto (usando `COALESCE`) a los elementos raíz.

### 4. ¿Cómo se maneja la ambigüedad de columnas en un SELF JOIN?
Como se está usando la misma tabla dos veces en la misma consulta, es obligatorio asignar aliases claros y distintos a cada instancia de la tabla (por ejemplo, `FROM flavors e LEFT JOIN flavors m`). De esta manera, el motor SQL puede distinguir si nos referimos al registro hijo o al registro padre.