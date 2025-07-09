
SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1: Transacciones y Propiedades ACID [cite: 1542, 1543]
 * Procedimiento para registrar un pedido con SAVEPOINT (versión mejorada).
 ******************************************************************************/
CREATE OR REPLACE PROCEDURE registrar_pedido_transaccional(
    p_cliente_id      IN Pedidos.ClienteID%TYPE,
    p_total           IN Pedidos.Total%TYPE,
    p_fecha_pedido    IN Pedidos.FechaPedido%TYPE
) AS
    v_cliente_existe NUMBER;
    v_pedido_id      NUMBER;
BEGIN
    -- Primero, validamos que el cliente exista.
    SELECT COUNT(*) INTO v_cliente_existe FROM Clientes WHERE ClienteID = p_cliente_id;
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente con ID ' || p_cliente_id || ' no existe.');
    END IF;

    SAVEPOINT inicio_pedido; -- Punto de guardado por si algo falla después.

    -- Insertamos el pedido.
    INSERT INTO Pedidos (PedidoID, ClienteID, Total, FechaPedido)
    VALUES ((SELECT NVL(MAX(PedidoID), 0) + 1 FROM Pedidos), p_cliente_id, p_total, p_fecha_pedido);

    COMMIT; -- Confirmamos la transacción solo si todo va bien.
    DBMS_OUTPUT.PUT_LINE('Pedido registrado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM || '. Revertiendo operación...');
        ROLLBACK TO inicio_pedido; -- Revertimos al punto de guardado.
END;
/

/******************************************************************************
 * ACTIVIDAD 2: Data Warehouse y Tabla de Hechos [cite: 1577, 1578]
 * Creación de tablas de Dimensiones y Hechos para un DW de inventario.
 ******************************************************************************/
-- Crear Tablas de Dimensiones (si no existen)
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE Dim_Producto AS SELECT ProductoID, Nombre, Precio FROM Productos';
    EXECUTE IMMEDIATE 'ALTER TABLE Dim_Producto ADD PRIMARY KEY (ProductoID)';
    DBMS_OUTPUT.PUT_LINE('Tabla Dim_Producto creada.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 OR SQLCODE = -2260 THEN NULL; ELSE RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE Dim_Tiempo (FechaID NUMBER PRIMARY KEY, Fecha DATE, Anio NUMBER, Mes NUMBER, Dia NUMBER)';
    DBMS_OUTPUT.PUT_LINE('Tabla Dim_Tiempo creada.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/

-- Crear Tabla de Hechos [cite: 1580]
BEGIN
    EXECUTE IMMEDIATE '
    CREATE TABLE Fact_Inventario (
        FactID             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        ProductoID         NUMBER,
        FechaID            NUMBER,
        CantidadMovimiento NUMBER,
        TipoMovimiento     VARCHAR2(10),
        CONSTRAINT fk_fact_inv_prod FOREIGN KEY (ProductoID) REFERENCES Dim_Producto(ProductoID),
        CONSTRAINT fk_fact_inv_tiempo FOREIGN KEY (FechaID) REFERENCES Dim_Tiempo(FechaID)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Fact_Inventario creada.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/

/******************************************************************************
 * ACTIVIDAD 3: Herencia con Tipos de Objetos 
 * Jerarquía de tipos Cliente -> ClientePremium.
 ******************************************************************************/
CREATE OR REPLACE TYPE Tipo_Cliente AS OBJECT (
    ClienteID NUMBER,
    Nombre VARCHAR2(50),
    Ciudad VARCHAR2(50),
    MEMBER FUNCTION getDescuento RETURN NUMBER
) NOT FINAL;
/
CREATE OR REPLACE TYPE BODY Tipo_Cliente AS
    MEMBER FUNCTION getDescuento RETURN NUMBER IS BEGIN RETURN 0; END;
END;
/
CREATE OR REPLACE TYPE Tipo_ClientePremium UNDER Tipo_Cliente (
    DescuentoAdicional NUMBER,
    OVERRIDING MEMBER FUNCTION getDescuento RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY Tipo_ClientePremium AS
    OVERRIDING MEMBER FUNCTION getDescuento RETURN NUMBER IS
    BEGIN
        RETURN (SELF AS Tipo_Cliente).getDescuento() + SELF.DescuentoAdicional;
    END;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE Clientes_Obj OF Tipo_Cliente';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_clientes_obj_ciudad ON Clientes_Obj (T.Ciudad)';
    DBMS_OUTPUT.PUT_LINE('Jerarquía de tipos y tabla de objetos creada.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/


/******************************************************************************
 * ACTIVIDAD 4: Particiones e Índices Compuestos 
 ******************************************************************************/
-- Crear el índice compuesto en DetallesPedidos
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_detalles_pedido_prod ON DetallesPedidos (PedidoID, ProductoID)';
    DBMS_OUTPUT.PUT_LINE('Índice idx_detalles_pedido_prod creado.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/
-- Consulta que suma el total por cliente en Enero de 2025 [cite: 1645]
-- Esta consulta se beneficia si la tabla Pedidos está particionada por mes.
SELECT
    ClienteID,
    SUM(Total) AS Total_Mensual
FROM Pedidos
WHERE FechaPedido BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-01-31', 'YYYY-MM-DD')
GROUP BY ClienteID;