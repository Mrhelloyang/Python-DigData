# MySQL知识补充

## 知识点01：课程回顾

![image-20240406091811726](Day08：MySQL中的DQL：强化练习.assets/image-20240406091811726.png)



## 知识点02：课程目标

1. MySQL高级开发
   - 目标：**==掌握Select语法的执行顺序==**以及理解存储过程、触发器
2. 知识点回顾梳理以及练习



# ==【模块一：MySQL的高级开发】==

## 知识点03：【掌握】MySQL关键词执行顺序

- **目标**：**理解MySQL关键词执行顺序**

- **实施**

  - **问题：MySQL的select语句中每个部分的先后顺序是什么？**

  - **书写顺序**

    ```sql
    select
    	distinct
    	聚合函数,
    	窗口函数
    from 数据表A
    	join 数据表B on 关联条件
    where 分组前过滤
    group by 分组字段
    having 分组后过滤
    order by 排序字段
    limit 分页查询
    ```

    - ==**执行顺序**==


    ```sql
    1) from
    2) join
    3) on
    4) where
    5) group by
    6) 聚合函数
    7) having
    8) 窗口函数
    9) select
    10) distinct
    11) order by
    12) limit
    ```

    - **限制**：窗口函数不能放在同一条SQL语句的where、group by、having后使用，但是可以放在order by 中使用


    ```mysql
    -- 建表
    CREATE TABLE test_window_orders (
      order_id INT COMMENT '订单id',
      customer_id INT COMMENT '用户id',
      order_date DATE COMMENT '订单日期',
      order_total DECIMAL(10, 2) COMMENT '订单金额',
      product_id INT COMMENT '商品id',
      product_name VARCHAR(50) COMMENT '商品名称',
      product_price DECIMAL(10, 2) COMMENT '商品单价'
    );
    
    INSERT INTO test_window_orders VALUES
    (1, 1, '2022-01-01', 100.00, 1, 'Product A', 20.00),
    (2, 1, '2022-01-02', 50.00, 2, 'Product B', 25.00),
    (3, 2, '2022-01-03', 75.00, 3, 'Product C', 15.00),
    (4, 2, '2022-01-04', 200.00, 1, 'Product A', 20.00),
    (5, 2, '2022-01-05', 30.00, 2, 'Product B', 25.00),
    (6, 3, '2022-01-06', 90.00, 3, 'Product C', 15.00),
    (7, 3, '2022-01-07', 40.00, 1, 'Product A', 20.00),
    (8, 4, '2022-01-08', 150.00, 2, 'Product B', 25.00),
    (9, 4, '2022-01-09', 60.00, 3, 'Product C', 15.00),
    (10, 5, '2022-01-10', 50.00, 1, 'Product A', 20.00),
    (11, 5, '2022-01-11', 100.00, 2, 'Product B', 25.00),
    (12, 5, '2022-01-12', 45.00, 3, 'Product C', 15.00);
    
    -- 在order by 中使用窗口函数的结果
    select
        order_id,
        customer_id,
        order_date,
        order_total,
        row_number() over (partition by customer_id order by order_date) as rn
    from test_window_orders
    order by rn;
    ```

  - **思考1**：如果一个SQL语句中，既有分组，又有窗口函数会是什么结果，一条还是多条？

    ```mysql
    -- 既有分组，也有分区
    select
        customer_id,
        count(order_id),
        row_number() over (partition by count(order_id) order by customer_id)
    from test_window_orders
    group by customer_id;
    ```

    - 分组聚合先执行
    - 窗口及基于分组聚合的结果再构建窗口计算

  - **思考2**：为什么在select在having之后执行，可是having中却可以使用select中的别名呢？

    ```mysql
    select
        customer_id,
        count(order_id) as cnt
    from test_window_orders
    group by customer_id
    having cnt > 2;
    ```

    - 数据库：MySQL优化器允许用户在having使用别名，底层优化时候自动进行表达式替换
    - 连接器：负责连接，接受客户端请求
    - 解析器：将SQL语句进行解析：发现语法错误，数据库、表、字段是否存在
    - 编译器：将SQL语句抽象成底层语法树
    - 优化器：优化你的执行过程
    - 执行器：负责执行整个任务

