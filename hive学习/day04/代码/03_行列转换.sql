-- 行转列
--建表
create table bigdata_db.row2col2
(
    col1 string,
    col2 string,
    col3 int
) row format delimited fields terminated by '\t';

-- 导入数据
-- 此处我们直接用web页面导入即可  --开发中不允许这样导入
load data local inpath'/root/r2c2.txt' into table bigdata_db.row2col2;
-- 查询数据
select *
from
    bigdata_db.row2col2;

select
    col1
    ,col2
    ,concat_ws('-',collect_list(cast(col3 as string))) as col3
from bigdata_db.row2col2
group by col1,col2;





-- 1. 将col1 和col2 进行合并转换成两行数据
select
    col1,
    col2
from
    bigdata_db.row2col2
group by
    col1, col2;

-- 2. 将col1 和col2处理完成后, 如果想获取col3 必须使用聚合函数, 将三个数据合并为一个字符串, 并且中间使用-作为分隔符
-- concat_ws ('-', 三个数据) 三个数据在三列中, 无法直接作为一个值插入, 所以我们需要使用聚合函数将三个数值变为一个数组
-- collect_list 可以将一列数据转换为一个数组, 数组中的元素数量就是这一类数据的行数
select
    col1,
    col2,
    collect_list(col3) as col3
from
    bigdata_db.row2col2
group by
    col1, col2;

-- Argument 2 of function CONCAT_WS must be "string or array<string>", but "array<int>" was found.
-- 如果我们想要使用concat_ws进行拼接, 则array类型数据的元素必须是字符串
select
    col1,
    col2,
    concat_ws('-', collect_list(col3)) as col3
from
    bigdata_db.row2col2
group by
    col1, col2;

-- 3. 为了能够进行拼接,必须进行数据类型转换
select
    col1,
    col2,
    concat_ws('-', collect_list(cast(col3 as string))) as col3
from
    bigdata_db.row2col2
group by
    col1, col2;


-- 列转行
--创建表
create table bigdata_db.col2row2
(
    col1 string,
    col2 string,
    col3 string
) row format delimited fields terminated by '\t';
-- 导入数据
-- 直接使用web导入 -- 开发中禁用
load data local inpath'/root/c2r2.txt' into table bigdata_db.row2col2;
-- 查看被导入的数据
select *
from
    bigdata_db.col2row2;
-- 行转列
with t1 as(select
    col1
    ,col2
    ,split(col3,',') col3
from bigdata_db.col2row2)
select
    col1
    ,col2
    ,t2.  int not null3
from t1 lateral view explode(col3) t2 as col3;



-- 1. 将字符串数据转换为数组类型数据
select
    col1,
    col2,
    split(col3, ',') as col3
from
    bigdata_db.col2row2;

-- 2. 使用炸裂函数+侧视图完成数据转换
with
    t1 as (select
               col1,
               col2,
               split(col3, ',') as col3
           from
               bigdata_db.col2row2)
select
    col1,
    col2,
    col_3
from
    t1 lateral view explode(col3) c as col_3;