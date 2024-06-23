
old_name=input("请输入需要复制的文件名：")

name_index=old_name.rindex('.')
new_name=old_name[:name_index]+'[复制]'+old_name[name_index:]
f1=open(f'./{old_name}','r',encoding='utf8')
f2=open(f'./{new_name}','w',encoding='utf8')
data=f1.read()
f2.write((data))
f1.close()
f1.close()