-- Teste de inserção e consulta de alerta
DECLARE
    v_id NUMBER;
    v_cursor SYS_REFCURSOR;
BEGIN
    -- Inserir alerta teste
    INSERT INTO ALERTAS(ID, OCORRENCIA_ID, NIVEL_CRITICIDADE, MENSAGEM, DATA_ALERTA)
    VALUES (ALERTAS_SEQ.NEXTVAL, 1, 'ALTO', 'Alerta de teste CI/CD', SYSDATE);

    COMMIT;

    -- Consultar alerta
    OPEN v_cursor FOR
        SELECT ID, MENSAGEM, NIVEL_CRITICIDADE FROM ALERTAS WHERE OCORRENCIA_ID = 1;

    DBMS_OUTPUT.PUT_LINE('Teste de alerta executado com sucesso!');
END;
/
