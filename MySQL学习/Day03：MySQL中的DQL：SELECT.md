# MySQL中的DQL：SELECT

## 知识点01：课程回顾

![image-20240330094737380](Day03：MySQL中的DQL：SELECT.assets/image-20240330094737380.png)



## 知识点02：课程目标

```
select 1 from 2  where 3  group by 4 having 5 order by 6 limit 7		=> 记住每个关键词语法和功能
```

1. **基础查询 select与 where**
   - 目标：掌握select单表语法中每个位置的功能与where的使用
   - 问题1：==**7个位置每个位置的功能是什么？**==
     - 1、select：决定了结果中列的个数，实现列的筛选 => 列裁剪
     - 2、from：决定了查询数据的来源，实现数据读取
     - 3、where：决定了查询到的数据按照条件对行进行过滤【分组前】 => 行裁剪
     - 4、group  by：按照哪些列进行分组，将相同列值的数据放入同一组中，实现每组统计分析：每个、每、各个、不同
     - 5、having：决定了查询到的数据按照条件对行进行过滤【分组后】=> 行裁剪
     - 6、order by：按照哪些列进行排序，指定升序【asc】或者降序【desc】：TopN、升序、降序、最多、最少、前N、后N
     - 7、limit：限制输出或者叫做分页查询，按照行号【默认从0开始表示第1行】指定输出特定的数据行
   - 问题2：where的使用如何实现条件过滤？
     - 功能：用于实现在分组前按照指定条件实现数据行的过滤
     - 场景：分组前行的筛选
     - 语法：select 1 from 2 where 条件1  and/or  条件2 ……
     - 条件：值的比较【=/>/</!=】、范围比较【between A and B】、模糊匹配【like：%/_】、空值匹配【is null，is not null】
2. **分组查询**
   - 目标：掌握group by与having的使用
   - 问题1：什么是group by？
     - 分组聚合：按照一定列将数据划分到多个组中，然后对每组的数据进行聚合统计分析
     - 实现步骤
       - step1：先分组
       - step2：再聚合
     - 分组：group  by：关键词：每、每个、各个、不同、各种、每种
     - 聚合：聚合函数
       - count：统计个数：count(1)/count(*)/count(列名)：count对null不计数的
       - sum：用于求和：sum(数值类型的列)
       - avg：用于计算平均值：avg（数值类型的列）
       - max：用于取最大值：max(列名)
       - min：用于取最小值：min(列名)
   - 问题2：什么是having？
     - 功能：用于实现分组后的行的过滤
     - 区别：where用于分组前行的过滤
     - 语法：having  条件1 and/or 条件2
     - 场景：对分组以后产生的列的数据进行过滤
     - 注意：如果一个过滤既能用where也能用having，优先使用where
3. **排序查询**
   - 目标：掌握order by 和limit的使用
   - 问题1：什么是order by？
     - 功能：按照指定的列实现对数据进行排序
     - 语法：order by col1 asc/desc, col2 asc/desc
     - 场景：用于实现排序取TopN，关键词：降序、升序、最大、最小、前N、后N
   - 问题2：什么是limit？
     - 功能：按照行号对结果的数据进行筛选
     - 语法：limit M, N，M表示从第几条开始查询，N表示查询几条，M默认值为0表示第1条，如果M为0，可以省略不写
     - 场景：可以单独使用，一般会搭配order by来使用
     - 注意：工作中测试查询数据，建议加上limit，严禁select * from  表;



# ==【模块一：DQL操作：基础查询select】==

## 知识点03：【掌握】统计查询select基础

- **目标**：**掌握统计查询select语法**