- **小结**：理解MySQL关键词执行顺序



## 知识点04：【理解】变量的定义与使用

- **目标**：**理解变量的定义与使用**

- **实施**

  - **问题1：什么是变量？**

    - 定义：变量是在编程和数据库中用来存储和表示数据的一个有名称的内存位置

    - 理解：变量是用于将代码中的值用一个固定的名称来表示，允许对这个名称的值进行修改来简化代码和提高代码维护性

    - 举个栗子

      - 场景需求

        ```mysql
        drop database if exists db_other;
        create database if not exists db_other;
        use db_other;
        
        create table if not exists tb_order
        as
        select 'o001' as oid, '2024-01-01' as o_dt, 199.99 as o_amt, 150 as actual_amt
        union all
        select 'o002' as oid, '2024-01-01' as o_dt, 99.9 as o_amt, 99.9 as actual_amt
        union all
        select 'o003' as oid, '2024-01-01' as o_dt, 100 as o_amt, 80 as actual_amt
        union all
        select 'o004' as oid, '2024-01-02' as o_dt, 500 as o_amt, 499 as actual_amt
        union all
        select 'o005' as oid, '2024-01-02' as o_dt, 300 as o_amt, 200 as actual_amt
        union all
        select 'o006' as oid, '2024-01-03' as o_dt, 400 as o_amt, 1 as actual_amt
        ;
        
        
        create table if not exists tb_product
        as
        select 'p001' as pid, 1000 as sal_price, 150 as num
        union all
        select 'p002' as pid, 900 as sal_price, 150 as num
        union all
        select 'p003' as pid, 800 as sal_price, 150 as num
        union all
        select 'p004' as pid, 700 as sal_price, 150 as num
        union all
        select 'p005' as pid, 600 as sal_price, 150 as num
        union all
        select 'p006' as pid, 500 as sal_price, 150 as num
        ;
        
        select * from tb_order;
        select * from tb_product;
        
        /*
            1、查询9折以下的订单【包含】
            2、查询所有的商品如果按照9折出售的售价【包含】
        */
        ```

      - 没有变量

        ```mysql
        -- 没有变量
        -- 需求1
        select *, actual_amt / o_amt as discount
        from tb_order
        where actual_amt / o_amt <= 0.9;
        
        -- 需求2
        select * , sal_price * 0.9 as discount_price from tb_product;
        ```

      - 场景问题

        - 问题1：如果有很多对9折处理的需求，那每条SQL中都要写一个0.9，占用内存
        - 问题2：如果领导突然要修改为8折，怎么办？

      - 有了变量

        ```mysql
        -- 有了变量
        set @discount_rate=0.9;
        
        -- 需求1
        select *, actual_amt / o_amt as discount
        from tb_order
        where actual_amt / o_amt <= @discount_rate;
        
        -- 需求2
        select * , sal_price * @discount_rate as discount_price from tb_product;
        ```

    - 设计优点：优化内存结构，提高代码维护性

  - **问题2：变量如何申明和引用？**

    - 会话变量：对整个MySQL本次连接有效，如果连接断开，会自动失效，一般用于定义一些固定配置的变量，例如字符集

      - 定义

        ```mysql
        set @变量名 = 值;
        ```

      - 引用

        ```mysql
        select @变量名;
        ```

    - 存储过程变量

      - 定义

        ```
        DECLARE 变量名 变量类型 [DEFAULT 默认值];
        ```

      - 引用

        ```
        select 变量名;
        ```

  - **问题3：变量在哪些场景下会使用？**

    - `SET`适合用于保存和管理会话相关的参数，如设置全局的SQL模式、临时更改字符集等。
    - `DECLARE`适合于在存储过程或函数内部进行数据处理、逻辑控制时所需的临时变量。

- **小结**：理解变量的定义与使用



## 知识点05：【理解】存储过程的开发

- **目标**：**理解存储过程的开发**

