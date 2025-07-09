

SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1: Crear usuario y rol de analista.
 ******************************************************************************/
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE rol_analista';
    DBMS_OUTPUT.PUT_LINE('Rol "rol_analista" creado.');
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE = -1921 THEN DBMS_OUTPUT.PUT_LINE('Rol "rol_analista" ya existía.'); ELSE RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER user_analista IDENTIFIED BY analista123';
    DBMS_OUTPUT.PUT_LINE('Usuario "user_analista" creado.');
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE = -1920 THEN DBMS_OUTPUT.PUT_LINE('Usuario "user_analista" ya existía.'); ELSE RAISE; END IF;
END;
/

GRANT CONNECT TO rol_analista;
GRANT SELECT ON curso_topicos.Clientes TO rol_analista;
GRANT SELECT ON curso_topicos.Pedidos TO rol_analista;
GRANT SELECT ON curso_topicos.Productos TO rol_analista;
GRANT SELECT ON curso_topicos.DetallesPedidos TO rol_analista;
GRANT INSERT ON curso_topicos.Pedidos TO rol_analista;
DBMS_OUTPUT.PUT_LINE('Permisos asignados a "rol_analista".');

GRANT rol_analista TO user_analista;
DBMS_OUTPUT.PUT_LINE('Rol "rol_analista" asignado a "user_analista".');


/******************************************************************************
 * ACTIVIDAD 2: Configurar auditoría para el analista.
 ******************************************************************************/
AUDIT SELECT ON curso_topicos.Clientes BY user_analista BY ACCESS;
AUDIT INSERT ON curso_topicos.Pedidos BY user_analista BY ACCESS;
DBMS_OUTPUT.PUT_LINE('Auditoría configurada para user_analista.');
DBMS_OUTPUT.PUT_LINE('Para ver los logs de auditoría, conecta como SYS y consulta la vista DBA_AUDIT_TRAIL.');