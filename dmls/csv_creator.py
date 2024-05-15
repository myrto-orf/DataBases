import data_generator as dg
import random
import format
import re
import csv

def remove_non_ascii(s):
    return re.sub(r'[^\x00-\x7F]+', '', s)

def searchList(list, key, value):
    for index in range(len(list)):
        if list[index][key] == value:
            return index
    return None

def listToCSV(list, key_names, file_path):
    file = open(file_path, "w")

    for index, name in enumerate(key_names):
        file.write(name)
        if not (index == len(key_names) - 1):
            file.write(",")
    file.write("\n")

    for item in list:
        for index, name in enumerate(key_names):
            file.write(str(item[name]))
            if not (index == len(key_names) - 1):
                file.write(",")
        file.write("\n")
    file.close()
    return

def getLengthCSV(path_to_file):
    length = 0
    with open(path_to_file, mode='r') as file: 
        csvFile = csv.reader(file)
        csvFile = list(csvFile)
        length = len(csvFile) - 1
    
    return length

class csvCreator:
    def cook(size):
        file = open("csv_files\cook.csv", "w")
        file.write("FirstName,LastName,BirthDate,ExperienceYears,TrainingLevel,PhoneNumber\n")

        level_vals = ["C cook", "B cook", "A cook", "sous chef", "chef"]
        rand_gen = dg.rand()
        for _ in range(size):
            firstName = rand_gen.firstName()
            lastName = rand_gen.lastName()
            birth = rand_gen.date('-60y', '-18y')
            experience = str(random.randint(0, 30))
            level = rand_gen.listValue(level_vals)
            phone = rand_gen.phoneNumber()
            line = "'" + firstName + "','" + lastName + "','" + birth + "'," + experience + ",'" + level + "','" + phone + "'\n"
            file.write(line)
        file.close()
        
        return
    
    def foodGroup(path_to_foodCategory):
        FoodGroup_table = []
        with open(path_to_foodCategory, mode='r') as file: 
            csvFile = csv.reader(file)
            csvFile = list(csvFile)
            csvFile = csvFile[1:]
            
            for row in csvFile:
                desc = format.stripChar(row[2], [","])
                name = "'" + desc + "'"
                description = "'decription of food group" + desc + "'"
                FoodGroup_table.append({'GroupName': name, 'GroupDescription': description})
            listToCSV(FoodGroup_table, ['GroupName', 'GroupDescription'], 'csv_files\FoodGroup.csv')
        
        return

    def recipeRelated(path_to_recipes_json):
        rand_gen = dg.rand()
        recipes = format.recipeDictionary(path_to_recipes_json)

        # assuming FoodGroup.csv and Unit.csv have been created
        food_group_length = getLengthCSV('csv_files\\FoodGroup.csv')
        unit_length = getLengthCSV('csv_files\\Unit.csv')

        recipe_table = []
        cuisine_table = []
        image_table = []
        step_table = []
        mealCategory_table = []
        mealCategory_recipe_table = []
        ingredient_table = []
        quantity_table = []

        for recipe_index, meal in enumerate(recipes):
            cuisine_name = "'" + meal['strArea'] + "'"
            index = searchList(cuisine_table, 'CuisineName', cuisine_name)
            if index == None:
                cuisine_table.append({'CuisineName': cuisine_name})
                recipe_table.append({'CuisineID': len(cuisine_table)})
            else:
                recipe_table.append({'CuisineID': index + 1})
            
            mealCategory = "'" + meal['strCategory'] + "'"
            index = searchList(mealCategory_table, 'CategoryName', mealCategory)
            if index == None:
                mealCategory_table.append({'CategoryName': mealCategory})
                dictionary = {'RecipeID': (recipe_index + 1), 'MealCategoryID': len(mealCategory_table)}
                mealCategory_recipe_table.append(dictionary)
            else:
                dictionary = {'RecipeID': (recipe_index + 1), 'MealCategoryID': (index + 1)}
                mealCategory_recipe_table.append(dictionary)
            
            url = "'" + meal['strMealThumb'] + "'"
            recipe_name = remove_non_ascii(meal['strMeal'])
            recipe_name = format.stripChar(recipe_name, [",", "'"])
            image_description = "'photo of " + recipe_name + "'"
            recipe_table[recipe_index]['RecipeName'] = "'" + recipe_name + "'"
            recipe_table[recipe_index]['ImageID'] = recipe_index + 1
            recipe_table[recipe_index]['IsBaking'] = random.randint(0,1)
            recipe_table[recipe_index]['DifficultyLevel'] = random.randint(1,5)
            description = "'description of recipe " + recipe_name + "'"
            recipe_table[recipe_index]['Description'] = description
            recipe_table[recipe_index]['PreparationTime'] = random.randint(5,20)
            recipe_table[recipe_index]['CookingTime'] = random.randint(5,20)
            recipe_table[recipe_index]['NumberOfPortions'] = random.randint(1,5)
            image_table.append({'ImageURL': url, 'ImageDescription': image_description})

            steps = format.analyseInstructions(meal['strInstructions'])
            for step_index, step in enumerate(steps):
                step_dictionary = {'RecipeID': (recipe_index + 1)}
                step_dictionary['StepNumber'] = (step_index + 1)
                step = remove_non_ascii(step)
                step = format.stripChar(step, [',', '\'', "\""])
                step_dictionary['StepDescription'] = "'" + step + "'"
                step_table.append(step_dictionary)

            max_ingredient = 20
            ingredient_index = []
            for i in range(max_ingredient):
                key = 'strIngredient' + str(i + 1)
                if meal[key] == None:
                    break
                ingredient_name = remove_non_ascii(meal[key])
                ingredient_name = "'" + format.stripChar(ingredient_name, [',']) + "'"
                if ingredient_name == "''":
                    break
                index = searchList(ingredient_table, 'IngredientName', ingredient_name)
                if index == None:
                    group_id = random.randint(1,food_group_length)
                    ingredient_table.append({'IngredientName': ingredient_name, 'GroupID': group_id})
                    ingredient_index.append(len(ingredient_table) - 1)
                else:
                    ingredient_index.append(index)
            
            for ingr_index in ingredient_index:
                quantity_dictionary = {'RecipeID': recipe_index + 1}
                quantity_dictionary['IngredientID'] = ingr_index + 1
                quantity_dictionary['QuantityValue'] = round(random.uniform(0, 40), 1)
                quantity_dictionary['UnitID'] = random.randint(1, unit_length)
                quantity_table.append(quantity_dictionary)

            main_ingredient_id = rand_gen.listValue(ingredient_index) + 1
            recipe_table[recipe_index]['MainIngredientID'] = main_ingredient_id
        
        listToCSV(cuisine_table, ['CuisineName'], 'csv_files\EthnicCuisine.csv')
        listToCSV(image_table, ['ImageURL', 'ImageDescription'], 'csv_files\Image.csv')
        listToCSV(step_table, ['RecipeID', 'StepNumber', 'StepDescription'], 'csv_files\Step.csv')
        listToCSV(mealCategory_table, ['CategoryName'], 'csv_files\MealCategory.csv')
        listToCSV(mealCategory_recipe_table, ['RecipeID', 'MealCategoryID'], 'csv_files\MealCategory_Recipe.csv')
        listToCSV(ingredient_table, ['IngredientName', 'GroupID'], 'csv_files\Ingredient.csv')
        recipe_keys = ['RecipeName', 'IsBaking', 'DifficultyLevel', 'Description', 'PreparationTime', 'CookingTime', 'NumberOfPortions', 'ImageID', 'CuisineID', 'MainIngredientID']
        listToCSV(recipe_table, recipe_keys, 'csv_files\Recipe.csv')
        listToCSV(quantity_table, ['RecipeID', 'IngredientID', 'QuantityValue', 'UnitID'], 'csv_files\Quantity.csv')

        return
    
    def createAll():
        csvCreator.cook(100)
        csvCreator.foodGroup('raw_data\\food_category.csv')
        csvCreator.recipeRelated('raw_data\\recipes.json')

        return
    
        
csvCreator.createAll()



