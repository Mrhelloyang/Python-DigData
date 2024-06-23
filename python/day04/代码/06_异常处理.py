

try:
    # 有可能出现的问题
    num=int(input("请输入分母"))
    ret=10/num
except Exception as e:
    # 显示异常信息
    print("异常信息：",e)
else:
    # 没有异常
    print("分母是对的")
finally:
    #对错都会执行
    print("谢谢使用")