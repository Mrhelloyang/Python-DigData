# MySQL中的DQL：多表查询子查询与基础函数

## 知识点01：课程回顾

![image-20240402093325988](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20240402093325988.png)



## 知识点02：课程目标

1. 子查询

   - **==目标：掌握子查询的使用以及分类==**

   - 问题1：什么是子查询？

     - 定义：在一条SQL语句A中包含了另外一条select语句B，称为B为子查询语句，A为主查询语句
     - 理解：在SQL语句中嵌套了另外的select语句
     - 目的：提高代码复用性

   - 问题2：子查询分为哪几类？

     - 条件子查询：select语句的结果作为外部查询的条件：一般放在where或者having后面【大多都可以用join来实现】
     - 数据源子查询：select语句的结果作为外部查询的数据来源：一般都是放在from后面的【常用CTE表达式来开发】
     - 字段子查询：select语句的结果作为外部查询的一列的值：应用场景比较少，很少使用

   - 问题3：什么是CTE表达式？

     - 目标：为了增加子查询代码可读性

     - 场景：只能用于数据源子查询

     - 语法

       ```
       with t1 as (
       	subquery1
       ), t2 as (
       	subquery2
       )
       ……
       select ……
       ```

2. 函数

   - 目标：掌握常用函数
   - 问题1：常用字符串函数有哪些？
     - length、char_length、==concat、concat_ws、substr、replace==、reverse、trim、locate、upper、lower
   - 问题2：常用数值函数有哪些？
     - abs、==rand、ceil、floor、round、truncate==、log、power、sqrt、pi、+、-、*、/ 、%



# ==【模块一：多表查询：子查询 】==

## 知识点03：【掌握】子查询的定义

- **目标**：**掌握子查询的定义与设计**

- **实施**

  - **需求**：查询 所有书籍 类商品的订单信息

    ![image-20230405112443514](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230405112443514-1710308008835.png)

    ```mysql
    -- step1: 先查询书籍类商品的id
    SELECT p_id FROM db_multi_tb.tb_product WHERE p_category = '书籍' ;
    
    -- step2：根据商品id查订单信息
    SELECT * FROM db_multi_tb.tb_order WHERE p_id in ('p001', 'p002');
    ```

  - **问题**：能不能一条SQL语句就搞定，而且不用每次修改代码？

    ```mysql
    SELECT
        *
    FROM db_multi_tb.tb_order
    WHERE p_id in (SELECT p_id FROM db_multi_tb.tb_product WHERE p_category = '书籍')
    ;
    ```

  - **定义**：如果一条SQL语句A内部包含了别的select语句B，我们称B这个查询语句为子查询，SQL A为主查询，A是一个带有子查询的语句

  - 理解：一条SQL语句中如果嵌套了另外一条select语句，这就是子查询语句

  - **设计**：为了提高代码开发效率，避免多次分步骤查询，可以直接在一条SQL语句中实现复杂的数据查询，提高代码复用性

  - **分类**：出现位置进行划分

    - **条件子查询**：查询的条件依赖于另外一个查询语句的结果，可以用于select、delete、update =>  都有where条件过滤中
      - 发生在过滤中：where、having
    - **数据源子查询**：查询的数据来自于另外一个查询语句的结果，主要用于select语句中
      - 发生数据来源中：from
      - 场景：按照步骤对每一步的结果进行处理
    - 字段子查询：查询的字段来自于另外一个查询语句的结果，主要用于select语句中
      - 结果作为字段：select

- **小结**：什么是子查询？

  - 定义：如果一条SQL语句A中包含了另外一条select语句B，称B是一个子查询，A是一个主查询，A是一个带有子查询的SQL语句
  - 设计：为了提高代码复用性，开发效率
  - 分类
    - 条件子查询：where、having
    - 数据源子查询：from
    - 字段子查询：select



## 知识点04：【掌握】条件子查询

- **目标**：**掌握条件子查询**

