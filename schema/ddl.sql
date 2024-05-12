-- MySQL Script generated by MySQL Workbench
-- Sat May 11 13:27:07 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cooking_competition
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cooking_competition
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cooking_competition` DEFAULT CHARACTER SET utf8 ;
USE `cooking_competition` ;

-- -----------------------------------------------------
-- Table `cooking_competition`.`Image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Image` (
  `ImageID` INT NOT NULL AUTO_INCREMENT,
  `ImageDescription` VARCHAR(45) NULL,
  `ImageFile` BLOB NOT NULL,
  PRIMARY KEY (`ImageID`),
  UNIQUE (`ImageID`)
  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`EthnicCuisine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`EthnicCuisine` (
  `CuisineID` INT NOT NULL AUTO_INCREMENT,
  `CuisineName` VARCHAR(45) NULL,
  `ImageID` INT NULL,
  PRIMARY KEY (`CuisineID`),
  UNIQUE (`CuisineID`),
  INDEX `ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `EthnicCuisine_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`FoodGroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`FoodGroup` (
  `GroupID` INT NOT NULL AUTO_INCREMENT,
  `GroupName` VARCHAR(45) NOT NULL,
  `GroupDescription` VARCHAR(45) NOT NULL,
  `ImageID` INT NULL,
  PRIMARY KEY (`GroupID`),
  UNIQUE (`GroupID`),
  CONSTRAINT `FoodGroup_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Ingredient` (
  `IngredientID` INT NOT NULL AUTO_INCREMENT,
  `IngredientName` VARCHAR(45) NOT NULL,
  `ImageID` INT NULL,
  `GroupID` INT NOT NULL,
  PRIMARY KEY (`IngredientID`),
  UNIQUE (`IngredientID`),
  INDEX `GroupID_idx` (`GroupID` ASC) ,
  INDEX `ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `Ingredient_GroupID`
    FOREIGN KEY (`GroupID`)
    REFERENCES `cooking_competition`.`FoodGroup` (`GroupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IngredientImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Recipe` (
  `RecipeID` INT NOT NULL AUTO_INCREMENT,
  `RecipeName` VARCHAR(45) NOT NULL,
  `IsBaking` INT NULL,
  `DifficultyLevel` INT NOT NULL,
  `Description` VARCHAR(200) NULL,
  `PreparationTime` INT NULL,
  `CookingTime` INT NULL,
  `NumberOfPortions` INT NOT NULL,
  `ImageID` INT NULL,
  `CuisineID` INT NOT NULL,
  `MainIngredientID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`),
  UNIQUE (`RecipeID`),
  CHECK (`DifficultyLevel` in (1, 2, 3, 4, 5)),
  CHECK (`IsBaking` in (0, 1)),
  INDEX `Recipe_CuisineID_idx` (`CuisineID` ASC) ,
  INDEX `Recipe_MainIngredientID_idx` (`MainIngredientID` ASC) ,
  INDEX `Recipe_ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `Recipe_CuisineID`
    FOREIGN KEY (`CuisineID`)
    REFERENCES `cooking_competition`.`EthnicCuisine` (`CuisineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Recipe_MainIngredientID`
    FOREIGN KEY (`MainIngredientID`)
    REFERENCES `cooking_competition`.`Ingredient` (`IngredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Recipe_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Label` (
  `LabelID` INT NOT NULL AUTO_INCREMENT,
  `LabelName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LabelID`),
  UNIQUE (`LabelID`)
  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`MealCategory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`MealCategory` (
  `CategoryID` INT NOT NULL AUTO_INCREMENT,
  `CategoryName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE (`CategoryID`)
  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Tips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Tips` (
  `TipsID` INT NOT NULL AUTO_INCREMENT,
  `TipsDescription` VARCHAR(100) NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`TipsID`),
  UNIQUE (`TipsID`),
  INDEX `Tips_RecipeID_idx` (`RecipeID` ASC) ,
  CONSTRAINT `Tips_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Step`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Step` (
  `StepID` INT NOT NULL AUTO_INCREMENT,
  `StepNumber` INT NOT NULL,
  `StepDescription` VARCHAR(100) NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`StepID`),
  UNIQUE (`StepID`),
  INDEX `Tips_RecipeID_idx` (`RecipeID` ASC) ,
  CONSTRAINT `Step_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`MealCategory_Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`MealCategory_Recipe` (
  `RecipeID` INT NOT NULL,
  `MealCategoryID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `MealCategoryID`),
  INDEX `MealCategory_Recipe_MealCategoryID_idx` (`MealCategoryID` ASC) ,
  CONSTRAINT `MealCategory_Recipe_MealCategoryID`
    FOREIGN KEY (`MealCategoryID`)
    REFERENCES `cooking_competition`.`MealCategory` (`CategoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MealCategory_Recipe_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Recipe_Label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Recipe_Label` (
  `RecipeID` INT NOT NULL,
  `LabelID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `LabelID`),
  INDEX `fk_Recipe_has_Label_Recipe1_idx` (`RecipeID` ASC) ,
  INDEX `Recipe_label_LabelID_idx` (`LabelID` ASC) ,
  CONSTRAINT `Recipe_Label_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Recipe_label_LabelID`
    FOREIGN KEY (`LabelID`)
    REFERENCES `cooking_competition`.`Label` (`LabelID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Equipment` (
  `EquipmentID` INT NOT NULL AUTO_INCREMENT,
  `EquipmentName` VARCHAR(45) NOT NULL,
  `EquipmentInstructions` VARCHAR(200) NULL,
  `ImageID` INT NULL,
  PRIMARY KEY (`EquipmentID`),
  UNIQUE (`EquipmentID`),
  INDEX `Equipment_ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `Equipment_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Recipe_Equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Recipe_Equipment` (
  `RecipeID` INT NOT NULL,
  `EquipmentID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `EquipmentID`),
  INDEX `Recipe_Equipment_EquipmentID_idx` (`EquipmentID` ASC) ,
  CONSTRAINT `Recipe_Equipment_EquipmentID`
    FOREIGN KEY (`EquipmentID`)
    REFERENCES `cooking_competition`.`Equipment` (`EquipmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Recipe_Equipment_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`ThematicUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`ThematicUnit` (
  `ThematicUnitID` INT NOT NULL AUTO_INCREMENT,
  `ThematicUnitName` VARCHAR(45) NOT NULL,
  `ThematicUnitDescription` VARCHAR(45) NOT NULL,
  `ImageID` INT NULL,
  PRIMARY KEY (`ThematicUnitID`),
  UNIQUE (`ThematicUnitID`),
  INDEX `ThematicUnit_ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `ThematicUnit_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`RecipeThematicUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`RecipeThematicUnit` (
  `RecipeID` INT NOT NULL,
  `ThematicUnitID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `ThematicUnitID`),
  INDEX `Recipe_ThematicUnit_ThematicUnitID_idx` (`ThematicUnitID` ASC) ,
  CONSTRAINT `Recipe_ThematicUnit_ThematicUnitID`
    FOREIGN KEY (`ThematicUnitID`)
    REFERENCES `cooking_competition`.`ThematicUnit` (`ThematicUnitID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Recipe_ThematicUnit_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`StandardUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`StandardUnit` (
  `StandardUnitID` INT NOT NULL AUTO_INCREMENT,
  `StandardUnitName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StandardUnitID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Unit` (
  `UnitID` INT NOT NULL,
  `UnitName` VARCHAR(45) NOT NULL,
  `UnitConvertValue` INT NOT NULL,
  `StandardUnit_ID` INT NOT NULL,
  PRIMARY KEY (`UnitID`),
  INDEX `Unit_StandardUnitID_idx` (`StandardUnit_ID` ASC) ,
  CONSTRAINT `Unit_StandardUnitID`
    FOREIGN KEY (`StandardUnit_ID`)
    REFERENCES `cooking_competition`.`StandardUnit` (`StandardUnitID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Quantity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Quantity` (
  `QuantityID` INT NOT NULL AUTO_INCREMENT,
  `QuantityValue` INT NOT NULL,
  `RecipeID` INT NOT NULL,
  `IngredientID` INT NOT NULL,
  `UnitID` INT NOT NULL,
  PRIMARY KEY (`QuantityID`),
  UNIQUE INDEX `QuantityID_UNIQUE` (`QuantityID` ASC) ,
  INDEX `Quantity_RecipeID_idx` (`RecipeID` ASC) ,
  INDEX `Quantity_UnitID_idx` (`UnitID` ASC) ,
  INDEX `Qunatity_IngredientID_idx` (`IngredientID` ASC) ,
  CONSTRAINT `Qunatity_IngredientID`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `cooking_competition`.`Ingredient` (`IngredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Quantity_UnitID`
    FOREIGN KEY (`UnitID`)
    REFERENCES `cooking_competition`.`Unit` (`UnitID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Quantity_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`NutritionalContent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`NutritionalContent` (
  `NutritionalContentID` INT NOT NULL,
  `FatsPer100` INT NOT NULL,
  `ProteinPer100` INT NOT NULL,
  `CarbsPer100` INT NULL,
  `CaloriesPer100` INT NOT NULL,
  `IngredientID` INT NOT NULL,
  PRIMARY KEY (`NutritionalContentID`),
  UNIQUE INDEX `NutritionalContentID_UNIQUE` (`NutritionalContentID` ASC) ,
  INDEX `NutritionalContent_IngredientID_idx` (`IngredientID` ASC) ,
  CONSTRAINT `NutritionalContent_IngredientID`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `cooking_competition`.`Ingredient` (`IngredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Cook`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Cook` (
  `CookID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `BirthDate` DATE NOT NULL,
  `ExperienceYears` INT NOT NULL,
  `TrainingLevel` VARCHAR(45) NOT NULL,
  `ImageID` INT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  CHECK (`TrainingLevel` in ("C cook", "B cook", "A cook", "sous chef", "chef")),
  PRIMARY KEY (`CookID`),
  INDEX `Cook_ImageID_idx` (`ImageID` ASC) ,
  CONSTRAINT `Cook_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `cooking_competition`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Expertise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Expertise` (
  `CookID` INT NOT NULL,
  `CuisineID` INT NOT NULL,
  PRIMARY KEY (`CookID`, `CuisineID`),
  INDEX `Expertise_CuisineID_idx` (`CuisineID` ASC) ,
  CONSTRAINT `Expertise_CuisineID`
    FOREIGN KEY (`CuisineID`)
    REFERENCES `cooking_competition`.`EthnicCuisine` (`CuisineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Expertise_CookID`
    FOREIGN KEY (`CookID`)
    REFERENCES `cooking_competition`.`Cook` (`CookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Season`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Season` (
  `SeasonID` INT NOT NULL AUTO_INCREMENT,
  `Year` INT NOT NULL,
  PRIMARY KEY (`SeasonID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Episode`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Episode` (
  `EpisodeID` INT NOT NULL,
  `EpisodeNumber` INT NOT NULL,
  `SeasonID` INT NOT NULL,
  PRIMARY KEY (`EpisodeID`),
  INDEX `Episode_SeasonID_idx` (`SeasonID` ASC) ,
  CONSTRAINT `Episode_SeasonID`
    FOREIGN KEY (`SeasonID`)
    REFERENCES `cooking_competition`.`Season` (`SeasonID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Event` (
  `EventID` INT NOT NULL AUTO_INCREMENT,
  `ContestantID` INT NOT NULL,
  `RecipeID` INT NOT NULL,
  `CuisineID` INT NOT NULL,
  `EpisodeID` INT NOT NULL,
  PRIMARY KEY (`EventID`),
  INDEX `Event_EpisodeID_idx` (`EpisodeID` ASC) ,
  INDEX `Event_ContestantID_idx` (`ContestantID` ASC) ,
  INDEX `Event_RecipeID_idx` (`RecipeID` ASC) ,
  INDEX `Event_CuisineID_idx` (`CuisineID` ASC) ,
  CONSTRAINT `Event_EpisodeID`
    FOREIGN KEY (`EpisodeID`)
    REFERENCES `cooking_competition`.`Episode` (`EpisodeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Event_ContestantID`
    FOREIGN KEY (`ContestantID`)
    REFERENCES `cooking_competition`.`Cook` (`CookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Event_RecipeID`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `cooking_competition`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Event_CuisineID`
    FOREIGN KEY (`CuisineID`)
    REFERENCES `cooking_competition`.`EthnicCuisine` (`CuisineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Judge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Judge` (
  `EpisodeID` INT NOT NULL,
  `CookID` INT NOT NULL,
  PRIMARY KEY (`EpisodeID`, `CookID`),
  INDEX `Judge_CookID_idx` (`CookID` ASC) ,
  CONSTRAINT `Judge_EpisodeID`
    FOREIGN KEY (`EpisodeID`)
    REFERENCES `cooking_competition`.`Episode` (`EpisodeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Judge_CookID`
    FOREIGN KEY (`CookID`)
    REFERENCES `cooking_competition`.`Cook` (`CookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cooking_competition`.`Score`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`Score` (
  `EventID` INT NOT NULL,
  `CookID` INT NOT NULL,
  `Value` INT NOT NULL,
  PRIMARY KEY (`EventID`, `CookID`),
  INDEX `Score_CookID_idx` (`CookID` ASC) ,
  CONSTRAINT `Score_EventID`
    FOREIGN KEY (`EventID`)
    REFERENCES `cooking_competition`.`Event` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Score_CookID`
    FOREIGN KEY (`CookID`)
    REFERENCES `cooking_competition`.`Cook` (`CookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `cooking_competition` ;

-- -----------------------------------------------------
-- Placeholder table for view `cooking_competition`.`NutritionalTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooking_competition`.`NutritionalTable` (`NutritionalContentID` INT, `FatsPer100` INT, `ProteinPer100` INT, `CarbsPer100` INT, `CaloriesPer100` INT, `IngredientID` INT);

-- -----------------------------------------------------
-- View `cooking_competition`.`NutritionalTable`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cooking_competition`.`NutritionalTable`;
USE `cooking_competition`;
CREATE  OR REPLACE VIEW `NutritionalTable` AS
	select *
    from NutritionalContent;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