- **实施**

  - **分类**

    - DDL：CREATE/DROP/DESC/TRUNCATE/ALTER/SHOW
    - DML：INSERT/UPDATE/DELETE/REPALCE
    - DQL：SELECT

  - **问题**：如果根据需求从MySQL数据表中查询自己需要的数据并进行统计？

  - **功能**：从MySQL数据表中查询数据，并对数据进行处理

  - **场景**：数据库的统计查询

  - ==**单表语法【背】**==：按照顺序组合得到select语句

    ```MYSQL
    SELECT 1 FROM 2 WHERE 3 GROUP BY 4 HAVING 5 ORDER BY 6 LIMIT 7
    ```

    - 翻译
    - select：查询、选择
    - from：从什么地方
    - where：哪里、哪些
    - group by：按照什么分组
    - having：类似于where
    - order by：按照什么排序
    - limit：限制

  - 栗子

    - 统计查询每个城市的人数

      ```
      -- 两列：城市、人数
      select city, user_cnt
      ```

    - 查询用户表中所有数据

      ```
      -- 列：没有要求，就是所有列
      select *
      ```

    - 查询用户登录信息表中的用户的id和登录日期

      ```
      -- 两列：用户id、登录日期
      select userid, login_date
      ```

    - 用户表、商品表、订单表：查询所有商品的id、商品名称、商品颜色

      ```
      --三列
      select pid, pname, pcolor from 商品表
      ```

    - 查询所有男性用户的信息

      ```
      -- 条件：男性
      ```

    - 每个城市的人数，所有学科人数，各个校区的人数

      ```
      -- 关键词：每、每个、各个、不同、所有
      ```

  - ==**位置解释【理解】**==

    | 位置 | 关键词   | 功能                                                         |
    | ---- | -------- | ------------------------------------------------------------ |
    | 1    | select   | 对数据**列的筛选**，==决定了结果中的列==的样式 => 列裁剪     |
    | 2    | from     | 决定了数据来源，分析==用到哪些数据==，from就写哪些表         |
    | 3    | where    | 对数据**行的筛选**，一般用于==分组前的行的过滤==  => 分组前的行裁剪 |
    | 4    | group by | ==**按照……分组**==……，关键词：每个、各个、不同、所有、每     |
    | 5    | having   | 对数据**行的筛选**，一般用于==分组后的行的过滤== => 分组后的行裁剪 |
    | 6    | order by | ==**按照……排序……**==，关键词：升序、降序、最大前N个、最小的前N个，asc-升序、desc-降序 |
    | 7    | limit    | 限制输出，分页查询，根据**行号来筛选数据**，第一行行号默认为0，一般搭配排序使用 |

  - **基础结构**

    ```mysql
    SELECT 1 FROM 2
    ```

  - **示例**

    ```sql
    -- 查询 tb_student09 表中的所有数据
    SELECT * FROM tb_student09;
    
    -- 查询 tb_student09 表中的 学生id、学生的性别
    SELECT stu_id, stu_gender FROM tb_student09;
    
    -- 查询 tb_student09 表中的 学生的性别 并更名为 sex, 学生的姓名 并更名为 name
    SELECT stu_gender as sex, stu_name as name FROM tb_student09;
    SELECT stu_gender sex, stu_name name FROM tb_student09;
    ```

  - **Tips**

    - “ * ” 表示所有列
    - as 表示取一个别名，也可以不加，但是建议加上，可读性更强

- **小结**：select的基础语法结构是？

  ```
  select 1 from 2 where 3 group by 4 having 5 order by 6 limit 7
  ```

  - 1-决定了结果中的列，列的过滤
  - 2-决定了数据的来源
  - 3-决定行的过滤，分组前
  - 4-按照谁分组
  - 5-决定行的过滤，分组后
  - 6-按照谁排序
  - 7-分页查询



## 知识点04：【掌握】统计查询where子句

- **目标**：**掌握统计查询where子句**

