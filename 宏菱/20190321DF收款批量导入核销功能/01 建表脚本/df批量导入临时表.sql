create sequence csh_transaction_batch_temp_s;

--df����������ʱ��
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR EXIT FAILURE ROLLBACK;
spool csh_transaction_batch_temp.log
prompt
prompt Creating table csh_transaction_batch_temp
prompt ===========================
prompt
whenever sqlerror continue
drop table csh_transaction_batch_temp;
whenever sqlerror exit failure rollback

Create Table csh_transaction_batch_temp
(
csh_transaction_batch_temp_id Number Not Null,
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
comment on table csh_transaction_batch_temp is 'df�տ�����������ʱ��';
comment on column csh_transaction_batch_temp.csh_transaction_batch_temp_id is '����';
comment on column csh_transaction_batch_temp.batch_session_id is 'SESSION';
comment on column csh_transaction_batch_temp.transaction_date is '�տ�����';
comment on column csh_transaction_batch_temp.transaction_amount is '�տ���';
comment on column csh_transaction_batch_temp.bank_serial_num is '������ˮ��';
comment on column csh_transaction_batch_temp.bp_bank_account_num is '�˺�(���)';
comment on column csh_transaction_batch_temp.bp_bank_account_name is '�˻�����(���)';
comment on column csh_transaction_batch_temp.bp_name is '��ҵ�������';
comment on column csh_transaction_batch_temp.fee_type is '��������';
comment on column csh_transaction_batch_temp.guangsan_flag is '�Ƿ��������';
comment on column csh_transaction_batch_temp.description is 'ժҪ';
comment on column csh_transaction_batch_temp.lease_channel is '��ҵģʽ';
comment on column csh_transaction_batch_temp.bank_account_num is '�˺�(�տ�)';
comment on column csh_transaction_batch_temp.CREATION_DATE is '��������';
comment on column csh_transaction_batch_temp.CREATED_BY is '������';
comment on column csh_transaction_batch_temp.LAST_UPDATED_BY is '��������';
comment on column csh_transaction_batch_temp.LAST_UPDATE_DATE is '��������';

alter table csh_transaction_batch_temp
add constraint csh_transaction_batch_temp_PK primary key (csh_transaction_batch_temp_id);
spool off
exit