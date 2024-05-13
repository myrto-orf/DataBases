from faker import Faker
import random

class rand:
    def __init__(self):
        self.fake = Faker()

    def date(self, min, max):
        return str(self.fake.date_between(start_date=min, end_date=max))
    
    def listValue(self, list):
        index = random.randint(1, len(list) - 1)
        return list[index]
    
    def firstName(self):
        return str(self.fake.first_name())
    
    def lastName(self):
        return str(self.fake.last_name())
    
    def phoneNumber(self):
        return str(self.fake.phone_number())

"""
# examples:

rand_gen = rand()
date = rand_gen.date(min='-30y', max='-20y')
print(date)

list = ['A cook', 'B cook', 'C cook', 'Chef']
print(rand_gen.listValue(list))

print(rand_gen.firstName())
print(rand_gen.lastName())
print(rand_gen.phoneNumber())

"""
