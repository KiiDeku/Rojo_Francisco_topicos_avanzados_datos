
-- Actividad 2: Inserción de tupla con ID duplicado y manejo de la excepción
DECLARE
    id_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(id_duplicado, -1); -- Código para violación de clave única

BEGIN
    -- Intentamos insertar un cliente con un ID que ya existe
    INSERT INTO Clientes (ClienteID, Nombre, Ciudad)
    VALUES (1, 'Pedro Pérez', 'Valparaíso');

    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente.');

EXCEPTION
    WHEN id_duplicado THEN
        DBMS_OUTPUT.PUT_LINE('Error: Intento de insertar un ID duplicado (ClienteID = 1).');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/
