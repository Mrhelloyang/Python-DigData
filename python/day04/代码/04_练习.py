import os
# 创建文件夹
# os.mkdir('./aaa')

#切换到aaa中
os.chdir("./aaa")
# print(os.getcwd())

# 获取当前问价夹下的文件和文件夹
name_list=os.listdir()

# 遍历列表
for i in name_list:
    new_name=i[:i.index(".")]+"[new]"+i[i.index("."):]
    os.rename(i,new_name)


