
-- 1,王昭君,女,北京,20,1,340322199001247654
--  2,诸葛亮,男,上海,18,2,340322199002242354
--  3,张飞,男,南京,24,3,340322199003247654
--  4,白起,男,安徽,22,4,340322199005247654
--  5,大乔,女,天津,19,3,340322199004247654
--  6,孙尚香,女,河北,18,1,340322199006247654
--  7,百里玄策,男,山西,20,2,340322199006247654
--  8,小乔,女,河南,15,3,340322199006247654
--  9,百里守约,男,湖南,21,1,340322199006247654
--  10,妲己,女,广东,26,2,340322199607247654
--  11,李白,男,北京,30,4,340322199005267754
--  12,孙膑,男,新疆,26,3,340322199000297655

-- 创建数据库homework,并指定数据存放位置为`/tmp/homework`
create  database if not exists homework location '/tmp/homework';

-- 在homework下创建表student_base
create external table if not exists homework.student_base(
    studentNo int comment "学号"
    ,name string comment "姓名"
    ,sex string comment '性别',
    hometown string comment '家乡',
    age int  comment '年龄',
    class_id int comment '班级编号',
    card string comment '生份证号'
)
    row format delimited fields terminated by ',';

-- 创建分区表student_part表符合以下需求：
create table if not exists homework.student_part(
    studentNo int comment "学号"
    ,name string comment "姓名"
    ,sex string comment '性别',
    hometown string comment '家乡',
    age int  comment '年龄',
    class_id int comment '班级编号',
    card string comment '生份证号'
)
    partitioned by (year string,month string,day string)
    row format delimited fields terminated by ',';

-- 创建分桶表 student_bucket
create table if not exists homework.student_bucket(
    studentNo int comment "学号"
    ,name string comment "姓名"
    ,sex string comment '性别',
    hometown string comment '家乡',
    age int  comment '年龄',
    class_id int comment '班级编号',
    card string comment '生份证号'
)
    clustered by (studentNo) sorted by (age) into 3 buckets
    row format delimited fields terminated by ',';

-- 从本地导入数据
load data local inpath '/root/hive_data/student.txt' into table homework.student_base;
-- 外部表不能清空数据，truncate table homework.student_base;

-- 从hdfs导入数据
load data inpath '/tmp/homework/student.txt' into table homework.student_base;

--从node1的/root/hive_data/中导入数据到student_part表2023年10月1日分区
load data local inpath '/root/hive_data/student.txt' into table homework.student_part partition(year='2023',month='10',day='01');
-- 从hdfs中导入数据到student_part表2023年10月1日分区
load data  inpath '/tmp/homework/student.txt' into table homework.student_part partition(year='2023',month='11',day='02');


-- 查询student_base表中的所有数据,加载到student_bucket中
insert into homework.student_bucket select * from homework.student_base;

-- 查看元数据
desc formatted homework.student_base;
desc formatted homework.student_bucket;
desc formatted homework.student_part;

-- 查看数据库中的表名
show tables in homework;

-- 查询student_part表中的所有分区
show partitions homework.student_part;

-- 将sex字段修改为gender 数据类型为string
alter table homework.student_base change column sex gender string;
alter table homework.student_part change column sex gender string;
alter table homework.student_bucket change column sex gender string;

-- 给student_part 添加2024年01月01日分区
alter table homework.student_part add partition (year='2024',month='01',day='01');
show partitions homework.student_part;


-- 删除student_part 中的2024年01月01日分区
alter table homework.student_part drop partition (year='2024',month='01',day='01');
show partitions homework.student_part;

-- 修改分区字段，将student_part中2023年10月01日分区改名为2023年10月03日分区
alter table homework.student_part  partition (year='2023',month='10',day='01') rename to  partition (year='2023',month='10',day='03');
show partitions homework.student_part;

-- 查询student_base表中所有学员信息
select *
from homework.student_base;

-- 查询student_base表中年龄大于20的学员信息
select *
from homework.student_base where age>20;

-- 查询student_base表中家乡为北京的所有学员的姓名和班级
select name
    ,student_base.class_id
from homework.student_base where hometown='北京';

-- 查询student_base表中各班级学生人数
select student_base.class_id
    ,count(1) as class_count
from homework.student_base group by class_id;



-- 查询student_base表中不属于安徽，河北的所有学员的信息
select *
from homework.student_base where hometown!='安徽'and hometown!="河北";


-- 查询student_base表中年龄最小的学生的全部信息
select * from  homework.student_base where age=(select min(age) from homework.student_base);

-- 查询student_bucket表中全部学生信息，按照学号分桶, 并按照学号桶内排序
set mapreduce.job.reduces=5;
select * from homework.student_bucket cluster by  studentNo;


-- 查询student_bucket表中全部学生信息, 按照学号分桶, 并按照年龄桶内排序
set mapreduce.job.reduces=3;
select * from homework.student_bucket distribute by studentNo sort by age;


--查询student_part表中2023年10月03日分区的所有学员信息
select * from homework.student_part where year='2023'and month='10'and day='03';


-- 22. 使用union联合查询,将student_part表中2023年10月03日分区中的所有男生信息和2023年11月02日分区中所有女生信息合并, 不去除重复数据.
select * from homework.student_part where year='2023'and month='10'and day='03'and gender='男'
union all
select * from homework.student_part where year='2023'and month='11'and day='02'and gender='女'

-- 23. 删除student_base表,观察hdfs中数据文件是否删除
drop table student_base;


-- 24. 删除student_bucket表,观察hdfs中数据文件是否被删除
drop table student_bucket;

-- 25. 删除homework数据库
drop database homework cascade;