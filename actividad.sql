CREATE OR REPLACE FUNCTION calcular_edad_cliente(p_cliente_id IN NUMBER) RETURN NUMBER AS
    v_fecha_nacimiento DATE;
    v_edad NUMBER;
BEGIN
    SELECT FechaNacimiento INTO v_fecha_nacimiento
    FROM Clientes
    WHERE ClienteID = p_cliente_id;

    v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_nacimiento) / 12);
    RETURN v_edad;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cliente con ID ' || p_cliente_id || ' no encontrado.');
END;
/
DECLARE
    v_edad NUMBER;
BEGIN
    v_edad := calcular_edad_cliente(1); -- Cambia el ID según tus datos
    DBMS_OUTPUT.PUT_LINE('EDAD DEL CLIENTE NUMERO 1: ' || v_edad);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/





--actividad 2


-- Función que devuelve el precio promedio
CREATE OR REPLACE FUNCTION obtener_precio_promedio RETURN NUMBER AS
    v_promedio NUMBER;
BEGIN
    SELECT AVG(Precio) INTO v_promedio
    FROM Productos;
    RETURN v_promedio;
END;
/
-- Bloque PL/SQL para listar productos con precio superior al promedio
DECLARE
    precio_promedio NUMBER;

BEGIN
    precio_promedio := obtener_precio_promedio;
    DBMS_OUTPUT.PUT_LINE('Promedio de precios de productos: ' || precio_promedio);
END;
/

