
class dog:

    def __init__(self,name):
        self.dog_name=name

    def run(self,age):
        print(f"{self.dog_name}再跑，他今年{age}岁了")

    def __str__(self):
        return f"他叫{self.dog_name}"
    def __del__(self):
        print("销毁了")

dog1=dog('小汪')
print(dog1)
dog1.run(12)