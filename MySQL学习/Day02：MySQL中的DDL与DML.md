# MySQL中的DDL与DML

## 知识点01：课程回顾

![image-20240328094501538](Day02：MySQL中的DDL与DML.assets/image-20240328094501538.png)



## 知识点02：课程目标

1. 表的DDL

   - 目标：==**掌握表的DDL操作**==

   - 问题1：如何实现表的列举？

     - 列举当前数据库中所有表：show  tables; 
     - 列举某个数据库中所有表：show  tables  in   数据库名称;

   - 问题2：创建表的语法是什么？

     ```
     create table if not exists 数据库名.表名(
     	列名1  类型1  【约束】 【列的注释】,
     	列名2  类型2  【约束】 【列的注释】,
     	……
     	列名N  类型N  【约束】 【列的注释】
     ) 【表的配置：引擎、字符集】 【表的注释】
     ;
     ```

   - 问题3：常用的数据类型有哪些？

     - 设计目的：让数据库系统识别不同类型的列可以做不同操作
     - 数值类型：整数【bit、tinyint、int、bigint】、小数/浮点型【double、decimal】
     - 日期时间：date、datetime、timestamp
     - 字符串：char、varchar、text

   - 问题4：什么是约束，常见的约束有哪些？

     - 约束：就是一种限制，限制了数据表中的列的值，保证数据的准确性和规范性，避免出现错误
     - 五大约束
     - 非空：not null：限定这一列的值不能为空，null
     - 默认：default：允许列存在默认值，如果这一列没有给值，就使用默认值
     - 唯一：unique：限定这一列的值不能重复
     - 主键：primary key：1、限定了这一列具有非空和唯一约束。2-构建主键索引，提高查询性能
       - 选择：非空且唯一，唯一标记这条数据，可以作为查询条件
       - 自增：auto_increment，自动增加这一列的值，必须是主键列，必须为int类型
     - 外键：不用记

   - 问题5：如何查看表的结构信息？

     - desc   数据库名称.表名;

   - 问题6：什么是相对路径，什么是绝对路径？

     - 绝对路径：从数据库开始逐级访问
     - 相对路径：相对当前所在位置进行访问

   - 问题7：如何实现表的删除和清空？

     - 删除：drop  table  if exists  数据库名称.表名;
     - 清空：truncate 数据库名称.表名;

   - 问题8：为什么清空表属于DDL？

     - 本质：先删除了表再创建了表

2. 表的DML

   - 目标：**掌握表的增删改的语法**
   - 问题1：如何实现表的数据插入？
     - 命令：insert
     - 方式一：insert  into 数据库名称.表名 [(列名)]   value/values  (v1, v2……)，（v1, v2……）；多行数据插入
     - 方式二：insert  into 数据库名称.表名  set  col1 = value1, col2 = value2 …… ；单行数据插入
     - 方式三：insert  into  数据库名称.表名  select ……；保存分析结果
   - 问题2：如何实现表的数据删除？
     - 命令：delete
     - 语法；delete  from  数据库名称.表名 【where  条件】
   - 问题3：如何实现表的数据更新？
     - 命令：update
     - 语法：update  数据库名称.表名  set  col1 = value1, col2= value2 …… 【where 条件】



# ==【模块一：MySQL 表的DDL】==

## 知识点03：【掌握】数据表的列举

- **目标**：**掌握数据表的列举**

- **实施**

  - **问题**：如何查看当前数据库中有哪些表？

  - **理解**：类似于查看电脑中某个目录下有哪些文件

  - **功能**：列举当前数据库或者某个数据库中有哪些表

  - **语法**：SHOW  TABLES

    ```sql
    SHOW TABLES [ IN db_name] ;
    ```

  - **示例**

    ```sql
    -- 创建一个数据库 db_test_bigdata01
    CREATE DATABASE IF NOT EXISTS db_test_bigdata01;
    
    -- 列举当前有哪些数据库
    SHOW DATABASES ;
    
    -- 切换到 db_test_bigdata01数据库中
    USE db_test_bigdata01;
    
    -- 列举当前数据库中有哪些表
    SHOW  TABLES;
    ```

    ![image-20230329213622737](Day02：MySQL中的DDL与DML.assets/image-20230329213622737.png)

    ```sql
    -- 列举mysql这个数据库中有哪些数据表
    SHOW TABLES IN mysql;
    ```

    ![image-20230329214019073](Day02：MySQL中的DDL与DML.assets/image-20230329214019073.png)

- **小结**：掌握数据表的列举



## 知识点04：【掌握】数据表的创建语法

- **目标**：**掌握数据表的创建语法**

