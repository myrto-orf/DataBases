from faker import Faker
import random

class rand:
    def date(min, max):
        fake = Faker()

        return str(fake.date_between(start_date=min, end_date=max))
    
    def listValue(list):
        index = random.randint(1, len(list) - 1)
        return list[index]
    
    def firstName():
        fake = Faker()
        return str(fake.first_name())
    
    def lastName():
        fake = Faker()
        return str(fake.last_name())
    
    def phoneNumber():
        fake = Faker()
        return str(fake.phone_number())

# date = rand.date('-30y', '-20y')
# print(date)

# list = ['A cook', 'B cook', 'C cook', 'Chef']
# print(rand.listValue(list))

# print(rand.firstName())
# print(rand.lastName())
# print(rand.phoneNumber())
