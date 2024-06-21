# MySQL基础及环境配置

## 知识点01：课程目标

1. 整体目标

   - 8天课程：MYSQL【SQL语言】
   - 目标：熟悉的使用SQL解决实际数据开发过程中的需求：数据分析、数据处理
   - 注意：SQL是整个数据开发行业中必不可少

2. 软件环境的安装配置

   - **Resilio Sync**：将每天上课的资料同步到大家的电脑中【==注意：大家电脑上的接受文件夹不能改的，会被覆盖==】

   - **MYSQL**：实现数据存储和数据管理工具，类似于文件系统或者Excel工具
   - **DataGrip**：用于连接以及操作MySQL开发客户端软件
   - **Typora**：Markdown格式的笔记和作业的工具
   - notepad：理解为功能非常强大的记事本，Linux课程中写脚本代码使用
   - Xmind：思维导图工具，逻辑结构工具，方便记忆
   - Snipaste：截图软件

3. **==数据库的介绍及DataGrip的使用==**
   - 目标：掌握MySQL的基础以及学习DG软件工具的基本使用
   - 问题1：什么是MySQL，功能和应用场景是什么？
     - 本质：MySQL是一个RDBMS关系型数据库管理系统
     - 功能：能够实现大数据量的数据存储和管理，提供简单的查询语言对数据进行增删改查操作
     - 场景：所有需要数据存储的地方都会见到数据库，1-企业中的业务系统。2-大数据中存储分析结果
   - 问题2：大数据中什么地方要用到MySQL？
     - 存储统计分析的结果、存储一些关键性的数据
   - 问题3：针对工作来讲，学习MySQL重心是什么？
     - 1、掌握一门RDBMS工具的使用
     - 2、熟练掌握SQL开发语言的学习
   - 问题4：MySQL架构以及DataGrip是什么？
     - 架构：CS架构，客户端服务端模式
     - DataGrip：全功能和全场景的数据库连接客户端工具
   - 问题5：SQL语言是什么，分为几类？
     - 本质：就是一种编程语言
     - 功能：基于简单的代码实现对数据库中的数据进行增删改查的操作
     - 场景：结构化数据的查询分析和处理
     - 分类
       - DDL：数据定义语言：create、drop
       - DML：数据操作语言【数据的增删改】：insert、update、delete
       - DQL：数据查询语言【数据的查询】：select
       - DCL：数据控制语言
   - 问题6：SQL的开发规则是什么？
     - 规则
       - 每条SQL语句都是由多个关键词组成，关键词不能用于列名、表名和库名
       - 每个关键词之间必须包含空格，类似于英文的语句
       - 每个SQL语句都必须包含结束符，默认结束符为英文分号
     - 注释
       - 单行注释：# 或者 -- 
       - 段落注释/多行注释：/* */

4. 数据库的DDL管理

   - 目标：掌握数据库的DDL操作
   - 问题1：如何基于SQL实现数据库的创建、删除、切换、列举
     - 创建：create database  [if not exists]  dbname  [charset=‘utf8’]
     - 列举：show  databases;
     - 切换：use   dbname;
     - 删除：drop  database [if  exists]   dbname;



# ==【模块一：数据库基础】==

## 知识点02：【了解】数据存储管理工具

- **目标**：**了解数据存储管理工具**

- **实施**

  - **发展**
  
    - 早期存储：解决能够存储就可以了：文件系统
    - 中期存储：能够更方便实现数据管理：数据库管理系统：MySQL、Oracle、SQL Server
    - 现在存储：能够对大量数据进行存储、管理以及处理：数据仓库系统：Hive、Spark、Flink、Hbase
  
  - **需求**
    - 需求1：我有100篇怎么能吃饭住宿不花钱的技术文章想保存到电脑中？
    - 需求2：我想统计这100篇文章学完以后一共能判几天？
    - 需求3：我想统计这100篇文章中每个词出现的次数？
  
  - **文本文件**：记事本、notepad等文本管理工具
    
    ![image-20230327175737942](Day01：MySQL基础及环境配置.assets/image-20230327175737942.png)
    
  - **表格文件**：Excel等图表管理工具【1-支持的数据量太小、2-支持功能太少】
  
    ![image-20230327181332371](Day01：MySQL基础及环境配置.assets/image-20230327181332371.png)
  
  - **思考：第三个需求怎么解决？**
  
    - 需要一种功能非常强大的工具，能够实现数据的存储和数据的统计分析
  
