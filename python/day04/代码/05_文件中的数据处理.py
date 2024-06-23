import json
# eval 来把文件中的字符类型转换为python中的数据类型
f=open('./data.txt','r',encoding='utf8')
data=eval(f.read())
print(data)
for i in data:
    print(i["name"])


# python中使用json.loads()来将json中的数据转换为python中的数据
# python使用json.dump()来将python中的数据转换为json类型
print(10/0)