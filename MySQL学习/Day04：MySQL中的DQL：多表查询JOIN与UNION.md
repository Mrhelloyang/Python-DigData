# MySQL中的DQL：多表查询Join与Union

## 知识点01：课程回顾

![image-20240331094435722](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20240331094435722.png)



## 知识点02：课程目标

1. 多表关系以及外键

   - 目标：理解多表设计以及多表关系
   - 问题1：为什么要设计多表？
     - 单表存储面临问题：1、维护管理成本较高。2、查询分析效率非常差。
     - 解决方案：按照业务需求通过建模方式将不同的数据存储在不同数据表中
   - 问题2：怎么能够体现表与表之间关系呢？
     - 将拥有数据关系的表中存放用于关联别的数据表的数据列
   - 问题3：怎么能够保证这个关系一定是正确的？
     - 约束：外键约束
     - 功能：限定子表中的列的数据只能引用自父表的主键
     - 顺序
       - 创建表：先建父表，再建子表
       - 删除表：先删子表，再删父表

2. **==多表查询：Join==**

   - 目标：**==掌握Join的功能语法和分类==**

   - 问题1：什么是join？

     - 功能：用于基于SQL实现多张表数据**列**的合并

     - 语法

       ```
       select
       	A.*
       	, B.*
       	, C.*
       from A 
       join B on A.col1 = B.col1 and/or A.col2 = B.col2
       # 这一步的join是基于上一步的join以后的结果再与C进行关联的
       join C on A.col3 = C.col3
       ;
       ```

     - 场景：1、需要将多表的列进行合并，2、求两张表集合的差值或者共同值，3-实现一些特殊行值关联的需求

   - 问题2：join分为哪几类？

     - 内连接：inner  join：找交集，公共的部分
       - 普通内连接：A join B  on 关联条件：两边都有，结果才有
       - 交叉连接：A join B  或者  from  A, B ：会产生笛卡尔积，结果条数 = A的行数 * B的行数
     - 外连接：outer  join：找差值，不一样的地方
       - 左连接：left  join：以左边为准，左边有，结果一定会有，右边没有的补mull
       - 右连接：right join：以右边为准，右边有，结果一定会有，左边没有的补null
       - 全连接：full  join：两边任意一边有，结果就有，MYSQL 不支持该语法
     - 自连接：自己与自己连接

3. 多表查询：Union

   - 目标：**掌握Union的使用以及distinct的使用**
   - 问题1：什么是union？
     - 功能：实现多张数据表**行**的合并
     - 要求：不同数据表的列的个数、类型必须一致
     - 语法：union【去重】/  union all 【不去重】
   - 问题2：什么是distinct？
     - 功能：实现对于数据列的去重
     - 语法：select  distinct  colName



# ==【模块一：多表查询：表关系与外键】==

## 知识点03：【理解】数据表的关系

- **目标**：**理解数据表的关系**

