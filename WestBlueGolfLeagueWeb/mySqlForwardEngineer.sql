SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `westbluegolf` ;
CREATE SCHEMA IF NOT EXISTS `westbluegolf` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `westbluegolf` ;

-- -----------------------------------------------------
-- Table `westbluegolf`.`team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`team` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`team` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `teamName` VARCHAR(120) NOT NULL,
  `validTeam` TINYINT(1) NOT NULL,
  `modifiedDate` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE INDEX `teamNameIndex1` ON `westbluegolf`.`team` (`teamName` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`player`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`player` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`player` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `currentHandicap` INT NOT NULL,
  `favorite` TINYINT(1) NOT NULL,
  `teamId` INT NOT NULL,
  `validPlayer` TINYINT(1) NOT NULL,
  `modifiedDate` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_player_team`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_player_team_idx` ON `westbluegolf`.`player` (`teamId` ASC);

CREATE INDEX `playerName1` ON `westbluegolf`.`player` (`name` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`course` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`course` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `par` INT NOT NULL,
  `address` VARCHAR(80) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE INDEX `courseName1` ON `westbluegolf`.`course` (`name` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`year`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`year` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`year` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `value` INT NOT NULL,
  `isComplete` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE INDEX `yearValue` ON `westbluegolf`.`year` (`value` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`week`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`week` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`week` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `courseId` INT NOT NULL,
  `yearId` INT NOT NULL,
  `isBadData` TINYINT(1) NOT NULL,
  `seasonIndex` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_week_course1`
    FOREIGN KEY (`courseId`)
    REFERENCES `westbluegolf`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_week_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_week_course1_idx` ON `westbluegolf`.`week` (`courseId` ASC);

CREATE INDEX `fk_week_year1_idx` ON `westbluegolf`.`week` (`yearId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`startTime`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`startTime` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`startTime` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time` VARCHAR(45) NOT NULL,
  `startTime` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `westbluegolf`.`pairing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`pairing` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`pairing` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pairingText` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `westbluegolf`.`teamMatchup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`teamMatchup` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`teamMatchup` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NULL,
  `weekId` INT NOT NULL,
  `matchComplete` TINYINT(1) NOT NULL,
  `startTimeId` INT NULL,
  `matchId` INT NULL,
  `pairingId` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_team_matchup_week1`
    FOREIGN KEY (`weekId`)
    REFERENCES `westbluegolf`.`week` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_matchup_start_times1`
    FOREIGN KEY (`startTimeId`)
    REFERENCES `westbluegolf`.`startTime` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMatchup_pairings1`
    FOREIGN KEY (`pairingId`)
    REFERENCES `westbluegolf`.`pairing` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_team_matchup_week1_idx` ON `westbluegolf`.`teamMatchup` (`weekId` ASC);

CREATE INDEX `fk_team_matchup_start_times1_idx` ON `westbluegolf`.`teamMatchup` (`startTimeId` ASC);

