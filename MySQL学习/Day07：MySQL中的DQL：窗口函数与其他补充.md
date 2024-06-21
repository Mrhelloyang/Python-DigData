# MySQL中的DQL：窗口函数与其他补充

## 知识点01：课程回顾

![image-20240405092942069](Day07：MySQL中的DQL：窗口函数与其他补充.assets/image-20240405092942069.png)



## 知识点02：课程目标

1. 窗口函数：分析函数、偏移函数
   - 目标：==**掌握分析函数和偏移函数的使用**==
   - 问题1：分析函数有哪些，应用场景是什么？
     - 场景：解决分区排名问题
     - 函数：row_number、rank、dense_rank
   - 问题2：三者之间彼此有什么区别？
     - row_number：基于每个分区内部生成编号，不考虑重复值问题，值相同，排名不同
     - rank：基于每个分区内部生成编号，考虑重复值问题，值相同，排名相同，会留下空位
     - dense_rank：基于每个分区内部生成编号，考虑重复值问题，值相同，排名相同，不留空位
   -  问题3：偏移函数有哪些，各自的功能是什么，应用场景是什么？
     - 场景：行之间比较问题，同比以及环比问题
     - first_value：按照分区，取每个分区内部窗口的第一条数据的某一列的值
     - last_value：按照分区，取每个分区颞部窗口的最后一条数据的某一列值【留意窗口大小】
     - lead：按照分区排序规则，向后偏移N个单位取某一列的值
     - lag：按照分区排序规则，向前偏移N个单位取某一列的值
   - 问题4：怎么解决连续登陆问题？
     - 方案一：自连接：不建议使用，性能太差
     - 方案二：下一次登陆时间与登陆第二天时间相等
2. 补充：视图、索引、事务
   - 目标：理解视图view、索引index、事务transaction基本概念和使用
   - 问题1：什么是视图，视图里存储的是什么？
     - 本质：视图就是一种只读的表
     - 存储：select语句
     - 语法：create or replace 视图名称  as  select ……
   - 问题2：什么是索引，索引的功能和语法是什么？
     - 目的：为了加快查询效率
     - 功能：基于数据表中的列构建索引信息，在基于列做查询时，提供索引查询
     - 语法：create index 索引名称  on  表名（列名）;
     - 场景：大数据场景



# ==【模块一：窗口函数：分析函数】==

## 知识点03：【掌握】窗口分析函数：row_number

- **目标**：**掌握窗口分析函数row_number**

- **实施**

  - **功能**：用于对每个分区内部进行**==编号==**，编号从1开始，**==不考虑重复值问题，如果值相同，编号不相同==**

  - **场景**：取每个分区内部的TopN

    - 订单表【订单id、订单金额、商品id】 + 商品表【商品id、类别id、店铺id】 + 商品分类表【类别id、类别名称】
    - 需求：查询每个类别销售额最高Top10店铺

  - **语法**

    ```
    row_number() over (partition by col order by col)
    ```

  - **示例**

    ```sql
    -- 查询每个部门薪资最高的前2个员工的信息
    with tmp as (
        select
            *,
            row_number() over (partition by deptno order by sal desc) as rn
        from tb_emp
    )
    select * from tmp where rn < 3;
    ```

  - **注意：窗口函数执行的顺序在group by之后，如果要对窗口函数的结果进行过滤，一般需要构建子查询**

- **小结**：row_number的功能和语法是？

  - 功能：对每个分区内部的每条数据进行编号，从1开始，不考虑重复值问题，如果值相同，编号不相同
  - 语法：row_number() over (partition by col order by col)



## 知识点04：【掌握】窗口分析函数：rank、dense_rank

- **目标**：**掌握窗口分析函数rank及dense_rank**

