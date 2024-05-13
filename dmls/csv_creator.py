import data_generator as dg
import random

# create csv for table 'Cook'

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

csvCreator.cook(100)



