CREATE OR REPLACE Package csh_transaction_wfl_pkg Is
  /*add by xuls 2016-11-17 用于对收款核销的审批*/

  Procedure workflow_start(p_transaction_id Number,
                           p_user_id        Number,
                           p_type           Varchar2);

  Procedure workflow_end(p_transaction_id Number,
                         p_status         Varchar2,
                         p_user_id        Number,
                         p_instance_id    Number);

  /*增加抵扣功能的 审批*/
  Procedure wf_workflow_start(p_session_id Number, p_user_id Number);

  Procedure wf_workflow_end(p_record_id   Number,
                            p_status      Varchar2,
                            p_user_id     Number,
                            p_instance_id Number);

  /*增加收款退款审批工作流*/
  Procedure return_workflow_start(p_return_id Number, p_user_id Number);

  /*退款审批工作流*/
  Procedure return_workflow_end(p_return_id Number,
                                p_status    Varchar2,
                                p_user_id   Number);

  -- df批量核销审批工作流  add by Liyuan  
  Procedure df_workflow_start(p_transaction_id_num Varchar2,
                              p_user_id            Number,
                              p_type               Varchar2);
  -- end add by Liyuan
  Function get_wfl_check(p_bp_id Number) Return Varchar2;
End;
/
CREATE OR REPLACE Package Body csh_transaction_wfl_pkg Is
  /*add by xuls 2016-11-17 用于对收款核销的审批*/

  Procedure workflow_start(p_transaction_id Number,
                           p_user_id        Number,
                           p_type           Varchar2) Is
    r_csh_transaction csh_transaction%Rowtype;
    e_status Exception;
    v_instance_id Number;
    v_workflow_id Number;
    r_csh_wf_tmp  csh_write_off_temp_wfl%Rowtype;
    r_record      hls_common_wfl%Rowtype;
    v_type        Varchar2(100);
    v_bp_name     Varchar2(200);
  Begin
    Select ct.*
      Into r_csh_transaction
      From csh_transaction ct
     Where ct.transaction_id = p_transaction_id;
  
    If nvl(r_csh_transaction.status, 'NEW') = 'APPROVING' Then
      --如果是审批中，则提示状态错误
      Raise e_status;
    End If;
    --v_instance_id := r_csh_transaction.wfl_instance_id;
  
    Select hdt.workflow_id
      Into v_workflow_id
      From hls_document_type hdt
     Where hdt.enabled_flag = 'Y'
       And hdt.document_category = 'CSH_TRX'
       And document_type = 'RECEIPT'
       And approval_method = 'WORK_FLOW';
    Begin
      Select hm.bp_name
        Into v_bp_name
        From csh_transaction ct, hls_bp_master hm
       Where ct.transaction_id = p_transaction_id
         And ct.bp_id = hm.bp_id;
    Exception
      When Others Then
        Null;
    End;
  
    If p_type = 'DEPOSIT' Then
      v_type := '经销商保证金抵扣债权';
    Elsif p_type = 'RISK' Then
      v_type := '风险金抵扣债权';
    Elsif p_type = 'RECEIPT_CREDIT' Then
      v_type := '收款核销债权';
    End If;
  
    Update csh_transaction ct --切记不能更改instance_id
       Set ct.status           = 'APPROVING',
           ct.last_update_date = Sysdate,
           ct.last_updated_by  = p_user_id
     Where ct.transaction_id = p_transaction_id;
  
    zj_wfl_workflow_start_pkg.workflow_start(p_instance_id       => v_instance_id,
                                             p_workflow_id       => v_workflow_id,
                                             p_company_id        => r_csh_transaction.company_id,
                                             p_user_id           => p_user_id,
                                             p_parameter_1       => 'TRANSACTION_ID',
                                             p_parameter_1_value => r_csh_transaction.transaction_id,
                                             p_parameter_2       => 'TRANSACTION_NUM',
                                             p_parameter_2_value => r_csh_transaction.transaction_num,
                                             p_parameter_3       => 'TRANSACTION_TYPE',
                                             p_parameter_3_value => r_csh_transaction.transaction_type,
                                             p_parameter_4       => 'SUBMIT_BY',
                                             p_parameter_4_value => p_user_id,
                                             p_parameter_5       => 'DOCUMENT_INFO',
                                             p_parameter_5_value => r_csh_transaction.transaction_num || ' ' ||
                                                                    v_bp_name ||
                                                                    v_type);
  
    r_record.record_id         := hls_common_wfl_s.nextval;
    r_record.wfl_instance_id   := v_instance_id;
    r_record.document_category := 'CSH_TRX';
    r_record.document_type     := 'RECEIPT';
    r_record.status            := 'APPROVING';
    r_record.creation_date     := Sysdate;
    r_record.created_by        := p_user_id;
    r_record.last_update_date  := Sysdate;
    r_record.last_updated_by   := p_user_id;
    r_record.document_id       := r_csh_transaction.transaction_id;
    Insert Into hls_common_wfl Values r_record;
    /*插入 工作流数据*/
    r_csh_transaction.wfl_instance_id := v_instance_id;
    Insert Into csh_transaction_wfl Values r_csh_transaction;
    Update csh_write_off_temp c
       Set c.wfl_instance_id = v_instance_id
     Where c.transaction_id = p_transaction_id;
  
    Insert Into csh_write_off_temp_wfl
      Select o."SESSION_ID",
             o."WRITE_OFF_TYPE",
             o."TRANSACTION_CATEGORY",
             o."TRANSACTION_TYPE",
             o."WRITE_OFF_DATE",
             o."WRITE_OFF_DUE_AMOUNT",
             o."WRITE_OFF_PRINCIPAL",
             o."WRITE_OFF_INTEREST",
             o."WRITE_OFF_DUE_AMOUNT_CNY",
             o."WRITE_OFF_PRINCIPAL_CNY",
             o."WRITE_OFF_INTEREST_CNY",
             o."EXCHANGE_RATE",
             o."COMPANY_ID",
             o."DOCUMENT_CATEGORY",
             o."DOCUMENT_ID",
             o."DOCUMENT_LINE_ID",
             o."DESCRIPTION",
             o."CREATION_DATE",
             o."CREATED_BY",
             o."LAST_UPDATE_DATE",
             o."LAST_UPDATED_BY",
             o."SUBSEQUENT_CSH_BP_ID",
             o."SUB_WRITE_OFF_TYPE",
             o."OPPOSITE_DOC_CATEGORY",
             o."OPPOSITE_DOC_TYPE",
             o."OPPOSITE_DOC_ID",
             o."OPPOSITE_DOC_LINE_ID",
             o."OPPOSITE_DOC_DETAIL_ID",
             o."OPPOSITE_WRITE_OFF_AMOUNT",
             o."TRANSACTION_ID",
             o."TEMP_ID",
             o."BP_ID",
             o."YEAR_FLAG",
             o."QUARTER_FLAG",
             o."MONTH_FLAG",
             o."TRANSFER_TYPE",
             o."WFL_INSTANCE_ID",
             o."RISK_IN_DEC",
             o.write_off_id
        From csh_write_off_temp o
       Where o.transaction_id = p_transaction_id;
    /*for c_write_temps in (select *from csh_write_off_temp ot where ot.transaction_id = p_transaction_id) loop
      r_csh_wf_tmp.session_id := c_write_temps.session_id;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
    end loop;*/
  
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在审批中请别重复提交',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End workflow_start;

  Procedure workflow_end(p_transaction_id Number,
                         p_status         Varchar2,
                         p_user_id        Number,
                         p_instance_id    Number) Is
    r_csh_transaction csh_transaction%Rowtype;
    e_status Exception;
  Begin
    Select ct.*
      Into r_csh_transaction
      From csh_transaction ct
     Where ct.transaction_id = p_transaction_id;
  
    If nvl(r_csh_transaction.status, 'NEW') != 'APPROVING' Then
      --如果不是审批中，则提示状态错误
      Raise e_status;
    End If;
    Update csh_transaction ct
       Set ct.status           = p_status,
           ct.last_update_date = Sysdate,
           ct.last_updated_by  = p_user_id
     Where ct.transaction_id = p_transaction_id;
    Update csh_transaction_wfl t
       Set t.status           = p_status,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = p_transaction_id
       And t.wfl_instance_id = p_instance_id;
  
    Update hls_common_wfl c
       Set c.status           = p_status,
           c.last_update_date = Sysdate,
           c.last_updated_by  = p_user_id
     Where c.wfl_instance_id = p_instance_id;
  
    If p_status = 'APPROVED' Then
      --如果审批通过，执行核销
    
      csh_write_off_pkg.main_write_off_new(p_transaction_id => p_transaction_id,
                                           p_user_id        => p_user_id);
    End If;
  Exception
  
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据状态有误，请联系系统管理员',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'workflow_end');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'workflow_end');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End workflow_end;

  /*增加抵扣功能的 审批*/
  Procedure wf_workflow_start(p_session_id Number, p_user_id Number) Is
    e_status Exception;
    v_instance_id     Number;
    v_workflow_id     Number;
    r_cwo_tmp         csh_write_off_temp%Rowtype;
    v_cashflow_id     Number;
    v_count           Number;
    V_RECORD_ID       Number;
    r_record          hls_common_wfl%Rowtype;
    v_bp_name         Varchar2(100);
    v_contract_number Varchar2(100);
  Begin
    Select t.*
      Into r_cwo_tmp
      From csh_write_off_temp t
     Where t.session_id = p_session_id
       And t.write_off_type = 'PAYMENT_DEBT'
       And t.wfl_instance_id Is Null
       And t.transaction_id Is Null;
  
    Select cc.contract_number, hm.bp_name
      Into v_contract_number, v_bp_name
      From con_contract cc, hls_bp_master hm
     Where r_cwo_tmp.document_id = cc.contract_id
       And cc.bp_id_agent_level1 = hm.bp_id;
  
    Select Count(*)
      Into v_count
      From hls_common_wfl c
     Where c.document_category = 'CSH_TRX'
       And c.document_type = 'DEDUCTION'
       And c.status = 'APPROVING'
       And c.document_id = r_cwo_tmp.document_line_id;
    If v_count > 0 Then
      Raise e_status;
    End If;
    V_RECORD_ID := hls_common_wfl_s.nextval;
  
    Select hdt.workflow_id
      Into v_workflow_id
      From hls_document_type hdt
     Where hdt.enabled_flag = 'Y'
       And hdt.document_category = 'CSH_TRX'
       And document_type = 'DEDUCTION'
       And approval_method = 'WORK_FLOW';
  
    zj_wfl_workflow_start_pkg.workflow_start(p_instance_id       => v_instance_id,
                                             p_workflow_id       => v_workflow_id,
                                             p_company_id        => r_cwo_tmp.company_id,
                                             p_user_id           => p_user_id,
                                             p_parameter_1       => 'RECORD_ID',
                                             p_parameter_1_value => V_RECORD_ID,
                                             p_parameter_2       => 'DOCUMENT_INFO',
                                             p_parameter_2_value => v_bp_name || '-' ||
                                                                    v_contract_number,
                                             p_parameter_3       => 'CASHFLOW_ID',
                                             p_parameter_3_value => r_cwo_tmp.document_line_id,
                                             p_parameter_4       => 'SUBMIT_BY',
                                             p_parameter_4_value => p_user_id);
    r_record.record_id         := V_RECORD_ID;
    r_record.wfl_instance_id   := v_instance_id;
    r_record.document_category := 'CSH_TRX';
    r_record.document_type     := 'DEDUCTION';
    r_record.status            := 'APPROVING';
    r_record.creation_date     := Sysdate;
    r_record.created_by        := p_user_id;
    r_record.last_update_date  := Sysdate;
    r_record.last_updated_by   := p_user_id;
    r_record.document_id       := r_cwo_tmp.document_line_id;
  
    Insert Into hls_common_wfl Values r_record;
  
    Insert Into CON_CONTRACT_CASHFLOW_wfl
      Select o."CASHFLOW_ID",
             o."CONTRACT_ID",
             o."CF_ITEM",
             o."CF_TYPE",
             o."CF_DIRECTION",
             o."CF_STATUS",
             o."TIMES",
             o."CALC_DATE",
             o."DUE_DATE",
             o."FIN_INCOME_DATE",
             o."DUE_AMOUNT",
             o."NET_DUE_AMOUNT",
             o."VAT_DUE_AMOUNT",
             o."PRINCIPAL",
             o."NET_PRINCIPAL",
             o."VAT_PRINCIPAL",
             o."INTEREST",
             o."NET_INTEREST",
             o."VAT_INTEREST",
             o."PRINCIPAL_IMPLICIT_RATE",
             o."NET_PRINCIPAL_IMPLICIT",
             o."VAT_PRINCIPAL_IMPLICIT",
             o."INTEREST_IMPLICIT_RATE",
             o."NET_INTEREST_IMPLICIT",
             o."VAT_INTEREST_IMPLICIT",
             o."OUTSTANDING_RENTAL",
             o."OUTSTANDING_PRINCIPAL",
             o."OUTSTANDING_INTEREST",
             o."INTEREST_ACCRUAL_BALANCE",
             o."ACCUMULATED_UNPAID_INTEREST",
             o."INTEREST_PERIOD_DAYS",
             o."DISCOUNTING_DAYS",
             o."FIX_PRINCIPAL_FLAG",
             o."FIX_RENTAL_FLAG",
             o."INTEREST_ONLY_FLAG",
             o."EQUAL_FLAG",
             o."MANUAL_FLAG",
             o."BEGINNING_OF_LEASE_YEAR",
             o."SALESTAX",
             o."GENERATED_SOURCE",
             o."GENERATED_SOURCE_DOC_ID",
             o."COLOUR_SCHEME",
             o."ALERT_SCHEME",
             o."CALC_LINE_ID",
             o."OVERDUE_STATUS",
             o."OVERDUE_BOOK_DATE",
             o."OVERDUE_MAX_DAYS",
             o."OVERDUE_AMOUNT",
             o."OVERDUE_PRINCIPAL",
             o."OVERDUE_INTEREST",
             o."OVERDUE_REMARK",
             o."RECEIVED_AMOUNT",
             o."RECEIVED_PRINCIPAL",
             o."RECEIVED_INTEREST",
             o."WRITE_OFF_FLAG",
             o."LAST_RECEIVED_DATE",
             o."FULL_WRITE_OFF_DATE",
             o."PENALTY_PROCESS_STATUS",
             o."BILLING_STATUS",
             o."BILLING_AMOUNT",
             o."BILLING_PRINCIPAL",
             o."BILLING_INTEREST",
             o."RENTAL_EQ_PYMT_RAW",
             o."RENTAL_EQ_PYMT_ADJ",
             o."INTEREST_EQ_PYMT_RAW",
             o."INTEREST_EQ_PYMT_ADJ",
             o."PRINCIPAL_EQ_PYMT_RAW",
             o."PRINCIPAL_EQ_PYMT_ADJ",
             o."RENTAL_EQ_PRIN_RAW",
             o."RENTAL_EQ_PRIN_ADJ",
             o."INTEREST_EQ_PRIN_RAW",
             o."INTEREST_EQ_PRIN_ADJ",
             o."PRINCIPAL_EQ_PRIN_RAW",
             o."PRINCIPAL_EQ_PRIN_ADJ",
             o."LN_USER_COL_D01",
             o."LN_USER_COL_D02",
             o."LN_USER_COL_D03",
             o."LN_USER_COL_D04",
             o."LN_USER_COL_D05",
             o."LN_USER_COL_V01",
             o."LN_USER_COL_V02",
             o."LN_USER_COL_V03",
             o."LN_USER_COL_V04",
             o."LN_USER_COL_V05",
             o."LN_USER_COL_N01",
             o."LN_USER_COL_N02",
             o."LN_USER_COL_N03",
             o."LN_USER_COL_N04",
             o."LN_USER_COL_N05",
             o."LN_USER_COL_N06",
             o."LN_USER_COL_N07",
             o."LN_USER_COL_N08",
             o."LN_USER_COL_N09",
             o."LN_USER_COL_N10",
             o."LN_USER_COL_N11",
             o."LN_USER_COL_N12",
             o."LN_USER_COL_N13",
             o."LN_USER_COL_N14",
             o."LN_USER_COL_N15",
             o."LN_USER_COL_N16",
             o."LN_USER_COL_N17",
             o."LN_USER_COL_N18",
             o."LN_USER_COL_N19",
             o."LN_USER_COL_N20",
             o."OUTSTANDING_RENTAL_TAX_INCLD",
             o."OUTSTANDING_PRIN_TAX_INCLD",
             o."OUTSTANDING_INT_TAX_INCLD",
             o."INTEREST_ACCRUAL_BAL_TAX_INCL",
             o."ACCUMULATED_UNPD_INT_TAX_INCL",
             o."EXCHANGE_RATE_TYPE",
             o."EXCHANGE_RATE_QUOTATION",
             o."EXCHANGE_RATE",
             o."DUE_AMOUNT_FUNC",
             o."MAIN_BUSINESS_INCOME",
             o."MAIN_BUSINESS_COST",
             o."FINANCING_COST",
             o."DUE_AMOUNT_CNY",
             o."PRINCIPAL_CNY",
             o."INTEREST_CNY",
             o."RECEIVED_AMOUNT_CNY",
             o."RECEIVED_PRINCIPAL_CNY",
             o."RECEIVED_INTEREST_CNY",
             o."LEASE_YEAR",
             o."QUARTER_NUM",
             o."PERIOD_NUM",
             o."TT_BANK_ACCOUNT_ID_1",
             o."TT_BANK_ACCOUNT_NUM_1",
             o."TT_ACCOUNT_1_AMT",
             o."TT_BANK_ACCOUNT_ID_2",
             o."TT_BANK_ACCOUNT_NUM_2",
             o."TT_ACCOUNT_2_AMT",
             o."TT_BANK_ACCOUNT_ID_3",
             o."TT_BANK_ACCOUNT_NUM_3",
             o."TT_ACCOUNT_3_AMT",
             o."CREATED_BY",
             o."CREATION_DATE",
             o."LAST_UPDATED_BY",
             o."LAST_UPDATE_DATE",
             o."ESTIMATED_DUE_AMOUNT",
             o."ESTIMATED_NET_DUE_AMOUNT",
             o."ESTIMATED_VAT_DUE_AMOUNT",
             o."PAYMENT_DEDUCTION_FLAG",
             o."PAYMENT_DEDUCTION_AMOUNT",
             o."CASHFLOW_EXTEND_ID",
             o."TAX_TYPE_ID",
             o."TAX_TYPE_RATE",
             o."RECEIVABLES_TYPE",
             v_instance_id
        From con_contract_cashflow o
       Where o.cashflow_id = r_record.document_id;
  
    Update csh_write_off_temp c
       Set c.wfl_instance_id = v_instance_id
     Where c.session_id = p_session_id
       And c.wfl_instance_id Is Null
       And c.transaction_id Is Null;
    Insert Into csh_write_off_temp_wfl
      Select *
        From csh_write_off_temp
       Where session_id = p_session_id
         And wfl_instance_id = v_instance_id
         And transaction_id Is Null;
  
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在审批中，请不要重复提交',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'wf_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'wf_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End wf_workflow_start;

  /*抵扣工作流结束*/
  Procedure wf_workflow_end(p_record_id   Number,
                            p_status      Varchar2,
                            p_user_id     Number,
                            p_instance_id Number) Is
    r_wfl hls_common_wfl%Rowtype;
    e_status Exception;
    v_transaction_id Number;
    v_company_id     Number;
    v_bp_id          Number;
  Begin
    Select w.*
      Into r_wfl
      From hls_common_wfl w
     Where w.record_id = p_record_id;
    Select cc.bp_id_tenant, cc.company_id
      Into v_bp_id, v_company_id
      From con_contract_cashflow ca, con_contract cc
     Where ca.cashflow_id = r_wfl.document_id
       And ca.contract_id = cc.contract_id
       And cc.data_class = 'NORMAL'
       And rownum = 1;
  
    Update hls_common_wfl l
       Set l.status           = p_status,
           l.last_update_date = Sysdate,
           l.last_updated_by  = p_user_id
     Where l.record_id = p_record_id
       And l.wfl_instance_id = p_instance_id;
    If p_status = 'APPROVED' Then
      --如果审批通过，执行抵扣
      --风险金核销债权后 add by zyx 2017-04-21
      For rec In (Select cot.write_off_due_amount
                    From csh_write_off_temp cot, con_contract_cashflow ccc
                   Where cot.document_id = ccc.contract_id
                     And cot.document_line_id = ccc.cashflow_id
                     And ccc.cf_item = 56
                     And cot.wfl_instance_id = p_instance_id) Loop
        Update csh_transaction ct
           Set ct.transaction_amount = ct.transaction_amount +
                                       rec.write_off_due_amount
         Where ct.transaction_type = 'RISK';
      End Loop;
      --应收经销商保证金核销债权后 add by zyx 2017-04-21
      For rec In (Select cot.write_off_due_amount, cot.document_id
                    From csh_write_off_temp cot, con_contract_cashflow ccc
                   Where cot.document_id = ccc.contract_id
                     And cot.document_line_id = ccc.cashflow_id
                     And ccc.cf_item = 55
                     And cot.wfl_instance_id = p_instance_id) Loop
        Update csh_transaction ct
           Set ct.transaction_amount = ct.transaction_amount +
                                       rec.write_off_due_amount
         Where ct.transaction_type = 'DEPOSIT'
           And ct.returned_flag != 'RETURN'
           And ct.bp_id =
               (Select cc.bp_id_agent_level1
                  From con_contract cc
                 Where cc.contract_id = rec.document_id);
      End Loop;
      csh_write_off_pkg.deduction_write_off_wfl(p_instance_id      => p_instance_id,
                                                p_company_id       => v_company_id,
                                                p_bp_id            => v_bp_id,
                                                p_transaction_date => trunc(Sysdate),
                                                p_description      => Null,
                                                p_user_id          => p_user_id,
                                                p_transaction_id   => v_transaction_id);
      --csh_write_off_pkg.main_write_off_new(p_transaction_id => p_transaction_id,p_user_id => p_user_id);
    Else
      --否则清除记录
      Delete From csh_write_off_temp t
       Where t.wfl_instance_id = p_instance_id;
    End If;
  
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据状态有误，请联系系统管理员',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'wf_workflow_end');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'wf_workflow_end');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End wf_workflow_end;

  /*增加收款退款审批工作流*/
  Procedure return_workflow_start(p_return_id Number, p_user_id Number) Is
    e_status Exception;
    v_instance_id     Number;
    v_workflow_id     Number;
    r_return          csh_transaction_return%Rowtype;
    v_company_id      Number;
    v_ctr_type        Varchar2(30);
    v_type_desc       Varchar2(100);
    v_document_number Varchar2(30);
    v_bp_name         Varchar2(100);
  Begin
    Select c.*
      Into r_return
      From csh_transaction_return c
     Where c.return_id = p_return_id;
  
    Select l.transaction_type, l.company_id, l.transaction_num, hm.bp_name
      Into v_ctr_type, v_company_id, v_document_number, v_bp_name
      From csh_transaction l, hls_bp_master hm
     Where l.transaction_id = r_return.transaction_id
       And hm.bp_id = l.bp_id;
  
    Select scv.code_value_name
      Into v_type_desc
      From sys_code_values_v scv
     Where scv.code = 'CSH511_TRANSACTION_TYPE'
       And scv.code_value = v_ctr_type;
  
    If nvl(r_return.status, 'NEW') Not In ('NEW', 'REJECT') Then
      Raise e_status;
    End If;
    Select hdt.workflow_id
      Into v_workflow_id
      From hls_document_type hdt
     Where hdt.enabled_flag = 'Y'
       And hdt.document_category = 'CSH_TRX'
       And document_type = 'RETURN'
       And approval_method = 'WORK_FLOW';
  
    zj_wfl_workflow_start_pkg.workflow_start(p_instance_id       => v_instance_id,
                                             p_workflow_id       => v_workflow_id,
                                             p_company_id        => v_company_id,
                                             p_user_id           => p_user_id,
                                             p_parameter_1       => 'RETURN_ID',
                                             p_parameter_1_value => r_return.return_id,
                                             p_parameter_2       => 'DOCUMENT_INFO',
                                             p_parameter_2_value => v_document_number || '-' ||
                                                                    v_bp_name ||
                                                                    '-退款金额' ||
                                                                    r_return.this_return_amount,
                                             p_parameter_3       => 'DOCUMENT_TYPE',
                                             p_parameter_3_value => v_ctr_type,
                                             p_parameter_4       => 'SUBMIT_BY',
                                             p_parameter_4_value => p_user_id,
                                             p_parameter_5       => 'DOCUMENT_NUMBER',
                                             p_parameter_5_value => v_document_number);
    Update csh_transaction_return l
       Set l.wfl_instance_id = v_instance_id, l.status = 'APPROVING'
     Where l.return_id = p_return_id;
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据状态有误，请联系系统管理员',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'return_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'return_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End return_workflow_start;
  /*退款审批工作流*/
  Procedure return_workflow_end(p_return_id Number,
                                p_status    Varchar2,
                                p_user_id   Number) Is
    e_status Exception;
    r_return csh_transaction_return%Rowtype;
  Begin
    Select c.*
      Into r_return
      From csh_transaction_return c
     Where c.return_id = p_return_id;
  
    /*if nvl(r_return.status,'NEW') != 'APPROVING' then
      raise e_status;
    end if; */
    Update csh_transaction_return l
       Set l.status           = p_status,
           l.last_update_date = Sysdate,
           l.last_updated_by  = p_user_id
     Where l.return_id = p_return_id;
  
    If p_status = 'APPROVED' Then
      CSH_TRANSACTION_PKG.RETURN_CSH_TRANSACTION(p_transaction_id      => r_return.transaction_id,
                                                 p_returned_date       => r_return.return_date,
                                                 p_returned_amount     => r_return.this_return_amount,
                                                 p_bank_slip_num       => Null,
                                                 p_payment_method_id   => Null,
                                                 p_bank_account_id     => r_return.bank_account_id,
                                                 p_bp_bank_account_id  => r_return.bp_bank_account_id,
                                                 p_bp_bank_account_num => r_return.bp_bank_account_num,
                                                 p_description         => r_return.notes,
                                                 p_user_id             => p_user_id);
    End If;
  
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据状态有误，请联系系统管理员',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'return_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'return_workflow_end');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  End return_workflow_end;

  Function get_wfl_check(p_bp_id Number) Return Varchar2 Is
    v_count      Number := 0;
    v_count1     Number := 0;
    v_check_flag Varchar2(1);
  Begin
    Select Count(*)
      Into v_count
      From csh_write_off_temp cot, zj_wfl_workflow_instance zi
     Where cot.wfl_instance_id = zi.instance_id
       And zi.status = 1
       And cot.transaction_id In
           (Select ct.transaction_id
              From csh_transaction ct
             Where ct.bp_id = p_bp_id
               And (ct.transaction_type = 'N' Or
                   ct.transaction_type = 'DEPOSIT'));
  
    /*      select count(*)  
    into v_count
    from csh_write_off_temp cot,zj_wfl_workflow_instance zi 
    where cot.wfl_instance_id=zi.instance_id
    and zi.status = 1
    and cot.bp_id= p_bp_id;*/
  
    Select Count(*)
      Into v_count1
      From csh_transaction_return cr, zj_wfl_workflow_instance zi
     Where cr.wfl_instance_id = zi.instance_id
       And zi.status = 1
       And cr.bp_id = p_bp_id;
  
    If v_count > 0 And v_count1 > 0 Then
      v_check_flag := 'Y';
    Elsif v_count > 0 And v_count1 = 0 Then
      v_check_flag := 'D';
    Elsif v_count = 0 And v_count1 > 0 Then
      v_check_flag := 'R';
    Else
      v_check_flag := 'N';
    End If;
    Return v_check_flag;
  End get_wfl_check;
  
  -- add by Liyuan df批量审批
  Procedure df_workflow_start(p_transaction_id_num Varchar2,
                              p_user_id            Number,
                              p_type               Varchar2) Is
    r_csh_transaction csh_transaction%Rowtype;
    e_status Exception;
    v_instance_id Number;
    v_workflow_id Number;
    r_csh_wf_tmp  csh_write_off_temp_wfl%Rowtype;
    r_record      hls_common_wfl%Rowtype;
    v_type        Varchar2(100);
    v_bp_name     Varchar2(200);
  Begin
  
    For i_transaction_id In (Select REGEXP_SUBSTR(p_transaction_id_num,
                                                  '[^;]+',
                                                  1,
                                                  rownum) As transaction_id
                             
                               From dual
                             Connect By rownum <=
                                        LENGTH(p_transaction_id_num) -
                                        LENGTH(regexp_replace(p_transaction_id_num,
                                                              ';',
                                                              ''))) Loop
      Select ct.*
        Into r_csh_transaction
        From csh_transaction ct
       Where ct.transaction_id = i_transaction_id.transaction_id;
    
      If nvl(r_csh_transaction.status, 'NEW') = 'APPROVING' Then
        --如果是审批中，则提示状态错误
        Raise e_status;
      End If;
      --v_instance_id := r_csh_transaction.wfl_instance_id;
    
      Select hdt.workflow_id
        Into v_workflow_id
        From hls_document_type hdt
       Where hdt.enabled_flag = 'Y'
         And hdt.document_category = 'CSH_TRX'
         And document_type = 'RECEIPT'
         And approval_method = 'WORK_FLOW';
      Begin
        Select hm.bp_name
          Into v_bp_name
          From csh_transaction ct, hls_bp_master hm
         Where ct.transaction_id = i_transaction_id.transaction_id
           And ct.bp_id = hm.bp_id;
      Exception
        When Others Then
          Null;
      End;
    
      If p_type = 'DEPOSIT' Then
        v_type := '经销商保证金抵扣债权';
      Elsif p_type = 'RISK' Then
        v_type := '风险金抵扣债权';
      Elsif p_type = 'RECEIPT_CREDIT' Then
        v_type := '收款核销债权';
      End If;
    
      Update csh_transaction ct --切记不能更改instance_id
         Set ct.status           = 'APPROVING',
             ct.last_update_date = Sysdate,
             ct.last_updated_by  = p_user_id
       Where ct.transaction_id = i_transaction_id.transaction_id;
    
      zj_wfl_workflow_start_pkg.workflow_start(p_instance_id       => v_instance_id,
                                               p_workflow_id       => v_workflow_id,
                                               p_company_id        => r_csh_transaction.company_id,
                                               p_user_id           => p_user_id,
                                               p_parameter_1       => 'TRANSACTION_ID',
                                               p_parameter_1_value => r_csh_transaction.transaction_id,
                                               p_parameter_2       => 'TRANSACTION_NUM',
                                               p_parameter_2_value => r_csh_transaction.transaction_num,
                                               p_parameter_3       => 'TRANSACTION_TYPE',
                                               p_parameter_3_value => r_csh_transaction.transaction_type,
                                               p_parameter_4       => 'SUBMIT_BY',
                                               p_parameter_4_value => p_user_id,
                                               p_parameter_5       => 'DOCUMENT_INFO',
                                               p_parameter_5_value => r_csh_transaction.transaction_num || ' ' ||
                                                                      v_bp_name ||
                                                                      v_type);
    
      r_record.record_id         := hls_common_wfl_s.nextval;
      r_record.wfl_instance_id   := v_instance_id;
      r_record.document_category := 'CSH_TRX';
      r_record.document_type     := 'RECEIPT';
      r_record.status            := 'APPROVING';
      r_record.creation_date     := Sysdate;
      r_record.created_by        := p_user_id;
      r_record.last_update_date  := Sysdate;
      r_record.last_updated_by   := p_user_id;
      r_record.document_id       := r_csh_transaction.transaction_id;
      Insert Into hls_common_wfl Values r_record;
      /*插入 工作流数据*/
      r_csh_transaction.wfl_instance_id := v_instance_id;
      Insert Into csh_transaction_wfl Values r_csh_transaction;
      Update csh_write_off_temp c
         Set c.wfl_instance_id = v_instance_id
       Where c.transaction_id = i_transaction_id.transaction_id;
    
      Insert Into csh_write_off_temp_wfl
        Select o."SESSION_ID",
               o."WRITE_OFF_TYPE",
               o."TRANSACTION_CATEGORY",
               o."TRANSACTION_TYPE",
               o."WRITE_OFF_DATE",
               o."WRITE_OFF_DUE_AMOUNT",
               o."WRITE_OFF_PRINCIPAL",
               o."WRITE_OFF_INTEREST",
               o."WRITE_OFF_DUE_AMOUNT_CNY",
               o."WRITE_OFF_PRINCIPAL_CNY",
               o."WRITE_OFF_INTEREST_CNY",
               o."EXCHANGE_RATE",
               o."COMPANY_ID",
               o."DOCUMENT_CATEGORY",
               o."DOCUMENT_ID",
               o."DOCUMENT_LINE_ID",
               o."DESCRIPTION",
               o."CREATION_DATE",
               o."CREATED_BY",
               o."LAST_UPDATE_DATE",
               o."LAST_UPDATED_BY",
               o."SUBSEQUENT_CSH_BP_ID",
               o."SUB_WRITE_OFF_TYPE",
               o."OPPOSITE_DOC_CATEGORY",
               o."OPPOSITE_DOC_TYPE",
               o."OPPOSITE_DOC_ID",
               o."OPPOSITE_DOC_LINE_ID",
               o."OPPOSITE_DOC_DETAIL_ID",
               o."OPPOSITE_WRITE_OFF_AMOUNT",
               o."TRANSACTION_ID",
               o."TEMP_ID",
               o."BP_ID",
               o."YEAR_FLAG",
               o."QUARTER_FLAG",
               o."MONTH_FLAG",
               o."TRANSFER_TYPE",
               o."WFL_INSTANCE_ID",
               o."RISK_IN_DEC",
               o.write_off_id
          From csh_write_off_temp o
         Where o.transaction_id = i_transaction_id.transaction_id;
      /*for c_write_temps in (select *from csh_write_off_temp ot where ot.transaction_id = p_transaction_id) loop
        r_csh_wf_tmp.session_id := c_write_temps.session_id;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
        r_csh_wf_tmp.write_off_type      := c_write_temps.write_off_type;
      end loop;*/
    
    End Loop;
  
  Exception
    When e_status Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在审批中请别重复提交',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'df_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_wfl_pkg',
                                                     p_procedure_function_name => 'df_workflow_start');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End df_workflow_start;
  -- end add by Liyuan 
End csh_transaction_wfl_pkg;
/
