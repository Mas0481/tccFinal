CREATE DATABASE IF NOT EXISTS `projeto_final`;

USE `projeto_final`;

CREATE TABLE `pessoas` (
	`cpf` bigint NOT NULL PRIMARY KEY,
	`rg` bigint  NOT NULL,
    `nome` varchar(200),
	`endereco` varchar(200),
    `numero` int (6),
	`estado` varchar(2),
    `telefone` bigint ,
    `ativo`char,
    `obs` text,
    `bairro` varchar(100),
    `cidade` varchar (100),
    `apto` int (4),
    `cep` bigint 
);
  
CREATE TABLE `clientes` (
	`codCliente` integer NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `fk_Cpf` bigint (11) NOT NULL,
    `qntPedidos` integer,
	`divida` float,
    `credito` float,

  FOREIGN KEY (fk_Cpf)
        REFERENCES pessoas (cpf) 
);

CREATE TABLE Pedidos (
    codPedido INT AUTO_INCREMENT PRIMARY KEY,
    fk_codCliente INT NOT NULL,
     qtd_produto DOUBLE,
     valor_produtos DOUBLE,
     pagamento TINYINT,
     data_pagamento VARCHAR(10),
    recebimentoStatus double NOT NULL,
    classificacaoStatus double NOT NULL,
    lavagemStatus double NOT NULL,
    centrifugacaoStatus double NOT NULL,
    secagemStatus double NOT NULL,
    passadoriaStatus double NOT NULL,
    finalizacaoStatus double NOT NULL,
    retornoStatus double NOT NULL,
    #codCliente INT NOT NULL,
    numPedido VARCHAR(50),
    dataColeta VARCHAR(10) NOT NULL,
    dataRecebimento VARCHAR(10),
    horaRecebimento VARCHAR(8),
    dataLimite VARCHAR(10),
    dataEntrega DATE NOT NULL,
    pesoTotal DOUBLE,
    recebimentoObs TEXT,
    totalLotes INT,
    classificacaoObs TEXT,
    classificacaoDataInicio VARCHAR(10),
    classificacaoHoraInicio VARCHAR(8),
    classificacaoDataFinal VARCHAR(10),
    classificacaoHoraFinal VARCHAR(8),
    passadoriaEquipamento VARCHAR(255),
    passadoriaTemperatura VARCHAR(50),
    passadoriaDataInicio VARCHAR(10),
    passadoriaHoraInicio VARCHAR(8),
    passadoriaDataFinal VARCHAR(10),
    passadoriaHoraFinal VARCHAR(8),
    passadoriaObs TEXT,
    finalizacaoReparo VARCHAR(255),
    finalizacaoEtiquetamento VARCHAR(255),
    finalizacaoTipoEmbalagem VARCHAR(255),
    finalizacaoVolumes VARCHAR(50),
    finalizacaoControleQualidade VARCHAR(255),
    finalizacaoDataInicio VARCHAR(10),
    finalizacaoHoraInicio VARCHAR(8),
    finalizacaoDataFinal VARCHAR(10),
    finalizacaoHoraFinal VARCHAR(8),
    finalizacaoObs TEXT,
    retornoData VARCHAR(10),
    retornoHoraCarregamento VARCHAR(8),
    retornoVolumes VARCHAR(50),
    retornoNomeMotorista VARCHAR(255),
    retornoVeiculo VARCHAR(255),
    retornoPlaca VARCHAR(50),
    retornoObs TEXT,
FOREIGN KEY (fk_codCliente) REFERENCES clientes(codCliente)
);

