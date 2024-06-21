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

CONCAT(str1,str2,…))函数用于返回多个字符串连接之后的字符串，例如：

```
SELECT CONCAT('MySQL', '字符串', '函数') AS str;s
```

如果该函数中的任何参数为 NULL，返回结果为 NULL。例如：

```
SELECT CONCAT('MySQL', NULL, '函数') AS str;
```

对于字符串常量，我们也可直接将它们连写在一起。例如：

```
SELECT 'MySQL' '字符串' '函数' AS str;
```

以上方式只能用于连接字符串常量，不能用于连接字段的值。

如果启用了 SQL 模式 PIPES_AS_CONCAT，MySQL 逻辑或运算符（||）也可以用于连接字符串，类似于 Oracle 和 PostgreSQL。

除了 CONCAT(str1,str2,…)) 函数之外，CONCAT_WS(separator,str1,str2,…))函数表示使用指定的分隔符 separator 连接多个字符串，分隔符为 NULL 则返回 NULL。例如：

```
SELECT CONCAT_WS('-', 'MySQL', NULL, '字符串') AS str1,       CONCAT_WS(NULL, 'MySQL', '字符串') AS str2;
```

#### **lower()**

LOWER(str)和LCASE(str)函数用于将字符串转换为小写形式，例如：

```
SELECT LOWER('MySQL字符串函数') AS str1, LCASE('MySQL字符串函数') AS str2;
```

MySQL 大小写转换函数不支持二进制字符串（BINARY、VARBINARY、BLOB)），可以将其转换为非二进制的字符串之后再进程处理。例如：

```
SELECT LOWER(BINARY 'MySQL字符串函数') AS str1,       LOWER(CONVERT(BINARY 'MySQL字符串函数' USING utf8mb4)) AS str2;
```

#### **upper()**

UPPER(str)和UCASE(str)函数用于将字符串转换为大写形式，例如：

```
SELECT UPPER('MySQL字符串函数') AS str1, UCASE('MySQL字符串函数') AS str2;
```

#### **length()**

LENGTH(str)和OCTET_LENGTH(str)函数用于返回字符串的字节长度，例如：

```
SELECT LENGTH('MySQL字符串函数') AS len1, OCTET_LENGTH('MySQL字符串函数') AS len2;
```

在 utf8mb4 编码中，一个汉字字符占用 3 个字节。

另外，CHAR_LENGTH(str)和CHARACTER_LENGTH(str)函数用于返回字符串的字符长度，也就是字符个数。例如：

```
SELECT CHAR_LENGTH('MySQL字符串函数') AS len1, CHARACTER_LENGTH('MySQL字符串函数') AS len2;
```

BIT_LENGTH(str)函数用于返回字符串的比特长度（比特数量），例如：

```
SELECT BIT_LENGTH('MySQL字符串函数') AS len;
```

一个字节包含 8 个比特。

**SUBSTRING()**

SUBSTRING(str,pos)、SUBSTRING(str FROM pos)、SUBSTRING(str,pos,len)以及SUBSTRING(str FROM pos FOR len)函数都可以用于返回从指定位置 pos 开始的子串，len 表示返回子串的长度；pos 为 0 表示返回空字符串。例如：

```
SELECT SUBSTRING('MySQL字符串函数', 6) AS str1,       SUBSTRING('MySQL字符串函数' FROM 6) AS str2,       SUBSTRING('MySQL字符串函数', 6, 3) AS str3,       SUBSTRING('MySQL字符串函数' FROM 6 FOR 3) AS str4,       SUBSTRING('MySQL字符串函数', 0) AS str5;
```

位置参数 pos 可以为负数，此时返回的子串从字符串右侧第 pos 个字符开始。例如：

```
SELECT SUBSTRING('MySQL字符串函数', -2) AS str1,       SUBSTRING('MySQL字符串函数', -5, 3) AS str2;
```

另外，SUBSTR()和MID()函数都是 SUBSTRING() 函数的同义词，也支持以上 4 种形式。

LEFT(str,len)函数返回字符串 str 左侧的 len 个字符，RIGHT(str,len)函数返回字符串 str 右侧的 len 个字符。例如：

```
SELECT LEFT('MySQL字符串函数',5) AS str1,       RIGHT('MySQL字符串函数',5) AS str2;
```

SUBSTRING_INDEX(str,delim,count)函数返回第 count 个分隔符 delim 之前的子串。如果 count 为正数，从左侧开始计数并返回左侧的所有字符；如果 count 为负数，从右侧开始计数并返回右侧的所有字符。例如：