- **实施**

  - **问题**：怎么在数据库中创建一张数据表？

  - **理解**：类似于在Excel文件中创建一个表格：行、列

  - **功能**：在某个数据库中创建一张数据表

  - **语法**

    ```sql
    -- 英文版
    CREATE TABLE [IF NOT EXISTS] [db_name.]tbl_name
    (
    	COL_NAME_1 DATA_TYPE [CONSTRAINT] [COl_COMMENT] ,
        COL_NAME_2 DATA_TYPE [CONSTRAINT] [COl_COMMENT] ,
        ……
        COL_NAME_N DATA_TYPE [CONSTRAINT] [COl_COMMENT]
    ) [TBL_OPTIONS] [TBL_COMMENT] 
    ;
    
    -- 中文版
    create table if not  exists 数据库名称.表名
    (
    	列名1		列的类型	[约束]	[列的注释] , -- 逗号表示没写完，还有下一行 
        列名2		列的类型	[约束]	[列的注释] ,
        列名3		列的类型	[约束]	[列的注释] ,
        列名4		列的类型	[约束]	[列的注释] ,
        列名5		列的类型	[约束]	[列的注释] ,
        ……
        列名N		列的类型	[约束]	[列的注释]		-- 最后一句话后面不能加逗号
    ) [表的配置：字符集、计算引擎] [表的注释]
    ;
    ```

    ![image-20230402144255739](Day02：MySQL中的DDL与DML.assets/image-20230402144255739.png)

  - **解释**

    - 必选

      ```properties
      COL_NAME: 列的名字，和数据库，表名都一样，不允许使用关键字，一般都是单词缩写
      DATA_TYPE: 数据类型，由于数据存储的目的是为了计算，所以为了方便计算，设计了不同类型：数值、日期、文本等
      ```

    - 可选

      ```properties
      CONSTRAINT: 约束，为了避免数据产生问题，导致处理异常或者结果不准确，可以约束限制列的内容
      COl_COMMENT: 列的注释，用于对列的功能进行说明
      TBL_OPTIONS: 表的配置，用于对表进行一些配置的设定，例如计算引擎、字符集等等
      TBL_COMMENT: 表的注释，用于对表的功能进行说明
      ```

  - **举例**：

    - **需求**：在 db_test_bigdata01 数据库中创建一张表  tb_student01 学生信息表

      - 用 stu_id 表示 学生的学号，例如：A1000096
      - 用 stu_name 表示学生的姓名，例如：周杰伦
      - 用 stu_birth 表示学生的生日，例如：2022-01-01
      - 用 stu_gender 表示学生的性别，0表示女性，1表示男性
      - 用 stu_stature 表示学生是身高，单位cm，例如：192
      - 用stu_city 表示学生的户籍，例如：江苏苏州

      ```sql
      -- 创建数据表
      CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_student01
      (
          stu_id      varchar(20),
          stu_name    varchar(30),
          stu_birth   date,
          stu_gender  int,
          stu_stature int,
          stu_city    varchar(10)
      );
      
      -- 插入两条测试数据
      INSERT INTO db_test_bigdata01.tb_student01
      VALUES ('A00001', '周杰伦', '2022-01-01', 1, 175, '中国台湾'),
             ('A00002', '蔡依林', '2022-01-02', 0, 160, '中国台湾');
      
      -- 查询所有数据
      SELECT * FROM db_test_bigdata01.tb_student01;
      ```

    - **问题**：如果我不是表的设计者，我怎么知道stu_gender性别这一列的0和1代表什么意思，我怎么知道stu_stature的单位是什么？我怎么知道这张表的功能？

    - **解决**：增加注释，标记每一列和表的功能

      ```SQL
      -- 创建表
      CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_student02
      (
          stu_id      varchar(20) COMMENT '学生id',
          stu_name    varchar(30) COMMENT '学生姓名',
          stu_birth   date COMMENT '出生日期',
          stu_gender  int COMMENT '性别, 0-女, 1-男',
          stu_stature int COMMENT '身高, 单位cm',
          stu_city    varchar(10) COMMENT '籍贯'
      ) ENGINE = InnoDB DEFAULT CHARSET = UTF8 COMMENT '学生基础信息表';
      
      -- 插入两条测试数据
      INSERT INTO db_test_bigdata01.tb_student02
      VALUES ('A00001', '周杰伦', '2022-01-01', 1, 175, '中国台湾'),
             ('A00002', '蔡依林', '2022-01-02', 0, 160, '中国台湾');
      
      -- 查询所有数据
      SELECT * FROM db_test_bigdata01.tb_student02;
      
      -- 查看表的结构信息
      SHOW FULL COLUMNS FROM db_test_bigdata01.tb_student02;
      
      -- 查看建表语句
      SHOW CREATE TABLE db_test_bigdata01.tb_student02;
      ```

