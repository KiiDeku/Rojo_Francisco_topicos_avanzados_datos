-- Nombre: Francisco Rojo Alfaro
-- Prueba 2: Tópicos Avanzados de Datos

--------------------------------------------------------------------------------
-- PARTE 2: PRÁCTICA
--------------------------------------------------------------------------------

/*1. Escribe un procedimiento registrar_movimiento que reciba un
ProductoID, TipoMovimiento ('Entrada' o 'Salida'), y
Cantidad (parámetros IN). El procedimiento debe:
○ Insertar un nuevo movimiento en la tabla Movimientos (usa
el próximo MovimientoID disponible).
○ Actualizar la cantidad en Inventario según el tipo de
movimiento.
○ Actualizar la FechaActualizacion en Inventario a la fecha
actual.
○ Manejar excepciones si el producto no existe o si la
cantidad en inventario se vuelve negativa.
*/

CREATE OR REPLACE PROCEDURE registrar_movimiento (
    p_producto_id IN NUMBER,
    p_tipo_movimiento IN VARCHAR2,
    p_cantidad IN NUMBER
) AS
    v_stock_actual NUMBER;
    v_nuevo_movimiento_id NUMBER;
BEGIN
    -- Primero, validamos que el producto exista en el inventario.
    -- Usamos un bloque anidado para capturar el error NO_DATA_FOUND específicamente.
    BEGIN
        SELECT Cantidad INTO v_stock_actual
        FROM Inventario
        WHERE ProductoID = p_producto_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Si no se encuentra el producto, lanzamos un error personalizado.
            RAISE_APPLICATION_ERROR(-20001, 'Error: El producto con ID ' || p_producto_id || ' no existe en el inventario.');
    END;

    -- Si el movimiento es de 'Salida', validamos que haya stock suficiente. 
    IF p_tipo_movimiento = 'Salida' THEN
        IF v_stock_actual < p_cantidad THEN
            -- Si no hay stock, lanzamos otro error personalizado.
            RAISE_APPLICATION_ERROR(-20002, 'Error: Stock insuficiente para el producto ' || p_producto_id || '. Stock actual: ' || v_stock_actual);
        END IF;
    END IF;

    -- Obtenemos el próximo MovimientoID disponible para la nueva inserción. 
    SELECT NVL(MAX(MovimientoID), 0) + 1 INTO v_nuevo_movimiento_id FROM Movimientos;

    -- Insertamos el nuevo movimiento en la tabla Movimientos. 
    INSERT INTO Movimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento)
    VALUES (v_nuevo_movimiento_id, p_producto_id, p_tipo_movimiento, p_cantidad, SYSDATE);

    -- Actualizamos la cantidad y la fecha en la tabla Inventario según el tipo de movimiento. 
    IF p_tipo_movimiento = 'Entrada' THEN
        UPDATE Inventario SET Cantidad = Cantidad + p_cantidad, FechaActualizacion = SYSDATE WHERE ProductoID = p_producto_id;
    ELSIF p_tipo_movimiento = 'Salida' THEN
        UPDATE Inventario SET Cantidad = Cantidad - p_cantidad, FechaActualizacion = SYSDATE WHERE ProductoID = p_producto_id;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Movimiento registrado exitosamente para el producto ' || p_producto_id);
    COMMIT;
EXCEPTION
    -- Bloque de excepción general para capturar cualquier otro error inesperado. 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado al registrar movimiento: ' || SQLERRM);
        ROLLBACK;
END;
/

/*2. Escribe una función calcular_valor_inventario_proveedor que
reciba un ProveedorID (parámetro IN) y devuelva el valor
total del inventario de los productos de ese proveedor (suma
de Precio * Cantidad). Luego, usa la función en un
procedimiento mostrar_valor_proveedor que muestre el valor
total del inventario por proveedor para todos los
proveedores.
*/


CREATE OR REPLACE FUNCTION calcular_valor_inventario_proveedor (
    p_proveedor_id IN NUMBER
) RETURN NUMBER AS
    v_valor_total NUMBER;
BEGIN
    -- La función suma el resultado de (Precio * Cantidad) para todos los productos
    -- que pertenecen al proveedor especificado.
    SELECT SUM(p.Precio * i.Cantidad)
    INTO v_valor_total
    FROM Productos p
    JOIN Inventario i ON p.ProductoID = i.ProductoID
    WHERE p.ProveedorID = p_proveedor_id;

    -- Si el proveedor no tiene productos o no hay stock, NVL devuelve 0.
    RETURN NVL(v_valor_total, 0);