-- Criação da tabela de usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID único e auto-incrementado
    username VARCHAR(50) NOT NULL,     -- Nome de usuário, não pode ser nulo
    password VARCHAR(50) NOT NULL,     -- Senha, não pode ser nula
    fk_Cpf BIGINT(20),                 -- Chave estrangeira ligada à tabela pessoas
    
    -- Define a chave estrangeira
    CONSTRAINT fk_Cpf_FK FOREIGN KEY (fk_Cpf) REFERENCES pessoas(cpf)
    ON DELETE CASCADE                  -- Excluir registros em usuarios quando o cpf correspondente for excluído
    ON UPDATE CASCADE                  -- Atualizar fk_Cpf em usuarios quando o cpf correspondente for atualizado
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome text NOT NULL,
    categoria VARCHAR(150),
    unidade VARCHAR (10),
    valor float NOT NULL,
    valor_especial float,
    percentual_desconto_max integer,
    tabela VARCHAR (100),
    prazo_min integer,
    observacoes text,
    data_cadastro date,
    ultima_atualizacao date,
    percentual integer    
);

  CREATE TABLE `pedido_cliente` (
	`fk_codPedido` integer,
    `fk_codCliente` integer,
    
	FOREIGN KEY (fk_codPedido)
        REFERENCES pedidos (codPedido),
        
	FOREIGN KEY (fk_codCliente)
        REFERENCES clientes (codCliente)
);

  CREATE TABLE `produto_cliente` (
	`fk_codProduto` integer NOT NULL,
    `fk_codCliente` integer NOT NULL,
    
	FOREIGN KEY (fk_codProduto)
        REFERENCES produtos (id),
        
	FOREIGN KEY (fk_codCliente)
        REFERENCES clientes (codCliente)
);

-- CRIAÇÃO DA TABELA LOTES

CREATE TABLE lotes (
    pedidoNum INT NOT NULL, -- Relaciona o lote ao número do pedido
    loteNum INT NOT NULL, -- Número do lote reiniciado para cada pedido
    loteStatus TINYINT DEFAULT 0, -- 0 = aguardando, 1 = iniciado, 2 = concluído

    -- Dados da lavagem
    loteLavagemStatus TINYINT DEFAULT 0,
    lavagemEquipamento VARCHAR(255),
    lavagemProcesso VARCHAR(255),
    lavagemDataInicio VARCHAR(10), -- Alterado de DATE para VARCHAR(10)
    lavagemHoraInicio VARCHAR(8),  -- Alterado de TIME para VARCHAR(8)
    lavagemDataFinal VARCHAR(10),  -- Alterado de DATE para VARCHAR(10)
    lavagemHoraFinal VARCHAR(8),   -- Alterado de TIME para VARCHAR(8)
    lavagemObs VARCHAR(800),      -- Alterado de TEXT para VARCHAR(800)

    -- Dados da centrifugação
    loteCentrifugacaoStatus TINYINT DEFAULT 0,
    centrifugacaoEquipamento VARCHAR(255),
    centrifugacaoTempoProcesso VARCHAR(50),
    centrifugacaoDataInicio VARCHAR(10), -- Alterado de DATE para VARCHAR(10)
    centrifugacaoHoraInicio VARCHAR(8),  -- Alterado de TIME para VARCHAR(8)
    centrifugacaoDataFinal VARCHAR(10),  -- Alterado de DATE para VARCHAR(10)
    centrifugacaoHoraFinal VARCHAR(8),   -- Alterado de TIME para VARCHAR(8)
    centrifugacaoObs VARCHAR(800),      -- Alterado de TEXT para VARCHAR(800)

    -- Dados da secagem
    loteSecagemStatus TINYINT DEFAULT 0,
    secagemEquipamento VARCHAR(255),
    secagemTempoProcesso VARCHAR(50),
    secagemTemperatura VARCHAR(50),
    secagemDataInicio VARCHAR(10), -- Alterado de DATE para VARCHAR(10)
    secagemHoraInicio VARCHAR(8),  -- Alterado de TIME para VARCHAR(8)
    secagemDataFinal VARCHAR(10),  -- Alterado de DATE para VARCHAR(10)
    secagemHoraFinal VARCHAR(8),   -- Alterado de TIME para VARCHAR(8)
    secagemObs VARCHAR(800),      -- Alterado de TEXT para VARCHAR(800)

    PRIMARY KEY (pedidoNum, loteNum), -- Chave composta
    FOREIGN KEY (pedidoNum) REFERENCES pedidos(codPedido)
);

DELIMITER $$

CREATE TRIGGER before_insert_lote
BEFORE INSERT ON lotes
FOR EACH ROW
BEGIN
    DECLARE ultimoLote INT;
    
    -- Obter o maior número de lote para o pedido atual
    SELECT COALESCE(MAX(loteNum), 0) INTO ultimoLote
    FROM lotes
    WHERE pedidoNum = NEW.pedidoNum;
    
    -- Incrementar o número do lote
    SET NEW.loteNum = ultimoLote + 1;
END$$

DELIMITER ;

