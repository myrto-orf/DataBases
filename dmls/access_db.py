import mysql.connector
import csv
import format
import random

class access_db:

	def __init__(self) -> None:
		self.mydb = mysql.connector.connect(
		host = "localhost",
		user = "root",
		password = "password"
		)

		self.cursor = self.mydb.cursor()
		self.cursor.execute('show databases')
		found = False
		for db in self.cursor:
			db_name = format.stripChar(str(db), ["(", ")", "'", ","])
			if db_name == "cooking_competition":
				found = True
		if found:
			self.cursor.execute("use cooking_competition")
		return

	def generateInstructions(self, file_path, table_name):
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

	def insertData(self, file_path, table_name):
		instructions = access_db.generateInstructions(self, file_path, table_name)

		for instr in instructions:
			self.cursor.execute(instr)
		self.mydb.commit()

	def buildAll(self):
		with open('..\\schema\\ddl.sql', 'r') as file:
			sql_script = file.read()
		
		for statement in sql_script.split(';'):
			if statement.strip():
				self.cursor.execute(statement)
		
		access_db.insertData(self, 'csv_files\cook.csv', 'Cook')
		access_db.insertData(self, 'csv_files\FoodGroup.csv', 'FoodGroup')
		access_db.insertData(self, 'csv_files\EthnicCuisine.csv', 'EthnicCuisine')
		access_db.insertData(self, 'csv_files\Image.csv', 'Image')
		access_db.insertData(self, 'csv_files\Ingredient.csv', 'Ingredient')
		access_db.insertData(self, 'csv_files\Recipe.csv', 'Recipe')
		access_db.insertData(self, 'csv_files\Image.csv', 'Image')
		access_db.insertData(self, 'csv_files\MealCategory.csv', 'MealCategory')
		access_db.insertData(self, 'csv_files\Step.csv', 'Step')
		access_db.insertData(self, 'csv_files\MealCategory_Recipe.csv', 'MealCategory_Recipe')
		access_db.insertData(self, 'csv_files\StandardUnit.csv', 'StandardUnit')
		access_db.insertData(self, 'csv_files\\Unit.csv', 'Unit')
		access_db.insertData(self, 'csv_files\Quantity.csv', 'Quantity')

		return

	def insertList(self, list, table_name):
		for dictionary in list:
			instruction = ""
			instruction += "INSERT INTO " + table_name + "("
			for key in dictionary:
				instruction += key
				instruction += ", "
			instruction = instruction[:-2]
			instruction += ") VALUES ("
			for key in dictionary:
				instruction += str(dictionary[key])
				instruction += ", "
			instruction = instruction[:-2]
			instruction += ")"
			self.cursor.execute(instruction)
		self.mydb.commit()

		return
	
	def readQuery(self, query):
		self.cursor.execute(query)
		return self.cursor.fetchall()
	
	def insertEventRelated(self, episode_id):
		judge_table = []
		event_table = []
		score_table = []

		query = "select CookID from cook"
		result = access_db.readQuery(self, query)
		number_of_judges = 3
		indexes = random.sample(range(len(result)), number_of_judges)
		for index in indexes:
			judge_id = result[index][0]
			judge_table.append({'CookID': judge_id, 'EpisodeID': episode_id})

		access_db.insertList(self, judge_table, "Judge")

		for index in sorted(indexes, reverse=True):
			del result[index]

		number_of_contestants = 10
		indexes = random.sample(range(len(result)), number_of_contestants)
		for index in indexes:
			contestant_id = result[index][0]
			event_table.append({'ContestantID': contestant_id, 'EpisodeID': episode_id})
		
		query = "select CuisineID from EthnicCuisine"
		result = access_db.readQuery(self, query)
		indexes = random.sample(range(len(result)), number_of_contestants)

		for i, index in enumerate(indexes):
			cuisine_id = result[index][0]
			query = "select RecipeID from Recipe as r, EthnicCuisine as c "
			query += "where r.CuisineID = c.CuisineID and c.CuisineID = " + str(cuisine_id)
			result2 = access_db.readQuery(self, query)
			recipe_index = random.randint(0, len(result2) - 1)
			recipe_id = result2[recipe_index][0]
			event_table[i]['RecipeID'] = recipe_id

			for j in range(number_of_judges):
				value = random.randint(1, 5)
				judge_id = judge_table[j]['CookID']
				score_table.append({'Value': value, 'CookID': judge_id})
		
		access_db.insertList(self, event_table, "Event")

		query = "select EventID from Event"
		result = access_db.readQuery(self, query)
		event_ids = []
		for event_id in result:
			event_ids.append(event_id[0])
		event_ids = sorted(event_ids, reverse=True)
		for i in range(number_of_contestants):
			for j in range(number_of_judges):
				score_table[3 * i + j]['EventID'] = event_ids[i]

		access_db.insertList(self, score_table, "Score")

		return
	
	def insertEpisodes(self, season_id):
		number_of_episodes = 10

		for i in range(number_of_episodes):
			episode_table = []
			episode_table.append({'SeasonID': season_id, 'EpisodeNumber': i + 1})
			access_db.insertList(self, episode_table, "Episode")
			query = "select EpisodeID from Episode"
			result = access_db.readQuery(self, query)
			episode_id = 0
			for tuple in result:
				if tuple[0] > episode_id:
					episode_id = tuple[0]
			access_db.insertEventRelated(self, episode_id)
		return
	
	def insertSeason(self):
		season_table = []

		query = "select * from Season"
		result = access_db.readQuery(self, query)
		season_year = 2000
		for tuple in result:
			if tuple[1] > season_year:
				season_year = tuple[1]
		season_year += 1
		season_table.append({'Year': season_year})
		access_db.insertList(self, season_table, "Season")

		query = "select * from Season"
		result = access_db.readQuery(self, query)
		season_id = 0
		for tuple in result:
			if tuple[0] > season_id:
				season_id = tuple[0]
		
		access_db.insertEpisodes(self, season_id)

		return
	
	


conne = access_db()
conne.buildAll()
for i in range(5):
	conne.insertSeason()