- **实施**

  - **问题1：什么是存储过程？**

    - 功能：存储过程是一组预先定义的SQL语句，被当做一个单元来执行。它提供了高效的数据处理和逻辑控制，有助于简化复杂任务、提高数据库性能并减少网络流量。

    - 场景：如果一个或者多个SQL需要反复被执行，可以将它们组合成一个整体，然后每次调用这个整体运行，不用重复开发

    - 举个栗子

      - 场景需求

        ```sql
        use db_other;
        -- 学生信息表：学生id、学生姓名
        CREATE TABLE students (
            student_id INT,
            student_name VARCHAR(50)
        );
        
        -- 插入学生数据
        INSERT INTO students (student_id, student_name) VALUES
        (1, '张三'),
        (2, '李四'),
        (3, '王五');
        
        
        -- 课程信息表：课程id、课程名称
        CREATE TABLE course (
            course_id INT,
            course_name VARCHAR(50)
        );
        
        -- 插入课程数据
        INSERT INTO course VALUES
        (1, '英语'),
        (2, '语文'),
        (3, '数学');
        
        -- 学生成绩表：学生id、课程id、课程成绩
        CREATE TABLE grades (
            student_id INT,
            course_id INT,
            score DECIMAL(5, 2)
        );
        
        -- 插入成绩数据
        INSERT INTO grades (student_id, course_id, score) VALUES
        (1, 1, 85.6),
        (1, 2, 78.3),
        (1, 3, 92.7),
        (2, 1, 90.2),
        (2, 2, 88.5),
        (3, 1, 76.4);
        
        -- 查询指定同学的成绩信息
        -- 需求1：查询 学号为1的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        -- 需求2：查询 学号为2的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        -- 需求3：查询 学号为3的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        ```

      - 没有存储过程

        ```sql
        -- 需求1：查询 学号为1的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        select concat(
                    (select student_name from students where student_id = 1),
                    '学习的课程个数为：',
                    (select count(1) as cnt from grades where student_id = 1),
                    '，',
                    '学习的课程名称为：',
                    (select group_concat(course_name) as course_name from grades a join course b on a.course_id = b.course_id where student_id = 1),
                    '，',
                    '课程平均分为：',
                    (select round(avg(score), 2) as avg_score from grades where student_id = 1),
                    '。'
                   ) as rs;
        
        -- 需求2：查询 学号为2的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        select concat(
                    (select student_name from students where student_id = 2),
                    '学习的课程个数为：',
                    (select count(1) as cnt from grades where student_id = 2),
                    '，',
                    '学习的课程名称为：',
                    (select group_concat(course_name) as course_name from grades a join course b on a.course_id = b.course_id where student_id = 2),
                    '，',
                    '课程平均分为：',
                    (select round(avg(score), 2) as avg_score from grades where student_id = 2),
                    '。'
                   ) as rs;
        
        -- 需求3：查询 学号为3的同学 参加的所有课程个数、课程名称和平均分数，结果显示：姓名  学习的课程个数为；A，课程的名称为：B，课程平均分为：C
        select concat(
                    (select student_name from students where student_id = 3),
                    '学习的课程个数为：',
                    (select count(1) as cnt from grades where student_id = 3),
                    '，',
                    '学习的课程名称为：',
                    (select group_concat(course_name) as course_name from grades a join course b on a.course_id = b.course_id where student_id = 3),
                    '，',
                    '课程平均分为：',
                    (select round(avg(score), 2) as avg_score from grades where student_id = 3),
                    '。'
                   ) as rs;
        ```

      - 有了存储过程

        ```mysql
        -- 创建存储过程
        DELIMITER //
        
        drop procedure if exists GetStudentGradeInfo;
        CREATE PROCEDURE GetStudentGradeInfo (IN student_id_param INT)
        BEGIN
            DECLARE stu_name varchar(200);
            DECLARE total_courses_cnt INT;
            DECLARE total_courses_name varchar(200);
            DECLARE total_avg_score DECIMAL(5, 2);
        
            select student_name
            into stu_name
            from students where student_id = student_id_param;
        
            select count(1) as cnt
            into total_courses_cnt
            from grades where student_id = student_id_param;
        
            select group_concat(course_name) as course_name
            into total_courses_name
            from grades a join course b on a.course_id = b.course_id where student_id = student_id_param;
        
            select round(avg(score), 2) as avg_score
            into total_avg_score
            from grades where student_id = student_id_param;
        
        
            IF total_courses_cnt > 0 THEN
                SELECT CONCAT(stu_name, '学习的课程个数为：', total_courses_cnt,'，', '学习的课程名称为：',total_courses_name,'，', '课程平均分为：',total_avg_score,'。') AS result;
            ELSE
                SELECT '这个学生没有课程信息。' AS result;
            END IF;
        END //
        
        DELIMITER ;
        
        -- 调用存储过程
        call GetStudentGradeInfo(3);
        ```

  - **问题2：怎么开发存储过程？**

    - 定义

      ```sql
      CREATE PROCEDURE 存储过程的名字 (输入的参数【in】和输出的参数【out】)
      BEGIN
          -- SQL语句或代码块
      END;
      ```

    - 注意：由于存储过程内部的代码块也是SQL，可以是多条SQL，所以必须修改默认的分隔符，不然存储过程无法定义

      ```mysql
      # 修改默认分隔符
      DELIMITER //
      
      # 定义存储过程
      CREATE PROCEDURE ……
      
      # 恢复默认分隔符
      DELIMITER ;
      ```

    - 调用

      ```mysql
      call  存储过程名称(参数)
      ```

    - 删除

      ```mysql
      drop procedure if exists 存储过程名称;
      ```

