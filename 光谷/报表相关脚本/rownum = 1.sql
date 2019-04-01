SELECT rownum AS seq_number, -- ���
       p.project_class_n, -- ��Ŀ���
       (SELECT f.company_short_name
          FROM fnd_companies_vl f
         WHERE f.company_id = c.company_id) company_short_name, --Ͷ�Ź�˾
       (SELECT t.write_off_date
          FROM (SELECT to_char(cw.write_off_date, 'yyyy') write_off_date,
                       cw.contract_id contract_id
                  FROM csh_write_off cw
                 WHERE cw.cf_item = 0
                   AND cw.write_off_due_amount <> 0
                 ORDER BY cw.write_off_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) release_year, -- Ͷ�����
       p.project_number, -- ��Ŀ���
       p.project_name, -- ��Ŀ����
       c.contract_number, -- ��ͬ���
       c.contract_name, -- ��ͬ����
       c.signing_date, -- ǩԼ����
       p.business_type_n, -- ҵ������
       (SELECT pl.bp_stock_type_n
          FROM prj_project_legal_lv pl
         WHERE pl.project_id = p.project_id) bp_stock_type_n, -- �ͻ�����
       
       p.lease_channel_n, -- ��Ʒ����
       (SELECT o.description
          FROM hls_lease_organization o
         WHERE o.lease_organization = c.lease_organization) AS lease_organization_n, --����
       (SELECT e.name
          FROM exp_employees e
         WHERE e.employee_id = c.employee_id) AS employee_id_n, --ҵ���� ����
       (SELECT u.description
          FROM sys_user u
         WHERE u.user_id = p.coorganiser_user_id) coorganiser_user_id_n, --Э��
       (SELECT h.bp_code FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_tenant_code, -- �����˱��
       (SELECT h.bp_name FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) bp_name_tenant, -- ������
       (SELECT listagg(ccb.bp_name, ',') within GROUP(ORDER BY ccb.contract_id)
          FROM con_contract_bp ccb
         WHERE ccb.bp_category = 'TENANT_SEC'
           AND ccb.contract_id = c.contract_id
           AND ccb.enabled_flag = 'Y') tenant_sec_name, -- ���ϳ���
       (SELECT h.bp_name_sp
          FROM hls_bp_master h
         WHERE h.bp_id = c.bp_id_tenant) bp_name_sp, -- ʵ�ʿ�����
       (SELECT listagg(hci.contact_person, ',') within GROUP(ORDER BY hci.bp_id)
          FROM hls_bp_master_contact_info hci
         WHERE hci.bp_id = c.bp_id_tenant
           AND rownum = 1) contact_person, -- ��ϵ������
       (SELECT listagg(hci.phone) within GROUP(ORDER BY hci.bp_id)
          FROM hls_bp_master_contact_info hci
         WHERE hci.bp_id = c.bp_id_tenant
           AND rownum = 1) contact_phone, -- �绰
       c.tt_bank_branch_name, -- �ؿ�����
       c.tt_bank_account_num, -- �ؿ��˺�
       (SELECT hl.company_nature_n
          FROM hls_bp_master_lv hl
         WHERE hl.bp_id = p.bp_id_tenant) company_nature_n, -- ��ҵ����
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'INDUSTRY_INTERNAL'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value =
               (SELECT h.industry_internal
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) industry_internal_n, -- �ڲ���ҵ
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'INVEST_POLICY'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value =
               (SELECT h.invest_policy
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) invest_policy_n, -- Ͷ������
       (SELECT sc.description
          FROM hls_stat_class sc
         WHERE sc.class_id =
               (SELECT h.industry
                  FROM hls_bp_master h
                 WHERE h.bp_id = c.bp_id_tenant
                   AND nvl(h.enabled_flag, 'N') = 'Y')) industry_n, -- ������ҵ
       p.platform_level_n, -- ƽ̨����
       (SELECT fp.description
          FROM fnd_province fp
         WHERE fp.province_id = (SELECT ha.province_id
                                   FROM hls_bp_master_address ha
                                  WHERE ha.bp_id = c.bp_id_tenant
                                    AND rownum = 1)) AS province_id_n, --ʡ
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
                                    AND rownum = 1)) city_district_n, -- ����
       to_char(c.lease_start_date, 'YYYY') lease_start_date_y, -- �������
       to_char(c.lease_start_date, 'MM-DD') lease_start_date_md, -- ��������
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
               'YYYY-MM-DD') lease_end_date, -- ��ֹ����
       c.lease_times, -- ��ͬ����
       c.lease_item_amount, -- ��ͬ�ܱ���
       (SELECT SUM(cw.write_off_due_amount)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_due_amount_s, -- ��ͬ��Ͷ�Ž��
       (SELECT listagg(cw.write_off_date, ',') within GROUP(ORDER BY cw.contract_id)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_date, -- ��ͬͶ��ʱ��
       (SELECT listagg(cw.write_off_due_amount, ',') within GROUP(ORDER BY cw.contract_id)
          FROM csh_write_off cw
         WHERE cw.contract_id = c.contract_id
           AND cw.cf_item = 0) write_off_due_amount, --��ͬͶ�Ž��
       nvl(c.deposit, 0) deposit, -- ��֤��
       decode((SELECT COUNT(1)
                FROM csh_write_off co, csh_transaction ct
               WHERE co.contract_id = c.contract_id
                 AND co.cf_item = 51
                 AND co.csh_transaction_id = ct.transaction_id
                 AND ct.transaction_type = 'DEDUCTION'),
              0,
              '��',
              '��') deposit_deduction_type, -- ��֤���ڿ�
       nvl(c.hd_user_col_v01, 0) hd_user_col_v01, -- ��ѯ�����
       decode((SELECT COUNT(1)
                FROM csh_write_off co, csh_transaction ct
               WHERE co.contract_id = c.contract_id
                 AND co.cf_item = 10
                 AND co.csh_transaction_id = ct.transaction_id
                 AND ct.transaction_type = 'DEDUCTION'),
              0,
              '��',
              '��') v01_deduction_type, -- ��ѯ������ڿ�
       c.residual_value, --�������
       c.irr, -- IRR
       c.xirr, -- XIRR
       c.int_rate, -- ��ͬ����
       c.int_rate_type_n, --�������� �̶�/����
       (SELECT listagg(pv.ref_v03_n, ',') within GROUP(ORDER BY pv.project_id)
          FROM prj_bp_guarantor_lv pv
         WHERE pv.project_id = c.project_id
           AND pv.ref_v03 IS NOT NULL) guarantee_type_n�� -- ������ʽ
       (SELECT listagg(ccb.bp_name, ',') within GROUP(ORDER BY ccb.contract_id)
          FROM con_contract_bp ccb
         WHERE ccb.bp_category = 'GUARANTOR'
           AND ccb.contract_id = c.contract_id
           AND ccb.enabled_flag = 'Y') guarantor, -- ������
       (SELECT SUM(cm.net_value)
          FROM con_contract_mortgage cm
         WHERE cm.contract_id = c.contract_id) net_value, -- ��Ѻ���ֵ
       c.pay_type_n, --���ⷽʽ
       p.property_type_n, -- ���������
       (SELECT listagg(ci.short_name, ',') within GROUP(ORDER BY ci.contract_id) lease_short_name
          FROM con_contract_lease_item ci
         WHERE ci.contract_id = c.contract_id) lease_short_name, -- ��������
       (SELECT SUM(ci.original_asset_value)
          FROM con_contract_lease_item ci
         WHERE ci.contract_id = c.contract_id) original_asset_value, -- �������ֵ   
       (SELECT rfc.description
          FROM rsc_five_class_code rfc, rsc_fc_estimate_result rft
         WHERE rfc.five_class_code = rft.five_class_code
           AND rft.contract_id = c.contract_id
           AND rownum = 1) five_class_name, -- �����弶����
       (SELECT v.code_value_name
          FROM sys_code_values_v v, rsc_fc_estimate_result rft
         WHERE v.code = 'INTERNAL_RISK'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value = rft.ref_v01
           AND rft.contract_id = c.contract_id
           AND rownum = 1) five_class_name_inner, -- �ڲ��弶����
       (SELECT nvl(cc.received_amount, 0)
          FROM con_contract_cashflow cc
         WHERE cc.contract_id = c.contract_id
           AND cc.cf_item = 10) received_amount_hd, -- ������ѯ�����
       (SELECT (nvl(cc.due_amount, 0) - nvl(cc.received_amount, 0)) unreceived_amount_hd
          FROM con_contract_cashflow cc
         WHERE cc.contract_id = c.contract_id
           AND cc.cf_item = 10) unreceived_amount_hd, -- δ����ѯ�����
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date >= SYSDATE
           AND ccc.due_date <= add_months(SYSDATE, 12)) in_one_year_due_rental, -- Ӧ������ܶ1���ڣ�
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 12)
           AND ccc.due_date <= add_months(SYSDATE, 24)) one_two_year_due_rental, -- Ӧ������ܶ1-2���ڣ�
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 24)
           AND ccc.due_date <= add_months(SYSDATE, 36)) two_three_year_due_rental, -- Ӧ������ܶ2-3���ڣ�
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 36)
           AND ccc.due_date <= add_months(SYSDATE, 48)) three_four_year_due_rental, -- Ӧ������ܶ3-4���ڣ�
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 48)
           AND ccc.due_date <= add_months(SYSDATE, 60)) four_five_year_due_rental, -- Ӧ������ܶ4-5���ڣ�
       (SELECT SUM(nvl(due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.due_date > add_months(SYSDATE, 60)) after_five_year_due_rental, -- Ӧ������ܶ5���������ڣ�
       (SELECT SUM(nvl(ccc.received_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_amount, -- ��������ܶ�
       (SELECT SUM(nvl(ccc.received_principal, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_principal, -- ���ձ����ܶ�
       (SELECT SUM(nvl(ccc.received_interest, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_received_interest, -- ������Ϣ�ܶ�
       (SELECT SUM(nvl(ccc.due_amount, 0) - nvl(ccc.received_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_amount, -- δ������ܶ�
       (SELECT SUM(nvl(ccc.principal, 0) - nvl(ccc.received_principal, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_principal, -- δ�ձ����ܶ�
       (SELECT SUM(nvl(ccc.interest, 0) - nvl(ccc.received_interest, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) sum_unreceived_interest, -- δ����Ϣ�ܶ�
       (SELECT SUM(nvl(ccc.due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1
           AND ccc.overdue_status = 'Y'
           AND ccc.write_off_flag <> 'FULL') over_due_amount, -- ���ڽ��
       (SELECT SUM(nvl(ccc.overdue_max_days, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 1) overdue_max_days, -- ��������
       (SELECT SUM(nvl(ccc.due_amount, 0))
          FROM con_contract_cashflow ccc
         WHERE ccc.contract_id = c.contract_id
           AND ccc.cf_item = 9) total_penalty_interest, -- ��Ϣ�ܶ�
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
            AND ccc.write_off_flag <> 'FULL')) residual_risk_exposure, -- ʣ����ճ���  
       (SELECT t.credit_rating_n
          FROM (SELECT h.credit_rating_n, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_credit_rating, -- ������������������ߣ�  
       (SELECT t.rating_agency
          FROM (SELECT h.rating_agency, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_rating_agency, -- ��������������,ȡ����
       (SELECT t.rating_date
          FROM (SELECT h.rating_date, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'TENANT'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) tenant_rating_date, -- ����������ʱ��,ȡ����  
       
       (SELECT t.credit_rating_n
          FROM (SELECT h.credit_rating_n, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_credit_rating, -- ������������������ߣ�  
       (SELECT t.rating_agency
          FROM (SELECT h.rating_agency, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_rating_agency, -- ��������������,ȡ����
       (SELECT t.rating_date
          FROM (SELECT h.rating_date, cb.contract_id
                  FROM hls_bp_master_lv h, con_contract_bp cb
                 WHERE h.bp_id = cb.bp_id
                   AND cb.bp_category = 'GUARANTOR'
                 ORDER BY h.rating_date DESC) t
         WHERE t.contract_id = c.contract_id
           AND rownum = 1) guarantor_rating_date, -- ����������ʱ��,ȡ����
       p.description, -- ��Ŀ���
       p.creation_date, -- ��Ŀ��������
       (SELECT pm.meeting_name
          FROM prj_project_approval pa, prj_project_meeting pm
         WHERE pa.project_id = p.project_id
           AND pa.meeting_id = pm.meeting_id) meeting_name, --�������
       (SELECT z.last_update_date
          FROM zj_wfl_approve_record z, zj_wfl_workflow_node_action za
         WHERE z.instance_id = p.wfl_instance_id
           AND za.node_id = z.node_id
           AND z.node_id = 1348
           AND za.node_action_id = 1625) date_will_pass --����ͨ������

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
       END)) residual_risk_exposure, --ʣ����ճ���
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
--��������
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
       '�ȶϢ',
       'CR_LEASING_PMT_01_sh',
       '�ȶϢ',
       'CR_LEASING_PRIN_01',
       '�ȶ��',
       'CR_LEASING_PRIN_01_sh',
       '�ȶ��',
       '�����ֽ���') price_list_n,
p.property_type_n,
p.description,
h.credit_rating_n tenant_credit_rating,
(SELECT listagg(h.bp_name || '��' ||
                nvl(nvl(h.credit_rating_n, h.credit_rating_2_n), '��'),
                '��') within GROUP(ORDER BY project_id) guarantor_credit_rating
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
--������Ч��
nvl((SELECT decode(sign(add_months(pd.company_all_date, 3) - SYSDATE),
                  -1,
                  '��',
                  '��')
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
                      '��',
                      '��')
          FROM prj_project_decision pd
         WHERE pd.project_id = p.project_id
           AND reply_type = 'COMPANY'),
        '��')) company_reply_valid_flag,
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
    AND ct.source_doc_line_id = cl.payment_req_ln_id) payment_date, --��ͬͶ��ʱ��
(SELECT hd.description
   FROM hls_document_type hd
  WHERE hd.document_type = c.document_type) document_type_n,
--c.business_type_n, --ҵ������
--c.lease_channel_n, --��Ʒ����
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
  WHERE f.company_id = c.company_id) company_short_name, --Ͷ�Ź�˾
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
            AND nvl(h.enabled_flag, 'N') = 'Y')) industry_n, --��ҵ
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
            AND nvl(h.enabled_flag, 'N') = 'Y')) invest_policy_n, --Ͷ������
(SELECT h.area FROM hls_bp_master h WHERE h.bp_id = c.bp_id_tenant) area, --����
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
                             AND rownum = 1)) city_district_n, --����
nvl(c.total_rental, 0) -
(SELECT SUM(nvl(ccc.received_amount, 0))
   FROM con_contract_cashflow ccc
  WHERE ccc.contract_id = c.contract_id
    AND ccc.cf_type = 1
    AND ccc.cf_item = 1
    AND ccc.cf_status = 'RELEASE') last_rental, --δ������ܶ�
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
    AND ccc.cf_status = 'RELEASE') last_interest, --δ����Ϣ�ܶ�
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
    AND ccc.cf_status = 'RELEASE') last_principal, --δ�ձ����ܶ�
c.telex_transfer_bank_id_n, --�ؿ��˻�
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
c.pay_type_n, --���ⷽʽ
c.int_rate,
--c.int_rate_type_n, --��������
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
       '��',
       '��') v01_deduction_type,
nvl(c.deposit, 0) deposit,
decode((SELECT COUNT(1)
         FROM csh_write_off co, csh_transaction ct
        WHERE co.contract_id = c.contract_id
          AND co.cf_item = 51
          AND co.csh_transaction_id = ct.transaction_id
          AND ct.transaction_type = 'DEDUCTION'),
       0,
       '��',
       '��') deposit_deduction_type,
c.residual_value, --�������
c.five_class_code,
decode((SELECT COUNT(*)
         FROM prj_bp_guarantor_lv pv
        WHERE pv.project_id = c.project_id
          AND pv.ref_v03 IS NOT NULL),
       0,
       '��',
       '��') guarantee_desc, --������ʽ����
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
