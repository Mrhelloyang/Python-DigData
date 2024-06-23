import socket

# 创建socket套接字
tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcp_socket.bind(('127.0.0.1', 8080))
tcp_socket.listen(127)

# 等待客户到来
while True:
    client_socket, client_addr = tcp_socket.accept()
    # 接受到的数据
    recv_data = client_socket.recv(10240)
    recv_data = recv_data.decode('utf8')
    # 请求报文中的路径解析
    request_path = recv_data.split('\r\n')[0].split(' ')[1]
    print("请求路径:", request_path)

    # 发送数据(数据要遵循响应报文格式)
    # 响应行
    response_line = "HTTP/1.1 200 OK\r\n"
    # 响应头
    response_header = 'server:python_web_1.1\r\n'

    # todo 判断请求的资源是 动态资源(html代码) 静态资源(图片)
    try:
        # 根据 请求路径 如果请求路径以html为结尾(动态资源) 否则就是(静态资源)
        if request_path.endswith('html'):
            # if语句如果成立 证明请求资源是动态资源
            with open(f"./html{request_path}", 'r', encoding='utf8') as f:
                response_body = f.read()
            # 响应报文
            response_data = response_line + response_header + "\r\n" + response_body
            # 编码
            response_data = response_data.encode('utf8')
        else:
            # 静态资源(图片)
            with open(f'./html{request_path}', 'rb') as f:
                response_body = f.read()
            # 响应报文
            response_data = response_line + response_header + "\r\n"
            # 编码
            response_data = response_data.encode('utf8') + response_body
    except Exception as e:
        # 执行到这里 证明 请求的资源不存在
        with open("./html/images/10.jpg", 'rb') as f:
            response_body = f.read()
        # 响应报文
        response_data = response_line + response_header + "\r\n"
        # 编码
        response_data = response_data.encode('utf8') + response_body

    # 发送数据
    client_socket.send(response_data)

    # 关闭客户端
    client_socket.close()