INSERT INTO produtos (nome, categoria, unidade, valor, valor_especial, percentual_desconto_max, tabela, prazo_min, observacoes, data_cadastro, ultima_atualizacao, percentual) VALUES
('Ser. lav. Tramandaí', 'servico', 'kg', '17.30', '17.30', '0', 'tramandai', '2', 'Serviço de lavanderia hospitalar', '21/04/24', '21/4/24', '0');

INSERT INTO pessoas (cpf, rg, nome, endereco, numero, estado, telefone, ativo, obs, bairro, cidade, apto, cep) VALUES
('2222','3333','PREFEITURA MUNICIPAL DE TRAMANDAÍ', 'AV DA IGREJA','223','RS','5199999999','1','BOA PAGADORA','CENTRO','TRAMANDAÍ', '0','95520000');

INSERT INTO pessoas (cpf, rg, nome, endereco, numero, estado, telefone, ativo, obs, bairro, cidade, apto, cep) VALUES
('787887878','3333','MARCIO ALMEIDA', 'TRAVESSA RIO BRANCO','32','RS','5199999999','1','BOA PAGADORA','CENTRO','OSÓRIO', '0','95520000');

INSERT INTO pessoas (cpf, rg, nome, endereco, numero, estado, telefone, ativo, obs, bairro, cidade, apto, cep) VALUES
('002200','3333','MARCIO ALMEIDA', 'TRAVESSA RIO BRANCO','32','RS','5199999999','1','BOA PAGADORA','CENTRO','OSÓRIO', '0','95520000');

INSERT INTO clientes (fk_Cpf, qntPedidos, divida, credito) VALUES
('2222','0','0','0');

INSERT INTO clientes (fk_Cpf, qntPedidos, divida, credito) VALUES
('002200','0','0','0');

INSERT INTO produto_cliente (fk_codProduto, fk_codCliente) VALUES
('1', '1');

INSERT INTO usuarios (username, password, fk_Cpf) VALUES ('mas0481', '123', '787887878');
INSERT INTO usuarios (username, password, fk_Cpf) VALUES ('1', '1', '787887878');

INSERT INTO pedidos (
  fk_codCliente, qtd_Produto, valor_Produtos, pagamento, data_pagamento, 
  recebimentoStatus, classificacaoStatus, lavagemStatus, centrifugacaoStatus,
  secagemStatus, passadoriaStatus, finalizacaoStatus, retornoStatus, 
  dataColeta, dataLimite, dataEntrega, pesoTotal, recebimentoObs, 
  totalLotes, classificacaoObs, classificacaoDataInicio, classificacaoHoraInicio,
  classificacaoDataFinal, classificacaoHoraFinal, passadoriaEquipamento,
  passadoriaTemperatura, passadoriaDataInicio, passadoriaHoraInicio,
  passadoriaDataFinal, passadoriaHoraFinal, passadoriaObs, finalizacaoReparo,
  finalizacaoEtiquetamento, finalizacaoTipoEmbalagem, finalizacaoVolumes,
  finalizacaoControleQualidade, finalizacaoDataInicio, finalizacaoHoraInicio,
  finalizacaoDataFinal, finalizacaoHoraFinal, finalizacaoObs, retornoData,
  retornoHoraCarregamento, retornoVolumes, retornoNomeMotorista, retornoVeiculo,
  retornoPlaca, retornoObs
) VALUES (
  2, 1000, 5000, 1, '2024-12-08', 
  0, 0, 0, 0, 0, 0, 0, 0, 
  '2024-12-08', '2024-12-12', '2024-12-14', 200, 'Observação', 
  3, 'Observação classificação', '2024-12-08', '10:00',
  '2024-12-09', '12:00', 'Equipamento X', 'Temperatura A',
  '2024-12-08', '10:00', '2024-12-09', '14:00', 'Obs passadoria', 
  'Reparo X', 'Etiquetamento Y', 'Embalagem A', 'Volumes A',
  'Controle A', '2024-12-08', '10:00', '2024-12-09', '14:00', 'Obs finalização',
  '2024-12-10', '16:00', 'Volumes B', 'Motorista A', 'Veículo A',
  'Placa X', 'Obs retorno'
);
INSERT INTO pedidos (
  fk_codCliente, qtd_Produto, valor_Produtos, pagamento, data_pagamento, 
  recebimentoStatus, classificacaoStatus, lavagemStatus, centrifugacaoStatus,
  secagemStatus, passadoriaStatus, finalizacaoStatus, retornoStatus, 
  dataColeta, dataLimite, dataEntrega, pesoTotal, recebimentoObs, 
  totalLotes, classificacaoObs, classificacaoDataInicio, classificacaoHoraInicio,
  classificacaoDataFinal, classificacaoHoraFinal, passadoriaEquipamento,
  passadoriaTemperatura, passadoriaDataInicio, passadoriaHoraInicio,
  passadoriaDataFinal, passadoriaHoraFinal, passadoriaObs, finalizacaoReparo,
  finalizacaoEtiquetamento, finalizacaoTipoEmbalagem, finalizacaoVolumes,
  finalizacaoControleQualidade, finalizacaoDataInicio, finalizacaoHoraInicio,
  finalizacaoDataFinal, finalizacaoHoraFinal, finalizacaoObs, retornoData,
  retornoHoraCarregamento, retornoVolumes, retornoNomeMotorista, retornoVeiculo,
  retornoPlaca, retornoObs
) VALUES 
(1, 1500, 7500, 1, '2024-12-08', 0, 0, 0, 0, 0, 0, 0, 0, '2024-12-08', 
 '2024-12-12', '2024-12-14', 250, 'Observação X', 3, 'Observação classificação X', 
 '2024-12-08', '10:00', '2024-12-09', '12:00', 'Equipamento A', 'Temperatura A', 
 '2024-12-08', '10:00', '2024-12-09', '14:00', 'Obs passadoria', 
 'Reparo A', 'Etiquetamento A', 'Embalagem A', 'Volumes A', 'Controle A', 
 '2024-12-08', '10:00', '2024-12-09', '14:00', 'Obs finalização',
 '2024-12-10', '16:00', 'Volumes B', 'Motorista A', 'Veículo A', 'Placa A', 'Obs retorno'),

