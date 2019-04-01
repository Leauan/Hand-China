CREATE OR REPLACE Package yonda_csh_transaction_pkg Is

  /*================================================
     Copyright (C) HAND Business Consulting Services
                 AllRights Reserved
  ==================================================
  * ================================================
  *   PACKAGE NAME: yonda_csh_transaction_pkg
  *
  *   DESCRIPTION:  永达现金事物二开PKG
  *
  *   HISTORY:
  *     1.00  (2015-8-20)  qianming     
  *                     Creation Description
  *
  * ==============================================*/

  Procedure yonda_auto_write_off_log(p_transaction_id  Number Default Null,
                                     p_write_off_id    Number Default Null,
                                     p_bp_id           Number Default Null,
                                     p_contract_id     Number Default Null,
                                     p_bank_account_id Number Default Null,
                                     p_message         Varchar2);
                                     
  -- 仅添加包头 add by Liyuan 
  Function match_bp_by_name(p_bp_name       In Varchar2,
                            p_error_message Out Varchar2) Return Number;
  Function match_contract_by_bp_amount(p_bp_id         In Number,
                                       p_amount        In Number,
                                       p_error_message Out Varchar2)
    Return Number;

  Function get_cashflow_by_contract(p_contract_id   Number,
                                    p_amount        Number,
                                    p_error_message Out Varchar2)
    Return con_contract_cashflow%Rowtype;

  Procedure get_bp_band_account(p_bp_bank_account_num In Varchar2,
                                p_bp_id               Number,
                                p_bp_bank_account_id  Out Number);

  Procedure get_company_band_account(p_company_bank_account_num In Varchar2,
                                     p_bank_account_id          Out Number,
                                     p_currency_code            Out Varchar2);
  
  -- end add by Liyuan
  Procedure auto_transaction_and_write_off(p_batch_id   Number,
                                           p_user_id    Number,
                                           p_company_id Number);

