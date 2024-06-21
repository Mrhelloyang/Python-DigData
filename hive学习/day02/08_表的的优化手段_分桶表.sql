
-- 创建分桶表
create table bigdata_db.score_buckets(
    name string,
    sourse string,
    score    int
)
    clustered by (sourse) into 3 buckets
    row format delimited fields terminated by '\t';

-- 导入数据，load data 在hive3.x中才能使用，一般不用
load data local inpath '/root/score.txt' into table bigdata_db.score_buckets;

create table bigdata_db.base
(
    name   string,
    course string,
    score  int
)
    row format delimited fields terminated by '\t';
load data local inpath '/root/score.txt' into table bigdata_db.base;
-- 间接导入数据
insert overwrite table bigdata_db.score_buckets  select * from bigdata_db.base;