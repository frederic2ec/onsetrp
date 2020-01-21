-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 15, 2020 at 01:14 AM
-- Server version: 10.3.15-MariaDB
-- PHP Version: 7.3.6

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
  `name` varchar(255) NOT NULL DEFAULT 'Unregistered',
  `clothing` text NOT NULL,
  `police` tinyint(1) NOT NULL DEFAULT 0,
  `medic` tinyint(1) NOT NULL DEFAULT 0,
  `inventory` text NOT NULL,
  `position` text NOT NULL,
  `admin` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `health_state` varchar(255) NOT NULL DEFAULT 'alive',
  `death_pos` text NOT NULL,
  `armor` float NOT NULL DEFAULT 0,
  `thirst` float NOT NULL DEFAULT 100,
  `hunger` float NOT NULL DEFAULT 100,
  `bank_balance` int(11) NOT NULL DEFAULT 900,
  `created` tinyint(1) NOT NULL DEFAULT 0,
  `phone_number` varchar(255) DEFAULT NULL,
  `driver_license` tinyint(1) NOT NULL DEFAULT 0,
  `gun_license` tinyint(1) NOT NULL DEFAULT 0,
  `helicopter_license` tinyint(1) NOT NULL DEFAULT 0,
  `drug_knowledge` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(10) UNSIGNED NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `ban_time` int(10) UNSIGNED NOT NULL,
  `reason` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `subcategory` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `weight` int(11) NOT NULL COMMENT 'in grams',
  `hunger` int(11) NOT NULL,
  `thirst` int(11) NOT NULL,
  `equipable` TINYINT NOT NULL DEFAULT 0,
  `usable` TINYINT NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `name`, `category`, `subcategory`, `price`, `weight`, `hunger`, `thirst`, `equipable`, `usable`) VALUES
	(1, 'water_bottle', 'miscellaneous', 'food', 5, 500, 0, 30, 0, 1),
	(2, 'apple', 'miscellaneous', 'food', 5, 100, 30, 0, 0, 1),
	(3, 'donut', 'miscellaneous', 'food', 5, 100, 30, 0, 0, 1),
	(4, 'repair_kit', 'miscellaneous', 'object', 50, 3000, 0, 0, 0, 1),
	(5, 'health_kit', 'miscellaneous', 'object', 50, 300, 0, 0, 0, 1),
	(6, 'lockpick', 'miscellaneous', 'object', 500, 500, 0, 0, 0, 1),
	(7, 'pickaxe', 'miscellaneous', 'tool', 20, 3000, 0, 0, 0, 1),
	(8, 'jerican', 'miscellaneous', 'object', 50, 5000, 0, 0, 0, 1),
	(9, 'phone', 'miscellaneous', 'object', 150, 200, 0, 0, 0, 1),
	(10, 'fishing_rod', 'miscellaneous', 'tool', 20, 1000, 0, 0, 0, 1),
	(11, 'fish', 'miscellaneous', 'food', 100, 500, 10, 0, 0, 1),
	(12, 'weapon_2', 'weapons', 'weapon', 5000, 2000, 0, 0, 0, 1),
	(13, 'weapon_3', 'weapons', 'weapon', 5000, 2000, 0, 0, 0, 1),
	(14, 'weapon_4', 'weapons', 'weapon', 5000, 2000, 0, 0, 0, 1),
	(15, 'weapon_5', 'weapons', 'weapon', 5000, 2000, 0, 0, 0, 1),
	(16, 'weapon_6', 'weapons', 'weapon', 15000, 4000, 0, 0, 0, 1),
	(17, 'weapon_7', 'weapons', 'weapon', 15000, 4000, 0, 0, 0, 1),
	(18, 'weapon_8', 'weapons', 'weapon', 10000, 4000, 0, 0, 0, 1),
	(19, 'weapon_9', 'weapons', 'weapon', 10000, 4000, 0, 0, 0, 1),
	(20, 'weapon_10', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(21, 'weapon_11', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(22, 'weapon_12', 'weapons', 'weapon', 30000, 5000, 0, 0, 0, 1),
	(23, 'weapon_13', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(24, 'weapon_14', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(25, 'weapon_15', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(26, 'weapon_16', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(27, 'weapon_17', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(28, 'weapon_18', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(29, 'weapon_19', 'weapons', 'weapon', 20000, 5000, 0, 0, 0, 1),
	(30, 'weapon_20', 'weapons', 'weapon', 30000, 6000, 0, 0, 0, 1),
	(31, 'weapon_21', 'weapons', 'weapon', 5000, 2000, 0, 0, 0, 1),
	(32, 'processed_rock', 'mine', 'object', 160, 1000, 0, 0, 0, 0),
	(33, 'peach', 'miscellaneous', 'food', 12, 100, 30, 5, 0, 1),
	(34, 'item_backpack', 'miscellaneous', 'object', 150, 1, 0, 0, 1, 0),
	(35, 'coca_leaf', 'drugs', 'drugs', 0, 200, 0, 0, 0, 0),
	(36, 'cocaine', 'drugs', 'drugs', 0, 200, 0, 0, 0, 1),
	(37, 'lumberjack_axe', 'miscellaneous', 'tool', 100, 3200, 0, 0, 0, 0),
	(38, 'tree_log', 'job_item', 'resource', 0, 2000, 0, 0, 0, 0),
	(39, 'wood_plank', 'job_item', 'resource', 0, 1000, 0, 0, 0, 0),
	(40, 'treated_wood_plank', 'job_item', 'resource', 0, 1000, 0, 0, 0, 0),
	(41, 'lumberjack_saw', 'miscellaneous', 'tool', 70, 1000, 0, 0, 0, 0),
	(42, 'handcuffs', 'miscellaneous', 'tool', 1000, 1000, 0, 0, 0, 0),
	(43, 'unprocessed_rock', 'mine', 'object', 0, 1000, 0, 0, 0, 0);


--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `action` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `from` varchar(255) NOT NULL DEFAULT '0',
  `to` varchar(255) NOT NULL DEFAULT '0',
  `content` text NOT NULL,
  `created_at` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `phone_contacts`
--

CREATE TABLE `phone_contacts` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner_id` int(10) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `player_garage`
--

CREATE TABLE `player_garage` (
  `id` int(10) UNSIGNED NOT NULL,
  `ownerid` int(10) UNSIGNED NOT NULL,
  `modelid` mediumint(8) UNSIGNED NOT NULL,
  `color` varchar(255) NOT NULL,
  `garage` tinyint(1) NOT NULL,
  `price` int(11) NOT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `inventory` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `player_house`
--

CREATE TABLE `player_house` (
  `id` int(10) UNSIGNED NOT NULL,
  `ownerid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `spawn` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_house`
--

INSERT INTO `player_house` (`id`, `ownerid`, `spawn`) VALUES
(1, 0, 0),
(2, 0, 0),
(3, 0, 0),
(4, 0, 0),
(5, 0, 0),
(6, 0, 0),
(7, 0, 0),
(8, 0, 0),
(9, 0, 0),
(10, 0, 0),
(11, 0, 0),
(12, 0, 0),
(13, 0, 0),
(14, 0, 0),
(15, 0, 0),
(16, 0, 0),
(17, 0, 0),
(18, 0, 0),
(19, 0, 0),
(20, 0, 0),
(21, 0, 0),
(22, 0, 0),
(23, 0, 0),
(24, 0, 0),
(25, 0, 0),
(26, 0, 0),
(27, 0, 0),
(28, 0, 0),
(29, 0, 0),
(30, 0, 0),
(31, 0, 0),
(32, 0, 0),
(33, 0, 0),
(34, 0, 0),
(35, 0, 0),
(36, 0, 0),
(37, 0, 0),
(38, 0, 0),
(39, 0, 0),
(40, 0, 0),
(41, 0, 0),
(42, 0, 0),
(43, 0, 0),
(44, 0, 0),
(45, 0, 0),
(46, 0, 0),
(47, 0, 0),
(48, 0, 0),
(49, 0, 0),
(50, 0, 0),
(51, 0, 0),
(52, 0, 0),
(53, 0, 0),
(54, 0, 0),
(55, 0, 0),
(56, 0, 0),
(57, 0, 0),
(58, 0, 0),
(59, 0, 0),
(60, 0, 0),
(61, 0, 0),
(62, 0, 0),
(63, 0, 0),
(64, 0, 0),
(65, 0, 0),
(66, 0, 0),
(67, 0, 0),
(68, 0, 0),
(69, 0, 0),
(70, 0, 0),
(71, 0, 0),
(72, 0, 0),
(73, 0, 0),
(74, 0, 0),
(75, 0, 0),
(76, 0, 0),
(77, 0, 0),
(78, 0, 0),
(79, 0, 0),
(80, 0, 0),
(81, 0, 0),
(82, 0, 0),
(83, 0, 0),
(84, 0, 0),
(85, 0, 0),
(86, 0, 0),
(87, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `z` int(11) NOT NULL,
  `h` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `name`, `category`, `x`, `y`, `z`, `h`) VALUES
(1, 'twentyfour', 'miscellaneous', 128748, 77622, 1576, 90),
(2, 'twentyfour', 'miscellaneous', 42694, 137926, 1581, 90),
(3, 'twentyfour', 'miscellaneous', -15402, -2773, 2065, 90),
(4, 'twentyfour', 'miscellaneous', -169093, -39441, 1149, 90),
(5, 'twentyfour', 'miscellaneous', 171131, 203562, 1413, -180),
(6, 'gunshop', 'weapons', -181943, -40882, 1163, 90),
(7, 'gunshop', 'weapons', 206071, 193057, 1357, 180),
(8, 'rockshop', 'mine', 67862, 184741, 535, 90);

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE `whitelist` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ipbans`
--
ALTER TABLE `ipbans`
  ADD PRIMARY KEY (`ip`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `phone_contacts`
--
ALTER TABLE `phone_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `player_garage`
--
ALTER TABLE `player_garage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_vehicle_ibfk_1` (`ownerid`);

--
-- Indexes for table `player_house`
--
ALTER TABLE `player_house`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `whitelist`
--
ALTER TABLE `whitelist`
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
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_contacts`
--
ALTER TABLE `phone_contacts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_garage`
--
ALTER TABLE `player_garage`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_house`
--
ALTER TABLE `player_house`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `whitelist`
--
ALTER TABLE `whitelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `player_garage`
--
ALTER TABLE `player_garage`
  ADD CONSTRAINT `player_garage_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
