import mysql.connector
import csv

def generateInstructions(file_path, table_name):
	sql_instructions = []
	with open(file_path, mode='r') as file:
		csvFile = csv.reader(file)
		csvFile = list(csvFile)
		column = csvFile[0]
		csvFile = csvFile[1:]
		
		for line in csvFile:
			sql_line = "INSERT INTO " + table_name + "("
			for name in column:
				sql_line += name
				sql_line += ", "
			sql_line = sql_line[:-2]
			sql_line += ") VALUES ("
			for value in line:
				sql_line += value
				sql_line += ", "
			sql_line = sql_line[:-2]
			sql_line += ")"
			sql_instructions.append(sql_line)

	return sql_instructions

def insertData(db, db_cursor, file_path, table_name):
	instructions = generateInstructions(file_path, table_name)

	for instr in instructions:
		db_cursor.execute(instr)
		db.commit()

def buildAll():
	mydb = mysql.connector.connect(
	host = "localhost",
	user = "root",
	password = "password"
	)

	cursor = mydb.cursor()

	with open('..\\schema\\ddl.sql', 'r') as file:
		sql_script = file.read()
	
	for statement in sql_script.split(';'):
		if statement.strip():
			cursor.execute(statement)
	
	insertData(mydb, cursor, 'csv_files\cook.csv', 'Cook')
	insertData(mydb, cursor, 'csv_files\FoodGroup.csv', 'FoodGroup')
	insertData(mydb, cursor, 'csv_files\EthnicCuisine.csv', 'EthnicCuisine')
	insertData(mydb, cursor, 'csv_files\Image.csv', 'Image')
	insertData(mydb, cursor, 'csv_files\Ingredient.csv', 'Ingredient')
	insertData(mydb, cursor, 'csv_files\Recipe.csv', 'Recipe')
	insertData(mydb, cursor, 'csv_files\Image.csv', 'Image')
	insertData(mydb, cursor, 'csv_files\MealCategory.csv', 'MealCategory')
	insertData(mydb, cursor, 'csv_files\Step.csv', 'Step')
	insertData(mydb, cursor, 'csv_files\MealCategory_Recipe.csv', 'MealCategory_Recipe')
	insertData(mydb, cursor, 'csv_files\StandardUnit.csv', 'StandardUnit')
	insertData(mydb, cursor, 'csv_files\\Unit.csv', 'Unit')
	insertData(mydb, cursor, 'csv_files\Quantity.csv', 'Quantity')

	return

buildAll()
