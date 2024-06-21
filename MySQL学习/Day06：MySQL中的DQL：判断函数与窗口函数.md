# MySQL中的DQL：判断函数与窗口函数

## 知识点01：课程回顾

![image-20240403093007699](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20240403093007699.png)



## 知识点02：课程目标

1. 其他函数

   - 目标：理解常用时间函数以及**掌握逻辑判断函数**
   - 问题1：常用的时间函数有哪些？
     - 时间取值：now、curdate、curtime、year/quater/month/day/hour/minute/second、day_of_year、weekofyear
     - 时间转换：unix_timestamp、from_unixtime、date_format
     - 时间计算：date_add/date_sub、date_diff、time_diff
   - 问题2：group_concat函数的功能和语法是什么？
     - 功能：在分组时，将每组的数据按照指定的列进行concat拼接
     - 分类：聚合函数，将一组某一列多行值合并为一行值
     - 语法：group_concat(distinct  col  order by col  seperator ‘分隔符’)
   - 问题3：常用的判断函数有哪些？
     - case when：用于实现条件判断，一般用于多条件判断场景
     - if：用于实现条件判断，一般用于单条件判断场景
     - ifnull：用于实现空值判断，返回参数列表中第一个非空值，只能接受2个参数
     - coalesce：用于实现空值判断，返回参数列表中第一个非空值，可以接受任意多个参数

2. 窗口函数

   - **==目标：掌握窗口函数的功能、语法、分类==**

   - 问题1：窗口函数的功能是什么？

     - 问题：需要实现对数据进行分组，但是不希望最后每组只得到一条结果，希望能够保留原始每一条数据
     - 需求：需要一个函数能够实现类似于分组的功能，但是会保留每一条数据
     - 功能：按照指定的列进行分区，并对每个分区内部实现排序、聚合等操作

   - 问题2：窗口函数的语法是什么？

     ```
     函数名(参数) over (partition by 分区字段 order by 排序字段  rows between …… and ……)
     ```

   - 问题3：窗口函数分为几类？

     - 聚合窗口：sum、count、max、min、avg
     - 分析函数：row_number、rank、dense_rank、ntile
     - 偏移函数：first_value、last_value、lead、lag

   - 问题4：聚合窗口有哪些以及应用场景是什么?

     - 函数：sum、count、max、min、avg  over (partition by 分区字段 order by 排序字段  rows between …… and ……)
     - 场景：累计问题
     - 默认窗口
       - 有分区有排序：分区第一行到当前行
       - 有分区无排序：分区第一行到最后一行

 

# ==【模块一：常用函数：其他函数】==

## 知识点03：【掌握】常用时间函数

- **目标**：**掌握常用的时间函数**