EXCEPTION
    -- En caso de cualquier error, la función devuelve 0 para no interrumpir el flujo.
    WHEN OTHERS THEN
        RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE mostrar_valor_proveedor AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Valor Total del Inventario por Proveedor ---');

    -- Se utiliza un cursor FOR LOOP para iterar sobre todos los proveedores.
    FOR prov IN (SELECT ProveedorID, Nombre FROM Proveedores ORDER BY Nombre) LOOP
        -- Dentro del bucle, se llama a la función para cada proveedor y se imprime el resultado.
        DBMS_OUTPUT.PUT_LINE(
            'Proveedor: ' || prov.Nombre ||
            ', Valor Total Inventario: ' || TO_CHAR(calcular_valor_inventario_proveedor(prov.ProveedorID), 'FML999G999G990D00')
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
END;
/


/*3. Crea un trigger auditar_movimientos que se dispare después
de insertar o eliminar un movimiento en la tabla Movimientos
y registre el MovimientoID, ProductoID, TipoMovimiento,
Cantidad, la acción ('INSERT' o 'DELETE') y la fecha en una
tabla de auditoría AuditoriaMovimientos.
*/


CREATE TABLE AuditoriaMovimientos (
    AuditoriaID          NUMBER GENERATED ALWAYS AS IDENTITY,
    MovimientoID         NUMBER,
    ProductoID           NUMBER,
    TipoMovimiento       VARCHAR2(50),
    Cantidad             NUMBER,
    Accion               VARCHAR2(10), -- 'INSERT' o 'DELETE'
    Fecha_Auditoria      DATE,
    CONSTRAINT pk_auditoria_movimientos PRIMARY KEY (AuditoriaID)
);

CREATE OR REPLACE TRIGGER auditar_movimientos
    -- Se dispara DESPUÉS de un INSERT o un DELETE en la tabla Movimientos.
    AFTER INSERT OR DELETE ON Movimientos
    -- Se ejecuta por cada fila afectada.
    FOR EACH ROW
DECLARE
    -- Variable para almacenar el tipo de acción.
    v_accion VARCHAR2(10);
BEGIN
    -- Las palabras clave INSERTING, DELETING y UPDATING nos permiten
    -- saber qué acción disparó el trigger.
    IF INSERTING THEN
        v_accion := 'INSERT';
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion, Fecha_Auditoria)
        VALUES (:NEW.MovimientoID, :NEW.ProductoID, :NEW.TipoMovimiento, :NEW.Cantidad, v_accion, SYSDATE);
        
    ELSIF DELETING THEN
        v_accion := 'DELETE';
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion, Fecha_Auditoria)
        VALUES (:OLD.MovimientoID, :OLD.ProductoID, :OLD.TipoMovimiento, :OLD.Cantidad, v_accion, SYSDATE);
    END IF;
END;
/



-- =================================================================
-- SCRIPT PARA CORRER PARTE 2
-- =================================================================

SET SERVEROUTPUT ON;

-- Limpiar la tabla de auditoría antes de empezar para una prueba limpia
DELETE FROM AuditoriaMovimientos;
COMMIT;

DECLARE
    v_producto_id_test NUMBER := 102; -- Usaremos el 'Teclado' para la primera prueba
    v_stock_inicial NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO DE PRUEBAS ---');
    DBMS_OUTPUT.PUT_LINE('');

    ----------------------------------------------------------------------
    -- 1. Probando Ejercicio 1: registrar_movimiento
    ----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Probando Ejercicio 1: registrar_movimiento ---');

    SELECT Cantidad INTO v_stock_inicial FROM Inventario WHERE ProductoID = v_producto_id_test;
    DBMS_OUTPUT.PUT_LINE('Stock inicial del producto ' || v_producto_id_test || ': ' || v_stock_inicial);

    -- Ejecutamos el procedimiento para una salida válida
    registrar_movimiento(p_producto_id => v_producto_id_test, p_tipo_movimiento => 'Salida', p_cantidad => 10);

    SELECT Cantidad INTO v_stock_inicial FROM Inventario WHERE ProductoID = v_producto_id_test;
    DBMS_OUTPUT.PUT_LINE('Stock final del producto ' || v_producto_id_test || ': ' || v_stock_inicial);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('');

    ----------------------------------------------------------------------
    -- 2. Probando Ejercicio 2: mostrar_valor_proveedor
    ----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Probando Ejercicio 2: mostrar_valor_proveedor ---');
    -- Ejecutamos el procedimiento, que a su vez usa la funcion.
    mostrar_valor_proveedor;
    DBMS_OUTPUT.PUT_LINE('');

    ----------------------------------------------------------------------
    -- 3. Probando Ejercicio 3: auditar_movimientos
    ----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Probando Ejercicio 3: auditar_movimientos ---');
    DBMS_OUTPUT.PUT_LINE('Tabla de auditoria ANTES de la eliminacion:');
END;
/

-- Mostramos la tabla de auditoría para ver el INSERT auditado del movimiento anterior
SELECT * FROM AuditoriaMovimientos;

DECLARE
    v_movimiento_a_borrar NUMBER := 3; -- Borraremos el movimiento 3 de la data inicial
BEGIN
    DBMS_OUTPUT.PUT_LINE('Borrando el movimiento con ID: ' || v_movimiento_a_borrar);
    DELETE FROM Movimientos WHERE MovimientoID = v_movimiento_a_borrar;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Tabla de auditoria DESPUES de la eliminacion:');
END;
/

-- Mostramos la tabla de auditoría de nuevo para ver el DELETE auditado
SELECT * FROM AuditoriaMovimientos;