- **小结**：了解数据存储管理工具



## 知识点03：【理解】数据库的介绍

- **目标**：**理解数据库的介绍**

- **实施**

  - **问题**：什么是数据库？

    <img src="Day01：MySQL基础及环境配置.assets/image-20230327202001880.png" alt="image-20230327202001880" style="zoom: 50%;" />

  - **申明**：数据库是口语上的说法，我们这里讲的数据库实际上叫做**==数据库管理系统DataBase Manage System【DBMS】==**

  - **定义**：数据库是一个长期存储在计算机内的、有组织的、可共享的、统一管理的大量数据的集合。

  - **理解**：数据库就是一个数据存储的软件，可以将数据存在数据库中，通过命令可以对数据库中的数据进行各种复杂的处理

  - **功能**：数据库可以实现GB级的数据存储，基于简单方便的查询方式【SQL】对数据提供各种复杂的读写操作

  - **特点**：相比较Excel而言

    - 支持的数据量更大：百万级别
    - 支持各种复杂的数据操作：分组、排序、各种复杂处理函数
    - 支持快速的数据读写：底层性能非常强大
    - 支持非常简单易用的开发接口SQL：实现复杂数据处理的时候可以通过类人类语言实现数据处理

  - **分类**

    - RDBMS【relation database manager system】：关系型数据库：Oracle、MySQL、SQL Server、PgSQL、DB2……【肯定都支持SQL】
      - 稳定、安全、大数据性能相对较差
    - NOSQL：非关系型数据库：Redis、MongoDB、Hbase、TiDB……【肯定都不支持SQL，但是一般有插件可以让它支持】
      - 大数据性能相对较好、稳定和安全相对较差

  - **场景**

    - RDBMS：业务系统存储：订单数据、用户数据、商品数据、支付数据、快递数据、配送数据【稳定、安全、性能慢】

      <img src="Day01：MySQL基础及环境配置.assets/image-20230327205246349.png" alt="image-20230327205246349" style="zoom:67%;" />

    - NoSQL：高并发高性能存储【性能快，稳定和安全性差】

      <img src="Day01：MySQL基础及环境配置.assets/image-20230327222155392.png" alt="image-20230327222155392" style="zoom: 67%;" />

    - **总的来说：任何一个需要存储数据的系统中都可以使用数据库来实现数据存储**

- **小结**：什么是数据库，为什么不使用Excel来存储数据并处理数据？

  - 数据库：类似于一个存储数据的软件，可以提供GB级的数据存储，并通过简单的代码实现非常复杂的数据处理
  - 特点：存储空间更大，支持处理功能更强大，读写速度更快
  - 学习：把它当做一个类似Excel软件来学习即可



## 知识点04：【掌握】数据库中概念

- **目标**：**掌握数据库的基本设计**

