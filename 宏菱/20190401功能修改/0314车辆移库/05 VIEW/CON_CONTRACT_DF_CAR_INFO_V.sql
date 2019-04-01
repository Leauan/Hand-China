CREATE OR REPLACE VIEW CON_CONTRACT_DF_CAR_INFO_V AS
Select t.bp_id,
       t.project_id,
       t.car_info_id,
       t1.contract_number,
       t2.project_number,
       (Select hm.bp_code From hls_bp_master hm Where hm.bp_id = t.bp_id) bp_code,
       (Select hm.bp_name From hls_bp_master hm Where hm.bp_id = t.bp_id) bp_name,
       t.son_code,
       t.model_code,
       (Select hb.description || hs.description || hm.description
          From hls_car_brands_vl hb,
               hls_car_model_vl  hm,
               hls_car_series_vl hs,
               hls_car_type_vl   ht
         Where hm.brand_id = hb.brand_id
           And hm.series_id = hs.series_id
           And hm.model_id = ht.model_id
           And hb.enabled_flag = 'Y'
           And hm.enabled_flag = 'Y'
           And hs.enabled_flag = 'Y'
           And ht.enabled_flag = 'Y'
           And ht.type_code = t.model_code
           And rownum = 1) As model_code_name, --add by lara 11355 20190117 增加车型代码对应描述，未找到则显示为空
       t.color_code,
       t.finance_com_code,
       t.main_fac_num,
       t.item_frame_number,
       t.car_price,
       t.item_engine_number,
       t.qualified_number,
       t.sch_departure_date,
       t.expected_arrival_date,
       t.departure_date,
       t.confirm_result,
       t.finance_amount,
       -- round(t.finance_amount * nvl(t1.down_payment_ratio,0),2) down_payment,
       t.agent_inventory_id,
       (Select inventory_name
          From inventory_info
         Where inventory_id = t.agent_inventory_id) agent_inventory_id_n,
       t.regulator_inventory_id,
       (Select inventory_name
          From inventory_info
         Where inventory_id = t.regulator_inventory_id) regulator_inventory_id_n,
       t.car_status,
       (Select code_value_name
          From sys_code_values_v s
         Where s.code = 'KR_CAR_STATUS'
           And s.code_value = t.car_status) car_status_n,
       t.description,
       (Select s.user_id
          From sys_user s
         Where s.bp_id = t1.bp_id_tenant
           And S.BP_CATEGORY = 'AGENT_DF') owner_user_id,
       t1.contract_id,
       t1.bp_id_tenant, --addby wuts
       nvl(t.will_move_flag, 'N') as will_move_flag, --addby wuts
       t1.contract_status, -- add by CLiyuan
       (Select v.code_value_name
          From sys_code_values_v v
         Where v.code = 'CON660_CONTRACT_STATUS'
           And v.code_enabled_flag = 'Y'
           And v.code_value_enabled_flag = 'Y'
           And v.code_value = t1.contract_status) As contract_status_n
  From con_contract_df_car_info t, con_contract t1, prj_project t2
 Where t.contract_id = t1.contract_id
   And t1.project_id = t2.project_id
   And t1.data_class = 'NORMAL'
   And t1.lease_channel = '01';