(2, 1200, 6000, 2, '2024-12-09', 0, 0, 0, 0, 0, 0, 0, 0, '2024-12-09', 
 '2024-12-13', '2024-12-18', 300, 'Observação Y', 4, 'Observação classificação Y', 
 '2024-12-09', '11:00', '2024-12-10', '13:00', 'Equipamento B', 'Temperatura B', 
 '2024-12-09', '11:00', '2024-12-10', '14:00', 'Obs passadoria', 
 'Reparo B', 'Etiquetamento B', 'Embalagem B', 'Volumes B', 'Controle B', 
 '2024-12-09', '11:00', '2024-12-10', '14:30', 'Obs finalização',
 '2024-12-11', '17:00', 'Volumes C', 'Motorista B', 'Veículo B', 'Placa B', 'Obs retorno'),

(1, 1300, 6500, 1, '2024-12-10', 0, 0, 0, 0, 0, 0, 0, 0, '2024-12-10', 
 '2024-12-14', '2024-12-15', 270, 'Observação Z', 2, 'Observação classificação Z', 
 '2024-12-10', '08:30', '2024-12-11', '10:00', 'Equipamento C', 'Temperatura C', 
 '2024-12-10', '08:30', '2024-12-11', '12:00', 'Obs passadoria',
 'Reparo C', 'Etiquetamento C', 'Embalagem C', 'Volumes C', 'Controle C', 
 '2024-12-10', '08:30', '2024-12-11', '12:30', 'Obs finalização',
 '2024-12-12', '18:00', 'Volumes D', 'Motorista C', 'Veículo C', 'Placa C', 'Obs retorno'),

(2, 1400, 7000, 2, '2024-12-11', 0, 0, 0, 0, 0, 0, 0, 0, '2024-12-11', 
 '2024-12-15', '2024-12-16', 220, 'Observação W', 5, 'Observação classificação W', 
 '2024-12-11', '09:00', '2024-12-12', '11:00', 'Equipamento D', 'Temperatura D', 
 '2024-12-11', '09:00', '2024-12-12', '12:00', 'Obs passadoria',
 'Reparo D', 'Etiquetamento D', 'Embalagem D', 'Volumes D', 'Controle D', 
 '2024-12-11', '09:00', '2024-12-12', '12:30', 'Obs finalização',
 '2024-12-13', '19:00', 'Volumes E', 'Motorista D', 'Veículo D', 'Placa D', 'Obs retorno'),

