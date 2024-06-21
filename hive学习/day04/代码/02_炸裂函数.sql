-- 炸裂函数: explode 这是一个典型的UDTF函数 (一进多出) 表生成函数, 将一个数值传入explode中,将会炸裂称为一个表.
-- 1. 使用炸裂函数将array类型数据炸裂为一个列 (列就是一个单列的表)
select explode(`array`(1, 2, 3, 4));
-- 可以给炸裂后的字段起别名 默认值就是col
select explode(`array`(1, 2, 3, 4)) as num1;

-- 2. 使用炸裂函数将map类型数据炸裂为一个表
-- 此时将会把map类型数据炸裂为2列的表, 一列为key 一列为value
select explode(`map`('name', '小明', 'gender', '男', 'school', '传智'));
-- 也可以给炸裂好的列起别名 使用 as (列1别名, 列2别名) 即可
select explode(`map`('name', '小明', 'gender', '男', 'school', '传智')) as (col_1, col_2);

-- 3. 炸裂函数和侧视图的使用案例

-- 准备数据
create table bigdata_db.the_nba_championship
(
    team_name     string,       -- 队名
    champion_year array<string> -- 夺冠年份
) row format delimited fields terminated by ','
    collection items terminated by '|';

-- 导入数据  直接通过web页面插入
load data local inpath '/root/The_NBA_Championship.txt' into table bigdata_db.the_nba_championship;
-- 查看数据是否导入成功
select *
from
    bigdata_db.the_nba_championship;

-- 需求: 让夺冠年份和队名意义匹配,且夺冠年份每一年都占用一行数据, 如果可以尽量按年份排序
-- 1) 先将夺冠年份使用炸裂函数 explode炸开, 得到一列数据, 每一个年份单独 占一行
with year_info as(select
    explode(champion_year) as year
from bigdata_db.the_nba_championship)
select
    year.year
    ,cs.team_name
from bigdata_db.the_nba_championship cs
    join year_info year on array_contains(cs.champion_year,year)
order by year.year;

-- 侧视图

select
    year
    ,team_name
from the_nba_championship cs lateral view explode(champion_year)t1 as year;
-- 2) 将年份与队名一一对应
-- 不能直接将teamname 放在select之后, 因为explode是一个表生成函数, team_name 输出的一个数据, 一个数据和一个表连接,不成立
-- 如果我们想让年份和队名一一对应, 应该进行表的连接
-- select
--     team_name,
--     explode(champion_year)
-- from
--     bigdata_db.the_nba_championship;

-- 方法1: 使用炸裂函数和原表进行连接(不用记)
with
    year_info as (select
                      explode(champion_year) as year
                  from
                      bigdata_db.the_nba_championship)
select
    cs.team_name,
    y.year
from
    bigdata_db.the_nba_championship cs
        join year_info y on array_contains(cs.champion_year, y.year) --判断数组中是否包含这个年份
order by
    y.year;


-- 方法2: 也可以使用侧视图, 将UDTF函数和原表数据进行连接.
-- 格式: select 列名...  from 原表 lateral view UDTF函数 别名;
select
    team_name,
    year
from
    bigdata_db.the_nba_championship lateral view explode(champion_year) t1 as year
order by year;

-- 侧视图效率更高,语法更加精简, 所以在开发中, 我们使用UDTF函数一般配合侧视图进行使用
-- 注意: 所有的UDTF函数都可以开启侧视图.

select '男\001女';