- **实施**

  - **问题1：如果我希望薪资相同，排名也相同怎么实现？**

    - 函数：rank

    - 功能：用于对每个分区内部进行**编号**，编号从1开始，==考虑重复值问题，如果值相同，编号相同，留下空位==

    - 场景：取每个分区内部的TopN，允许并列排名，会留下空位

    - 语法

      ```
      rank() over (partition by col order by col)
      ```

    - 示例

      ```mysql
      with tmp as (
          select
              *,
              rank() over (partition by deptno order by sal desc) as rn
          from tb_emp
      )
      select * from tmp where rn < 3;
      ```

  - **问题2：如果我希望薪资相同，排名相同并且不留空位，怎么实现？**

    - 函数：dense_rank

    - 功能：用于对每个分区内部进行**编号**，编号从1开始，考虑重复值问题，如果值相同，编号相同，==**不留空位**==

    - 场景：取每个分区内部的TopN，允许并列排名并且不留空位

    - 语法

      ```
      dense_rank() over (partition by col order by col)
      ```

    - 示例

      ```mysql
      with tmp as (
          select
              *,
              dense_rank() over (partition by deptno order by sal desc) as rn
          from tb_emp
      )
      select * from tmp where rn < 3;
      ```

- **小结**：row_number、rank、dense_rank三者的场景、功能、区别？

  - 功能：都是基于每个分区内部给每条数据进行**编号**
  - 场景：实现统计每个分区内部的TopN
  - 区别：
    - row_number：不考虑重复值问题，如果值相同，排名不相同
    - rank：考虑重复值问题，如果值相同，排名相同，但是会留空位
    - dense_rank：考虑重复值问题，如果值相同，排名相同，不会留下空位
  - 思考：Ntile
    - 查询每个部门薪资最高的前1/3的员工的信息：每个部门的人数不一样



# ==【模块二：窗口函数：偏移函数】==

## 知识点05：【掌握】窗口偏移函数：first_value、last_value

- **目标**：**掌握窗口偏移函数first_value及last_value的使用**

- **实施**

  - **场景**：主要用于计算一些转换率问题

  - **first_value**

    - 功能：用于取分区窗口内某一列的第一个值

    - 语法

      ```
      first_value(col) over (partition by col order by col)
      ```

    - 示例

      ```mysql
      -- 每个部门按照薪水降序排序，并计算每个部门员工的薪水与该部门最高薪资之前的差值
      select
          *,
          sal - first_value(sal) over (partition by deptno order by sal desc) as diff_sal
      from tb_emp;
      ```

  - **last_value**

    - 功能：用于取分区窗口内某一列的最后一个值

    - 注意：窗口范围的问题

    - 语法

      ```
      last_value(col) over (partition by col order by col)
      ```

    - 示例

      ```mysql
      -- 计算每个部门员工的薪水与该部门最低薪资之前的差值
      select
          *,
          sal - last_value(sal) over (partition by deptno order by sal desc) as diff_sal
      from tb_emp;
      
      -- 默认窗口会导致结果错误，需要指定窗口或者更换排序规则
      select
          *,
          sal - last_value(sal) over (partition by deptno order by sal desc rows between unbounded preceding and unbounded following) as diff_sal
      from tb_emp;
      ```

  - **实际场景**

    - 数据

      ```mysql
      -- 建表
      create table if not exists tb_window
      as
      select '浏览' as event, 1000 as user_cnt
      union all
      select '加购' as event, 400 as user_cnt
      union all
      select '下单' as event, 100 as user_cnt
      union all
      select '支付' as event, 99 as user_cnt
      ;
      
      -- 查询
      select * from tb_window;
      ```

    - 需求：计算每一步的相对第一步的留存率

      ![image-20230411091327505](Day07：MySQL中的DQL：窗口函数与其他补充.assets/image-20230411091327505.png)

    - 代码

      ```mysql
      select
          *,
          user_cnt / first_value(user_cnt) over (order by user_cnt desc) as retention
      from tb_window;
      ```

- **小结**：first_value和last_value的功能是什么？

  - first_value：取每个分区内部某一列的第一个值
  - last_value：取每个分区内部某一列的最后一个值，一定要注意窗口范围



## 知识点06：【掌握】窗口偏移函数：lead、lag

- **目标**：**掌握窗口偏移函数lead和lag**