- **实施**

  - **问题**：select决定了结果中显示那些列，那如果我想对行进行过滤怎么办？

  - **功能**：对数据表中的数据行进行筛选，过滤出需要的数据

  - **场景**：行的过滤【分组前】

  - **语法**

    ```mysql
    SELECT 1 FROM 2 WHERE 条件1 [ and/or 条件2 ……] 
    ```

  - **多条件**：where 后面可以跟多个条件，多个条件可以通过 and 或者 or来连接

    - and 表示并列：两个条件都成立就保留
    - or 表示或者：满足其中一个条件就保留
    - not 表示非：不满足这个条件就保留

  - **条件表达式**

    - 比较运算符

      ```
      =  : 等于
      >  : 大于
      >= : 大于等于
      <  : 小于
      <= : 小于等于
      != : 不等于
      <> : 不等于
      ```

    - 范围查询【前闭后闭：范围中包含A和B】

      ```
      BETWEEN A AND B 表示在一个A到B的范围内查询
      ```

    - 模糊匹配：LIKE: 功能是做字符串的模糊匹配，一般会在where中搭配使用

      - like中的 % 表示任意内容的多个字符，_ 表示任意内容的单个字符，匹配可以理解为从左往右匹配 
      - like的性能非常差，实际工作中一般不建议使用，了解即可

    - 常见null判断

      ```
      where col is null;
      where col is not null;
      ```

  - **示例**

    ```sql
    -- 查询 tb_student09 表中的 出生日期为 2022-01-02 的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_birth = '2022-01-02';
    
    -- 查询 tb_student09 表中的 出生日期大于 2022-01-02 的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_birth > '2022-01-02';
    
    -- 查询 tb_student09 表中的 出生日期大于 2022-01-02 的男生的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_birth > '2022-01-02' and stu_gender = 1;
    
    
    -- 查询出生日期在 2022-01-01 到 2022-01-03 之间出生的人的信息
    SELECT
        *
    FROM tb_student09
    WHERE stu_birth >= '2022-01-01' and stu_birth <= '2022-01-03';
    
    SELECT
        *
    FROM tb_student09
    WHERE stu_birth BETWEEN '2022-01-01' and '2022-01-03';
    
    -- 查询 tb_student09 表中的 姓张的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_name like '张%';
    
    -- 查询 tb_student09 表中的 不姓张的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE not stu_name like '张%';
    
    
    -- 查询 tb_student09 表中的 姓张且名字两个字的 或者 出生日期是2022-01-03 的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_name like '张_' or stu_birth = '2022-01-03';
    
    -- 查询 tb_student09 表中的 名字包含张字的 或者 出生日期是2022-01-03 的学生的id 和 学生的姓名
    SELECT
        stu_id,
        stu_name
    FROM tb_student09
    WHERE stu_name like '%张%' or stu_birth = '2022-01-03';
    ```

- **小结**：where子句的功能是什么？

  - 功能：实现数据行的筛选过滤
  - 语法：where 条件1 and/or 条件2



# ==【模块二：DQL操作：分组GROUP BY】==

## 知识点05：【理解】统计分析的需求：分组聚合

- **目标**：**理解统计分析的需求分组聚合**

- **实施**

  - **问题**：我们经常在数据分析中会遇到分组聚合的需求，哪些属于分组聚合的需求？基本的实现思路是什么？

  - **示例**

    - 需求：统计**==每个==**等级的VIP人数

    - 假想：4行、两列【等级、人数】

    - 数据

      | userid：用户id | city：城市 | vip_level：VIP等级 |
      | :------------: | :--------: | :----------------: |
      |      u001      |    上海    |        VIP1        |
      |      u002      |    北京    |        VIP2        |
      |      u003      |    上海    |        VIP1        |
      |      u004      |    北京    |        VIP1        |
      |      u005      |    上海    |        VIP1        |
      |      u006      |    北京    |        VIP2        |
      |      u007      |    上海    |        VIP2        |
      |      u008      |    杭州    |        VIP3        |
      |      u009      |    杭州    |       other        |
      |      u010      |    上海    |       other        |
      |       ……       |     ……     |         ……         |

    - 结果

      ![image-20230402204659977](Day03：MySQL中的DQL：SELECT.assets/image-20230402204659977.png)

      ```
      VIP1		1000
      VIP2		1005
      VIP3		999
      other		100
      ```

      

     **思路**：以各等级占比为例

    - step1：分组，按照每一种等级将数据进行划分

      ```mysql
      -- 第一组 VIP1
      u003	上海	VIP1
      u004	北京	VIP1
      u005	上海	VIP1
      u001	上海	VIP1
      
      -- 第二组 VIP2
      u006	北京	VIP2
      u007	上海	VIP2
      u002	北京	VIP2
      
      -- 第三组 VIP3
      u008	杭州	VIP3
      
      -- 第四组 other
      u009	杭州	other
      u010	上海	other
      ```

    - step2：聚合，计算每一组用户id的个数

      ```mysql
      -- 第一组
      VIP1	4
      
      -- 第二组
      VIP2	3
      
      -- 第三组
      VIP3	1
      
      -- 第四组
      other	2
      ```

  - **规则**：**==分组必聚合，分组聚合后每一组最后只能产生一条结果==**

