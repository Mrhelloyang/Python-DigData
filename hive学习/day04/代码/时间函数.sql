-- 时间类型函数,就是进行时间操控的函数, 在hive中对于数据类型要求不严格, 所以以时间格式进行 定义的字符串也可以作为时间类型数据使用
-- 标准时间格式字符串  'yyyy-MM-dd HH:mm:ss'   例如: "2024-04-23 09:57:22"

-- 1. 获取当前时间
-- 获取当前日期和时间
select current_timestamp();
-- 获取当前的日期
select current_date();

-- 2. 获取一部分日期元素
select year(current_timestamp()) ;-- 获取年
select month(current_timestamp());--- 获取月
select day(current_timestamp());-- 获取日
select hour(current_timestamp());-- 获取时
 select minute(current_timestamp());-- 获取分
 select quarter(current_timestamp());-- 获取秒
 select second(current_timestamp());-- 获取季度
select weekofyear(current_timestamp());-- 获取一年的第几周
 select dayofmonth(current_timestamp());-- 获取一周的第几天
-- 获取一个月的第几天

-- 3. 获取时间差: datediff 获取两个 时间间隔的天数
select datediff('1718797535', '1670886732');
-- 用前边的时间减去后边的时间

-- 4. 时间的增加和减少
-- date_add 就是在指定的时间上增加几天
select date_add(`current_date`(),-12);
-- date_sub 就是在指定的时间上减少几天


-- 其实我们记住上述两个函数其中之一就可以, 因为偏移天数可以使用负数


-- 在开发中如果想要偏移的数据单位不是天也可以直接加减



-- 5. 时间类型转换
-- 从时间类型数据转换为时间戳
-- 格式: unix_timestamp(时间类型数据或时间格式字符串, 格式化规则)
-- 时间戳:从1970年1月1日开始到现在的秒数或者毫秒数, 也有可能时纳秒数, 但是一定是数值类型数据.
select unix_timestamp(`current_date`());
-- 纯日期类型是可以转换成功的
-- 如果字符串是特殊格式日期, 需要指定字符串的转换规则

-- 1670886732

-- 将时间戳转换为时间格式数据
select from_unixtime(1670886732,"yyyy-MM+dd");
-- 2022-12-12 23:12:12
-- 可以在转换为时间的过程中添加格式化规则

-- 2022年12月12日 23点12分12秒


-- 6. 时间类型字符串的格式化方式
-- date_format(时间类型数据或字符串, 格式化规则)  输出的内容是一个字符串信息
select date_format('2022-12-12 23:12:12x',"yyyy-MM+dd");