CREATE OR REPLACE VIEW CON_CONTRACT_CASHFLOW_DEF_LV AS
select t1.cashflow_id,
       t1.contract_id,
       t1.cf_item,
       cf.description as cf_item_n,
       t1.cf_type,
       cft.description as cf_type_n,
       t1.cf_direction cf_direction_pic,
      -- t1.cf_direction,
     --  (SELECT V.code_value_name
      --    FROM SYS_CODE_VALUES_V V
      --  WHERE V.code = 'HLS005_CF_DIRECTION'
      --     AND V.code_value = t1.cf_direction) as cf_direction_n,
       t1.cf_status,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'HLS005_CF_STATUS'
           AND V.code_value = t1.cf_status) as cf_status_n,
          t1.CF_DIRECTION,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CF_DIRECTION'
           AND V.code_value = t1.CF_DIRECTION) as CF_DIRECTION_N,
       t1.times,
       t1.calc_date,
       t1.due_date,
       to_char(t1.due_date,'yyyy-mm-dd')due_date_c,
       t1.due_amount,
       t1.overdue_max_days,
       t1.principal,
       t1.interest,
       t1.outstanding_rental,
       t1.outstanding_principal,
       t1.outstanding_interest,
       t1.interest_accrual_balance,
       t1.accumulated_unpaid_interest,
       t1.outstanding_rental_tax_incld,
       t1.outstanding_prin_tax_incld,
       t1.outstanding_int_tax_incld,
       t1.interest_accrual_bal_tax_incl,
       t1.accumulated_unpd_int_tax_incl,
       t1.principal_implicit_rate,
       t1.interest_implicit_rate,
       t1.interest_period_days,
       t1.discounting_days,
       t1.vat_due_amount,
       t1.vat_principal,
       t1.vat_interest,
       t1.vat_principal_implicit,
       t1.vat_interest_implicit,
       t1.net_due_amount,
       t1.net_principal,
       t1.net_interest,
       t1.net_principal_implicit,
       t1.net_interest_implicit,
       t1.fix_principal_flag,
       t1.fix_rental_flag,
       t1.interest_only_flag,
       t1.equal_flag,
       t1.manual_flag,
       t1.beginning_of_lease_year,
       t1.salestax,
       t1.generated_source,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CON_GENERATED_SOURCE'
           AND V.code_value = t1.generated_source) as generated_source_n,
       t1.generated_source_doc_id,
       t1.colour_scheme,
       t1.alert_scheme,
       t1.calc_line_id,
       t1.overdue_status,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CON_OVERDUE_STATUS'
           AND V.code_value = t1.overdue_status) as overdue_status_n,
       t1.overdue_book_date,
       t1.overdue_amount,
       t1.overdue_principal,
       t1.overdue_interest,
       t1.overdue_remark,
       t1.received_amount,
       t1.received_principal,
       t1.received_interest,
       t1.write_off_flag,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CON_WRITE_OFF_FLAG'
           AND V.code_value = t1.write_off_flag)write_off_flag_n,
       t1.last_received_date,
       t1.full_write_off_date,
       t1.penalty_process_status,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CON_PENALTY_PROCESS_STATUS'
           AND V.code_value = t1.penalty_process_status) as penalty_process_status_n,
       t1.billing_status,
       (SELECT V.code_value_name
          FROM SYS_CODE_VALUES_V V
         WHERE V.code = 'CON_BILLING_STATUS'
           AND V.code_value = t1.billing_status) as billing_status_n,
       t1.billing_amount,
       t1.billing_principal,
       t1.billing_interest,
       t1.rental_eq_pymt_raw,
       t1.rental_eq_pymt_adj,
       t1.interest_eq_pymt_raw,
       t1.interest_eq_pymt_adj,
       t1.principal_eq_pymt_raw,
       t1.principal_eq_pymt_adj,
       t1.rental_eq_prin_raw,
       t1.rental_eq_prin_adj,
       t1.interest_eq_prin_raw,
       t1.interest_eq_prin_adj,
       t1.principal_eq_prin_raw,
       t1.principal_eq_prin_adj,
       t1.exchange_rate_type,
       t1.exchange_rate_quotation,
       t1.exchange_rate,
       t1.tt_bank_account_num_1,
       t1.tt_account_1_amt,
       t1.tt_bank_account_num_2,
       t1.tt_account_2_amt,
       t1.tt_bank_account_num_3,
       t1.tt_account_3_amt,
       t1.tt_bank_account_id_1,
       t1.tt_bank_account_id_2,
       t1.tt_bank_account_id_3,
       t1.ln_user_col_d01,
       t1.ln_user_col_d02,
       t1.ln_user_col_d03,
       t1.ln_user_col_d04,
       t1.ln_user_col_d05,
       t1.ln_user_col_v01,
       t1.ln_user_col_v02,
       t1.ln_user_col_v03,
       t1.ln_user_col_v04,
       t1.ln_user_col_v05,
       t1.ln_user_col_n01,
       t1.ln_user_col_n02,
       t1.ln_user_col_n03,
       t1.ln_user_col_n04,
       t1.ln_user_col_n05,
       t1.ln_user_col_n06,
       t1.ln_user_col_n07,
       t1.ln_user_col_n08,
       t1.ln_user_col_n09,
       t1.ln_user_col_n10,
       t1.ln_user_col_n11,
       t1.ln_user_col_n12,
       t1.ln_user_col_n13,
       t1.ln_user_col_n14,
       t1.ln_user_col_n15,
       t1.ln_user_col_n16,
       t1.ln_user_col_n17,
       t1.ln_user_col_n18,
       t1.ln_user_col_n19,
       t1.ln_user_col_n20,
       t1.created_by,
       t1.creation_date,
       t1.last_updated_by,
       t1.last_update_date,
       t1.estimated_due_amount,
       t1.payment_deduction_flag, -- 收付抵扣标志
       t1.payment_deduction_amount, --收付抵扣金额

       /*
       (select hfc.vat_interest from hls_fin_calculator_ln hfc,con_contract cc where hfc.calc_session_id = cc.calc_session_id and cc.contract_id = t1.contract_id)vat_rental,-- 税金
       (select hfc.net_rental from hls_fin_calculator_ln hfc,con_contract cc where hfc.calc_session_id = cc.calc_session_id and cc.contract_id = t1.contract_id)net_rental,-- 不含税租金
       (select h.vat_rate_of_interest from hls_fin_calculator_hd h,con_contract cc where h.calc_session_id = cc.calc_session_id and cc.contract_id = t1.contract_id)vat_rate_of_interest --税率
 */
     (select hf.vat_interest from hls_fin_calculator_ln hf where hf.calc_line_id = t1.calc_line_id)vat_rental,-- 税金
     (select hf.net_rental from hls_fin_calculator_ln hf where hf.calc_line_id = t1.calc_line_id)net_rental,-- 不含税租金
     (select f.vat_rate_of_interest from hls_fin_calculator_ln h,hls_fin_calculator_hd f where h.calc_session_id = f.calc_session_id and h.calc_line_id = t1.calc_line_id)vat_rate, --税率
   nvl(t1.last_received_date,(select max(wr.write_off_date) from csh_write_off wr where wr.cashflow_id=t1.cashflow_id))last_write_off_date,--add by lara 11355 20181213 库融资金计划实收/付日期
   --add by neo 20180424
  (select sum(al.total_amount)
        from acr_invoice_ln al,acr_invoice_hd ah
       where al.cashflow_id = t1.cashflow_id
         and al.cf_item = 100
         and al.invoice_hd_id=ah.invoice_hd_id
         and ah.invoice_status = 'CONFIRM')ACR_PRINCIPAL,--已开票本金
     (select sum(al.total_amount)
        from acr_invoice_ln al,acr_invoice_hd ah
       where al.cashflow_id = t1.cashflow_id
         and al.cf_item = 101
         and al.invoice_hd_id=ah.invoice_hd_id
         and ah.invoice_status = 'CONFIRM')ACR_INTEREST,--已开票利息
     (select sum(al.total_amount)
        from acr_invoice_ln al,acr_invoice_hd ah
       where al.cashflow_id = t1.cashflow_id
         and al.invoice_hd_id=ah.invoice_hd_id
         and ah.invoice_status = 'CONFIRM')ACR_AMOUNT,--已开票金额
     'A2' as vat_group,--税收组（凭证参考段）
     (select hbm.bp_code
        from con_contract c,hls_bp_master hbm
       where c.contract_id = t1.contract_id
         and c.bp_id_tenant = hbm.bp_id)tenant_code,--承租人编码
     (select hbm.bp_code
        from con_contract c,hls_bp_master hbm
       where c.contract_id = t1.contract_id
         and c.BP_ID_AGENT_LEVEL1 = hbm.bp_id)agent_code,--承租人编码
     (select c.contract_number from con_contract c where c.contract_id = t1.contract_id)contract_number，
     (select cc1.company_id from con_contract cc1
where cc1.contract_id=t1.contract_id)company_id,--公司id
     nvl(t1.output_tax_create_je_flag,'N')output_tax_create_je_flag--销项税凭证生成标志
 from con_contract_cashflow t1,
       hls_cashflow_item cf,
       hls_cashflow_type cft
 where t1.cf_item = cf.cf_item
   and t1.cf_type = cft.cf_type
   AND t1.cf_item != 11
   and t1.cf_type != 11
   and not (t1.times = 0 and t1.cf_direction = 'NONCASH')
order by decode(cf.cf_item, 304, 2, 305, 1, 3) desc, t1.contract_id,t1.cf_direction DESC,t1.times,t1.cf_type desc
;