CREATE INDEX `fk_teamMatchup_pairings1_idx` ON `westbluegolf`.`teamMatchup` (`pairingId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`matchup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`matchup` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`matchup` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `teamMatchupId` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_matchup_team_matchup1`
    FOREIGN KEY (`teamMatchupId`)
    REFERENCES `westbluegolf`.`teamMatchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_matchup_team_matchup1_idx` ON `westbluegolf`.`matchup` (`teamMatchupId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`result` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`result` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `priorHandicap` INT NOT NULL,
  `score` INT NOT NULL,
  `points` INT NOT NULL,
  `teamId` INT NOT NULL,
  `playerId` INT NOT NULL,
  `matchupId` INT NOT NULL,
  `yearId` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_result_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_matchup1`
    FOREIGN KEY (`matchupId`)
    REFERENCES `westbluegolf`.`matchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_result_team1_idx` ON `westbluegolf`.`result` (`teamId` ASC);

CREATE INDEX `fk_result_player1_idx` ON `westbluegolf`.`result` (`playerId` ASC);

CREATE INDEX `fk_result_matchup1_idx` ON `westbluegolf`.`result` (`matchupId` ASC);

CREATE INDEX `fk_result_year1_idx` ON `westbluegolf`.`result` (`yearId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`playerYearData`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`playerYearData` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`playerYearData` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `isRookie` TINYINT(1) NOT NULL,
  `startingHandicap` INT NOT NULL,
  `finishingHandicap` INT NOT NULL,
  `playerId` INT NOT NULL,
  `yearId` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_player_year_data_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_year_data_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_player_year_data_player1_idx` ON `westbluegolf`.`playerYearData` (`playerId` ASC);

CREATE INDEX `fk_player_year_data_year1_idx` ON `westbluegolf`.`playerYearData` (`yearId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`leaderBoard`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`leaderBoard` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`leaderBoard` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `isPlayerBoard` TINYINT(1) NOT NULL,
  `priority` INT NOT NULL,
  `key` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE INDEX `lookup` ON `westbluegolf`.`leaderBoard` (`key` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`leaderBoardData`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`leaderBoardData` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`leaderBoardData` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rank` INT NOT NULL,
  `value` DOUBLE NOT NULL,
  `leaderBoardId` INT NOT NULL,
  `yearId` INT NOT NULL,
  `isPlayer` TINYINT(1) NOT NULL,
  `teamId` INT NULL,
  `playerId` INT NULL,
  `detail` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_leader_board_data_leader_board1`
    FOREIGN KEY (`leaderBoardId`)
    REFERENCES `westbluegolf`.`leaderBoard` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leader_board_data_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leaderBoardData_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leaderBoardData_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_leader_board_data_leader_board1_idx` ON `westbluegolf`.`leaderBoardData` (`leaderBoardId` ASC);

CREATE INDEX `fk_leader_board_data_year1_idx` ON `westbluegolf`.`leaderBoardData` (`yearId` ASC);

CREATE INDEX `fk_leaderBoardData_team1_idx` ON `westbluegolf`.`leaderBoardData` (`teamId` ASC);

CREATE INDEX `fk_leaderBoardData_player1_idx` ON `westbluegolf`.`leaderBoardData` (`playerId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`dataMigration`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`dataMigration` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`dataMigration` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dataMigrationDate` DATETIME NOT NULL,
  `notes` VARCHAR(200) NULL,
  `yearId` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_dataMigration_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_dataMigration_year1_idx` ON `westbluegolf`.`dataMigration` (`yearId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`matchupToPlayer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`matchupToPlayer` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`matchupToPlayer` (
  `playerId` INT NOT NULL,
  `matchupId` INT NOT NULL,
  PRIMARY KEY (`playerId`, `matchupId`),
  CONSTRAINT `fk_matchupToPlayer_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_matchupToPlayer_matchup1`
    FOREIGN KEY (`matchupId`)
    REFERENCES `westbluegolf`.`matchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_matchupToPlayer_player1_idx` ON `westbluegolf`.`matchupToPlayer` (`playerId` ASC);

CREATE INDEX `fk_matchupToPlayer_matchup1_idx` ON `westbluegolf`.`matchupToPlayer` (`matchupId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`teamMatchupToTeam`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`teamMatchupToTeam` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`teamMatchupToTeam` (
  `teamMatchupId` INT NOT NULL,
  `teamId` INT NOT NULL,
  PRIMARY KEY (`teamMatchupId`, `teamId`),
  CONSTRAINT `fk_teamMatchupToTeam_teamMatchup1`
    FOREIGN KEY (`teamMatchupId`)
    REFERENCES `westbluegolf`.`teamMatchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMatchupToTeam_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_teamMatchupToTeam_teamMatchup1_idx` ON `westbluegolf`.`teamMatchupToTeam` (`teamMatchupId` ASC);

CREATE INDEX `fk_teamMatchupToTeam_team1_idx` ON `westbluegolf`.`teamMatchupToTeam` (`teamId` ASC);


-- -----------------------------------------------------
-- Table `westbluegolf`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`user` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`user` (
  `id` INT NOT NULL,
  `username` VARCHAR(100) BINARY NOT NULL,
  `passwordHash` VARCHAR(200) NOT NULL,
  `salt` VARCHAR(45) NOT NULL,
  `dateAdded` DATETIME NOT NULL,
  `email` VARCHAR(120) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `westbluegolf`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `westbluegolf`;
INSERT INTO `westbluegolf`.`user` (`id`, `username`, `passwordHash`, `salt`, `dateAdded`, `email`) VALUES (1, 'admin', '4AE41260B4CA1A93852A3F05CE1D90D85DE30224CD0539331BAD671E4A1D1A00', '839202910', '2014-04-19', 'polaris878@gmail.com');

COMMIT;