- **实施**

  - **==需求：公司的数据存储起来==**

    - 人事部门的数据.xlsx：sheet1：在职人员信息表，sheet2：离职人员信息表……
  - 财务部门的数据.xlsx
    
    - 业务部门的数据.xlsx
  - 客户服务的数据.xlsx
    - 产品部门的数据.xlsx
    - 解决问题1：不同部门的数据放在不同部门的Excel文件中
  - 解决问题2；每个文件都要存储多种数据，通过划分表格来实现
    
  - **方向**：

    - BI工程师：做报表的，从数据库中通过SQL查询或者分析做图表
    - 数据库工程师：写SQL开发代码实现数据处理和数据分析，对数据库原理要求高
    - ETL工程师：python、mysql、etl工具、BI工具
    - BI数据分析师：SQL、BI工具、运营决策支撑
    - 数据开发/数据仓库：大数据技术栈、数据库、数据仓库

  - **问题**：数据库中有哪些核心的概念，如何操作数据库？

    - 文件系统中的概念：目录、文件、行
    - Excel系统中的概念：文件、Sheet【表】、行、列

  - **概念**

    - **DataBase数据库**：数据库管理系统中对数据的第一级划分，可以将不同类别的数据划分到不同的数据库中，一个数据库管理系统中可以有多个数据库

      <img src="Day01：MySQL基础及环境配置.assets/image-20230327212115643.png" alt="image-20230327212115643" style="zoom: 67%;" />

    - **Table数据表**：数据库管理系统中对数据的第二级划分，在一个数据库中可以将不同的数据存储在不同的表中，一个数据库中可以包含多个数据表

      <img src="Day01：MySQL基础及环境配置.assets/image-20230327213001942.png" alt="image-20230327213001942" style="zoom:67%;" />

    - **Row数据行**：数据行表示数据表中的一行数据或者一条数据，数据表中可以有多行数据

    - **Column数据列**：数据列表示数据表中的一列数据，数据表中可以有多列数据【区别：每一列需要自己定义列名】

      <img src="Day01：MySQL基础及环境配置.assets/image-20230327214014067.png" alt="image-20230327214014067" style="zoom:67%;" />

  - **类比**：与Excel高度相似

    |   概念   |   Excel    |       DBMS       |
    | :------: | :--------: | :--------------: |
    |   软件   | Excel软件  | MySQL/Oracle/DB2 |
    | 一级划分 |  文件File  |  数据库DataBase  |
    | 二级划分 |  表Sheet   |     表Table      |
    |    行    | 行【数字】 |      行Row       |
    |    列    | 列【字母】 |     列Column     |

- **小结**：数据库中的对象有哪些？

  - database：数据库，不同业务的数据存储在不同的数据库中，财务数据库、人事数据库、销售数据库
  - table：数据表，同一个业务中不同的数据可以存储在不同的表中：收入表、支出表、纳税表
  - row：数据行，表示表中的一行数据，一张表中可以有多行数据
  - column：数据列，表示表中的一列数据，一张表可以有多列数据



# ==【模块二：MySQL基础及DataGrip的使用】==

## 知识点05：【掌握】MySQL的介绍

- **目标**：**掌握MySQL的介绍**

- **实施**

  - **问题**：MySQL是什么，有什么用，哪些场景下会用到MySQL？

  - **官网**：https://www.mysql.com/

    ![image-20230327222716032](Day01：MySQL基础及环境配置.assets/image-20230327222716032.png)

    ```
    MySQL, the most popular Open Source SQL database management system, is developed, distributed, and supported by Oracle Corporation.
    ```

  - **功能**：能够高效的实现数据存储，基于简单方便的查询方式对数据提供各种复杂的读写操作

  - **分类**：RDBMS【支持SQL】，关系型数据库管理系统

  - **特点**：开源、支持社区版、性能高、功能强大、支持事务、配置简单、使用方便 =》综合性非常好

  - **场景**

    - 业务系统：存储业务数据，例如用户数据、商品数据、订单数据、支付数据等各种公司业务中需要存储保留的数据
    - 大数据系统：存储统计分析的结果、存储核心的元数据 => 小数据量存储

  - **排名**

    <img src="Day01：MySQL基础及环境配置.assets/image-20230327222928986.png" alt="image-20230327222928986" style="zoom: 80%;" />

  - **学习目标**：掌握一款RDBMS数据库的使用，**==重点学习SQL结构化查询语言==**

- **小结**：MySQL是什么，主要用于哪些场景下，学习的目标是什么？

  - MySQL是一个数据库工具，提供大量的数据存储，基于简单代码实现复杂的数据处理
  - 场景：传统-业务数据库、大数据-存储结果
  - 目标：1-掌握一款RDBMS使用，2-熟练掌握SQL语法



## 知识点06：【理解】MySQL的基本架构

- **目标**：**理解MySQL的基本架构**

- **实施**

  - **问题**：要想使用MySQL，需要准备哪些东西？

  - **安装**：已经安装完成

  - **架构**：典型的CS架构：Client客户端、Server服务端模式

    ![image-20230331163611966](Day01：MySQL基础及环境配置.assets/image-20230331163611966.png)

    - Client：用于提交需求实现与服务端交互的组件
    - Server：接收客户端的请求，处理需求，并将结果返回给客户端

  - **MySQL服务端**

    ![image-20230331152414631](Day01：MySQL基础及环境配置.assets/image-20230331152414631.png)

  - **MySQL客户端**

    <img src="Day01：MySQL基础及环境配置.assets/image-20230328093641233.png" alt="image-20230328093641233" style="zoom: 67%;" />

    或者

    ![image-20230331164130783](Day01：MySQL基础及环境配置.assets/image-20230331164130783.png)

  - **MySQL用户登录**

    - 登陆：在cmd中执行命令：mysql -uroot -p

    <img src="Day01：MySQL基础及环境配置.assets/image-20230328093736720.png" alt="image-20230328093736720" style="zoom: 60%;" />

    - 退出：exit

      <img src="Day01：MySQL基础及环境配置.assets/image-20230328094227426.png" alt="image-20230328094227426" style="zoom:67%;" />