- **实施**

  - **问题1**：假设现在公司做了一个电商网站，请问这个网站后台应该存储哪些核心的数据？

    - 表的目的：为了存储数据，提供数据读写
    - 注册：用户信息，记录用户的用户名、密码、手机号、性别、收货地址
    - 登陆：用户登录信息，记录用户所有登录时间、访问信息、浏览信息
    - 浏览：商品信息，记录了每个商品的类别、名称、价格、库存、颜色、尺寸
    - 加购/收藏：行为信息，记录每个用户的购物车、收藏列表、搜索信息
    - 下单：订单信息，记录每个用户购买的每个商品的订单，订单id、订单金额、订单时间、支付方式、支付状态、物流状态

    ![image-20230407110612686](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230407110612686.png)

  - **问题2**：如果要存储这些数据，应该如何存储，存储在一张表中行不行？行

    ![image-20230404103622864](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404103622864.png)

  - **问题3**：上面这种设计，将所有信息存储在一张表中，有没有什么问题？

    - 用户登录时，我们需要通过用户名，读取用户的密码验证，或者用户注册的时候，只需要记录用户的信息
    - 用户浏览某个商品时，我们需要通过商品id，读取这个商品具体的信息展示给用户
    - 用户查询订单时，我们需要将订单的核心信息：状态、时间、用户id、商品信息展示给用户
    - ||
    - 问题：效率非常差，每次读写基于整张表所有字段进行读写

  - **问题4**：那企业中如何解决这个问题，如何实现订单业务系统的数据存储？

    - 多表的划分：将不同的业务操作放入不同表中进行处理
    - 用户读写：用户表
    - 商品读写：商品表
    - 订单读写：订单表

    ![image-20230404105532886](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404105532886.png)

  - **问题5**：将数据分开存储，解决了读写不方便的问题，但是如何让数据对应起来，我们怎么知道订单是什么人买了什么商品？

    ![image-20230404110733440](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404110733440.png)

    - 上图中的用户id、商品id我们可以称为三张表关系的外键

  - **测试实现**

    ```mysql
    -- 建库
    DROP DATABASE IF EXISTS db_multi_tb;
    CREATE DATABASE db_multi_tb;
    USE db_multi_tb;
    
    
    /*
        订单表：订单id、下单时间、订单金额、订单状态、用户id、商品id
        用户表：用户id、用户名称、用户性别、用户城市、用户生日
        商品表：商品id、商品名称、商品单价、商品库存、商品类别
     */
    
    -- 创建订单表
    DROP TABLE IF EXISTS tb_order;
    CREATE TABLE IF NOT EXISTS tb_order(
        o_id varchar(20) primary key comment '订单id',
        o_time datetime not null comment '下单时间',
        o_amount decimal(10, 2) default 0.00 not null comment '订单金额',
        o_status int comment '订单状态，1-已下单，2-已支付，3-已发货，4-已收货，5-已退款',
        u_id varchar(20) not null comment '下单用户id，来自用户表',
        p_id varchar(20) not null comment '下单商品id，来自商品表'
    ) default charset = utf8 comment '订单信息表'
    ;
    
    -- 插入订单数据
    INSERT INTO tb_order
    VALUES ('o001', '2023-01-01 10:00:00', 199.45, 1, 'u002', 'p005'),
           ('o002', '2023-01-01 11:00:00', 88.50, 2, 'u001', 'p001'),
           ('o003', '2023-01-01 12:00:00', 13.33, 2, 'u001', 'p004'),
           ('o004', '2023-01-01 12:00:00', 29.90, 4, 'u002', 'p002'),
           ('o005', '2023-01-02 15:00:00', 0.04, 1, 'u001', 'p003'),
           ('o006', '2023-01-02 16:00:00', 10.00, 1, 'u002', 'p001'),
           ('o007', '2023-01-02 11:00:00', 0.00, 3, 'u003', 'p002'),
           ('o008', '2023-01-03 12:00:00', 10003.5, 4, 'u004', 'p005'),
           ('o009', '2023-01-03 12:00:00', 356.89, 2, 'u002', 'p001'),
           ('o010', '2023-01-04 10:00:00', 20.30, 1, 'u003', 'p002')
    ;
    
    -- 用户表
    DROP TABLE IF EXISTS tb_user;
    CREATE TABLE tb_user(
        u_id varchar(20) primary key comment '用户id',
        u_name varchar(20) not null comment '用户名称',
        u_gender int comment '用户性别，1-男，2-女，3-其他',
        u_city varchar(20) comment '用户城市',
        u_birth date default '2023-01-01' comment '用户生日'
    ) default charset = utf8 comment '用户信息表'
    ;
    
    -- 插入用户数据
    INSERT INTO tb_user
    VALUES ('u001', '周杰伦', 1, '中国台湾', '1979-01-18'),
           ('u002', '蔡依林', 2, '中国台湾', '1980-09-15'),
           ('u003', '凤凰传奇', 3, '中国内蒙古', '2004-01-01'),
           ('u004', '刘德华', 1, '中国香港', '1961-09-27'),
           ('u005', '林子祥',1, '中国香港', '1947-10-12')
    ;
    
    
    -- 商品表
    DROP TABLE IF EXISTS tb_product;
    CREATE TABLE tb_product(
        p_id varchar(20) primary key comment '商品id',
        p_name varchar(20) not null comment '商品名称',
        p_price decimal(20, 2) not null comment '商品单价',
        p_surplus int comment '商品库存' default 0,
        p_category varchar(20) comment '商品类别'
    ) default charset = utf8 comment '商品信息表'
    ;
    
    -- 插入商品数据
    INSERT INTO tb_product
    VALUES ('p001', 'MySQL数据库从入门到跑路', 100.00, 199, '书籍'),
           ('p002', 'Java编程指南', 50.03, 12, '书籍'),
           ('p003', '变形金刚', 399.00, 34, '玩具'),
           ('p004', '迪迦奥特曼', 199.99, 51, '玩具'),
           ('p005', '保时捷911', 1000000, 2, '生活用品'),
           ('p006', '汤臣一品400平小户型', 100000000.00, 1, '生活用品')
    ;
    ```

  - **关系分类**

    - **一对一**：两张表A和B中的数据一一对应

      ![image-20230404122520675](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404122520675.png)

    - **一对多**：两张表A中的一条数据可以对应B中的多条数据

      ![image-20230404122554656](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404122554656.png)

    - **多对多**：两张表中，A表的一条数据可以对应B表的多条数据，B表的一条数据也可以对应A表的多条数据

      ![image-20230404122641239](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404122641239.png)

