WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool con_move_cars_hd.log
prompt
prompt Creating table con_move_cars_hd
prompt ============================
prompt
whenever sqlerror continue
 drop sequence con_move_cars_hd_s;
 drop table con_move_cars_hd; 
whenever sqlerror exit failure rollback
-- Create table
create table con_move_cars_hd(
     hd_id number,
     hd_number varchar2(100),
     user_id number,
     status varchar2(30),
     instance_id number,
     note varchar2(2000),
     creation_date date ,
     created_by number ,
     last_update_date date ,
     last_updated_by number 
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table con_move_cars_hd
  add constraint con_move_cars_hd_pk primary key (hd_id);
 
--create sequence
create sequence con_move_cars_hd_s;
--add comment 
comment on table con_move_cars_hd is '车辆移库头表';
comment on column con_move_cars_hd.hd_number is '编号';
comment on column con_move_cars_hd.user_id is '创建人';
comment on column con_move_cars_hd.status is '审批状态';
comment on column con_move_cars_hd.instance_id is '工作流实例ID';
comment on column con_move_cars_hd.note is '备注';

spool off

exit
