

class father:
    like='喝茶'
    def __init__(self):
        self.name="老王"
    def run(self):
        print("跑步")
    def dance(self):
        print("跳舞")

class son(father):
    like="喝饮料"
    def __init__(self):
        self.name="小王"
    def dance(self):
        print("街舞")
s=son()
s.run()
print(s.name)
s.dance()