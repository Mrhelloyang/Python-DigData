-- 单分区表和多级分区表本质上没什么区别,只不过多级分区表多了几个分区字段而已
-- 一般情况下,多级分区表中,每一个分区字段是有相互依赖关系的额.
-- 1. 多级分区表的创建
/*
create [external] table 表名 (
    字段名1  字段类型,
    字段名2  字段类型,
    字段名3  字段类型,
    .....
)
partitioned by (一级分区字段 字段类型, 二级分区字段 字段类型, 三级分区字段 字段类型 .......)
row format delimited fields terminated by ',';
*/

create table bigdata_db.score_parts1
(
    name   string,
    course string,
    score  int
)
    partitioned by (dt string)
    row format delimited fields terminated by '\t';

-- 2. 查看多级分区表中的数据信息
desc formatted bigdata_db.score_parts;

-- 3. 向分区表中的指定分区内添加数据信息
-- 使用多级分区,会形成分区目录的嵌套, 一级分区中嵌套二级分区, 二级分区中嵌套三级分区以此类推
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (dt=2024-06-15);
-- 如果新分区内,一级分区名称一致,则放入同一个一级分区目录中
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (year = '2024', month = '05', day = '18');
-- 如果新分区内, 一级分区,二级分区名称均一致,则放入同一个二级分区目录中.
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (year = '2024', month = '05', day = '22');
show partitions  bigdata_db.score_parts1
-- 4. 查看分区表中的数据内容 ,查询结果一共有6列数据
select *
from
    bigdata_db.score_parts1;

select *
from
    bigdata_db.score_par;

-- 5. 查看当前分区表的分区有哪些?  上述代码中一共有三个分区
show partitions bigdata_db.score_parts;

-- 删除分区表:  和删除普通表没有区别
drop table bigdata_db.score_part;

-- 6. 多级分区表中, 如果想要提升查询效率,根据任意多个分区字段进行筛选都可以提高查询效率
select *
from
    bigdata_db.score_parts
where
    year = '2024';
select *
from
    bigdata_db.score_parts
where
      year = '2024'
  and month = '08';
select *
from
    bigdata_db.score_parts
where
      year = '2024'
  and month = '08'
  and day = '22';

-- 注意事项:
-- 1. 多级分区字段之间一般都会存在依赖关系,否则后期维护时,逻辑极其混乱  例如 :年月日  时分秒  省市区    公司 部门 小组
-- 2. 一般分区层级不超过3级, 否则会出现大量的小文件, hdfs不适合存储小文件, mr不适合计算小文件,所以尽量避免.


-- 单分区表和多级分区表本质上没什么区别,只不过多级分区表多了几个分区字段而已
-- 一般情况下,多级分区表中,每一个分区字段是有相互依赖关系的额.
-- 1. 多级分区表的创建
/*
create [external] table 表名 (
    字段名1  字段类型,
    字段名2  字段类型,
    字段名3  字段类型,
    .....
)
partitioned by (一级分区字段 字段类型, 二级分区字段 字段类型, 三级分区字段 字段类型 .......)
row format delimited fields terminated by ',';
*/
create database if not exists bigdata_db;
create table bigdata_db.score_parts
(
    name   string,
    course string,
    score  int
)
    partitioned by (year string, month string, day string)
    row format delimited fields terminated by '\t';

-- 2. 查看多级分区表中的数据信息
desc formatted bigdata_db.score_parts;
show partitions bigdata_db.score_parts;

-- 3. 向分区表中的指定分区内添加数据信息
-- 使用多级分区,会形成分区目录的嵌套, 一级分区中嵌套二级分区, 二级分区中嵌套三级分区以此类推
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (year = '2024', month = '04', day = '20');
-- 如果新分区内,一级分区名称一致,则放入同一个一级分区目录中
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (year = '2024', month = '05', day = '18');
-- 如果新分区内, 一级分区,二级分区名称均一致,则放入同一个二级分区目录中.
load data local inpath '/root/score.txt' into table bigdata_db.score_parts partition (year = '2024', month = '05', day = '22');

-- 4. 查看分区表中的数据内容 ,查询结果一共有6列数据
select *
from
    bigdata_db.score_parts;

-- 5. 查看当前分区表的分区有哪些?  上述代码中一共有三个分区
show partitions bigdata_db.score_parts;

-- 删除分区表:  和删除普通表没有区别
drop table bigdata_db.score_part;

-- 6. 多级分区表中, 如果想要提升查询效率,根据任意多个分区字段进行筛选都可以提高查询效率
select *
from
    bigdata_db.score_parts
where
    year = '2024';
select *
from
    bigdata_db.score_parts
where
      year = '2024'
  and month = '08';
select *
from
    bigdata_db.score_parts
where month = '05'




-- 注意事项:
-- 1. 多级分区字段之间一般都会存在依赖关系,否则后期维护时,逻辑极其混乱  例如 :年月日  时分秒  省市区    公司 部门 小组
-- 2. 一般分区层级不超过3级, 否则会出现大量的小文件, hdfs不适合存储小文件, mr不适合计算小文件,所以尽量避免.