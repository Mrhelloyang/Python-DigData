-- 创建一个普通表
create table bigdata_db.students
(
    id     int,
    name   string,
    gender string,
    age    int,
    class  string
)
    row format delimited
        fields terminated by ',';

-- 导入数据
load data local inpath '/root/hive_data/students.txt' into table bigdata_db.students;

-- 查询数据
select *
from
    bigdata_db.students;

-- 如果我们想要对于数据进行排序, 可以使用如下方案
-- 1. 数据全局排序, 使用order by
select *
from
    bigdata_db.students
order by
    age;

-- 2. cluster by分桶并进行数据的桶内排序
-- 此时如果想要按照桶内排序, 需要修改hive的配置参数, 否则分桶数量为1 与全局排序效率相当.
-- 如果想要设置分桶数量, 必须增加reduce任务数量
set mapreduce.job.reduces = 3; -- 将reduce任务数量修改为3

select *
from
    bigdata_db.students cluster by age;

-- 此时 分桶字段和排序字段为同一个字段, 且分桶排序规则为升序

-- 3. distribute by 分桶字段 sort by 排序字段 [asc | desc] ;
-- 此时我们可以根据不同的字段进行分桶和排序, 且可以指定排序规则为升序还是降序
-- 由于上边的代码中已经修改了reduce任务数量, 所以下边我们就不用重新修改了.
select
    *
from bigdata_db.students distribute by age sort by age;

select *
from
    bigdata_db.students distribute by id sort by age desc;

-- 注意: 仅仅分桶和排序字段完全相同, 且排序依据为升序时, cluster by === distribute by sort by

-- 为什么要在查询时分桶排序,不在建表时操作呢?
-- 建表时分桶字段一定是经常用于连接或查询的字段
-- 有些字段我们不经常连接,偶尔使用一次且想提高连接效率,则可以使用该方法
-- 分桶排序排序效率比全局排序效率高,所以我们使用分桶排序代替全局排序