End yonda_csh_transaction_pkg;
/
CREATE OR REPLACE Package Body yonda_csh_transaction_pkg Is

  Procedure yonda_auto_write_off_log(p_transaction_id  Number Default Null,
                                     p_write_off_id    Number Default Null,
                                     p_bp_id           Number Default Null,
                                     p_contract_id     Number Default Null,
                                     p_bank_account_id Number Default Null,
                                     p_message         Varchar2) As
    Pragma Autonomous_Transaction;
  Begin
    Insert Into yonda_csh_excel_write_off_log
      (log_id,
       log_date,
       transaction_id,
       write_off_id,
       bp_id,
       contract_id,
       bank_account_id,
       message)
    Values
      (yonda_auto_write_off_log_s.nextval,
       Sysdate,
       p_transaction_id,
       p_write_off_id,
       p_bp_id,
       p_contract_id,
       p_bank_account_id,
       p_message);
    Commit;
  End yonda_auto_write_off_log;

  -- excle 导入收款匹配承租人
  Function match_bp_by_name(p_bp_name       In Varchar2,
                            p_error_message Out Varchar2) Return Number As
    v_bp_id Number;
  Begin
    Select tt1.bp_id
      Into v_bp_id
      From hls_bp_master tt1
     Where tt1.bp_name = p_bp_name
       And Exists (Select 1
              From con_contract_bp
             Where bp_id = tt1.bp_id
               And bp_category = 'TENANT');
    p_error_message := Null;
    Return v_bp_id;
  Exception
    When NO_DATA_FOUND Then
      p_error_message := '无法匹配到商业伙伴';
      Return Null;
    When too_many_rows Then
      p_error_message := '匹配到多个商业伙伴';
      Return Null;
  End match_bp_by_name;
  -- excle 导入收款匹配合同，BP+AMOUNT
  Function match_contract_by_bp_amount(p_bp_id         In Number,
                                       p_amount        In Number,
                                       p_error_message Out Varchar2)
    Return Number As
    v_contract_id Number;
  Begin
    Select tt1.contract_id
      Into v_contract_id
      From con_contract tt1, con_contract_bp tt2
     Where tt1.contract_id = tt2.contract_id
       And tt2.bp_id = p_bp_id
       And tt1.contract_status Not In
           ('CANCEL', 'AD', 'ET', 'TERMINATE', 'SIGN', 'PRINTED', 'NEW')
       And tt1.data_class = 'NORMAL'
       And Exists
     (Select 1
              From con_contract_cashflow
             Where contract_id = tt1.contract_id
               And cf_direction = 'INFLOW'
               And cf_status = 'RELEASE'
               And due_amount - nvl(received_amount, 0) = p_amount);
    p_error_message := Null;
    Return v_contract_id;
  Exception
    When NO_DATA_FOUND Then
      p_error_message := '无法匹配到可核销合同（状态不匹配/现金流不匹配）';
      Return Null;
    When too_many_rows Then
      p_error_message := '匹配到多个可核销合同';
      Return Null;
  End match_contract_by_bp_amount;

  Function get_cashflow_by_contract(p_contract_id   Number,
                                    p_amount        Number,
                                    p_error_message Out Varchar2)
    Return con_contract_cashflow%Rowtype As
    r_con_contract_cashflow con_contract_cashflow%Rowtype;
    v_min_times             Number;
  Begin
    Select Min(ccf.times)
      Into v_min_times
      From con_contract_cashflow ccf
     Where ccf.cf_status = 'RELEASE'
       And ccf.cf_direction = 'INFLOW'
       And ccf.due_amount - nvl(ccf.received_amount, 0) = p_amount
       And ccf.contract_id = p_contract_id;
    Select *
      Into r_con_contract_cashflow
      From con_contract_cashflow ccf
     Where ccf.cf_status = 'RELEASE'
       And ccf.cf_direction = 'INFLOW'
       And ccf.due_amount - nvl(ccf.received_amount, 0) = p_amount
       And ccf.times = v_min_times
       And ccf.contract_id = p_contract_id;
    p_error_message := Null;
    Return r_con_contract_cashflow;
  Exception
    When Others Then
      p_error_message := '获取现金流失败';
      Return Null;
  End get_cashflow_by_contract;

  Procedure get_bp_band_account(p_bp_bank_account_num In Varchar2,
                                p_bp_id               Number,
                                p_bp_bank_account_id  Out Number) As
  Begin
    Select tt.bank_account_id
      Into p_bp_bank_account_id
      From hls_bp_master_bank_account tt
     Where tt.bank_account_num = p_bp_bank_account_num
       And tt.bp_id = p_bp_id;
  Exception
    When Others Then
      Null;
  End get_bp_band_account;

  Procedure get_company_band_account(p_company_bank_account_num In Varchar2,
                                     p_bank_account_id          Out Number,
                                     p_currency_code            Out Varchar2) As
  Begin
    Select bank_account_id, tt.currency_code
      Into p_bank_account_id, p_currency_code
      From csh_bank_account tt
     Where tt.bank_account_num = p_company_bank_account_num;
  Exception
    When Others Then
      Null;
  End get_company_band_account;
  /************interface*************/
  Procedure auto_transaction_and_write_off(p_batch_id   Number,
                                           p_user_id    Number,
                                           p_company_id Number) As
    v_bp_id                 Number;
    v_contract_id           Number;
    v_bp_bank_account_id    Number;
    v_bank_account_id       Number;
    v_currency_code         Varchar2(30);
    v_auto_write_off_flag   Varchar2(1) := 'N';
    v_period_name           Varchar2(30);
    v_internal_period_num   Number;
    v_transaction_id        Number;
    v_session_id            Number;
    v_transaction_num       Varchar2(30);
    r_con_contract_cashflow con_contract_cashflow%Rowtype;
    r_con_contract_bp       con_contract_bp%Rowtype;
    v_head_message          Varchar2(2000);
    v_front_message         Varchar2(2000);
  Begin
    -- lock the tmpt data
    For cc_record In (Select *
                        From csh_transaction_temp a
                       Where a.batch_id = p_batch_id
                         For Update Nowait) Loop
      v_contract_id           := Null; --reset data
      v_bp_id                 := Null;
      r_con_contract_cashflow := Null;
      v_auto_write_off_flag   := 'N'; -- reset the control flag
      v_head_message          := to_char(cc_record.transaction_date,
                                         'YYYY-MM-DD') || '来自' ||
                                 cc_record.bp_name || '的一笔' ||
                                 cc_record.transaction_amount || '收款，';
      --1. match bp
      v_bp_id := match_bp_by_name(p_bp_name       => cc_record.bp_name,
                                  p_error_message => v_front_message);
      If v_bp_id Is Not Null Then
        --2. match contract
        v_contract_id := match_contract_by_bp_amount(p_bp_id         => v_bp_id,
                                                     p_amount        => cc_record.transaction_amount,
                                                     p_error_message => v_front_message);
        If v_contract_id Is Not Null Then
          --3. get cashflow & bp & contract
          Select *
            Into r_con_contract_bp
            From con_contract_bp
           Where contract_id = v_contract_id
             And bp_id = v_bp_id
             And bp_category = 'TENANT';
          r_con_contract_cashflow := get_cashflow_by_contract(p_contract_id   => v_contract_id,
                                                              p_amount        => cc_record.transaction_amount,
                                                              p_error_message => v_front_message);
          If v_front_message Is Null Then
            v_auto_write_off_flag := 'Y'; -- here to control if write off
          End If;
        End If;
      End If;
      -- 4. get account info
      -- no catch exception
      get_bp_band_account(p_bp_bank_account_num => cc_record.bp_bank_account_num,
                          p_bp_id               => v_bp_id,
                          p_bp_bank_account_id  => v_bp_bank_account_id);
      -- no catch exception
      get_company_band_account(p_company_bank_account_num => cc_record.bank_account_num,
                               p_bank_account_id          => v_bank_account_id,
                               p_currency_code            => v_currency_code);
      -- 5. get period
      Select v.period_name,
             gld_common_pkg.get_gld_internal_period_num(p_company_id,
                                                        v.period_name) internal_period_num
        Into v_period_name, v_internal_period_num
        From (Select gld_common_pkg.get_gld_period_name(p_company_id,
                                                        trunc(cc_record.transaction_date)) period_name
                From dual) v;
      -- 6. transaction
      csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
                                                 p_transaction_num         => v_transaction_num,
                                                 p_transaction_category    => 'BUSINESS',
                                                 p_transaction_type        => 'RECEIPT',
                                                 p_transaction_date        => trunc(cc_record.transaction_date),
                                                 p_penalty_calc_date       => trunc(cc_record.transaction_date),
                                                 p_bank_slip_num           => Null,
                                                 p_company_id              => p_company_id,
                                                 p_internal_period_num     => v_internal_period_num,
                                                 p_period_name             => v_period_name,
                                                 p_payment_method_id       => 1,
                                                 p_distribution_set_id     => Null,
                                                 p_cashflow_amount         => cc_record.transaction_amount,
                                                 p_currency_code           => nvl(v_currency_code,
                                                                                  'CNY'),
                                                 p_transaction_amount      => cc_record.transaction_amount,
                                                 p_exchange_rate_type      => Null,
                                                 p_exchange_rate_quotation => Null,
                                                 p_exchange_rate           => 1,
                                                 p_bank_account_id         => v_bank_account_id,
                                                 p_bp_category             => r_con_contract_bp.bp_category,
                                                 p_bp_id                   => v_bp_id,
                                                 p_bp_bank_account_id      => v_bp_bank_account_id,
                                                 p_bp_bank_account_num     => cc_record.bp_bank_account_num,
                                                 p_description             => cc_record.description,
                                                 p_handling_charge         => 0,
                                                 p_posted_flag             => 'N',
                                                 p_reversed_flag           => 'N',
                                                 p_reversed_date           => Null,
                                                 p_returned_flag           => 'NOT',
                                                 p_returned_amount         => Null,
                                                 p_write_off_flag          => 'NOT',
                                                 p_write_off_amount        => Null,
                                                 p_full_write_off_date     => Null,
                                                 p_twin_csh_trx_id         => Null,
                                                 p_return_from_csh_trx_id  => Null,
                                                 p_reversed_csh_trx_id     => Null,
                                                 p_source_csh_trx_type     => Null,
                                                 p_source_csh_trx_id       => Null,
                                                 p_source_doc_category     => 'CONTRACT',
                                                 p_source_doc_type         => Null,
                                                 p_source_doc_id           => v_contract_id,
                                                 p_source_doc_line_id      => r_con_contract_cashflow.cashflow_id,
                                                 p_create_je_mothed        => Null,
                                                 p_create_je_flag          => 'N',
                                                 p_gld_interface_flag      => 'N',
                                                 p_user_id                 => p_user_id,
                                                 p_ref_contract_id         => Null,
                                                 p_csh_bp_name             => cc_record.bp_name);
      Update csh_transaction ct
         Set ct.receipt_type = 'IMPORT'
       Where ct.transaction_id = v_transaction_id;
      --7. write off
      /*IF v_auto_write_off_flag = 'Y' THEN
        SAVEPOINT start_auto_write_off;
        BEGIN
          v_session_id := sys_session_s.nextval;
          csh_write_off_pkg.insert_csh_write_off_temp(p_session_id           => v_session_id,
                                                      p_write_off_type       => 'RECEIPT_CREDIT',
                                                      p_transaction_category => 'BUSINESS',
                                                      p_transaction_type     => 'RECEIPT',
                                                      p_write_off_date       => trunc(SYSDATE),
                                                      p_write_off_due_amount => cc_record.transaction_amount,
                                                      p_write_off_principal  => r_con_contract_cashflow.principal -
                                                                                nvl(r_con_contract_cashflow.received_principal,
                                                                                    0),
                                                      p_write_off_interest   => r_con_contract_cashflow.interest -
                                                                                nvl(r_con_contract_cashflow.received_interest,
                                                                                    0),
                                                      p_company_id           => p_company_id,
                                                      p_document_category    => 'CONTRACT',
                                                      p_document_id          => v_contract_id,
                                                      p_document_line_id     => r_con_contract_cashflow.cashflow_id,
                                                      p_description          => '收款导入自动核销生成',
                                                      p_user_id              => p_user_id);
          csh_write_off_pkg.main_write_off(p_session_id     => v_session_id,
                                           p_transaction_id => v_transaction_id,
                                           p_user_id        => p_user_id);
          v_front_message := '自动核销成功';
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK TO start_auto_write_off;
            v_front_message := '核销错误，未能自动核销';
        END;
      END IF;*/
      -- 8. record log
      yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                               p_bp_id           => v_bp_id,
                               p_contract_id     => v_contract_id,
                               p_bank_account_id => v_bp_bank_account_id,
                               p_message         => v_head_message ||
                                                    v_front_message);
    End Loop;
  End auto_transaction_and_write_off;

End yonda_csh_transaction_pkg;
/