- **实施**

  - **lead**

    - 功能：用于获取分区内某一列**向后**偏

    - 移N个单位的值

    - 语法

      ```
      lead(某一列，N个单位，取不到的默认值) over (partition by col order by col)
      ```

    - 示例

      ```mysql
      -- 获取每个用户下一次的订单时间，计算每次订单的下单周期，最终计算平均订单周期
      select
          o_id, u_id, o_amount, o_time,
          lead(o_time, 1, o_time) over (partition by u_id order by o_time) as next_time
      from db_multi_tb.tb_order;
      ```

  - **lag**

    - 功能：用于获取分区内某一列**向前**偏移N个单位的值

    - 语法

      ```
      lead(某一列，N个单位，取不到的默认值) over (partition by col order by col)
      ```

    - 示例

      ```mysql
      -- 获取每个月上一个月的销售额，计算销售额增长金额
      select
             * ,
             lag(sold_amt, 1 , 0) over (order by month) as last_sold,
             sold_amt - lag(sold_amt, 1 , 0) over (order by month) as incr
      from db_multi_tb.tb_sales;
      ```

  - **实际场景**

    - 数据

      ```mysql
      -- 建表
      create table if not exists tb_window
      as
      select '浏览' as event, 1000 as user_cnt
      union all
      select '加购' as event, 400 as user_cnt
      union all
      select '下单' as event, 100 as user_cnt
      union all
      select '支付' as event, 99 as user_cnt
      ;
      
      -- 查询
      select * from tb_window;
      ```

    - 需求：计算每一步的相对上一步的留存率

      ![image-20230411091337966](Day07：MySQL中的DQL：窗口函数与其他补充.assets/image-20230411091337966.png)

    - 代码

      ```mysql
      select
          *,
          lag(user_cnt, 1, user_cnt) over (order by user_cnt desc) as last_step,
          user_cnt / lag(user_cnt, 1, user_cnt) over (order by user_cnt desc)  as retention
      from tb_window;
      ```

- **小结**：lead和lag的功能和语法是什么？

  - lead：基于每个分区内部取某一列指定向后偏移的值，lead(列名， N， 默认值)

  - lag：基于每个分区内部取某一列指定向前偏移的值，lag(列名，N，默认值)

  - 连续登陆问题

    - 数据：每一个用户在每一条只保留一条登陆信息

      ```
      userId		logindate
      A			2023-01-02
      B			2023-01-02
      C			2023-01-02
      A			2023-01-03
      C			2023-01-03
      A			2023-01-04
      ```

    - 连续N天登陆的用户有哪些？N >= 2

    - 连续2天登陆？

      ```sql
      userId		logindate
      A			2023-01-02
      B			2023-01-02
      C			2023-01-02
      A			2023-01-03
      C			2023-01-03
      A			2023-01-04
      B			2023-01-04
      
      -- 数据逻辑，找数据规律
      /*
      	连续登陆规律
      	下一次的登录时间 = 当前登陆时间第二天
      	下下一次的登录时间 = 当前登陆时间第三天
      	下下下一次的登录时间 = 当前登陆时间的第四天
      */
      
      -- 连续两天
      select
      	*,
      	-- 取当前登陆第二天
      	date_add(logindate, interval 1 day) as next_day,
      	-- 取下一次的登录时间
      	lead(logindate, 1, null) over (partition by userid order by logindate) as next_login_date
      from table
      
      userId		logindate			next_day	=	next_login_date
      A			2023-01-02			2023-01-03		2023-01-03
      A			2023-01-03			2023-01-04		2023-01-04
      A			2023-01-04			2023-01-05		null
      
      B			2023-01-02			2023-01-03		2023-01-04
      B			2023-01-04			2023-01-05		null
      
      C			2023-01-02			2023-01-03		2023-01-03
      C			2023-01-03			2023-01-04		null
      
      
      -- 连续三天
      select
      	*,
      	-- 取当前登陆第三天
      	date_add(logindate, interval 2 day) as next_day,
      	-- 取下下一次的登录时间
      	lead(logindate, 2, null) over (partition by userid order by logindate) as next_login_date
      from table
      
      userId		logindate			next_day	=	next_login_date
      A			2023-01-02			2023-01-04		2023-01-04
      A			2023-01-03			2023-01-05		null
      A			2023-01-04			2023-01-06		null
      
      B			2023-01-02			2023-01-04		null
      B			2023-01-04			2023-01-06		null
      
      C			2023-01-02			2023-01-04		null
      C			2023-01-03			2023-01-05		null
      ```

      



