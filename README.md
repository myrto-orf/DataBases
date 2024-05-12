## DataBases

# Purpose
This is an excercise for the subject data bases.
It provides a data base for a cooking competition
which has information about recipes, ingredients, cooks etc.
It is possible to query the data, add new data or delete data

# Installation Guide
Install the xamp stack (Apache, mysql, php)
Open the xamp panel and run apache and mysql
Use the file schema\ddl.sql to build the relations of the database (source <path_to_ddl.sql>)
cd to dmls folder
create a virtual environment (python -m venv venv)
type 'pip install requirements.txt' in your terminal to download python dependencies
type 'python access_db.py' to load the data from the cvs to your database
you might need to change the password in the 'access_db.py' file to access your database

# Use