- **小结**：理解MySQL的基本架构



## 知识点07：【掌握】SQL的介绍和分类

- **目标**：**掌握SQL的介绍和分类**

- **实施**
  - **问题**：什么是SQL？

  - **定义**：Structured Query Language 结构化查询语言简称SQL，是一种专为**==数据统计分析==**而设计的编程语言

    <img src="Day01：MySQL基础及环境配置.assets/image-20230328095749718.png" alt="image-20230328095749718" style="zoom:50%;" />

  - **功能**：可以利用SQL对数据库中的对象【数据库Database、表Table】进行管理，对数据进行增删改查的操作

    <img src="Day01：MySQL基础及环境配置.assets/image-20230328095852662.png" alt="image-20230328095852662" style="zoom:50%;" />

  - ==**SQL命令分类**==：要背

    - DDL(Data Definition Language)：数据定义语言，对数据库和表的创建、删除等动作：create、drop
    - DML(Data Manipulation Language)：数据操作语言，对数据表中的数据进行增、删、改【写】：insert、update、delete
    - DQL(Data Query Language)：数据查询语言，对数据中的数据进行查询【读】：select
    - DCL(Data Control Language)：数据控制语言，用于对数据库中权限进行管理：grant、revoke

  - **特点**：

    - **通用性**：大多数据的数据库系统或者类数据库系统，都支持SQL，只是在不同工具之间有些许的语法差别

      <img src="Day01：MySQL基础及环境配置.assets/image-20230328095516593.png" alt="image-20230328095516593" style="zoom: 67%;" />

    - **简洁性**：语法非常简洁并接近自然语言，可以通过自然表达快速的学习并使用SQL实现数据的统计分析

      ![image-20230328101617469](Day01：MySQL基础及环境配置.assets/image-20230328101617469.png)

    - **功能性**：SQL在简洁的语法上还支持各种函数操作，可以实现对数据各种复杂的处理转换过程

      ![image-20230328101803100](Day01：MySQL基础及环境配置.assets/image-20230328101803100.png)

- **小结**：SQL是什么，分为哪几类？

  - 定义：结构化查询语言，用于实现读写数据库的操作
  - 分类
    - DDL：数据定义语言，对数据库和表进行创建、删除
    - DML：数据操作语言，对数据表的数据进行增删改
    - DQL：数据查询语言，对数据表的数据进行查询
    - DCL：数据控制语言，对数据库进行权限管理



## 知识点08：【掌握】SQL的基本规则

- **目标**：**掌握SQL的基本规则**

