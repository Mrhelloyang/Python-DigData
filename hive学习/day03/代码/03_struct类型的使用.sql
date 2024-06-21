
-- 创建表
create table test_struct(

    id int
    ,info struct<name:string,age:int>
)
    row format delimited fields terminated by'#'
    collection items terminated by ':';

-- 导入数据
load data local inpath '/root/hive_data/data_for_struct_type.txt' into table bigdata_db.test_struct;

select
    *
from bigdata_db.test_struct;