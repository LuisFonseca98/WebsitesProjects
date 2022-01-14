-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 30-Jun-2020 às 16:13
-- Versão do servidor: 10.4.11-MariaDB
-- versão do PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `tp2`
--
CREATE DATABASE IF NOT EXISTS `tp2` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `tp2`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth-basic`
--

CREATE TABLE `auth-basic` (
  `id` int(11) NOT NULL,
  `name` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `valid` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth-challenge`
--

CREATE TABLE `auth-challenge` (
  `id` int(11) NOT NULL,
  `challenge` varchar(32) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth-permissions`
--

CREATE TABLE `auth-permissions` (
  `role` int(11) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `auth-roles`
--

CREATE TABLE `auth-roles` (
  `role` int(11) NOT NULL,
  `friendlyName` varchar(64) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `auth-roles`
--

INSERT INTO `auth-roles` (`role`, `friendlyName`) VALUES
(1, 'admin'),
(2, 'simpatizante'),
(3, 'utilizador'),
(4, 'convidado');

-- --------------------------------------------------------

--
-- Estrutura da tabela `conteudo`
--

CREATE TABLE `conteudo` (
  `id_conteudo` int(11) NOT NULL,
  `titulo` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `descricao` longtext COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `curso`
--

CREATE TABLE `curso` (
  `id_curso` int(11) NOT NULL,
  `nome_curso` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `duracao` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `img` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `required_role` int(11) NOT NULL,
  `tag` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `video` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `visible` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `curso_conteudo`
--

CREATE TABLE `curso_conteudo` (
  `id_curso` int(11) NOT NULL,
  `id_conteudo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `email-accounts`
--

CREATE TABLE `email-accounts` (
  `id` int(11) NOT NULL,
  `accountName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `smtpServer` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `port` int(11) NOT NULL,
  `useSSL` tinyint(4) NOT NULL,
  `timeout` int(11) NOT NULL,
  `loginName` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `displayName` varchar(128) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `email-accounts`
--

INSERT INTO `email-accounts` (`id`, `accountName`, `smtpServer`, `port`, `useSSL`, `timeout`, `loginName`, `password`, `email`, `displayName`) VALUES
(1, 'Gmail - SMI', 'smtp.gmail.com', 465, 1, 30, 'iselg13smi@gmail.com', 'isel1920', 'iselg13smi@gmail.com', 'Sistemas Multimédia para a Internet');

-- --------------------------------------------------------

--
-- Estrutura da tabela `email-contacts`
--

CREATE TABLE `email-contacts` (
  `id` int(11) NOT NULL,
  `displayName` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `email-contacts`
--

INSERT INTO `email-contacts` (`id`, `displayName`, `email`) VALUES
(1, 'Carlos Gonçalves - IPL', 'cgoncalves@deetc.isel.ipl.pt'),
(2, 'Carlos Gonçalves - ISEL', 'carlos.goncalves@isel.pt');

-- --------------------------------------------------------

--
-- Estrutura da tabela `images`
--

CREATE TABLE `images` (
  `id` int(10) NOT NULL,
  `id_conteudo` int(10) NOT NULL,
  `img` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `images-config`
--

CREATE TABLE `images-config` (
  `id` int(11) NOT NULL,
  `destination` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `maxFileSize` int(11) NOT NULL,
  `thumbType` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `thumbWidth` int(11) NOT NULL,
  `thumbHeight` int(11) NOT NULL,
  `numColls` int(11) NOT NULL,
  `cellspacing` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `images-config`
--

INSERT INTO `images-config` (`id`, `destination`, `maxFileSize`, `thumbType`, `thumbWidth`, `thumbHeight`, `numColls`, `cellspacing`) VALUES
(1, 'C:\\Temp\\upload', 52428800, 'png', 80, 80, 3, 10);

-- --------------------------------------------------------

--
-- Estrutura da tabela `images-counters`
--

CREATE TABLE `images-counters` (
  `id` int(11) NOT NULL,
  `counterValue` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `images-counters`
--

INSERT INTO `images-counters` (`id`, `counterValue`) VALUES
(1, 16);

-- --------------------------------------------------------

--
-- Estrutura da tabela `images-details`
--

CREATE TABLE `images-details` (
  `id` int(11) NOT NULL,
  `fileName` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `mimeFileName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `typeFileName` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `imageFileName` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `imageMimeFileName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `imageTypeFileName` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `thumbFileName` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `thumbMimeFileName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `thumbTypeFileName` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `latitude` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `longitude` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(512) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `images-details`
--

INSERT INTO `images-details` (`id`, `fileName`, `mimeFileName`, `typeFileName`, `imageFileName`, `imageMimeFileName`, `imageTypeFileName`, `thumbFileName`, `thumbMimeFileName`, `thumbTypeFileName`, `latitude`, `longitude`, `title`, `description`) VALUES
(8, 'C:\\Temp\\upload\\índice.jpg', 'image', 'jpeg', 'C:\\Temp\\upload\\índice.jpg', 'image', 'jpeg', 'C:\\Temp\\upload\\thumbs\\índice.jpeg', 'image', 'jpeg', '', '', 'sdas', 'asdasd'),
(9, 'C:\\Temp\\upload\\índice.jpg', 'image', 'jpeg', 'C:\\Temp\\upload\\índice.jpg', 'image', 'jpeg', 'C:\\Temp\\upload\\thumbs\\índice.jpeg', 'image', 'jpeg', '', '', 'jkjkjh', 'jkhjghjgh'),
(10, 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\thumbs\\transferir.png', 'image', 'png', '', '', '', ''),
(11, 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\thumbs\\transferir.png', 'image', 'png', '', '', '', ''),
(12, 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\thumbs\\transferir.png', 'image', 'png', '', '', '', ''),
(13, 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\thumbs\\transferir.png', 'image', 'png', '', '', '', ''),
(14, 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\transferir.png', 'image', 'png', 'C:\\Temp\\upload\\thumbs\\transferir.png', 'image', 'png', '', '', '', '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `inscricao`
--

CREATE TABLE `inscricao` (
  `id` int(16) NOT NULL,
  `idCurso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `video`
--

CREATE TABLE `video` (
  `id` int(10) NOT NULL,
  `id_conteudo` int(10) NOT NULL,
  `video` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `auth-basic`
--
ALTER TABLE `auth-basic`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices para tabela `auth-roles`
--
ALTER TABLE `auth-roles`
  ADD PRIMARY KEY (`role`);

--
-- Índices para tabela `conteudo`
--
ALTER TABLE `conteudo`
  ADD PRIMARY KEY (`id_conteudo`);

--
-- Índices para tabela `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`id_curso`),
  ADD UNIQUE KEY `tag` (`tag`);

--
-- Índices para tabela `email-accounts`
--
ALTER TABLE `email-accounts`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `email-contacts`
--
ALTER TABLE `email-contacts`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `images-config`
--
ALTER TABLE `images-config`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `images-counters`
--
ALTER TABLE `images-counters`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `images-details`
--
ALTER TABLE `images-details`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `video`
--
ALTER TABLE `video`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `auth-basic`
--
ALTER TABLE `auth-basic`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `conteudo`
--
ALTER TABLE `conteudo`
  MODIFY `id_conteudo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `curso`
--
ALTER TABLE `curso`
  MODIFY `id_curso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `email-accounts`
--
ALTER TABLE `email-accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `email-contacts`
--
ALTER TABLE `email-contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `images`
--
ALTER TABLE `images`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `images-config`
--
ALTER TABLE `images-config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `images-counters`
--
ALTER TABLE `images-counters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `images-details`
--
ALTER TABLE `images-details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `video`
--
ALTER TABLE `video`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
