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
comment on table con_move_cars_ln is '�����ƿ��б�';
comment on column con_move_cars_ln.car_info_id is 'CON����ID';
comment on column con_move_cars_ln.contract_id is '��ͬID';
comment on column con_move_cars_ln.before_id is '�ƿ�ǰ��Ϣ';
comment on column con_move_cars_ln.after_id is '�ƿ����Ϣ';
comment on column con_move_cars_ln.early_redemp_payment is '��ǰ��֤��';
comment on column con_move_cars_ln.redemp_payment is '��֤��';
comment on column con_move_cars_ln.move_date is '�ƿ�����';
comment on column con_move_cars_ln.remove_date is 'Ԥ���ͻ���';
comment on column con_move_cars_ln.phone is '��ϵ�绰';
comment on column con_move_cars_ln.history_id is '��ʷ���ݺ�ͬid';

spool off

exit
