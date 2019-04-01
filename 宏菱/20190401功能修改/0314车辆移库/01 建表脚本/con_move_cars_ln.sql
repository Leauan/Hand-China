WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool con_move_cars_ln.log
prompt
prompt Creating table con_move_cars_ln
prompt ============================
prompt
whenever sqlerror continue
 drop sequence con_move_cars_ln_s;
 drop table con_move_cars_ln; 
whenever sqlerror exit failure rollback
-- Create table
create table con_move_cars_ln(
     line_id number,
     hd_id number,
     car_info_id number,
     contract_id number,
     before_id number,
     after_id number,
     early_redemp_payment number,
     redemp_payment number,
     move_date date,
     remove_date date,
     phone varchar2(30),
     history_id number,
     creation_date date ,
     created_by number ,
     last_update_date date ,
     last_updated_by number 
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table con_move_cars_ln
  add constraint con_move_cars_ln_pk primary key (line_id);
 
--create sequence
create sequence con_move_cars_ln_s;
--add comment 
comment on table con_move_cars_ln is '车辆移库行表';
comment on column con_move_cars_ln.car_info_id is 'CON车辆ID';
comment on column con_move_cars_ln.contract_id is '合同ID';
comment on column con_move_cars_ln.before_id is '移库前信息';
comment on column con_move_cars_ln.after_id is '移库后信息';
comment on column con_move_cars_ln.early_redemp_payment is '提前赎证款';
comment on column con_move_cars_ln.redemp_payment is '赎证款';
comment on column con_move_cars_ln.move_date is '移库日期';
comment on column con_move_cars_ln.remove_date is '预计送回日';
comment on column con_move_cars_ln.phone is '联系电话';
comment on column con_move_cars_ln.history_id is '历史备份合同id';

spool off

exit