- **小结**：理解统计分析的需求分组聚合



## 知识点06：【掌握】常用的聚合函数

- **目标**：**掌握常用的聚合函数**

- **实施**

  - **问题**：上述例子中，如何能实现将多条数据聚合成一条数据？

  - **解决**：聚合函数

  - **函数**：工具将一些特定功能已经封装好了，可以通过固定语法调用这个功能 => 函数

    - 一对一：普通函数：输入一个，出来一个
    - 多对一：聚合函数，输入多个，出来一个
    - 一对多：特殊函数，输入一个，出来多个

  - **定义**：可以将多行数据合并成一行数据的函数我们就可以叫做聚合函数

  - **场景**：多对一场景

  - **常用**

    | 函数          | 语法                                     | 功能                                                         |   场景   |
    | ------------- | ---------------------------------------- | ------------------------------------------------------------ | :------: |
    | count【个数】 | count(列名) 或者  count(1) 或者 count(*) | 用于对表中的某一列的每一组统计行数，==注意null不参与count==的统计 | ==计数== |
    | sum【求和】   | sum（列名）                              | 用于对表中的某一列的每一组统计求和，注意==数值类型==才有意义 |   求和   |
    | max【最大】   | max（列名）                              | 用于对表中的某一列的每一组计算最大值                         |   最大   |
    | min【最小】   | min（列名）                              | 用于对表中的某一列的每一组计算最小值                         |   最小   |
    | avg【平均】   | avg（列名）                              | 用于对表中的某一列的每一组计算平均值，注意==数值类型==才有意义 |   平均   |

  - **示例**

    ```mysql
    -- 创建测试数据表
    DROP TABLE IF EXISTS db_test_bigdata01.tb_agg_func;
    -- 将SQL的select语句的结果建成一张表
    CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_agg_func
    AS
    SELECT 'Jack' as name , 20 as age , 'F' as gender
    union all
    SELECT 'Alice' as name , 22 as age , 'M' as gender
    union all
    SELECT 'Frank' as name , 22 as age , 'F' as gender
    union all
    SELECT 'Itcast' as name , 20 as age , NULL as gender
    union all
    SELECT 'Heima' as name , 20 as age , 'M' as gender
    union all
    SELECT 'Json' as name , 20 as age , NULL as gender
    union all
    SELECT 'Maria' as name , 22 as age , 'M' as gender
    union all
    SELECT 'Iric' as name , 22 as age , 'M' as gender
    ;
    
    -- 查询数据
    SELECT * FROM db_test_bigdata01.tb_agg_func;
    
    
    -- 统计表中的行数
    SELECT
        count(*) as cnt
    FROM tb_agg_func;
    
    -- 统计用户的个数
    SELECT
        count(name) as user_cnt
    FROM tb_agg_func;
    
    -- 统计性别的个数
    SELECT
        count(gender) as gender_cnt
    FROM tb_agg_func;
    
    -- 对年龄求和
    SELECT
        sum(age) as age_sum
    FROM tb_agg_func;
    
    
    -- 查询最大年龄和最小年龄
    SELECT
        max(age) as max_age,
        min(age) as min_age
    FROM tb_agg_func;
    
    
    -- 查询名字的最大和最小值
    SELECT
        max(name) as max_name,
        min(name) as min_name
    FROM tb_agg_func;
    
    
    -- 查询年龄的平均值
    SELECT
        avg(age) as avg_age
    FROM tb_agg_func;
    
    ```

- **小结**：常用的聚合函数有哪些？

  - count：count(col)/count(1)/count(*)，用于计数，count对null不计数
  - sum：sum(col)，用于求和
  - max：max(col)，用于求最大
  - min：min(col)，用于求最小
  - avg：avg(col)，用于求平均值



## 知识点07：【掌握】group by分组的功能与应用

- **目标**：**掌握group by分组的功能与作用**