- **小结**：数据表的创建语法是什么？

  ```mysql
  CREATE TABLE IF NOT EXISTS db_name.tb_name
  (
  	列名1		类型1		[约束]	[列的注释],
  	列名2		类型2		[约束]	[列的注释],
  	……
  	列名N		类型N		[约束]	[列的注释]
  ) [表的配置] [表的注释]
  ;
  ```



## 知识点05：【理解】数据列的字段类型

- **目标**：**理解数据列的字段类型**

- **实施**

  - **问题1**：我想计算所有学员穿了10cm的高跟鞋以后有多高，我想计算每个学员出生的年份是哪一年，怎么得到？

    - 解决1：通过函数可以直接计算

    ```SQL
    -- 每个人的身高 + 10cm , 获取每个人出生的年份
    SELECT
        stu_stature,
        stu_stature + 10 as stature_add,
        stu_birth,
        year(stu_birth) as birth_year
    FROM db_test_bigdata01.tb_student02 ;
    ```

    ![image-20230330204711371](Day02：MySQL中的DDL与DML.assets/image-20230330204711371.png)

  - **问题2**：计算机或者MySQL怎么知道年龄字段是一个数字，可以被加10，怎么知道出生日期是个时间可以获取年？

    - 解决2：我们在创建表的时候指定了每一列的值是什么类型

  - **功能**：限定了这一列的值的类型，方便计算机可以对不同类型的值进行不同的操作

  - **理解**：就像我们在电脑上，有不同的文件类型，有图片、视频、音乐，电脑怎么知道该用什么软件打开这个文件？

    - 电脑通过文件的后缀名来区分类型，不同类型的文件使用不同的软件打开进行操作处理

  - **常用**：文本【字符串，数据通过引号包裹】、数值【整数、浮点数】、时间【日期时间、时间戳】

    ![image-20230402155014099](Day02：MySQL中的DDL与DML.assets/image-20230402155014099.png)

    - 数值：bit(存0或1)、tinyint、int、bigint、decimal，double

      | 类型        | 介绍                                                         |
      | ----------- | ------------------------------------------------------------ |
      | bit         | 0 或者 1                                                     |
      | ==tinyint== | -128 ~ +127， 无符号只算正数：从0开始 到255                  |
      | ==int==     | -2147483648 ~ +2147483647                                    |
      | bigint      | -2^63 ~ + 2^63 - 1                                           |
      | ==double==  | double(M, D)，M总个数，D是小数位，双精度浮点型，16位精度，适合精确度一般的 |
      | ==decimal== | decimal（M， D）， M最大为65，D最大为30，定点数类型，适合精确度非常高的 |

    - 字符串：varchar，char，text

      | 类型        | 介绍                      |
      | ----------- | ------------------------- |
      | char        | 固定长度，最多255个字符   |
      | ==varchar== | 固定长度，最多65535个字符 |
      | text        | 可变长度，最多65535个字符 |

    - 日期时间：date， time， datetime

      | 类型                                            | 介绍                                           |
      | ----------------------------------------------- | ---------------------------------------------- |
      | **==date==**【年月日】                          | YYYY-MM-DD                                     |
      | ==datetime==【年月日 时分秒：标准日期时间格式】 | YYYY-MM-DD HH:mm:ss                            |
      | ==timestamp==                                   | 时间戳，从1970年1月1日00:00:00到目前为止的秒数 |

- **小结**：常见的字段类型有哪些？

  - 文本【字符串】：char、varchar、text
  - 数值【整数、浮点数】: bit、tinyint、int、bigint、double、decimal
  - 时间【日期、时间戳】：date、datetime、timestamp



## 知识点06：【掌握】数据列的约束规则：非空、默认

- **目标**：**掌握数据列的约束规则：非空和默认**