- **实施**

  - **问题**：SQL怎么用？

  - **规则**

    - 通过**==关键词==**根据需求组合成SQL语句：create、drop、show、insert、delete、update、select等

      ```
      select 1 from 2 where 3 group by 4 having 5 order by 6 limit 7
      ```

      - 注意：关键词的单词不要写错，顺序也不能乱，关键词不能作为库名、表名、列名

    - 每个关键词的语法之间必须使用**==空格==**隔开：select id, name from tb_user where id = 20 ;

      ```mysql
      # 错误的示例
      select1from2where3
      
      # 正确的
      select 1 from 2 where 3
      ```

    - 每条SQL语句结束，必须加上结束符，默认的SQL结束符为分号   **==；==**

      ```
      select 1 
      from 2 
      where 3
      group by 4;
      
      
      select 3 from 4 ; select 1 from 2;
      ```

  - **注释**

    - 作用：用于将代码的解释进行标记，便于自己或者别人理解或者防止遗忘

    - 单行注释：`# 注释内容 ` 或者 `-- 注释内容`，==注意："--"与注释内容要用空格隔开才会生效==

      ```
      # 这是一行注释
      -- 这是一行注释
      ```

      ![image-20230331170300276](Day01：MySQL基础及环境配置.assets/image-20230331170300276.png)

    - 多行注释：`/* 注释内容 */`

      ```
      /*
      	这里可以写多行注释
      	这里可以写多行注释
      */
      ```
      
      ![image-20230331170405642](Day01：MySQL基础及环境配置.assets/image-20230331170405642.png)

  - **示例**

    ```sql
    -- 我想列举一下当前有哪些数据库
    show databases;
    
    -- 我想创建一个数据库叫做db_bigdata01
    create database db_bigdata01;
    
    -- 我想使用这个db_bigdata01这个数据库
    use db_bigdata01;
    
    -- 我想查看这个数据库中有哪些表
    show tables;
    
    /*
    	现在我想创建一张用户表叫做tb_user
    	表里面有两列，分别是用户的名字和年龄
    */
    create table `tb_user` (
    	`name` varchar(100),
        `age` int
    );
    
    # 现在我想查询这张表的所有的数据
    select * from `tb_user`;
    
    # 现在我想往这里面写入几条数据
    insert into `tb_user` values ('laoda', 18), ('laoer', 20), ('laosan', 22), ('laosi', 24);
    
    # 现在我想查询年龄等于20岁的用户的姓名和年龄
    select `name`, `age` from `tb_user` where age = 20; 
    ```

- **小结**：SQL基本规则是什么，注释怎么写？

  - 规则
    - 1-根据需求使用关键词组合成SQL语句，关键词不能作为列名、表名和库名
    - 2-SQL关键词之间需要保留空格
    - 3-SQL语句使用分号表示结束
  - 注释
    - 单行：# 或者 -- 
    - 多行：/* */



## 知识点09：【掌握】DataGrip的介绍和工程管理

- **目标**：**掌握DataGrip的介绍和工程管理**

- **实施**
  - **问题**：MySQL自带的写代码的客户端太Low了【交互性不够友好】，我们在企业中用什么工具开发SQL？
  
  - **介绍**：https://www.jetbrains.com/zh-cn/datagrip/
  
    ![image-20230328110515463](Day01：MySQL基础及环境配置.assets/image-20230328110515463.png)
  
    ```
        DataGrip 是JetBrains公司开发的数据库管理客户端工具，是一个面向SQL开发人员的综合数据库IDE【集成开发环境】。它具有实用的功能，提供精心设计的现代界面，非常直观。使用这种直观的IDE管理多种类型的数据库，可以轻松编写SQL代码并提供各种有用的功能。
        类似的产品还有：Navicat、DBeaver、Workbench、SQLyog等
    ```
  
  - **特点**：支持数据库非常全面【Oracle、MySQL、Hive……】、功能非常强大【SQL编辑、代码提示、可视化查询、数据比较等】
  
  - **界面布局**
  
    <img src="Day01：MySQL基础及环境配置.assets/image-20230328112038916.png" alt="image-20230328112038916" style="zoom:67%;" />
  
  - **修改代码字体**：为了后期写代码方便，可以调整下代码的字体大小
  
    ![image-20230328112413158](Day01：MySQL基础及环境配置.assets/image-20230328112413158.png)
  
    ![image-20230328112520663](Day01：MySQL基础及环境配置.assets/image-20230328112520663.png)
  
  - **工程管理**
  
    - 新建工程
  
      ![image-20230328113421764](Day01：MySQL基础及环境配置.assets/image-20230328113421764.png)
  
      ![image-20230328114002470](Day01：MySQL基础及环境配置.assets/image-20230328114002470.png)
  
    - 关闭工程
  
      ![image-20230328114107188](Day01：MySQL基础及环境配置.assets/image-20230328114107188.png)
  
    - 切换工程
  
      ![image-20230328114046755](Day01：MySQL基础及环境配置.assets/image-20230328114046755.png)
  
    - 删除工程
  
      ![image-20230328114128044](Day01：MySQL基础及环境配置.assets/image-20230328114128044.png)
  
      ![image-20230328114151332](Day01：MySQL基础及环境配置.assets/image-20230328114151332.png)
  
- **小结**：掌握DataGrip的介绍和工程管理



## 知识点10：【掌握】DataGrip的连接和窗口管理

