

class father:   
    def __init__(self):
        __name='老王'
        __age=18
        gender="男"
    def get_age(self):
        print(self.__age)
class son(father):
    pass
s=son()
s.get_age()