- **小结**：理解存储过程的开发



## 知识点06：【理解】触发器的开发

- **目标**：**理解触发器的开发**

- **实施**

  - **问题1：什么是触发器？**

    - 功能：实时监测数据库表上的数据变化，并在特定事件发生时自动执行操作，在确保数据完整性和一致性的同时进行复杂的业务处理。

    - 理解：监听MySQL中的数据变化，当MySQL在发生A这个事情的时候可以自动的执行B这个操作

    - 场景：实现自动化处理、自动化监听效果

    - 举个栗子

      - 场景需求：当用户下订单的时候，更新商品的库存

        ```mysql
        use db_other;
        -- 创建订单表
        CREATE TABLE orders (
            order_id INT AUTO_INCREMENT PRIMARY KEY,
            product_id INT,
            quantity INT,
            total_amount DECIMAL(10, 2)
        );
        
        INSERT INTO orders (product_id, quantity, total_amount) VALUES
        (1, 2, 1500.00),
        (2, 5, 3000.00),
        (3, 3, 450.00);
        
        -- 创建商品表
        CREATE TABLE products (
            product_id INT AUTO_INCREMENT PRIMARY KEY,
            product_name VARCHAR(50),
            price decimal(10,2),
            stock_quantity INT
        );
        
        INSERT INTO products (product_name, price, stock_quantity) VALUES
        ('火箭', 750, 100),
        ('坦克', 600, 150),
        ('AK47', 150, 200);
        
        select
            a.*,
            p.*
        from orders a join products p on a.product_id = p.product_id;
        ```

      - 没有触发器

        ```sql
        # step1：锁定库存，更新库存
        update products set stock_quantity = stock_quantity - 10 where product_id = 1;
        # step2：生成订单
        INSERT INTO orders (product_id, quantity, total_amount) VALUES (1, 10, 7500.00);
        ```

      - 有了触发器

        ```sql
        -- 有了触发器
        # 定义触发器
        DELIMITER //
        
        CREATE TRIGGER update_product_stock_quantity
        AFTER INSERT ON orders FOR EACH ROW
        BEGIN
            DECLARE sold_quantity INT;
            SELECT NEW.quantity INTO sold_quantity;
            UPDATE products SET stock_quantity = stock_quantity - sold_quantity
            WHERE products.product_id = NEW.product_id;
        END //
        DELIMITER ;
        
        # 生成订单
        INSERT INTO orders (product_id, quantity, total_amount) VALUES (1, 10, 7500.00);
        
        select
            a.*,
            p.*
        from orders a join products p on a.product_id = p.product_id;
        ```

  - **问题2：怎么开发触发器？**

    - 定义

      ```sql
      CREATE TRIGGER 触发器名称
      BEFORE|AFTER INSERT|UPDATE|DELETE ON 监听的表名
      FOR EACH ROW
      BEGIN
          -- 触发器响应SQL逻辑
      END;
      ```

    - 注意：由于触发器的代码块也是SQL，可以是多条SQL，所以必须修改默认的分隔符，不然无法定义

    - 删除

      ```mysql
      DROP TRIGGER IF EXISTS 触发器名称;
      ```