- **目标**：**掌握DataGrip的连接和窗口管理**

- **实施**

  - **问题**：DataGrip作为一个客户端工具，怎么连接MySQL等数据库写SQL？

  - **连接管理**

    - 新建连接

      ![image-20230328163415597](Day01：MySQL基础及环境配置.assets/image-20230328163415597.png)

    - 配置连接

      ![image-20230328163652633](Day01：MySQL基础及环境配置.assets/image-20230328163652633.png)

    - 驱动设置

      ![image-20230328163721585](Day01：MySQL基础及环境配置.assets/image-20230328163721585.png)

      ![image-20230328163832476](Day01：MySQL基础及环境配置.assets/image-20230328163832476.png)

      ![image-20230328163905372](Day01：MySQL基础及环境配置.assets/image-20230328163905372.png)

    - **==下载不成功，则手动添加驱动文件==**

      ![image-20230331172524295](Day01：MySQL基础及环境配置.assets/image-20230331172524295.png)

      ![image-20230331172541899](Day01：MySQL基础及环境配置.assets/image-20230331172541899.png)

      ![image-20230331172628244](Day01：MySQL基础及环境配置.assets/image-20230331172628244.png)

      ![image-20230331172700730](Day01：MySQL基础及环境配置.assets/image-20230331172700730.png)

      ![image-20230331172709339](Day01：MySQL基础及环境配置.assets/image-20230331172709339.png)

    - 测试保存

      ![image-20230328163937473](Day01：MySQL基础及环境配置.assets/image-20230328163937473.png)

      ![image-20230328163954467](Day01：MySQL基础及环境配置.assets/image-20230328163954467.png)

      ![image-20230328164122285](Day01：MySQL基础及环境配置.assets/image-20230328164122285.png)

    - **==注意如果连接错误，尝试在url后面加上以下内容==**

      ![image-20230331172749392](Day01：MySQL基础及环境配置.assets/image-20230331172749392.png)

      ```
      ?useSSL=false&serverTimezone=UTC&characterEncoding=utf-8&autoReconnect=true
      ```

      ![image-20230331172812964](Day01：MySQL基础及环境配置.assets/image-20230331172812964.png)

      ![image-20230331172835886](Day01：MySQL基础及环境配置.assets/image-20230331172835886.png)

    - 连接使用

      ![image-20230328164544405](Day01：MySQL基础及环境配置.assets/image-20230328164544405.png)

      ![image-20230328164657840](Day01：MySQL基础及环境配置.assets/image-20230328164657840.png)

      ![image-20230328164751517](Day01：MySQL基础及环境配置.assets/image-20230328164751517.png)

  - **窗口管理**

    - 默认窗口

      ![image-20230328165622776](Day01：MySQL基础及环境配置.assets/image-20230328165622776.png)

    - 新建窗口

      ![image-20230328165648454](Day01：MySQL基础及环境配置.assets/image-20230328165648454.png)

      ![image-20230328165736819](Day01：MySQL基础及环境配置.assets/image-20230328165736819.png)

    - 删除窗口

      ![image-20230328165800811](Day01：MySQL基础及环境配置.assets/image-20230328165800811.png)

      ![image-20230328165845717](Day01：MySQL基础及环境配置.assets/image-20230328165845717.png)

      ![image-20230328165905497](Day01：MySQL基础及环境配置.assets/image-20230328165905497.png)

  - **常用快捷键**

    - 运行代码：Ctrl + Enter

      ![image-20230328170411489](Day01：MySQL基础及环境配置.assets/image-20230328170411489.png)

    - 格式化代码：Ctrl + Alt + L

      ![image-20230328170607421](Day01：MySQL基础及环境配置.assets/image-20230328170607421.png)

- **小结**：掌握DataGrip的连接和窗口管理



# ==【模块三：MySQL 数据库的DDL管理】==

## 知识点11：【掌握】数据库的列举、创建

- **目标**：**掌握数据库的列举、创建**

