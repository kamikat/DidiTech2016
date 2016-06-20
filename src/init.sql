-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema didi
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `didi` ;

-- -----------------------------------------------------
-- Schema didi
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `didi` DEFAULT CHARACTER SET utf8 ;
USE `didi` ;

-- -----------------------------------------------------
-- Table `didi`.`weather`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `didi`.`weather` ;

CREATE TABLE IF NOT EXISTS `didi`.`weather` (
  `date` VARCHAR(45) NULL,
  `time_slot` INT NULL,
  `weather` INT NULL,
  `temperature` DOUBLE NULL,
  `pm25` DOUBLE NULL
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `didi`.`traffic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `didi`.`traffic` ;

CREATE TABLE IF NOT EXISTS `didi`.`traffic` (
  `district_hash` VARCHAR(45) NOT NULL,
  `level_1` INT NULL,
  `level_2` INT NULL,
  `level_3` INT NULL,
  `level_4` INT NULL,
  `date` VARCHAR(45) NULL,
  `time_slot` INT NULL,
  PRIMARY KEY (`district_hash`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `didi`.`district`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `didi`.`district` ;

CREATE TABLE IF NOT EXISTS `didi`.`district` (
  `district_hash` VARCHAR(45) NOT NULL,
  `district_id` INT NULL,
  `poi_1` INT NULL,
  `poi_2` INT NULL,
  `poi_3` INT NULL,
  PRIMARY KEY (`district_hash`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `didi`.`calendar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `didi`.`calendar` ;

CREATE TABLE IF NOT EXISTS `didi`.`calendar` (
  `date` VARCHAR(45) NOT NULL,
  `is_holiday` TINYINT(1) NULL,
  PRIMARY KEY (`date`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `didi`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `didi`.`order` ;

CREATE TABLE IF NOT EXISTS `didi`.`order` (
  `order_id` VARCHAR(45) NOT NULL,
  `driver_id` VARCHAR(45) NULL,
  `passenger_id` VARCHAR(45) NULL,
  `start_district_hash` VARCHAR(45) NULL,
  `dest_district_hash` VARCHAR(45) NULL,
  `price` DOUBLE NULL,
  `date` VARCHAR(45) NULL,
  `time_slot` INT NULL,
  PRIMARY KEY (`order_id`)
)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