- **实施**

  - ==**now**：现在==

    - 功能：获取当前的日期和时间

    - 语法：now()

    - 示例

      ```
      select now();
      ```

      

  - ==**curdate**：现在日期==

    - 功能：获取当前的日期，不包含时间

    - 语法：curdate()

    - 示例

      ```
      select curdate();
      ```

      

  - **curtime**

    - 功能：获取当前的时间，不包含日期

    - 语法：curtime

    - 示例

      ```
      select curtime();
      ```

      

  - **date**

    - 功能：从日期时间中获取日期

    - 语法：date(日期时间)

    - 示例

      ```
      select date('2023-01-01 12:30:29');
      ```

      

  - **time**

    - 功能：从日期时间中获取时间

    - 语法：time(日期时间)

    - 示例

      ```
      select time('2023-01-01 12:30:29');
      ```

      

  - ==**year/quarter/month/day/hour/minute/second**==

    - 功能：从日期时间中获取指定的元素

    - 语法：year/quarter/month/day/hour/minute/second(日期时间)

    - 示例

      ```
      select
             year('2023-04-01 12:30:29') as year,
             quarter('2023-04-01 12:30:29') as quater,
             month('2023-04-01 12:30:29') as month,
             day('2023-04-01 12:30:29') as day,
             hour('2023-04-01 12:30:29') as hour,
             minute('2023-04-01 12:30:29') as minute,
             second('2023-04-01 12:30:29') as seconds
             ;
      ```

      

  - ==**unix_timestamp**==

    - 功能：将指定日期时间转换我时间戳

    - 语法：unix_timestamp(日期时间)

    - 示例

      ```
      select unix_timestamp('2022-01-01 21:00:00');
      ```

      

  - ==**from_unixtime**==

    - 功能：将时间戳，转换成日期时间

    - 语法：from_unixtime(时间戳)

    - 示例

      ```
      select from_unixtime(1641042000), from_unixtime(1641042000, '%Y-%m-%d %H:%i:%S');
      ```

      

  - ==**date_format**==

    - 功能：用于实现两个日期格式之间的转换

    - 语法：date_format(日期时间， 目标格式)

    - 示例

      ```
      SELECT DATE_FORMAT('2022-02-01 12:30:45', '%d/%M/%Y %H:%i:%s');
      ```

      

  - ==**date_add==/date_sub**

    - 功能：用于实现日期的加减

    - 语法：date_add/date_sub(日期，天数)

    - 示例

      ```
      SELECT
             date_add('2022-02-01 12:30:00', interval 1 second ),
             date_add('2022-02-01 12:30:00', interval 1 minute ),
             date_add('2022-02-01 12:30:00', interval 1 hour ),
             date_add('2022-02-01 12:30:00', interval 1 day),
             date_add('2022-02-01 12:30:00', interval 1 week ),
             date_add('2022-02-01 12:30:00', interval 1 month ),
             date_add('2022-02-01 12:30:00', interval 1 year ),
             date_sub('2022-02-01 12:30:00', interval 1 year ),
             date_add('2022-02-01 12:30:00', interval -1 year )
             ;
      ```

      

  - ==**datediff**==

    - 功能：用于获取两个日期之间的差值

    - 语法：date_diff(日期1， 日期2)

    - 示例

      ```
      select datediff('2023-11-11', '2023-09-10');
      ```

      

  - **timediff**

    - 功能：用于获取两个时间之间的差值

    - 语法：timediff(时间1， 时间2)

    - 示例

      ```
      select timediff('12:30:45', '10:00:00');
      ```

      

  - **last_day**

    - 功能：用于获取每个月最后一天

    - 语法：last_day(日期)

    - 示例

      ```
      select last_day(curdate());
      ```

      

  - **day_of_week / day_of_month / day_of_year**

    - 功能：获取某个日期是那一周/那一个月/那一年的第几天

    - 语法：day_of_week(日期)/day_of_month(日期)/day_of_year(日期)

    - 示例

      ```
      select dayofweek(curdate()), dayofmonth(curdate()), dayofyear(curdate());
      ```

      

  - **week_of_year**

    - 功能：获取日期在今年的第几周

    - 语法：week_of_year(日期)

    - 示例

      ```
      select weekofyear(curdate());
      ```

      

- **小结**：常用的时间函数有哪些？

  - 取值函数：now、curdate、curtime、date、time、year、quater、month、day、hour、minute、second、dayofweek、dayofmonth、dayofyear、weekofyear、last_day
  - 转换函数：unix_timestamp、from_unixtime、date_format
  - 计算函数：date_add、date_sub、datediff、timediff



## 知识点04：【掌握】聚合函数group_concat

- **目标**：**掌握聚合函数group_concat的使用**

- **实施**

  - **问题**：我们之前见过的聚合函数，都是将多行聚合成一行，保留了一个聚合的结果，但是如果我想保留原来的值怎么办？

    - count、sum、max、min、avg : 这些函数都是对这一列的数据进行计算，最后得到一个结果

  - **需求**：现有一份数据，记录每个用户工作过的城市，现在要统计每个用户工作过的城市个数和城市列表，怎么实现？

    - 数据

      ```mysql
      -- 建表
      create table if not exists tb_data_func_05
      as
      select '小明' as name, '上海' as work_city
      union
      select '老王' as name, '北京' as work_city
      union
      select '小明' as name, '深圳' as work_city
      union
      select '老王' as name, '伊拉克' as work_city
      union
      select '小明' as name, '广州' as work_city
      union
      select '老王' as name, '深圳' as work_city
      union
      select '老王' as name, '斯里兰卡' as work_city
      ;
      
      -- 查询数据
      select * from tb_data_func_05;
      ```

    - 结果

      ![image-20230408145655956](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230408145655956-1710307536701.png)

      

  - **解决**：group_concat：分组拼接字符串

  - **功能**：用于在分组时，将指定字段的值进行合并拼接成一个字符串

  - **语法**

    ```mysql
    group_concat(  [distinct] col [order by col] [separator 分隔符]  )
    
    distinct：对元素的值进行去重
    order by：按照某一列的值进行排序
    separator：用于指定分隔符，不给默认为逗号作为分隔符
    ```

  - **示例**

    ```mysql
    select
        name,
        count(work_city) as cnt,
        group_concat(work_city) as work_city,
        group_concat(distinct work_city order by convert(work_city using gbk) separator ' ') as work_city_other
    from tb_data_func_05
    group by name
    ```

