-- 数据导出,指的是从hive中将数据导出到指定位置(hive服务所在服务器, hdfs中)
-- 格式:  insert overwrite [local] directory '路径' select 列... from 表;

-- 1. 将数据从hive中导出到本地
-- 此处导出的路径必须是目录, 如果写文件名成,则会创建该文件名称的文件夹
-- 当重复向同一个目录中导入数据时,数据内容会被覆盖
insert overwrite local directory '/root/test_log'
select *
from
    bigdata_db.test_load;
-- 2. 将数据从hive中导出到hdfs
insert overwrite directory '/user/hive_data' select * from bigdata_db.test_load;
-- 3. 导出数据的同时指定分隔符


-- 4. 验证: 如果我们导出的位置不是目录,而是文件将会发生什么?
-- 如果该文件已经存在,则导出失败, 如果该文件不存在,则导出到指定文件名称的目录下.