- **实施**

  - **问题**：什么是条件子查询？

  - **功能**：用于在一条SQL语句中，通过一个子查询来实现条件过滤

  - **场景**：一般用在where子句中， 支持select、update、delete，过滤条件依赖于一条select语句的结果

  - **语法**

    ```mysql
    select …… from where …… (select ……)
    update ……  where …… (select ……)
    delete from …… where …… (select ……)
    ```

  - **示例**

    ```mysql
    -- 查询 所有单价在100 到 300 之间的商品的 订单信息
    -- join
    select
        a.*
    from tb_order a join tb_product b on a.p_id = b.p_id
    where b.p_price between  100 and 300;
    
    -- sub query
    select *
    from tb_order
    where p_id in (select p_id from tb_product where p_price between 100 and 300);
    
    
    -- 查询 所有来自 中国台湾的 女性 用户的 订单信息
    -- 内部：找出所有来自中国台湾的女性用户的id
    select u_id from tb_user where u_city = '中国台湾' and u_gender = 2;
    -- 外部
    select *
    from tb_order
    where u_id in (select u_id from tb_user where u_city = '中国台湾' and u_gender = 2);
    
    
    -- 查询 城市用户超过1人的 所有城市的用户的订单信息
    
    -- 内层：先统计每个城市有多少人，过滤出超过1人的城市
    select
        u_city,
        count(u_id) as cnt
    from tb_user
    group by u_city
    having cnt > 1
    ;
    
    -- 中层：获取这些城市包含的用户的id
    select u_id
    from tb_user
    where u_city in (select
                        u_city
                    from tb_user
                    group by u_city
                    having count(u_id) > 1)
    ;
    
    
    -- 外层：获取这些用户的订单信息
    select *
    from tb_order
    where u_id in (select u_id
                    from tb_user
                    where u_city in (select
                                        u_city
                                    from tb_user
                                    group by u_city
                                    having count(u_id) > 1));
    
    
    -- 删除 出生日期为 2004-01-01的所有用户 订单信息
    -- 内部
    select u_id from tb_user where u_birth = '2004-01-01';
    -- 外部
    delete from tb_order where u_id in (select u_id from tb_user where u_birth = '2004-01-01');
    
    
    -- 更新 所有高于平均商品单价的商品  的库存量加1
    -- 内部：先计算出哪些商品的单价高于商品平均单价
    select avg(p_price) as avg_price from tb_product;
    
    -- 外部：MySQL不允许直接基于自己的查询去修改或者删除自己
    update tb_product set p_surplus = p_surplus + 1 where p_price > (select avg(p_price) as avg_price from tb_product);
    
    -- 骗一下
    update tb_product set p_surplus = p_surplus + 1 where p_price > (
        select
            t.avg_price
        from (select avg(p_price) as avg_price from tb_product) t
        );
    ```

- **小结**：什么是条件子查询？

  - 定义：子查询出现在where中，利用子查询的结果作为查询条件
  - 场景：select、update、delete
  - 规律：结果来自于某张表，条件必须依赖于另外一张表



## 知识点05：【掌握】数据源子查询

- **目标**：**掌握数据源子查询**

