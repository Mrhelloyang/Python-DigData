-- 在创建hive表时,可以指定分桶的同时指定排序依据, 后续插入该分桶中的数据就会自动排序.
-- 由于增加了分桶和排序规则,每次插入数据都要验证其哈希值, 插入数据的效率会大大降低.

-- 1. 建表时增加分桶排序规则
/*
 create table 表名
(
    字段名称 字段类型,
    字段名称 字段类型,
 ....
)
    clustered by (分桶依据) sorted by (排序依据 排序规则[asc|desc]) into 桶数 buckets
    row format delimited fields terminated by '分隔符';
 */
create table bigdata_db.student_bucket_sorted
(
    id     int,
    name   string,
    gender string,
    age    int,
    class  string
)
    clustered by (id) sorted by (age desc) into 3 buckets
    row format delimited fields terminated by ',';


-- 直接导入数据
load data local inpath '/root/hive_data/students.txt' into table bigdata_db.student_bucket_sorted;
-- 2. 向分桶表中插入数据, 使用间接方式加载.
-- 创建普通表
create table bigdata_db.students
(
    id     int,
    name   string,
    gender string,
    age    int,
    class  string
)
    row format delimited fields terminated by ',';

-- 数据导入到普通表中
load data local inpath '/root/hive_data/students.txt' into table bigdata_db.students;

-- 检查数据是否映射成功
select *
from
    bigdata_db.students;

-- 间接导入到分桶排序表中
insert overwrite table
    bigdata_db.student_bucket_sorted
select *
from
    bigdata_db.students;

-- 3. 查看分桶排序表中的数据, 是否分桶完成并在桶内排序
select *
from
    bigdata_db.student_bucket_sorted;
-- 分桶排序任务已经完成, 但是数据插入效率较低

-- 4. 我们插入一部分新数据查看是否依然分桶排序  是滴
insert into
    bigdata_db.student_bucket_sorted
values
    (95023, '小华', '女', 33, 'CS');

-- 查看数据,验证是否分桶排序(以hive2.x为例)
-- 1) 插入数据后,分桶目录中依然是三个数据文件
select *
from
    bigdata_db.student_bucket_sorted;
-- 2) 向内部插入的数据也会分桶排序, 所以效率依然很低