# ==【模块三：视图、索引、事务】==

## 知识点07：【理解】视图view

- **目标**：**理解视图view**

- **实施**

  - **问题1：什么是视图？**

    ![image-20230411100041316](Day07：MySQL中的DQL：窗口函数与其他补充.assets/image-20230411100041316.png)

    - MySQL中的视图是一种**虚拟表**，其内容可能是从一个或多个现有表中选择、过滤、聚合等操作所得到的**结果集**
    - 用户可以把视图当做表一样进行查询，但是视图与表不同，**视图本身不存储任何的数据内容**，==视图只存储了SQL语句==
    - 可以理解为视图只是一个SQL语句，每次对视图操作时，是先通过SQL语句生成了临时表，然后再对临时表操作

    

  - **问题2：为什么需要视图？**

    - 简化查询：视图可以将多个表的数据组合成一个虚拟的表，用户可以通过单独的 SQL 语句来查询虚拟表，从而简化查询操作
    - 提高安全：通过使用视图，可以授予用户对特定列或行的访问权限，同时保护敏感数据免遭未经授权的访问
    - 数据独立：当需要修改底层表的结构时，使用视图可以隐藏这些变化，使得上层应用程序不需要做出相应的调整
    - 逻辑分离：视图允许开发者将复杂的查询逻辑分离出来，使得应用程序代码更加简洁易懂

    

  - **问题3：视图怎么使用？**

    - 创建视图

      - 语法

        ```sql
        create [ or replace ] view 视图名称
        as
        select ……
        ```

      - 示例

        ```mysql
        -- 建库
        create database if not exists db_other;
        use db_other;
        
        -- 建视图
        create view view_order_detail
        as
        select
            a.o_id, a.o_time, a.o_amount,
            b.u_id, b.u_name,
            c.p_id, c.p_name
        from db_multi_tb.tb_order a
        join db_multi_tb.tb_user b on a.u_id = b.u_id
        join db_multi_tb.tb_product c on a.p_id = c.p_id
        ;
        
        -- 如果存在就替换视图
        create or replace view view_order_detail
        as
        select
            a.o_id, a.o_time, a.o_amount,
            b.u_id, b.u_name,
            c.p_id, c.p_name, p_category
        from db_multi_tb.tb_order a
        join db_multi_tb.tb_user b on a.u_id = b.u_id
        join db_multi_tb.tb_product c on a.p_id = c.p_id
        ;
        ```

        

    - 列举视图

      ```sql
      show tables ;
      ```

      

    - 查询视图

      ```mysql
      -- 基础查询
      select * from db_other.view_order_detail;
      
      -- 分组聚合排序
      select
          u_id,
          count(distinct p_id) as p_cnt,
          count(o_id) as o_cnt
      from view_order_detail
      group by u_id
      having o_cnt > 1
      order by o_cnt desc
      limit 1;
      ```

      

    - 删除视图

      ```mysql
      drop view if exists db_other.view_order_detail;
      ```

- **小结**：理解视图view



## 知识点08：【理解】索引index

- **目标**：**理解索引index**