- **实施**

  - **问题**：什么是数据源子查询？

  - **功能**：用于在一条SQL语句中，通过一个子查询来构造查询的数据内容

  - **场景**：一般用在select语句中，**==常用于继续对上一步的结果继续进行处理==**

  - **语法**

    ```mysql
    select …… from (select ……)
    ```

  - **示例**

    ```mysql
    -- 统计 总消费金额在500以上 的用户有多少个
    -- 先计算总消费金额在500以上的用户都有谁
    select
        u_id,
        sum(o_amount) as amt
    from tb_order
    group by u_id
    having amt > 500;
    
    -- 再统计个数
    select count(t.u_id) as cnt
    from (select
                u_id,
                sum(o_amount) as amt
            from tb_order
            group by u_id
            having amt > 500) t;
    
    
    -- 查询每个用户的总消费金额，结果显示用户id、用户名称、总消费金额
    -- 用户表：用户id、用户名字
    -- 结果集：用户id、总消费金额
    select
        u_id,
        sum(o_amount) as amt
    from tb_order
    group by u_id;
    
    select u.u_id, u.u_name, t.amt
    -- 每个用户的id 和金额
    from (select
            u_id,
            sum(o_amount) as amt
        from tb_order
        group by u_id) t
    -- 关联用户表获取用户的名称
    join tb_user u on t.u_id = u.u_id;
    ```

  - **==注意：数据源子查询一定要给子查询取个别名==**

  - **思考**：能不能不用子查询，直接使用join实现？

    ```mysql
    -- 查询每个用户的总消费金额，结果显示用户id、用户名称、总消费金额
    select
        b.u_id,
        b.u_name,
        sum(a.o_amount) as amt
    from tb_order a join tb_user b on a.u_id  = b.u_id
    group by b.u_id, b.u_name;
    ```

- **小结**：掌握数据源子查询



## 知识点06：【理解】字段子查询

- **目标**：**理解字段子查询**

- **实施**

  - **问题**：什么是字段子查询？

  - **功能**：用于select通过子查询生成一列的数据

  - **场景**：一般用在select后面，**不常用**

  - **语法**

    ```mysql
    select ……, (select …… ) as col from ……
    ```

  - **示例**

    ```mysql
    -- 查询 所有商品的单价 以及 商品单价与平均单价的差值
    
    select
        p_id,
        p_name,
        p_price
    from tb_product;
    
    select avg(p_price) as avg_price from tb_product;
    
    
    select
        p_id,
        p_name,
        p_price,
        (select avg(p_price)  from tb_product) as avg_price,
        p_price - (select avg(p_price)  from tb_product) as price_diff
    from tb_product;
    ```

- **小结**：理解字段子查询



## 知识点07：【掌握】子查询的CTE表达式

- **目标**：**掌握子查询的CTE表达式**

- **实施**

  - **问题**：一旦子查询嵌套的结构多了，整体代码开发的逻辑容易混乱，代码可读性不强，怎么解决？

  - **解决**：CTE【Common Table Expresssion】表达式，通用/公共表表达式

    - 普通子查询

      ```mysql
      -- 统计 总消费金额在500以上 的用户有多少个
      SELECT
          count(t.u_id) as cnt
      FROM (
              SELECT 
                     u_id, sum(o_amount) as total_amt 
              FROM db_multi_tb.tb_order 
              GROUP BY u_id 
              HAVING total_amt > 500
          ) t
      ;
      ```

    - CTE表达式

      ```mysql
      -- 统计 总消费金额在500以上 的用户有多少个
      WITH t as (
          SELECT
                 u_id, sum(o_amount) as total_amt
          FROM db_multi_tb.tb_order
          GROUP BY u_id
          HAVING total_amt > 500
      )
      SELECT count(t.u_id) as cnt FROM t
      ;
      ```

  - **功能**：可以将每一步SQL的结果临时构建一个表名，再继续下一步对上一步的表名进行处理

  - **场景**：**==一般用于数据源子查询中==**

  - **语法**

    ```mysql
    -- 单层
    WITH tmp_tb_name AS (
    	SELECT ……
    )
    SELECT …… FROM tmp_tb_name
    
    -- 多层
    WITH tmp_tb_name1 AS (
    	SELECT ……
        
    ), tmp_tb_name2 AS (
    	SELECT …… FROM tmp_tb_name1
        
    ), tmp_tb_name3 AS (
    	SELECT …… FROM tmp_tb_name2
        
    )
    SELECT …… FROM tmp_tb_name3
    ```

  - **示例**

    ```mysql
    -- 需求：查询每个用户的消费总金额，结果显示用户id、用户名称、总金额
    -- 原来的写法
    SELECT
        b.u_id, b.u_name,
        a.total_amt
    FROM (
            SELECT u_id, sum(o_amount) as total_amt FROM db_multi_tb.tb_order GROUP BY u_id
         ) a
    JOIN tb_user b ON a.u_id = b.u_id
    ;
    
    -- CTE的写法
    with a as (
        SELECT u_id, sum(o_amount) as total_amt FROM db_multi_tb.tb_order GROUP BY u_id
    )
    select
        b.u_id, b.u_name,
        a.total_amt
    from a join tb_user b on a.u_id = b.u_id;
    
    
    with a as (
        SELECT u_id, sum(o_amount) as total_amt FROM db_multi_tb.tb_order GROUP BY u_id
    ), b as (
        select u_id, u_name from tb_user
    )
    select
        a.*,b.*
    from a join b on a.u_id = b.u_id;
    ```

