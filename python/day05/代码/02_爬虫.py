import requests
import re

# http协议中的
# get请求报文
# requests.get() 等价于 在浏览器中输入网址 直接回车
# html_data:
html_data = requests.get('http://127.0.0.1:8080/index.html')
html_data = html_data.content.decode('utf8')
# 把html中大数据进行了切割 形成了一个列表
html_data = html_data.split("\n")
# 列表用来存储图片链接
pic_list = []
# 匹配数据
for i in html_data:
    ret = re.match('.*<img src="(.*)" width', i)
    if ret != None:
        pic_list.append(ret.group(1))

num = 0
# 请求图并保存
for i in pic_list:
    # i : ./images/2.jpg
    # i[1:] : /images/2.jpg
    # http://127.0.0.1:8080/images/2.jpg
    url = 'http://127.0.0.1:8080' + i[1:]
    # 根据路径请求图片资源
    pic_data = requests.get(url).content
    # 保存图片
    with open(f"./pic/{num}.jpg", "wb") as f:
        f.write(pic_data)

    num += 1