- **小结**：理解触发器的开发





# ==【模块二：综合练习】==

## 知识点07：【掌握】MySQL核心知识梳理

- **目标：掌握MySQL整体核心知识梳理**
- **实施**
  - **概念**

    - 定义：是一个关系型数据库【RDBMS】管理系统
    - 公司：Oracle旗下的产品，分为社区版【免费】和商业版【收费】两个版本
    - 功能：基于表格化的形式提供数据存储，基于简洁查询语句对数据进行读写
    - 架构：CS架构，客户端服务端架构
    - 对象：数据库DataBase、数据表Table
    - 开发：SQL语言
    - 分类：
      - DDL：数据定义语言：create、drop、show、use、desc、truncate、alter
      - DML：数据操作语言：insert、update、delete
      - DQL：数据查询语言：select
      - DCL：数据控制语言

  - **DDL**

    - 数据库
      - 创建：create database if not exists 数据库名称;
      - 删除：drop  database if exists 数据库名称;
      - 列举：show databases;
      - 切换：use 数据库名称;
    - 数据表
      - 创建：create  table if not exists 数据库.表名(列名  类型 约束   注释 ……) 表的注释  配置;
        - 注释：comment  ‘注释内容’
        - 类型
          - 数值：tinyint、int、bigint、double、decimal
          - 时间：date、datetime、timestamp
          - 字符串：char、varchar、text
        - 约束
          - 非空：not null：限定这一列的值不能为空
          - 默认：default：如果不给定列的值，会赋予默认值
          - 唯一：unique：限定这一列的值不能重复
          - 主键：primary key：自带非空和唯一约束并提供主键索引，主键只能有1个，可以用自增auto_increment
          - 外键：约束了这一列作为外键它的值必须来自于父表的主键列的值
      - 删除：drop  table if exists 数据库.表名；
      - 列举：show tables [in  数据库]；
      - 描述：desc 数据库.表名;
      - 清空：truncate  数据库.表名;

  - **DML**

    - insert
      - insert into 数据库.表名(列名)  values  (值1)， （值2）；
      - insert into 数据库.表名 set col1 = v1 , col2 = v2 ……；
      - insert into 数据库.表名 select ……
    - update：update 数据库.表名 set col1 = v1 , col2 = v2 where ……
    - delete：delete from 数据库.表名 where ……

  - **DQL单表**

    ```
    select 1 from 2  where 3 group by 4 having 5 order by 6 limit 7
    ```

  - **DQL多表**

    - 关联

      - 列关联：join
        - 语法：from  A  join B on 关联条件
        - 内连接：inner
          - 普通内连接：from  A  join B on 关联条件：两边都有结果才有
          - 交叉连接：from  A  join B   或者  from A, B ：构建笛卡尔积
        - 外连接：outer
          - left join：左边有，结果就有
          - right join：右边有，结果就有
        - 自连接：自己与自己连接
      - 行关联：union
        - union：直接实现行的合并并去重
        - union all：直接实现行的合并但不去重
        - 要求：字段个数和类型必须相等
        - 去重：distinct、group by、union、 row_number、group_concat

    - 子查询

      - 本质：SQL语句中嵌套了select语句

      - 条件子查询：where后面

      - 数据源子查询：from后面

        ```
        with t1 as (
        	select1
        ), t2 as (
        	select2
        )
        ……
        select ……
        ```

      - 字段子查询：select后面

  - **函数**：聚合函数、字符串函数、时间、数值、逻辑判断函数、窗口函数
- **小结**：掌握MySQL整体核心知识梳理



## 知识点08：【实现】DDL、DML练习

- **目标**：**实现DDL、DML的练习**

