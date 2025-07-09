
SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1 y 2: Paquete gestion_clientes con validaciones y excepciones.
 ******************************************************************************/

-- Especificación del Paquete
CREATE OR REPLACE PACKAGE gestion_clientes AS
    g_clientes_registrados NUMBER := 0;
    e_edad_invalida EXCEPTION;
    e_fecha_nac_invalida EXCEPTION;

    PROCEDURE registrar_cliente(
        p_cliente_id      IN Clientes.ClienteID%TYPE,
        p_nombre          IN Clientes.Nombre%TYPE,
        p_ciudad          IN Clientes.Ciudad%TYPE,
        p_fecha_nacimiento IN Clientes.FechaNacimiento%TYPE
    );

    FUNCTION obtener_edad(
        p_cliente_id IN Clientes.ClienteID%TYPE
    ) RETURN NUMBER;
END gestion_clientes;
/

-- Cuerpo del Paquete
CREATE OR REPLACE PACKAGE BODY gestion_clientes AS

    FUNCTION obtener_edad(
        p_cliente_id IN Clientes.ClienteID%TYPE
    ) RETURN NUMBER IS
        v_fecha_nac DATE;
    BEGIN
        SELECT FechaNacimiento INTO v_fecha_nac FROM Clientes WHERE ClienteID = p_cliente_id;
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_nac) / 12);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END obtener_edad;

    PROCEDURE registrar_cliente(
        p_cliente_id      IN Clientes.ClienteID%TYPE,
        p_nombre          IN Clientes.Nombre%TYPE,
        p_ciudad          IN Clientes.Ciudad%TYPE,
        p_fecha_nacimiento IN Clientes.FechaNacimiento%TYPE
    ) IS
        v_edad NUMBER;
    BEGIN
        IF p_fecha_nacimiento >= TRUNC(SYSDATE) THEN
            RAISE e_fecha_nac_invalida;
        END IF;

        v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12);
        IF v_edad < 18 THEN
            RAISE e_edad_invalida;
        END IF;

        INSERT INTO Clientes (ClienteID, Nombre, Ciudad, FechaNacimiento)
        VALUES (p_cliente_id, p_nombre, p_ciudad, p_fecha_nacimiento);

        g_clientes_registrados := g_clientes_registrados + 1;
        DBMS_OUTPUT.PUT_LINE('Cliente "' || p_nombre || '" registrado. Clientes en sesión: ' || g_clientes_registrados);

    EXCEPTION
        WHEN e_fecha_nac_invalida THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: La fecha de nacimiento no puede ser hoy o en el futuro.');
        WHEN e_edad_invalida THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: El cliente debe ser mayor de 18 años.');
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Ya existe un cliente con el ID ' || p_cliente_id || '.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error inesperado: ' || SQLERRM);
    END registrar_cliente;

END gestion_clientes;
/

-- Bloques de prueba
DBMS_OUTPUT.PUT_LINE('--- Probando el paquete gestion_clientes ---');

BEGIN
    DBMS_OUTPUT.PUT_LINE('Prueba 1: Intentando registrar cliente menor de 18 (debe fallar)...');
    gestion_clientes.registrar_cliente(10, 'Jaimito', 'Santiago', ADD_MONTHS(SYSDATE, -12 * 17));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Prueba 2: Intentando registrar cliente con fecha futura (debe fallar)...');
    gestion_clientes.registrar_cliente(11, 'Viajero Tiempo', 'Concepcion', ADD_MONTHS(SYSDATE, 12));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Prueba 3: Intentando registrar cliente válido (debe funcionar)...');
    gestion_clientes.registrar_cliente(12, 'Pedro Valdivia', 'La Serena', TO_DATE('1980-01-01', 'YYYY-MM-DD'));
END;
/
ROLLBACK;