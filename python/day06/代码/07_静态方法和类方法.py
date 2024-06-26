class Father:
    kind='999'

    def __init__(self,name):
        self.name=name
    def set_province(self):
        self.pro='北京人'

    @classmethod
    def set_kind(cls):
        cls.kind='中国人'

    @staticmethod
    def show_time():
        print("2024年")


Father.set_kind()
print(Father.kind)  