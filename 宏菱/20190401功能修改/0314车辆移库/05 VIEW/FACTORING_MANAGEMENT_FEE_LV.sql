CREATE OR REPLACE VIEW FACTORING_MANAGEMENT_FEE_LV AS
Select t1."BP_ID_TENANT_NAME",
       t1."CONTRACT_ID",
       t1."CONTRACT_NUMBER",
       t1."BP_ID_TENANT",
       t1."CASHFLOW_ID",
       t1."CF_ITEM",
       t1."PROJECT_NUMBER",
       t1."PROJECT_NAME",
       t1."SUBMIT_DATE",
       t1."LEASE_START_DATE",
       t1."MODEL_CODE_NAME",
       t1."ITEM_FRAME_NUMBER",
       t1."RECEIVED_AMOUNT",
       t1."FEE_RATE",
       t1."LAST_RECEIVED_DATE",
       t1."DATE_FROM_FLAG",
       t1."VALID_DATE_FROM",
       t1."VALID_DATE_TO",
       t1."USE_DAYS",
       t1."DUE_AMOUNT",
       t1."FACTORING_RESIDUAL"
  From (Select 0 contract_id,
               Null contract_number,
               0 bp_id_tenant,
               Null bp_id_tenant_name,
               Null cashflow_id,
               Null cf_item,
               '总计' project_number,
               Null project_name,
               Null submit_date,
               Null lease_start_date,
               Null model_code_name,
               Null item_frame_number,
               Sum(tq.received_amount) received_amount,
               Null fee_rate,
               Null last_received_date,
               '20020715' date_from_flag,
               Null valid_date_from,
               Null valid_date_to,
               Null use_days,
               Sum(tq.due_amount) due_amount,
               Sum(tq.factoring_residual) factoring_residual
          From (Select c.contract_id,
                       c.contract_number,
                       c.bp_id_tenant,
                       (Select bp_name
                          From hls_bp_master
                         Where bp_id = c.bp_id_tenant) bp_id_tenant_name,
                       cc.cashflow_id,
                       cc.cf_item,
                       (Select p.project_number
                          From prj_project p
                         Where p.project_id = c.project_id) project_number, -- 申请编号
                       (Select p.project_name
                          From prj_project p
                         Where p.project_id = c.project_id) project_name, -- 申请名称
                       (Select p.submit_date
                          From prj_project p
                         Where p.project_id = c.project_id) submit_date, -- 申请日期
                       to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                               'yyyy-mm-dd') lease_start_date, -- 起息日
                       
                       (Select hb.description || hs.description ||
                               hm.description model_code_name
                        
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
                           And ht.type_code = ci.model_code
                           And rownum = 1) model_code_name, -- 车型
                       (Select cd.item_frame_number
                          From con_contract_df_car_info cd
                         Where cd.contract_id = c.contract_id) item_frame_number, -- VIN码
                       nvl(t.due_amount, 0) received_amount, -- 赎证金额
                       cr.fee_rate, -- 管理费率
                       t.last_received_date, -- 赎证日期
                       cr.valid_date_from, -- 起始日
                       nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
                       (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
                       cc.due_amount, -- 管理费
                       -- decode(nvl(t.received_amount, 0), 0, nvl(t.due_amount, 0), '') factoring_residual, -- 保理残值
                       -- 存在赎证日期 且小于等于计算期间 则保理残值取0
                       Case
                         When to_char(t.last_received_date, 'yyyymm') <=
                              to_char(cr.valid_date_from, 'yyyymm') Then
                          Null
                       -- 存在赎证日期 且大于计算期间 则保理残值取不为0
                         When to_char(t.last_received_date, 'yyyymm') >
                              to_char(cr.valid_date_from, 'yyyymm') Then
                          nvl(t.due_amount, 0)
                         Else
                          nvl(t.due_amount, 0)
                       End As factoring_residual
                  From con_contract c,
                       con_contract_cashflow cc,
                       con_df_manage_fee_rate cr,
                       (Select ccc.contract_id,
                               ccc.received_amount,
                               ccc.due_amount,
                               ccc.last_received_date
                          From con_contract_cashflow ccc
                         Where ccc.cf_item = 302
                           And ccc.cf_status = 'RELEASE') t,
                       con_contract_df_car_info ci
                 Where c.contract_id = cc.contract_id
                   And to_char(cc.due_date, 'yyyymm') =
                       to_char(cr.valid_date_from, 'yyyymm')
                   And c.contract_id = cr.contract_id
                   And c.contract_id = t.contract_id
                   And c.contract_id = ci.contract_id
                   And c.contract_status Not In ('CLOSED')
                   And c.data_class = 'NORMAL'
                   And c.lease_channel = '01'
                   And cc.cf_item = 301
                   And cc.cf_status = 'RELEASE') tq
        Union
        Select c.contract_id,
               c.contract_number,
               c.bp_id_tenant,
               (Select bp_name
                  From hls_bp_master
                 Where bp_id = c.bp_id_tenant) bp_id_tenant_name,
               cc.cashflow_id,
               cc.cf_item,
               (Select p.project_number
                  From prj_project p
                 Where p.project_id = c.project_id) project_number, -- 申请编号
               (Select p.project_name
                  From prj_project p
                 Where p.project_id = c.project_id) project_name, -- 申请名称
               (Select p.submit_date
                  From prj_project p
                 Where p.project_id = c.project_id) submit_date, -- 申请日期
               to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                       'yyyy-mm-dd') lease_start_date, -- 起息日
               
               (Select hb.description || hs.description || hm.description model_code_name
                
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
                   And ht.type_code = ci.model_code
                   And rownum = 1) model_code_name, -- 车型
               (Select cd.item_frame_number
                  From con_contract_df_car_info cd
                 Where cd.contract_id = c.contract_id) item_frame_number, -- VIN码
               nvl(t.due_amount, 0) received_amount, -- 赎证金额
               cr.fee_rate, -- 管理费率
               t.last_received_date, -- 赎证日期
               to_char(cc.due_date, 'yyyymmdd') date_from_flag,
               cr.valid_date_from, -- 起始日
               nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
               (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
               cc.due_amount, -- 管理费
               -- decode(nvl(t.received_amount, 0), 0, nvl(t.due_amount, 0), '') factoring_residual, -- 保理残值
               -- 存在赎证日期 且小于等于计算期间 则保理残值取0
               Case
                 When to_char(t.last_received_date, 'yyyymm') <=
                      to_char(cr.valid_date_from, 'yyyymm') Then
                  Null
               -- 存在赎证日期 且大于计算期间 则保理残值取不为0
                 When to_char(t.last_received_date, 'yyyymm') >
                      to_char(cr.valid_date_from, 'yyyymm') Then
                  nvl(t.due_amount, 0)
                 Else
                  nvl(t.due_amount, 0)
               End As factoring_residual
          From con_contract c,
               con_contract_cashflow cc,
               con_df_manage_fee_rate cr,
               (Select ccc.contract_id,
                       ccc.received_amount,
                       ccc.due_amount,
                       ccc.last_received_date
                  From con_contract_cashflow ccc
                 Where ccc.cf_item = 302
                   And ccc.cf_status = 'RELEASE') t,
               con_contract_df_car_info ci
         Where c.contract_id = cc.contract_id
           And to_char(cc.due_date, 'yyyymm') =
               to_char(cr.valid_date_from, 'yyyymm')
           And c.contract_id = cr.contract_id
           And c.contract_id = t.contract_id
           And c.contract_id = ci.contract_id
           And c.contract_status Not In ('CLOSED')
           And c.data_class = 'NORMAL'
           And c.lease_channel = '01'
           And cc.cf_item = 301
           And cc.cf_status = 'RELEASE'
        Union
        Select -1 contract_id,
               Null contract_number,
               te.bp_id_tenant,
               te.bp_id_tenant_name,
               Null cashflow_id,
               Null cf_item,
               '小计' project_number,
               Null project_name,
               Null submit_date,
               Null lease_start_date,
               Null model_code_name,
               Null item_frame_number,
               Sum(te.received_amount) received_amount,
               Null fee_rate,
               Null last_received_date,
               te.date_from_flag,
               Null valid_date_from,
               Null valid_date_to,
               Null use_days,
               Sum(te.due_amount) due_amount,
               Sum(te.factoring_residual) factoring_residual
          From (Select c.contract_id,
                       c.contract_number,
                       c.bp_id_tenant,
                       (Select bp_name
                          From hls_bp_master
                         Where bp_id = c.bp_id_tenant) bp_id_tenant_name,
                       cc.cashflow_id,
                       cc.cf_item,
                       (Select p.project_number
                          From prj_project p
                         Where p.project_id = c.project_id) project_number, -- 申请编号
                       (Select p.project_name
                          From prj_project p
                         Where p.project_id = c.project_id) project_name, -- 申请名称
                       (Select p.submit_date
                          From prj_project p
                         Where p.project_id = c.project_id) submit_date, -- 申请日期
                       to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                               'yyyy-mm-dd') lease_start_date, -- 起息日
                       (Select hb.description || hs.description ||
                               hm.description model_code_name
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
                           And ht.type_code = ci.model_code
                           And rownum = 1) model_code_name, -- 车型
                       (Select cd.item_frame_number
                          From con_contract_df_car_info cd
                         Where cd.contract_id = c.contract_id) item_frame_number, -- VIN码
                       nvl(t.due_amount, 0) received_amount, -- 赎证金额
                       cr.fee_rate, -- 管理费率
                       t.last_received_date, -- 赎证日期
                       to_char(cc.due_date, 'yyyymm') || '00' date_from_flag,
                       cr.valid_date_from, -- 起始日
                       nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
                       (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
                       cc.due_amount, -- 管理费
                       -- decode(nvl(t.received_amount, 0), 0, nvl(t.due_amount, 0), '') factoring_residual, -- 保理残值
                       -- 存在赎证日期 且小于等于计算期间 则保理残值取0
                       Case
                         When to_char(t.last_received_date, 'yyyymm') <=
                              to_char(cr.valid_date_from, 'yyyymm') Then
                          Null
                       -- 存在赎证日期 且大于计算期间 则保理残值取不为0
                         When to_char(t.last_received_date, 'yyyymm') >
                              to_char(cr.valid_date_from, 'yyyymm') Then
                          nvl(t.due_amount, 0)
                         Else
                          nvl(t.due_amount, 0)
                       End As factoring_residual
                  From con_contract c,
                       con_contract_cashflow cc,
                       con_df_manage_fee_rate cr,
                       (Select ccc.contract_id,
                               ccc.received_amount,
                               ccc.due_amount,
                               ccc.last_received_date
                          From con_contract_cashflow ccc
                         Where ccc.cf_item = 302
                           And ccc.cf_status = 'RELEASE') t,
                       con_contract_df_car_info ci
                 Where c.contract_id = cc.contract_id
                   And c.contract_id = cr.contract_id
                   And to_char(cc.due_date, 'yyyymm') =
                       to_char(cr.valid_date_from, 'yyyymm')
                   And c.contract_id = t.contract_id
                   And c.contract_id = ci.contract_id
                   And c.contract_status Not In ('CLOSED')
                   And c.data_class = 'NORMAL'
                   And c.lease_channel = '01'
                   And cc.cf_item = 301
                   And cc.cf_status = 'RELEASE'
                 Order By date_from_flag, cr.valid_date_from) te
         Group By te.bp_id_tenant, te.date_from_flag, te.bp_id_tenant_name
         Order By bp_id_tenant, date_from_flag, bp_id_tenant_name) t1;
