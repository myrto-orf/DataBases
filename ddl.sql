-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Image` (
  `ImageID` INT NOT NULL,
  `ImageDescription` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ImageID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EthnicCuisine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EthnicCuisine` (
  `CuisineID` INT NOT NULL,
  `CuisineName` VARCHAR(45) NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`CuisineID`),
  CONSTRAINT `FK_EthnicCuisine_Image` 
    FOREIGN KEY (`ImageID`)         
    REFERENCES `mydb`.`Image` (`ImageID`) 
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recipe` (
  `RecipeID` INT NOT NULL,
  `RecipeName` VARCHAR(45) NOT NULL,
  `IsBaking` BOOLEAN NOT NULL,
  `DifficultyLevel` INT NOT NULL CHECK (DifficultyLevel BETWEEN 1 AND 5),
  `Description` VARCHAR(200) NULL,
  `PreparationTime` INT NULL,
  `CookingTime` INT NULL,
  `NumberOfPortions` INT NULL,
  `MainIngredientID` INT NOT NULL,
  `MainIngredientCategory` VARCHAR(45) NOT NULL,
  `ImageID` INT NOT NULL,
  `CuisineID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`),
  UNIQUE INDEX `MainIngredientID_UNIQUE` (`MainIngredientID` ASC),
  CONSTRAINT `FK_Recipe_CuisineID`
    FOREIGN KEY (`CuisineID`) 
    REFERENCES `mydb`.`EthnicCuisine` (`CuisineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Recipe_ImageID`
    FOREIGN KEY (`ImageID`) 
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Label` (
  `LabelID` INT NOT NULL,
  `LabelName` VARCHAR(45) NOT NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`LabelID`),
  CONSTRAINT `FK_Label_ImageID`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)  -- Connecting LabelID to ImageID
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MealCategory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MealCategory` (
  `CategoryID` INT NOT NULL,
  `CategoryName` VARCHAR(45) NOT NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`CategoryID`),
  CONSTRAINT `FK_MealCategory_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tips` (
  `TipsID` INT NOT NULL,
  `TipsDescription` VARCHAR(45) NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`TipsID`),
  CONSTRAINT `FK_Tips_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Step`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Step` (
  `StepID` INT NOT NULL,
  `StepNumber` INT NOT NULL,
  `StepDescription` VARCHAR(200) NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`StepID`),
  CONSTRAINT `FK_Step_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MealCategory_has_Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MealCategory_has_Recipe` (
  `CategoryID` INT NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`CategoryID`, `RecipeID`),
  CONSTRAINT `FK_MealCategory_has_Recipe_MealCategory`
    FOREIGN KEY (`CategoryID`)
    REFERENCES `mydb`.`MealCategory` (`CategoryID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_MealCategory_has_Recipe_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recipe_has_Label`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recipe_has_Label` (
  `RecipeID` INT NOT NULL,
  `LabelID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `LabelID`),
  CONSTRAINT `fk_Recipe_has_Label_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Recipe_has_Label_Label`
    FOREIGN KEY (`LabelID`)
    REFERENCES `mydb`.`Label` (`LabelID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FoodGroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FoodGroup` (
  `GroupID` INT NOT NULL,
  `GroupName` VARCHAR(45) NOT NULL,
  `GroupDescription` VARCHAR(45) NOT NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`GroupID`),
  CONSTRAINT `FK_FoodGroup_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ingredient` (
  `IngredientID` INT NOT NULL,
  `IngredientName` VARCHAR(45) NOT NULL,
  `ImageID` INT NOT NULL,
  `GroupID` INT NOT NULL,
  PRIMARY KEY (`IngredientID`),
  CONSTRAINT `FK_Ingredient_FoodGroup`
    FOREIGN KEY (`GroupID`)
    REFERENCES `mydb`.`FoodGroup` (`GroupID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Ingredient_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recipe_has_Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recipe_has_Ingredient` (
  `RecipeID` INT NOT NULL,
  `IngredientID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `IngredientID`),
  CONSTRAINT `Recipe_has_Ingredient_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Recipe_has_Ingredient_Recipe_Ingredient`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `mydb`.`Ingredient` (`IngredientID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Equipment` (
  `EquipmentID` INT NOT NULL,
  `EquipmentName` VARCHAR(45) NOT NULL,
  `EquipmentInstructions` VARCHAR(200) NOT NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`EquipmentID`),
  CONSTRAINT `FK_Equipment_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recipe_has_Equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recipe_has_Equipment` (
  `RecipeID` INT NOT NULL,
  `EquipmentID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `EquipmentID`),
  CONSTRAINT `Recipe_has_Equipment_Equipment`
    FOREIGN KEY (`EquipmentID`)
    REFERENCES `mydb`.`Equipment` (`EquipmentID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Recipe_has_Equipment_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ThematicUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ThematicUnit` (
  `ThematicUnitID` INT NOT NULL,
  `ThematicUnitName` VARCHAR(45) NOT NULL,
  `ThematicUnitDescription` VARCHAR(200) NOT NULL,
  `ImageID` INT NOT NULL,
  PRIMARY KEY (`ThematicUnitID`),
  CONSTRAINT `FK_ThematicUnit_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recipe_has_ThematicUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recipe_has_ThematicUnit` (
  `RecipeID` INT NOT NULL,
  `ThematicUnitID` INT NOT NULL,
  PRIMARY KEY (`RecipeID`, `ThematicUnitID`),
  CONSTRAINT `Recipe_has_ThematicUnit_ThematicUnit`
    FOREIGN KEY (`ThematicUnitID`)
    REFERENCES `mydb`.`ThematicUnit` (`ThematicUnitID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Recipe_has_ThematicUnit_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`StandardUnit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`StandardUnit` (
  `StandardUnitID` INT NOT NULL,
  `StandardUnitName` ENUM('gr', 'ml') NOT NULL,
  PRIMARY KEY (`StandardUnitID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Unit` (
  `UnitID` INT NOT NULL,
  `UnitName` VARCHAR(45) NOT NULL,
  `UnitConvertValue` INT NOT NULL,
  `StandardUnitID` INT NOT NULL,
  PRIMARY KEY (`UnitID`),
  CONSTRAINT `FK_Unit_StandardUnit`
    FOREIGN KEY (`StandardUnitID`)
    REFERENCES `mydb`.`StandardUnit` (`StandardUnitID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Quantity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Quantity` (
  `QuantityID` INT NOT NULL,
  `QuantityValue` INT NOT NULL,
  `IngredientID` INT NOT NULL, 
  `UnitID` INT NOT NULL,
  PRIMARY KEY (`QuantityID`),
  CONSTRAINT `FK_Quantity_Ingredient`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `mydb`.`Ingredient` (`IngredientID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Quantity_Unit`
    FOREIGN KEY (`UnitID`)
    REFERENCES `mydb`.`Unit` (`UnitID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NutricionalInfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`NutricionalInfo` (
  `NutricionalInfoID` INT NOT NULL,
  `FatsPerServing` DECIMAL(10,2) NOT NULL,
  `ProteinPerServing` DECIMAL(10,2) NOT NULL,
  `CarbsPerServing` DECIMAL(10,2) NOT NULL,
  `CaloriesPerServing` DECIMAL(10,2) NOT NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`NutricionalInfoID`),
  CONSTRAINT `FK_NutritionalInfo_Recipe`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `mydb`.`Recipe` (`RecipeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Trigger creation statements
DELIMITER //

DROP TRIGGER IF EXISTS calculate_fats_per_serving;
CREATE TRIGGER calculate_fats_per_serving 
BEFORE INSERT ON `mydb`.`NutricionalInfo`
FOR EACH ROW
BEGIN
    DECLARE fats_per_ingredient DECIMAL(10, 2);
    DECLARE standard_unit_convert_value INT;
    DECLARE unit_id INT;
    DECLARE quantity_value INT;
    DECLARE number_of_portions INT;
    DECLARE ingredient_id INT; 
    
    SET ingredient_id = (SELECT IngredientID FROM Recipe_has_Ingredient WHERE RecipeID = NEW.RecipeID);

    SELECT nc.FatsPer100
    INTO fats_per_ingredient
    FROM NutricionalContent nc
    WHERE nc.IngredientID = ingredient_id;

    SELECT q.UnitID, q.QuantityValue
    INTO unit_id, quantity_value
    FROM Quantity q
    WHERE q.IngredientID = ingredient_id;

    SELECT u.UnitConvertValue
    INTO standard_unit_convert_value
    FROM Unit u
    WHERE u.UnitID = unit_id;

    SELECT NumberOfPortions
    INTO number_of_portions
    FROM Recipe
    WHERE RecipeID = NEW.RecipeID;

    SET fats_per_ingredient = fats_per_ingredient * quantity_value * standard_unit_convert_value;

    SET NEW.FatsPerServing = fats_per_ingredient / number_of_portions;
END//

DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS calculate_protein_per_serving;
CREATE TRIGGER calculate_protein_per_serving
BEFORE INSERT ON `mydb`.`NutricionalInfo`
FOR EACH ROW
BEGIN
    DECLARE protein_per_ingredient DECIMAL(10, 2); 
    DECLARE standard_unit_convert_value INT;
    DECLARE unit_id INT;
    DECLARE quantity_value INT;
    DECLARE number_of_portions INT;
    DECLARE ingredient_id INT; 

    SET ingredient_id = (SELECT IngredientID FROM Recipe_has_Ingredient WHERE RecipeID = NEW.RecipeID);

    SELECT nc.ProteinPer100
    INTO protein_per_ingredient
    FROM NutricionalContent nc
    WHERE nc.IngredientID = ingredient_id;

    SELECT q.UnitID, q.QuantityValue
    INTO unit_id, quantity_value
    FROM Quantity q
    WHERE q.IngredientID = ingredient_id;

    SELECT u.UnitConvertValue
    INTO standard_unit_convert_value
    FROM Unit u
    WHERE u.UnitID = unit_id;

    SELECT NumberOfPortions
    INTO number_of_portions
    FROM Recipe
    WHERE RecipeID = NEW.RecipeID;

    SET protein_per_ingredient = protein_per_ingredient * quantity_value * standard_unit_convert_value;

    SET NEW.ProteinPerServing = protein_per_ingredient / number_of_portions;
END//


DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS calculate_carbs_per_serving;
CREATE TRIGGER calculate_carbs_per_serving
BEFORE INSERT ON `mydb`.`NutricionalInfo`
FOR EACH ROW
BEGIN
    DECLARE carbs_per_ingredient DECIMAL(10, 2);
    DECLARE standard_unit_convert_value INT;
    DECLARE unit_id INT;
    DECLARE quantity_value INT;
    DECLARE number_of_portions INT;
    DECLARE ingredient_id INT; 

    SET ingredient_id = (SELECT IngredientID FROM Recipe_has_Ingredient WHERE RecipeID = NEW.RecipeID);

    SELECT nc.CarbsPer100
    INTO carbs_per_ingredient
    FROM NutricionalContent nc
    WHERE nc.IngredientID = ingredient_id;

    SELECT q.UnitID, q.QuantityValue
    INTO unit_id, quantity_value
    FROM Quantity q
    WHERE q.IngredientID = ingredient_id;

    SELECT u.UnitConvertValue
    INTO standard_unit_convert_value
    FROM Unit u
    WHERE u.UnitID = unit_id;

    SELECT NumberOfPortions
    INTO number_of_portions
    FROM Recipe
    WHERE RecipeID = NEW.RecipeID;

    SET carbs_per_ingredient = carbs_per_ingredient * quantity_value * standard_unit_convert_value;

    SET NEW.CarbsPerServing = carbs_per_ingredient / number_of_portions;
END//

DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS calculate_calories_per_serving;
CREATE TRIGGER calculate_calories_per_serving
BEFORE INSERT ON `mydb`.`NutricionalInfo`
FOR EACH ROW
BEGIN
    DECLARE calories_per_ingredient DECIMAL(10, 2);
    DECLARE standard_unit_convert_value INT;
    DECLARE unit_id INT;
    DECLARE quantity_value INT;
    DECLARE number_of_portions INT;
    DECLARE ingredient_id INT; 

    SET ingredient_id = (SELECT IngredientID FROM Recipe_has_Ingredient WHERE RecipeID = NEW.RecipeID);

    SELECT nc.CaloriesPer100
    INTO calories_per_ingredient
    FROM NutricionalContent nc
    WHERE nc.IngredientID = ingredient_id;

    SELECT q.UnitID, q.QuantityValue
    INTO unit_id, quantity_value
    FROM Quantity q
    WHERE q.IngredientID = ingredient_id;

    SELECT u.UnitConvertValue
    INTO standard_unit_convert_value
    FROM Unit u
    WHERE u.UnitID = unit_id;

    SELECT NumberOfPortions
    INTO number_of_portions
    FROM Recipe
    WHERE RecipeID = NEW.RecipeID;

    SET calories_per_ingredient = calories_per_ingredient * quantity_value * standard_unit_convert_value;

    SET NEW.CaloriesPerServing = calories_per_ingredient / number_of_portions;
END//
DELIMITER ;



-- -----------------------------------------------------
-- Table `mydb`.`NutricionalContent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`NutricionalContent` (
  `NutritionalContentID` INT NOT NULL,
  `FatsPer100` DECIMAL(10,2) NOT NULL,
  `ProteinPer100` DECIMAL(10,2) NOT NULL,
  `CarbsPer100` DECIMAL(10,2) NOT NULL,
  `CaloriesPer100` DECIMAL(10,2) NOT NULL,
  `IngredientID` INT NOT NULL,
  `UnitID` INT NOT NULL,
  PRIMARY KEY (`NutritionalContentID`),
  CONSTRAINT `FK_NutricionalContent_Ingredient`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `mydb`.`Ingredient` (`IngredientID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_NutricionalContent_Unit`
    FOREIGN KEY (`UnitID`)
    REFERENCES `mydb`.`Unit` (`UnitID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cook`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cook` (
  `CookID` INT NOT NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `PhoneNumber` VARCHAR(45) NOT NULL,
  `BirthDate` DATE NOT NULL,
  `Age` INT NOT NULL,
  `ExperienceYears` INT NOT NULL,
  `TrainingLevel` ENUM('Γ΄ μάγειρας', 'Β΄ μάγειρας', 'Α΄ μάγειρας', 'βοηθός αρχιμάγειρα', 'αρχιμάγειρας (σεφ)') NOT NULL,
  `TotalScore` INT NOT NULL,
  `IsWinner` BOOLEAN NOT NULL,
  `ImageID` INT NOT NULL,	
  `CuisineID` INT NOT NULL,
  PRIMARY KEY (`CookID`),
  CONSTRAINT `FK_Cook_EthnicCuisine`
    FOREIGN KEY (`CuisineID`)
    REFERENCES `mydb`.`EthnicCuisine` (`CuisineID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Cook_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;

DELIMITER //

DROP TRIGGER IF EXISTS calculate_age_before_insert;
CREATE TRIGGER calculate_age_before_insert
BEFORE INSERT ON `mydb`.`Cook`
FOR EACH ROW
BEGIN
    SET NEW.Age = TIMESTAMPDIFF(YEAR, NEW.BirthDate, CURDATE());
END;
//

DROP TRIGGER IF EXISTS calculate_age_before_update;
CREATE TRIGGER calculate_age_before_update
BEFORE UPDATE ON `mydb`.`Cook`
FOR EACH ROW
BEGIN
    SET NEW.Age = TIMESTAMPDIFF(YEAR, NEW.BirthDate, CURDATE());
END;
//

DELIMITER ;


-- -----------------------------------------------------
-- Table `mydb`.`Expertise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Expertise` (
  `CookID` INT NOT NULL,
  `CuisineID` INT NOT NULL,
  `ExpertiseYears` INT NOT NULL,
  PRIMARY KEY (`CookID`, `CuisineID`),
  CONSTRAINT `Expertise_Cuisine`
    FOREIGN KEY (`CuisineID`)
    REFERENCES `mydb`.`EthnicCuisine` (`CuisineID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Expertise_Cook`
    FOREIGN KEY (`CookID`)
    REFERENCES `mydb`.`Cook` (`CookID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Episode`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Episode` (
  `EpisodeID` INT NOT NULL,
  `EpisodeDate` DATE NOT NULL,
  `EpisodeNumber` INT NOT NULL,
  `EpisodeSeason` INT NOT NULL,
  `ImageID` INT NOT NULL,	
  `SeasonID` INT NOT NULL,
  PRIMARY KEY (`EpisodeID`),
  CONSTRAINT `FK_Episode_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Episode_Season`
    FOREIGN KEY (`SeasonID`)
    REFERENCES `mydb`.`Season` (`SeasonID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`Season`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Season` (
  `SeasonID` INT NOT NULL,
  `SeasonStartDate` DATE NOT NULL,
  `ImageID` INT NOT NULL,	
  PRIMARY KEY (`SeasonID`),
  CONSTRAINT `FK_Season_Image`
    FOREIGN KEY (`ImageID`)
    REFERENCES `mydb`.`Image` (`ImageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Judge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Judge` (
  `CookID` INT NOT NULL,
  `EpisodeID` INT NOT NULL,
  `Score` INT NOT NULL,
  PRIMARY KEY (`CookID`, `EpisodeID`),
  CONSTRAINT `Judge_Cook`
    FOREIGN KEY (`CookID`)
    REFERENCES `mydb`.`Cook` (`CookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Judge_Episode`
    FOREIGN KEY (`EpisodeID`)
    REFERENCES `mydb`.`Episode` (`EpisodeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX idx_cook_ethnic_cuisine ON `Cook` (`CuisineID`);
-- CREATE INDEX idx_recipe_cook_ethnic_cuisine ON `Recipe` (`CookID`, `CuisineID`);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
