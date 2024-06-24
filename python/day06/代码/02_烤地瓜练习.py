


class sweetpotato:
    def __init__(self):
        self.state='生的'
        self.cook_time=0

    def cooked(self,time):
        self.cook_time+=time
        if(self.cook_time>=0)and (self.cook_time<3):
            self.state="生的"
        elif(self.cook_time >= 3) and (self.cook_time < 6):
            self.state = "半生不熟的"
        elif (self.cook_time >=6) and (self.cook_time < 8):
            self.state = "熟的"
        elif (self.cook_time >=8) :
            self.state = "糊的"
    def __str__(self):
        return f"这是一个{self.state}地瓜，烤了{self.cook_time}分钟"
a=sweetpotato()
print(a)
a.cooked(2)
print(a)
a.cooked(2)
print(a)
a.cooked(2)
print(a)
a.cooked(2)
print(a)