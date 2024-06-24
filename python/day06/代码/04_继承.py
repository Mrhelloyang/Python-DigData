

class A:
    def __init__(self):
        self.name='A'
    def run(self):
        print("跑")

class B(A):
    def sing(self):
        print("唱歌")

b=B()
b.sing()
print(b.name)
b.run()