- **小结**：group_concat函数的功能和语法是什么？

  - 功能：在分组的时候，将某一列的值进行拼接，多行值拼接成一行，并使用分隔符隔开
  - 语法：group_concat( [distinct] col  [order by col desc]  separator ‘,’ )



## 知识点05：【掌握】逻辑判断函数case when

- **目标**：**掌握逻辑判断函数case when的使用**

- **实施**

  - **问题**：工作中经常会遇到一种情况，针对数据的不同处理的方式不同，在SQL中如何实现这种操作？

  - **需求**

    - 数据

      ```
      select * from db_multi_tb.tb_product;
      ```

    - 需求：查询所有商品的信息，并构建折扣价格，单价低于200的价格打九折，单价高于200的上涨10% ,等于200的保持不动

      ![image-20230408151715596](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230408151715596-1710307536702.png)

  - **解决**：case when

  - **功能**：基于不同的条件，返回不同的结果

  - **语法**

    ```mysql
    -- 语法1：限制性，不常用
    case 列 when 值1 then 返回1
            when 值2 then 返回2
            ……
            else 返回N
            end
    
    -- 语法2：最常用
    case when 条件1 then 返回1
         when 条件2 then 返回2
         ……
         else 返回N
         end
    ```

  - **示例**

    ```mysql
    /*
        查询每个用户的总订单金额，并按总订单金额降序排序，并显示用户价值评语
        如果金额高于10000，就显示你是富婆吧
        如果金额高于500 小于 10000，则显示你是程序员吧
        如果金额高于100 小于 500, 则显示你真棒
        除以上所有情况以外，则显示你抓紧搬砖吧
     */
    with tmp as (
        select
            u_id,
            sum(o_amount) as total_price
        from db_multi_tb.tb_order
        group by u_id
        order by total_price desc
    )
    select
        *,
        case when total_price > 10000 then '你认识富婆吧'
             when total_price > 500 then '你是程序员吧'
             when total_price > 100 then '你真棒'
             else '你抓紧搬砖吧'
             end as evl
    from tmp;
    ```

  - **场景**：如果 A 则 B，如果 C 则 D ……，**==多条件的判断场景==**

- **小结**：case when的功能及语法是什么？

  - 功能：实现多条件的判断，基于不同判断的结果返回不同的值

  - 语法

    - 方式一：case  列名 when  值1 then 结果1 when 值2 then 结果2 else 结果N end

      - 等值匹配

    - 方式二：case when 条件1 then 结果1 when 条件2 then 结果2 else 结果N  end

      - 多条件的复杂判断



## 知识点06：【掌握】其他判断函数if、ifnull、coalesce

- **目标**：**掌握其他判断函数及转换函数**

- **实施**

  - ==**if**==

    - 功能：用于实现条件判断，基于条件判断的结果返回不同的值，**==用于单条件场景==**

    - 语法：if(判断条件，条件成立返回的结果，条件不成立返回的结果)

    - 示例

      ```mysql
      -- 如果订单金额大于100，就显示有钱，否则就显示有命
      select
          *,
          if(o_amount > 100, '有钱', '有命') as have
      from db_multi_tb.tb_order;
      
      
      -- 如果用户性别是1则显示为男性，如果是2则显示为女性
      select
          *,
          if(u_gender = 1, '男', '女') as gender_new
      from db_multi_tb.tb_user;
      
      -- 多条件嵌套
      select
          *,
          if(u_gender = 1, '男', if(u_gender =2, '女', '未知')) as gender_new
      from db_multi_tb.tb_user;
      ```

    

  - **ifnull**

    - 功能：用于判断第一个参数是否为null，如果为null则返回第二个参数，如果不为null则返回第一个参数

    - 语法：ifnull(参数1，参数2)

    - 示例

      ```sql
      -- 创建表
      create table if not exists tb_data_func_06
      as
      select 'u001' as emp_id, 3000.00 as salary
      union all
      select 'u002' as emp_id, null as salary
      union all
      select 'u003' as emp_id, null as salary
      union all
      select 'u004' as emp_id, 6000.00 as salary
      ;
      
      -- 查询数据
      select * from tb_data_func_06;
      
      
      -- 如果 薪资为 null 则显示为0
      select
          *,
          case when salary is null then 0 else salary end as case_rs,
          if(salary is null, 0, salary) as if_rs,
          ifnull(salary, 0) as ifnull_rs
      from tb_data_func_06;
      ```

      

  - **coalesce**

    - 功能：返回参数列表中第一个非空的值

    - 语法：coalesce（参数1，参数2，参数3……参数N）

    - 示例

      ```mysql
      select emp_id, coalesce(salary,0) as sal from tb_data_func_06;
      ```

