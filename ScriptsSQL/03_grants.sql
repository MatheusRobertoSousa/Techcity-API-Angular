-- db/deploy/03_grants.sql
-- Criação de usuário da aplicação com privilégios mínimos
-- Ajuste as senhas/nomes conforme o ambiente

-- CREATE USER smarthas_app IDENTIFIED BY "Troque@Senha123"
--   DEFAULT TABLESPACE USERS
--   TEMPORARY TABLESPACE TEMP
--   QUOTA 100M ON USERS;

-- GRANT CREATE SESSION TO smarthas_app;

-- Conceder privilégios mínimos de execução/leitura:
-- Troque OWNER_SCHEMA pelo schema que contém as tabelas/objetos.

-- EXECUÇÃO DE PACOTE E TRIGGER (trigger não precisa de grant; é no OWNER)
GRANT EXECUTE ON OWNER_SCHEMA.SMART_HAS_PKG TO smarthas_app;

-- SELECT nas tabelas necessárias para a aplicação
GRANT SELECT ON OWNER_SCHEMA.OCORRENCIAS TO smarthas_app;
GRANT SELECT ON OWNER_SCHEMA.ALERTAS TO smarthas_app;
GRANT INSERT ON OWNER_SCHEMA.ALERTAS TO smarthas_app;

-- INSERT na tabela de log, se a aplicação também registrar mensagens de erro
GRANT INSERT ON OWNER_SCHEMA.RELATORIOS_OCORRENCIAS_LOG TO smarthas_app;

-- Index recomendados (criar no OWNER)
-- CREATE INDEX IDX_OCORRENCIAS_BAIRRO ON OWNER_SCHEMA.OCORRENCIAS(BAIRRO);
-- CREATE INDEX IDX_OCORRENCIAS_STATUS ON OWNER_SCHEMA.OCORRENCIAS(STATUS);
-- CREATE INDEX IDX_OCORRENCIAS_NIVEL ON OWNER_SCHEMA.OCORRENCIAS(NIVEL_CRITICIDADE);