- **实施**

  - 需求1：请写出通过root用户登陆本地mysql的命令？

    ```
    mysql -u root -p
    ```

  - 需求2：MySQL的架构是什么架构？

    ```
    CS架构：客户端服务端模式架构
    ```
  
  - 需求3：什么是约束，约束有哪些？
  
    ```
    约束本质就是限制条件：限制了数据表中的列的内容
    非空、默认、唯一、主键、外键
    ```
  
  - 需求4：Join连接查询有哪几种？
  
    ```
    内连接
    	普通内连接：from A join B on 条件
    	交叉连接：from A join B 或者 from A, B
    外连接
    	左连接：from  A  left join B
    	右连接：from  A  right join B
    自连接：from  A join A
    ```
  
  - 需求5：根据以下需求，实现建库建表
  
    - 创建一个db_student数据库，如果存在就先删除再创建
    - 创建学生表 tb_stu
         - s_id：学生id，主键，字符串类型，不超过20个字符
      - s_name：学生名称，字符串类型，不超过20个字符，非空
      - s_age：学生年龄，整形，默认为0
      - s_gender：学生性别，字符串类型，不超过10个字符
    - 创建教师表 tb_tea
      - t_id：教师id，主键，字符串类型，不超过20个字符
      - t_name：教师名称，字符串类型，不超过20个字符，非空
    - 创建课程表 tb_course
        - c_id：课程id，主键，字符串类型，不超过20个字符
        - c_name：课程名称，字符串类型，不超过20个字符， 非空
        - t_id：教师id
    - 创建成绩表 tb_score
        - sc_id：成绩id，主键，自增
        - s_id：学生id，字符串类型，不超过20个字符
        - c_id：课程id，字符串类型，不超过20个字符
        - score：分数，整形
    
  - 需求6：对每张表插入数据
  
    - tb_stu
  
      ```
    ('s001', '张三', 20, '男'),
      ('s002', '李四', 18, '女'),
    ('s003', '王五', 22, '男'),
      ('s004', '赵六', 18, '男'),
    ('s005', '田七', 22, '男'),
      ('s006', '钱八', 22, '女');
      ```
  
    - tb_tea
  
      ```
      ('t001', '周杰伦'),
      ('t002', '张译'),
      ('t003', '于谦');
      ```
      
    - tb_course
    
      ```
      ('c001', '语文', 't003'),
      ('c002', '数学', 't002'),
      ('c003', '英语', 't004');
      ```
    
    
    - tb_score
    
      ```
      (null, 's001', 'c001', 90),
      (null, 's001', 'c002', 80),
      (null, 's001', 'c003', 70),
      (null, 's002', 'c001', 30),
      (null, 's002', 'c003', 59),
      (null, 's003', 'c001', 81),
      (null, 's003', 'c003', 49),
      (null, 's004', 'c001', 90),
      (null, 's004', 'c002', 80),
      (null, 's004', 'c003', 70),
      (null, 's005', 'c001', 100),
      (null, 's005', 'c002', 80),
      (null, 's005', 'c003', 70),
      (null, 's006', 'c001', 45),
      (null, 's006', 'c003', 21);
      ```
    
  - 需求7：修改tb_stu表，删除年龄列【写出命令即可，不用真的运行，后续还要用到这一列】
  
  - 需求8：插入一条课程信息，c004，音乐，t001
  
  - 需求9：将田七这个学生的性别修改成女
  
  - 需求10：删除音乐课的课程信息
  
- **小结**：实现DDL、DML的练习



## 知识点09：【实现】DQL练习

- **目标**：**实现DQL的练习**

