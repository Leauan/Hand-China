create or replace view con_move_cars_ln_lv as
Select ln.line_id,
       ln.hd_id,
       ln.car_info_id,
       ln.contract_id,
       -- (Select h.bp_name From hls_bp_master h Where h.bp_id = cd.bp_id) As bp_name,
       cd.dealer_name As bp_name,
       (Select p.project_number
          From prj_project p
         Where p.project_id = cd.project_id) As project_number,
       ln.before_id,
       (Select inventory_name
          From inventory_info
         Where inventory_id = ln.before_id) before_id_n,
       ln.after_id,
       (Select inventory_name
          From inventory_info
         Where inventory_id = ln.after_id) after_id_n,
       cd.item_frame_number,
       cd.son_code,
       (Select contract_number
          From con_contract
         Where contract_id = ln.contract_id) contract_number,
       cd.bp_id,
       cd.MODEL_CODE,
       cd.ITEM_ENGINE_NUMBER,
       ln.EARLY_REDEMP_PAYMENT,
       ln.REDEMP_PAYMENT,
       ln.MOVE_DATE,
       ln.REMOVE_DATE,
       ln.PHONE,
       ln.deposit_flag,
       (Select cv.code_value_name
          From sys_code_values_v cv
         Where cv.code = 'YES_NO'
           And cv.code_enabled_flag = 'Y'
           And cv.code_value_enabled_flag = 'Y'
           And cv.code_value = ln.deposit_flag) As deposit_flag_n,
       ln.contact_person, 
       ln.is_moved_flag,
       (Select cv.code_value_name
          From sys_code_values_v cv
         Where cv.code = 'YES_NO'
           And cv.code_enabled_flag = 'Y'
           And cv.code_value_enabled_flag = 'Y'
           And cv.code_value = nvl(ln.is_moved_flag, 'N')) as is_moved_flag_n
  From con_move_cars_ln ln, con_contract_df_car_info cd
 Where ln.car_info_id = cd.car_info_id;
