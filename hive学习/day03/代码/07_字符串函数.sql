-- 在开发中我们的数据内容以字符串形式出现的最多.

-- 1. concat 字符串连接
select concat('hello','world','!!!');

-- 2. concat_ws 字符串按照指定分隔符进行连接
-- 格式: concat_ws(分隔符, 字符串1, 字符串2, .....)
select concat_ws('-','hello','world','!!!');
-- 查看concat_ws的使用方式

-- 经过查看函数的使用方法, 可以断定, 其不光可以连接字符串, 还可以将元素为字符串类型的数组类型数据连接在一起

-- 3. length 查看字符串的 长度, 或者说查看字符串中有多少个字符
select length("hello world!!!");
-- 4. upper 和 lower  将字符转换为大写或小写, 对于数字和汉字,符号等无效
select upper("hello world!!!");
select lower("hello world!!!");

-- 5. trim 清除字符串数据左右两侧的空格 ,不能清除 \t或者 \n
select trim("   hello world!!! ");
-- 11

-- 6. split 将字符按照指定分隔符进行拆分, 拆分完成后, 返回元素为字符串的数组类型数据.
select split("hello world and hello hangzhou and hello china and",'and');

-- 注意:查分后返回数组类型数据,且查分后, 分隔符在数组中不存在. 如果定义的分隔符在字符串中出现了n次, 则数据被拆分为n+1份,返回的数组中,就有n+1个元素

-- 7. substr 截取字符串中的一部分信息, 完全等价于 substring
-- 格式:substr(被截取的字符串, 起始位置, 截取长度)
-- sql中substr 和其他编程语言的截取方式不一样, 是从1开始数截取数据的位置值的. 其他都是从0开始
select substr("你好新世界！！！",2,3);

-- 8. parse_url 解析url
-- url : 统一资源定位符, 可以从互联网上定义到唯一一个资源的路径
-- https://prodev.jd.com/mall/active/DpSh7ma8JV7QAxSE2gJNro8Q2h9/index.html?babelChannel=ttt56
-- PROTOCOL 协议: https://  按照指定规则传递数据
-- HOST 域名: prodev.jd.com 等价于: ip + 端口号  找到指定的主机
-- PATH 资源路径 : /mall/active/DpSh7ma8JV7QAxSE2gJNro8Q2h9/index.html  -- 找到主机上的指定资源
-- Parameter 参数: ?babelChannel=ttt56 给服务器传递信息

desc function extended parse_url;

-- 官方示例


-- 9. get_json_object 解析json数据, 从json数据中获取指定的数据内容
-- json数据我们可以先理解为 map类型和array类型的互相嵌套
-- 格式: get_json_object(json数据, 数据提取规则)
-- $ 代表整条json数据
-- $.name 代表当前json数据中 key为name的键值对所对应的值
