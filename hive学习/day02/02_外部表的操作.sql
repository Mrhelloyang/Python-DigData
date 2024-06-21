-- 1. 创建一个外部表
-- 创建外部表,就是在内部表的基础上,增加一个external的修饰符
create external table bigdata_db.person_external(
    id int,
    name string,
    gender string
)row format delimited fields terminated by '\t';
-- 查看表的元数据信息
-- Table Type: EXTERNAL_TABLE
desc formatted person_external;

-- 2. 向外部表中插入数据
insert into person_external values
            (1,'小三','男'),
            (2,'小四','女'),
            (3,'小五','男');

-- 3. 清空数据记录, 外部表中的数据记录,不能使用truncate进行清空
-- Cannot truncate non-managed table bigdata_db.person_external.
-- truncate table bigdata_db.person_external;

-- 4. 删除外部表
-- 删除内部表时,数据记录和元数据同时被删除.
drop table bigdata_db.person_external;
-- show tables 查看外部表的元数据是否存在
show tables in bigdata_db;

-- 去hdfs中查看数据文件是否存在, hdfs中的数据文件依然存在
truncate table bigdata_db.person_external;
-- 结论:
-- 1. hive对于内部表中的数据与元数据具备操作权限, 删除表时,数据和元数据同时被删除
-- 2. hive对于外部表的元数据具备完全操作权限, 对于数据文件仅具备写入权限,不具备删除权限, 删除表时,元数据被清空,但数据文件依然存在.