- **实施**

  - **问题1：什么是索引？**

    ![image-20230411103854509](Day07：MySQL中的DQL：窗口函数与其他补充.assets/image-20230411103854509.png)

    - 生活中
      - 大型商场，需要路牌索引，方便顾客快速的查询并找到自己想要去的店铺
      - 图书馆，需要图书索引，方便用户能够快速的查询并找到自己想要的书籍的位置
      - 新华字典，需要目录索引，方便用户能够快速找到自己想要的字的在哪一页
    - 数据库：select * from table where name = ‘张三’
      - MySQL中的索引是一种用于加速数据库查询操作的数据结构
      - 它可以帮助用户根据自己需求，更快地从MySQL中定位到需要查询的数据的位置
    - 理解：索引是一份数据【元数据：用于描述数据的数据】，这份数据中记录了你想要找的东西所在的位置

    

  - **问题2：为什么需要索引？**

    - 生活中如果没有索引

      - 我们在商场要想找到某个店铺，只能一层一层找
      - 我们在图书馆想找某一本书籍，只能一本一本查
      - 我们在新华字典中想找某个字，只能一页一页翻

    - 数据库如果没有索引：select * from table where name = ‘张三’

      - 我们要找我们需要的数据，只能一行一行的对比

        

  - **问题3：怎么使用索引？**

    - 索引分类：主键索引、外键索引、唯一索引、联合索引等

      - primary key：主键列的查询是基于索引的查询
      - primary key（id, name）：一张表主键只有1个，但是主键可以由多列构成

    - 创建索引

      - 语法

        ```mysql
        CREATE INDEX index_name ON table_name (column1, column2, ...);
        ```

      - 示例

        ```mysql
        -- 查询订单表的信息
        desc db_multi_tb.tb_order;
        
        -- 开启查看任务监控
        show variables like '%profiling%'; -- 查看是否开启监控 profiling 为 on 就是已经开启了
        set profiling = 1; -- 如果上一步的结果profiling为off, 需要执行这一步手动开启
        show profiles ; -- 查看近15条任务的监控
        
        -- 基于 主键索引 的过滤查询
        select * from db_multi_tb.tb_order where o_id = 'o005';
        
        -- 基于 非索引字段 的过滤查询
        select * from db_multi_tb.tb_order where u_id = 'u001';
        
        -- 基于 非索引字段 创建索引 变成索引字段
        create index test_index01 on db_multi_tb.tb_order(u_id);
        
        -- 测试搜狗数据：不用自己做
        -- 统计行数
        select count(1) as cnt from db_test_bigdata01.tb_sogou;
        
        -- 查看表结构
        desc db_test_bigdata01.tb_sogou;
        
        -- 查询 11579135515147154 这个用户的浏览记录
        select * from db_test_bigdata01.tb_sogou where uuid = '11579135515147154';
        
        -- 创建索引
        create index test_index02 on db_test_bigdata01.tb_sogou(uuid);
        
        -- 查询 2982199073774412 这个用户的浏览记录
        select * from db_test_bigdata01.tb_sogou where uuid = '2982199073774412';
        ```

    - 删除索引

      - 语法

        ```mysql
        DROP INDEX index_name ON table_name;
        ```

      - 示例

        ```mysql
        drop index test_index02 on db_test_bigdata01.tb_sogou;
        ```

  - **问题4：什么场景下使用索引？**

    - 优点
      - 提高查询性能：索引可以让数据库快速定位到包含所需数据的页，并且避免扫描整个表，从而提高查询速度。
      - 优化排序分组：在ORDER BY或GROUP BY语句，索引可以避免进行全表扫描和排序，降低查询的时间复杂度。
      - 加速表连接：如果在JOIN操作中使用了索引，可以大大加速查询速度
    - 缺点
      - 索引需要占用额外的存储空间，因此会增加数据表的存储成本。
      - 写入操作变慢：每次更新表中的数据时，都需要同时更新索引，这会导致写入操作变慢。
    - 适合：大数据量的固定条件的查询，加快查询速度
    - 不适合：小数据量的数据查询或者多条件模糊查询
    - 原则
      - 不要滥用索引，只针对经常查询的字段建立索引
      - 数据量小的表最好不要使用索引
      - 在一个字段上相同值比较多不要建立索引，比如性别

- **小结**：理解索引index



## 知识点09：【了解】事务transaction

