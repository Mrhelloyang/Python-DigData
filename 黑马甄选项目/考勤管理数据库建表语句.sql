drop table if exists ods.ods_calendar_i;
CREATE TABLE ods.ods_calendar_i (
  `id` int COMMENT 'id',
  `datelist` date COMMENT '时间列表'
)COMMENT '日历'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');

drop table if exists ods.ods_class_studying_student_count_i;
CREATE TABLE ods.ods_class_studying_student_count_i (
  `id` int,
  `school_id` int COMMENT '校区id',
  `subject_id` int  COMMENT '学科id',
  `class_id` int COMMENT '班级id',
  `studying_student_count` int  COMMENT '在读班级人数',
  `studying_date` date COMMENT '在读日期'

)COMMENT '班级在读学生人数' row format delimited fields terminated by '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');

drop table if exists ods.ods_course_table_upload_detail_i;
CREATE TABLE ods.ods_course_table_upload_detail_i (
  id int COMMENT 'id',
  base_id int COMMENT '课程主表id',
  class_id int COMMENT '班级id',
  class_date date COMMENT '上课日期',
  content string  COMMENT '课程内容',
  teacher_id int  COMMENT '老师id',
  teacher_name string COMMENT '老师名字',
  job_number string COMMENT '工号',
  classroom_id int COMMENT '教室id',
  classroom_name string COMMENT '教室名称',
  is_outline int COMMENT '是否大纲 0 否 1 是',
  class_mode int COMMENT '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
  is_stage_exam int COMMENT '是否阶段考试（0：否 1：是）',
  is_pay int COMMENT '代课费（0：无 1：有）',
  tutor_teacher_id int COMMENT '晚自习辅导老师id',
  tutor_teacher_name string COMMENT '辅导老师姓名',
  tutor_job_number string COMMENT '晚自习辅导老师工号',
  is_subsidy int COMMENT '晚自习补贴（0：无 1：有）',
  answer_teacher_id int COMMENT '答疑老师id',
  answer_teacher_name string COMMENT '答疑老师姓名',
  answer_job_number string COMMENT '答疑老师工号',
  remark string  COMMENT '备注',
  create_time date COMMENT '创建时间'
)COMMENT '班级课表' row format delimited fields terminated by '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');


drop table if exists ods.ods_student_leave_apply_i;
CREATE TABLE ods.ods_student_leave_apply_i(
  `id` int,
  `class_id` int COMMENT '班级id',
  `student_id` int COMMENT '学员id',
  `audit_state` int COMMENT '审核状态 0 待审核 1 通过 2 不通过',
  `audit_person` int COMMENT '审核人',
  `audit_time` date COMMENT '审核时间',
  `audit_remark` string COMMENT '审核备注',
  `leave_type` int COMMENT '请假类型  1 请假 2 销假',
  `leave_reason` int COMMENT '请假原因  1 事假 2 病假',
  `begin_time` date COMMENT '请假开始时间',
  `begin_time_type` int COMMENT '1：上午 2：下午',
  `end_time` date COMMENT '请假结束时间',
  `end_time_type` int COMMENT '1：上午 2：下午',
  `days` float COMMENT '请假/已休天数',
  `cancel_state` int COMMENT '撤销状态  0 未撤销 1 已撤销',
  `cancel_time` date COMMENT '撤销时间',
  `old_leave_id` int COMMENT '原请假id，只有leave_type =2 销假的时候才有',
  `leave_remark` string COMMENT '请假/销假说明',
  `valid_state` int COMMENT '是否有效（0：无效 1：有效）',
  `create_time` date COMMENT '创建时间'
)COMMENT '学生请假申请表' row format delimited fields terminated by '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');

drop table if exists ods.ods_tbh_class_time_table_i;
CREATE TABLE ods.ods_tbh_class_time_table_i (
  id int COMMENT '主键id',
  class_id int COMMENT '班级id',
  morning_template_id int COMMENT '上午出勤模板id',
  morning_begin_time timestamp COMMENT '上午开始时间',
  morning_end_time timestamp COMMENT '上午结束时间',
  afternoon_template_id int COMMENT '下午出勤模板id',
  afternoon_begin_time timestamp COMMENT '下午开始时间',
  afternoon_end_time timestamp COMMENT '下午结束时间',
  evening_template_id int COMMENT '晚上出勤模板id',
  evening_begin_time timestamp COMMENT '晚上开始时间',
  evening_end_time timestamp COMMENT '晚上结束时间',
  use_begin_date date COMMENT '使用开始日期',
  use_end_date date COMMENT '使用结束日期',
  create_time date COMMENT '创建时间',
  create_person int COMMENT '创建人',
  remark string COMMENT '备注'
) COMMENT '班级作息时间表' row format delimited fields terminated by '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');


drop table if exists ods.ods_tbh_student_signin_record_i;
CREATE TABLE ods.ods_tbh_student_signin_record_i(
  id int COMMENT '主键id',
  normal_class_flag int COMMENT '是否正课 1 正课 2 自习',
  time_table_id int COMMENT '作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
  class_id int COMMENT '班级id',
  student_id int COMMENT '学员id',
  signin_time date COMMENT '签到时间',
  signin_date date COMMENT '签到日期',
  inner_flag int COMMENT '内外网标志  0 外网 1 内网',
  signin_type int COMMENT '签到类型 1 心跳打卡 2 老师补卡',
  share_state int COMMENT '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0 ',
  inner_ip string COMMENT '内网ip地址'
)COMMENT '学生打卡记录表' row format delimited fields terminated by '\t'
STORED AS orc
TBLPROPERTIES ('orc.compress'='ZLIB');
