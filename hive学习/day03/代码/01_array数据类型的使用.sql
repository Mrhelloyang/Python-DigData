-- 创建表
create table bigdata_db.test_array(
    name string,
    address array<string>
)
row format delimited fields terminated by'\t'
collection items terminated by ',';

-- 插入数据
load data local inpath '/root/hive_data/data_for_array_type.txt' into table bigdata_db.test_array;

-- 查看数据是否映射成功
    select * from bigdata_db.test_array;

-- 需求一：查看每个学员第一个进入的城市
select
    name
    ,address[0]as first_city
from bigdata_db.test_array;

-- 需求二：查看是否包含上海
select
    name
    ,array_contains(test_array.address,'shanghai') as is_shanghai
from bigdata_db.test_array;


-- 查看学员去过几个城市
select
    name
    ,size(address) as count_city
from bigdata_db.test_array;