- **小结**：理解数据表的关系



## 知识点04：【理解】外键约束的设计

- **目标**：**理解外键约束的设计**

- **实施**

  - **问题**：在多表关系中，我们可以用两张表拥有一个相同列形成外键，来维持这个关系，但是怎么保证这个关系的准确性？

  - **例如**

    ```mysql
    -- 没有外键的情况下，插入一条订单数据，用户为u011，商品为p011
    INSERT INTO tb_order
    VALUES ('o011', '2023-01-01 10:00:00', 9.99, 1, 'u011', 'p011');
    ```

  - **设计**：订单表中的用户id只能来自于用户表中已有的id，订单表中的商品id只能来自于商品表中的商品id

  - **百科**

    ```
    如果公共关键字在一个关系中是主关键字，那么这个公共关键字被称为另一个关系的外键。由此可见，外键表示了两个关系之间的相关联系。以另一个关系的外键作主关键字的表被称为主表，具有此外键的表被称为主表的从表。外键又称作外关键字。
    ```

  - **外键约束**

    - 在多表关系中，如果一张  表B  中的一个  字段colB  的值来自于另外一张  表A  中的  主键colA  的值
    - 我们称A为父表，colA为A表的主键【用户表，用户id】
    - 我们称B为子表，colB为B表的外键，数据的内容必须来自于 colA 这一列【订单表，用户id】

  - **特点**

    - 优点：保证了数据的准确性，降低了冗余度
    - 缺点：降低数据增删改的性能，损失了灵活性，增加了复杂度

  - **顺序**

    - 创建和插入：先操作父表，再操作子表
    - 删除的时候：先操作子表，再操作父表

  - **应用**：业务系统中核心数据会用外键约束保证准确性，大数据系统中不使用外键

  - **语法**

    ```mysql
    [ CONSTRAINT '外键的名字' ] 
    FOREIGN KEY (外键列) REFERENCES 父表(主键列)
    [ ON DELETE action ]
    [ ON UPDATE action ]
    ```

  - **解释**

    - CONSTRAINT：表示要定义一个约束，然后取个外键约束的名字，名称唯一，不能相同，可以省略、

    - ACTION：表示如果父表的数据发生了变化，子表的数据怎么处理

      - DELETE ：如果父表的数据删除了，子表怎么办

      - UPDATE ：如果父表的数据更新了，子表怎么办

      - 分类：Restrict，No Action, Cascade,Set Null

        ```properties
        restrict: 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除
        no action: 意思同restrict. 即如果存在从数据，不允许删除主数据
        cascade(级联): 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则也删除外键在子表的数据
        set null: 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为null，要求该外键允许为null
        ```

  - **解决**

    ```mysql
    /*
        外键：用于约束两张表的关系的准确性
    */
    -- 没有外键的情况下，插入一条订单数据，用户为u011，商品为p011
    INSERT INTO tb_order
    VALUES ('o011', '2023-01-01 10:00:00', 9.99, 1, 'u011', 'p011');
    
    -- 创建订单表：这是子表，必须先有父表
    DROP TABLE IF EXISTS tb_order;
    CREATE TABLE IF NOT EXISTS tb_order(
        o_id varchar(20) primary key comment '订单id',
        o_time datetime not null comment '下单时间',
        o_amount decimal(10, 2) default 0.00 not null comment '订单金额',
        o_status int comment '订单状态，1-已下单，2-已支付，3-已发货，4-已收货，5-已退款',
        u_id varchar(20) comment '下单用户id，来自用户表',
        p_id varchar(20) comment '下单商品id，来自商品表',
        foreign key (u_id) references db_multi_tb.tb_user(u_id),
        constraint `order_product_key` foreign key (p_id) references db_multi_tb.tb_product (p_id)
        on delete set null on update cascade
    ) default charset = utf8 comment '订单信息表'
    ;
    
    -- 插入订单数据
    INSERT INTO tb_order
    VALUES ('o001', '2023-01-01 10:00:00', 199.45, 1, 'u002', 'p005'),
           ('o002', '2023-01-01 11:00:00', 88.50, 2, 'u001', 'p001'),
           ('o003', '2023-01-01 12:00:00', 13.33, 2, 'u001', 'p004'),
           ('o004', '2023-01-01 12:00:00', 29.90, 4, 'u002', 'p002'),
           ('o005', '2023-01-02 15:00:00', 0.04, 1, 'u001', 'p003'),
           ('o006', '2023-01-02 16:00:00', 10.00, 1, 'u002', 'p001'),
           ('o007', '2023-01-02 11:00:00', 0.00, 3, 'u003', 'p002'),
           ('o008', '2023-01-03 12:00:00', 10003.5, 4, 'u004', 'p005'),
           ('o009', '2023-01-03 12:00:00', 356.89, 2, 'u002', 'p001'),
           ('o010', '2023-01-04 10:00:00', 20.30, 1, 'u003', 'p002')
    ;
    
    -- 有外键的情况下，插入一条订单数据，用户为u011，商品为p011
    INSERT INTO tb_order
    VALUES ('o011', '2023-01-01 10:00:00', 9.99, 1, 'u011', 'p011');
    
    -- 删除或者更新 用户表的一条数据
    DELETE FROM tb_user WHERE u_id = 'u001';
    UPDATE tb_user SET u_id = 'u033' WHERE u_id = 'u003';
    
    -- 思考更新 非主键列 受影响吗？
    
    -- 删除或者更新 商品表的数据
    DELETE FROM tb_product WHERE p_id = 'p001';
    UPDATE tb_product SET p_id = 'p055' WHERE p_id = 'p005';
    ```

    ![image-20230407120135807](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230407120135807.png)

    ![image-20230407120209513](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230407120209513.png)

  - 其他操作

    ```mysql
    -- 查看表的约束
    SHOW CREATE TABLE 表名;
    -- 删除外键约束
    ALTER TABLE 表名 DROP FOREIGN KEY 外键约束名;
    ```

