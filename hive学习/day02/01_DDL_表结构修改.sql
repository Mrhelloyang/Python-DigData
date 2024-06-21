-- 0.数据准备
create external table bigdata_db.person1(
    id int,
    name string,
    gender string
)row format delimited fields terminated by '\t';

-- 添加字段
alter table bigdata_db.person add columns(height double,weight decimal(27,2));
-- 查看表结构
desc formatted bigdata_db.person;

-- 1.添加一个字段
-- alter table bigdata_db.person add height double;  -- mysql语法不适用
alter table bigdata_db.person
    add columns (height double, weight decimal(27, 2));

-- 查看表结构
desc bigdata_db.person;

-- 2. 修改一个字段
-- 在hive中没有modify修改方式
alter table bigdata_db.person change sex gender string;

alter table bigdata_db.person
    change gender sex string;

-- hive中不能删除字段, 如果字段书写错误,可以修改或重建表.
-- alter table bigdata_db.person drop (sex) ;

-- 3. 修改表的名称
alter table bigdata_db.person
    rename to bigdata_db.person_info;
-- 查看bigdata数据库中所有的表名
show tables in bigdata_db;

-- 4. 清空表数据
-- 添加数据
insert into
    bigdata_db.person_info(id, name)
values
    (1, '易峰'),
    (2, '徐坤'),
    (3, '亦凡');
-- 清空数据
-- Attempt to do update or delete using transaction manager that does not support these operations.
-- delete from bigdata_db.person_info;   hive中 不支持 更新和删除操作
truncate table bigdata_db.person_info;
-- 可以清空数据(内部表可以清空，外部表不可以清空)

-- 5. 修改表的属性
alter table bigdata_db.person_info
    set tblproperties ('chuanzhi' = '1');
-- 对于同一个键重复赋值,则修改原来的值
alter table bigdata_db.person_info
    set tblproperties ('chuanzhi' = '666');
-- 对于不重复的键,在元数据中会新增一个键值对
alter table bigdata_db.person_info
    set tblproperties ('itheima' = '高薪就业');  -- 暂时元数据中不能出现中文, 后续项目阶段我们会处理该问题

-- 修改表的特定属性,可以进行一些设置操作,例如可以将内部表转换为外部表
-- table type =  EXTERNAL_TABLE
alter table bigdata_db.person1 set tblproperties ('EXTERNAL' = 'TRUE');

-- 查看表的元数据信息
describe formatted bigdata_db.person1;

-- 6. 修改表的存储位置 (几乎不用)
insert into
    bigdata_db.person_info(id, name)
values
    (1, '易峰'),
    (2, '徐坤'),
    (3, '亦凡');

select * from bigdata_db.person_info;

alter table bigdata_db.person_info set location '/user/hive_db';

-- 修改成功后,查询数据内容
-- 在hdfs中进行查询, 发现数据依然在原始位置, 修改的仅仅是这张表的元数据信息, 所以数据全部丢失.
select * from bigdata_db.person_info;

-- 修改表位置后,再次插入数据,此时将存在新位置处
insert into
    bigdata_db.person_info(id, name)
values
    (1, '易峰'),
    (2, '徐坤'),
    (3, '亦凡');

-- 7. 清空数据时,不能清空外部表中的数据
-- Cannot truncate non-managed table bigdata_db.person_info.
truncate table bigdata_db.person_info;

alter table bigdata_db.test_load
    add columns (age int,gender int);