(1, 1100, 5500, 1, '2024-12-12', 0, 0, 0, 0, 0, 0, 0, 0, '2024-12-12', 
 '2024-12-16', '2024-12-20', 240, 'Observação V', 3, 'Observação classificação V', 
 '2024-12-12', '07:30', '2024-12-13', '09:00', 'Equipamento E', 'Temperatura E', 
 '2024-12-12', '07:30', '2024-12-13', '10:00', 'Obs passadoria',
 'Reparo E', 'Etiquetamento E', 'Embalagem E', 'Volumes E', 'Controle E', 
 '2024-12-12', '07:30', '2024-12-13', '10:30', 'Obs finalização',
 '2024-12-14', '21:00', 'Volumes F', 'Motorista E', 'Veículo E', 'Placa E', 'Obs retorno');

-- Lotes para o Pedido 30
INSERT INTO lotes (
  pedidoNum, loteNum, loteStatus, loteLavagemStatus, lavagemEquipamento, lavagemProcesso,
  lavagemDataInicio, lavagemHoraInicio, lavagemDataFinal, lavagemHoraFinal, lavagemObs,
  loteCentrifugacaoStatus, centrifugacaoEquipamento, centrifugacaoTempoProcesso, centrifugacaoDataInicio,
  centrifugacaoHoraInicio, centrifugacaoDataFinal, centrifugacaoHoraFinal, centrifugacaoObs,
  loteSecagemStatus, secagemEquipamento, secagemTempoProcesso, secagemTemperatura, secagemDataInicio,
  secagemHoraInicio, secagemDataFinal, secagemHoraFinal, secagemObs
) VALUES
(1, 1, 0, 0, 'Equipamento Lavagem 1', 'Lavagem Processo 1', '2024-12-10', '08:00', '2024-12-10', '10:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 1', 'Tempo Centrifugação 1', '2024-12-10', '10:00', '2024-12-10', '12:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 1', 'Tempo Secagem 1', 'Temperatura Secagem 1', '2024-12-10', '12:00', '2024-12-10', '14:00', 'Obs secagem'),

(1, 2, 0, 0, 'Equipamento Lavagem 2', 'Lavagem Processo 2', '2024-12-11', '09:00', '2024-12-11', '11:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 2', 'Tempo Centrifugação 2', '2024-12-11', '11:00', '2024-12-11', '13:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 2', 'Tempo Secagem 2', 'Temperatura Secagem 2', '2024-12-11', '13:00', '2024-12-11', '15:00', 'Obs secagem'),

(1, 3, 0, 0, 'Equipamento Lavagem 3', 'Lavagem Processo 3', '2024-12-12', '10:00', '2024-12-12', '12:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 3', 'Tempo Centrifugação 3', '2024-12-12', '12:00', '2024-12-12', '14:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 3', 'Tempo Secagem 3', 'Temperatura Secagem 3', '2024-12-12', '14:00', '2024-12-12', '16:00', 'Obs secagem'),

-- Lotes para o Pedido 31
(2, 1, 0, 0, 'Equipamento Lavagem 1', 'Lavagem Processo 1', '2024-12-13', '08:00', '2024-12-13', '10:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 1', 'Tempo Centrifugação 1', '2024-12-13', '10:00', '2024-12-13', '12:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 1', 'Tempo Secagem 1', 'Temperatura Secagem 1', '2024-12-13', '12:00', '2024-12-13', '14:00', 'Obs secagem'),

(2, 2, 0, 0, 'Equipamento Lavagem 2', 'Lavagem Processo 2', '2024-12-14', '09:00', '2024-12-14', '11:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 2', 'Tempo Centrifugação 2', '2024-12-14', '11:00', '2024-12-14', '13:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 2', 'Tempo Secagem 2', 'Temperatura Secagem 2', '2024-12-14', '13:00', '2024-12-14', '15:00', 'Obs secagem'),

(2, 3, 0, 0, 'Equipamento Lavagem 3', 'Lavagem Processo 3', '2024-12-15', '10:00', '2024-12-15', '12:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 3', 'Tempo Centrifugação 3', '2024-12-15', '12:00', '2024-12-15', '14:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 3', 'Tempo Secagem 3', 'Temperatura Secagem 3', '2024-12-15', '14:00', '2024-12-15', '16:00', 'Obs secagem'),