- **小结**：理解外键约束的设计



# ==【模块二：多表查询：Join 】==

## 知识点05：【掌握】join的功能及语法

- **目标**：**掌握join的功能及设计**

- **实施**

  - **问题**：在多表关系中，如果我想查询多张表的字段数据，怎么实现？例如我想得到以下的一个结果

    ```
    订单id	订单时间	订单金额		用户id		用户名称		商品id		商品名称
    ```

    ![image-20230404135424868](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404135424868.png)

  - ==**解决**：join 列关联==

  - **功能**：用于根据两张表的关系，实现两张表列的拼接

  - **语法**

    ```mysql
    SELECT 
    	A.*,
    	B.*,
    	…
    FROM A 
    [ INNER | OUTER ] JOIN B [ ON A.col = B.col ]
    [ INNER | OUTER ] JOIN C [ ON A.col = C.col ]
    ……
    ```

  - **实现**：**==上面的表由于测试了外键，数据不全，需要删除重建，先删除子表，再删除父表，后续创建不用再指定外键==**

    ```mysql
    -- 实现关联
    SELECT
        tb_order.o_id, tb_order.o_time, tb_order.o_amount, tb_order.u_id,
        tb_user.u_name
    FROM tb_order
    JOIN tb_user ON tb_order.u_id = tb_user.u_id
    ;
    -- 省略写法
    SELECT
        o_id, o_time, o_amount, a.u_id,
        u_name
    FROM tb_order as a
    JOIN tb_user as b ON a.u_id = b.u_id
    ;
    -- 省略as
    SELECT
        o_id, o_time, o_amount, a.u_id,
        u_name
    FROM tb_order a
    JOIN tb_user b ON a.u_id = b.u_id
    ;
    ```

  - **思考**：例如我想得到以下的一个结果，该怎么写？

    ```
    订单id	订单时间	订单金额		用户id		用户名称		商品id		商品名称
    ```

    ![image-20230404134810696](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404134810696.png)

    ```mysql
    -- 三表关联
    select
      a.o_id,
        a.o_time,
      a.o_amount,
        b.u_id,
        b.u_name,
        c.p_id,
        c.p_name
    -- 订单
    from tb_order a
    -- 用户 = 用户id
    join tb_user b on a.u_id = b.u_id
    -- 商品 = 商品id
    join tb_product c on a.p_id = c.p_id
    ```

