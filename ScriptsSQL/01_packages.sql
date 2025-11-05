-- db/deploy/01_packages.sql
-- Smart HAS - Package de consolidação (produção)
-- Requisitos: tabelas OCORRENCIAS, ALERTAS, RELATORIOS_OCORRENCIAS_LOG
-- Sequences: ALERTAS_SEQ, RELATORIOS_OCORRENCIAS_LOG_SEQ

SET DEFINE OFF;

CREATE OR REPLACE PACKAGE smart_has_pkg AS
  PROCEDURE registrar_alerta(
    p_ocorrencia_id     IN NUMBER,
    p_nivel_criticidade IN VARCHAR2,
    p_mensagem          IN VARCHAR2
  );
  FUNCTION consultar_alertas_ocorrencia(
    p_ocorrencia_id IN NUMBER
  ) RETURN SYS_REFCURSOR;
  PROCEDURE atualizar_relatorio_usuario(
    p_user_id IN NUMBER
  );
  FUNCTION buscar_ocorrencias_dinamico(
    p_coluna IN VARCHAR2,
    p_valor  IN VARCHAR2
  ) RETURN SYS_REFCURSOR;
END smart_has_pkg;
/

CREATE OR REPLACE PACKAGE BODY smart_has_pkg AS
  FUNCTION is_coluna_permitida(p_coluna IN VARCHAR2) RETURN BOOLEAN IS
    v_col VARCHAR2(128) := UPPER(TRIM(p_coluna));
  BEGIN
    IF v_col IN ('ID','TITULO','USER_ID','DATA','DATA_CRIACAO','DATA_OCORRENCIA','STATUS','BAIRRO','TIPO','NIVEL_CRITICIDADE') THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END;

  PROCEDURE registrar_alerta(
    p_ocorrencia_id     IN NUMBER,
    p_nivel_criticidade IN VARCHAR2,
    p_mensagem          IN VARCHAR2
  ) IS
    v_id          NUMBER;
    v_existe      NUMBER;
    v_crit        VARCHAR2(20) := UPPER(TRIM(p_nivel_criticidade));
  BEGIN
    IF p_ocorrencia_id IS NULL OR p_mensagem IS NULL OR p_nivel_criticidade IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Parâmetros obrigatórios ausentes.');
    END IF;

    SELECT COUNT(*) INTO v_existe FROM OCORRENCIAS WHERE ID = p_ocorrencia_id;
    IF v_existe = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Ocorrência inexistente: '||p_ocorrencia_id);
    END IF;

    IF v_crit NOT IN ('BAIXA','MEDIA','ALTA','CRITICA') THEN
      RAISE_APPLICATION_ERROR(-20003, 'Nível de criticidade inválido: '||v_crit);
    END IF;

    SELECT ALERTAS_SEQ.NEXTVAL INTO v_id FROM dual;
    INSERT INTO ALERTAS (ID, OCORRENCIA_ID, NIVEL_CRITICIDADE, MENSAGEM, DATA_ALERTA)
    VALUES (v_id, p_ocorrencia_id, v_crit, SUBSTR(p_mensagem,1,500), SYSTIMESTAMP);
  EXCEPTION
    WHEN OTHERS THEN
      DECLARE
        v_log_id NUMBER;
        v_user   NUMBER;
      BEGIN
        BEGIN
          SELECT COALESCE(USER_ID, -1) INTO v_user FROM OCORRENCIAS WHERE ID = p_ocorrencia_id;
        EXCEPTION WHEN OTHERS THEN v_user := NULL; END;
        SELECT RELATORIOS_OCORRENCIAS_LOG_SEQ.NEXTVAL INTO v_log_id FROM dual;
        INSERT INTO RELATORIOS_OCORRENCIAS_LOG
          (ID, USER_ID, QTD_OCORRENCIAS, ULTIMA_DATA, ULTIMA_TITULO, DATA_EXECUCAO, DATA_REGISTRO, MENSAGEM, FONTE)
        VALUES
          (v_log_id, v_user, NULL, SYSTIMESTAMP, NULL, SYSTIMESTAMP, SYSTIMESTAMP,
           'Falha registrar_alerta: '||SQLERRM, 'registrar_alerta');
        RAISE;
      END;
  END registrar_alerta;

  FUNCTION consultar_alertas_ocorrencia(
    p_ocorrencia_id IN NUMBER
  ) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
      SELECT ID, NIVEL_CRITICIDADE, MENSAGEM, DATA_ALERTA
      FROM ALERTAS
      WHERE OCORRENCIA_ID = p_ocorrencia_id
      ORDER BY DATA_ALERTA DESC;
    RETURN v_cursor;
  END consultar_alertas_ocorrencia;

  PROCEDURE atualizar_relatorio_usuario(
    p_user_id IN NUMBER
  ) IS
    v_qtd           NUMBER := 0;
    v_ultima_titulo VARCHAR2(255);
    v_ultima_data   DATE;
    v_id            NUMBER;
  BEGIN
    IF p_user_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20010, 'p_user_id é obrigatório');
    END IF;

    SELECT COUNT(*), MAX(TITULO), MAX(DATA_OCORRENCIA)
      INTO v_qtd, v_ultima_titulo, v_ultima_data
      FROM OCORRENCIAS
     WHERE USER_ID = p_user_id;

    SELECT RELATORIOS_OCORRENCIAS_LOG_SEQ.NEXTVAL INTO v_id FROM dual;
    INSERT INTO RELATORIOS_OCORRENCIAS_LOG(
      ID, USER_ID, QTD_OCORRENCIAS, ULTIMA_DATA, ULTIMA_TITULO, DATA_EXECUCAO, DATA_REGISTRO, MENSAGEM, FONTE
    )
    VALUES(
      v_id, p_user_id, v_qtd, v_ultima_data, v_ultima_titulo, SYSTIMESTAMP, SYSTIMESTAMP,
      'Atualização de snapshot do usuário', 'atualizar_relatorio_usuario'
    );
  END atualizar_relatorio_usuario;

  FUNCTION buscar_ocorrencias_dinamico(
    p_coluna IN VARCHAR2,
    p_valor  IN VARCHAR2
  ) RETURN SYS_REFCURSOR IS
    v_sql    VARCHAR2(4000);
    v_cursor SYS_REFCURSOR;
    v_col    VARCHAR2(128) := UPPER(TRIM(p_coluna));
  BEGIN
    IF NOT is_coluna_permitida(v_col) THEN
      RAISE_APPLICATION_ERROR(-20020, 'Coluna não permitida para busca dinâmica: '||v_col);
    END IF;

    v_sql := 'SELECT ID, TITULO, DATA_CRIACAO, USER_ID, DATA, DESCRICAO, DATA_OCORRENCIA, STATUS, BAIRRO, TIPO, NIVEL_CRITICIDADE
              FROM OCORRENCIAS
              WHERE ' || v_col || ' = :valor
              ORDER BY DATA_OCORRENCIA DESC NULLS LAST';

    OPEN v_cursor FOR v_sql USING p_valor;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      DECLARE
        v_log_id NUMBER;
      BEGIN
        SELECT RELATORIOS_OCORRENCIAS_LOG_SEQ.NEXTVAL INTO v_log_id FROM dual;
        INSERT INTO RELATORIOS_OCORRENCIAS_LOG
          (ID, USER_ID, QTD_OCORRENCIAS, ULTIMA_DATA, ULTIMA_TITULO, DATA_EXECUCAO, DATA_REGISTRO, MENSAGEM, FONTE)
        VALUES
          (v_log_id, NULL, NULL, SYSTIMESTAMP, NULL, SYSTIMESTAMP, SYSTIMESTAMP,
           'Falha buscar_ocorrencias_dinamico: '||SQLERRM, 'buscar_ocorrencias_dinamico');
        RAISE;
      END;
  END buscar_ocorrencias_dinamico;
END smart_has_pkg;
/