- **实施**

  - **问题**：什么是约束，非空约束是什么，默认约束是什么？

  - **需求**：在 db_test_bigdata01 数据库中创建一张学生信息表

    - 要求1：每个学生的籍贯必须填写，不允许留空 

    - 测试

      ```SQL
      -- 测试写入一条新的数据，但是不给籍贯
      INSERT INTO db_test_bigdata01.tb_student02(stu_id, stu_name, stu_birth, stu_gender, stu_stature)
      VALUES ('A00003', '陈升', '2022-01-03', 1, 170);
      
      -- 查询内容
      SELECT * FROM db_test_bigdata01.tb_student02;
      ```

    - 要求2：如果填写信息时，没有给定学生的性别，就默认为1

    - 测试

      ```sql
      -- 测试写入一条新的数据，但是不给性别
      INSERT INTO db_test_bigdata01.tb_student02(stu_id, stu_name, stu_birth, stu_stature, stu_city)
      VALUES ('A00004', '刘德华', '2022-01-04', 180, '中国香港');
      
      -- 查询内容
      SELECT * FROM db_test_bigdata01.tb_student02;
      ```

  - **解决**：MySQL等数据库允许用户在建表时，指定约束，限定列的值的内容

    ```sql
    -- 创建表
    CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_student03
    (
        stu_id      varchar(20) COMMENT '学生id',
        stu_name    varchar(30) COMMENT '学生姓名',
        stu_birth   date COMMENT '出生日期',
        stu_gender  int COMMENT '性别, 0-女, 1-男' DEFAULT 1,
        stu_stature int COMMENT '身高, 单位cm',
        stu_city    varchar(10) COMMENT '籍贯' NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = UTF8 COMMENT '学生基础信息表';
    
    -- 插入两条测试数据
    INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00001', '周杰伦', '2022-01-01', 1, 175, '中国台湾'),
           ('A00002', '蔡依林', '2022-01-02', 0, 160, '中国台湾');
    
    -- 测试写入一条新的数据，但是不给籍贯
    INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_gender, stu_stature)
    VALUES ('A00003', '陈升', '2022-01-03', 1, 170);
    
    -- 测试写入一条新的数据，给定籍贯，但是为null
    INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00003', '陈升', '2022-01-03', 1, 170, null);
    
    -- 测试写入一条新的数据，但是不给性别
    INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_stature, stu_city)
    VALUES ('A00004', '刘德华', '2022-01-04', 180, '中国香港');
    
    -- 查询内容
    SELECT * FROM db_test_bigdata01.tb_student03;
    ```

  - **约束**：**==为了避免数据异常，提高数据的准确性和高效性，数据库中允许用户通过约束来限定列值的内容==**

  - **常见**：五种

    - **主键 primary key**：物理上存储的顺序。 MySQL 建议所有表的主键字段都叫 id， 类型为 int unsigned。
    - **唯一 unique**：此字段的值不允许重复。
    - **非空 not null**：此字段不允许填写空值。**==NULL表示空==**，注意 null【没有值】  和   ‘null’ 【字符串】  是否一样？
    - **默认 default**：当不填写字段对应的值会使用默认值，如果填写时以填写为准。
    - **外键 foreign key**：对关系字段进行约束， 当为关系字段填写值时， 会到关联的表中查询此值是否存在， 如果存在则填写成功， 如果不存在则填写失败并抛出异常。

- **小结**：什么是约束，非空是什么，默认是什么？

  - 约束：为了避免数据异常，提高数据的准确性和高效性，数据库中允许用户通过约束限制列值的内容
  - 非空：约束了这一列的值不能为空NULL，这一列的每一行必须有值：not null
  - 默认：约束了这一列的值存在默认值，如果没有给定这一行的这一列的值，就使用默认值：default



## 知识点07：【掌握】数据列的约束规则：主键、唯一

- **目标**：**掌握数据列的约束规则：主键和唯一**

