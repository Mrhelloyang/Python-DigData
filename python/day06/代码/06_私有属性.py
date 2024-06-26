

class father:
    def __init__(self):
        self.__name='老王'
        self.__age=18
        self.gender="男"
    def get_age(self):
        print(self.__age)
class son(father):
    pass
s=son()
s.get_age()

# class Father:
#     def __init__(self):
#         self.name = "老王"
#         # todo 如果变量名以__为开头 证明他是私有属性
#         #  私有属性和私有方法 只能在类的内部使用 不能在类的外部使用
#         #  私有属性和方法不能被继承
#         self.__age = 18
#
#     def __run(self):
#         print("跑步")
#
#     def get_age(self, passwd):
#         # 在类的内部使用
#         if passwd == "123":
#             print(self.__age)
#             self.__run()
#
#     def set_age(self, age):
#         # 数据筛选
#         if (age >= 0) and (age <= 200):
#             self.__age = age
#         else:
#             print("年龄不正确")
#
#
# class Son(Father):
#     pass
#
#
# s = Son()
# # 子类无法直接继承 私有属性和方法 可以继承其他所有的非私有属性和方法
# # print(s.__age)
# # print(s.__run())
# s.get_age('123')

#
# f = Father()
# # 实例属性
# print(f.name)
# # 私有属性不能再类的外部使用
# f.set_age(1000)
# f.get_age('123')