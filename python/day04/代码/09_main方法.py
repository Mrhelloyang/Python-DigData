
# 直接导入会报错没有__main__,会直接执行导入模块的所有代码
import my_model
'''
def func01():
    print("this is func01")

def func02():
    print("this is func02")

func01()
func02()
'''
# 如果在导入模块代码的函数调用前加 if __name__=='__name__':
# 这里调用的是函数入口是my_model,判断为假,后面代码不执行