-- 在hive中导入数据时, 使用insert方法导入数据效率最低.用的少
create database bigdata_db;
-- 0. 数据准备
CREATE TABLE bigdata_db.test_load
(
    dt      string comment '时间（时分秒）',
    user_id string comment '用户ID',
    word    string comment '搜索词',
    url     string comment '用户访问网址'
) comment '搜索引擎日志表' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- 1. insert into
-- 这种插入方式极其缓慢, 且资源占用量大.
insert into table
    bigdata_db.test_load
values
    ('2022-12-12 12:33:44', '001', '传智', 'www.itcast.cn');

-- 问: 如果插入20万条数据, 多长时间能接受呢?  2-3秒可以接受

-- 2. 数据文件可以直接在web页面上传,但是这种方式在开发中不能用, 因为我们没有权限
-- 通过web页面上传后, 如果数据文件的格式,与表的分隔符等相同,则可以映射成功
select * from bigdata_db.test_load;

-- 3. 可以通过终端, 使用hadoop fs -put 上传数据文件,到数据表目录中, 完成数据映射
select * from bigdata_db.test_load;
drop table bigdata_db.test_load;

-- 4. load data 方式进行数据文件的导入
-- 以上两种方式,虽然可以完成映射, 但是需要使用多个脚本完成数据导入和分析工作, 如果使用sql语句完成这件事,就可以放入一个脚本中实现了.
-- 格式: load data [local] in path '文件路径'  into  table 表名;
-- 添加local则从本地获取数据文件上传到hive表中, 此时的本地,说的是hiveserver2服务所在的服务器
load data local inpath '/root/search_log.txt'into table bigdata_db.test_load;
desc formatted bigdata_db.test_load;
load DATA LOCAL INPATH '/root/search_log.txt' OVERWRITE INTO TABLE bigdata_db.test_load;
-- 查看数据是否加载成功
select * from bigdata_db.test_load;

-- 思考: 如果使用4方法,就要将数据都存入node1, 此时node1存储上限就限制的数据导入量级上限, 所以我们最好将原始数据文件存在分布式存储系统中, 例如hdfs
-- 去掉local 则是从hdfs 中向hive表中导入数据
load data inpath '/user/hive_data/search_log.txt' into table bigdata_db.test_load;

-- No files matching path hdfs://node1.itcast.cn:8020/user/hive_data/search_log.txt
-- 再次执行该导入语句, 发现原始数据文件已经丢失
load data inpath '/user/hive_data/search_log.txt' into table bigdata_db.test_load;
LOAD DATA LOCAL INPATH '/tmp/search_log.txt' INTO TABLE bigdata_db.test_load;
-- 查看数据是否加载成功
select * from bigdata_db.test_load;


-- 使用local从本地加载文件到hive数据表中, 本地文件不丢失.
-- 如果不使用local则会将hdfs中原始文件移动到目标数据表目录中, 原始文件消失.

-- 不加 local的方式用的更多
-- 1. 本地一般不会大量存储原始数据, 一般会使用分布式方式存储.
-- 2. 不使用local的方式,可以有效防止数据重复导入.

-- 0. 复制一个test_load表的表结构, 为后续导入数据做准备
create table bigdata_db.test_load_copy like bigdata_db.test_load;

-- 验证其表结构是否符合要求
desc bigdata_db.test_load_copy;

-- 1. 查询数据结果,写入到刚刚创建好的数据表中
insert into bigdata_db.test_load_copy
    select * from bigdata_db.test_load;

-- 查询数据是否导入成功, 此时数据走mr任务,效率较低
select *
from
    bigdata_db.test_load_copy;

-- 2. 查询数据结构,覆盖到刚刚建好的数据表中
-- insert into 进行数据追加时,每次追加一个数据文件, 多个数据文件只要在同一个表目录中,就可以映射为同一个表数据.
insert overwrite table bigdata_db.test_load_copy
    select * from bigdata_db.test_load
    limit 3,2;

-- 查看数据是否覆盖成功
select * from bigdata_db.test_load_copy;

-- 思考:  先建表,再使用insert into select 更好 还是直接 create table as 更好呢??
-- create table as 一般用来存储临时表, 因为这种方式不能详细规定表的数据类型,以及注释和相关属性信息等.
-- 而 insert into select 先精细化建表,再插入数据,更适合长期数据存储.