- **小结**：掌握其他判断函数及转换函数



## 知识点07：【理解】类型转换函数：cast

- **目标**：**掌握其他判断函数及转换函数**

- **实施**

  - **cast**

  - 功能：将某一数据的类型进行转换

  - 语法：cast( 列 as 新的类型)

    <img src="Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230408163604677.png" alt="image-20230408163604677" style="zoom: 67%;" />

  - 示例

    ```mysql
    select cast('5' as UNSIGNED) - 1;
    select '5' - 1;
    select cast('2023-01-01 15:31:27' as date );
    select cast('2023-01-01 15:31:27' as time );
    select cast('2023-01-01' as dateti
    ```

- **小结**：掌握其他判断函数及转换函数



​	

# ==【模块二：窗口函数的设计】==

## 知识点08：【理解】统计分析的问题

- **目标**：**理解统计分析的问题**

- **实施**
  
  - **准备数据**
    
    ```sql
    drop database if exists db_window_func;
    create database if not exists db_window_func;
    use db_window_func;
    -- 创建员工表
    drop table if exists tb_emp;
    create table tb_emp
    (
        empno int primary key auto_increment,
        ename varchar(20),
        sal double(10, 2),
        deptno int
    );
    insert into tb_emp
    values (null, '张三', 1000, 10),
           (null, '李四', 800, 10),
           (null, '王五', 1000, 10),
           (null, '赵六', 3000, 10),
           (null, '田七', 5000, 20),
           (null, '钱八', 4000, 20),
           (null, '高九', 3000, 20),
           (null, '任十', 9000, 30),
           (null, '马十一', 10000, 30),
           (null, '牛十二', 1000, 30);
    select * from tb_emp;
    
    -- 创建部门表
    drop table if exists tb_dept;
    create table tb_dept
    (
        deptno int primary key ,
        dname varchar(20),
        loc varchar(30)
    );
    insert into tb_dept
    values (10, '人事部', '中国上海'),
           (20, '财务部', '中国北京'),
           (30, '销售部', '中国香港'),
           (40, '采购部', '中国深圳');
    select * from tb_dept;
    ```
    
  - **需求1**：查询薪资最高的前2名员工的信息
  
    ```sql
    select * from tb_emp order by sal desc limit 2;
    ```
  
  - **需求2**：查询每个部门薪资最高的员工的信息
  
    ```sql
    -- 保留所有最高薪资
    with t1 as (
        select
               deptno, max(sal) as max_sal
        from tb_emp
        group by deptno
    )
    select
        a.*
    from tb_emp a
    join t1 on a.deptno = t1.deptno and a.sal = t1.max_sal
    order by a.deptno;
    ```
  
  - **需求3**：查询每个部门薪资最高的**==前2个员工==**的信息？
  
  - **问题**：能不能用分组？能不能不聚合【count、sum、max、min、avg、group_concat】？
  
    - 能分组：按照部门分组，将相同部门的数据放到一起，一个部门就是一组
    - 不能做传统聚合，因为传统聚合，一组最后只能聚合成一条
    - 需求：每一组返回两条
  
  - **需求**：需要分组，但是不聚合，能够保留每个分组内的每条原始数据
  
- **小结**：理解统计分析的问题



## 知识点09：【掌握】窗口函数的设计

- **目标**：**掌握窗口函数的设计**

- **实施**：https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html

  ![image-20230409195645853](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230409195645853.png)

  - **设计**：为了实现分组聚合、排序、位置偏移等操作并**==保留原始数据内容==**，提高查询效率和代码可读性

  - **功能**：基于数据实现**==分区==**，并对分区内部的数据进行基于窗口的**==排序==**、**聚合**等操作并**保留原始的数据**行内容

  - **实现**

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

  - ==**语法**==

    ```mysql
    -- 英文版
    func_name(args) over ( partition by col order by col [asc | desc] [window_size] )
    
    -- 中文版
    函数名(参数) over ( partition by 分区字段 order by 排序字段 [升序或者降序] [窗口大小范围] )
    ```

  - **说明**

    - **partition by**：指定按照某一列分区，分区类似于分组，**==相同分区的数据会放到一起==**
      - 关键字：每、每个、各个、不同、每种
      - 分组：group by + 聚合函数：一组返回一条：每个部门薪资最高的：多对一
      - 分区：窗口函数 + partition by：一组返回多条：每个部门薪资最高的前两个：多对多
    - **order by**：指定每个**==分区内部==**按照哪一列进行排序
    - **window_size**：指定窗口的大小，就是分区内部每条数据计算的范围

  - **分类**

    - **窗口聚合函数**：可以基于每个分区内部的窗口实现count/sum/max/min/avg等操作
    - **窗口分析函数**：可以基于每个分区实现排名标记等操作
    - **窗口偏移函数**：可以基于每个分区内部实现相对位置的取值操作