- **实施**

  - **问题**：怎么在MySQL中查看有哪些数据库？怎么在MySQL中创建一个新的数据库？

  - 官网：www.mysql.com

  - 文档：https://dev.mysql.com/doc/refman/8.0/en/create-database.html

  - **列举数据库**：SHOW

    - 功能：用于列举当前数据库中有哪些数据库

    - 理解：类似于在电脑上查看有哪些文件

    - 语法

      ```mysql
      -- 以后见到中括号代表可选的，竖线都代表或者
      SHOW {DATABASES | SCHEMAS} ;
      ```

    - 注意：DATABASES是复数形式，要加s

    - 示例

      ```sql
      -- 显示当前所有的数据库
      SHOW DATABASES ;
      ```

      ![image-20230329154733260](Day01：MySQL基础及环境配置.assets/image-20230329154733260.png)

  - **创建数据库**：CREATE DATABASE

    - 功能：用于在MySQL中创建一个新的数据库

    - 理解：类似于在电脑上创建一个目录

    - 规范

      - 不建议使用关键词，参考附录一
      - 不建议使用数字开头，不建议使用中文
      - 取名要有含义，使用单词的缩写，用_拼接

    - 语法

      ```sql
      CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name [db_option];
      ```

    - 示例

      ```sql
      -- 创建一个数据库，名字叫做db_bigdata01
      CREATE DATABASE db_bigdata01;
      ```

      ![image-20230329180140886](Day01：MySQL基础及环境配置.assets/image-20230329180140886.png)

        ```SQL
        -- 为了避免数据库已经存在了，导致程序报错，一般会加上判断
      CREATE DATABASE IF NOT EXISTS db_bigdata01;
        ```

        ![image-20230329180351462](Day01：MySQL基础及环境配置.assets/image-20230329180351462.png)

        ![image-20230329180412154](Day01：MySQL基础及环境配置.assets/image-20230329180412154.png)

        ```sql
        -- 创建一个数据库 db_bigdata02 并配置数据库的字符集支持中文为utf8
        CREATE DATABASE IF NOT EXISTS db_bigdata02 CHARSET='utf8';
        ```

- **小结**：数据库的列举和创建的语法是什么？

  - 列举：show databases ；
  - 创建：create database [ if not exists ]  db_name [db_option] ；



## 知识点12：【掌握】数据库的切换、删除

- **目标**：**掌握数据库的切换、删除**

- **实施**

  - **问题**：多个数据库怎么切换，怎么删除数据库？

  - **切换数据库**：USE

    - 功能：实现在多个数据库之间的切换

    - 理解：类似于在电脑上切换不同的目录

    - 语法

      ```sql
      USE db_name ;
      ```

    - 示例

      ```mysql
      -- 切换到 db_bigdata01 数据库
      USE db_bigdata01 ;
      
      -- 切换到 mysql 数据库
      USE mysql ;
      ```

      ![image-20230329204400472](Day01：MySQL基础及环境配置.assets/image-20230329204400472.png)

  - **删除数据库**：DROP  database

    - 功能：实现数据库的删除

    - 理解：类似于在电脑上删除一个目录

    - 语法

      ```SQL
      DROP {DATABASE | SCHEMA} [IF EXISTS] db_name ;
      ```

    - 示例

      ```sql
      -- 删除数据库 db_bigdata01
      DROP DATABASE db_bigdata01;
      
      -- 列举所有数据库
      SHOW DATABASES ;
      
      -- 为了避免报错，可以先判断再删除
      DROP DATABASE IF EXISTS db_bigdata02;
      ```

- **小结**：掌握数据库的切换、删除





# 附录一：MySQL中常见关键词

关键词就是MySQL本身已经使用的单词作为命令或者语法

==**关键词不要作为数据库名、表名、列名！！！！！**==

==**关键词不要作为数据库名、表名、列名！！！！！**==

==**关键词不要作为数据库名、表名、列名！！！！！**==