- **小结**：掌握子查询的CTE表达式



# ==【模块二：常用函数：字符串、数值】==

## 知识点08：【理解】函数的定义与分类

- **目标**：**理解函数的定义与分类**

- **实施**

  - **问题**：什么是函数，为什么需要函数？

    <img src="Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230406191543260.png" alt="image-20230406191543260" style="zoom: 67%;" />

  - **定义**：用于对用户给定的输入数据进行处理，实现指定的功能，并输出对应结果的代码叫做函数

  - **功能**：实现对数据进行特定功能的加工处理转换

  - **场景**：数据清洗、数据分析

  - **示例**

    - 统计每种性别的平均年龄并保留两位小数

      ```mysql
      SELECT
          gender,
          round(avg(age), 2) as avg_age
      FROM db_test_bigdata01.tb_topn
      GROUP BY gender
      ```

      ![image-20230406202611937](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230406202611937.png)

    - 计算用户的停留时间

      ```mysql
      -- 平均访问时长 = 每一次访问的时间 / 访问的次数
      -- 2023-01-01 12:31:51 进入， 2023-01-01 12:47:25 离开，用户访问了多长时间
      select unix_timestamp('2023-01-01 12:47:25') - unix_timestamp('2023-01-01 12:31:51');
      select unix_timestamp('2023-01-01 12:47:25');
      select unix_timestamp('2023-01-01 12:31:51');
      ```

      ![image-20230406203505540](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230406203505540.png)

  - **分类**

    - 按照输入输出划分
      - 一对一 : 输入一行，输出一行
      - 多对一 : 输入多行，输出一行，聚合函数
      - 一对多 : 输入一个，输出多个
    - 按照功能划分
      - 字符串函数：专门用于实现对字符串数据的处理，裁剪、拼接、分割、替换、去空格
      - 数值函数：专门用于实现对数值的处理，取整、随机、四舍五入、次方、取余
      - 日期函数：专门用于实现对时间的处理，转换、求值、取值、求差、加减日期
      - 特殊函数：专门用于实现一些复杂数据处理的函数，分析函数、位置偏移函数、窗口聚合函数

- **小结**：理解函数的定义与分类



## 知识点09：【掌握】常用字符串函数

- **目标**：**掌握常用的字符串函数**

- **实施**

  - **问题**：常用的字符串函数有哪些？

  - **length**：长度

    - 功能：用于计算字符串的**字节**个数

    - 语法：length(字符串)

    - 示例

      ```mysql
      -- 字节，一个中文用3个字节存储， 所有数字、汉字、英文都可以共用字符表示，统一单位
      select '123456' as str, length('123456'); -- 数值或者字母都是一个字符用一个字节存储
      select '我爱中国' as str, length('我爱中国');-- 汉字是一个字符用三个字节存储
      select name, length(name) from db_test_bigdata01.tb_agg_func;
      ```

      ![image-20230410114114386](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230410114114386.png)

- **char_length**：字符长度

  - 功能：用于计算字符串的字符个数

  - 语法：char_length(字符串)

  - 示例

    ```mysql
      select length('我爱你中国'), char_length('我爱你中国');
      select
      	name,
      	char_length(name) as len_name,
          gender,
          char_length(gender) as len_gender
      from db_test_bigdata01.tb_agg_func;
    ```

      ![image-20230410114255674](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230410114255674.png)

