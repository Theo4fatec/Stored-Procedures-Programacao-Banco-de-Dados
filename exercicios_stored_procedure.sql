-- Active: 1727015344955@@127.0.0.1@5432@20242_fatec_ipi_pbdi_theo@public

--Exercicio 1.1
CREATE TABLE tb_log_restaurante(
    cod_tb_log_restautante SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_log VARCHAR(300));

-- em cada exercicio foi adicionado isso, para ter controle: INSERT INTO tb_log_restaurante (data_operacao, nome_log) VALUES (CURRENT_TIMESTAMP, '');


--Exercicio 1.2
CREATE OR REPLACE PROCEDURE sp_codigo_cliente (IN p_cod_cliente INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO v_pedidos FROM tb_pedido WHERE cod_cliente = p_cod_cliente;
    RAISE NOTICE 'O cliente % tem % pedidos', p_cod_cliente, v_pedidos;

    INSERT INTO tb_log_restaurante (data_operacao, nome_log) VALUES (CURRENT_TIMESTAMP, 'sp_codigo_cliente');
END;
$$

CALL sp_codigo_cliente(1);


--Exercicio 1.3
CREATE OR REPLACE PROCEDURE sp_codigo_cliente_2 (IN p_cod_cliente INT, OUT v_pedidos INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO v_pedidos FROM tb_pedido WHERE cod_cliente = p_cod_cliente;
    RAISE NOTICE 'O cliente % possui % pedidos', p_cod_cliente, v_pedidos;

    INSERT INTO tb_log_restaurante (data_operacao, nome_log) VALUES (CURRENT_TIMESTAMP, 'sp_codigo_cliente_2');
END;
$$

DO
$$
DECLARE
    v_pedidos INT;
BEGIN
    CALL sp_codigo_cliente_2(1, v_pedidos);
END;
$$


--Exercicio 1.4
CREATE OR REPLACE PROCEDURE sp_clientes_pedidos_total (INOUT p_cod_cliente INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO v_pedidos FROM tb_pedido WHERE cod_cliente = p_cod_cliente;
    p_cod_cliente := v_pedidos;
    RAISE NOTICE 'O total de pedidos realizado pelo cliente foi de % pedidos', p_cod_cliente;

    INSERT INTO tb_log_restaurante (data_operacao, nome_log) VALUES (CURRENT_TIMESTAMP, 'sp_clientes_pedidos_total');
END;
$$

CALL sp_clientes_pedidos_total(1);


--Exercicio 1.5
CREATE OR REPLACE PROCEDURE sp_insercao_clientes (VARIADIC nomes_pessoas text [])
LANGUAGE plpgsql
AS $$
DECLARE
    i TEXT;
    nomes_armazenados TEXT := '';
BEGIN
    FOREACH i IN ARRAY nomes_pessoas LOOP 
        INSERT INTO tb_cliente (nome) VALUES (i);
        nomes_armazenados := nomes_armazenados || i || ', ';
    END LOOP;
    RAISE NOTICE 'Os clientes: % foram cadastrados', nomes_armazenados;

    INSERT INTO tb_log_restaurante (data_operacao, nome_log) VALUES (CURRENT_TIMESTAMP, 'sp_insercao_clientes');
    
END;
$$

CALL sp_insercao_clientes ('Cleber', 'Igor', 'Marina', 'John', 'Ramiro');