- **小结**：join的功能及语法是什么？

  - 功能：实现多表的列关联，将多张表中的列进行合并
  - 语法：select A . col, B.col  from A join B on A.col = B.col



## 知识点06：【掌握】内连接 inner join

- **目标**：**掌握内连接inner join**

- **实施**

  - **问题**：订单表中有所有用户的订单，用户表中有所有用户，假设没有约束，有的用户没有下订单，有的订单中的用户不在用户表中，我只想看下了订单的并且在用户表里面的 订单信息和用户信息

  - **例如**

    - 订单表

      ![image-20230404141918444](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404141918444.png)

    - 用户表

      ![image-20230404141939513](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404141939513.png)

    - 查询在用户表中，并且有订单记录的用户id、用户名称、订单id、订单时间、订单金额

      ![image-20230404142211035](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404142211035.png)

  - **功能**：用于根据关联条件，保留**==两边都存在==**的数据

  - **语法**：INNER JOIN，其中 **INNER 可以省略**

  - **场景**：两边都有，结果就有，取两份数据的**交集**

    ![image-20230404143043661](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404143043661.png)

  - **实现**

    ```mysql
    -- 查询在用户表中，并且有订单记录的用户id、用户名称、订单id、订单时间、订单金额
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    INNER JOIN tb_user b on a.u_id = b.u_id
    ```

  - **注意**：在使用内连接时，可以省略 inner 关键词，关联条件也可以省略，如果省略了关联条件，就构建了**==笛卡尔积【交叉连接】==**，我们把这种没有关联条件的join，叫做cross join，结果是两张表的无差别关联，**数据有A * B 条**，一般不建议使用

    ```mysql
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    INNER JOIN tb_user b;
    ```

    ![image-20230404143731185](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404143731185.png)

