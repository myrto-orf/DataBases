import data_generator as dg
import random

# create csv for table 'Cook'

class csvCreator:
    def cook(size):
        file = open("csv_files\cook.csv", "w")
        file.write("FirstName,LastName,BirthDate,ExperienceYears,TrainingLevel,PhoneNumber\n")

        level_vals = ["C cook", "B cook", "A cook", "sous chef", "chef"]
        for _ in range(size):
            firstName = dg.rand.firstName()
            lastName = dg.rand.lastName()
            birth = dg.rand.date('-60y', '-18y')
            experience = str(random.randint(0, 30))
            level = dg.rand.listValue(level_vals)
            phone = dg.rand.phoneNumber()
            line = "'" + firstName + "','" + lastName + "','" + birth + "'," + experience + ",'" + level + "','" + phone + "'\n"
            file.write(line)
        file.close()

csvCreator.cook(100)



