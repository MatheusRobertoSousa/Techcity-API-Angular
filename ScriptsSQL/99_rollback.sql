-- db/deploy/99_rollback.sql
SET DEFINE OFF;

-- Drop Trigger
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_auditoria_alertas';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Drop Package
BEGIN
  EXECUTE IMMEDIATE 'DROP PACKAGE smart_has_pkg';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Observação: não removemos tabelas/sequences aqui por segurança.
-- Caso necessário, inclua DDL de drop controlado e backup prévio.
