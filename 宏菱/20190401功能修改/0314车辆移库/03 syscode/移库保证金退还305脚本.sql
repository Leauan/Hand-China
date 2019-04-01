???prompt Importing table hls_cashflow_item...
set feedback off
set define off
insert into hls_cashflow_item (CF_ITEM, CF_TYPE, DESCRIPTION, CF_DIRECTION, RESERVED_FLAG, SYSTEM_FLAG, WRITE_OFF_ORDER, CALC_PENALTY, BILLING_DESC, ENABLED_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, REF_V01, REF_V02, REF_V03, REF_V04, REF_V05, REF_N01, REF_N02, REF_N03, REF_N04, REF_N05, REF_D01, REF_D02, REF_D03, REF_D04, REF_D05)
values (305, 300, '移库保证金退还', 'OUTFLOW', 'N', 'N', null, 'N', null, 'Y', 1, to_date('29-03-2019 10:08:05', 'dd-mm-yyyy hh24:mi:ss'), 1, to_date('29-03-2019 10:08:05', 'dd-mm-yyyy hh24:mi:ss'), null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);

prompt Done.
