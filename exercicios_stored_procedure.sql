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