- **实施**

  - **问题**：上面的函数可以将多条数据聚合，那如何实现将数据分成多组，对每组的数据聚合呢？

  - **解决**：group by

  - **功能**：用于对指定的单个或者多个字段进行分组，字段值相同的即为一组，==**一般会搭配聚合函数使用，实现分组聚合**==

  - **语法**

    ```mysql
    -- select 1 from 2 [ where 3 ] group by 4 [ having 5 order by 6 limit 7 ]
    group by col1, col2 ……
    ```

  - **示例**

    ```mysql
    -- 统计查询每种性别的人数
    SELECT
        gender,
        count(name) as user_cnt
    FROM db_test_bigdata01.tb_agg_func
    GROUP BY gender
    ;
    
    -- 统计每种年龄的人数
    SELECT
        age,
        count(name) as user_cnt
    FROM db_test_bigdata01.tb_agg_func
    GROUP BY age
    ;
    
    -- 统计每种年龄每种性别的人数
    SELECT
        age,
        gender,
        count(name) as user_cnt
    FROM db_test_bigdata01.tb_agg_func
    GROUP BY age, gender
    ;
    
    -- 统计每种性别的总年龄、最大年龄、最小年龄、平均年龄
    SELECT
        gender,
        sum(age) as total_age,
        max(age) as max_age,
        min(age) as min_age,
        avg(age) as avg_age
    FROM db_test_bigdata01.tb_agg_func
    GROUP BY gender
    ;
    
    -- 查询所有男性人群中每种年龄的人数
    SELECT
        age,
        count(name) as user_cnt
    FROM db_test_bigdata01.tb_agg_func
    WHERE gender = 'M'
    GROUP BY age
    ;
    ```

  - **场景**：在分析需求中出现了以下关键字搭配时候，就可以考虑分组聚合

    ```sql
    -- 关键词：每、每个、每种、各个、不同、所有
    -- 分组字段：关键词后面的列就是分组字段
    ```

  - ==**注意：分组语句中select后面的写法，只能有三种情况**==

    - 分组字段
    - 函数结果：聚合函数
    - 常量

- **小结**：分组的功能和应用场景是什么？

  - 分组：按照分组规则，将相同的值放入同一组
  - 场景：统计分析聚合



## 知识点08：【掌握】having的功能与应用

- **目标**：**掌握having的功能与应用**

- **实施**

  - **问题**：我们要过滤行，可以在where中实现，但是如果想要分组以后进行过滤怎么办？

    - 因为where是在分组聚合之前先执行的，所以如果要对分组以后的数据进行行的过滤，where无法实现

  - **解决**：having

  - **功能**：用于实现对**分组聚合后**的结果进行**行的过滤**

  - **场景**：分组后的过滤，固定搭配group by使用

  - **语法**

    ```sql
    -- select 1 from 2 [ where 3 ] group by 4 having 5 [ order by 6 limit 7 ]
    having 条件
    ```

  - **示例**

    ```sql
    -- 统计每种年龄每种性别的人数，要求人数至少大于1人
    SELECT
        age,
        gender,
        count(1) as cnt
    FROM tb_agg_func
    GROUP BY age, gender
    HAVING cnt > 1
    ;
    
    
    -- 统计查询 平均年龄大于21 的 每种性别的最大年龄，最小年龄
    SELECT
        gender,
        max(age) as max_age,
        min(age) as min_age,
        avg(age) as avg_age
    FROM tb_agg_func
    GROUP BY gender
    HAVING  avg_age >= 21;
    
    
    SELECT
        gender,
        max(age) as max_age,
        min(age) as min_age
    FROM tb_agg_func
    GROUP BY gender
    HAVING avg(age) >= 21;
    ```

  - **区分**：什么时候用where，什么时候用having，如果都可以，优先选择谁？

    - 过滤的条件在分组之前就有的：where
    - 过滤的条件在分组之后才有的：having

    ```SQL
    -- 统计查询所有性别不为空的每种性别的平均年龄
    -- where做
    SELECT
        gender,
        avg(age) as avg_age
    FROM db_test_bigdata01.tb_agg_func
    WHERE gender IS NOT NULL
    GROUP BY gender;
    
    -- having做
    SELECT
        gender,
        avg(age) as avg_age
    FROM db_test_bigdata01.tb_agg_func
    GROUP BY gender
    HAVING gender IS NOT NULL;
    ```

  - **结论**：如果where和having都能实现相同的需求，优先使用where，原则：Predicate Push Down：谓词下推

  - **场景**：如果过滤的字段分组聚合之前就有就使用where，如果字段是分组聚合以后才产生就使用having

