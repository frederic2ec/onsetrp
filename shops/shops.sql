SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP TABLE IF EXISTS `shops`;
CREATE TABLE IF NOT EXISTS `shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `z` int(11) NOT NULL,
  `h` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

INSERT INTO `shops` (`id`, `name`, `category`, `x`, `y`, `z`, `h`) VALUES
(1, 'twentyfour', 'miscellaneous', 128748, 77622, 1576, 90),
(2, 'twentyfour', 'miscellaneous', 42694, 137926, 1581, 90),
(3, 'twentyfour', 'miscellaneous', -15402, -2773, 2065, 90),
(4, 'twentyfour', 'miscellaneous', -169093, -39441, 1149, 90),
(5, 'twentyfour', 'miscellaneous', 171131, 203562, 1413, -180),
(6, 'gunshop', 'weapons', -181943, -40882, 1163, 90),
(7, 'gunshop', 'weapons', 206071, 193057, 1357, 180),
(8, 'rockshop', 'mine', 67862, 184741, 535, 90);

DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `weight` int(11) NOT NULL COMMENT 'in grams',
  `hunger` int(11) NOT NULL,
  `thirst` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

INSERT INTO `items` (`id`, `name`, `category`, `price`, `weight`, `hunger`, `thirst`) VALUES
(1, 'water_bottle', 'miscellaneous', 5, 1, 0, 30),
(2, 'apple', 'miscellaneous', 5, 500, 30, 0),
(3, 'donut', 'miscellaneous', 5, 500, 30, 0),
(4, 'repair_kit', 'miscellaneous', 50, 3000, 0, 0),
(5, 'health_kit', 'miscellaneous', 50, 3000, 0, 0),
(6, 'lockpick', 'miscellaneous', 500, 5000, 0, 0),
(7, 'pickaxe', 'miscellaneous', 20, 5000, 0, 0),
(8, 'jerican', 'miscellaneous', 50, 10000, 0, 0),
(9, 'phone', 'miscellaneous', 150, 500, 0, 0),
(10, 'fishing_rod', 'miscellaneous', 20, 2000, 0, 0),
(11, 'fish', 'miscellaneous', 100, 2000, 10, 0),
(12, 'weapon_2', 'weapons', 5000, 2000, 0, 0),
(13, 'weapon_3', 'weapons', 5000, 2000, 0, 0),
(14, 'weapon_4', 'weapons', 5000, 2000, 0, 0),
(15, 'weapon_5', 'weapons', 5000, 2000, 0, 0),
(16, 'weapon_6', 'weapons', 15000, 4000, 0, 0),
(17, 'weapon_7', 'weapons', 15000, 4000, 0, 0),
(18, 'weapon_8', 'weapons', 10000, 4000, 0, 0),
(19, 'weapon_9', 'weapons', 10000, 4000, 0, 0),
(20, 'weapon_10', 'weapons', 20000, 5000, 0, 0),
(21, 'weapon_11', 'weapons', 20000, 5000, 0, 0),
(22, 'weapon_12', 'weapons', 30000, 5000, 0, 0),
(23, 'weapon_13', 'weapons', 20000, 5000, 0, 0),
(24, 'weapon_14', 'weapons', 20000, 5000, 0, 0),
(25, 'weapon_15', 'weapons', 20000, 5000, 0, 0),
(26, 'weapon_16', 'weapons', 20000, 5000, 0, 0),
(27, 'weapon_17', 'weapons', 20000, 5000, 0, 0),
(28, 'weapon_18', 'weapons', 20000, 5000, 0, 0),
(29, 'weapon_19', 'weapons', 20000, 5000, 0, 0),
(30, 'weapon_20', 'weapons', 30000, 6000, 0, 0),
(31, 'processed_rock', 'mine', 160, 1000, 0, 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;