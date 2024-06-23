# 读取文件
# 写入为全路径是要注意，不能是'\',复制的路径要改为'/'
f=open('./test.txt','r',encoding='utf8')
data=f.read()
print(data)
f.close()

# w的方式写文件,会覆盖原有的文件内容
f=open('./test.txt','w',encoding='utf8')
f.write("你好")
f.close()

# a追加
f=open('./test.txt','a',encoding='utf8')
f.write("你好123432")
f.close()