- **实施**

  ```mysql
  # 修改tb_stu表，删除年龄列【写出命令即可，不用真的运行，后续还要用到这一列】
  # alter table tb_stu drop s_age;
  
  # 插入一条课程信息，c004，音乐，t001
  -- 课程表
  insert into tb_course values ('c004', '音乐', 't001');
  
  # 将田七这个学生的性别修改成女
  update tb_stu set s_gender = '女' where s_name = '田七';
  
  # 删除音乐课的课程信息
  delete from tb_course where c_name = '音乐';
  
  -- 查询所有20岁以上的学生的信息
  -- 学生信息：学生表
  select *
  from tb_stu
  where s_age > 20;
  
  -- 查询所有学生的信息并按照年龄降序排序，如果年龄相同，则按照学号升序排序
  select *
  from tb_stu
  order by s_age desc, s_id asc;
  
  -- 查询所有20岁以上的女性及20岁以下的男生的学号和姓名
  select s_id
          , s_name
  from tb_stu
  where (s_age > 20 and s_gender = '女') or (s_age < 20 and s_gender = '男')
  ;
  
  -- 查询所有学生的考试成绩，结果显示学号，姓名，科目名称，成绩
  -- 学号、姓名：学生表
  -- 科目名称：课程表
  -- 成绩：成绩表
  select
      s.s_id
      , s_name
      , c_name
      , score
  from tb_stu s
  join tb_score score on s.s_id = score.s_id
  join tb_course c on score.c_id = c.c_id
  ;
  
  -- 查询所有学生的考试科目信息，结果显示学号，姓名，科目名称，教师名称
  -- 学号、姓名：学生表
  -- 科目名称：课程表
  -- 教师名称：教师表
  select
      s.s_id
      , s_name
      , c_name
      , t_name
  from tb_stu s
  join tb_score score on s.s_id = score.s_id
  join tb_course c on score.c_id = c.c_id
  join tb_tea t on c.t_id = t.t_id
  ;
  
  -- 统计每个科目的平均分，最高分，最低分，并按照科目平均分降序排序
  -- 结果：科目名称、平均分、最高分、最低分
  -- 科目名称：课程表
  -- 分数：成绩表
  select
      c_name
      , avg(score) as avg_score
      , max(score) as max_score
      , min(score) as min_score
  from tb_score a join tb_course c on a.c_id = c.c_id
  -- 分组
  group by c_name
  -- 排序
  order by avg_score desc;
  
  -- 统计查询科目平均分高于70分的科目信息
  select
      c_name
      , avg(score) as avg_score
  from tb_score a join tb_course c on a.c_id = c.c_id
  -- 分组
  group by c_name
  -- 筛选
  having avg_score > 70;
  
  -- 查询哪些老师没有课
  -- 子查询
  select *
  from tb_tea
  where t_id not in (select t_id from tb_course)
  ;
  
  -- 外连接
  select
      a.*
  from tb_tea a left join tb_course b on a.t_id = b.t_id
  where b.t_id is null;
  
  -- 统计每个科目及格的人数，结果显示科目名称，及格人数，不及格人数（60分为及格线）
  -- 结果
  -- 科目名称：课程表
  -- 是否及格：成绩表
  with t1 as (
      # step1：先基于成绩表，计算每个科目的及格人数和不及格人数
      select c_id
              , count(case when score >= 60 then s_id else null end ) as 及格人数
              , sum(case when score < 60 then 1 else 0 end ) as 不及格人数
      from tb_score
      -- 分组
      group by c_id
  )
  # step2：将上面的结果与课程关联，得到每个课程的名称
  select
      c.c_name
      , t1.及格人数
      , t1.不及格人数
  from t1 join tb_course c on t1.c_id = c.c_id
  ;
  
  
  -- 查询既参加了语文考试又参加了数学考试的学生的信息
  -- 学生信息：学生表
  select *
  from tb_stu
  where s_id in (select
      a.s_id
  from (select
          s_id
      from tb_score
      join tb_course tc on tb_score.c_id = tc.c_id
      where c_name = '语文') a
  join (select
          s_id
      from tb_score
      join tb_course tc on tb_score.c_id = tc.c_id
      where c_name = '数学'
      ) b
  on a.s_id = b.s_id)
  ;
  
  -- 将学习语文的同学id获取到
  select
      s_id
  from tb_score
  join tb_course tc on tb_score.c_id = tc.c_id
  where c_name = '语文'
  ;
  
  -- 将学习数学的同学id获取到
  select
      s_id
  from tb_score
  join tb_course tc on tb_score.c_id = tc.c_id
  where c_name = '数学'
  ;
  
  -- 通过内连接查询两者交集
  select
      a.s_id
  from (select
          s_id
      from tb_score
      join tb_course tc on tb_score.c_id = tc.c_id
      where c_name = '语文') a
  join (select
          s_id
      from tb_score
      join tb_course tc on tb_score.c_id = tc.c_id
      where c_name = '数学'
      ) b
  on a.s_id = b.s_id
  ;
  
  -- 查询每个科目成绩最高的前两名同学的信息
  with t1 as (
      select *
           , row_number() over (partition by c_id order by score desc) as rn
      from tb_score
  )
  select * from t1 where rn < 3
  ;
  ```

  - 思考：查询和"s002"号的同学学习的课程完全相同的其他同学的信息 ，如何实现？

- **小结**：实现DQL的练习

