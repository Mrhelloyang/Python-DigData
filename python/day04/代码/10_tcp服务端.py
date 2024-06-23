import socket

# todo 1 创建套接字(创建一个电话)
# 参数1 : socket.AF_INET ==> ipv4
# 参数2 : socket.SOCK_STREAM ==> 流式协议 tcp
tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# todo 2 地址绑定
# 参数1: 元组(ip地址,端口号)
tcp_socket.bind(('127.0.0.1', 8080))

# todo 3 设置监听
# 参数 : 最大连接数
# tcp_socket : 设置为只能接受数据
tcp_socket.listen(127)

while True:
    # todo 4 连接请求的接受
    # accept(): 会阻塞程序运行 等待链接请求
    # 接受到两个东西
    # 1. 专门负责和请求方 进行数据通讯的socket
    # 2. 请求方的地址(ip地址和端口号)
    client_socket, client_addr = tcp_socket.accept()

    # todo 5 接受数据
    recv_data = client_socket.recv(1024)
    recv_data = recv_data.decode('utf8')
    print(f"~~~~客户端数据:{recv_data}~~~~")

    # todo 6 发送数据
    send_data = input("请输入发送给客户端的数据:")
    send_data = send_data.encode('utf8')
    client_socket.send(send_data)

    # todo 7 关闭连接
    client_socket.close()

tcp_socket.close()
