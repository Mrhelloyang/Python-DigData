

# def func1():
#         print('__________________________________')
# def func(num):
#     while num>0:
#         func1()
#         num-=1
#
#
# func(3)

def func1(num1,num2,num3):
    sum=num1+num2+num3
    return sum

def func2(num1,num2,num3):
    avg=func1(num1,num2,num3)/3
    return avg

ret=func2(3,6.3,3)
print(ret)