- **目标**：**了解事务transaction**
- **实施**
  - **问题1：什么是事务？**
  
    - 事务是数据库操作的最小工作单元，一个事务代表一次对数据库的操作，操作可以是单个或者多个
  
    - 举例：现有一张银行账户信息表，id代表用户id，balance代表用户的余额
  
      ```mysql
      -- 建表
      drop table if exists tb_bank;
      create table if not exists tb_bank(
      	user_id varchar(20) primary key,
      	balance decimal(20, 2) default 0 not null
      );
      
      -- zhangsan开户了
      insert into tb_bank values ('zhangsan', 0);
      
      -- lisi开户了
      insert into tb_bank values ('lisi', 0);
      
      -- zhangsan存了770块
      update tb_bank set balance = 770 where user_id = 'zhangsan';
      
      -- lisi存了146块
      update tb_bank set balance = 146 where user_id = 'lisi';
      ```
  
    - 默认情况下，我们每做一个操作，每个操作内包含一条SQL语句提交给MySQL执行，就代表一个事务操作，要么成功，要么失败
  
    - 问题：如果我要在一个事务操作内，实现多个SQL语句的运行，怎么保证要么结果都成功，要么结果都失败呢？
  
    - 例如：清明节这天，zhangsan给lisi转了520块？
  
    - 需求：必须保证zhangsan的账户少了520，lisi的账户多了520，两个操作必须是一致的
  
  - **问题2：为什么需要事务？**
  
    - 事务保证了在一次操作中多个**==写操作==**事情的结果一致性，避免了数据操作的异常影响业务
  
    - 示例
  
      ```mysql
      /*
         未开启事务操作
      */
      -- zhangsan 转账给 lisi 520
      update tb_bank set balance = balance + 520 where user_id = 'lisi'; -- 运行成功
      update tb_bank set balance = balance - 520 where user_id = 'zhangsan'; -- 该操作无法执行
      ```
  
    - 如果没有事务，不能保证这个过程的结果的准确性
  
  - **问题3：事务的四大特性是什么？**
  
    - **==简称：ACID==**
    - 原子性（Atomicity）：此属性确保事务中的所有操作要么全部完成，要么全部回滚到它们开始之前的状态。如果事务中的任何部分失败，则整个事务将被回滚。【要么都成功，要么都失败】
    - 一致性（Consistency）：此属性确保在事务开始和结束时，数据库的状态始终是一致的。如果事务违反了约束或触发器，则事务将被回滚并返回到先前的状态。【不影响数据库的准确性，允许恢复到原来的状态】
    - 隔离性（Isolation）：此属性确保在同时运行的多个事务之间的操作相互独立。每个事务都必须独立于其他事务，并且不能干扰其他事务的操作。【每个事务彼此独立，互不影响】
    - 持久性（Durability）：此属性确保一旦事务提交，对数据库进行的更改将永久保存，即使系统崩溃或重新启动也不会影响其永久性。【事务会被存储，及时重启也不影响】
  
  - **问题4：怎么使用事务？**
  
    - 场景：DML操作
  
    - 语法
  
      - BEGIN / START TRANSACTION：开始一个新的事务操作
      - SQL：执行SQL操作：在事务中执行需要保持原子性的SQL操作。
      - COMMIT：提交这次事务中的所有SQL操作
      - ROLLBACK：取消这次事务操作，回滚到之前的状态
  
    - **==示例【可以不运行】==**
  
      ```mysql
      /*
         开启事务操作
       */
      -- 关闭自动提交事务
      show variables like '%autocommit%';
      set autocommit=0;
      
      -- 开始一个新的事务
      begin ;
      
      -- 如果都是正确操作
      update tb_bank set balance = balance + 520 where user_id = 'lisi';
      update tb_bank set balance = balance - 520 where user_id = 'zhangsan';
      
      -- 提交事务
      commit ;
      
      
      -- 开始一个新的事务
      begin ;
      
      -- 如果有逻辑问题
      update tb_bank set balance = balance + 520 where user_id = 'lisi';
      update tb_bank set balance = balance - 220 where user_id = 'zhangsan'; -- 逻辑问题
      
      -- 回滚
      rollback ;
      
      -- 测试完成记得一定要重新开启事务的自动提交
      show variables like '%autocommit%';
      set autocommit=1;
      ```
- **小结**：了解事务transaction