- **实施**

  - **需求**：在 db_test_bigdata01 数据库中创建一张学生信息表

    - 要求1：每个学生的id不能为空，不能重复，唯一标识一个学生 => 不同学生的id不能相同

    - 测试

      ```SQL
      -- 测试写入一条新的数据
      INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
      VALUES ('A00004', '刘德华', '2022-01-04', 1, 180, '中国香港');
      
      -- 查询内容
      SELECT * FROM db_test_bigdata01.tb_student03;
      ```

    - 要求2：每个学生的名字不能相同

    - 测试

      ```sql
      -- 测试写入一条新的数据
      INSERT INTO db_test_bigdata01.tb_student03(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
      VALUES ('A00005', '刘德华', '2022-01-04', 1, 180, '中国香港');
      
      -- 查询内容
      SELECT * FROM db_test_bigdata01.tb_student03;
      ```

  - **解决**

    ```sql
    -- 创建表
    CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_student04
    (
        stu_id      varchar(20) COMMENT '学生id' PRIMARY KEY ,
        stu_name    varchar(30) COMMENT '学生姓名' UNIQUE ,
        stu_birth   date COMMENT '出生日期',
        stu_gender  int COMMENT '性别, 0-女, 1-男' DEFAULT 1,
        stu_stature int COMMENT '身高, 单位cm',
        stu_city    varchar(10) COMMENT '籍贯' NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = UTF8 COMMENT '学生基础信息表';
    
    -- 插入两条测试数据
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00001', '周杰伦', '2022-01-01', 1, 175, '中国台湾'),
           ('A00002', '蔡依林', '2022-01-02', 0, 160, '中国台湾');
    
    -- 测试写入一条新的数据，但是不给籍贯
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature)
    VALUES ('A00003', '陈升', '2022-01-03', 1, 170);
    
    -- 测试写入一条新的数据，给定籍贯，但是为null
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00003', '陈升', '2022-01-03', 1, 170, null);
    
    -- 测试写入一条新的数据，但是不给性别
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_stature, stu_city)
    VALUES ('A00003', '刘德华', '2022-01-04', 180, '中国香港');
    
    -- 测试写入一条新的数据, id相同
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00003', '刘德华', '2022-01-04', 1, 180, '中国香港');
    
    -- 测试写入一条新的数据, id为null
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES (null, '刘德华', '2022-01-04', 1, 180, '中国香港');
    
    -- 测试写入一条新的数据, 名称相同
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00004', '刘德华', '2022-01-04', 1, 180, '中国香港');
    
    -- 测试写入一条新的数据, Id和名称不相同
    INSERT INTO db_test_bigdata01.tb_student04(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
    VALUES ('A00004', '马德华', '2022-01-04', 1, 180, '中国大陆');
    
    -- 查询内容
    SELECT * FROM db_test_bigdata01.tb_student04;
    ```

  - **唯一**：**unique**，用于约束数据表中的列值一定不相同，每个值都是唯一的，不存在重复的值

  - **主键**：**primary key**，**==用于唯一标识数据表中的一条数据==**，每条数据的主键一定不相同并且不为空，自带**非空**和**唯一**约束

    - 主键**==唯一标识表中的每一条数据==**，自带非空和唯一约束，构建索引，提高查询性能，工作中建议每张表都有主键

    - 一般选择符合这个条件的字段作为数据表的主键，例如：学生id、身份证号码等

    - 如果没有合适的字段，可以通过 ==**AUTO_INCREMENT**== 来构造自增的一列，**==必须为int类型==**

      ```sql
      /*
      	AUTO_INCREMENT: 自增，表示这一列的值从1开始自增，必须用于主键中
      					第一行为1，第二行为2，依此类推，必须为int类型
      					如果指定了值，下一行就从最大值后面继续编号
      */
      CREATE TABLE IF NOT EXISTS db_test_bigdata01.tb_student05
      (
          stu_id      int COMMENT '学生id' PRIMARY KEY AUTO_INCREMENT,
          stu_name    varchar(30) COMMENT '学生姓名' UNIQUE ,
          stu_birth   date COMMENT '出生日期',
          stu_gender  int COMMENT '性别, 0-女, 1-男' DEFAULT 1,
          stu_stature int COMMENT '身高, 单位cm',
          stu_city    varchar(10) COMMENT '籍贯' NOT NULL
      ) ENGINE = InnoDB DEFAULT CHARSET = UTF8 COMMENT '学生基础信息表';
      
      -- 插入两条测试数据，给定stu_id
      INSERT INTO db_test_bigdata01.tb_student05(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
      VALUES (1, '周杰伦', '2022-01-01', 1, 175, '中国台湾'),
             (2, '蔡依林', '2022-01-02', 0, 160, '中国台湾');
      
      -- 插入两条测试数据，不给定stu_id
      INSERT INTO db_test_bigdata01.tb_student05(stu_name, stu_birth, stu_gender, stu_stature, stu_city)
      VALUES ('马德华', '2022-01-04', 1, 180, '中国大陆');
      
      -- 插入两条测试数据，不给定stu_id
      INSERT INTO db_test_bigdata01.tb_student05(stu_id, stu_name, stu_birth, stu_gender, stu_stature, stu_city)
      VALUES (null, '刘德华', '2022-01-04', 1, 180, '中国大陆');
      ```

- **小结**：主键约束是什么，唯一约束是什么？

  - 主键：用于唯一标记表中的一行，自带非空和唯一约束，一般选择符合条件的列作为主键，如果没有合适的可以用自增：primary key
  - 唯一：用于限制这一列的值不重复，每一行的值都是唯一的：unique



## 知识点08：【掌握】数据表的描述、路径

- **目标**：**掌握数据表的描述、路径**

- **实施**

  - **问题1**：创建完表以后怎么查看表的一些字段信息？

  - **问题2**：怎么在当前数据库中访问另外一个数据库中的表？

  - **描述数据表**：describe / desc

    - 功能：用于查看表的结构信息，有哪些字段，哪些约束等等

    - 语法

      ```sql
      DESC [db_name.]tb_name ;
      ```

    - 示例

      ```sql
      -- 查看表的信息
      DESC tb_student05;
      ```

      ![image-20230403102101887](Day02：MySQL中的DDL与DML.assets/image-20230403102101887.png)

      ```sql
      -- 查看表的信息
      DESC db_test_bigdata01.tb_student05;
      ```

      ![image-20230330224353618](Day02：MySQL中的DDL与DML.assets/image-20230330224353618.png)

  - **访问数据表**

    - 方式一：**==相对路径【相对当前的位置进行访问】==**，切换到对应的数据库中，直接使用表名访问

      ```sql
      -- 读取mysql数据库中user表
      -- 先切换到mysql这个数据库中
      use mysql;
      -- 再通过表名查询
      select * from user;
      ```

    - 方式二：**==绝对路径【使用一个完整的位置路径进行访问】==**，直接使用完整的路径去访问，使用数据库名.表名的方式

      ```sql
      -- 读取mysql数据库中user表
      -- 直接使用绝对路径
      select * from mysql.user;
      ```

