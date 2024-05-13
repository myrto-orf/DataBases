import json

# formats recipes.json
"""
with open('recipes.json', 'r') as file:
    data = file.read()

json_data = json.loads(data)
formatted = json.dumps(json_data, indent = 4, sort_keys=True)

with open('recipes.json', 'w') as file:
    file.write(formatted)
"""

# puts meals from recipes.json to a list
def getRecipes(file_path):
    file = open(file_path, 'r')
    lines = file.readlines()
    file.close()

    recipes = []
    
    bracket_count = 0
    for line in lines:
        if '{' in line:
            bracket_count += 1
            if bracket_count == 2:
                meal = "{"
        elif '}' in line:
            bracket_count -= 1
            if bracket_count == 1:
                meal += "}"
                recipes.append(meal)
        else:
            if bracket_count == 2:
                meal += line
        
    return recipes

# creates a list of dictionaries
# each element of the list is a meal 
def recipeDictionary(file_path):
    recipes = getRecipes(file_path)
    recipe_dic = []
    for meal in recipes:
        json_data = json.loads(meal)
        recipe_dic.append(json_data)
    return recipe_dic

# example
recipes = recipeDictionary('recipes.json')
print(recipes[60]['strMeal'])

