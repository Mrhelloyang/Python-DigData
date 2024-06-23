import socket

while True:
    # todo 创建一个socket对象
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # todo 连接到服务器
    client_socket.connect(('127.0.0.1', 8080))

    # todo 发送消息到服务器
    # 在网络中只能进行二进制数据传输
    # 发数据: 把数据转化为二进制(编码)
    data = input("客户端,请输入数据:")
    data = data.encode('utf8')
    # 发数据
    client_socket.send(data)

    # todo 接收服务器的响应
    # 从网络中获取的数据是二进制类型
    # 把二进制数据转化为字符串(解码)
    response_data = client_socket.recv(1024)
    response_data = response_data.decode('utf8')
    print('~~~~服务端的数据:~~~~', response_data)

    # todo 关闭socket连接
    client_socket.close()