- **lower**：小写

  - 功能：用于将大写字母转换成小写字母

  - 语法：lower(字符串)

  - 示例

    ```mysql
      select
          name,
          lower(name) as low_name
      from db_test_bigdata01.tb_agg_func;
    ```

  

- **upper**：大写

  - 功能：用于将小写字母转换成大写字母

  - 语法：upper(字符串)

  - 示例

    ```mysql
      select
          name,
          lower(name) as low_name,
          upper(name) as up_name
      from db_test_bigdata01.tb_agg_func;
    ```

      ![image-20230410114439743](Day05：MySQL中的DQL：多表查询子查询与基础函数.assets/image-20230410114439743.png)

      

- ==**concat**==：连接

  - 功能：用于实现字符串的拼接

  - 语法：concat（字符串1，字符串2，……，字符串N）

  - 注意：如果拼接中有任何一个元素为null，整个结果就为null

  - 示例

    ```mysql
      -- 建测试数据表
      create table if not exists db_test_bigdata01.tb_fun_concat
          as
      select '2020' as year, '08' as month, '01' as day
      union all
      select '2020' as year, '08' as month, '02' as day;
      
      -- 查询数据
      select * from db_test_bigdata01.tb_fun_concat;
      
      -- 合并成一列
      select
             concat(year,'-', month,'-', day) as daystr
      from db_test_bigdata01.tb_fun_concat;
      
      -- 如果有 null
      select
             concat(year,'-', month,'-', day, null) as daystr
      from db_test_bigdata01.tb_fun_concat;
    ```

  

- ==**concat_ws**==

  - 功能：用于实现字符串的拼接，可以指定字符串之间的分隔符

  - 语法：concat_ws（分隔符，字符串1，字符串2，……，字符串N）

  - 注意：只要有一个不为null，结果就不为null

  - 示例

    ```mysql
      select
             concat_ws('-', year, month, day) as daystr
      from db_test_bigdata01.tb_fun_concat;
    ```

  

- ==**substr**==

  - 功能：用于实现字符串的裁剪

  - 语法：substr(字符串， 开始位置， 截取长度)

  - 示例

    ```mysql
      -- 不指定长度
      select
          stu_birth,
          substr(stu_birth, 6) as day
      from tb_student09;
      
      -- 指定长度
      select
          stu_birth,
          substr(stu_birth, 1, 4) as year,
          substring(stu_birth, 6, 2) as month
      from tb_student09;
    ```

  

- ==**replace**==

  - 功能：用于实现字符串的替换

  - 语法：replace(字符串，替换谁，替换成什么)

  - 示例

    ```mysql
      -- 将yyyy-MM-dd 转换成 yyyy.MM.dd
      select
          stu_birth,
          replace(stu_birth, '-', '.') as new_birth
      from tb_student09;
    ```

  

- **reverse**

  - 功能：实现字符串的反转

  - 语法：reverse(字符串)

  - 示例

    ```mysql
      select 'abcdefg', reverse('abcdefg');
    ```

  

- **locate**：定位

  - 功能：查找子串的位置或者是否包含子串

  - 语法：locate(子串，字符串) ，不存在就返回0，存在就返回子串的开始位置

  - 示例

    ```mysql
      -- 查询所有名字中包含 ri 的
      select
          *,
          locate('ri', name)
      from tb_agg_func
      where locate('ri', name) > 0;
    ```

  

- **trim**

  - 功能：用于实现对字符串去首尾空格

  - 语法：trim(字符串)

  - 示例

    ```mysql
      select ' 我两边各有一个空格 ', trim(' 我两边各有一个空格 ');
    ```

  