- **小结**：窗口函数的功能、语法、分类？

  - 功能：基于原始数据进行分区，并基于每个分区进行排序，窗口聚合等操作，但是会保留所有原始数据行
  - 语法：函数名(参数)  over (【partition by col】【order by col asc/desc】【窗口大小】)
  - 分类：窗口聚合函数、窗口分析函数、窗口偏移函数【连续登陆问题】



# ==【模块三：窗口函数：窗口聚合】==

## 知识点10：【掌握】窗口聚合函数

- **目标**：**掌握窗口聚合函数sum**

- **实施**

  - **函数**：sum

  - **功能**：生成一列基于每个分区的窗口进行sum聚合的结果

  - **语法**

    ```mysql
    sum(处理的列) over (partition by col order by col [window_size]) 
    ```

  - **示例1**

    - 需求：查询每个用户的订单情况，并显示每个用户的总订单金额

    - 结果

      ![image-20230409204017364](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230409204017364.png)

    - 代码

      ```mysql
      select
             *,
             sum(o_amount) over (partition by u_id) as sum_amt
      from db_multi_tb.tb_order;
      ```

      ![image-20230412160832611](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230412160832611.png)

  - **示例2**

    - 需求：按照时间顺序，显示每个用户的订单情况，并显示每个时间用户累计消费金额

    - 结果

      ![image-20230409203626321](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230409203626321.png)

    - 代码

      ```sql
      -- 按照时间顺序，显示每个用户的订单情况，并显示每个时间用户累计消费金额
      select
             *,
             sum(o_amount) over (partition by u_id order by o_time) as sum_amt
      from db_multi_tb.tb_order;
      ```
      
      ![image-20230412161444539](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230412161444539.png)

- **小结**：窗口聚合函数sum的功能及语法是？

  - 功能：基于分区以及分区排序的结果对**==每个分区内部==**按照一定的窗口进行聚合
  - 语法：sum(累加的列) over (partition by col order by col [window])



## 知识点11：【理解】其他窗口聚合函数

- **目标**：**理解其他窗口聚合函数**

- **实施**

  - **函数**：count、max、min、avg

  - **功能**：生成一列基于每个分区的窗口进行count、max、min、avg聚合的结果

  - **语法**

    ```mysql
    count/max/min/avg(处理的列) over (partition by col order by col [window_size]) 
    ```

  - **示例1**

    - 需求：查询每个用户的订单情况，并显示每个用户的总订单个数和平均订单金额

    - 结果

      ![image-20230409204543799](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230409204543799.png)

    - 代码

      ```mysql
      select
             *,
             count(o_id) over (partition by u_id) as o_cnt,
             avg(o_amount) over (partition by u_id) as avg_amt
      from db_multi_tb.tb_order;
      ```

  - **示例2**

    - 需求：查询每个用户的订单情况，按照订单时间升序排序，并显示每个用户的最大订单金额和最小订单金额

    - 结果

      ![image-20230409205351264](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230409205351264.png)

      ![image-20230412164114710](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230412164114710.png)

    - 代码

      ```mysql
      select
             *,
             max(o_amount) over (partition by u_id order by o_time rows between unbounded preceding and unbounded following) as max_amt,
             min(o_amount) over (partition by u_id order by o_time rows between unbounded preceding and unbounded following) as min_amt
      from db_multi_tb.tb_order;
      ```

  - -  

      ![image-20230412165205549](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230412165205549.png)
  
      ![image-20230412165435146](Day06：MySQL中的DQL：判断函数与窗口函数.assets/image-20230412165435146.png)

  - ==**注意：不是所有的窗口函数都能指定窗口**==

- **小结**：理解其他窗口聚合函数



```
userid		date		amt
u001		2024-01		10
u001		2024-01		10
u001		2024-01		10
u001		2024-02		5
u001		2024-02		10
u001		2024-03		30

||

userid		date		month_amt		acc_amt
u001		2024-01			30				30
u001		2024-02			15				45
u001		2024-03			30				75

with t1 as (
	-- 计算每个用户每个月存款金额
	select userid,
			date,
			sum(amt) as month_amt
	from table
	group by userid, date
)
select *
		, sum(month_amt) over (partition by userid order by date) as acc_amt
from t1;
```

