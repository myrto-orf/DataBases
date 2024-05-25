# DataBases

## Purpose
This is an excercise for the subject data bases.
It provides a data base for a cooking competition
which has information about recipes, ingredients, cooks etc.
It is possible to query the data, add new data or delete data

## Installation Guide
Install the xamp stack (Apache, mysql, php)

clone the entire project in the folder ..\xamp\htdocs

Open the xamp panel and run apache and mysql

cd to dmls folder

create a virtual environment by typing `python -m venv venv`

make sure to use the interpreter of your venv

type 'pip install -r requirements.txt' in your terminal to download python dependencies

if the password of the root user is NOT `password` you will have to run
mysql from a terminal as the root user and type in this command:
`ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';`

type `python access_db.py` to create your database

## Use

Open your browser and search for `localhost/DataBases/UI/templates/`

Click on `initialize admin` to create a user with admin priviliges for the database

You can then go back and log in with username `admin` and password `password`.
This will allow you to create new users and access the database.

Some queries are already written and can be found in UI\queries.sql