- **小结**：掌握数据表的描述、路径



## 知识点09：【掌握】数据表的删除、清空

- **目标**：**掌握数据表的删除和清空**

- **实施**

  - 问题：怎么删除数据表？怎么清空数据表？

  - **删除数据表**：DROP Table

    - 功能：删除数据库中的数据表

    - 语法

      ```SQL
      DROP TABLE [IF EXISTS] [db_name.]tbname ;
      ```

    - 示例

      ```sql
      -- 删除tb_student01
      DROP TABLE db_test_bigdata01.tb_student01;
      
      -- 删除tb_student02
      DROP TABLE IF EXISTS db_test_bigdata01.tb_student02;
      
      -- 列举表
      SHOW TABLES IN db_test_bigdata01;
      ```

  - **清空数据表**：TRUNCATE

    - 功能：用于清空整张表的数据

    - 问题：为什么TRUNCATE属于DDL？

      - 本质：清空的原理是把表的删了重新建
      - 注意：清空的时候如果有自增，自增重头开始

    - 语法

      ```sql
        TRUNCATE [db_name.]tbname
      ```

    - 示例

      ```sql
      -- 查询表数据
      SELECT * FROM db_test_bigdata01.tb_student03;
      
      -- 清空表数据
      TRUNCATE db_test_bigdata01.tb_student03;
      ```

- **小结**：掌握数据表的删除和清空



## 知识点10：【理解】数据表的修改

- **目标**：理解数据表的修改

- **实施**

  - **问题**：如果以后随着业务发展的需求，需要对数据表删除字段、添加字段，怎么办？

  - **场景**：工作中使用比较少，大数据平台中基本不用

  - **修改数据表**：ALTER

    - 功能：用于修改表的结构，字段、类型、约束等

    - 语法

      ```sql
      -- 添加
      ALTER  TABLE  表名  ADD  列名  类型(长度)  [约束];
      
      -- 修改
      ALTER TABLE 表名 CHANGE 旧列名 新列名 类型(长度) 约束;
      
      -- 删除
      ALTER TABLE 表名 DROP 列名;
      ```

    - 示例

      ```SQL
      -- 给 student04 增加一列 stu_weight 体重，单位KG
      ALTER TABLE db_test_bigdata01.tb_student04 ADD stu_weight double not null;
      
      -- 给 student04 的性别列修改为tinyint类型
      ALTER TABLE db_test_bigdata01.tb_student04 CHANGE stu_gender stu_gender tinyint(4);
      
      -- 删除 student04 的stu_weight 列
      ALTER TABLE db_test_bigdata01.tb_student04 DROP stu_weight;
      
      -- 查看结构
      DESC db_test_bigdata01.tb_student04;
      ```

- **小结**：理解数据表的修改



# ==【模块二：MySQL DML操作】==

## 知识点11：【掌握】插入数据insert：value方式

- **目标**：**掌握插入数据insert语法**