| 关键词             | 关键词              | 关键词             |
| ------------------ | ------------------- | ------------------ |
| ADD                | ALL                 | ALTER              |
| ANALYZE            | AND                 | AS                 |
| ASC                | ASENSITIVE          | BEFORE             |
| BETWEEN            | BIGINT              | BINARY             |
| BLOB               | BOTH                | BY                 |
| CALL               | CASCADE             | CASE               |
| CHANGE             | CHAR                | CHARACTER          |
| CHECK              | COLLATE             | COLUMN             |
| CONDITION          | CONNECTION          | CONSTRAINT         |
| CONTINUE           | CONVERT             | CREATE             |
| CROSS              | CURRENT_DATE        | CURRENT_TIME       |
| CURRENT_TIMESTAMP  | CURRENT_USER        | CURSOR             |
| DATABASE           | DATABASES           | DAY_HOUR           |
| DAY_MICROSECOND    | DAY_MINUTE          | DAY_SECOND         |
| DEC                | DECIMAL             | DECLARE            |
| DEFAULT            | DELAYED             | DELETE             |
| DESC               | DESCRIBE            | DETERMINISTIC      |
| DISTINCT           | DISTINCTROW         | p                  |
| DOUBLE             | DROP                | DUAL               |
| EACH               | ELSE                | ELSEIF             |
| ENCLOSED           | ESCAPED             | EXISTS             |
| EXIT               | EXPLAIN             | FALSE              |
| FETCH              | FLOAT               | FLOAT4             |
| FLOAT8             | FOR                 | FORCE              |
| FOREIGN            | FROM                | FULLTEXT           |
| GOTO               | GRANT               | GROUP              |
| HAVING             | HIGH_PRIORITY       | HOUR_MICROSECOND   |
| HOUR_MINUTE        | HOUR_SECOND         | IF                 |
| IGNORE             | IN                  | INDEX              |
| INFILE             | INNER               | INOUT              |
| INSENSITIVE        | INSERT              | INT                |
| INT1               | INT2                | INT3               |
| INT4               | INT8                | INTEGER            |
| INTERVAL           | INTO                | IS                 |
| ITERATE            | JOIN                | KEY                |
| KEYS               | KILL                | LABEL              |
| LEADING            | LEAVE               | LEFT               |
| LIKE               | LIMIT               | LINEAR             |
| LINES              | LOAD                | LOCALTIME          |
| LOCALTIMESTAMP     | LOCK                | LONG               |
| LONGBLOB           | LONGTEXT            | LOOP               |
| LOW_PRIORITY       | MATCH               | MEDIUMBLOB         |
| MEDIUMINT          | MEDIUMTEXT          | MIDDLEINT          |
| MINUTE_MICROSECOND | MINUTE_SECOND       | MOD                |
| MODIFIES           | NATURAL             | NOT                |
| NO_WRITE_TO_BINLOG | NULL                | NUMERIC            |
| ON                 | OPTIMIZE            | OPTION             |
| OPTIONALLY         | OR                  | ORDER              |
| OUT                | OUTER               | OUTFILE            |
| PRECISION          | PRIMARY             | PROCEDURE          |
| PURGE              | RAID0               | RANGE              |
| READ               | READS               | REAL               |
| REFERENCES         | REGEXP              | RELEASE            |
| RENAME             | REPEAT              | REPLACE            |
| REQUIRE            | RESTRICT            | RETURN             |
| REVOKE             | RIGHT               | RLIKE              |
| SCHEMA             | SCHEMAS             | SECOND_MICROSECOND |
| SELECT             | SENSITIVE           | SEPARATOR          |
| SET                | SHOW                | SMALLINT           |
| SPATIAL            | SPECIFIC            | SQL                |
| SQLEXCEPTION       | SQLSTATE            | SQLWARNING         |
| SQL_BIG_RESULT     | SQL_CALC_FOUND_ROWS | SQL_SMALL_RESULT   |
| SSL                | STARTING            | STRAIGHT_JOIN      |
| TABLE              | TERMINATED          | THEN               |
| TINYBLOB           | TINYINT             | TINYTEXT           |
| TO                 | TRAILING            | TRIGGER            |
| TRUE               | UNDO                | UNION              |
| UNIQUE             | UNLOCK              | UNSIGNED           |
| UPDATE             | USAGE               | USE                |
| USING              | UTC_DATE            | UTC_TIME           |
| UTC_TIMESTAMP      | VALUES              | VARBINARY          |
| VARCHAR            | VARCHARACTER        | VARYING            |
| WHEN               | WHERE               | WHILE              |
| WITH               | WRITE               | X509               |
| XOR                | YEAR_MONTH          | ZEROFILL           |



# 附录二：作业提交

- 文件格式：pdf格式提交

- 文件名称：你的名字-作业01.pdf

- 提交形式：单独私发给我

- 提交时间：第二天中午12点之前