

-- 创建表
create table bigdata_db.test_map(
    id int
    ,name string
    ,members map<string,string>
    ,age int
)
    row format delimited fields terminated by ','
    collection items terminated by '#'
    map keys terminated by ':';

-- 导入数据
load data local inpath '/root/hive_data/data_for_map_type.txt' into table bigdata_db.test_map;

-- 查看数据
select
    *
from bigdata_db.test_map;


-- 5. map数据类型的使用
-- 需求1: 获取每一个学员的名称和其父亲的名称
select
    name
    ,members['father'] as father
from bigdata_db.test_map;

-- 需求2: 获取每个学员家里共有几口人
select
    name
    ,size(members)+1 as sum_people
from bigdata_db.test_map;
-- 需求3: 获取有哥哥的学员信息
select
    *
from bigdata_db.test_map
where array_contains(map_keys(members),'brother');