SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

ALTER TABLE `accounts`
	ADD `driver_license` tinyint(1) NOT NULL DEFAULT 0;

ALTER TABLE `accounts`
	ADD `gun_license` tinyint(1) NOT NULL DEFAULT 0;

ALTER TABLE `accounts`
	ADD `helicopter_license` tinyint(1) NOT NULL DEFAULT 0;

COMMIT;