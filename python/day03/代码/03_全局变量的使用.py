
num=0

def func1():
    num=10
    print(num)

print(num)

def func2():
    global num
    num=1000
    print(num)

func1()
func2()
print(num)