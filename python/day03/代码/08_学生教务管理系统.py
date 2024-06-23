# 学生的信息可以使用一个字典类型
# 管理学生可以使用列表

# 定义全局变量学生列表
student_list=[{'id':'1','name':'张四','age':'21','gender':'男'},{'id':'2','name':'sisi','age':'22','gender':'女'}]

# 显示功能菜单的函数
def show_menu():
    print("______________学生管理系统________________________")
    print("______________1.添加学生________________________")
    print("______________2.删除学生________________________")
    print("______________3.修改学生信息_____________________")
    print("______________4.查询学生信息________________________")
    print("______________5.显示所有学生信息________________________")
    print("______________6.退出________________________")



# 添加学生
def add_student():
    stu_name=input("请输入学生姓名：")
    stu_age=input("请输入学生年龄")
    stu_gender=input("请输入学生性别")
    stu_dict={}
    stu_dict['name']= stu_name
    stu_dict['age'] = stu_age
    stu_dict['gender'] = stu_gender
    student_list.append(stu_dict)



# 删除学生信息
def del_student():

    stu_id=int(input("请输入需要删除的学生id："))
    del student_list[stu_id-1]
# 修改学生信息
def mod_student():
    id=int(input("请输入需要修改的学生id"))
    stu_dict=student_list[id-1]
    stu_dict["name"]=input("请输入修改后的姓名：")
    stu_dict["age"] = input("请输入修改后的年龄：")
    stu_dict["gender"] = input("请输入修改后的性别：")

# 查询学生
def search_student():
    #按学生姓名查找学生
    name=input("请输入需要查找的学生姓名：")
    for i in student_list:
        if i["name"]==name:
            print(f"name:{i['name']} age:{i['age']} gender:{i['gender']}")
            break
# 显示所有学生信息
def show_student():
    for i in student_list:
        print(f"name:{i['name']} age:{i['age']} gender:{i['gender']}")
    print("")
# 程序启动的函数
def run():

    while 1:
        show_menu()
        num = int(input("请输入你的操作选择"))
        if num==1:
            add_student()
        elif num==2:
            del_student()
        elif num==3:
            mod_student()
        elif num==4:
            search_student()
        elif num==5:
            show_student()
            input("请输入enter继续")
        elif num ==6:
            break
        else:
            print("输入有误，请重新输入。")

# 执行程序启动的函数
run()