- **小结**：inner join的功能和语法是什么？什么是笛卡尔积？

  - 功能：实现两张表的关联，只保留两张表都有的部分，取交集
  - 结果：两边都有，结果才有
  - 语法：[inner] join
  - 笛卡尔积：关联的时候没有给定关联条件，实现无差别关联，结果集就是A*B大小



## 知识点07：【掌握】外连接 outer join

- **目标**：**掌握外连接 outer join**

- **实施**

  - **问题**：如果我想要的是左边所有数据，或者右边所有数据，又或者两边所有的数据呢？

    ![image-20230404151311656](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404151311656.png)

  - **需求**

    - 需求一：我想查看所有订单的id、订单时间、订单金额以及对应的用户id、用户名称
    - 需求二：我想查看所有用户的id、用户名称以及每个用户对应的订单的id、订单时间、订单的金额

  - **功能**：用于根据关联条件，保留 左边的 或者 右边的 或者 全部的 数据

  - **语法**：outer关键词可以省略

    - **left outer join**：左连接，保留左边所有的数据行，如果右边没有与之对应的行，则右边表的字段为null
    - **right outer join**：右连接，保留右边所有的数据行，如果左边没有与之对应的行，则左边表的字段为null

  - **场景**

    - left join：左边有，结果就有，用于返回左表的所有数据并带上右表的列
    - right join：右边有，结果就有，用于返回右表的所有数据并带上左表的列

  - **注意**：**==任意一边没有对应的值，就会为null==**

  - **实现**

    ```mysql
    -- 需求一：我想查看所有订单的id、订单时间、订单金额以及对应的用户id、用户名称
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    LEFT JOIN tb_user b ON a.u_id = b.u_id;
    
    -- 需求二：我想查看所有用户的id、用户名称以及每个用户对应的订单的id、订单时间、订单的金额
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    RIGHT JOIN tb_user b ON a.u_id = b.u_id;
    ```

- **小结**：外连接的分类及各自的功能和语法是什么？

  - 分类：左外连接、右外连接
  - 功能：
    - 左连接以左表为准，保留左表所有数据，右表的字段没有就为null【左边有，结果就有】
    - 右连接以右表为准，保留右表所有数据，左表的字段没有就有null【右边有，结果就有】
  - 语法
    - A left [outer] join B
    - A right [outer] join B



## 知识点08：【理解】全连接与自连接

- **目标**：**理解全连接与自连接**

- **实施**

  - **问题1**：在连接中，如果既要保留左边的结果，又要保留右边的结果，关联不上的都补充为null，怎么实现？

    <img src="Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404233025410.png" alt="image-20230404233025410" style="zoom:67%;" />

  - **需求**：两边任意一边有结果就有，任意一边不能匹配的就补充为null

    ![image-20230404233226823](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404233226823.png)

  - **语法**：FULL  OUTER  JOIN，mysql不支持，但是可以使用左连接和右连接的结果进行union得到

    ```sql
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    LEFT JOIN tb_user b ON a.u_id = b.u_id
    UNION
    SELECT
        a.o_id, a.o_time, a.o_amount,
        b.u_id, b.u_name
    FROM tb_order a
    RIGHT JOIN tb_user b ON a.u_id = b.u_id;
    ```

  - **自连接**：自己与自己连接就叫做自连接，**==简单点理解A JOIN A==**

  - **语法**

    ```mysql
    SELECT …… FROM A as a JOIN A as b ON 条件 
    ```

  - **栗子**

    - 数据表

      ```sql
      CREATE TABLE IF NOT EXISTS tb_sales (
          month INT NOT NULL, -- 月份
          sold_amt DECIMAL(10, 2) -- 销售额
      );
      
      INSERT INTO tb_sales
      VALUES
          (1, 1000),
          (2, 800),
          (3, 1200),
          (4, 2000),
          (5, 1800),
          (6, 5000),
          (7, 3000),
          (8, 2500),
          (9, 1600),
          (10, 2200),
          (11, 900),
          (12, 4600);
      
      SELECT * FROM tb_sales;
      ```

      ![image-20230404233828946](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404233828946.png)

    - 结果表：查询每个月比上一个月的增长的销售额：月份、上一个月销售额、当月销售额、增长金额

      <img src="Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20230404234333048.png" alt="image-20230404234333048" style="zoom:80%;" />

    - 实现

      ```mysql
      -- 查询每个月比上一个月的增长的销售额：月份、当月销售额、上一个月销售额、增长金额 = 当月 - 上一个
      select
          a.month,
          a.sold_amt as now_amt,
          b.sold_amt as last_amt,
          a.sold_amt - b.sold_amt as incr_amt
      from tb_sales a
      left join tb_sales b on a.month = b.month + 1
      ```

