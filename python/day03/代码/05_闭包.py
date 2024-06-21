import copy
import time
def func1(name):
    def func2():
        age=20
        print(F"{name}:{age}")
    return func2
func=func1('老王')
func()

# #去重
# a=[1,2,3,2,1,2,2,3,2,3,2,2,2,0,2,3,4,5,6,3,2,4,2,3,2,1,2,3,1,8,5,4,3,5,3,5,'a','a','a','a',"l",'hhhello','hello','hello']
# #b=a,这里是复制a存的列表首地址
# b=a.copy()
# for i in range(len(a)):
#     if a.count(b[i])>1:
#         a.remove(b[i])
# print(a)

print('helllonihao')