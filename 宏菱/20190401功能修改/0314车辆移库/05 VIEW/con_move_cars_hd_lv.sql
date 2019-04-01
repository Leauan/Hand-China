create or replace view con_move_cars_hd_lv as
Select hd.hd_id,
       hd.hd_number,
       hd.instance_id,
       (Select cl.bp_id
          From con_move_cars_ln_lv cl
         Where cl.hd_id = hd.hd_id
           And rownum = 1) As bp_id,
       (Select cl.bp_name
          From con_move_cars_ln_lv cl
         Where cl.hd_id = hd.hd_id
           And rownum = 1) As bp_name,
       (Select Count(1) From con_move_cars_ln Where hd_id = hd.hd_id) CARS_COUNT,
       (Select Sum(cl.REDEMP_PAYMENT)
          From con_move_cars_ln cl
         Where cl.hd_id = hd.hd_id) REDEMP_PAYMENT_SUM, -- 保理融资金额总额
       (Select Sum(EARLY_REDEMP_PAYMENT)
          From con_move_cars_ln
         Where hd_id = hd.hd_id) EARLY_REDEMP_PAYMENT_SUM, -- 移库保证金总额
       hd.status,
       (Select cv.code_value_name
          From sys_code_values_v cv
         Where cv.code = 'DF_MOVE_STATUS'
           And cv.code_enabled_flag = 'Y'
           And cv.code_value_enabled_flag = 'Y'
           And cv.code_value = hd.status) As status_n,
       hd.user_id,
       (Select s.description From sys_user s Where s.user_id = hd.user_id) user_id_n,
       hd.creation_date created_date,
       hd.NOTE
  From con_move_cars_hd hd;