- **小结**：理解全连接与自连接



![image-20240331164153392](Day04：MySQL中的DQL：多表查询JOIN与UNION.assets/image-20240331164153392.png)



# ==【模块三：多表查询：Union 】==

## 知识点09：【掌握】union的功能及设计

- **目标**：**掌握union的功能及设计**

- **实施**

  - **问题**：join可以实现将两张表的列进行合并，那如何将两张表的行进行合并呢？

  - **需求**：将两份用户的数据进行合并

    ```sql
    -- 查询 订单表的数据
    select * from tb_user;
    
    -- 构造两张测试的数据表
    create table if not exists tb_user_union1
    as
    select u_id, u_name from tb_user
    where u_id <= 'u002';
    
    create table if not exists tb_user_union2
    as
    select u_id, u_name from tb_user
    where u_id >= 'u002';
    
    -- 查询数据
    select * from tb_user_union1;
    select * from tb_user_union2;
    ```

  - **功能**：实现对两张数据表的行的合并

  - **语法**：

    ```mysql
    -- union：会去重
    select …… union select ……
    
    -- union all：不会去重
    select …… union all select ……
    ```

  - **注意**：要求两份数据的字段个数必须一致

  - **实现**

    ```mysql
    -- 实现union
    select * from tb_user_union1
    union
    select * from tb_user_union2;
    
    -- 实现union并排序
    ( select * from tb_user_union1)
    union
    ( select * from tb_user_union2)
    order by u_id desc
    ;
    
    
    -- 实现union all
    select * from tb_user_union1
    union all
    select * from tb_user_union2;
    ```

- **小结**：union的功能和语法的是什么？

  - 功能：实现两张表数据行的合并，要求两张表的字段个数相等
  - 语法
    - union：合并并且去重
    - union all：合并不做去重



## 知识点10：【理解】distinct的功能及使用

- **目标**：**掌握distinct的功能及使用**

- **实施**

  - **问题**：如果数据中本来就有重复的，如何实现数据的去重？

  - **解决**：distinct去重

  - **功能**：用于对表中的数据实现去重

  - **场景**：1、直接在select语句中对字段进行去重。2、在聚合的时候对每组内部进行去重：count(distinct col)

  - **语法**

    ```mysql
    select distinct 字段 from 表
    ```

  - **示例**

    ```mysql
    -- 建表
    drop table if exists tb_user_distinct;
    create table if not exists tb_user_distinct
    as
    select 1 as id , 'laoda' as name
    union all
    select 2 as id , 'laoer' as name
    union all
    select 1 as id , 'laoda' as name
    union all
    select 2 as id , 'laosan' as name
    ;
    
    -- 查询
    select * from tb_user_distinct;
    
    -- 去重id
    select distinct id from tb_user_distinct;
    
    -- 去重name
    select distinct name from tb_user_distinct;
    
    -- 去重多列
    select distinct id, name from tb_user_distinct;
    
    -- 去重行
    select distinct * from tb_user_distinct;
    ```

  - ==**思考**：MySQL去重的方式哪有几种？==

- **小结**：掌握distinct的功能及使用
