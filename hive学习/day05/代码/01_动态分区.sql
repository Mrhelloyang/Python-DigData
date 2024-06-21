-- 需求: 创建一个分区表orders_part按照订单的创建日期进行分区, 相同创建日期的数据放入同一个分区表中

-- 1. 建表
-- 数据准备
CREATE TABLE bigdata_db.orders_part
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
)
    partitioned by (dt string comment '创建订单的日期')
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- 2. 将数据导入,并查询数据是否导入成功
-- 我们使用之前的数据加载方式(静态加载) 是无法实现根据某个字段的值进行分区的
-- load data local inpath '/root/hive_data/itheima_orders.txt' into table bigdata_db.orders_part partition ()

-- 如果想要根据数据的值不同进行分区,此时,我们要使用动态分区表数据加载方式
-- 动态分区表加载方式就是将数据先查询出来, 再写入分区表中, 这样的间接加载形式就是动态分区表加载

-- 在使用动态分区表加载方式之前必须开启动态分区非严格模式,否则无法使用


set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table
    bigdata_db.orders_part partition (dt)
select
    orders.orderid,
    orders.orderno,
    orders.shopid,
    orders.userid,
    orders.orderstatus,
    orders.goodsmoney,
    orders.delivermoney,
    orders.totalmoney,
    orders.realtotalmoney,
    orders.paytype,
    orders.ispay,
    orders.username,
    orders.useraddress,
    orders.userphone,
    orders.createtime,
    orders.paytime,
    orders.totalpayfee,
    date_format(createtime,'yyyy-MM-dd') as dt
from
    bigdata_db.orders;

truncate table bigdata_db.orders_part;



set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table
    bigdata_db.orders_part partition (dt)
select
    orderid,
    orderno,
    shopid,
    userid,
    orderstatus,
    goodsmoney,
    delivermoney,
    totalmoney,
    realtotalmoney,
    paytype,
    ispay,
    username,
    useraddress,
    userphone,
    createtime,
    paytime,
    totalpayfee,
    date_format(createtime, 'yyyy-MM-dd') as dt
from
    bigdata_db.orders;


-- 3. 查询动态分区表的数据是否加载成功, 分区是否创建完成
select * from bigdata_db.orders_part;

show partitions bigdata_db.orders_part;