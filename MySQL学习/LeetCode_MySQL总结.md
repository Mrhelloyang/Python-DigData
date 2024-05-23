# LeetCode_MySQL总结

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

## 单行函数

### 字符串函数

### 数学函数

### 日期函数

- **datediff()**，求日期之间的日期差值；

  ```sql
  select datediff('2023-11-11', '2023-09-10');
  ```

  

- **timestampdiff()**, timestampdiff(day, a.date, b.date)=-1，a比b晚一天；

  ```sql
  timestampdiff(day, a.date, b.date)
  ```

- **DATE_FORMAT(date, format)** 函数用于将日期/时间类型的值按照指定的格式进行格式化输出。
- 它的一般语法如下：其中，date 参数是要被格式化的日期/时间值，format 参数是指定的日期/时间格式，可以是一个字符串常量或者包含日期格式控制符的字符串。

下面是一些常用的日期和时间格式控制符：

```sql
%Y	年份，四位数字
%y	年份，两位数字
%m	月份，两位数字
%c	月份，没有前导零
    %d	月份中的第几天，两位数字
%e	月份中的第几天，没有前导零
%H	小时，24小时制，两位数字
%h	小时，12小时制，两位数字
%i	分钟，两位数字
%s	秒钟，两位数字
%p	AM 或 PM
```



### 流程控制函数

- ifnull()，判断为空函数

  ```sql
  IFNULL(Round(SUM(sales) / SUM(units), 2), 0)--如果Round(SUM(sales) / SUM(units)为空时，返回0，否则返回原值
  ```

  

### 其他函数

## 聚合函数

- count()条件统计，count()函数中使用条件表达式加or null来实现，作用就是当条件不满足时，函数变成了count(null)不会统计数量

  ```sql
  mysql> select count(num > 200 or null) from a;
  ```

  

## 窗口函数

**窗口范围**

- 默认窗口

  - 既有分区，又有排序：默认窗口是从分区第一行到当前行  【row between unbounded preceding and current row】

  - 只有分区：默认窗口是从分区第一行到最后一行 => 整个分区 【row between unbounded preceding and unbounded following】

  - 只有排序：从分区第一行到当前行，如果有重复排序值，直接累加

- 自己定义窗口

  ```mysql
  rows between 起始位置 and 结束位置  / range between start and end
  ```

  - preceding：前面的
  - following：后面的
  - current row：当前行
  - unbounded preceding：从分区的第一行
  - unbounded following：到分区的最后一行

  ```properties
  rows between unbounded preceding and current row: 从分区的第一行到当前行
  rows between 2 preceding and current row: 从前2行到当前行
  rows between 3 preceding and 1 following: 从前3行到后1行， 一共5行
  rows between current row and unbounded following:从当前行到最后一行
  ```

- 示例

  ```mysql
  -- 有分区，有排序，默认从第一行到当前行
  select
         *,
         max(o_amount) over (partition by u_id order by o_time ) as max_amt,
         min(o_amount) over (partition by u_id order by o_time ) as min_amt
  from db_multi_tb.tb_order;
  
  -- 有分区，无排序，默认分区第一行到最后一行
  select
         *,
         max(o_amount) over (partition by u_id) as max_amt,
         min(o_amount) over (partition by u_id) as min_amt
  from db_multi_tb.tb_order;
  
  -- 无分区，有排序，默认分区第一行到最后一行
  select
         *,
         sum(o_status) over (order by o_time) as sum_amt,
         count(o_id) over (order by o_id) as cnt
  from db_multi_tb.tb_order;
  
  
  -- 指定窗口，当前行到最后一行
  select
         *,
         sum(o_status) over (partition by u_id order by o_time rows between current row and unbounded following) as sum_sta
  from db_multi_tb.tb_order;
  
  -- 指定窗口，前一行到后一行
  select
         *,
         sum(o_status) over (partition by u_id order by o_time rows between 1 preceding and 1 following) as sum_sta
  from db_multi_tb.tb_order;
  
  -- 指定窗口，前一行到最后一行
  select
         *,
         sum(o_status) over (partition by u_id order by o_time rows between 1 preceding and unbounded following) as sum_sta
  from db_multi_tb.tb_order;
  ```




### row_number

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



### rank

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

### dense_rank

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

- 
