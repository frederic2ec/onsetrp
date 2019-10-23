-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 23, 2019 at 08:24 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `roleplay`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `admin` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armor` float NOT NULL DEFAULT 0,
  `thirst` float NOT NULL DEFAULT 100,
  `hunger` float NOT NULL DEFAULT 100,
  `cash` int(11) DEFAULT 1000,
  `bank_balance` int(11) NOT NULL DEFAULT 0,
  `model` float NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `id` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `atm`
--

INSERT INTO `atm` (`id`, `modelid`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
(1, 494, 129221, 78053, 1478, 0, 90, 0);

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(10) UNSIGNED NOT NULL,
  `ban_time` int(10) UNSIGNED NOT NULL,
  `reason` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `garage_dealer`
--

CREATE TABLE `garage_dealer` (
  `id` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `h` float NOT NULL,
  `spawnx` float NOT NULL,
  `spawny` float NOT NULL,
  `spawnz` float NOT NULL,
  `spawnh` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `garage_dealer`
--

INSERT INTO `garage_dealer` (`id`, `modelid`, `x`, `y`, `z`, `h`, `spawnx`, `spawny`, `spawnz`, `spawnh`) VALUES
(1, 15, 126574, 74560, 1567, 90, 127533, 75598, 1567, 90);

-- --------------------------------------------------------

--
-- Table structure for table `garage_store`
--

CREATE TABLE `garage_store` (
  `id` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `garage_store`
--

INSERT INTO `garage_store` (`id`, `modelid`, `x`, `y`, `z`) VALUES
(1, 2, 127542, 75351, 1567),
(2, 2, 128002, 75351, 1567),
(3, 2, 128557, 75351, 1567),
(4, 2, 129013, 75351, 1567);

-- --------------------------------------------------------

--
-- Table structure for table `ipbans`
--

CREATE TABLE `ipbans` (
  `ip` varchar(16) NOT NULL,
  `ban_time` int(10) UNSIGNED NOT NULL,
  `reason` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_data`
--

CREATE TABLE `player_data` (
  `id` int(11) NOT NULL,
  `steamID` varchar(50) NOT NULL,
  `server_data` varchar(300) DEFAULT NULL,
  `synced_data` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `player_garage`
--

CREATE TABLE `player_garage` (
  `id` int(10) UNSIGNED NOT NULL,
  `ownerid` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `garage` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_dealer`
--

CREATE TABLE `vehicle_dealer` (
  `id` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `h` float NOT NULL,
  `spawnx` float NOT NULL,
  `spawny` float NOT NULL,
  `spawnz` float NOT NULL,
  `spawnh` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `vehicle_dealer`
--

INSERT INTO `vehicle_dealer` (`id`, `modelid`, `x`, `y`, `z`, `h`, `spawnx`, `spawny`, `spawnz`, `spawnh`) VALUES
(1, 5, 128990, 80774, 1567, 180, 127720, 80774, 1567, 180);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_price`
--

CREATE TABLE `vehicle_price` (
  `id` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `vehicle_price`
--

INSERT INTO `vehicle_price` (`id`, `modelid`, `name`, `price`) VALUES
(1, 1, 'Sedan 01', 1000),
(2, 4, 'Sedan 03', 1000),
(3, 5, 'Sedan 03', 1000),
(4, 6, 'Nascar', 1000),
(5, 7, 'Truck', 1000),
(6, 11, 'Coupe', 1000),
(7, 12, 'Rally', 1000);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `garage_dealer`
--
ALTER TABLE `garage_dealer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `garage_store`
--
ALTER TABLE `garage_store`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ipbans`
--
ALTER TABLE `ipbans`
  ADD PRIMARY KEY (`ip`);

--
-- Indexes for table `player_data`
--
ALTER TABLE `player_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `player_garage`
--
ALTER TABLE `player_garage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_vehicle_ibfk_1` (`ownerid`);

--
-- Indexes for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_price`
--
ALTER TABLE `vehicle_price`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `garage_dealer`
--
ALTER TABLE `garage_dealer`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `garage_store`
--
ALTER TABLE `garage_store`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `player_data`
--
ALTER TABLE `player_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_garage`
--
ALTER TABLE `player_garage`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vehicle_price`
--
ALTER TABLE `vehicle_price`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bans`
--
ALTER TABLE `bans`
  ADD CONSTRAINT `bans_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_garage`
--
ALTER TABLE `player_garage`
  ADD CONSTRAINT `player_garage_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
