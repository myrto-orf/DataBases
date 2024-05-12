import requests
import json
from string import ascii_lowercase as alc

def write_recipe(letter, file_name):
    constant_url = 'https://www.themealdb.com/api/json/v1/1/search.php?f='
    full_url = constant_url + letter
    response = requests.get(full_url)

    if response.status_code == 200:
        # Parse JSON response
        json_data = response.json()
        file = open(file_name, 'a')
        json.dump(json_data, file)
        file.write("\n")
        file.close()
    else:
        print('Failed to fetch data from API')

def get_data(file_name):
    file = open(file_name, 'a')
    file.write("[")
    file.close()
    for letter in alc:
        write_recipe(letter, file_name)
        if not (letter == 'z'): 
            file = open(file_name, 'a')
            file.write(",")
            file.close()
    file = open(file_name, 'a')
    file.write("]")
    file.close()

get_data('recipes.json')
