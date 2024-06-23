import os

#查看当前路径的文件和文件夹信息
print(os.listdir())

# 查看当前所在路径
print(os.getcwd())

# # 文件名修改
# os.rename("./test.txt","111.txt")

# # 路径修改
# os.chdir("../")
# print(os.getcwd())

# 创建文件夹
# os.mkdir("./aaa")

# 删除文件/文件夹
os.rmdir('./aaa')
# os.remove("./111.txt")