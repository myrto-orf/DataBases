import mysql.connector
import csv

def insertData(file_path, table_name):
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
				#sql_line += "'"
				sql_line += value
				#sql_line += "'"
				sql_line += ", "
			sql_line = sql_line[:-2]
			sql_line += ")"
			sql_instructions.append(sql_line)

	return sql_instructions

# change the password if yours is different
mydb = mysql.connector.connect(
	host = "localhost",
	user = "root",
	password = "password"
)

# Creating an instance of 'cursor' class 
# which is used to execute the 'SQL' 
# statements in 'Python'
cursor = mydb.cursor()

# Show database
"""
cursor.execute("show databases")

for x in cursor:
    print(x)
"""
cursor.execute("USE cooking_competition")
instructions = insertData('csv_files\cook.csv', 'Cook')

for instr in instructions:
	cursor.execute(instr)
	mydb.commit()