- **小结**：having的功能是什么，与where有什么区别？

  - 功能：实现数据行的过滤筛选，作用等同于where
  - 场景：用于分组后的行的过滤
  - 区别：where在分组前





# ==【模块三：DQL操作：排序ORDER BY、LIMIT】==

## 知识点09：【理解】统计分析的需求：排序TopN

- **目标**：**理解统计分析的需求排序TopN**

- **实施**

  - **问题**：我们经常在数据分析中会遇到排序TopN的需求，哪些属于排序TopN的需求？基本的实现思路是什么？

    - step1：先排序
    - step2：基于排序的结果取前N个

  - **示例**

    ![image-20230402221555086](Day03：MySQL中的DQL：SELECT.assets/image-20230402221555086.png)

    

    ![image-20230402221615439](Day03：MySQL中的DQL：SELECT.assets/image-20230402221615439.png)

    ![image-20230402221755264](Day03：MySQL中的DQL：SELECT.assets/image-20230402221755264.png)

  - **思路**

    - ==**对数据按照一定的规则进行升序或者排序即可**==

    - 数据：name、age、gender

      ```
      Jack	20	F
      Alice	22	M
      Frank	21	F
      Itcast	18	F
      Heima	10	M
      Json	40	M
      Maria	22	M
      Iric	62	M
      ```

    - 按照年龄降序

      ```
      Iric	62	M
      Json	40	M
      Alice	22	M
      Maria	22	M
      Frank	21	F
      Jack	20	F
      Itcast	18	F
      Heima	10	M
      ```

    - 按照年龄升序

      ```
      Heima	10	M
      Itcast	18	F
      Jack	20	F
      Frank	21	F
      Alice	22	M
      Maria	22	M
      Json	40	M
      Iric	62	M
      ```

    - 按照姓名升序排序

      ```
      Alice	22	M
      Frank	21	F
      Heima	10	M
      Iric	62	M
      Itcast	18	F
      Jack	20	F
      Json	40	M
      Maria	22	M
      ```

    - 按照年龄升序排序，如果年龄相同，按照姓名降序排序

      ```
      Heima	10	M
      Itcast	18	F
      Jack	20	F
      Frank	21	F
      Maria	22	M
      Alice	22	M
      Json	40	M
      Iric	62	M
      ```

    - 按照年龄升序排序，如果年龄相同，按照姓名降序排序，并取前3

      ```
      Heima	10	M
      Itcast	18	F
      Jack	20	F
      ```

  - **规则**：按照业务需求，对单个或者多个字段进行排序，并对排序的结果进行筛选输出即可

- **小结**：理解统计分析的需求排序TopN



## 知识点10：【掌握】order by排序的功能与应用

- **目标**：**掌握order by排序的功能与应用**

- **实施**

  - **问题**：上面的效果如何在SQL语句中实现？

  - **解决**：order by

  - **功能**：用于对指定的单个或者多个字段进行排序，可以对每个字段按照从左往右指定升序或者降序

  - **语法**

    ```mysql
    -- select 1 from 2 [ where 3 group by 4 having 5 ] order by 6 [ limit 7 ]
    order by col1 , col2 [asc | desc]
    
    asc：表示升序，可以不写，默认就是升序
    desc：表示降序
    ```

  - **示例**

    ```sql
    -- 创建测试数据表
    DROP TABLE IF EXISTS db_test_bigdata01.tb_topn;
    CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_topn
    AS
    SELECT 'Jack' as name, 20 as age, 'F' as gender
    union all
    SELECT 'Alice' as name, 22 as age, 'M' as gender
    union all
    SELECT 'Frank' as name, 21 as age, 'F' as gender
    union all
    SELECT 'Itcast' as name, 18 as age, 'F' as gender
    union all
    SELECT 'Heima' as name, 10 as age, 'M' as gender
    union all
    SELECT 'Json' as name, 40 as age, 'M' as gender
    union all
    SELECT 'Maria' as name, 22 as age, 'M' as gender
    union all
    SELECT 'Iric' as name, 62 as age, 'M' as gender
    ;
    
    -- 按照年龄升序排序
    SELECT *
    FROM tb_topn
    ORDER BY age ASC;
    
    SELECT *
    FROM tb_topn
    ORDER BY age;
    
    -- 按照年龄降序排序
    SELECT *
    FROM tb_topn
    ORDER BY age DESC;
    
    -- 按照名称降序排序
    SELECT *
    FROM tb_topn
    ORDER BY name DESC;
    
    -- 按照年龄升序排序，如果年龄相同，按照名称降序排序
    SELECT *
    FROM tb_topn
    ORDER BY age, name DESC;
    
    -- 查询所有男性的信息并按照年龄降序排序
    SELECT *
    FROM tb_topn
    WHERE gender = 'M'
    ORDER BY age DESC;
    
    -- 查询每种性别的平均年龄，并按照平均年龄降序排序
    SELECT
        gender,
        avg(age) as avg_age
    FROM tb_topn
    GROUP BY gender
    ORDER BY avg_age DESC;
    ```

  - **场景**：在分析需求中出现了以下关键字搭配时候，就可以考虑排序

    ```sql
    -- 关键词：排序，升序，降序。前N个、后N个、最大N个、最小N个、最多、最高、最低
    -- 排序字段：根据需求排序字段
    ```

