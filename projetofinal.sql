-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 24/06/2025 às 22:30
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `projetofinal`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `beneficio`
--

CREATE TABLE `beneficio` (
  `idBeneficio` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` tinytext DEFAULT NULL,
  `status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `beneficio`
--

INSERT INTO `beneficio` (`idBeneficio`, `nome`, `descricao`, `status`) VALUES
(4, 'VT', 'Vale Transporte', 1),
(6, 'VA', 'Vale Alimentação', 1),
(8, 'Creche', 'Auxilo Creche', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `contra_cheque`
--

CREATE TABLE `contra_cheque` (
  `idContra_cheque` int(11) NOT NULL,
  `valorBruto` decimal(10,2) NOT NULL,
  `descontos` decimal(10,2) NOT NULL,
  `valorLiquido` decimal(10,2) NOT NULL,
  `funcionario_idFfuncionario` int(11) NOT NULL,
  `mes` int(11) DEFAULT NULL,
  `ano` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `contra_cheque`
--

INSERT INTO `contra_cheque` (`idContra_cheque`, `valorBruto`, `descontos`, `valorLiquido`, `funcionario_idFfuncionario`, `mes`, `ano`) VALUES
(59, 4500.00, 789.33, 4504.78, 6, 5, 2025);

-- --------------------------------------------------------

--
-- Estrutura para tabela `contra_cheque_imposto`
--

CREATE TABLE `contra_cheque_imposto` (
  `idContra_cheque` int(11) NOT NULL,
  `idImposto` int(11) NOT NULL,
  `valorDescontado` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `contra_cheque_imposto`
--

INSERT INTO `contra_cheque_imposto` (`idContra_cheque`, `idImposto`, `valorDescontado`) VALUES
(59, 6, 439.60),
(59, 10, 349.73);

-- --------------------------------------------------------

--
-- Estrutura para tabela `evento_contra_cheque`
--

CREATE TABLE `evento_contra_cheque` (
  `idEvento` int(11) NOT NULL,
  `idContra_cheque` int(11) DEFAULT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `referencia` decimal(10,2) DEFAULT NULL,
  `tipo` enum('VENCIMENTO','DESCONTO') DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `evento_contra_cheque`
--

INSERT INTO `evento_contra_cheque` (`idEvento`, `idContra_cheque`, `codigo`, `descricao`, `referencia`, `tipo`, `valor`) VALUES
(169, 59, NULL, 'Salário base', NULL, 'VENCIMENTO', 4500.00),
(170, 59, NULL, 'Hora extra (50%)', NULL, 'VENCIMENTO', 754.11),
(171, 59, NULL, 'Benefícios', NULL, 'VENCIMENTO', 40.00),
(172, 59, NULL, 'INSS Faixa 4', NULL, 'DESCONTO', 439.60),
(173, 59, NULL, 'IRRF Faixa 4', NULL, 'DESCONTO', 349.73);

-- --------------------------------------------------------

--
-- Estrutura para tabela `ferias`
--

CREATE TABLE `ferias` (
  `idFerias` int(11) NOT NULL,
  `dataInicio` date NOT NULL,
  `dataFim` date NOT NULL,
  `status` varchar(20) NOT NULL,
  `funcionario_idFfuncionario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `ferias`
--

INSERT INTO `ferias` (`idFerias`, `dataInicio`, `dataFim`, `status`, `funcionario_idFfuncionario`) VALUES
(17, '2025-06-19', '2025-07-16', 'Recusado', 3),
(19, '2025-07-21', '2025-08-11', 'Recusado', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `idFfuncionario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `dataNasc` date NOT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `cargo` varchar(45) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `usuario_idUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`idFfuncionario`, `nome`, `dataNasc`, `cpf`, `cargo`, `status`, `usuario_idUsuario`) VALUES
(1, 'Wevertton', '2009-02-01', '11111111111', 'Analista', 1, 11),
(2, 'Lucinha', '2002-01-01', '12312312300', 'Gerente', 1, 12),
(3, 'Daniel', '1999-12-15', '12312332100', 'Administrador', 2, 1),
(6, 'Gilvam', '1996-12-15', '0318151109', 'Vendedor', 1, 15);

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario_beneficio`
--

CREATE TABLE `funcionario_beneficio` (
  `funcionario_idFfuncionario` int(11) NOT NULL,
  `beneficio_idBeneficio` int(11) NOT NULL,
  `valor` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `funcionario_beneficio`
--

INSERT INTO `funcionario_beneficio` (`funcionario_idFfuncionario`, `beneficio_idBeneficio`, `valor`) VALUES
(1, 4, 10),
(1, 8, 30),
(2, 4, 600),
(2, 8, 500);

-- --------------------------------------------------------

--
-- Estrutura para tabela `imposto`
--

CREATE TABLE `imposto` (
  `idImposto` int(11) NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `tipo` varchar(10) DEFAULT NULL,
  `faixa_inicio` decimal(10,2) DEFAULT NULL,
  `faixa_fim` decimal(10,2) DEFAULT NULL,
  `aliquota` decimal(5,2) DEFAULT NULL,
  `parcela_deduzir` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `imposto`
--

INSERT INTO `imposto` (`idImposto`, `descricao`, `status`, `tipo`, `faixa_inicio`, `faixa_fim`, `aliquota`, `parcela_deduzir`) VALUES
(3, 'INSS Faixa 1', 1, 'INSS', 0.00, 1518.00, 7.50, 0.00),
(4, 'INSS Faixa 2', 1, 'INSS', 1518.01, 2793.88, 9.00, 22.77),
(5, 'INSS Faixa 3', 1, 'INSS', 2793.89, 4190.83, 12.00, 106.59),
(6, 'INSS Faixa 4', 1, 'INSS', 4190.84, 8157.41, 14.00, 190.40),
(7, 'IRRF Faixa 1', 1, 'IRRF', 0.00, 2259.20, 0.00, 0.00),
(8, 'IRRF Faixa 2', 1, 'IRRF', 2259.21, 2826.65, 7.50, 169.44),
(9, 'IRRF Faixa 3', 1, 'IRRF', 2826.66, 3751.05, 15.00, 381.44),
(10, 'IRRF Faixa 4', 1, 'IRRF', 3751.06, 4664.68, 22.50, 662.77),
(11, 'IRRF Faixa 5', 1, 'IRRF', 4664.69, NULL, 27.50, 896.00);

-- --------------------------------------------------------

--
-- Estrutura para tabela `menu`
--

CREATE TABLE `menu` (
  `idMenu` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `link` varchar(100) NOT NULL,
  `icone` varchar(45) DEFAULT NULL,
  `exibir` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `menu`
--

INSERT INTO `menu` (`idMenu`, `nome`, `link`, `icone`, `exibir`) VALUES
(1, 'Dashboard', 'index.jsp', '#', 1),
(3, 'Funcionários', 'listar_funcionario.jsp', 'user', 1),
(4, 'Benefícios', 'listar_beneficio.jsp', 'gift', 1),
(5, 'Contracheque', 'listar_contra_cheque.jsp', 'money', 1),
(6, 'Impostos', 'listar_imposto.jsp', 'percent', 1),
(7, 'Registro de Ponto', 'listar_registro_ponto.jsp', 'clock', 1),
(8, 'Férias', 'listar_ferias.jsp', 'beach', 1),
(9, 'Menu', 'listar_menu.jsp', NULL, 1),
(10, 'Perfil', 'listar_perfil.jsp', NULL, 1),
(11, 'Usuário', 'listar_usuario.jsp', NULL, 1),
(19, 'Cadastrar Funcionario', 'form_funcionario.jsp', '#', 2),
(22, 'Gerenciar Funcionario', 'GerenciarFuncionario', 'gear', 0),
(24, 'Cadastrar Menu', 'form_menu.jsp', '#', 0),
(25, 'Gerenciar Menu', 'GerenciarMenu', '#', 0),
(26, 'Cadastrar Perfil', 'form_perfil.jsp', '#', 0),
(27, 'Gerenciar Perfil', 'GerenciarPerfil', '#', 0),
(28, 'Cadastrar Usuario', 'form_usuario.jsp', '#', 0),
(29, 'Gerenciar Usuario', 'GerenciarUsuario', '#', 0),
(30, 'Cadastrar Beneficio', 'form_beneficio.jsp', '#', 2),
(31, 'Gerenciar Beneficio', 'GerenciarBeneficio', '#', 2),
(32, 'Cadastrar Contra-Cheque', 'form_contra_cheque.jsp', '#', 2),
(33, 'Gerenciar Contra-Cheque', 'GerenciarContraCheque', '#', 2),
(34, 'Cadastrar Pagamento', 'form_pagamento.jsp', '#', 2),
(35, 'Gerenciar Pagamento', 'GerenciarPagamento', '#', 2),
(36, 'Pagamento', 'listar_pagamento.jsp', '#', 1),
(37, 'Cadastrar Imposto', 'form_imposto.jsp', '#', 2),
(38, 'Gerenciar Imposto', 'GerenciarImposto', '#', 2),
(40, 'Cadastrar Registro de Ponto', 'form_registro_ponto.jsp', '#', 2),
(41, 'Gerenciar Registro de Ponto', 'GerenciarRegistroPonto', '#', 2),
(42, 'Cadastrar Ferias', 'form_ferias.jsp', '#', 2),
(43, 'Gerenciar Ferias', 'GerenciarFereias', '#', 2),
(45, 'Funcionario-Benefi­cio', 'form_funcionario_beneficio.jsp', '#', 2),
(46, 'Contracheque', 'meus_contra_cheques.jsp', '$$', 1),
(47, 'GerarPDF', 'GerarPDF', '#', 2),
(48, 'GerenciarDashboard', 'GerenciarDashboard', '#', 2),
(49, 'GerenciarDashboard', 'GerenciarDashboard', '#', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pagamento`
--

CREATE TABLE `pagamento` (
  `idPagamento` int(11) NOT NULL,
  `tipoPagamento` varchar(20) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `dataPagamento` date NOT NULL,
  `funcionario_idFfuncionario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `pagamento`
--

INSERT INTO `pagamento` (`idPagamento`, `tipoPagamento`, `valor`, `dataPagamento`, `funcionario_idFfuncionario`) VALUES
(6, 'TED', 4500.00, '2025-06-05', 6),
(7, 'PIX', 3000.00, '2025-05-02', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `nome`, `status`) VALUES
(1, 'Administrador', 1),
(2, 'Gerente', 1),
(3, 'Funcionario', 1),
(5, 'Terceirizado', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `perfil_menu`
--

CREATE TABLE `perfil_menu` (
  `perfil_idPerfil` int(11) NOT NULL,
  `menu_idMenu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `perfil_menu`
--

INSERT INTO `perfil_menu` (`perfil_idPerfil`, `menu_idMenu`) VALUES
(1, 1),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 19),
(1, 22),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 45),
(1, 47),
(2, 1),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 11),
(2, 19),
(2, 22),
(2, 26),
(2, 27),
(2, 28),
(2, 29),
(2, 30),
(2, 31),
(2, 32),
(2, 33),
(2, 34),
(2, 35),
(2, 36),
(2, 37),
(2, 38),
(2, 40),
(2, 41),
(2, 42),
(2, 43),
(2, 45),
(2, 47),
(3, 1),
(3, 7),
(3, 8),
(3, 42),
(3, 43),
(3, 46),
(3, 47);

-- --------------------------------------------------------

--
-- Estrutura para tabela `registro_ponto`
--

CREATE TABLE `registro_ponto` (
  `idRegistro_ponto` int(11) NOT NULL,
  `data` date NOT NULL,
  `horaEntrada` time NOT NULL,
  `horaSaida` time DEFAULT NULL,
  `horasTrabalhadas` decimal(5,2) DEFAULT NULL,
  `funcionario_idFfuncionario` int(11) NOT NULL,
  `horaAlmocoSaida` time DEFAULT NULL,
  `horaAlmocoVolta` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `registro_ponto`
--

INSERT INTO `registro_ponto` (`idRegistro_ponto`, `data`, `horaEntrada`, `horaSaida`, `horasTrabalhadas`, `funcionario_idFfuncionario`, `horaAlmocoSaida`, `horaAlmocoVolta`) VALUES
(15, '2025-06-01', '08:00:07', '17:00:30', 7.00, 6, '12:00:13', '14:00:23'),
(23, '2025-05-03', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(24, '2025-05-05', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(25, '2025-05-06', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(26, '2025-05-07', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(27, '2025-05-08', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(28, '2025-05-09', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(29, '2025-05-10', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(30, '2025-05-12', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(31, '2025-05-13', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(32, '2025-05-14', '07:00:00', '18:00:00', 9.00, 1, '12:00:00', '14:00:00'),
(33, '2025-05-15', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(34, '2025-05-16', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(35, '2025-05-17', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(36, '2025-05-19', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(37, '2025-05-20', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(38, '2025-05-21', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(39, '2025-05-22', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(40, '2025-05-23', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(41, '2025-05-24', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(45, '2025-06-10', '06:00:00', '18:18:00', 11.30, 6, '11:00:00', '12:00:00'),
(51, '2025-06-15', '19:07:37', '14:00:44', 4.77, 6, '23:00:42', '13:07:43'),
(53, '2025-05-02', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(54, '2025-05-26', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(55, '2025-05-27', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(56, '2025-05-28', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(57, '2025-05-29', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(58, '2025-05-30', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(59, '2025-05-31', '08:00:00', '18:00:00', 8.00, 1, '12:00:00', '14:00:00'),
(62, '2025-06-12', '08:00:00', '20:00:00', 10.00, 6, '12:00:00', '14:00:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `login` varchar(45) NOT NULL,
  `senha` varchar(45) NOT NULL,
  `status` int(11) NOT NULL,
  `idPerfil` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `nome`, `login`, `senha`, `status`, `idPerfil`) VALUES
(1, 'Administrador', 'admin', '1', 1, 1),
(11, 'Wevertton', 'ton', '1', 1, 3),
(12, 'Lucinha', 'lucinha', '1', 1, 2),
(15, 'Gilvam', 'gil', '1', 1, 3),
(19, 'Joana', 'jo', '1', 1, 5);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `beneficio`
--
ALTER TABLE `beneficio`
  ADD PRIMARY KEY (`idBeneficio`);

--
-- Índices de tabela `contra_cheque`
--
ALTER TABLE `contra_cheque`
  ADD PRIMARY KEY (`idContra_cheque`),
  ADD KEY `fk_contra_cheque_funcionario1_idx` (`funcionario_idFfuncionario`);

--
-- Índices de tabela `contra_cheque_imposto`
--
ALTER TABLE `contra_cheque_imposto`
  ADD PRIMARY KEY (`idContra_cheque`,`idImposto`),
  ADD KEY `idImposto` (`idImposto`);

--
-- Índices de tabela `evento_contra_cheque`
--
ALTER TABLE `evento_contra_cheque`
  ADD PRIMARY KEY (`idEvento`),
  ADD KEY `idContra_cheque` (`idContra_cheque`);

--
-- Índices de tabela `ferias`
--
ALTER TABLE `ferias`
  ADD PRIMARY KEY (`idFerias`),
  ADD KEY `fk_ferias_funcionario1_idx` (`funcionario_idFfuncionario`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`idFfuncionario`),
  ADD KEY `fk_funcionario_usuario1_idx` (`usuario_idUsuario`);

--
-- Índices de tabela `funcionario_beneficio`
--
ALTER TABLE `funcionario_beneficio`
  ADD PRIMARY KEY (`funcionario_idFfuncionario`,`beneficio_idBeneficio`),
  ADD KEY `fk_funcionario_has_beneficio_beneficio1_idx` (`beneficio_idBeneficio`),
  ADD KEY `fk_funcionario_has_beneficio_funcionario1_idx` (`funcionario_idFfuncionario`);

--
-- Índices de tabela `imposto`
--
ALTER TABLE `imposto`
  ADD PRIMARY KEY (`idImposto`);

--
-- Índices de tabela `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`idMenu`);

--
-- Índices de tabela `pagamento`
--
ALTER TABLE `pagamento`
  ADD PRIMARY KEY (`idPagamento`),
  ADD KEY `fk_pagamento_funcionario1_idx` (`funcionario_idFfuncionario`);

--
-- Índices de tabela `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`);

--
-- Índices de tabela `perfil_menu`
--
ALTER TABLE `perfil_menu`
  ADD PRIMARY KEY (`perfil_idPerfil`,`menu_idMenu`),
  ADD KEY `fk_perfil_has_menu_menu1_idx` (`menu_idMenu`),
  ADD KEY `fk_perfil_has_menu_perfil1_idx` (`perfil_idPerfil`);

--
-- Índices de tabela `registro_ponto`
--
ALTER TABLE `registro_ponto`
  ADD PRIMARY KEY (`idRegistro_ponto`),
  ADD KEY `fk_registro_ponto_funcionario1_idx` (`funcionario_idFfuncionario`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD KEY `fk_usuario_perfil_idx` (`idPerfil`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `beneficio`
--
ALTER TABLE `beneficio`
  MODIFY `idBeneficio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `contra_cheque`
--
ALTER TABLE `contra_cheque`
  MODIFY `idContra_cheque` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT de tabela `evento_contra_cheque`
--
ALTER TABLE `evento_contra_cheque`
  MODIFY `idEvento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT de tabela `ferias`
--
ALTER TABLE `ferias`
  MODIFY `idFerias` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `funcionario`
--
ALTER TABLE `funcionario`
  MODIFY `idFfuncionario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `imposto`
--
ALTER TABLE `imposto`
  MODIFY `idImposto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `menu`
--
ALTER TABLE `menu`
  MODIFY `idMenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT de tabela `pagamento`
--
ALTER TABLE `pagamento`
  MODIFY `idPagamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `perfil`
--
ALTER TABLE `perfil`
  MODIFY `idPerfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `registro_ponto`
--
ALTER TABLE `registro_ponto`
  MODIFY `idRegistro_ponto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `contra_cheque`
--
ALTER TABLE `contra_cheque`
  ADD CONSTRAINT `fk_contra_cheque_funcionario1` FOREIGN KEY (`funcionario_idFfuncionario`) REFERENCES `funcionario` (`idFfuncionario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `contra_cheque_imposto`
--
ALTER TABLE `contra_cheque_imposto`
  ADD CONSTRAINT `contra_cheque_imposto_ibfk_1` FOREIGN KEY (`idContra_cheque`) REFERENCES `contra_cheque` (`idContra_cheque`),
  ADD CONSTRAINT `contra_cheque_imposto_ibfk_2` FOREIGN KEY (`idImposto`) REFERENCES `imposto` (`idImposto`);

--
-- Restrições para tabelas `evento_contra_cheque`
--
ALTER TABLE `evento_contra_cheque`
  ADD CONSTRAINT `evento_contra_cheque_ibfk_1` FOREIGN KEY (`idContra_cheque`) REFERENCES `contra_cheque` (`idContra_cheque`);

--
-- Restrições para tabelas `ferias`
--
ALTER TABLE `ferias`
  ADD CONSTRAINT `fk_ferias_funcionario1` FOREIGN KEY (`funcionario_idFfuncionario`) REFERENCES `funcionario` (`idFfuncionario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `funcionario`
--
ALTER TABLE `funcionario`
  ADD CONSTRAINT `fk_funcionario_usuario1` FOREIGN KEY (`usuario_idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `funcionario_beneficio`
--
ALTER TABLE `funcionario_beneficio`
  ADD CONSTRAINT `fk_funcionario_has_beneficio_beneficio1` FOREIGN KEY (`beneficio_idBeneficio`) REFERENCES `beneficio` (`idBeneficio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_funcionario_has_beneficio_funcionario1` FOREIGN KEY (`funcionario_idFfuncionario`) REFERENCES `funcionario` (`idFfuncionario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `pagamento`
--
ALTER TABLE `pagamento`
  ADD CONSTRAINT `fk_pagamento_funcionario1` FOREIGN KEY (`funcionario_idFfuncionario`) REFERENCES `funcionario` (`idFfuncionario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `perfil_menu`
--
ALTER TABLE `perfil_menu`
  ADD CONSTRAINT `fk_perfil_has_menu_menu1` FOREIGN KEY (`menu_idMenu`) REFERENCES `menu` (`idMenu`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_perfil_has_menu_perfil1` FOREIGN KEY (`perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `registro_ponto`
--
ALTER TABLE `registro_ponto`
  ADD CONSTRAINT `fk_registro_ponto_funcionario1` FOREIGN KEY (`funcionario_idFfuncionario`) REFERENCES `funcionario` (`idFfuncionario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_perfil` FOREIGN KEY (`idPerfil`) REFERENCES `perfil` (`idPerfil`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
