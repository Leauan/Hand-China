CREATE OR REPLACE VIEW FACTORING_MANAGEMENT_FEE_LV AS
SELECT t1."BP_ID_TENANT_NAME",
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
  FROM (SELECT 0 contract_id,
               NULL contract_number,
               0 bp_id_tenant,
               NULL bp_id_tenant_name,
               NULL cashflow_id,
               NULL cf_item,
               '总计' project_number,
               NULL project_name,
               NULL submit_date,
               NULL lease_start_date,
               NULL model_code_name,
               NULL item_frame_number,
               SUM(tq.received_amount) received_amount,
               NULL fee_rate,
               NULL last_received_date,
               '20020715' date_from_flag,
               NULL valid_date_from,
               NULL valid_date_to,
               NULL use_days,
               SUM(tq.due_amount) due_amount,
               SUM(tq.factoring_residual) factoring_residual
          FROM (SELECT c.contract_id,
                       c.contract_number,
                       c.bp_id_tenant,
                       (SELECT bp_name
                          FROM hls_bp_master
                         WHERE bp_id = c.bp_id_tenant) bp_id_tenant_name,
                       cc.cashflow_id,
                       cc.cf_item,
                       (SELECT p.project_number
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) project_number, -- 申请编号
                       (SELECT p.project_name
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) project_name, -- 申请名称
                       (SELECT p.submit_date
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) submit_date, -- 申请日期
                       to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                               'yyyy-mm-dd') lease_start_date, -- 起息日
                       
                       (SELECT hb.description || hs.description ||
                               hm.description model_code_name
                        
                          FROM hls_car_brands_vl hb,
                               hls_car_model_vl  hm,
                               hls_car_series_vl hs,
                               hls_car_type_vl   ht
                         WHERE hm.brand_id = hb.brand_id
                           AND hm.series_id = hs.series_id
                           AND hm.model_id = ht.model_id
                           AND hb.enabled_flag = 'Y'
                           AND hm.enabled_flag = 'Y'
                           AND hs.enabled_flag = 'Y'
                           AND ht.enabled_flag = 'Y'
                           AND ht.type_code = ci.model_code
                           AND rownum = 1) model_code_name, -- 车型
                       (SELECT cd.item_frame_number
                          FROM con_contract_df_car_info cd
                         WHERE cd.contract_id = c.contract_id) item_frame_number, -- VIN码
                       nvl(t.due_amount, 0) received_amount, -- 赎证金额
                       cr.fee_rate, -- 管理费率
                       t.last_received_date, -- 赎证日期
                       cr.valid_date_from, -- 起始日
                       nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
                       (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
                       cc.due_amount, -- 管理费
                       decode(nvl(t.received_amount, 0),
                              0,
                              nvl(t.due_amount, 0),
                              '') factoring_residual -- 保理残值
                  FROM con_contract c,
                       con_contract_cashflow cc,
                       con_df_manage_fee_rate cr,
                       (SELECT ccc.contract_id,
                               ccc.received_amount,
                               ccc.due_amount,
                               ccc.last_received_date
                          FROM con_contract_cashflow ccc
                         WHERE ccc.cf_item = 302
                           AND ccc.cf_status = 'RELEASE') t,
                       con_contract_df_car_info ci
                 WHERE c.contract_id = cc.contract_id
                   AND to_char(cc.due_date, 'yyyymm') =
                       to_char(cr.valid_date_from, 'yyyymm')
                   AND c.contract_id = cr.contract_id
                   AND c.contract_id = t.contract_id
                   AND c.contract_id = ci.contract_id
                   AND c.contract_status NOT IN ('CLOSED')
                   AND c.data_class = 'NORMAL'
                   AND c.lease_channel = '01'
                   AND cc.cf_item = 301
                   AND cc.cf_status = 'RELEASE') tq
        UNION
        SELECT c.contract_id,
               c.contract_number,
               c.bp_id_tenant,
               (SELECT bp_name
                  FROM hls_bp_master
                 WHERE bp_id = c.bp_id_tenant) bp_id_tenant_name,
               cc.cashflow_id,
               cc.cf_item,
               (SELECT p.project_number
                  FROM prj_project p
                 WHERE p.project_id = c.project_id) project_number, -- 申请编号
               (SELECT p.project_name
                  FROM prj_project p
                 WHERE p.project_id = c.project_id) project_name, -- 申请名称
               (SELECT p.submit_date
                  FROM prj_project p
                 WHERE p.project_id = c.project_id) submit_date, -- 申请日期
               to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                       'yyyy-mm-dd') lease_start_date, -- 起息日
               
               (SELECT hb.description || hs.description || hm.description model_code_name
                
                  FROM hls_car_brands_vl hb,
                       hls_car_model_vl  hm,
                       hls_car_series_vl hs,
                       hls_car_type_vl   ht
                 WHERE hm.brand_id = hb.brand_id
                   AND hm.series_id = hs.series_id
                   AND hm.model_id = ht.model_id
                   AND hb.enabled_flag = 'Y'
                   AND hm.enabled_flag = 'Y'
                   AND hs.enabled_flag = 'Y'
                   AND ht.enabled_flag = 'Y'
                   AND ht.type_code = ci.model_code
                   AND rownum = 1) model_code_name, -- 车型
               (SELECT cd.item_frame_number
                  FROM con_contract_df_car_info cd
                 WHERE cd.contract_id = c.contract_id) item_frame_number, -- VIN码
               nvl(t.due_amount, 0) received_amount, -- 赎证金额
               cr.fee_rate, -- 管理费率
               t.last_received_date, -- 赎证日期
               to_char(cc.due_date, 'yyyymmdd') date_from_flag,
               cr.valid_date_from, -- 起始日
               nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
               (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
               cc.due_amount, -- 管理费
               decode(nvl(t.received_amount, 0), 0, nvl(t.due_amount, 0), '') factoring_residual -- 保理残值
          FROM con_contract c,
               con_contract_cashflow cc,
               con_df_manage_fee_rate cr,
               (SELECT ccc.contract_id,
                       ccc.received_amount,
                       ccc.due_amount,
                       ccc.last_received_date
                  FROM con_contract_cashflow ccc
                 WHERE ccc.cf_item = 302
                   AND ccc.cf_status = 'RELEASE') t,
               con_contract_df_car_info ci
         WHERE c.contract_id = cc.contract_id
           AND to_char(cc.due_date, 'yyyymm') =
               to_char(cr.valid_date_from, 'yyyymm')
           AND c.contract_id = cr.contract_id
           AND c.contract_id = t.contract_id
           AND c.contract_id = ci.contract_id
           AND c.contract_status NOT IN ('CLOSED')
           AND c.data_class = 'NORMAL'
           AND c.lease_channel = '01'
           AND cc.cf_item = 301
           AND cc.cf_status = 'RELEASE'
        UNION
        SELECT -1 contract_id,
               NULL contract_number,
               te.bp_id_tenant,
               te.bp_id_tenant_name,
               NULL cashflow_id,
               NULL cf_item,
               '小计' project_number,
               NULL project_name,
               NULL submit_date,
               NULL lease_start_date,
               NULL model_code_name,
               NULL item_frame_number,
               SUM(te.received_amount) received_amount,
               NULL fee_rate,
               NULL last_received_date,
               te.date_from_flag,
               NULL valid_date_from,
               NULL valid_date_to,
               NULL use_days,
               SUM(te.due_amount) due_amount,
               SUM(te.factoring_residual) factoring_residual
          FROM (SELECT c.contract_id,
                       c.contract_number,
                       c.bp_id_tenant,
                       (SELECT bp_name
                          FROM hls_bp_master
                         WHERE bp_id = c.bp_id_tenant) bp_id_tenant_name,
                       cc.cashflow_id,
                       cc.cf_item,
                       (SELECT p.project_number
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) project_number, -- 申请编号
                       (SELECT p.project_name
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) project_name, -- 申请名称
                       (SELECT p.submit_date
                          FROM prj_project p
                         WHERE p.project_id = c.project_id) submit_date, -- 申请日期
                       to_date(to_char(c.lease_start_date, 'yyyy-mm-dd'),
                               'yyyy-mm-dd') lease_start_date, -- 起息日
                       (SELECT hb.description || hs.description ||
                               hm.description model_code_name
                          FROM hls_car_brands_vl hb,
                               hls_car_model_vl  hm,
                               hls_car_series_vl hs,
                               hls_car_type_vl   ht
                         WHERE hm.brand_id = hb.brand_id
                           AND hm.series_id = hs.series_id
                           AND hm.model_id = ht.model_id
                           AND hb.enabled_flag = 'Y'
                           AND hm.enabled_flag = 'Y'
                           AND hs.enabled_flag = 'Y'
                           AND ht.enabled_flag = 'Y'
                           AND ht.type_code = ci.model_code
                           AND rownum = 1) model_code_name, -- 车型
                       (SELECT cd.item_frame_number
                          FROM con_contract_df_car_info cd
                         WHERE cd.contract_id = c.contract_id) item_frame_number, -- VIN码
                       nvl(t.due_amount, 0) received_amount, -- 赎证金额
                       cr.fee_rate, -- 管理费率
                       t.last_received_date, -- 赎证日期
                       to_char(cc.due_date, 'yyyymm') || '00' date_from_flag,
                       cr.valid_date_from, -- 起始日
                       nvl(cr.valid_date_to, cc.due_date) valid_date_to, -- 计算期间
                       (cr.valid_date_to - cr.valid_date_from + 1) use_days, -- 使用日期
                       cc.due_amount, -- 管理费
                       decode(nvl(t.received_amount, 0),
                              0,
                              nvl(t.due_amount, 0),
                              '') factoring_residual -- 保理残值
                  FROM con_contract c,
                       con_contract_cashflow cc,
                       con_df_manage_fee_rate cr,
                       (SELECT ccc.contract_id,
                               ccc.received_amount,
                               ccc.due_amount,
                               ccc.last_received_date
                          FROM con_contract_cashflow ccc
                         WHERE ccc.cf_item = 302
                           AND ccc.cf_status = 'RELEASE') t,
                       con_contract_df_car_info ci
                 WHERE c.contract_id = cc.contract_id
                   AND c.contract_id = cr.contract_id
                   AND to_char(cc.due_date, 'yyyymm') =
                       to_char(cr.valid_date_from, 'yyyymm')
                   AND c.contract_id = t.contract_id
                   AND c.contract_id = ci.contract_id
                   AND c.contract_status NOT IN ('CLOSED')
                   AND c.data_class = 'NORMAL'
                   AND c.lease_channel = '01'
                   AND cc.cf_item = 301
                   AND cc.cf_status = 'RELEASE'
                 ORDER BY date_from_flag, cr.valid_date_from) te
         GROUP BY te.bp_id_tenant, te.date_from_flag, te.bp_id_tenant_name
         ORDER BY bp_id_tenant, date_from_flag, bp_id_tenant_name) t1;
