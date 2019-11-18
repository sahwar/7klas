-- MySQL Workbench Synchronization
-- Generated: 2019-11-18 18:32
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: admin

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `7klas` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `7klas`.`schools` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `short_name` VARCHAR(32) NOT NULL,
  `telephone` VARCHAR(32) NULL DEFAULT NULL,
  `address` VARCHAR(128) NULL DEFAULT NULL,
  `email` VARCHAR(64) NULL DEFAULT NULL,
  `url` VARCHAR(128) NULL DEFAULT NULL,
  `city_id` INT(11) NOT NULL,
  `district_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_sch_city_idx` (`city_id` ASC) VISIBLE,
  INDEX `fk_sch_district_idx` (`district_id` ASC) VISIBLE,
  CONSTRAINT `fk_sch_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `7klas`.`cities` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sch_district`
    FOREIGN KEY (`district_id`)
    REFERENCES `7klas`.`districts` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`districts` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `num` INT(11) NOT NULL,
  `city_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_reg_city_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `fk_reg_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `7klas`.`cities` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`cities` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`classes` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `numcl` INT(11) NOT NULL COMMENT 'Number of classes',
  `yr` YEAR NOT NULL COMMENT 'School year starting',
  `coef_bel` INT(11) NOT NULL COMMENT 'Coeficient for BEL result',
  `coef_mat` VARCHAR(45) NOT NULL COMMENT 'Coeficient for MAT result',
  `subj1_id` VARCHAR(5) NOT NULL COMMENT 'Subject 1',
  `subj2_id` VARCHAR(5) NOT NULL COMMENT 'Subject 2',
  `school_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`, `yr`),
  INDEX `fk_class_school_idx` (`school_id` ASC) VISIBLE,
  INDEX `fk_class_subj1_idx` (`subj1_id` ASC) VISIBLE,
  INDEX `fk_class_subj2_idx` (`subj2_id` ASC) VISIBLE,
  CONSTRAINT `fk_class_school`
    FOREIGN KEY (`school_id`)
    REFERENCES `7klas`.`schools` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_class_subj1`
    FOREIGN KEY (`subj1_id`)
    REFERENCES `7klas`.`subjects` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_class_subj2`
    FOREIGN KEY (`subj2_id`)
    REFERENCES `7klas`.`subjects` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`subjects` (
  `id` VARCHAR(5) NOT NULL,
  `name` VARCHAR(42) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`students` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL COMMENT 'Full name',
  `score_nea_bel` INT(11) NOT NULL COMMENT 'Score from National External Assesment BEL',
  `score_nea_mat` INT(11) NOT NULL COMMENT 'Score from National External Assesment MAT',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`subj_marks` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `student_id` INT(11) NOT NULL,
  `subject_id` VARCHAR(5) NOT NULL,
  `mark` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_sm_student_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_sm_subject_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `fk_sm_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `7klas`.`students` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sm_subject`
    FOREIGN KEY (`subject_id`)
    REFERENCES `7klas`.`subjects` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `7klas`.`class_rankings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `yr` YEAR NOT NULL,
  `min_rank_I` DECIMAL(5,2) NOT NULL COMMENT 'Minimal rank from Ist ranking',
  `min_rank_II` DECIMAL(5,2) NOT NULL COMMENT 'Minimal rank from IInd ranking',
  `max_rank_I` DECIMAL(5,2) NOT NULL COMMENT 'Maximal rank from Ist ranking',
  `max_rank_II` VARCHAR(45) NOT NULL COMMENT 'Maximal rank from IInd ranking',
  PRIMARY KEY (`id`),
  INDEX `fk_cr_class_idx` (`class_id` ASC, `yr` ASC) VISIBLE,
  CONSTRAINT `fk_cr_class`
    FOREIGN KEY (`class_id` , `yr`)
    REFERENCES `7klas`.`classes` (`id` , `yr`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Placeholder table for view `7klas`.`ClassRanks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `7klas`.`ClassRanks` (`clsYear` INT, `schlName` INT, `clsName` INT, `min_rank_I` INT, `min_rank_II` INT);

-- -----------------------------------------------------
-- Placeholder table for view `7klas`.`ClassRanksJSON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `7klas`.`ClassRanksJSON` (`json_obj` INT);


USE `7klas`;

-- -----------------------------------------------------
-- View `7klas`.`ClassRanks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `7klas`.`ClassRanks`;
USE `7klas`;
CREATE  OR REPLACE VIEW ClassRanks AS
SELECT CAST(CR.yr AS CHAR(4)) clsYear,
       CONCAT(SC.id, ' ', SC.short_name) schlName,
       CONCAT(SUBSTR(CONVERT(CL.id, CHAR), 5), ' ', CL.`name`)     clsName,
       CR.min_rank_I,
       CR.min_rank_II
  FROM classes        CL,
       class_rankings CR,
       schools        SC
 WHERE CR.class_id  = CL.id
   AND CR.yr        = CL.yr
   AND CL.school_id = SC.id
 ORDER BY CR.yr, CR.min_rank_II DESC;


USE `7klas`;

-- -----------------------------------------------------
-- View `7klas`.`ClassRanksJSON`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `7klas`.`ClassRanksJSON`;
USE `7klas`;
CREATE  OR REPLACE VIEW ClassRanksJSON AS
SELECT JSON_OBJECT("clsYear"    , clsYear,
                   "schlName"   , schlName,
                   "clsName"    , clsName,
                   "min_rank_I" , min_rank_I,
                   "min_rank_II", min_rank_II
                  ) json_obj
  FROM ClassRanks;

DELIMITER //
USE `7klas`//
CREATE FUNCTION mark_to_score(mark INT)
  RETURNS INT
  DETERMINISTIC
BEGIN
  DECLARE score INT;

  SET score := CASE mark
    WHEN 6 THEN 50
    WHEN 5 THEN 39
    WHEN 4 THEN 26
    WHEN 3 THEN 15
    ELSE 0
  END;

  RETURN score;
END//

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