-- Lotes para o Pedido 32
(3, 1, 0, 0, 'Equipamento Lavagem 1', 'Lavagem Processo 1', '2024-12-16', '08:00', '2024-12-16', '10:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 1', 'Tempo Centrifugação 1', '2024-12-16', '10:00', '2024-12-16', '12:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 1', 'Tempo Secagem 1', 'Temperatura Secagem 1', '2024-12-16', '12:00', '2024-12-16', '14:00', 'Obs secagem'),

(3, 2, 0, 0, 'Equipamento Lavagem 2', 'Lavagem Processo 2', '2024-12-17', '09:00', '2024-12-17', '11:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 2', 'Tempo Centrifugação 2', '2024-12-17', '11:00', '2024-12-17', '13:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 2', 'Tempo Secagem 2', 'Temperatura Secagem 2', '2024-12-17', '13:00', '2024-12-17', '15:00', 'Obs secagem'),

(3, 3, 0, 0, 'Equipamento Lavagem 3', 'Lavagem Processo 3', '2024-12-18', '10:00', '2024-12-18', '12:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 3', 'Tempo Centrifugação 3', '2024-12-18', '12:00', '2024-12-18', '14:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 3', 'Tempo Secagem 3', 'Temperatura Secagem 3', '2024-12-18', '14:00', '2024-12-18', '16:00', 'Obs secagem'),

-- Lotes para o Pedido 33
(4, 1, 0, 0, 'Equipamento Lavagem 1', 'Lavagem Processo 1', '2024-12-19', '08:00', '2024-12-19', '10:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 1', 'Tempo Centrifugação 1', '2024-12-19', '10:00', '2024-12-19', '12:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 1', 'Tempo Secagem 1', 'Temperatura Secagem 1', '2024-12-19', '12:00', '2024-12-19', '14:00', 'Obs secagem'),

(4, 2, 0, 0, 'Equipamento Lavagem 2', 'Lavagem Processo 2', '2024-12-20', '09:00', '2024-12-20', '11:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 2', 'Tempo Centrifugação 2', '2024-12-20', '11:00', '2024-12-20', '13:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 2', 'Tempo Secagem 2', 'Temperatura Secagem 2', '2024-12-20', '13:00', '2024-12-20', '15:00', 'Obs secagem'),

(4, 3, 0, 0, 'Equipamento Lavagem 3', 'Lavagem Processo 3', '2024-12-21', '10:00', '2024-12-21', '12:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 3', 'Tempo Centrifugação 3', '2024-12-21', '12:00', '2024-12-21', '14:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 3', 'Tempo Secagem 3', 'Temperatura Secagem 3', '2024-12-21', '14:00', '2024-12-21', '16:00', 'Obs secagem'),

-- Lotes para o Pedido 34
(5, 1, 0, 0, 'Equipamento Lavagem 1', 'Lavagem Processo 1', '2024-12-22', '08:00', '2024-12-22', '10:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 1', 'Tempo Centrifugação 1', '2024-12-22', '10:00', '2024-12-22', '12:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 1', 'Tempo Secagem 1', 'Temperatura Secagem 1', '2024-12-22', '12:00', '2024-12-22', '14:00', 'Obs secagem'),

(5, 2, 0, 0, 'Equipamento Lavagem 2', 'Lavagem Processo 2', '2024-12-23', '09:00', '2024-12-23', '11:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 2', 'Tempo Centrifugação 2', '2024-12-23', '11:00', '2024-12-23', '13:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 2', 'Tempo Secagem 2', 'Temperatura Secagem 2', '2024-12-23', '13:00', '2024-12-23', '15:00', 'Obs secagem'),

(6, 3, 0, 0, 'Equipamento Lavagem 3', 'Lavagem Processo 3', '2024-12-24', '10:00', '2024-12-24', '12:00', 'Obs lavagem',
 0, 'Equipamento Centrifugação 3', 'Tempo Centrifugação 3', '2024-12-24', '12:00', '2024-12-24', '14:00', 'Obs centrifugação',
 0, 'Equipamento Secagem 3', 'Tempo Secagem 3', 'Temperatura Secagem 3', '2024-12-24', '14:00', '2024-12-24', '16:00', 'Obs secagem');