- **实施**

  - **问题**：MySQL的表已经创建好了，但是怎么将数据插入到MySQL的表中？

  - **解决**：insert

  - **功能**：指定每一行的每一列的数据值写入MySQL数据表中

  - **场景**：一般用于**==多条数据批量插入==** 

  - **语法**

    ```mysql
    INSERT INTO tbl_name[(列名)] VALUE  (单行数据的内容), (单行数据的内容) ……  ;
    
    或者
    
    INSERT INTO tbl_name[(列名)] VALUES (单行数据的内容), (单行数据的内容) …… ;
    ```

  - **示例**

    ```mysql
    -- 创建一张表 tb_student06
    DROP TABLE IF EXISTS db_test_bigdata01.tb_student06;
    CREATE TABLE `db_test_bigdata01`.`tb_student06` (
      `stu_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生id',
      `stu_name` varchar(30) DEFAULT NULL COMMENT '学生姓名',
      `stu_birth` date DEFAULT NULL COMMENT '出生日期',
      `stu_gender` int(11) DEFAULT '1' COMMENT '性别, 0-女, 1-男',
      PRIMARY KEY (`stu_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='学生基础信息表';
    
    -- 插入一条数据
    INSERT INTO db_test_bigdata01.tb_student06 (stu_id, stu_name, stu_birth, stu_gender)
    VALUE (1, '张三', '2023-04-01', 1) ;
    
    INSERT INTO db_test_bigdata01.tb_student06
    VALUE (null, '李四', '2023-04-02', 0) ;
    
    INSERT INTO db_test_bigdata01.tb_student06 (stu_name, stu_birth, stu_gender)
    VALUE ('王五', '2023-04-03', 0) ;
    
    -- 插入多条数据
    INSERT INTO db_test_bigdata01.tb_student06
    VALUE (null, '赵六', '2023-04-04', 1), (null, '田七', '2023-04-05', 0) ;
    
    -- 创建一张表 tb_student07
    DROP TABLE IF EXISTS db_test_bigdata01.tb_student07;
    CREATE TABLE `db_test_bigdata01`.`tb_student07` (
      `stu_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生id',
      `stu_name` varchar(30) DEFAULT NULL COMMENT '学生姓名',
      `stu_birth` date DEFAULT NULL COMMENT '出生日期',
      `stu_gender` int(11) DEFAULT '1' COMMENT '性别, 0-女, 1-男',
      PRIMARY KEY (`stu_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='学生基础信息表';
    
    -- 插入一条数据
    INSERT INTO db_test_bigdata01.tb_student07 (stu_id, stu_name, stu_birth, stu_gender)
    VALUES (1, '张三', '2023-04-01', 1) ;
    
    INSERT INTO db_test_bigdata01.tb_student07
    VALUES (null, '李四', '2023-04-02', 0) ;
    
    INSERT INTO db_test_bigdata01.tb_student07 (stu_name, stu_birth, stu_gender)
    VALUES ('王五', '2023-04-03', 0) ;
    
    -- 插入多条数据
    INSERT INTO db_test_bigdata01.tb_student07
    VALUES (null, '赵六', '2023-04-04', 1), (null, '田七', '2023-04-05', 0) ;
    ```

  - **注意**

    - 表名后的列名可以省略不写，但是values中的值必须与表中所有的字段顺序一致
    - 表名后的列名如果不省略，那么values后面的值只要与列名一一对应即可，可以不写所有的列名，没写的列为null

- **小结**：insert语句的values语法是什么？

  ```
  INSERT INTO [db_name.]tbname[(列名)] VALUES (每一列的值), (每一列的值)……
  ```

  

## 知识点12：【理解】插入数据insert：set方式

- **目标**：**理解插入数据insert的set方法**

- **实施**

  - **问题**：values一般用于多条数据的插入，单条数据插入效率相对差一些，那单条数据的插入怎么高效？

  - **功能**：指定写入一行数据的每一列的值

  - **场景**：适合于**==单条数据插入==**，应用场景较少

  - **语法**

    ```mysql
    INSERT INTO tb_name SET col_name1 = col_value1, col_name2 = col_value2……;
    ```

  - **示例**

    ```sql
    -- 创建一张表 tb_student08
    DROP TABLE IF EXISTS db_test_bigdata01.tb_student08;
    CREATE TABLE `db_test_bigdata01`.`tb_student08` (
      `stu_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生id',
      `stu_name` varchar(30) DEFAULT NULL COMMENT '学生姓名',
      `stu_birth` date DEFAULT NULL COMMENT '出生日期',
      `stu_gender` int(11) DEFAULT '1' COMMENT '性别, 0-女, 1-男',
      PRIMARY KEY (`stu_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='学生基础信息表';
    
    -- 插入数据
    INSERT INTO db_test_bigdata01.tb_student08
    SET stu_id = 1, stu_name = '张三', stu_birth = '2023-04-01', stu_gender = 0;
    
    INSERT INTO db_test_bigdata01.tb_student08
    SET stu_name = '李四', stu_birth = '2023-04-02', stu_gender = 1;
    
    INSERT INTO db_test_bigdata01.tb_student08
    SET stu_name = '王五';
    ```

- **小结**：理解插入数据insert的set方法



## 知识点13：【掌握】插入数据insert：select方式

- **目标**：**掌握插入数据insert的select方式**

- **实施**

  - **问题**：每次统计分析的结果通过select查询都只是打印出来，我们怎么将结果保存到一张结果表中？

  - **功能**：将一条查询语句的结果保存写入一张表中

  - **场景**：**==保存统计分析的结果==**

  - **语法**

    ```mysql
    INSERT INTO tb_name SELECT ……
    ```

  - **示例**

    ```mysql
    -- 查询统计 tb_student07 每种性别的人数
    SELECT
           case when stu_gender = 1 then '男' else '女' end as gender,
           COUNT(1) AS stu_cnt
    FROM db_test_bigdata01.tb_student07
    GROUP BY stu_gender;
    
    -- 创建一张表 tb_result01
    DROP TABLE IF EXISTS db_test_bigdata01.tb_result01;
    CREATE TABLE `db_test_bigdata01`.`tb_result01`
    (
        `gender` varchar(11) COMMENT '性别, 0-女, 1-男',
        `stu_cnt`    int(11) COMMENT '人数'
    ) ENGINE = InnoDB
      DEFAULT CHARSET = utf8 COMMENT ='学生统计结果信息表';
    
    -- 保存结果
    INSERT INTO db_test_bigdata01.tb_result01
    SELECT
           case when stu_gender = 1 then '男' else '女' end as gender,
           COUNT(1) AS stu_cnt
    FROM db_test_bigdata01.tb_student07
    GROUP BY stu_gender;
    ```

- **小结**：insert语句的select方式的场景和语法是什么？

  - 场景：保存select语句的结果
  - 语法：insert into 表名 select ……



## 知识点14：【掌握】删除数据delete语法

- **目标**：**掌握删除数据delete语法**

- **实施**

  - **问题**：MySQL中的数据如何删除？

  - **功能**：根据条件删除数据表特定的行

  - **场景**：删除数据表中的数据

  - **语法**

    ```mysql
    DELETE FROM tbname [WHERE 条件]
    ```

  - **示例**

    ```MYSQL
    -- 删除 tb_student08 表中的所有数据
    DELETE FROM db_test_bigdata01.tb_student08 ;
    
    -- 删除 tb_student07 表中所有男性的数据
    DELETE FROM db_test_bigdata01.tb_student07 WHERE stu_gender = 1;
    ```

- **小结**：delete的语法是？

  - 语法：delete from db_name.tbname [where 过滤条件]



## 知识点15：【掌握】更新数据update语法

- **目标**：掌握更新数据update语法

- **实施**

  - **问题**：MySQL中的数据如果写错了，如何修改？

  - **功能**：根据条件修改数据表特定的列

  - **场景**：修改数据表中的数据

  - **语法**

    ```mysql
    UPDATE tb_name SET col1=value1, col2=value2, ... [WHERE 条件];
    ```

  - **示例**

    ```mysql
    -- 更新 tb_student06 表中所有人的生日为 9999-12-31, 名字都设置为 刘德华
    UPDATE tb_student06 SET stu_birth = '9999-12-31', stu_name = '刘德华' ;
    
    -- 更新 tb_student06 表中性别为 女性的人的生日为 0000-01-01
    UPDATE tb_student06 SET stu_birth = '0000-01-01' WHERE stu_gender = 0;
    ```

- **小结**：update的语法是？

  - 语法：UPDATE  dbname.tbname SET col = new_value, col = new_value 【where 条件】



## 知识点16：【理解】插入更新replace语法

- **目标**：**理解插入更新replace语法**

- **实施**

  - **问题**：如果有一张表拥有主键，我想写入一条学生的数据，但是我不知道这个学生的信息是否已经存在了，怎么办？

    ```mysql
    -- 建表
    DROP TABLE IF EXISTS db_test_bigdata01.tb_student09;
    CREATE TABLE `db_test_bigdata01`.`tb_student09`
    (
        `stu_id`     varchar(11)  COMMENT '学生id',
        `stu_name`   varchar(30)  COMMENT '学生姓名',
        `stu_birth`  date         COMMENT '出生日期',
        `stu_gender` int(11)      COMMENT '性别, 0-女, 1-男',
        PRIMARY KEY (`stu_id`)
    ) ENGINE = InnoDB
      DEFAULT CHARSET = utf8 COMMENT ='学生基础信息表';
    
    -- 插入测试数据
    INSERT INTO db_test_bigdata01.tb_student09
    VALUES ('A001', '张三', '2022-01-01', 1),
           ('A002', '李四', '2022-01-02', 0),
           ('A003', '王五', '2022-01-03', 1);
    ```

  - **现象**：前提我们不知道这个学员的信息是否存在，需求是如果存在就更新信息，如果不存在就插入信息

    - 用insert是否可以？

      ```MYSQL
      INSERT INTO db_test_bigdata01.tb_student09
      VALUES ('A002', '李四', '2022-01-02', 1);
      ```

    - 用update是否可以？

      ```MYSQL
      UPDATE  db_test_bigdata01.tb_student09
      SET stu_gender = 1 WHERE stu_id = 'A004';
      ```

  - **解决**：==replace，如果主键存在就更新，如果不存在就插入【别的数据库一般都叫upsert = update + insert】==

  - **语法**

    ```MYSQL
    REPLACE INTO tbl_name[(列名)] VALUES (单行数据的内容), (单行数据的内容) …… ;
    ```

  - **实现**

    ```mysql
    REPLACE INTO db_test_bigdata01.tb_student09
    VALUES ('A002', '李四', '2022-01-02', 1);
    
    REPLACE INTO db_test_bigdata01.tb_student09
    VALUES ('A004', '赵六', '2022-01-02', 1);
    ```

- **小结**：理解插入更新replace语法