```
SELECT SUBSTRING_INDEX('张三;李四;王五', ';', 2) AS str1,       SUBSTRING_INDEX('张三;李四;王五', ';', -2) AS str2;
```

#### trim() 

TRIM([remstr FROM] str)函数用于返回删除字符串 str 两侧所有 remstr 字符串之后的子串，remstr 默认为空格。例如：

```
SELECT TRIM('  MySQL字符串函数  ') AS str1,       TRIM('-' FROM '--MySQL字符串函数--') AS str2;
```

TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str)函数用于返回删除字符串 str 两侧/左侧/右侧所有 remstr 字符串之后的子串，默认删除两侧字符串（BOTH），remstr 默认为空格。例如：

```
SELECT TRIM(LEADING ' ' FROM '  MySQL字符串函数  ') AS str1,       TRIM(TRAILING '-' FROM '--MySQL字符串函数--') AS str2;
```

#### **lpad()/rpad()**

LPAD(str,len,padstr)函数表示字符串 str 的左侧使用 padstr 进行填充，直到长度为 len；RPAD(str,len,padstr)函数表示在字符串 str 的右侧使用 padstr 进行填充，直到长度为 len。例如：

```
SELECT LPAD(123, 6, '0') AS str1, LPAD(123, 2, '0') AS str2,       RPAD(123, 6, '0') AS str1, RPAD(123, 2, '0') AS str1;
```

当字符串 str 的长度大于 len 时，相当于从右侧截断字符串。

另外，REPEAT(str,count)函数用于将字符串 str 复制 count 次并返回结果。例如：

```
SELECT REPEAT('', 5) AS str;
```

#### **instr()** 

INSTR(str,substr)函数用于返回子串 substr 在字符串 str 中第一次出现的索引位置，没有找到子串时返回 0。例如：

```
select INSTR('MySQL字符串函数', '字符串') AS index1,       INSTR('MySQL字符串函数', '日期') AS index2,       INSTR('MySQL字符串函数', '') AS index3,       INSTR('MySQL字符串函数', null) AS index4;
```

另外，LOCATE(substr,str)函数也可以用于返回子串 substr 在字符串 str 中第一次出现的索引位置，和 INSTR(str,substr) 函数唯一的不同就是参数的顺序相反。

LOCATE(substr,str,pos)函数返回子串 substr 在字符串 str 中从位置 pos 开始第一次出现的索引位置，例如：

```
SELECT LOCATE('S','MySQL Server', 5) AS ind;
```

FIELD(str,str1,str2,str3,…) 函数返回字符串 str 在后续字符串列表中出现的位置，没有找到时返回 0。例如：

```
SELECT FIELD('李四', '张三', '李四', '王五') AS ind;
```

FIND_IN_SET(str,strlist) 函数返回字符串 str 在列表字符串 strlist 中出现的位置，strlist 由 N 个子串使用逗号分隔组成。例如：

```
SELECT FIND_IN_SET('李四', '张三,李四,王五') AS ind;
```

#### **replace()**

REPLACE(str,from_str,to_str)函数用于将字符串 str 中所有的 from_str 替换为 to_str，返回替换后的字符串。例如：

```
SELECT REPLACE('MySQL字符串函数', '字符串', '日期') AS str1,       REPLACE('MySQL字符串函数', '字符串', '') AS str2;
```

另外，INSERT(str,pos,len,newstr)函数用于在字符串 str 的指定位置 pos 之后插入子串 newstr，替换随后的 len 个字符。例如：

```
SELECT INSERT('MySQL字符串函数', 6, 3, '日期') AS str;
```

#### **reverse()**

REVERSE(str)函数用于将字符串 str 中的字符顺序进行反转。例如：

```
SELECT REVERSE('上海自来水来自海上')='上海自来水来自海上' AS "回文";
```

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

- FROM_UNIXTIME(1679712000);时间戳转换为日期

- UNIX_TIMESTAMP('2023-04-01 00:00:00');日期转换为时间戳

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



### lead()和lag()：

查询当前行向下偏移n行对应的结果
该函数有三个参数：第一个为待查询的参数列名，第二个为向下偏移的位数，第三个参数为超出最下面边界的默认值。
如下代码：

查询向下偏移 2 位的年龄

```SELECT user_id,
SELECT user_id,
       user_age,
       lead(user_age, 2, 0) over(ORDER BY user_id)
FROM user_info;
```

LEAD()函数图示：

![img](https://img-blog.csdnimg.cn/2020101216015020.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1NjaGFmZmVyX1c=,size_16,color_FFFFFF,t_70#pic_center)  
