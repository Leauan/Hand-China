SELECT rownum AS seq_number, -- 序号
       p.project_class_n, -- 项目类别
       (SELECT f.company_short_name
          FROM fnd_companies_vl f
         WHERE f.company_id = c.company_id) company_short_name, --投放公司
       (SELECT t.write_off_date
          FROM (SELECT to_char(cw.write_off_date, 'yyyy') write_off_date,
                       cw.contract_id contract_id
                  FROM csh_write_off cw
                 WHERE cw.cf_item = 0
                   AND cw.write_off_due_amount <> 0
                 ORDER BY cw.write_off_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) release_year, -- 投放年份
       p.project_number, -- 项目编号
       p.project_name, -- 项目名称
       c.contract_number, -- 合同编号
       c.contract_name, -- 合同名称
       c.signing_date, -- 签约日期
       p.business_type_n, -- 业务类型
       (SELECT pl.bp_stock_type_n
          FROM prj_project_legal_lv pl
         WHERE pl.project_id = p.project_id) bp_stock_type_n, -- 客户类型
       
       p.lease_channel_n, -- 产品类型
       (SELECT o.description
          FROM hls_lease_organization o
         WHERE o.lease_organization = c.lease_organization) AS lease_organization_n, --部门
       (SELECT e.name
          FROM exp_employees e
         WHERE e.employee_id = c.employee_id) AS employee_id_n, --业务经理 主办
       (SELECT u.description
          FROM sys_user u
         WHERE u.user_id = p.coorganiser_user_id) coorganiser_user_id_n, --协办
       (SELECT h.bp_code FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_tenant_code, -- 承租人编号
       (SELECT h.bp_name FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_name_tenant, -- 承租人
       (SELECT listagg(ccb.bp_name, ',') within GROUP(ORDER BY ccb.contract_id)
          FROM con_contract_bp ccb
         WHERE ccb.bp_category = 'TENANT_SEC'
           AND ccb.contract_id = c.contract_id
           AND ccb.enabled_flag = 'Y') tenant_sec_name, -- 联合承租
       (SELECT h.bp_name_sp
          FROM hls_bp_master h
         WHERE h.bp_id = c.bp_id_tenant) bp_name_sp, -- 实际控制人
       (SELECT listagg(hci.contact_person, ',') within GROUP(ORDER BY hci.bp_id)
          FROM hls_bp_master_contact_info hci
         WHERE hci.bp_id = c.bp_id_tenant
           AND rownum = 1) contact_person, -- 联系人姓名
       (SELECT listagg(hci.phone) within GROUP(ORDER BY hci.bp_id)
          FROM hls_bp_master_contact_info hci
         WHERE hci.bp_id = c.bp_id_tenant
           AND rownum = 1) contact_phone, -- 电话
       c.tt_bank_branch_name, -- 回款银行
       c.tt_bank_account_num, -- 回款账号
       (SELECT hl.company_nature_n
          FROM hls_bp_master_lv hl
         WHERE hl.bp_id = p.bp_id_tenant) company_nature_n, -- 企业性质
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'INDUSTRY_INTERNAL'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value =
               (SELECT h.industry_internal
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) industry_internal_n, -- 内部行业
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'INVEST_POLICY'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value =
               (SELECT h.invest_policy
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) invest_policy_n, -- 投向政策
       (SELECT sc.description
          FROM hls_stat_class sc
         WHERE sc.class_id =
               (SELECT h.industry
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) industry_n, -- 国标行业
       p.platform_level_n, -- 平台级别
       (SELECT fp.description
          FROM fnd_province fp
         WHERE fp.province_id = (SELECT ha.province_id
                                   FROM hls_bp_master_address ha
                                  WHERE ha.bp_id = c.bp_id_tenant
                                    AND rownum = 1)) AS province_id_n, --省
       (SELECT fc.description
          FROM fnd_city fc
         WHERE fc.city_id = (SELECT ha.city_id
                               FROM hls_bp_master_address ha
                              WHERE ha.bp_id = c.bp_id_tenant
                                AND rownum = 1)) ||
       (SELECT fd.description
          FROM fnd_district fd
         WHERE fd.district_id = (SELECT ha.district_id
                                   FROM hls_bp_master_address ha
                                  WHERE ha.bp_id = c.bp_id_tenant
                                    AND rownum = 1)) city_district_n, -- 市县
       to_char(c.lease_start_date, 'YYYY') lease_start_date_y, -- 起租年份
       to_char(c.lease_start_date, 'MM-DD') lease_start_date_md, -- 起租日期
       to_char((SELECT nvl(ccc.full_write_off_date, ccc.due_date)
                 FROM con_contract_cashflow ccc
                WHERE ccc.contract_id = c.contract_id
                  AND ccc.cf_direction = 'INFLOW'
                  AND ccc.cf_status = 'RELEASE'
                  AND ccc.cf_type = 1
                  AND ccc.times = (SELECT MAX(cf.times)
                                     FROM con_contract_cashflow cf
                                    WHERE cf.contract_id = c.contract_id
                                      AND cf.cf_direction = 'INFLOW'
                                      AND cf.cf_status = 'RELEASE'
                                      AND cf.cf_type = 1)),
               'YYYY-MM-DD') lease_end_date, -- 终止日期
       c.lease_times, -- 合同期限
       c.lease_item_amount, -- 合同总本金
       (SELECT SUM(cw.write_off_due_amount)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_due_amount_s, -- 合同已投放金额
       (SELECT listagg(cw.write_off_date, ',') within GROUP(ORDER BY cw.contract_id)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_date, -- 合同投放时间
       (SELECT listagg(cw.write_off_due_amount, ',') within GROUP(ORDER BY cw.contract_id)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_due_amount, --合同投放金额
       nvl(c.deposit, 0) deposit, -- 保证金
       decode((SELECT COUNT(1)
                FROM csh_write_off co, csh_transaction ct
               WHERE co.contract_id = c.contract_id
                 AND co.cf_item = 51
                 AND co.csh_transaction_id = ct.transaction_id
                 AND ct.transaction_type = 'DEDUCTION'),
              0,
              '否',
              '是') deposit_deduction_type, -- 保证金内扣
       nvl(c.hd_user_col_v01, 0) hd_user_col_v01, -- 咨询服务费
       decode((SELECT COUNT(1)
                FROM csh_write_off co, csh_transaction ct
               WHERE co.contract_id = c.contract_id
                 AND co.cf_item = 10
                 AND co.csh_transaction_id = ct.transaction_id
                 AND ct.transaction_type = 'DEDUCTION'),
              0,
              '否',
              '是') v01_deduction_type, -- 咨询服务费内扣
       c.residual_value, --名义货价
       c.irr, -- IRR
       c.xirr, -- XIRR
       c.int_rate, -- 合同利率
       c.int_rate_type_n, --利率类型 固定/浮动
       (SELECT listagg(pv.ref_v03_n, ',') within GROUP(ORDER BY pv.project_id)
          FROM prj_bp_guarantor_lv pv
         WHERE pv.project_id = c.project_id
           AND pv.ref_v03 IS NOT NULL) guarantee_type_n， -- 担保方式
       (SELECT listagg(ccb.bp_name, ',') within GROUP(ORDER BY ccb.contract_id)
          FROM con_contract_bp ccb
         WHERE ccb.bp_category = 'GUARANTOR'
           AND ccb.contract_id = c.contract_id
           AND ccb.enabled_flag = 'Y') guarantor, -- 担保人
       (SELECT SUM(cm.net_value)
          FROM con_contract_mortgage cm
         WHERE cm.contract_id = c.contract_id) net_value, -- 抵押物价值
       c.pay_type_n, --还租方式
       p.property_type_n, -- 租赁物类别
       (SELECT listagg(ci.short_name, ',') within GROUP(ORDER BY ci.contract_id) lease_short_name
          FROM con_contract_lease_item ci
         WHERE ci.contract_id = c.contract_id) lease_short_name, -- 租赁物简称
       (SELECT SUM(ci.original_asset_value)
          FROM con_contract_lease_item ci
         WHERE ci.contract_id = c.contract_id) original_asset_value, -- 租赁物价值   
       (SELECT rfc.description
          FROM rsc_five_class_code rfc, rsc_fc_estimate_result rft
         WHERE rfc.five_class_code = rft.five_class_code
           AND rft.contract_id = c.contract_id
           AND rownum = 1) five_class_name, -- 正常五级分类
       (SELECT v.code_value_name
          FROM sys_code_values_v v, rsc_fc_estimate_result rft
         WHERE v.code = 'INTERNAL_RISK'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value = rft.ref_v01
           AND rft.contract_id = c.contract_id
           AND rownum = 1) five_class_name_inner, -- 内部五级分类
       (SELECT nvl(cc.received_amount, 0)
          FROM con_contract_cashflow cc
         WHERE cc.contract_id = c.contract_id
           AND cc.cf_item = 10) received_amount_hd, -- 已收咨询服务费
       (SELECT (nvl(cc.due_amount, 0) - nvl(cc.received_amount, 0)) unreceived_amount_hd
          FROM con_contract_cashflow cc
         WHERE cc.contract_id = c.contract_id
           AND cc.cf_item = 10) unreceived_amount_hd, -- 未收咨询服务费
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date >= SYSDATE
           AND ccc.due_date <= add_months(SYSDATE, 12)) in_one_year_due_rental, -- 应收租金总额（1年内）
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 12)
           AND ccc.due_date <= add_months(SYSDATE, 24)) one_two_year_due_rental, -- 应收租金总额（1-2年内）
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 24)
           AND ccc.due_date <= add_months(SYSDATE, 36)) two_three_year_due_rental, -- 应收租金总额（2-3年内）
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 36)
           AND ccc.due_date <= add_months(SYSDATE, 48)) three_four_year_due_rental, -- 应收租金总额（3-4年内）
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 48)
           AND ccc.due_date <= add_months(SYSDATE, 60)) four_five_year_due_rental, -- 应收租金总额（4-5年内）
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 60)) after_five_year_due_rental, -- 应收租金总额（5年以上年内）
       (SELECT SUM(nvl(ccc.received_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_amount, -- 已收租金总额
       (SELECT SUM(nvl(ccc.received_principal, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_principal, -- 已收本金总额
       (SELECT SUM(nvl(ccc.received_interest, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_interest, -- 已收利息总额
       (SELECT SUM(nvl(ccc.due_amount, 0) - nvl(ccc.received_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_amount, -- 未收租金总额
       (SELECT SUM(nvl(ccc.principal, 0) - nvl(ccc.received_principal, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_principal, -- 未收本金总额
       (SELECT SUM(nvl(ccc.interest, 0) - nvl(ccc.received_interest, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_interest, -- 未收利息总额
       (SELECT SUM(nvl(ccc.due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.overdue_status = 'Y'
           AND ccc.write_off_flag <> 'FULL') over_due_amount, -- 逾期金额
       (SELECT SUM(nvl(ccc.overdue_max_days, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) overdue_max_days, -- 逾期天数
       (SELECT SUM(nvl(ccc.due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 9) total_penalty_interest, -- 罚息总额
       ((SELECT SUM(nvl(ccc.principal, 0) - nvl(ccc.received_principal, 0))
           FROM con_contract_cashflow ccc
          WHERE ccc.contract_id = c.contract_id
            AND ccc.cf_item = 1
            AND ccc.times <> 0) - c.deposit +
       (SELECT SUM(nvl(ccc.interest, 0))
           FROM con_contract_cashflow ccc
          WHERE ccc.contract_id = c.contract_id
            AND ccc.cf_item = 1
            AND ccc.overdue_status = 'Y'
            AND ccc.write_off_flag <> 'FULL')) residual_risk_exposure, -- 剩余风险敞口  
       (SELECT t.credit_rating_n
          FROM (SELECT h.credit_rating_n, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_credit_rating, -- 承租人最新评级（最高）  
       (SELECT t.rating_agency
          FROM (SELECT h.rating_agency, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_rating_agency, -- 承租人评级机构,取最新
       (SELECT t.rating_date
          FROM (SELECT h.rating_date, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_rating_date, -- 承租人评级时间,取最新  
       
       (SELECT t.credit_rating_n
          FROM (SELECT h.credit_rating_n, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_credit_rating, -- 担保人最新评级（最高）  
       (SELECT t.rating_agency
          FROM (SELECT h.rating_agency, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_rating_agency, -- 担保人评级机构,取最新
       (SELECT t.rating_date
          FROM (SELECT h.rating_date, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_rating_date, -- 担保人评级时间,取最新
       p.description, -- 项目简介
       p.creation_date, -- 项目创建日期
       (SELECT pm.meeting_name
          FROM prj_project_approval pa, prj_project_meeting pm
         WHERE pa.project_id = p.project_id
           AND pa.meeting_id = pm.meeting_id) meeting_name, --立项会编号
       (SELECT z.last_update_date
          FROM zj_wfl_approve_record z, zj_wfl_workflow_node_action za
         WHERE z.instance_id = p.wfl_instance_id
           AND za.node_id = z.node_id
           AND z.node_id = 1348
           AND za.node_action_id = 1625) date_will_pass --立项通过日期

/*decode(cc.price_list,
       'CR_OTHER',
       NULL,
       (CASE
         WHEN (SELECT nvl(cc.lease_item_amount, 0) -
                      SUM(nvl(cf.received_principal, 0))
                 FROM con_contract_cashflow cf
                WHERE cc.contract_id = cf.contract_id) - cc.deposit -
              cc.third_party_deposit +
              nvl((SELECT SUM(nvl(cf.received_amount, 0))
                    FROM con_contract_cashflow cf
                   WHERE cc.contract_id = cf.contract_id
                     AND cf.cf_item = 54),
                  0) >= 0 THEN
          (SELECT nvl(cc.lease_item_amount, 0) -
                  SUM(nvl(cf.received_principal, 0))
             FROM con_contract_cashflow cf
            WHERE cc.contract_id = cf.contract_id) - cc.deposit -
          cc.third_party_deposit +
          nvl((SELECT SUM(nvl(cf.received_amount, 0))
                FROM con_contract_cashflow cf
               WHERE cc.contract_id = cf.contract_id
                 AND cf.cf_item = 54),
              0)
         ELSE
          0
       END)) residual_risk_exposure, --剩余风险敞口
decode(h.bp_class,
       'ORG',
       (SELECT city_id_n || district_id_n
          FROM hls_bp_master_address_lv
         WHERE bp_id = h.bp_id
           AND address_type = 'COMPANY_ADDRESS'
           AND rownum = 1),
       'NP',
       (SELECT city_id_n || district_id_n
          FROM hls_bp_master_address_lv
         WHERE bp_id = h.bp_id
           AND address_type = 'DOC_SENT_ADDRESS')) city_district_id_n,
nvl(p.lease_item_amount,
    (SELECT SUM(lease_item_amount)
       FROM con_contract
      WHERE project_id = p.project_id)) lease_item_amount,
nvl(p.hd_user_col_v01,
    (SELECT SUM(hd_user_col_v01)
       FROM con_contract
      WHERE project_id = p.project_id)) hd_user_col_v01,
round(p.lease_term / 12, 2) lease_term_year,
(SELECT to_number(nvl(hd.irr, 0) * 100) || '%'
   FROM prj_quotation pq, hls_fin_calculator_hd hd
  WHERE pq.document_category = 'PROJECT'
    AND pq.document_id = p.project_id
    AND pq.calc_session_id = hd.calc_session_id
    AND pq.quotation_type = 'MAJOR'
    AND pq.enabled_flag = 'Y'
    AND hd.calc_successful = 'Y'
    AND pq.data_class IN ('NORMAL', 'CHANGE_REQ')) irr,
--批复利率
decode((SELECT compant_reply_rate * 100 || '%'
         FROM prj_project_decision
        WHERE project_id = p.project_id
          AND reply_type = 'COMPANY'),
       '%',
       NULL,
       (SELECT compant_reply_rate * 100 || '%'
          FROM prj_project_decision
         WHERE project_id = p.project_id
           AND reply_type = 'COMPANY')) company_reply_rate,
decode((SELECT pq.price_list
         FROM prj_quotation pq
        WHERE pq.document_category = 'PROJECT'
          AND pq.document_id = p.project_id
          AND pq.quotation_type = 'MAJOR'
          AND pq.enabled_flag = 'Y'
          AND pq.data_class IN ('NORMAL', 'CHANGE_REQ')),
       'CR_LEASING_PMT_01',
       '等额本息',
       'CR_LEASING_PMT_01_sh',
       '等额本息',
       'CR_LEASING_PRIN_01',
       '等额本金',
       'CR_LEASING_PRIN_01_sh',
       '等额本金',
       '任意现金流') price_list_n,
p.property_type_n,
p.description,
h.credit_rating_n tenant_credit_rating,
(SELECT listagg(h.bp_name || '：' ||
                nvl(nvl(h.credit_rating_n, h.credit_rating_2_n), '无'),
                '；') within GROUP(ORDER BY project_id) guarantor_credit_rating
   FROM prj_project_bp pb, hls_bp_master_lv h
  WHERE pb.bp_category = 'GUARANTOR'
    AND pb.bp_id = h.bp_id
    AND pb.project_id = p.project_id) guarantor_credit_rating,
p.aproved_date,
p.project_status_n,
(SELECT examiner_n
   FROM prj_project_legal_lv
  WHERE project_id = p.project_id) examiner_n,
(SELECT examiner_date
   FROM prj_project_legal_lv pl
  WHERE project_id = p.project_id) examiner_date,
(SELECT legal_opinion_create_n
   FROM prj_project_legal_lv
  WHERE project_id = p.project_id) legal_opinion_create_n,
(SELECT bloc_reply_time
   FROM prj_project_decision
  WHERE reply_type = 'BLOC'
    AND project_id = p.project_id) bloc_reply_time,
--批复有效期
nvl((SELECT decode(sign(add_months(pd.company_all_date, 3) - SYSDATE),
                  -1,
                  '否',
                  '是')
      FROM prj_project_decision pd
     WHERE pd.project_id = p.project_id
       AND reply_type = 'COMPANY'
       AND EXISTS
     (SELECT 1
              FROM con_contract_cashflow ccc, con_contract cc
             WHERE ccc.contract_id = cc.contract_id
               AND cc.project_id = p.project_id
               AND ccc.cf_item = 0
               AND ccc.times = 0
               AND cc.data_class = 'NORMAL'
               AND ccc.write_off_flag <> 'NOT')),
    nvl((SELECT decode(sign(add_months(pd.company_first_date, 3) -
                           SYSDATE),
                      -1,
                      '否',
                      '是')
          FROM prj_project_decision pd
         WHERE pd.project_id = p.project_id
           AND reply_type = 'COMPANY'),
        '否')) company_reply_valid_flag,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date >= SYSDATE
    AND ccc.due_date <= add_months(SYSDATE, 12)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') in_one_year_due_rental,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date > add_months(SYSDATE, 12)
    AND ccc.due_date <= add_months(SYSDATE, 24)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') one_two_year_due_rental,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date > add_months(SYSDATE, 24)
    AND ccc.due_date <= add_months(SYSDATE, 36)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') two_three_year_due_rental,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date > add_months(SYSDATE, 36)
    AND ccc.due_date <= add_months(SYSDATE, 48)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') three_four_year_due_rental,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date > add_months(SYSDATE, 48)
    AND ccc.due_date <= add_months(SYSDATE, 60)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') four_five_year_due_rental,
(SELECT SUM(nvl(due_amount, 0))
   FROM con_contract_cashflow ccc, con_contract cc
  WHERE ccc.contract_id = cc.contract_id
    AND ccc.cf_item = 1
    AND ccc.due_date > add_months(SYSDATE, 60)
    AND cc.project_id = p.project_id
    AND cc.data_class = 'NORMAL') after_five_year_due_rental,
(SELECT f.company_code
   FROM fnd_companies_vl f
  WHERE company_id = p.company_id) company_code,
p.cdd_list_id,
p.document_category,
p.document_type,
(SELECT listagg(to_char(ct.transaction_date, 'YYYY-MM-DD'), ',') within GROUP(ORDER BY cl.ref_doc_id)
   FROM csh_payment_req_ln cl, csh_transaction ct
  WHERE cl.ref_doc_id = c.contract_id
    AND cl.ref_doc_category = 'CONTRACT'
    AND ct.source_doc_id = cl.payment_req_id
    AND ct.source_doc_line_id = cl.payment_req_ln_id) payment_date, --合同投放时间
(SELECT hd.description
   FROM hls_document_type hd
  WHERE hd.document_type = c.document_type) document_type_n,
--c.business_type_n, --业务类型
--c.lease_channel_n, --产品类型
c.contract_status,
c.contract_status_n,
c.bp_id_tenant,
(SELECT h.bp_code FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_tenant_code,
(SELECT h.bp_type FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_tenant_type,
(SELECT h.bp_class
   FROM hls_bp_master h
  WHERE h.bp_id = c.bp_id_tenant) bp_class,
(SELECT h.bp_name FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_name_tenant,
(SELECT f.company_short_name
   FROM fnd_companies_vl f
  WHERE f.company_id = c.company_id) company_short_name, --投放公司
(SELECT h.industry
   FROM hls_bp_master h
  WHERE h.bp_id = c.bp_id_tenant
    AND nvl(h.enabled_flag, 'N') = 'Y') industry,
(SELECT sc.description
   FROM hls_stat_class sc
  WHERE sc.class_id =
        (SELECT h.industry
           FROM hls_bp_master h
          WHERE h.bp_id = c.bp_id_tenant
            AND nvl(h.enabled_flag, 'N') = 'Y')) industry_n, --行业
(SELECT h.industry_internal
   FROM hls_bp_master h
  WHERE h.bp_id = c.bp_id_tenant
    AND nvl(h.enabled_flag, 'N') = 'Y') industry_internal,
(SELECT h.invest_policy
   FROM hls_bp_master h
  WHERE h.bp_id = c.bp_id_tenant
    AND nvl(h.enabled_flag, 'N') = 'Y') invest_policy,
(SELECT v.code_value_name
   FROM sys_code_values_v v
  WHERE v.code = 'INVEST_POLICY'
    AND v.code_enabled_flag = 'Y'
    AND v.code_value_enabled_flag = 'Y'
    AND v.code_value =
        (SELECT h.invest_policy
           FROM hls_bp_master h
          WHERE h.bp_id = c.bp_id_tenant
            AND nvl(h.enabled_flag, 'N') = 'Y')) invest_policy_n, --投向政策
(SELECT h.area FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) area, --区域
(SELECT fc.description
   FROM fnd_city fc
  WHERE fc.city_id = (SELECT ha.city_id
                        FROM hls_bp_master_address ha
                       WHERE ha.bp_id = c.bp_id_tenant
                         AND rownum = 1)) ||
(SELECT fd.description
   FROM fnd_district fd
  WHERE fd.district_id = (SELECT ha.district_id
                            FROM hls_bp_master_address ha
                           WHERE ha.bp_id = c.bp_id_tenant
                             AND rownum = 1)) city_district_n, --市县
nvl(c.total_rental, 0) -
(SELECT SUM(nvl(ccc.received_amount, 0))
   FROM con_contract_cashflow ccc
  WHERE ccc.contract_id = c.contract_id
    AND ccc.cf_type = 1
    AND ccc.cf_item = 1
    AND ccc.cf_status = 'RELEASE') last_rental, --未收租金总额
nvl(c.total_interest,
    (SELECT SUM(nvl(ccc.interest, 0))
       FROM con_contract_cashflow ccc
      WHERE ccc.contract_id = c.contract_id
        AND ccc.cf_type = 1
        AND ccc.cf_item = 1)) -
(SELECT SUM(nvl(ccc.received_interest, 0))
   FROM con_contract_cashflow ccc
  WHERE ccc.contract_id = c.contract_id
    AND ccc.cf_type = 1
    AND ccc.cf_item = 1
    AND ccc.cf_status = 'RELEASE') last_interest, --未收利息总额
nvl(c.total_rental, 0) -
nvl(c.total_interest,
    (SELECT SUM(nvl(ccc.interest, 0))
       FROM con_contract_cashflow ccc
      WHERE ccc.contract_id = c.contract_id
        AND ccc.cf_type = 1
        AND ccc.cf_item = 1)) -
(SELECT SUM(nvl(ccc.received_principal, 0))
   FROM con_contract_cashflow ccc
  WHERE ccc.contract_id = c.contract_id
    AND ccc.cf_type = 1
    AND ccc.cf_item = 1
    AND ccc.cf_status = 'RELEASE') last_principal, --未收本金总额
c.telex_transfer_bank_id_n, --回款账户
c.lease_times,
to_char(c.lease_start_date, 'YYYY-MM-DD') lease_start_date,
to_char((SELECT nvl(ccc.full_write_off_date, ccc.due_date)
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_direction = 'INFLOW'
           AND ccc.cf_status = 'RELEASE'
           AND ccc.cf_type = 1
           AND ccc.times = (SELECT MAX(cf.times)
                              FROM con_contract_cashflow cf
                             WHERE cf.contract_id = c.contract_id
                               AND cf.cf_direction = 'INFLOW'
                               AND cf.cf_status = 'RELEASE'
                               AND cf.cf_type = 1)),
        'YYYY-MM-DD') lease_end_date,
c.pay_type,
c.pay_type_n, --还租方式
c.int_rate,
--c.int_rate_type_n, --利率类型
c.xirr,
nvl(c.total_rental, 0) total_rental,
nvl(c.total_interest,
    (SELECT SUM(nvl(ccc.interest, 0))
       FROM con_contract_cashflow ccc
      WHERE ccc.contract_id = c.contract_id
        AND ccc.cf_type = 1
        AND ccc.cf_item = 1)) total_interest,
nvl(c.total_rental, 0) -
nvl(c.total_interest,
    (SELECT SUM(nvl(ccc.interest, 0))
       FROM con_contract_cashflow ccc
      WHERE ccc.contract_id = c.contract_id
        AND ccc.cf_type = 1
        AND ccc.cf_item = 1)) total_principal,
decode((SELECT COUNT(1)
         FROM csh_write_off co, csh_transaction ct
        WHERE co.contract_id = c.contract_id
          AND co.cf_item = 10
          AND co.csh_transaction_id = ct.transaction_id
          AND ct.transaction_type = 'DEDUCTION'),
       0,
       '否',
       '是') v01_deduction_type,
nvl(c.deposit, 0) deposit,
decode((SELECT COUNT(1)
         FROM csh_write_off co, csh_transaction ct
        WHERE co.contract_id = c.contract_id
          AND co.cf_item = 51
          AND co.csh_transaction_id = ct.transaction_id
          AND ct.transaction_type = 'DEDUCTION'),
       0,
       '否',
       '是') deposit_deduction_type,
c.residual_value, --名义货价
c.five_class_code,
decode((SELECT COUNT(*)
         FROM prj_bp_guarantor_lv pv
        WHERE pv.project_id = c.project_id
          AND pv.ref_v03 IS NOT NULL),
       0,
       '无',
       '有') guarantee_desc, --担保方式有无
(SELECT listagg(pv.ref_v03_n, ',') within GROUP(ORDER BY pv.project_id)
   FROM prj_bp_guarantor_lv pv
  WHERE pv.project_id = c.project_id
    AND pv.ref_v03 IS NOT NULL) guarantee_type_n*/
  FROM prj_project_lv p,
       --hls_bp_master_lv      h,
       con_contract_lv c
/*con_contract          cc,
hls_bp_master         hbm,
csh_payment_req_hd    cprh,
con_contract_cashflow ccc*/
 WHERE c.data_class = 'NORMAL'
   AND c.contract_status <> 'CANCEL'
   AND c.project_id = p.project_id
   AND EXISTS (SELECT 1
          FROM csh_write_off co
         WHERE co.contract_id = c.contract_id
           AND co.write_off_type = 'PAYMENT_DEBT'
           AND co.cf_item = 0);
/* WHERE p.bp_id_tenant = h.bp_id
   AND c.data_class = 'NORMAL'
   AND hbm.bp_id = h.bp_id
   AND p.company_id = cprh.company_id
   AND cc.contract_id = c.contract_id
   AND ccc.contract_id = c.contract_id
   AND c.contract_status <> 'CANCEL'
   AND p.project_id = c.project_id
   AND p.project_status IN ('ApROVED', 'CONTRACT_CREATED');*/
