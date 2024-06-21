-- 数据准备
CREATE TABLE bigdata_db.orders
(
    orderId        bigint COMMENT '订单id',
    orderNo        string COMMENT '订单编号',
    shopId         bigint COMMENT '门店id',
    userId         bigint COMMENT '用户id',
    orderStatus    tinyint COMMENT '订单状态 -3:用户拒收 -2:未付款的订单 -1：用户取消 0:待发货 1:配送中 2:用户确认收货',
    goodsMoney     double COMMENT '商品金额',
    deliverMoney   double COMMENT '运费',
    totalMoney     double COMMENT '订单金额（包括运费）',
    realTotalMoney double COMMENT '实际订单金额（折扣后金额）',
    payType        tinyint COMMENT '支付方式,0:未知;1:支付宝，2：微信;3、现金；4、其他',
    isPay          tinyint COMMENT '是否支付 0:未支付 1:已支付',
    userName       string COMMENT '收件人姓名',
    userAddress    string COMMENT '收件人地址',
    userPhone      string COMMENT '收件人电话',
    createTime     timestamp COMMENT '下单时间',
    payTime        timestamp COMMENT '支付时间',
    totalPayFee    int COMMENT '总支付金额'
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- 导入数据
LOAD DATA LOCAL INPATH '/root/hive_data/itheima_orders.txt' INTO TABLE bigdata_db.orders;
-- 查询全部数据
select *
from
    bigdata_db.orders;

-- 简单查询 (只能控制列数,不能控制行数)
select *
from
    bigdata_db.orders;

select
    orderno,
    totalmoney,
    useraddress,
    userid
from
    bigdata_db.orders;

select
    orderno,
    totalmoney + delivermoney,
    totalmoney * 0.85,
    '传智商城'
from
    bigdata_db.orders;

-- 条件查询
select *
from
    bigdata_db.orders
where
    totalmoney > 1000;

select *
from
    bigdata_db.orders
where
    totalmoney between 100 and 10000;

select *
from
    bigdata_db.orders
where
    paytype in (1, 3);

select *
from
    bigdata_db.orders
where
    userid is not null;

-- 聚合查询
select
    count(*)
from
    bigdata_db.orders;

-- 分组查询
-- 分组查询select 之后只能使用分区字段,聚合函数,或常数列,不能使用非分组字段
select
    paytype,
    count(1)
from
    bigdata_db.orders
group by
    paytype;

-- 排序查询
-- order by 是全局排序, 在开发中用的不多 ,  很多企业级开发服务上,禁止使用无where条件语句的order by
select *
from
    bigdata_db.orders
order by
    totalmoney;

-- 分页查询
select *
from
    bigdata_db.orders
limit 1, 2;

-- 子查询
-- 注意:
-- 1.子查询语句中,括号内的sql一定可以单独执行无bug ,否则写入父语句中一样会报错.
select *
from
    bigdata_db.orders
where
    totalmoney = (select min(totalmoney) from bigdata_db.orders);
-- 2.如果子查询语句作为数据表出现,必须有别名
select *
from
    (
        select *
        from bigdata_db.orders
        where paytype = 1
    ) t;

-- 3. 子查询作为值出现, 只能有一行一列,  作为列出现只能有一列,  作为表出现,必须有别名




-- 数据准备
CREATE TABLE bigdata_db.users
(
    userId         int,
    loginName      string,
    loginSecret    int,
    loginPwd       string,
    userSex        tinyint,
    userName       string,
    trueName       string,
    brithday       date,
    userPhoto      string,
    userQQ         string,
    userPhone      string,
    userScore      int,
    userTotalScore int,
    userFrom       tinyint,
    userMoney      double,
    lockMoney      double,
    createTime     timestamp,
    payPwd         string,
    rechargeMoney  double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- 插入数据
LOAD DATA LOCAL INPATH '/root/hive_data/itheima_users.txt' INTO TABLE bigdata_db.users;

-- 查询数据
select *
from
    bigdata_db.users
limit 20;

-- 分析一下: user表 和orders表可以进行连接, 连接规则是 orders.userID = users.userID

-- 1. 内连接: 左右两张表进行连接, 仅保留所有连接成功的数据内容
select *
from
    bigdata_db.orders o
        join bigdata_db.users u
                   on o.userid = u.userid;
-- 隐式内连: 知道的忘记他, hive中隐式内连效率极低

-- 2. 左连接: 左右两张表连接, 保留左表中全部的数据, 和右表中连接成功的数据内容
select *
from
    bigdata_db.orders o
        left join bigdata_db.users u
                        on o.userid = u.userid;

-- 3. 右连接: 左右两张表连接, 保留右表中全部的数据, 和左表中连接成功的数据内容
select *
from
    bigdata_db.orders o
        right join bigdata_db.users u
                         on o.userid = u.userid;
-- 注意: 左连接和右连接记住一种即可, 因为a表放在左侧左连接和a表放在右侧右连接数据结果完全相同.

-- 4. 全连接: 左右两张表连接, 保留左右两张表的全部数据, 连接成功则成功, 不成功补充null值.
select *
from
    bigdata_db.orders o
        full join bigdata_db.users u
                        on o.userid = u.userid;

-- 5. 左半链接 : 左右两张表进行内连接, 但是只返回左表中的全部信息, 右表中数据不返回.
-- 举例: 我要获取所有学员中毕业院校为真实国内院校的学员全部信息, 左表是学员表, 右表是国内的大学信息表
-- 此时我们用两张表左左半连接, 只返回匹配成功的学员信息, 速度更快,内存消耗更小.
select *
from
    bigdata_db.orders o
        left semi
        join bigdata_db.users u
             on o.userid = u.userid;

-- 注意事项: 没有右半链接

-- 6. 交叉链接(使用的很少): 其实交叉连接就是笛卡尔积
-- 交叉链接不需要链接条件, 如果书写链接条件则结果和内连接无异,但是性能消耗比内连接大很多, 和隐式内连相似.
select *
from
    bigdata_db.orders o
        join bigdata_db.users u;

-- 交叉链接在之前版本中用的还是很多的, 因为早期的hive版本中 连接条件只能使用简单连接条件, 例如 == !=
-- 所以如果要使用复杂连接条件就需要先交叉链接 再进行判断

-- 所有的连接方式中  outer和inner是可以被省略的