- **小结**：order by的功能及场景是什么？

  - 功能：用于实现对数据的排序，可以指定升序或者降序
  - 语法：order by col asc, col desc
  - 场景：统计分析取TopN



## 知识点11：【掌握】limit的功能与应用

- **目标**：**掌握limit的功能与应用**

- **实施**

  - **问题**：order by实现了排序，但是怎么实现取排序后的前N行？

  - **解决**：limit分页查询

  - **功能**：用于对select语句的结果根据需求查询固定行的数据【理解：根据行号对表中的行进行筛选】

  - **语法**

    ```sql
    -- select 1 from 2 [ where 3 group by 4 having 5  order by 6 ] limit 7 
    limit M, N ：表示从第M条开始显示N条数据
    M：表示从第几条开始，第一行为0，第二行为1，第N行为N-1，M默认为0，默认为0的时候M可以省略不写
    N：表示显示几条
    ```

  - **示例**

    ```mysql
    -- 按照年龄降序排序，返回年龄最大的前5条
    SELECT *
    FROM tb_topn
    ORDER BY age DESC
    LIMIT 0, 5;
    
    -- 如果是从第一条开始查询，M可以省略
    SELECT *
    FROM tb_topn
    ORDER BY age DESC
    LIMIT 5;
    
    -- 按照年龄降序排序，返回年龄最大的第6 - 10条
    -- 如果是从第一条开始查询，M可以省略
    SELECT *
    FROM tb_topn
    ORDER BY age DESC
    LIMIT 5, 5;
    ```

  - **场景**：一般用于分页查询或者搭配order by 实现TopN

- **小结**：掌握limit的功能与应用



## 知识点12：【理解】保存select语句的结果

- **目标**：**理解保存select语句的结果**

- **实施**

  - **问题**：每次select语句的结果都是打印在控制台中，实际工作中需要将结果保存，如何实现？

  - **方案一**：create table …… as select ……

    - 功能：用于将select语句的结果直接创建成一张==**不存在**==的新表，将结果保存到表中

    - 分类：DDL

    - 场景：**结果表不存在**，具体场景：每次会将SQL语句的结果临时的存在这张表中，下次可以先删除再存新的数据【临时表】

    - 示例

      ```sql
      -- 查询每种性别的平均年龄，并按照平均年龄降序排序，将结果保存到表中
      CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_result02
          AS
      SELECT
          gender,
          avg(age) as avg_age
      FROM tb_topn
      GROUP BY gender
      ORDER BY avg_age DESC;
      ```

      

  - **方案二**：insert into …… select ……

    - 功能：用于将select语句的结果插入到一张==**已存在**==的表中，将结果保存到表中

    - 分类：DML

    - 场景：**结果表已经存在了**，具体场景：先建结果表，每次将每天的结果追加放入结果表中

    - 示例

      ```SQL
      -- 创建结果表
      CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_result03
      (
        `gender` varchar(1),
        `avg_age` decimal(20,4)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8
      ;
      
      -- 写入结果表
      INSERT INTO db_test_bigdata01.tb_result03
      SELECT
          gender,
          avg(age) as avg_age
      FROM tb_topn
      GROUP BY gender
      ORDER BY avg_age DESC;
      ```

- **小结**：理解保存select语句的结果
