
alter table con_contract_df_car_info  add will_move_flag  VARCHAR2(1);

comment on column con_contract_df_car_info.will_move_flag is '���ﳵ��ʶ';con_contract_df_car_info_v

alter table hls_bp_master add transfer_margin_ratio number;

comment on column hls_bp_master.transfer_margin_ratio is '�ƿⱣ֤�����' ;hls_bp_master_lv

comment on column con_move_cars_ln.early_redemp_payment is '�ƿⱣ֤��';
comment on column con_move_cars_ln.redemp_payment is '�������ʶ�';

alter table con_move_cars_ln add deposit_flag varchar2(1);
comment on column con_move_cars_ln.deposit_flag is '�Ƿ���ȡ��֤��';

alter table con_move_cars_ln add contact_person varchar2(200);
comment on column con_move_cars_ln.contact_person is '��ϵ��';

alter table con_move_cars_ln add is_moved_flag varchar2(1);
comment on column con_move_cars_ln.is_moved_flag is '�Ƿ��ƹ���';


alter table con_move_cars_ln  add ref_v01  VARCHAR2(2000);
alter table con_move_cars_ln  add ref_v02  VARCHAR2(2000);
alter table con_move_cars_ln  add ref_v03  VARCHAR2(2000);
alter table con_move_cars_ln  add ref_v04  VARCHAR2(2000);
alter table con_move_cars_ln  add ref_v05  VARCHAR2(2000);
alter table con_move_cars_ln  add ref_n01  number;
alter table con_move_cars_ln  add ref_n02  number;
alter table con_move_cars_ln  add ref_n03  number;
alter table con_move_cars_ln  add ref_n04  number;
alter table con_move_cars_ln  add ref_n05  number;
alter table con_move_cars_ln  add ref_d01  date;
alter table con_move_cars_ln  add ref_d02  date;
alter table con_move_cars_ln  add ref_d03  date;
alter table con_move_cars_ln  add ref_d04  date;
alter table con_move_cars_ln  add ref_d05  date;
comment on column con_move_cars_ln.ref_n01 is '�����ֶ�';
