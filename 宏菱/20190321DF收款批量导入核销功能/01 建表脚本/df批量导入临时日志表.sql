create sequence csh_df_batch_temp_logs_s;
     
-- df����������ʱ��־��

WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR EXIT FAILURE ROLLBACK;
spool csh_df_batch_temp_logs.log
prompt
prompt Creating table csh_df_batch_temp_logs
prompt ===========================
prompt
whenever sqlerror continue
drop table csh_df_batch_temp_logs;
whenever sqlerror exit failure rollback

Create Table csh_df_batch_temp_logs
(
csh_df_batch_temp_logs_id Number Not Null,
batch_session_id Number Not Null,
transaction_date date,
transaction_amount number,
bank_serial_num varchar2(200),
bp_bank_account_num varchar2(200),
bp_bank_account_name varchar2(200),
bp_name varchar2(200),
fee_type varchar2(30),
guangsan_flag varchar2(30),
description Varchar2(4000),
lease_channel varchar2(30),
bank_account_num varchar2(200),
log_text varchar2(2000),
ref_v01 varchar2(2000),
ref_v02 varchar2(2000),
ref_v03 varchar2(2000),
ref_v04 varchar2(2000),
ref_v05 varchar2(2000),
ref_n01 number,
ref_n02 number,
ref_n03 number,
ref_n04 number,
ref_n05 number,
ref_d01 date,
ref_d02 date,
ref_d03 date,
ref_d04 date,
ref_d05 date,
CREATION_DATE DATE default sysdate not null,
CREATED_BY NUMBER default -1 not null,
LAST_UPDATED_BY NUMBER default -1 not null,
LAST_UPDATE_DATE DATE default sysdate not null
);
comment on table csh_df_batch_temp_logs is 'df�տ�����������ʱ��־��';
comment on column csh_df_batch_temp_logs.csh_df_batch_temp_logs_id is '����';
comment on column csh_df_batch_temp_logs.batch_session_id is 'SESSION';
comment on column csh_df_batch_temp_logs.transaction_date is '�տ�����';
comment on column csh_df_batch_temp_logs.transaction_amount is '�տ���';
comment on column csh_df_batch_temp_logs.bank_serial_num is '������ˮ��';
comment on column csh_df_batch_temp_logs.bp_bank_account_num is '�˺�(���)';
comment on column csh_df_batch_temp_logs.bp_bank_account_name is '�˻�����(���)';
comment on column csh_df_batch_temp_logs.bp_name is '��ҵ�������';
comment on column csh_df_batch_temp_logs.fee_type is '��������';
comment on column csh_df_batch_temp_logs.guangsan_flag is '�Ƿ��������';
comment on column csh_df_batch_temp_logs.description is 'ժҪ';
comment on column csh_df_batch_temp_logs.lease_channel is '��ҵģʽ';
comment on column csh_df_batch_temp_logs.bank_account_num is '�˺�(�տ�)';
comment on column csh_df_batch_temp_logs.log_text is '��־�ı�';
comment on column csh_df_batch_temp_logs.CREATION_DATE is '��������';
comment on column csh_df_batch_temp_logs.CREATED_BY is '������';
comment on column csh_df_batch_temp_logs.LAST_UPDATED_BY is '��������';
comment on column csh_df_batch_temp_logs.LAST_UPDATE_DATE is '��������';

alter table csh_df_batch_temp_logs
add constraint CSH_DF_BATCH_TEMP_LOGS_PK primary key (csh_df_batch_temp_logs_id);
spool off
exit