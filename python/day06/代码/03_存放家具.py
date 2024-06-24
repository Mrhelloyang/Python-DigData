
class Home:
    def __init__(self,area):
        self.area=area
        self.item=[]
    def add_item(self,item):
        if self.area>=item.item_area:
            self.item.append(item.name)
            self.area-=item.item_area
        else:
            print("房子面积不足")

    def __str__(self):
        return (f"有{self.item},房子面积剩余{self.area}")


class Item:
    def __init__(self,name,area):
        self.name=name
        self.item_area=area

my_home=Home(100)
sofe=Item("沙发",20)
my_home.add_item(sofe)
print(my_home)
bed=Item("床",10)
my_home.add_item(bed)
print(my_home)