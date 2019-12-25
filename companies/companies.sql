SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `companies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `money` int(10) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE `accounts`
	ADD `company_id` VARCHAR(255) DEFAULT NULL;

ALTER TABLE `accounts`
	ADD `company_job` VARCHAR(255) DEFAULT NULL;

INSERT INTO `companies` (`id`,`money`,`name`) VALUES ('1','1000','Police');
INSERT INTO `companies` (`id`,`money`,`name`) VALUES ('2','1000','Mine');
INSERT INTO `companies` (`id`,`money`,`name`) VALUES ('3','1000','Peche');
INSERT INTO `companies` (`id`,`money`,`name`) VALUES ('4','1000','Phone');
INSERT INTO `companies` (`id`,`money`,`name`) VALUES ('5','1000','Pavlovena Compagny');

COMMIT;