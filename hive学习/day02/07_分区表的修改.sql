show partitions bigdata_db.score_parts;
-- 删除分区
alter table bigdata_db.score_parts drop partition (year='2024',month='05',day='22');
show partitions bigdata_db.score_parts;
-- 添加分区
alter table bigdata_db.score_parts add partition (year='2024',month='05',day='24');
show partitions bigdata_db.score_parts;

-- 修复分区，当元数据没用添加的分区时，会自动添加分区
msck repair table bigdata_db.score_parts sync partitions;
show partitions bigdata_db.score_parts;
select *    from bigdata_db.score_parts;