- **strcmp**：string compare：字符串比较

  - 功能：用于比较两个字符串的大小

  - 语法：strcmp(str1, str2)，0表示相等，1表示str1大于str2，-1表示str1小于str2

  - 示例

    ```mysql
      select strcmp('abc', 'abc');
      select strcmp('abcd', 'abc');
      select strcmp('abc', 'bbc');
      select strcmp('abc', 'b');
    ```

- **小结**：常用的字符串函数有哪些？

  - 长度：length、char_length
  - 大小写：upper、lower
  - ==裁剪：substr==
  - ==替换：replace==
  - 定位：locate
  - ==拼接：concat、concat_ws==
  - 反转：reverse
  - 比较：strcmp



## 知识点10：【掌握】常用数值函数

- **目标**：**掌握常用的数值函数**

- **实施**

  - **abs**

    - 功能：用于返回给定数值的绝对值

    - 语法：abs(数值)

    - 示例

      ```mysql
      select abs(-1), abs(1), abs(-15.99), abs(0);
      ```

      

  - ==**ceil**==

    - 功能：用于实现对数值进行**向上**取整

    - 语法：ceil(数值)

    - 示例

      ```
      select ceil(9.3), ceil(9.9), ceil(10), ceil(10.1);
      ```

      

  - ==**floor**==

    - 功能：用于实现对数值进行**向下**取整

    - 语法：floor(数值)

    - 示例

      ```
      select floor(9.3), floor(9.9), floor(10), floor(10.1);
      ```

      

  - **mod**

    - 功能：用于实现两个数值 A除以B运算  的**余数**

    - 语法：mod(A, B)

    - 示例

      ```
      select mod(1, 3), mod(4, 5), mod(5, 3), mod(9, 3);
      ```

      

  - ==**rand**:  random:随机==

    - 功能：用于随机生成一个0 - 1 之间的小数

    - 语法：rand()  、rand(N)，如果给定了N，相当于随机数只生成一次，以后每次结果都相同

    - 示例

      ```
      select rand(), rand(100);
      ```

      

  - ==**round**==

    - 功能：用于实现**四舍五入**，指定小数点后保留几位

    - 语法：round(数值，小数点后位数)，**不给定位数则取整**

    - 示例

      ```
      select round(19.12345), round(19.56789), round(19.12345, 2), round(19.56789, 3);
      ```

      

  - ==**truncate**==

    - 功能：用于直接截取小数点后的位数，指定小数点后保留几位，**不四舍五入**

    - 语法：truncate(数值，小数点后位数)

    - 示例

      ```
      select truncate(19.12345, 2), truncate(19.56789, 3);
      ```

      

  - **pi**

    - 功能：用于生成圆周率

    - 语法：pi()

    - 示例

      ```
      select pi();
      ```

      

  - **power**

    - 功能：用于计算数值指定的次方

    - 语法：power(数值，次方)

    - 示例

      ```
      select power(2, 2), power(2, 3), power(2, 10), power(2, 20), power(2,100);
      ```

      

  - **sqrt**

    - 功能：用于返回指定数值的平方根

    - 语法：sqrt(数值)

    - 示例

      ```
      select sqrt(4), sqrt(9), sqrt(8), sqrt(10);
      ```

      

  - **log**

    - 功能：返回指定以M为底的N的对数值

    - 语法：log(底数，数值)

    - 示例

      ```
      select log(2, 16), log(3, 1), log(4, 4);
      ```

      

  - **数值运算符**

    - 功能：用于实现数值的运算

    - 语法：加+、减-、乘*、除/ 、取余%

    - 示例

      ```sql
      select age,
             age + 1,
             age + age,
             age - 1,
             age * 2,
             age / 2,
             age % 2
      from db_school.tb_stu;
      ```

      

- **小结**：常用的数值函数有哪些？

  - 绝对值：abs
  - 取整：ceil、floor
  - 保留小数位：round[四舍五入]、truncate【直接截取】
  - 随机数：rand
  - 取余：mod
  - 次方：power
  - π：pi
  - 平方根：sqrt
  - 运算符：+ - * / %
