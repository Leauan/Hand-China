CREATE OR REPLACE Package csh_write_off_pkg Is

  -- Author  : GAOYANG
  -- Created : 2013/5/20 16:27:15
  -- Purpose :
  -- Version : 1.23

  write_off_type_receipt_credit Constant Varchar2(30) := 'RECEIPT_CREDIT'; -- 收款核销债权类型
  write_off_type_receipt_pre    Constant Varchar2(30) := 'RECEIPT_ADVANCE_RECEIPT'; -- 收款核销为预收款类型
  write_off_type_pre_credit     Constant Varchar2(30) := 'ADVANCE_RECEIPT_CREDIT'; -- 预收款核销债权类型
  write_off_type_return         Constant Varchar2(30) := 'CSH_RETURN'; -- 现金退款
  write_off_type_payment_debt   Constant Varchar2(30) := 'PAYMENT_DEBT'; -- 付款核销债务
  write_off_type_pre_debt       Constant Varchar2(30) := 'PREPAYMENT_DEBT'; -- 预付款核销债务类型

  write_off_type_deposit        Constant Varchar2(30) := 'DEPOSIT'; -- 核销保证金池
  write_off_type_deposit_credit Constant Varchar2(30) := 'DEPOSIT_CREDIT'; -- 保证金核销债权
  write_off_type_risk           Constant Varchar2(30) := 'RISK'; --风险金
  write_off_type_risk_credit    Constant Varchar2(30) := 'RISK_CREDIT'; -- 保证金核销债权
  write_off_type_deposit_cus    Constant Varchar2(30) := 'DEPOSIT_CUS'; -- 核销为客户保证金

  document_category_contract Constant Varchar2(30) := 'CONTRACT'; --租赁合同

  Function get_last_write_off_date(p_transaction_id Number) Return Date;

  Function get_csh_write_off_id Return Number;
  Procedure set_con_cfw_after_writeoff(p_con_cashflow_rec  con_contract_cashflow%Rowtype,
                                       p_csh_write_off_rec csh_write_off%Rowtype,
                                       p_user_id           Number);
  Procedure lock_csh_write_off(p_write_off_id      csh_write_off.write_off_id%Type,
                               p_user_id           Number,
                               p_csh_write_off_rec Out csh_write_off%Rowtype);

  Procedure upd_write_off_after_reverse(p_write_off_id          Number,
                                        p_reversed_date         Date,
                                        p_reserved_write_off_id Number,
                                        p_user_id               Number);

  Procedure execute_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%Type,
                                       p_write_off_type           csh_write_off_temp.write_off_type%Type,
                                       p_transaction_category     csh_write_off_temp.transaction_category%Type,
                                       p_transaction_type         csh_write_off_temp.transaction_type%Type,
                                       p_write_off_date           csh_write_off_temp.write_off_date%Type,
                                       p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%Type,
                                       p_write_off_principal      csh_write_off_temp.write_off_principal%Type,
                                       p_write_off_interest       csh_write_off_temp.write_off_interest%Type,
                                       p_write_off_penalty        Number,
                                       p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%Type Default Null,
                                       p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%Type Default Null,
                                       p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%Type Default Null,
                                       p_exchange_rate            csh_write_off_temp.exchange_rate%Type Default Null,
                                       p_company_id               csh_write_off_temp.company_id%Type,
                                       p_document_category        csh_write_off_temp.document_category%Type,
                                       p_document_id              csh_write_off_temp.document_id%Type,
                                       p_document_line_id         csh_write_off_temp.document_line_id%Type,
                                       p_penalty_cashflow_id      Number,
                                       p_description              csh_write_off_temp.description%Type,
                                       p_user_id                  csh_write_off_temp.created_by%Type,
                                       p_transaction_id           Number Default Null,
                                       p_bp_id                    Number Default Null,
                                       p_year_flag                Varchar2 Default Null,
                                       p_quarter_flag             Varchar2 Default Null,
                                       p_month_flag               Varchar2 Default Null,
                                       p_transfer_type            Varchar2 Default Null,
                                       p_risk_in_dec              Varchar2 Default Null);

  Procedure insert_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%Type,
                                      p_write_off_type           csh_write_off_temp.write_off_type%Type,
                                      p_transaction_category     csh_write_off_temp.transaction_category%Type,
                                      p_transaction_type         csh_write_off_temp.transaction_type%Type,
                                      p_write_off_date           csh_write_off_temp.write_off_date%Type,
                                      p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%Type,
                                      p_write_off_principal      csh_write_off_temp.write_off_principal%Type,
                                      p_write_off_interest       csh_write_off_temp.write_off_interest%Type,
                                      p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%Type Default Null,
                                      p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%Type Default Null,
                                      p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%Type Default Null,
                                      p_exchange_rate            csh_write_off_temp.exchange_rate%Type Default Null,
                                      p_company_id               csh_write_off_temp.company_id%Type,
                                      p_document_category        csh_write_off_temp.document_category%Type,
                                      p_document_id              csh_write_off_temp.document_id%Type,
                                      p_document_line_id         csh_write_off_temp.document_line_id%Type,
                                      p_description              csh_write_off_temp.description%Type,
                                      p_user_id                  csh_write_off_temp.created_by%Type,
                                      p_transaction_id           Number Default Null,
                                      p_bp_id                    Number Default Null,
                                      p_year_flag                Varchar2 Default Null,
                                      p_quarter_flag             Varchar2 Default Null,
                                      p_month_flag               Varchar2 Default Null,
                                      p_transfer_type            Varchar2 Default Null,
                                      p_risk_in_dec              Varchar2 Default Null);

  Procedure delete_csh_write_off_temp(p_session_id Number,
                                      p_user_id    Number);

  Procedure insert_csh_write_off(p_write_off_id                Out csh_write_off.write_off_id%Type,
                                 p_write_off_type              csh_write_off.write_off_type%Type,
                                 p_write_off_date              csh_write_off.write_off_date%Type,
                                 p_internal_period_num         csh_write_off.internal_period_num%Type,
                                 p_period_name                 csh_write_off.period_name%Type,
                                 p_csh_transaction_id          csh_write_off.csh_transaction_id%Type,
                                 p_csh_write_off_amount        csh_write_off.csh_write_off_amount%Type,
                                 p_subsequent_csh_trx_id       csh_write_off.subsequent_csh_trx_id%Type,
                                 p_subseq_csh_write_off_amount csh_write_off.subseq_csh_write_off_amount%Type,
                                 p_reversed_flag               csh_write_off.reversed_flag%Type,
                                 p_reversed_write_off_id       csh_write_off.reversed_write_off_id%Type,
                                 p_reversed_date               csh_write_off.reversed_date%Type,
                                 p_cashflow_id                 csh_write_off.cashflow_id%Type,
                                 p_contract_id                 csh_write_off.contract_id%Type,
                                 p_times                       csh_write_off.times%Type,
                                 p_cf_item                     csh_write_off.cf_item%Type,
                                 p_cf_type                     csh_write_off.cf_type%Type,
                                 p_penalty_calc_date           csh_write_off.penalty_calc_date%Type,
                                 p_write_off_due_amount        csh_write_off.write_off_due_amount%Type,
                                 p_write_off_principal         csh_write_off.write_off_principal%Type,
                                 p_write_off_interest          csh_write_off.write_off_interest%Type,
                                 p_write_off_due_amount_cny    csh_write_off.write_off_due_amount_cny%Type Default Null,
                                 p_write_off_principal_cny     csh_write_off.write_off_principal_cny%Type Default Null,
                                 p_write_off_interest_cny      csh_write_off.write_off_interest_cny%Type Default Null,
                                 p_exchange_rate               csh_write_off.exchange_rate%Type Default Null,
                                 p_description                 csh_write_off.description%Type,
                                 p_opposite_doc_category       csh_write_off.opposite_doc_category%Type,
                                 p_opposite_doc_type           csh_write_off.opposite_doc_type%Type,
                                 p_opposite_doc_id             csh_write_off.opposite_doc_id%Type,
                                 p_opposite_doc_line_id        csh_write_off.opposite_doc_line_id%Type,
                                 p_opposite_doc_detail_id      csh_write_off.opposite_doc_detail_id%Type,
                                 p_opposite_write_off_amount   csh_write_off.opposite_write_off_amount%Type,
                                 p_create_je_mothed            csh_write_off.create_je_mothed%Type,
                                 p_create_je_flag              csh_write_off.create_je_flag%Type,
                                 p_gld_interface_flag          csh_write_off.gld_interface_flag%Type,
                                 p_user_id                     csh_write_off.created_by%Type,
                                 p_bp_id                       Number Default Null);

  --核销前校验
  Procedure check_before_write_off(p_csh_write_off_rec   csh_write_off%Rowtype,
                                   p_csh_trx_rec         csh_transaction%Rowtype,
                                   p_cross_currency_flag Varchar2 Default 'N',
                                   p_user_id             Number);

  Procedure return_write_off(p_return_write_off_id   Out Number,
                             p_transaction_id        Number,
                             p_return_transaction_id Number,
                             p_returned_date         Date,
                             p_returned_amount       Number,
                             p_description           Varchar2,
                             p_user_id               Number);
  --核销反冲主入口
  Procedure reverse_write_off(p_reverse_write_off_id Out Number,
                              p_write_off_id         Number,
                              p_reversed_date        Date,
                              p_description          Varchar2,
                              p_user_id              Number,
                              p_from_csh_trx_flag    Varchar2 Default 'N');

  Procedure after_write_off(p_contract_id Number, p_user_id Number);

  Procedure execute_write_off(p_write_off_id        Number,
                              p_cross_currency_flag Varchar2 Default 'N',
                              p_user_id             Number);

  --核销主入口
  Procedure main_write_off(p_session_id          Number,
                           p_transaction_id      Number,
                           p_cross_currency_flag Varchar2 Default 'N',
                           p_receipt_flag        Varchar2 Default Null,
                           p_user_id             Number);
  Procedure main_write_off_new(p_transaction_id      Number,
                               p_cross_currency_flag Varchar2 Default 'N',
                               p_receipt_flag        Varchar2 Default Null,
                               p_user_id             Number);
  --收付抵扣主入口
  Procedure deduction_write_off(p_session_id          Number,
                                p_company_id          Number,
                                p_bp_id               Number,
                                p_transaction_date    Date,
                                p_description         Varchar2,
                                p_source_csh_trx_type Varchar2 Default Null,
                                p_source_csh_trx_id   Number Default Null,
                                p_source_doc_category Varchar2 Default Null,
                                p_source_doc_type     Varchar2 Default Null,
                                p_source_doc_id       Number Default Null,
                                p_source_doc_line_id  Number Default Null,
                                p_user_id             Number,
                                p_transaction_id      Out Number);
  --工作流抵扣主入口                             
  Procedure deduction_write_off_wfl(p_instance_id      Number,
                                    p_company_id       Number,
                                    p_bp_id            Number,
                                    p_transaction_date Date,
                                    p_description      Varchar2,
                                    p_user_id          Number,
                                    p_transaction_id   Out Number);

  Procedure save_pay_check(p_write_off_id Number,
                           p_pay_check    Varchar2,
                           p_user_id      Number);

  --add by 8754 批量核销
  Procedure batch_write_off(p_transaction_id Number,
                            p_session_id     Number,
                            p_user_id        Number);

  --add by 8754  检查合同是否在收款备注的申请中
  Function check_contract_exist_flag(p_transaction_id Number,
                                     p_contract_id    Number) Return Varchar2;

  --检查收款备注是属于cf还是df
  Function get_cf_df(p_transaction_id Number) Return Varchar2;

  -- add by Liyuan DF批量核销
  Procedure batch_write_off_df(p_transaction_id_num Varchar2,
                               p_bp_id              Number,
                               p_fee_type           Varchar2,
                               p_session_id         Number,
                               p_user_id            Number);

  Procedure update_for_csh_table(p_transaction_id_num Varchar2,
                                 p_bp_id              Number,
                                 p_session_id         Number,
                                 p_user_id            Number);

  Procedure insert_write_off_df_tmp(p_contract_id Number,
                                    p_cf_item     Number,
                                    p_session_id  Number,
                                    p_user_id     Number);
  -- 批量核销开始逻辑                                  
  Procedure execute_csh_write_off_df_temp(p_transaction_id_num Varchar2,
                                          p_temp_id_num        Varchar2,
                                          p_write_off_date     Date,
                                          p_session_id         csh_write_off_temp.session_id%Type,
                                          p_user_id            Number);

  Procedure main_write_off_df(p_session_id          Number,
                              p_transaction_id      Number,
                              p_cross_currency_flag Varchar2 Default 'N',
                              p_receipt_flag        Varchar2 Default Null,
                              p_user_id             Number);
  -- end add by Liyuan
End csh_write_off_pkg;
/
CREATE OR REPLACE Package Body csh_write_off_pkg Is

  v_err_code Varchar2(2000);
  e_lock_error Exception;
  Pragma Exception_Init(e_lock_error, -54);

  Function get_csh_write_off_id Return Number Is
    v_write_off_id Number;
  Begin
    Select csh_write_off_s.nextval Into v_write_off_id From dual;
    Return v_write_off_id;
  End get_csh_write_off_id;

  Function get_last_write_off_date(p_transaction_id Number) Return Date Is
    v_last_write_off_date Date;
  Begin
    Select Max(w.write_off_date)
      Into v_last_write_off_date
      From csh_write_off w
     Where w.csh_transaction_id = p_transaction_id;
  
    Return v_last_write_off_date;
  End get_last_write_off_date;

  Function get_con_last_writeoff_date(p_cashflow_id Number) Return Date Is
    v_last_write_off_date Date;
  Begin
    Select Max(w.write_off_date)
      Into v_last_write_off_date
      From csh_write_off w
     Where w.cashflow_id = p_cashflow_id;
    Return v_last_write_off_date;
  End;

  Function is_write_off_reverse(p_csh_transaction_rec In csh_transaction%Rowtype,
                                p_user_id             Number) Return Boolean Is
    v_ctx_rec csh_transaction%Rowtype;
  Begin
    If nvl(p_csh_transaction_rec.returned_flag,
           csh_transaction_pkg.csh_trx_return_flag_n) =
       csh_transaction_pkg.csh_trx_return_flag_return Then
      Return True;
    Elsif nvl(p_csh_transaction_rec.posted_flag,
              csh_transaction_pkg.csh_trx_posted_flag_yes) <>
          csh_transaction_pkg.csh_trx_posted_flag_yes Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_POSTED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.reversed_flag,
              csh_transaction_pkg.csh_trx_reversed_flag_n) <>
          csh_transaction_pkg.csh_trx_reversed_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_REVERSED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.write_off_flag,
              csh_transaction_pkg.csh_trx_write_off_flag_n) =
          csh_transaction_pkg.csh_trx_write_off_flag_n Then
      v_err_code := 'CSH_WRITE_OFF_PKG.REVERSE_WRITE_OFF_FLAG_ERROR';
      Return False;
    End If;
    --20170216  JIANGLEI  注释 
    For r_writeoff_rec In (Select d.subsequent_csh_trx_id
                             From csh_write_off d
                            Where d.csh_transaction_id =
                                  p_csh_transaction_rec.transaction_id
                              And d.subsequent_csh_trx_id Is Not Null
                              And nvl(d.reversed_flag,
                                      csh_transaction_pkg.csh_trx_reversed_flag_n) =
                                  csh_transaction_pkg.csh_trx_reversed_flag_n) Loop
    
      csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => r_writeoff_rec.subsequent_csh_trx_id,
                                               p_user_id             => p_user_id,
                                               p_csh_transaction_rec => v_ctx_rec);
    
      If nvl(v_ctx_rec.write_off_flag,
             csh_transaction_pkg.csh_trx_write_off_flag_n) <>
         csh_transaction_pkg.csh_trx_write_off_flag_n And
         v_ctx_rec.transaction_type <> 'DEPOSIT' And
         v_ctx_rec.transaction_type <>
         csh_write_off_pkg.write_off_type_risk Then
        v_err_code := 'CSH_WRITE_OFF_PKG.SUBSEQUENT_REVERSE_WRITE_OFF_FLAG_ERROR';
        Return False;
      Elsif nvl(v_ctx_rec.returned_flag,
                csh_transaction_pkg.csh_trx_return_flag_n) <>
            csh_transaction_pkg.csh_trx_return_flag_n And
            v_ctx_rec.transaction_type <> 'DEPOSIT' Then
        --风险保证金
        v_err_code := 'CSH_WRITE_OFF_PKG.SUBSEQUENT_REVERSE_RETURN_FLAG_ERROR';
        Return False;
      End If;
    End Loop;
    Return True;
  End;

  --索合同行表
  Procedure lock_con_contract_cashflow(p_cashflow_id      con_contract_cashflow.cashflow_id%Type,
                                       p_user_id          Number,
                                       p_con_cashflow_rec Out con_contract_cashflow%Rowtype) Is
  Begin
    Select *
      Into p_con_cashflow_rec
      From con_contract_cashflow t
     Where t.cashflow_id = p_cashflow_id
       For Update Nowait;
  
  Exception
    When e_lock_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CON_LOCK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'lock_con_contract_cashflow');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --索csh_write_off
  Procedure lock_csh_write_off(p_write_off_id      csh_write_off.write_off_id%Type,
                               p_user_id           Number,
                               p_csh_write_off_rec Out csh_write_off%Rowtype) Is
  Begin
    Select *
      Into p_csh_write_off_rec
      From csh_write_off t
     Where t.write_off_id = p_write_off_id
       For Update Nowait;
  
  Exception
    When e_lock_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_LOCK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'lock_csh_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --更新被反冲的核销事务
  Procedure upd_write_off_after_reverse(p_write_off_id          Number,
                                        p_reversed_date         Date,
                                        p_reserved_write_off_id Number,
                                        p_user_id               Number) Is
    v_csh_write_off_rec csh_write_off%Rowtype;
  Begin
    lock_csh_write_off(p_write_off_id      => p_write_off_id,
                       p_user_id           => p_user_id,
                       p_csh_write_off_rec => v_csh_write_off_rec);
    Update csh_write_off t
       Set t.reversed_flag         = csh_transaction_pkg.csh_trx_reversed_flag_w,
           t.reversed_date         = p_reversed_date,
           t.reversed_write_off_id = p_reserved_write_off_id,
           t.last_update_date      = Sysdate,
           t.last_updated_by       = p_user_id
     Where t.write_off_id = v_csh_write_off_rec.write_off_id;
  End;

  --更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
  Procedure set_con_cfw_after_writeoff(p_con_cashflow_rec  con_contract_cashflow%Rowtype,
                                       p_csh_write_off_rec csh_write_off%Rowtype,
                                       p_user_id           Number) Is
    v_write_off_due_amount Number;
    v_write_off_principal  Number;
    v_write_off_interest   Number;
  
    v_last_write_off_date Date;
    v_transaction_date    Date;
  
    v_write_off_flag Varchar2(30);
  
    v_con_cf_rec con_contract_cashflow%Rowtype;
    e_cfw_con_error Exception;
  Begin
  
    v_write_off_due_amount := nvl(p_con_cashflow_rec.received_amount, 0) +
                              nvl(p_csh_write_off_rec.write_off_due_amount,
                                  0);
    v_write_off_principal  := nvl(p_con_cashflow_rec.received_principal, 0) +
                              nvl(p_csh_write_off_rec.write_off_principal,
                                  0);
    v_write_off_interest   := nvl(p_con_cashflow_rec.received_interest, 0) +
                              nvl(p_csh_write_off_rec.write_off_interest, 0);
  
    If v_write_off_due_amount = 0 Then
      v_last_write_off_date := Null;
      v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_n;
    Else
      If nvl(p_con_cashflow_rec.due_amount, 0) = v_write_off_due_amount Then
        v_last_write_off_date := get_con_last_writeoff_date(p_cashflow_id => p_con_cashflow_rec.cashflow_id);
        v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_f;
      Elsif nvl(p_con_cashflow_rec.due_amount, 0) > v_write_off_due_amount Then
        v_last_write_off_date := Null;
        v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_p;
      Else
        v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_DUE_AMOUNT_ERROR';
        Raise e_cfw_con_error;
      End If;
    End If;
  
    If nvl(p_con_cashflow_rec.principal, 0) < v_write_off_principal Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_PRINCIPAL_ERROR';
      Raise e_cfw_con_error;
    End If;
  
    If nvl(p_con_cashflow_rec.interest, 0) < v_write_off_interest Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_INTEREST_ERROR';
      Raise e_cfw_con_error;
    End If;
  
    Update con_contract_cashflow t
       Set t.received_amount        = v_write_off_due_amount,
           t.received_principal     = v_write_off_principal,
           t.received_interest      = v_write_off_interest,
           t.received_amount_cny    = nvl(t.received_amount_cny, 0) +
                                      nvl(p_csh_write_off_rec.write_off_due_amount_cny,
                                          0),
           t.received_principal_cny = nvl(t.received_principal_cny, 0) +
                                      nvl(p_csh_write_off_rec.write_off_principal_cny,
                                          0),
           t.received_interest_cny  = nvl(t.received_interest_cny, 0) +
                                      nvl(p_csh_write_off_rec.write_off_interest_cny,
                                          0),
           t.write_off_flag         = v_write_off_flag,
           t.full_write_off_date    = v_last_write_off_date,
           t.last_received_date    =
           (Select a.transaction_date
              From csh_transaction a
             Where a.transaction_id = p_csh_write_off_rec.csh_transaction_id),
           t.last_update_date       = Sysdate,
           t.last_updated_by        = p_user_id
     Where t.cashflow_id = p_con_cashflow_rec.cashflow_id;
  Exception
    When e_cfw_con_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'set_con_cfw_after_writeoff');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --更新subsequent_csh_trx_id
  Procedure update_subsequent_csh_trx_id(p_write_off_id   Number,
                                         p_transaction_id Number,
                                         p_user_id        Number) Is
    v_csh_write_off_rec csh_write_off%Rowtype;
  Begin
    lock_csh_write_off(p_write_off_id      => p_write_off_id,
                       p_user_id           => p_user_id,
                       p_csh_write_off_rec => v_csh_write_off_rec);
    Update csh_write_off d
       Set d.subsequent_csh_trx_id       = p_transaction_id,
           d.subseq_csh_write_off_amount = v_csh_write_off_rec.csh_write_off_amount,
           d.last_update_date            = Sysdate,
           d.last_updated_by             = p_user_id
     Where d.write_off_id = p_write_off_id;
  End;

  Procedure execute_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%Type,
                                       p_write_off_type           csh_write_off_temp.write_off_type%Type,
                                       p_transaction_category     csh_write_off_temp.transaction_category%Type,
                                       p_transaction_type         csh_write_off_temp.transaction_type%Type,
                                       p_write_off_date           csh_write_off_temp.write_off_date%Type,
                                       p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%Type,
                                       p_write_off_principal      csh_write_off_temp.write_off_principal%Type,
                                       p_write_off_interest       csh_write_off_temp.write_off_interest%Type,
                                       p_write_off_penalty        Number,
                                       p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%Type Default Null,
                                       p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%Type Default Null,
                                       p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%Type Default Null,
                                       p_exchange_rate            csh_write_off_temp.exchange_rate%Type Default Null,
                                       p_company_id               csh_write_off_temp.company_id%Type,
                                       p_document_category        csh_write_off_temp.document_category%Type,
                                       p_document_id              csh_write_off_temp.document_id%Type,
                                       p_document_line_id         csh_write_off_temp.document_line_id%Type,
                                       p_penalty_cashflow_id      Number,
                                       p_description              csh_write_off_temp.description%Type,
                                       p_user_id                  csh_write_off_temp.created_by%Type,
                                       p_transaction_id           Number Default Null,
                                       p_bp_id                    Number Default Null,
                                       p_year_flag                Varchar2 Default Null,
                                       p_quarter_flag             Varchar2 Default Null,
                                       p_month_flag               Varchar2 Default Null,
                                       p_transfer_type            Varchar2 Default Null,
                                       p_risk_in_dec              Varchar2 Default Null) Is
    e_amount_error Exception;
    v_count           Number := 0;
    v_contract_status Varchar2(20);
    v_et_count        Number;
    e_status_error Exception;
    R_CSH_TRANSACTION CSH_TRANSACTION%Rowtype;
    v_lease_channel   Varchar2(10);
    e_cf_advance_receipt Exception;
  Begin
  
    --add by Harry 9952 2017/2/13
    If p_document_id Is Not Null Then
      Select c.contract_status, lease_Channel
        Into v_contract_status, v_lease_channel --addby wuts
        From con_contract c
       Where c.contract_id = p_document_id
         For Update Nowait;
    
      If v_contract_status = 'ETING' Then
        /*判断是否审批通过，如果审批通过肯定存在APPROVED*/
        Select Count(*)
          Into v_et_count
          From con_contract_et_hd h
         Where h.contract_id = p_document_id
           And h.status = 'APPROVED';
        /*如果不存在审批通过的，则抛错*/
        If v_et_count = 0 Then
          Raise e_status_error;
        End If;
      End If;
    End If;
  
    --add by wuts  2019-01-10
    Begin
      Select *
        Into R_CSH_TRANSACTION
        From CSH_TRANSACTION
       Where transaction_id = p_transaction_id;
    
    Exception
      When NO_DATA_FOUND Then
        Null;
    End;
    If R_CSH_TRANSACTION.TRANSACTION_TYPE = 'ADVANCE_RECEIPT' And
       v_lease_channel = '00' Then
      Raise e_cf_advance_receipt;
    End If;
    --end wuts
    If nvl(p_write_off_due_amount, 0) > 0 Then
      insert_csh_write_off_temp(p_session_id               => p_session_id,
                                p_write_off_type           => p_write_off_type,
                                p_transaction_category     => p_transaction_category,
                                p_transaction_type         => p_transaction_type,
                                p_write_off_date           => p_write_off_date,
                                p_write_off_due_amount     => p_write_off_due_amount,
                                p_write_off_principal      => p_write_off_principal,
                                p_write_off_interest       => p_write_off_interest,
                                p_write_off_due_amount_cny => p_write_off_due_amount_cny,
                                p_write_off_principal_cny  => p_write_off_principal_cny,
                                p_write_off_interest_cny   => p_write_off_interest_cny,
                                p_exchange_rate            => p_exchange_rate,
                                p_company_id               => p_company_id,
                                p_document_category        => p_document_category,
                                p_document_id              => p_document_id,
                                p_document_line_id         => p_document_line_id,
                                p_description              => p_description,
                                p_user_id                  => p_user_id,
                                p_transaction_id           => p_transaction_id,
                                p_bp_id                    => p_bp_id,
                                p_year_flag                => p_year_flag,
                                p_quarter_flag             => p_quarter_flag,
                                p_month_flag               => p_month_flag,
                                p_transfer_type            => p_transfer_type,
                                p_risk_in_dec              => p_risk_in_dec);
    Else
      v_count := v_count + 1;
    End If;
    If nvl(p_write_off_penalty, 0) > 0 And
       p_penalty_cashflow_id Is Not Null Then
      insert_csh_write_off_temp(p_session_id           => p_session_id,
                                p_write_off_type       => p_write_off_type,
                                p_transaction_category => p_transaction_category,
                                p_transaction_type     => p_transaction_type,
                                p_write_off_date       => p_write_off_date,
                                p_write_off_due_amount => p_write_off_penalty,
                                p_write_off_principal  => '',
                                p_write_off_interest   => '',
                                p_company_id           => p_company_id,
                                p_document_category    => p_document_category,
                                p_document_id          => p_document_id,
                                p_document_line_id     => p_penalty_cashflow_id,
                                p_description          => p_description,
                                p_user_id              => p_user_id,
                                p_transaction_id       => p_transaction_id);
    Else
      v_count := v_count + 1;
    End If;
    If v_count = 2 Then
      Raise e_amount_error;
    End If;
  Exception
    When e_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_AMOUNT_NEGATIVE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_cf_advance_receipt Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CF_ADVANCE_RECEIPT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_STATUS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure insert_csh_write_off_temp(p_csh_write_off_temp_rec In Out csh_write_off_temp%Rowtype) Is
  Begin
    Insert Into csh_write_off_temp Values p_csh_write_off_temp_rec;
  End;

  Procedure insert_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%Type,
                                      p_write_off_type           csh_write_off_temp.write_off_type%Type,
                                      p_transaction_category     csh_write_off_temp.transaction_category%Type,
                                      p_transaction_type         csh_write_off_temp.transaction_type%Type,
                                      p_write_off_date           csh_write_off_temp.write_off_date%Type,
                                      p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%Type,
                                      p_write_off_principal      csh_write_off_temp.write_off_principal%Type,
                                      p_write_off_interest       csh_write_off_temp.write_off_interest%Type,
                                      p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%Type Default Null,
                                      p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%Type Default Null,
                                      p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%Type Default Null,
                                      p_exchange_rate            csh_write_off_temp.exchange_rate%Type Default Null,
                                      p_company_id               csh_write_off_temp.company_id%Type,
                                      p_document_category        csh_write_off_temp.document_category%Type,
                                      p_document_id              csh_write_off_temp.document_id%Type,
                                      p_document_line_id         csh_write_off_temp.document_line_id%Type,
                                      p_description              csh_write_off_temp.description%Type,
                                      p_user_id                  csh_write_off_temp.created_by%Type,
                                      p_transaction_id           Number Default Null,
                                      p_bp_id                    Number Default Null,
                                      p_year_flag                Varchar2 Default Null,
                                      p_quarter_flag             Varchar2 Default Null,
                                      p_month_flag               Varchar2 Default Null,
                                      p_transfer_type            Varchar2 Default Null,
                                      p_risk_in_dec              Varchar2 Default Null) Is
  
    v_record csh_write_off_temp%Rowtype;
  Begin
    v_record.session_id               := p_session_id;
    v_record.write_off_type           := p_write_off_type;
    v_record.transaction_category     := p_transaction_category;
    v_record.transaction_type         := p_transaction_type;
    v_record.write_off_date           := p_write_off_date;
    v_record.write_off_due_amount     := p_write_off_due_amount;
    v_record.write_off_principal      := p_write_off_principal;
    v_record.write_off_interest       := p_write_off_interest;
    v_record.write_off_due_amount_cny := p_write_off_due_amount_cny;
    v_record.write_off_principal_cny  := p_write_off_principal_cny;
    v_record.write_off_interest_cny   := p_write_off_interest_cny;
    v_record.exchange_rate            := p_exchange_rate;
    v_record.company_id               := p_company_id;
    v_record.document_category        := p_document_category;
    v_record.document_id              := p_document_id;
    v_record.document_line_id         := p_document_line_id;
    v_record.description              := Trim(p_description);
    v_record.creation_date            := Sysdate;
    v_record.created_by               := p_user_id;
    v_record.last_update_date         := Sysdate;
    v_record.last_updated_by          := p_user_id;
    v_record.temp_id                  := csh_write_off_temp_s.nextval;
    v_record.transaction_id           := p_transaction_id;
    v_record.bp_id                    := p_bp_id;
    v_record.year_flag                := p_year_flag;
    v_record.quarter_flag             := p_quarter_flag;
    v_record.month_flag               := p_month_flag;
    v_record.transfer_type            := p_transfer_type;
    v_record.risk_in_dec              := p_risk_in_dec;
  
    insert_csh_write_off_temp(v_record);
  End;

  Procedure delete_csh_write_off_temp(p_session_id Number,
                                      p_user_id    Number) Is
  Begin
    Delete From csh_write_off_temp t
     Where t.transaction_id Is Null
       And t.session_id = p_session_id
       And t.wfl_instance_id Is Null;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'delete_csh_write_off_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End delete_csh_write_off_temp;

  Function insert_csh_write_off(p_csh_write_off_temp_rec csh_write_off_temp%Rowtype,
                                p_csh_transaction_rec    csh_transaction%Rowtype,
                                p_set_of_books_id        Number,
                                p_cross_currency_flag    Varchar2 Default 'N',
                                p_user_id                Number)
    Return Number Is
    v_write_off_id             Number;
    v_csh_write_off_amount     Number;
    v_write_off_due_amount     Number;
    v_write_off_principal      Number;
    v_write_off_interest       Number;
    v_write_off_due_amount_cny Number;
    v_write_off_principal_cny  Number;
    v_write_off_interest_cny   Number;
    v_write_off_penalty        Number;
    v_precision                Number;
    v_period_name              Varchar2(30);
    v_internal_period_num      gld_periods.internal_period_num%Type;
  
    v_con_cashflow_rec con_contract_cashflow%Rowtype;
  
    e_insert_write_off_error Exception;
  Begin
    v_precision := fnd_format_mask_pkg.get_gld_amount_precision(p_currency_code   => p_csh_transaction_rec.currency_code,
                                                                p_set_of_books_id => p_set_of_books_id);
  
    If p_csh_write_off_temp_rec.write_off_type In
       (csh_write_off_pkg.write_off_type_receipt_credit,
        csh_write_off_pkg.write_off_type_pre_credit,
        csh_write_off_pkg.write_off_type_payment_debt,
        csh_write_off_pkg.write_off_type_deposit_credit,
        csh_write_off_pkg.write_off_type_risk_credit) Then
      --索合同表
      lock_con_contract_cashflow(p_cashflow_id      => p_csh_write_off_temp_rec.document_line_id,
                                 p_user_id          => p_user_id,
                                 p_con_cashflow_rec => v_con_cashflow_rec);
    End If;
    If v_precision Is Not Null Then
      If p_cross_currency_flag = 'Y' And
         p_csh_transaction_rec.currency_code = 'CNY' Then
        v_csh_write_off_amount     := round(nvl(p_csh_write_off_temp_rec.write_off_due_amount_cny,
                                                0),
                                            v_precision);
        v_write_off_due_amount_cny := round(p_csh_write_off_temp_rec.write_off_due_amount_cny,
                                            v_precision);
      
        v_write_off_principal_cny := round(p_csh_write_off_temp_rec.write_off_principal_cny,
                                           v_precision);
        v_write_off_interest_cny  := round(p_csh_write_off_temp_rec.write_off_interest_cny,
                                           v_precision);
      Else
        v_csh_write_off_amount     := round(nvl(p_csh_write_off_temp_rec.write_off_due_amount,
                                                0),
                                            v_precision);
        v_write_off_due_amount_cny := Null;
        v_write_off_principal_cny  := Null;
        v_write_off_interest_cny   := Null;
      
      End If;
    
      v_write_off_due_amount := round(p_csh_write_off_temp_rec.write_off_due_amount,
                                      v_precision);
      v_write_off_principal  := round(p_csh_write_off_temp_rec.write_off_principal,
                                      v_precision);
      v_write_off_interest   := round(p_csh_write_off_temp_rec.write_off_interest,
                                      v_precision);
    Else
    
      If p_cross_currency_flag = 'Y' And
         p_csh_transaction_rec.currency_code = 'CNY' Then
        v_csh_write_off_amount := nvl(p_csh_write_off_temp_rec.write_off_due_amount_cny,
                                      0);
      
        v_write_off_due_amount_cny := p_csh_write_off_temp_rec.write_off_due_amount_cny;
      
        v_write_off_principal_cny := p_csh_write_off_temp_rec.write_off_principal_cny;
        v_write_off_interest_cny  := p_csh_write_off_temp_rec.write_off_interest_cny;
      
      Else
      
        v_csh_write_off_amount     := nvl(p_csh_write_off_temp_rec.write_off_due_amount,
                                          0);
        v_write_off_due_amount_cny := Null;
        v_write_off_principal_cny  := Null;
        v_write_off_interest_cny   := Null;
      End If;
      v_write_off_due_amount := p_csh_write_off_temp_rec.write_off_due_amount;
      v_write_off_principal  := p_csh_write_off_temp_rec.write_off_principal;
      v_write_off_interest   := p_csh_write_off_temp_rec.write_off_interest;
    End If;
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_csh_transaction_rec.company_id,
                                                        p_date       => p_csh_write_off_temp_rec.write_off_date);
    If v_period_name Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_ERROR';
      Raise e_insert_write_off_error;
    End If;
    v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => p_csh_transaction_rec.company_id,
                                                                        p_period_name => v_period_name);
    If v_internal_period_num Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_NUM_ERROR';
      Raise e_insert_write_off_error;
    End If;
    insert_csh_write_off(p_write_off_id                => v_write_off_id,
                         p_write_off_type              => p_csh_write_off_temp_rec.write_off_type,
                         p_write_off_date              => p_csh_write_off_temp_rec.write_off_date,
                         p_internal_period_num         => v_internal_period_num,
                         p_period_name                 => v_period_name,
                         p_csh_transaction_id          => p_csh_transaction_rec.transaction_id,
                         p_csh_write_off_amount        => v_csh_write_off_amount,
                         p_subsequent_csh_trx_id       => '',
                         p_subseq_csh_write_off_amount => '',
                         p_reversed_flag               => csh_transaction_pkg.csh_trx_reversed_flag_n,
                         p_reversed_write_off_id       => '',
                         p_reversed_date               => '',
                         p_cashflow_id                 => v_con_cashflow_rec.cashflow_id,
                         p_contract_id                 => nvl(v_con_cashflow_rec.contract_id,
                                                              p_csh_write_off_temp_rec.document_id),
                         p_times                       => v_con_cashflow_rec.times,
                         p_cf_item                     => v_con_cashflow_rec.cf_item,
                         p_cf_type                     => v_con_cashflow_rec.cf_type,
                         --p_penalty_calc_date           => p_csh_transaction_rec.transaction_date,modify by Spencer 3893 20160825 延迟履行金计算日修改为取核销日期
                         p_penalty_calc_date         => p_csh_write_off_temp_rec.write_off_date,
                         p_write_off_due_amount      => v_write_off_due_amount,
                         p_write_off_principal       => v_write_off_principal,
                         p_write_off_interest        => v_write_off_interest,
                         p_write_off_due_amount_cny  => v_write_off_due_amount_cny,
                         p_write_off_principal_cny   => v_write_off_principal_cny,
                         p_write_off_interest_cny    => v_write_off_interest_cny,
                         p_exchange_rate             => p_csh_write_off_temp_rec.exchange_rate,
                         p_opposite_doc_category     => '',
                         p_opposite_doc_type         => '',
                         p_opposite_doc_id           => '',
                         p_opposite_doc_line_id      => '',
                         p_opposite_doc_detail_id    => '',
                         p_opposite_write_off_amount => '',
                         p_create_je_mothed          => '',
                         p_create_je_flag            => 'N',
                         p_gld_interface_flag        => 'N',
                         p_description               => p_csh_write_off_temp_rec.description,
                         p_user_id                   => p_user_id,
                         p_bp_id                     => p_csh_transaction_rec.bp_id);
  
    Update csh_write_off cwo
       Set cwo.year_flag     = p_csh_write_off_temp_rec.year_flag,
           cwo.quarter_flag  = p_csh_write_off_temp_rec.quarter_flag,
           cwo.month_flag    = p_csh_write_off_temp_rec.month_flag,
           cwo.bp_id         = p_csh_write_off_temp_rec.bp_id,
           cwo.transfer_type = p_csh_write_off_temp_rec.transfer_type,
           cwo.risk_in_dec   = p_csh_write_off_temp_rec.risk_in_dec
     Where cwo.write_off_id = v_write_off_id;
  
    Return v_write_off_id;
  Exception
    When e_insert_write_off_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'insert_csh_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure insert_csh_write_off(p_csh_write_off_rec In Out csh_write_off%Rowtype) Is
  Begin
    If p_csh_write_off_rec.write_off_id Is Null Then
      Select csh_write_off_s.nextval
        Into p_csh_write_off_rec.write_off_id
        From dual;
    End If;
    Insert Into csh_write_off Values p_csh_write_off_rec;
  End;

  Procedure insert_csh_write_off(p_write_off_id                Out csh_write_off.write_off_id%Type,
                                 p_write_off_type              csh_write_off.write_off_type%Type,
                                 p_write_off_date              csh_write_off.write_off_date%Type,
                                 p_internal_period_num         csh_write_off.internal_period_num%Type,
                                 p_period_name                 csh_write_off.period_name%Type,
                                 p_csh_transaction_id          csh_write_off.csh_transaction_id%Type,
                                 p_csh_write_off_amount        csh_write_off.csh_write_off_amount%Type,
                                 p_subsequent_csh_trx_id       csh_write_off.subsequent_csh_trx_id%Type,
                                 p_subseq_csh_write_off_amount csh_write_off.subseq_csh_write_off_amount%Type,
                                 p_reversed_flag               csh_write_off.reversed_flag%Type,
                                 p_reversed_write_off_id       csh_write_off.reversed_write_off_id%Type,
                                 p_reversed_date               csh_write_off.reversed_date%Type,
                                 p_cashflow_id                 csh_write_off.cashflow_id%Type,
                                 p_contract_id                 csh_write_off.contract_id%Type,
                                 p_times                       csh_write_off.times%Type,
                                 p_cf_item                     csh_write_off.cf_item%Type,
                                 p_cf_type                     csh_write_off.cf_type%Type,
                                 p_penalty_calc_date           csh_write_off.penalty_calc_date%Type,
                                 p_write_off_due_amount        csh_write_off.write_off_due_amount%Type,
                                 p_write_off_principal         csh_write_off.write_off_principal%Type,
                                 p_write_off_interest          csh_write_off.write_off_interest%Type,
                                 p_write_off_due_amount_cny    csh_write_off.write_off_due_amount_cny%Type Default Null,
                                 p_write_off_principal_cny     csh_write_off.write_off_principal_cny%Type Default Null,
                                 p_write_off_interest_cny      csh_write_off.write_off_interest_cny%Type Default Null,
                                 p_exchange_rate               csh_write_off.exchange_rate%Type Default Null,
                                 p_description                 csh_write_off.description%Type,
                                 p_opposite_doc_category       csh_write_off.opposite_doc_category%Type,
                                 p_opposite_doc_type           csh_write_off.opposite_doc_type%Type,
                                 p_opposite_doc_id             csh_write_off.opposite_doc_id%Type,
                                 p_opposite_doc_line_id        csh_write_off.opposite_doc_line_id%Type,
                                 p_opposite_doc_detail_id      csh_write_off.opposite_doc_detail_id%Type,
                                 p_opposite_write_off_amount   csh_write_off.opposite_write_off_amount%Type,
                                 p_create_je_mothed            csh_write_off.create_je_mothed%Type,
                                 p_create_je_flag              csh_write_off.create_je_flag%Type,
                                 p_gld_interface_flag          csh_write_off.gld_interface_flag%Type,
                                 p_user_id                     csh_write_off.created_by%Type,
                                 p_bp_id                       Number Default Null) Is
    v_record           csh_write_off%Rowtype;
    v_csh_write_off_id Number;
  Begin
    Select csh_write_off_s.nextval Into v_csh_write_off_id From dual;
    v_record.write_off_id                := v_csh_write_off_id;
    v_record.write_off_type              := p_write_off_type;
    v_record.write_off_date              := p_write_off_date;
    v_record.internal_period_num         := p_internal_period_num;
    v_record.period_name                 := p_period_name;
    v_record.csh_transaction_id          := p_csh_transaction_id;
    v_record.csh_write_off_amount        := p_csh_write_off_amount;
    v_record.subsequent_csh_trx_id       := p_subsequent_csh_trx_id;
    v_record.subseq_csh_write_off_amount := p_subseq_csh_write_off_amount;
    v_record.reversed_flag               := nvl(p_reversed_flag,
                                                csh_transaction_pkg.csh_trx_reversed_flag_n);
    v_record.reversed_write_off_id       := p_reversed_write_off_id;
    v_record.reversed_date               := p_reversed_date;
    v_record.cashflow_id                 := p_cashflow_id;
    v_record.contract_id                 := p_contract_id;
    v_record.times                       := p_times;
    v_record.cf_item                     := p_cf_item;
    v_record.cf_type                     := p_cf_type;
    v_record.penalty_calc_date           := p_penalty_calc_date;
    v_record.write_off_due_amount        := p_write_off_due_amount;
    v_record.write_off_principal         := p_write_off_principal;
    v_record.write_off_interest          := p_write_off_interest;
    v_record.write_off_due_amount_cny    := p_write_off_due_amount_cny;
    v_record.write_off_principal_cny     := p_write_off_principal_cny;
    v_record.write_off_interest_cny      := p_write_off_interest_cny;
    v_record.exchange_rate               := p_exchange_rate;
    v_record.description                 := p_description;
    v_record.opposite_doc_category       := p_opposite_doc_category;
    v_record.opposite_doc_type           := p_opposite_doc_type;
    v_record.opposite_doc_id             := p_opposite_doc_id;
    v_record.opposite_doc_line_id        := p_opposite_doc_line_id;
    v_record.opposite_doc_detail_id      := p_opposite_doc_detail_id;
    v_record.opposite_write_off_amount   := p_opposite_write_off_amount;
    v_record.create_je_mothed            := p_create_je_mothed;
    v_record.create_je_flag              := nvl(p_create_je_flag, 'N');
    v_record.gld_interface_flag          := nvl(p_gld_interface_flag, 'N');
    v_record.created_by                  := p_user_id;
    v_record.creation_date               := Sysdate;
    v_record.last_updated_by             := p_user_id;
    v_record.last_update_date            := Sysdate;
    Select ct.bp_id
      Into v_record.bp_id
      From csh_transaction ct
     Where ct.transaction_id = p_csh_transaction_id;
  
    insert_csh_write_off(v_record);
    p_write_off_id := v_record.write_off_id;
  End;

  --核销前金额校验
  Procedure check_before_write_off(p_csh_write_off_rec   csh_write_off%Rowtype,
                                   p_csh_trx_rec         csh_transaction%Rowtype,
                                   p_cross_currency_flag Varchar2 Default 'N',
                                   p_user_id             Number) Is
    e_amount_error              Exception;
    e_trx_writeoff_amount_error Exception;
    e_cf_type_amount_error      Exception;
    e_currency_error            Exception;
    v_con_cashflow_rec   con_contract_cashflow%Rowtype;
    v_con_contract_rec   con_contract%Rowtype;
    v_un_writeoff_amount Number;
  Begin
    If nvl(p_csh_write_off_rec.write_off_due_amount, 0) < 0 Or
       nvl(p_csh_write_off_rec.write_off_principal, 0) < 0 Or
       nvl(p_csh_write_off_rec.write_off_interest, 0) < 0 Then
      Raise e_amount_error;
    End If;
    If nvl(p_csh_write_off_rec.write_off_due_amount, 0) +
       nvl(p_csh_write_off_rec.write_off_principal, 0) +
       nvl(p_csh_write_off_rec.write_off_interest, 0) <= 0 Then
      Raise e_amount_error;
    End If;
    If p_csh_write_off_rec.write_off_type In
       (csh_write_off_pkg.write_off_type_receipt_credit,
        csh_write_off_pkg.write_off_type_pre_credit) And
       p_csh_trx_rec.transaction_type In
       (csh_transaction_pkg.csh_trx_type_receipt,
        csh_transaction_pkg.csh_trx_type_prereceipt) And
       p_csh_trx_rec.transaction_category =
       csh_transaction_pkg.csh_trx_category_business Then
      lock_con_contract_cashflow(p_cashflow_id      => p_csh_write_off_rec.cashflow_id,
                                 p_user_id          => p_user_id,
                                 p_con_cashflow_rec => v_con_cashflow_rec);
    
      v_con_contract_rec := con_contract_pkg.get_contract_rec(p_contract_id => v_con_cashflow_rec.contract_id,
                                                              p_user_id     => p_user_id);
    
      If nvl(p_cross_currency_flag, 'N') = 'N' And
         v_con_contract_rec.currency <> p_csh_trx_rec.currency_code Then
        Raise e_currency_error;
      End If;
      /*if v_con_cashflow_rec.cf_type = '1' and
         nvl(p_csh_write_off_rec.write_off_due_amount, 0) <>
         nvl(p_csh_write_off_rec.write_off_principal, 0) +
         nvl(p_csh_write_off_rec.write_off_penalty, 0) then
        raise e_cf_type_amount_error;
      end if;*/
      /*v_un_writeoff_amount := nvl(p_csh_trx_rec.transaction_amount, 0) -
                              nvl(p_csh_trx_rec.write_off_amount, 0) -
                              nvl(p_csh_trx_rec.returned_amount, 0) -
                              nvl(p_csh_write_off_rec.write_off_due_amount,
                                  0);
      if v_un_writeoff_amount < 0 then
        raise e_trx_writeoff_amount_error;
      end if;*/
    End If;
  Exception
    When e_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_AMOUNT_NEGATIVE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'check_receipt_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_currency_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'check_receipt_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_cf_type_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CF_TYPE_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'check_receipt_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_trx_writeoff_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.TRX_WRITEOFF_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'check_receipt_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  /*根据填写的经销商来处理*/
  Procedure deposit_write_off(p_write_off_rec csh_write_off%Rowtype,
                              p_user_id       Number) Is
    r_source_csh_trx_rec  csh_transaction%Rowtype;
    r_deposit_csh_trx_rec csh_transaction%Rowtype;
  
    v_exists Varchar2(1);
  Begin
  
    Select *
      Into r_source_csh_trx_rec
      From csh_transaction
     Where transaction_id = p_write_off_rec.csh_transaction_id;
  
    Begin
      Select *
        Into r_deposit_csh_trx_rec
        From csh_transaction a
       Where a.company_id = r_source_csh_trx_rec.company_id
         And a.transaction_type = 'DEPOSIT'
         And nvl(a.reversed_flag, 'N') = 'N'
         And a.returned_flag != 'RETURN'
         And a.bp_id = p_write_off_rec.bp_id;
    Exception
      When no_data_found Then
        r_deposit_csh_trx_rec := Null;
    End;
  
    If r_deposit_csh_trx_rec.transaction_id Is Null Then
      r_deposit_csh_trx_rec.transaction_id          := csh_transaction_s.nextval;
      r_deposit_csh_trx_rec.transaction_category    := csh_transaction_pkg.csh_trx_category_business;
      r_deposit_csh_trx_rec.transaction_type        := 'DEPOSIT';
      r_deposit_csh_trx_rec.transaction_date        := p_write_off_rec.write_off_date;
      r_deposit_csh_trx_rec.penalty_calc_date       := p_write_off_rec.write_off_date;
      r_deposit_csh_trx_rec.bank_slip_num           := r_source_csh_trx_rec.bank_slip_num;
      r_deposit_csh_trx_rec.company_id              := r_source_csh_trx_rec.company_id;
      r_deposit_csh_trx_rec.internal_period_num     := p_write_off_rec.internal_period_num;
      r_deposit_csh_trx_rec.period_name             := p_write_off_rec.period_name;
      r_deposit_csh_trx_rec.payment_method_id       := r_source_csh_trx_rec.payment_method_id;
      r_deposit_csh_trx_rec.distribution_set_id     := Null;
      r_deposit_csh_trx_rec.cashflow_amount         := 0;
      r_deposit_csh_trx_rec.currency_code           := r_source_csh_trx_rec.currency_code;
      r_deposit_csh_trx_rec.transaction_amount      := 0;
      r_deposit_csh_trx_rec.exchange_rate_type      := r_source_csh_trx_rec.exchange_rate_type;
      r_deposit_csh_trx_rec.exchange_rate_quotation := r_source_csh_trx_rec.exchange_rate_quotation;
      r_deposit_csh_trx_rec.exchange_rate           := r_source_csh_trx_rec.exchange_rate;
      r_deposit_csh_trx_rec.bank_account_id         := r_source_csh_trx_rec.bank_account_id;
      r_deposit_csh_trx_rec.bp_category             := 'AGENT';
      r_deposit_csh_trx_rec.bp_id                   := p_write_off_rec.bp_id;
      r_deposit_csh_trx_rec.bp_bank_account_id      := r_source_csh_trx_rec.bp_bank_account_id;
      r_deposit_csh_trx_rec.bp_bank_account_num     := r_source_csh_trx_rec.bp_bank_account_num;
      r_deposit_csh_trx_rec.description             := '';
      r_deposit_csh_trx_rec.handling_charge         := '';
      r_deposit_csh_trx_rec.twin_csh_trx_id         := '';
      r_deposit_csh_trx_rec.posted_flag             := 'Y';
      r_deposit_csh_trx_rec.write_off_flag          := 'NOT';
      r_deposit_csh_trx_rec.write_off_amount        := Null;
      r_deposit_csh_trx_rec.full_write_off_date     := Null;
      r_deposit_csh_trx_rec.reversed_flag           := 'N';
      r_deposit_csh_trx_rec.reversed_date           := Null;
      r_deposit_csh_trx_rec.reversed_csh_trx_id     := Null;
      r_deposit_csh_trx_rec.returned_flag           := 'NOT';
      r_deposit_csh_trx_rec.returned_amount         := Null;
      r_deposit_csh_trx_rec.return_from_csh_trx_id  := Null;
      r_deposit_csh_trx_rec.source_csh_trx_type     := r_source_csh_trx_rec.transaction_type;
      r_deposit_csh_trx_rec.source_csh_trx_id       := r_source_csh_trx_rec.transaction_id;
      r_deposit_csh_trx_rec.source_doc_category     := '';
      r_deposit_csh_trx_rec.source_doc_type         := '';
      r_deposit_csh_trx_rec.source_doc_id           := '';
      r_deposit_csh_trx_rec.source_doc_line_id      := '';
      r_deposit_csh_trx_rec.create_je_mothed        := '';
      r_deposit_csh_trx_rec.create_je_flag          := 'N';
      r_deposit_csh_trx_rec.gld_interface_flag      := 'N';
      r_deposit_csh_trx_rec.creation_date           := Sysdate;
      r_deposit_csh_trx_rec.created_by              := p_user_id;
      r_deposit_csh_trx_rec.last_update_date        := Sysdate;
      r_deposit_csh_trx_rec.last_updated_by         := p_user_id;
      r_deposit_csh_trx_rec.transaction_num         := csh_transaction_pkg.get_csh_transaction_num(p_transaction_type => r_deposit_csh_trx_rec.transaction_type,
                                                                                                   p_transaction_date => r_deposit_csh_trx_rec.transaction_date,
                                                                                                   p_company_id       => r_deposit_csh_trx_rec.company_id,
                                                                                                   p_user_id          => p_user_id);
    
      Insert Into csh_transaction Values r_deposit_csh_trx_rec;
    End If;
  
    r_deposit_csh_trx_rec.transaction_amount := nvl(r_deposit_csh_trx_rec.transaction_amount,
                                                    0) + nvl(p_write_off_rec.write_off_due_amount,
                                                             0);
    r_deposit_csh_trx_rec.cashflow_amount    := r_deposit_csh_trx_rec.transaction_amount;
  
    If nvl(r_deposit_csh_trx_rec.write_off_amount, 0) = 0 Then
      r_deposit_csh_trx_rec.write_off_flag      := 'NOT';
      r_deposit_csh_trx_rec.full_write_off_date := Null;
    Elsif r_deposit_csh_trx_rec.transaction_amount >
          nvl(r_deposit_csh_trx_rec.write_off_amount, 0) +
          nvl(r_deposit_csh_trx_rec.returned_amount, 0) Then
      r_deposit_csh_trx_rec.write_off_flag      := 'PARTIAL';
      r_deposit_csh_trx_rec.full_write_off_date := Null;
    Elsif r_deposit_csh_trx_rec.transaction_amount =
          nvl(r_deposit_csh_trx_rec.write_off_amount, 0) +
          nvl(r_deposit_csh_trx_rec.returned_amount, 0) Then
      r_deposit_csh_trx_rec.write_off_flag      := 'FULL';
      r_deposit_csh_trx_rec.full_write_off_date := p_write_off_rec.write_off_date;
    End If;
  
    If nvl(r_deposit_csh_trx_rec.returned_amount, 0) = 0 Then
      r_deposit_csh_trx_rec.returned_flag       := 'NOT';
      r_deposit_csh_trx_rec.full_write_off_date := Null;
    Elsif r_deposit_csh_trx_rec.transaction_amount >
          nvl(r_deposit_csh_trx_rec.write_off_amount, 0) +
          nvl(r_deposit_csh_trx_rec.returned_amount, 0) Then
      r_deposit_csh_trx_rec.returned_flag       := 'PARTIAL';
      r_deposit_csh_trx_rec.full_write_off_date := Null;
    Elsif r_deposit_csh_trx_rec.transaction_amount =
          nvl(r_deposit_csh_trx_rec.write_off_amount, 0) +
          nvl(r_deposit_csh_trx_rec.returned_amount, 0) Then
      r_deposit_csh_trx_rec.returned_flag       := 'FULL';
      r_deposit_csh_trx_rec.full_write_off_date := p_write_off_rec.write_off_date;
    End If;
  
    -- modify by qianming 20140825
    /*if r_deposit_csh_trx_rec.transaction_amount < 0 or
       nvl(r_deposit_csh_trx_rec.write_off_amount, 0) >
       r_deposit_csh_trx_rec.transaction_amount then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CFL_CSH_WRITE_OFF_PKG.DEPOSIT_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deposit_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    end if;*/
  
    Update csh_transaction a
       Set a.transaction_amount  = r_deposit_csh_trx_rec.transaction_amount,
           a.cashflow_amount     = r_deposit_csh_trx_rec.cashflow_amount,
           a.write_off_flag      = r_deposit_csh_trx_rec.write_off_flag,
           a.full_write_off_date = r_deposit_csh_trx_rec.full_write_off_date,
           a.returned_flag       = r_deposit_csh_trx_rec.returned_flag
     Where a.transaction_id = r_deposit_csh_trx_rec.transaction_id;
  
    Update csh_write_off a
       Set a.subsequent_csh_trx_id       = r_deposit_csh_trx_rec.transaction_id,
           a.subseq_csh_write_off_amount = a.write_off_due_amount
     Where a.write_off_id = p_write_off_rec.write_off_id;
  
  End;

  Procedure insert_deposit_write_off(p_con_cashflow_rec         con_contract_cashflow%Rowtype,
                                     p_source_csh_write_off_rec csh_write_off%Rowtype,
                                     p_user_id                  Number) Is
    r_write_off_rec csh_write_off%Rowtype;
  Begin
    r_write_off_rec := p_source_csh_write_off_rec;
  
    r_write_off_rec.write_off_id     := csh_write_off_s.nextval;
    r_write_off_rec.write_off_type   := csh_write_off_pkg.write_off_type_deposit;
    r_write_off_rec.create_je_flag   := 'N';
    r_write_off_rec.created_by       := p_user_id;
    r_write_off_rec.creation_date    := Sysdate;
    r_write_off_rec.last_updated_by  := p_user_id;
    r_write_off_rec.last_update_date := Sysdate;
  
    Insert Into csh_write_off Values r_write_off_rec;
  
    --生成单笔核销事务凭证
    csh_transaction_je_pkg.create_write_off_je(p_write_off_id => r_write_off_rec.write_off_id,
                                               p_user_id      => p_user_id);
  
    deposit_write_off(p_write_off_rec => r_write_off_rec,
                      p_user_id       => p_user_id);
  
  End;
  --用于增加供应商保证金和风险金(应收现金流)
  Procedure special_write_off(p_write_off_rec    csh_write_off%Rowtype,
                              p_user_id          Number,
                              p_transaction_type Varchar2) Is
    v_cashflow_id Number;
    r_cashflow    con_contract_cashflow%Rowtype;
    v_times       Number;
    v_end_date    Date;
    v_cf_item     Varchar2(5);
    v_count       Number(20);
  Begin
    If p_transaction_type = 'DEPOSIT' Then
      v_cf_item := '55';
    Elsif p_transaction_type = 'RISK' Then
      v_cf_item := '56';
    End If;
    Begin
      Select ca.cashflow_id
        Into v_cashflow_id
        From con_contract_cashflow ca
       Where ca.contract_id = p_write_off_rec.contract_id
         And ca.cf_item = v_cf_item
         And ca.times = p_write_off_rec.times;
      Update con_contract_cashflow a
         Set a.due_amount               = a.due_amount +
                                          p_write_off_rec.csh_write_off_amount,
             a.payment_deduction_amount = a.payment_deduction_amount +
                                          p_write_off_rec.csh_write_off_amount,
             a.write_off_flag           = 'NOT'
       Where a.cashflow_id = v_cashflow_id;
    
    Exception
      When no_data_found Then
        --如果找不到的话，进行插入现金流
      
        Select Count(*)
          Into v_count
          From con_contract h
         Where h.contract_id = p_write_off_rec.contract_id
           And h.contract_status In
               ('ET', 'ETING', 'TERMINATE', 'AD', 'ADING');
      
        If (v_count = 0) Then
          -- 提前结清/资产处置  不生成现金流 ad by Harry 9952 2017/1/24
        
          Select ca.due_date
            Into v_end_date
            From con_contract_cashflow ca
           Where ca.cashflow_id = p_write_off_rec.cashflow_id;
        
          r_cashflow.cashflow_id              := con_contract_cashflow_s.nextval;
          r_cashflow.contract_id              := p_write_off_rec.contract_id;
          r_cashflow.cf_item                  := v_cf_item;
          r_cashflow.cf_type                  := '5';
          r_cashflow.cf_direction             := 'INFLOW';
          r_cashflow.cf_status                := 'RELEASE';
          r_cashflow.times                    := p_write_off_rec.times;
          r_cashflow.calc_date                := v_end_date;
          r_cashflow.due_date                 := v_end_date;
          r_cashflow.due_amount               := p_write_off_rec.csh_write_off_amount;
          r_cashflow.payment_deduction_flag   := 'Y';
          r_cashflow.payment_deduction_amount := p_write_off_rec.csh_write_off_amount;
          r_cashflow.fix_rental_flag          := 'Y';
          r_cashflow.beginning_of_lease_year  := 'N';
          r_cashflow.generated_source         := 'MANUAL';
          r_cashflow.overdue_status           := 'N';
          r_cashflow.write_off_flag           := 'NOT';
          r_cashflow.penalty_process_status   := 'NORMAL';
          r_cashflow.billing_status           := 'NOT';
          r_cashflow.exchange_rate            := 1;
          r_cashflow.creation_date            := Sysdate;
          r_cashflow.last_update_date         := Sysdate;
          r_cashflow.created_by               := p_user_id;
          r_cashflow.last_updated_by          := p_user_id;
          Insert Into con_contract_cashflow Values r_cashflow;
        End If;
    End;
  
  End special_write_off;

  --用于核销为客户保证金
  Procedure deposit_cus_write_off(p_write_off_rec csh_write_off%Rowtype,
                                  p_user_id       Number) Is
    v_cashflow_id Number;
    r_cashflow    con_contract_cashflow%Rowtype;
    v_times       Number;
    v_end_date    Date;
  Begin
    --先查询是否存在保证金退还52现金流
    Begin
      Select ca.cashflow_id
        Into v_cashflow_id
        From con_contract_cashflow ca
       Where ca.contract_id = p_write_off_rec.contract_id
         And ca.cf_item = 52;
      Update con_contract_cashflow a
         Set a.due_amount               = a.due_amount +
                                          p_write_off_rec.csh_write_off_amount,
             a.payment_deduction_amount = a.payment_deduction_amount +
                                          p_write_off_rec.csh_write_off_amount
       Where a.cashflow_id = v_cashflow_id;
    
    Exception
      When no_data_found Then
        --如果找不到的话，进行插入现金流
        Select c.lease_times, c.lease_end_date
          Into v_times, v_end_date
          From con_contract c
         Where c.contract_id = p_write_off_rec.contract_id
           And c.data_class = 'NORMAL';
      
        r_cashflow.cashflow_id              := con_contract_cashflow_s.nextval;
        v_cashflow_id                       := r_cashflow.cashflow_id;
        r_cashflow.contract_id              := p_write_off_rec.contract_id;
        r_cashflow.cf_item                  := '52';
        r_cashflow.cf_type                  := '5';
        r_cashflow.cf_direction             := 'OUTFLOW';
        r_cashflow.cf_status                := 'RELEASE';
        r_cashflow.times                    := v_times;
        r_cashflow.calc_date                := v_end_date;
        r_cashflow.due_date                 := v_end_date;
        r_cashflow.due_amount               := p_write_off_rec.csh_write_off_amount;
        r_cashflow.payment_deduction_flag   := 'Y';
        r_cashflow.payment_deduction_amount := p_write_off_rec.csh_write_off_amount;
        r_cashflow.fix_rental_flag          := 'Y';
        r_cashflow.beginning_of_lease_year  := 'N';
        r_cashflow.generated_source         := 'MANUAL';
        r_cashflow.overdue_status           := 'N';
        r_cashflow.write_off_flag           := 'NOT';
        r_cashflow.penalty_process_status   := 'NORMAL';
        r_cashflow.billing_status           := 'NOT';
        r_cashflow.exchange_rate            := 1;
        r_cashflow.creation_date            := Sysdate;
        r_cashflow.last_update_date         := Sysdate;
        r_cashflow.created_by               := p_user_id;
        r_cashflow.last_updated_by          := p_user_id;
        Insert Into con_contract_cashflow Values r_cashflow;
    End;
  
    Update csh_write_off cwo
       Set cwo.cashflow_id = v_cashflow_id,
           cwo.cf_item     = '52',
           cwo.cf_type     = '5'
     Where cwo.write_off_id = p_write_off_rec.write_off_id;
  
  End deposit_cus_write_off;

  --用于进行其他费用的核销
  Procedure others_write_off(p_write_off_rec    csh_write_off%Rowtype,
                             p_user_id          Number,
                             p_transaction_type Varchar2,
                             p_bp_flag          Varchar2 Default 'N') Is
    --是否需要使用bp作为索引
    r_source_csh_trx_rec csh_transaction%Rowtype;
    r_others_csh_trx_rec csh_transaction%Rowtype;
  
    v_exists Varchar2(1);
    v_bp_id  Number;
  Begin
    /* if p_transaction_type = 'RISK' then
      select bm.bp_id
        into v_bp_id
        from hls_bp_master bm
       where bm.bp_code = 'S90812';
      update csh_write_off cwo
         set cwo.bp_id = v_bp_id
       where cwo.write_off_id = p_write_off_rec.write_off_id;
    end if;*/
  
    Select *
      Into r_source_csh_trx_rec
      From csh_transaction
     Where transaction_id = p_write_off_rec.csh_transaction_id;
  
    Begin
      Select *
        Into r_others_csh_trx_rec
        From csh_transaction a
       Where a.company_id = r_source_csh_trx_rec.company_id
         And a.transaction_category =
             csh_transaction_pkg.csh_trx_category_business
         And a.transaction_type = p_transaction_type
         And nvl(a.reversed_flag, 'N') = 'N'
         And (p_bp_flag = 'N' Or
             (p_bp_flag = 'Y' And a.bp_id = r_source_csh_trx_rec.bp_id));
    Exception
      When no_data_found Then
        r_others_csh_trx_rec := Null;
    End;
  
    If r_others_csh_trx_rec.transaction_id Is Null Then
      r_others_csh_trx_rec.transaction_id          := csh_transaction_s.nextval;
      r_others_csh_trx_rec.transaction_category    := csh_transaction_pkg.csh_trx_category_business;
      r_others_csh_trx_rec.transaction_type        := p_transaction_type;
      r_others_csh_trx_rec.transaction_date        := p_write_off_rec.write_off_date;
      r_others_csh_trx_rec.penalty_calc_date       := p_write_off_rec.write_off_date;
      r_others_csh_trx_rec.bank_slip_num           := r_source_csh_trx_rec.bank_slip_num;
      r_others_csh_trx_rec.company_id              := r_source_csh_trx_rec.company_id;
      r_others_csh_trx_rec.internal_period_num     := p_write_off_rec.internal_period_num;
      r_others_csh_trx_rec.period_name             := p_write_off_rec.period_name;
      r_others_csh_trx_rec.payment_method_id       := r_source_csh_trx_rec.payment_method_id;
      r_others_csh_trx_rec.distribution_set_id     := Null;
      r_others_csh_trx_rec.cashflow_amount         := 0;
      r_others_csh_trx_rec.currency_code           := r_source_csh_trx_rec.currency_code;
      r_others_csh_trx_rec.transaction_amount      := 0;
      r_others_csh_trx_rec.exchange_rate_type      := r_source_csh_trx_rec.exchange_rate_type;
      r_others_csh_trx_rec.exchange_rate_quotation := r_source_csh_trx_rec.exchange_rate_quotation;
      r_others_csh_trx_rec.exchange_rate           := r_source_csh_trx_rec.exchange_rate;
      r_others_csh_trx_rec.bank_account_id         := r_source_csh_trx_rec.bank_account_id;
      r_others_csh_trx_rec.bp_category             := r_source_csh_trx_rec.bp_category;
      r_others_csh_trx_rec.bp_id                   := nvl(v_bp_id,
                                                          r_source_csh_trx_rec.bp_id);
      r_others_csh_trx_rec.bp_bank_account_id      := r_source_csh_trx_rec.bp_bank_account_id;
      r_others_csh_trx_rec.bp_bank_account_num     := r_source_csh_trx_rec.bp_bank_account_num;
      r_others_csh_trx_rec.description             := '';
      r_others_csh_trx_rec.handling_charge         := '';
      r_others_csh_trx_rec.twin_csh_trx_id         := '';
      r_others_csh_trx_rec.posted_flag             := 'Y';
      r_others_csh_trx_rec.write_off_flag          := 'NOT';
      r_others_csh_trx_rec.write_off_amount        := Null;
      r_others_csh_trx_rec.full_write_off_date     := Null;
      r_others_csh_trx_rec.reversed_flag           := 'N';
      r_others_csh_trx_rec.reversed_date           := Null;
      r_others_csh_trx_rec.reversed_csh_trx_id     := Null;
      r_others_csh_trx_rec.returned_flag           := 'NOT';
      r_others_csh_trx_rec.returned_amount         := Null;
      r_others_csh_trx_rec.return_from_csh_trx_id  := Null;
      r_others_csh_trx_rec.source_csh_trx_type     := r_source_csh_trx_rec.transaction_type;
      r_others_csh_trx_rec.source_csh_trx_id       := r_source_csh_trx_rec.transaction_id;
      r_others_csh_trx_rec.source_doc_category     := '';
      r_others_csh_trx_rec.source_doc_type         := '';
      r_others_csh_trx_rec.source_doc_id           := '';
      r_others_csh_trx_rec.source_doc_line_id      := '';
      r_others_csh_trx_rec.create_je_mothed        := '';
      r_others_csh_trx_rec.create_je_flag          := 'N';
      r_others_csh_trx_rec.gld_interface_flag      := 'N';
      r_others_csh_trx_rec.creation_date           := Sysdate;
      r_others_csh_trx_rec.created_by              := p_user_id;
      r_others_csh_trx_rec.last_update_date        := Sysdate;
      r_others_csh_trx_rec.last_updated_by         := p_user_id;
      r_others_csh_trx_rec.transaction_num         := csh_transaction_pkg.get_csh_transaction_num(p_transaction_type => r_others_csh_trx_rec.transaction_type,
                                                                                                  p_transaction_date => r_others_csh_trx_rec.transaction_date,
                                                                                                  p_company_id       => r_others_csh_trx_rec.company_id,
                                                                                                  p_user_id          => p_user_id);
    
      Insert Into csh_transaction Values r_others_csh_trx_rec;
    End If;
  
    r_others_csh_trx_rec.transaction_amount := nvl(r_others_csh_trx_rec.transaction_amount,
                                                   0) + nvl(p_write_off_rec.write_off_due_amount,
                                                            0);
    r_others_csh_trx_rec.cashflow_amount    := r_others_csh_trx_rec.transaction_amount;
  
    If nvl(r_others_csh_trx_rec.write_off_amount, 0) = 0 Then
      r_others_csh_trx_rec.write_off_flag      := 'NOT';
      r_others_csh_trx_rec.full_write_off_date := Null;
    Elsif r_others_csh_trx_rec.transaction_amount >
          nvl(r_others_csh_trx_rec.write_off_amount, 0) Then
      r_others_csh_trx_rec.write_off_flag      := 'PARTIAL';
      r_others_csh_trx_rec.full_write_off_date := Null;
    Elsif r_others_csh_trx_rec.transaction_amount =
          nvl(r_others_csh_trx_rec.write_off_amount, 0) Then
      r_others_csh_trx_rec.write_off_flag      := 'FULL';
      r_others_csh_trx_rec.full_write_off_date := p_write_off_rec.write_off_date;
    End If;
    -- modify by qianming 20140825
    /*if r_others_csh_trx_rec.transaction_amount < 0 or
       nvl(r_others_csh_trx_rec.write_off_amount, 0) >
       r_others_csh_trx_rec.transaction_amount then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CFL_CSH_WRITE_OFF_PKG.DEPOSIT_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deposit_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    end if;*/
  
    Update csh_transaction a
       Set a.transaction_amount  = r_others_csh_trx_rec.transaction_amount,
           a.cashflow_amount     = r_others_csh_trx_rec.cashflow_amount,
           a.write_off_flag      = r_others_csh_trx_rec.write_off_flag,
           a.full_write_off_date = r_others_csh_trx_rec.full_write_off_date
     Where a.transaction_id = r_others_csh_trx_rec.transaction_id;
  
    Update csh_write_off a
       Set a.subsequent_csh_trx_id       = r_others_csh_trx_rec.transaction_id,
           a.subseq_csh_write_off_amount = a.write_off_due_amount
     Where a.write_off_id = p_write_off_rec.write_off_id;
  
  End;

  Procedure insert_risk_write_off(p_con_cashflow_rec         con_contract_cashflow%Rowtype,
                                  p_source_csh_write_off_rec csh_write_off%Rowtype,
                                  p_user_id                  Number) Is
    r_write_off_rec csh_write_off%Rowtype;
  Begin
    r_write_off_rec := p_source_csh_write_off_rec;
  
    r_write_off_rec.write_off_id     := csh_write_off_s.nextval;
    r_write_off_rec.write_off_type   := csh_write_off_pkg.write_off_type_risk_credit;
    r_write_off_rec.create_je_flag   := 'N';
    r_write_off_rec.created_by       := p_user_id;
    r_write_off_rec.creation_date    := Sysdate;
    r_write_off_rec.last_updated_by  := p_user_id;
    r_write_off_rec.last_update_date := Sysdate;
  
    Insert Into csh_write_off Values r_write_off_rec;
  
    --生成单笔核销事务凭证
    csh_transaction_je_pkg.create_write_off_je(p_write_off_id => r_write_off_rec.write_off_id,
                                               p_user_id      => p_user_id);
  
    others_write_off(p_write_off_rec    => r_write_off_rec,
                     p_user_id          => p_user_id,
                     p_transaction_type => csh_transaction_pkg.csh_trx_type_risk);
  
  End;
  --收款、预收款的退款需要在核销表中插一条退款事务
  Procedure return_write_off(p_return_write_off_id   Out Number,
                             p_transaction_id        Number,
                             p_return_transaction_id Number,
                             p_returned_date         Date,
                             p_returned_amount       Number,
                             p_description           Varchar2,
                             p_user_id               Number) Is
    v_write_off_id        Number;
    v_period_name         Varchar2(30);
    v_internal_period_num gld_periods.internal_period_num%Type;
  
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_return_error Exception;
  Begin
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => v_csh_transaction_rec);
  
    --校验退款日期
    If p_returned_date < v_csh_transaction_rec.transaction_date Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_DATE_ERROR';
      Raise e_return_error;
    End If;
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_csh_transaction_rec.company_id,
                                                        p_date       => p_returned_date);
    If v_period_name Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_PERIOD_ERROR';
      Raise e_return_error;
    End If;
    v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_csh_transaction_rec.company_id,
                                                                        p_period_name => v_period_name);
    If v_internal_period_num Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_PERIOD_NUM_ERROR';
      Raise e_return_error;
    End If;
    insert_csh_write_off(p_write_off_id                => v_write_off_id,
                         p_write_off_type              => csh_write_off_pkg.write_off_type_return,
                         p_write_off_date              => Sysdate,
                         p_internal_period_num         => v_internal_period_num,
                         p_period_name                 => v_period_name,
                         p_csh_transaction_id          => v_csh_transaction_rec.transaction_id,
                         p_csh_write_off_amount        => p_returned_amount,
                         p_subsequent_csh_trx_id       => p_return_transaction_id,
                         p_subseq_csh_write_off_amount => p_returned_amount,
                         p_reversed_flag               => csh_transaction_pkg.csh_trx_reversed_flag_n,
                         p_reversed_write_off_id       => '',
                         p_reversed_date               => '',
                         p_cashflow_id                 => '',
                         p_contract_id                 => '',
                         p_times                       => '',
                         p_cf_item                     => '',
                         p_cf_type                     => '',
                         p_penalty_calc_date           => '',
                         p_write_off_due_amount        => '',
                         p_write_off_principal         => '',
                         p_write_off_interest          => '',
                         p_opposite_doc_category       => '',
                         p_opposite_doc_type           => '',
                         p_opposite_doc_id             => '',
                         p_opposite_doc_line_id        => '',
                         p_opposite_doc_detail_id      => '',
                         p_opposite_write_off_amount   => '',
                         p_create_je_mothed            => '',
                         p_create_je_flag              => 'N',
                         p_gld_interface_flag          => 'N',
                         p_description                 => p_description,
                         p_user_id                     => p_user_id);
    --生成退款的退款凭证
    /*csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
    p_user_id        => p_user_id);*/
  
    /*改成使用退款事务来生成凭证*/
    csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_return_transaction_id,
                                                   p_user_id        => p_user_id);
  
    p_return_write_off_id := v_write_off_id;
  Exception
    When e_return_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'return_write_off',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'return_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  End;
  --反冲明细
  Procedure reverse_write_off(p_reverse_write_off_id Out Number,
                              p_write_off_id         Number,
                              p_reversed_date        Date,
                              p_period_name          Varchar2,
                              p_internal_period_num  Number,
                              p_description          Varchar2,
                              p_user_id              Number) Is
    v_write_off_id Number;
  
    v_csh_write_off_rec csh_write_off%Rowtype;
    v_times             Number;
    v_contract_Status   Varchar2(30);
    v_initial_amount    Number;
    v_rl_id             Number;
    v_fee_rate          Number;
    v_valid_date_from   Date;
    v_valid_date_to     Date;
    e_redempted Exception;
    v_INITIAL_RATE  Number;
    v_bp_id_tenant  Number;
    v_linkage_bp_id Number;
    v_linkage_flag  Varchar2(10);
  Begin
  
    lock_csh_write_off(p_write_off_id      => p_write_off_id,
                       p_user_id           => p_user_id,
                       p_csh_write_off_rec => v_csh_write_off_rec);
  
    insert_csh_write_off(p_write_off_id                => v_write_off_id,
                         p_write_off_type              => v_csh_write_off_rec.write_off_type,
                         p_write_off_date              => p_reversed_date,
                         p_internal_period_num         => p_internal_period_num,
                         p_period_name                 => p_period_name,
                         p_csh_transaction_id          => v_csh_write_off_rec.csh_transaction_id,
                         p_csh_write_off_amount        => -1 *
                                                          v_csh_write_off_rec.csh_write_off_amount,
                         p_subsequent_csh_trx_id       => v_csh_write_off_rec.subsequent_csh_trx_id,
                         p_subseq_csh_write_off_amount => -1 *
                                                          v_csh_write_off_rec.subseq_csh_write_off_amount,
                         p_reversed_flag               => csh_transaction_pkg.csh_trx_reversed_flag_r,
                         p_reversed_write_off_id       => v_csh_write_off_rec.write_off_id,
                         p_reversed_date               => p_reversed_date,
                         p_cashflow_id                 => v_csh_write_off_rec.cashflow_id,
                         p_contract_id                 => v_csh_write_off_rec.contract_id,
                         p_times                       => v_csh_write_off_rec.times,
                         p_cf_item                     => v_csh_write_off_rec.cf_item,
                         p_cf_type                     => v_csh_write_off_rec.cf_type,
                         p_penalty_calc_date           => v_csh_write_off_rec.penalty_calc_date,
                         p_write_off_due_amount        => -1 *
                                                          v_csh_write_off_rec.write_off_due_amount,
                         p_write_off_principal         => -1 *
                                                          v_csh_write_off_rec.write_off_principal,
                         p_write_off_interest          => -1 *
                                                          v_csh_write_off_rec.write_off_interest,
                         p_write_off_due_amount_cny    => -1 *
                                                          v_csh_write_off_rec.write_off_due_amount_cny,
                         p_write_off_principal_cny     => -1 *
                                                          v_csh_write_off_rec.write_off_principal_cny,
                         p_write_off_interest_cny      => -1 *
                                                          v_csh_write_off_rec.write_off_interest_cny,
                         
                         p_exchange_rate => v_csh_write_off_rec.exchange_rate,
                         
                         p_opposite_doc_category     => v_csh_write_off_rec.opposite_doc_category,
                         p_opposite_doc_type         => v_csh_write_off_rec.opposite_doc_type,
                         p_opposite_doc_id           => v_csh_write_off_rec.opposite_doc_id,
                         p_opposite_doc_line_id      => v_csh_write_off_rec.opposite_doc_line_id,
                         p_opposite_doc_detail_id    => v_csh_write_off_rec.opposite_doc_detail_id,
                         p_opposite_write_off_amount => -1 *
                                                        v_csh_write_off_rec.opposite_write_off_amount,
                         p_create_je_mothed          => v_csh_write_off_rec.create_je_mothed,
                         p_create_je_flag            => 'N',
                         p_gld_interface_flag        => 'N',
                         p_description               => p_description,
                         p_user_id                   => p_user_id,
                         p_bp_id                     => v_csh_write_off_rec.bp_id);
    --更新被反冲的核销事务
    upd_write_off_after_reverse(p_write_off_id          => p_write_off_id,
                                p_reversed_date         => p_reversed_date,
                                p_reserved_write_off_id => v_write_off_id,
                                p_user_id               => p_user_id);
    p_reverse_write_off_id := v_write_off_id;
    Begin
      Select contract_status
        Into v_contract_Status
        From con_contract
       Where contract_id = v_csh_write_off_rec.contract_id;
    
    Exception
      When no_data_found Then
        Null;
    End;
    --反冲赎证款 特殊处理 addby wuts 2019-1-22
    If v_csh_write_off_rec.cf_item = 302 Then
    
      If v_contract_Status = 'REDEMPTED' Then
      
        --将冻结管理费放开
      
        --最后一期管理费期数
        Select Max(times)
          Into v_times
          From con_contract_cashflow
         Where contract_id = v_csh_write_off_rec.contract_id
           And cf_item = 301
           And cf_status = 'RELEASE'
           And cf_direction = 'INFLOW';
      
        --还原回去金额
        Update con_contract_cashflow
           Set due_date         = ln_user_col_d05,
               calc_date        = ln_user_col_d05,
               fin_income_date  = ln_user_col_d05,
               due_amount       = round(due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               net_due_amount   = round(net_due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               vat_due_amount   = round(vat_due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               interest         = round(due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               net_interest     = round(net_due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               vat_interest     = round(vat_due_amount / ln_user_col_n06 *
                                        ln_user_col_n05,
                                        2),
               last_updated_by  = p_user_id,
               last_update_date = Sysdate
         Where contract_id = v_csh_write_off_rec.contract_id
           And times = v_times
           And cf_item = 301
           And cf_status = 'RELEASE'
           And cf_direction = 'INFLOW';
        --解除冻结
        Update con_contract_cashflow
           Set cf_status = 'RELEASE'
         Where contract_id = v_csh_write_off_rec.contract_id
           And cf_item = 301
           And cf_status = 'BLOCK'
           And cf_direction = 'INFLOW';
        --更新状态   从已赎证 还原到  起息
        Update con_contract
           Set contract_status = 'INCEPT'
         Where contract_id = v_csh_write_off_rec.contract_id
           And contract_status = 'REDEMPTED';
        --已结清  到审批通过
        Update prj_project
           Set project_status = 'APPROVED'
         Where project_id =
               (Select project_id
                  From con_contract
                 Where contract_id = v_csh_write_off_rec.contract_id)
           And project_status = 'SETTLED';
      End If;
    
      --反冲赎证款 特殊处理 addby wuts 2019-1-22
    Elsif v_csh_write_off_rec.cf_item = 300 Then
    
      If v_contract_Status = 'REDEMPTED' Or
         v_contract_Status = 'REDEMPTING' Then
        Raise e_redempted;
      End If;
      --经销商
      Select bp_id_tenant
        Into v_bp_id_tenant
        From con_contract
       Where contract_id = v_csh_write_off_rec.contract_id;
      --初始利率
      Select initial_rate
        Into v_initial_rate
        From hls_bp_master
       Where bp_id = v_bp_id_tenant;
      --现管理费利率
      Select fee_rate, valid_date_from, valid_date_to
        Into v_fee_rate, v_valid_date_from, v_valid_date_to
        From con_df_manage_fee_rate
       Where contract_id = v_csh_write_off_rec.contract_id
         And rownum = 1;
      If v_fee_rate = v_initial_rate Then
      
        --con_df_manage_fee_rate删除车辆信息管理费率
        Delete con_df_manage_fee_rate
         Where contract_id = v_csh_write_off_rec.contract_id;
      Else
      
        --反冲金额
        Select due_amount
          Into v_initial_amount
          From con_contract_cashflow
         Where contract_id = v_csh_write_off_rec.contract_id
           And cf_item = 302
           And cf_status = 'RELEASE';
      
        --释放额度
        --addby wuts 2019-3-13 联动利率改造
        Select nvl(linkage_flag, 'N')
          Into v_linkage_flag
          From hls_bp_master
         Where bp_id = v_bp_id_tenant;
        If v_linkage_flag = 'Y' Then
          v_linkage_bp_id := v_bp_id_tenant;
        Else
          Select bp_id
            Into v_linkage_bp_id
            From hls_bp_master t1
           Where parent_id = (Select parent_id
                                From hls_bp_master
                               Where bp_id = v_bp_id_tenant)
             And linkage_flag = 'Y';
        End If;
      
        -- end addby wuts
      
        Select rl_id
          Into v_rl_id
          From hl_rate_linkage
         Where bp_id = v_linkage_bp_id -- v_bp_id_tenant modify by wuts
           And v_fee_rate = prime_rate
           And trunc(the_limit_is_valid_from) <= trunc(v_valid_date_from)
           And trunc(the_limit_is_valid_to) >= trunc(v_valid_date_to);
      
        Update hl_rate_linkage t
           Set t.residual_preferential_limit = t.residual_preferential_limit +
                                               v_initial_amount,
               
               t.last_update_date = Sysdate,
               t.last_updated_by  = p_user_id
         Where rl_id = v_rl_id;
      
        --con_df_manage_fee_rate删除车辆信息管理费率
        Delete con_df_manage_fee_rate
         Where contract_id = v_csh_write_off_rec.contract_id;
      
        --赎证费期数 日期调回
        Update con_contract_cashflow
           Set times           = 0,
               due_date       =
               (Select due_date
                  From con_contract_cashflow
                 Where cashflow_id = v_csh_write_off_rec.cashflow_id),
               calc_date      =
               (Select calc_date
                  From con_contract_cashflow
                 Where cashflow_id = v_csh_write_off_rec.cashflow_id),
               fin_income_date =
               (Select fin_income_date
                  From con_contract_cashflow
                 Where cashflow_id = v_csh_write_off_rec.cashflow_id)
         Where contract_id = v_csh_write_off_rec.contract_id
           And cf_item = 302
           And cf_status = 'RELEASE';
        /*
        update con_contract t
           set t.contract_status    = 'INCEPT',
               t.lease_start_date   = p_pay_date,
               t.inception_of_lease = p_pay_date,
               t.lease_end_date     = v_end_date,
               t.last_update_date   = sysdate,
               t.last_updated_by    = p_user_id
         where t.contract_id = payment_req_rec.ref_doc_id;*/
      End If;
    
    End If;
  
  Exception
    When e_redempted Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.E_REDEMPTED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'reverse_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'reverse_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --核销反冲主入口（收款核销债权反冲，预收款核销债权反冲，收款核销预收款反冲，退款反冲，付款反冲）
  Procedure reverse_write_off(p_reverse_write_off_id Out Number,
                              p_write_off_id         Number,
                              p_reversed_date        Date,
                              p_description          Varchar2,
                              p_user_id              Number,
                              p_from_csh_trx_flag    Varchar2 Default 'N') Is
  
    v_csh_write_off_rec         csh_write_off%Rowtype;
    v_csh_reverse_write_off_rec csh_write_off%Rowtype;
    v_csh_transaction_rec       csh_transaction%Rowtype;
    v_subsequent_csh_trx_rec    csh_transaction%Rowtype;
    v_con_cashflow_rec          con_contract_cashflow%Rowtype;
    v_internal_period_num       gld_periods.internal_period_num%Type;
  
    v_reverse_write_off_id Number;
    v_transaction_id       Number;
    v_period_name          Varchar2(30);
  
    e_reverse_error Exception;
    v_contract_count Number;
    v_write301_count Number;
  Begin
    lock_csh_write_off(p_write_off_id      => p_write_off_id,
                       p_user_id           => p_user_id,
                       p_csh_write_off_rec => v_csh_write_off_rec);
  
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.csh_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => v_csh_transaction_rec);
    If v_csh_write_off_rec.write_off_type = write_off_type_return Then
      csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.subsequent_csh_trx_id,
                                               p_user_id             => p_user_id,
                                               p_csh_transaction_rec => v_csh_transaction_rec);
    Elsif v_csh_write_off_rec.write_off_type = write_off_type_receipt_pre Then
      csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.subsequent_csh_trx_id,
                                               p_user_id             => p_user_id,
                                               p_csh_transaction_rec => v_subsequent_csh_trx_rec);
    End If;
  
    --保理融资额反冲
    If v_csh_write_off_rec.cf_item In ('300') Then
    
      Select Count(1)
        Into v_contract_count
        From con_contract cc
       Where cc.contract_id = v_csh_write_off_rec.contract_id
         And cc.contract_status In ('REDEMPTING', 'REDEMPTED');
      If v_contract_count > 0 Then
        v_err_code := 'CSH_WRITE_OFF_PKG.CONTRACT_COUNT';
        Raise e_reverse_error;
      End If;
      Select Count(1)
        Into v_write301_count
        From con_contract_cashflow cc
       Where contract_id = v_csh_write_off_rec.contract_id
         And cc.cf_item = 301
         And cc.cf_status = 'RELEASE'
         And nvl(write_off_flag, 'NOT') != 'NOT';
      If v_write301_count > 0 Then
        v_err_code := 'CSH_WRITE_OFF_PKG.WRITE301_COUNT';
        Raise e_reverse_error;
      End If;
    Elsif v_csh_write_off_rec.cf_item = '303' Then
      Select Count(1)
        Into v_contract_count
        From con_contract cc
       Where cc.contract_id = v_csh_write_off_rec.contract_id
         And cc.contract_status In ('REDEMPTING', 'REDEMPTED', 'INCEPT');
      If v_contract_count > 0 Then
        v_err_code := 'CSH_WRITE_OFF_PKG.CONTRACT_COUNT_F';
        Raise e_reverse_error;
      End If;
    Elsif v_csh_write_off_rec.cf_item = '302' Then
      Select Count(1)
        Into v_contract_count
        From con_contract cc
       Where cc.contract_id = v_csh_write_off_rec.contract_id
         And cc.contract_status In ('REDEMPTING', 'REDEMPTED');
      If v_contract_count > 0 Then
        v_err_code := 'CSH_WRITE_OFF_PKG.CONTRACT_COUNT';
        Raise e_reverse_error;
      End If;
    End If;
  
    If p_from_csh_trx_flag = 'N' And
       v_csh_write_off_rec.write_off_type In
       (write_off_type_return, write_off_type_payment_debt) Then
      v_err_code := 'CSH_WRITE_OFF_PKG.WRITEOFF_SOURCE_ERROR';
      Raise e_reverse_error;
    End If;
    If p_from_csh_trx_flag = 'N' And
       nvl(v_csh_transaction_rec.transaction_amount, 0) != 0 And
       v_csh_write_off_rec.write_off_type In
       (write_off_type_return, write_off_type_payment_debt) Then
      v_err_code := 'CSH_WRITE_OFF_PKG.WRITEOFF_SOURCE_ERROR';
      Raise e_reverse_error;
    End If;
    If Not is_write_off_reverse(v_csh_transaction_rec, p_user_id) Then
      Raise e_reverse_error;
    End If;
    --校验反冲日期
    If p_reversed_date < v_csh_write_off_rec.write_off_date Then
      v_err_code := 'CSH_WRITE_OFF_PKG.REVERSE_WRITE_OFF_DATE_ERROR';
      Raise e_reverse_error;
    End If;
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_csh_transaction_rec.company_id,
                                                        p_date       => p_reversed_date);
    If v_period_name Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_ERROR';
      Raise e_reverse_error;
    End If;
    v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_csh_transaction_rec.company_id,
                                                                        p_period_name => v_period_name);
    If v_internal_period_num Is Null Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_NUM_ERROR';
      Raise e_reverse_error;
    End If;
    --收款核销预收款反冲
    If v_csh_write_off_rec.write_off_type =
       csh_write_off_pkg.write_off_type_receipt_pre Then
      csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
                                                 p_transaction_num         => '',
                                                 p_transaction_category    => v_subsequent_csh_trx_rec.transaction_category,
                                                 p_transaction_type        => v_subsequent_csh_trx_rec.transaction_type,
                                                 p_transaction_date        => p_reversed_date,
                                                 p_penalty_calc_date       => v_subsequent_csh_trx_rec.penalty_calc_date,
                                                 p_bank_slip_num           => v_subsequent_csh_trx_rec.bank_slip_num,
                                                 p_company_id              => v_subsequent_csh_trx_rec.company_id,
                                                 p_internal_period_num     => v_internal_period_num,
                                                 p_period_name             => v_period_name,
                                                 p_payment_method_id       => v_subsequent_csh_trx_rec.payment_method_id,
                                                 p_distribution_set_id     => v_subsequent_csh_trx_rec.distribution_set_id,
                                                 p_cashflow_amount         => -1 *
                                                                              v_subsequent_csh_trx_rec.cashflow_amount,
                                                 p_currency_code           => v_subsequent_csh_trx_rec.currency_code,
                                                 p_transaction_amount      => -1 *
                                                                              v_subsequent_csh_trx_rec.transaction_amount,
                                                 p_exchange_rate_type      => v_subsequent_csh_trx_rec.exchange_rate_type,
                                                 p_exchange_rate_quotation => v_subsequent_csh_trx_rec.exchange_rate_quotation,
                                                 p_exchange_rate           => v_subsequent_csh_trx_rec.exchange_rate,
                                                 p_bank_account_id         => v_subsequent_csh_trx_rec.bank_account_id,
                                                 p_bp_category             => v_subsequent_csh_trx_rec.bp_category,
                                                 p_bp_id                   => v_subsequent_csh_trx_rec.bp_id,
                                                 p_bp_bank_account_id      => v_subsequent_csh_trx_rec.bp_bank_account_id,
                                                 p_bp_bank_account_num     => v_subsequent_csh_trx_rec.bp_bank_account_num,
                                                 p_description             => p_description,
                                                 p_handling_charge         => v_subsequent_csh_trx_rec.handling_charge,
                                                 p_posted_flag             => csh_transaction_pkg.csh_trx_posted_flag_yes,
                                                 p_reversed_flag           => csh_transaction_pkg.csh_trx_reversed_flag_r,
                                                 p_reversed_date           => '',
                                                 p_returned_flag           => v_subsequent_csh_trx_rec.returned_flag,
                                                 p_returned_amount         => v_subsequent_csh_trx_rec.returned_amount,
                                                 p_write_off_flag          => v_subsequent_csh_trx_rec.write_off_flag,
                                                 p_write_off_amount        => v_subsequent_csh_trx_rec.write_off_amount,
                                                 p_full_write_off_date     => v_subsequent_csh_trx_rec.full_write_off_date,
                                                 p_twin_csh_trx_id         => v_subsequent_csh_trx_rec.twin_csh_trx_id,
                                                 p_return_from_csh_trx_id  => v_subsequent_csh_trx_rec.return_from_csh_trx_id,
                                                 p_reversed_csh_trx_id     => v_subsequent_csh_trx_rec.transaction_id,
                                                 p_source_csh_trx_type     => v_subsequent_csh_trx_rec.source_csh_trx_type,
                                                 p_source_csh_trx_id       => v_subsequent_csh_trx_rec.source_csh_trx_id,
                                                 p_source_doc_category     => v_subsequent_csh_trx_rec.source_doc_category,
                                                 p_source_doc_type         => v_subsequent_csh_trx_rec.source_doc_type,
                                                 p_source_doc_id           => v_subsequent_csh_trx_rec.source_doc_id,
                                                 p_source_doc_line_id      => v_subsequent_csh_trx_rec.source_doc_line_id,
                                                 p_create_je_mothed        => v_subsequent_csh_trx_rec.create_je_mothed,
                                                 p_create_je_flag          => 'N',
                                                 p_gld_interface_flag      => 'N',
                                                 p_user_id                 => p_user_id);
      --更新被反冲现金事务
      csh_transaction_pkg.update_csh_trx_after_reverse(p_transaction_id      => v_subsequent_csh_trx_rec.transaction_id,
                                                       p_reversed_date       => p_reversed_date,
                                                       p_reserved_csh_trx_id => v_transaction_id,
                                                       p_user_id             => p_user_id);
    End If;
    --核销反冲后更新被反冲现金事务核销金额
    csh_transaction_pkg.update_trx_amt_after_reverse(p_transaction_id => v_csh_write_off_rec.csh_transaction_id,
                                                     p_reverse_amount => nvl(v_csh_write_off_rec.write_off_due_amount_cny,
                                                                             v_csh_write_off_rec.write_off_due_amount),
                                                     p_user_id        => p_user_id);
  
    --反冲核销明细
    reverse_write_off(p_reverse_write_off_id => v_reverse_write_off_id,
                      p_write_off_id         => p_write_off_id,
                      p_reversed_date        => p_reversed_date,
                      p_period_name          => v_period_name,
                      p_internal_period_num  => v_internal_period_num,
                      p_description          => p_description,
                      p_user_id              => p_user_id);
  
    If v_csh_write_off_rec.write_off_type In
       (write_off_type_receipt_credit,
        write_off_type_pre_credit,
        write_off_type_payment_debt) Then
      lock_con_contract_cashflow(p_cashflow_id      => v_csh_write_off_rec.cashflow_id,
                                 p_user_id          => p_user_id,
                                 p_con_cashflow_rec => v_con_cashflow_rec);
      --更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
      lock_csh_write_off(p_write_off_id      => v_reverse_write_off_id,
                         p_user_id           => p_user_id,
                         p_csh_write_off_rec => v_csh_reverse_write_off_rec);
    
      set_con_cfw_after_writeoff(p_con_cashflow_rec  => v_con_cashflow_rec,
                                 p_csh_write_off_rec => v_csh_reverse_write_off_rec,
                                 p_user_id           => p_user_id);
      If v_csh_reverse_write_off_rec.cf_item = 56 Then
        Update csh_transaction ct
           Set ct.transaction_amount = ct.transaction_amount +
                                       v_csh_reverse_write_off_rec.write_off_due_amount
         Where ct.transaction_type = 'RISK';
      End If;
    
      If v_csh_reverse_write_off_rec.cf_item = 55 Then
        Update csh_transaction ct
           Set ct.transaction_amount = ct.transaction_amount +
                                       v_csh_reverse_write_off_rec.write_off_due_amount
         Where ct.transaction_type = 'DEPOSIT'
           And ct.returned_flag != 'RETURN'
           And ct.bp_id =
               (Select cc.bp_id_agent_level1
                  From con_contract cc
                 Where cc.contract_id =
                       v_csh_reverse_write_off_rec.contract_id);
      End If;
    
    End If;
  
    If v_csh_write_off_rec.write_off_type = write_off_type_deposit Then
      -- modify by qianming ,20140825，保证金反冲无关联现金流，注释
      /*lock_con_contract_cashflow(p_cashflow_id      => v_csh_write_off_rec.cashflow_id,
      p_user_id          => p_user_id,
      p_con_cashflow_rec => v_con_cashflow_rec);*/
      --更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
      lock_csh_write_off(p_write_off_id      => v_reverse_write_off_id,
                         p_user_id           => p_user_id,
                         p_csh_write_off_rec => v_csh_reverse_write_off_rec);
    
      Null;
      --核销保证金池(反冲) by zl
      deposit_write_off(p_write_off_rec => v_csh_reverse_write_off_rec,
                        p_user_id       => p_user_id);
    Elsif v_csh_write_off_rec.write_off_type = write_off_type_risk Then
      lock_csh_write_off(p_write_off_id      => v_reverse_write_off_id,
                         p_user_id           => p_user_id,
                         p_csh_write_off_rec => v_csh_reverse_write_off_rec);
    
      others_write_off(p_write_off_rec    => v_csh_reverse_write_off_rec,
                       p_user_id          => p_user_id,
                       p_transaction_type => csh_write_off_pkg.write_off_type_risk);
      --反冲客户保证金                   
    Elsif v_csh_write_off_rec.write_off_type = write_off_type_deposit_cus Then
      lock_csh_write_off(p_write_off_id      => v_reverse_write_off_id,
                         p_user_id           => p_user_id,
                         p_csh_write_off_rec => v_csh_reverse_write_off_rec);
      Update con_contract_cashflow ca
         Set ca.due_amount = ca.due_amount +
                             v_csh_reverse_write_off_rec.write_off_due_amount
       Where ca.cashflow_id = v_csh_reverse_write_off_rec.cashflow_id;
    End If;
  
    --生成单笔核销反冲事务凭证
    csh_transaction_je_pkg.create_write_off_reverse_je(p_write_off_id => v_reverse_write_off_id,
                                                       p_user_id      => p_user_id);
    --生产核销反冲凭证
    csh_transaction_je_pkg.create_trx_writeoff_reverse_je(p_transaction_id => v_csh_write_off_rec.csh_transaction_id,
                                                          p_reversed_date  => p_reversed_date,
                                                          p_user_id        => p_user_id);
  
    --add by wdd 20180524
    --核销反冲凭证
    csh_transaction_je_pkg.hl_create_trx_wf_reverse_je(p_transaction_id => v_csh_write_off_rec.csh_transaction_id,
                                                       p_reversed_date  => p_reversed_date,
                                                       p_user_id        => p_user_id);
    --end
    p_reverse_write_off_id := v_reverse_write_off_id;
  Exception
    When e_reverse_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'reverse_write_off',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'reverse_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure after_write_off(p_contract_id Number, p_user_id Number) Is
    v_contract_rec con_contract%Rowtype;
    v_count        Number;
  Begin
    Select *
      Into v_contract_rec
      From con_contract cc
     Where cc.contract_id = p_contract_id;
  
    If v_contract_rec.contract_status = 'INCEPT' Then
      Select Count(*)
        Into v_count
        From con_contract_cashflow ccc
       Where ccc.contract_id = v_contract_rec.contract_id
         And ccc.cf_item In (1, 8, 9, 55, 56, 913)
         And ccc.times != 0
         And (ccc.cf_status != 'RELEASE' Or ccc.write_off_flag != 'FULL');
    
      If v_count = 0 Then
        Update con_contract cc
           Set cc.contract_status  = 'TERMINATE',
               cc.last_updated_by  = p_user_id,
               cc.last_update_date = Sysdate
         Where cc.contract_id = v_contract_rec.contract_id;
      End If;
    End If;
  End after_write_off;

  --明细核销情况

  /*收款核销预收款增加传送ref_contract_id*/
  Procedure execute_write_off(p_write_off_id        Number,
                              p_cross_currency_flag Varchar2 Default 'N',
                              p_user_id             Number) Is
    v_write_off_rec    csh_write_off%Rowtype;
    v_csh_trx_rec      csh_transaction%Rowtype;
    v_con_cashflow_rec con_contract_cashflow%Rowtype;
  
    v_transaction_id Number;
    v_cf_item        Number;
    v_description    Varchar2(2000);
    v_lease_channel  Varchar2(10); --add by lara 11355 20181212 增加DF系统付款起租
    e_csh_trx_error Exception;
  Begin
    Select *
      Into v_write_off_rec
      From csh_write_off
     Where write_off_id = p_write_off_id;
  
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_write_off_rec.csh_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => v_csh_trx_rec);
  
    csh_write_off_custom_pkg.before_write_off(p_write_off_id => p_write_off_id,
                                              p_user_id      => p_user_id);
  
    --核销前金额校验
    check_before_write_off(p_csh_write_off_rec   => v_write_off_rec,
                           p_csh_trx_rec         => v_csh_trx_rec,
                           p_cross_currency_flag => p_cross_currency_flag,
                           p_user_id             => p_user_id);
  
    --收款(预收款)核销债权
    If v_write_off_rec.write_off_type In
       (write_off_type_receipt_credit,
        write_off_type_pre_credit,
        write_off_type_deposit_credit,
        write_off_type_payment_debt,
        write_off_type_risk_credit) And
       v_csh_trx_rec.transaction_type In
       (csh_transaction_pkg.csh_trx_type_receipt,
        csh_transaction_pkg.csh_trx_type_prereceipt,
        csh_transaction_pkg.csh_trx_type_payment,
        csh_transaction_pkg.csh_trx_type_deduction,
        csh_transaction_pkg.csh_trx_type_deposit,
        csh_transaction_pkg.csh_trx_type_risk) And
       v_csh_trx_rec.transaction_category =
       csh_transaction_pkg.csh_trx_category_business Then
      lock_con_contract_cashflow(p_cashflow_id      => v_write_off_rec.cashflow_id,
                                 p_user_id          => p_user_id,
                                 p_con_cashflow_rec => v_con_cashflow_rec);
    
      --更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
      set_con_cfw_after_writeoff(p_con_cashflow_rec  => v_con_cashflow_rec,
                                 p_csh_write_off_rec => v_write_off_rec,
                                 p_user_id           => p_user_id);
    
      -- 如果是收款核销提前结清，保证金，多退少补，判断是否结清
      -- add by qianming 20150520
      If v_con_cashflow_rec.cf_item In (200, 52, 10, 11, 13, 8, 57, 58) Then
        con_contract_et_pkg.et_judge_receipted(p_contract_id => v_con_cashflow_rec.contract_id,
                                               p_cashflow_id => v_con_cashflow_rec.cashflow_id,
                                               p_user_id     => p_user_id);
      End If;
    
      If v_con_cashflow_rec.cf_item In (1, 8, 9, 55, 56, 913) Then
        after_write_off(p_contract_id => v_con_cashflow_rec.contract_id,
                        p_user_id     => p_user_id);
      End If;
    
      hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CSH_TRX',
                                                             p_document_id       => v_csh_trx_rec.transaction_id,
                                                             p_operation_code    => write_off_type_receipt_credit,
                                                             p_user_id           => p_user_id,
                                                             p_operation_time    => Sysdate,
                                                             p_description       => '现金事务编号[' ||
                                                                                    v_csh_trx_rec.transaction_num ||
                                                                                    '],核销金额:' ||
                                                                                    v_write_off_rec.csh_write_off_amount);
      /* if v_con_cashflow_rec.cf_item = '55' and
         v_con_cashflow_rec.cf_direction = 'INFLOW' and
         v_write_off_rec.write_off_type = write_off_type_receipt_credit then
        -- 收款核销现金流项目为保证金池，自动生成 保证金池事务 by zl
        insert_deposit_write_off(p_con_cashflow_rec         => v_con_cashflow_rec,
                                 p_source_csh_write_off_rec => v_write_off_rec,
                                 p_user_id                  => p_user_id);
      elsif
        v_con_cashflow_rec.cf_direction = 'INFLOW' and
         v_write_off_rec.write_off_type = write_off_type_receipt_credit then --风险金处理
         insert_risk_write_off(p_con_cashflow_rec         => v_con_cashflow_rec,
                                 p_source_csh_write_off_rec => v_write_off_rec,
                                 p_user_id                  => p_user_id);
      end if;*/
    
      --add by wcs 2014-10-30
      --modify by lara 11355 20181212 DF系统增加付款起租逻辑
      Select cc.lease_channel
        Into v_lease_channel
        From con_contract cc
       Where cc.contract_id = v_con_cashflow_rec.contract_id;
      If v_lease_channel = '01' Then
        con_contract_pkg.contract_incept_automatic(p_contract_id => v_con_cashflow_rec.contract_id,
                                                   p_incept_date => to_date(v_write_off_rec.write_off_date),
                                                   p_user_id     => p_user_id);
      End If;
      --end  modfy by lara 11355 20181212
    
    Elsif v_write_off_rec.write_off_type =
          csh_write_off_pkg.write_off_type_receipt_pre And
          v_csh_trx_rec.transaction_type =
          csh_transaction_pkg.csh_trx_type_receipt And
          v_csh_trx_rec.transaction_category =
          csh_transaction_pkg.csh_trx_category_business Then
      Select co.description
        Into v_description
        From csh_write_off_temp co
       Where co.transaction_id = v_write_off_rec.csh_transaction_id
         And co.write_off_type = 'RECEIPT_ADVANCE_RECEIPT';
      csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
                                                 p_transaction_num         => '',
                                                 p_transaction_category    => csh_transaction_pkg.csh_trx_category_business,
                                                 p_transaction_type        => csh_transaction_pkg.csh_trx_type_prereceipt,
                                                 p_transaction_date        => v_write_off_rec.write_off_date,
                                                 p_penalty_calc_date       => v_write_off_rec.write_off_date,
                                                 p_bank_slip_num           => v_csh_trx_rec.bank_slip_num,
                                                 p_company_id              => v_csh_trx_rec.company_id,
                                                 p_internal_period_num     => v_csh_trx_rec.internal_period_num,
                                                 p_period_name             => v_csh_trx_rec.period_name,
                                                 p_payment_method_id       => v_csh_trx_rec.payment_method_id,
                                                 p_distribution_set_id     => v_csh_trx_rec.distribution_set_id,
                                                 p_cashflow_amount         => v_write_off_rec.csh_write_off_amount,
                                                 p_currency_code           => v_csh_trx_rec.currency_code,
                                                 p_transaction_amount      => v_write_off_rec.csh_write_off_amount,
                                                 p_exchange_rate_type      => v_csh_trx_rec.exchange_rate_type,
                                                 p_exchange_rate_quotation => v_csh_trx_rec.exchange_rate_quotation,
                                                 p_exchange_rate           => v_csh_trx_rec.exchange_rate,
                                                 p_bank_account_id         => v_csh_trx_rec.bank_account_id,
                                                 p_bp_category             => v_csh_trx_rec.bp_category,
                                                 p_bp_id                   => v_csh_trx_rec.bp_id,
                                                 p_bp_bank_account_id      => v_csh_trx_rec.bp_bank_account_id,
                                                 p_bp_bank_account_num     => v_csh_trx_rec.bp_bank_account_num,
                                                 p_description             => v_csh_trx_rec.description /*|| '||' ||  v_description*/,
                                                 p_handling_charge         => v_csh_trx_rec.handling_charge,
                                                 p_posted_flag             => csh_transaction_pkg.csh_trx_posted_flag_yes,
                                                 p_reversed_flag           => csh_transaction_pkg.csh_trx_reversed_flag_n,
                                                 p_reversed_date           => '',
                                                 p_returned_flag           => csh_transaction_pkg.csh_trx_return_flag_n,
                                                 p_returned_amount         => '',
                                                 p_write_off_flag          => csh_transaction_pkg.csh_trx_write_off_flag_n,
                                                 p_write_off_amount        => '',
                                                 p_full_write_off_date     => '',
                                                 p_twin_csh_trx_id         => '',
                                                 p_return_from_csh_trx_id  => '',
                                                 p_reversed_csh_trx_id     => '',
                                                 p_source_csh_trx_type     => csh_transaction_pkg.csh_trx_type_receipt,
                                                 p_source_csh_trx_id       => v_write_off_rec.csh_transaction_id,
                                                 p_source_doc_category     => '',
                                                 p_source_doc_type         => '',
                                                 p_source_doc_id           => '',
                                                 p_source_doc_line_id      => '',
                                                 p_create_je_mothed        => '',
                                                 p_create_je_flag          => 'N',
                                                 p_gld_interface_flag      => 'N',
                                                 p_user_id                 => p_user_id,
                                                 p_ref_contract_id         => v_csh_trx_rec.ref_contract_id,
                                                 p_lease_channel           => v_csh_trx_rec.lease_channel,
                                                 p_guangsan_flag           => v_csh_trx_rec.guangsan_flag); --add by xuls 2014-9-26 for ref_contract_id
      --更新subsequent_csh_trx_id等字段信息
      update_subsequent_csh_trx_id(p_write_off_id   => p_write_off_id,
                                   p_transaction_id => v_transaction_id,
                                   p_user_id        => p_user_id);
    
      hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CSH_TRX',
                                                             p_document_id       => v_write_off_rec.csh_transaction_id,
                                                             p_operation_code    => write_off_type_receipt_pre,
                                                             p_user_id           => p_user_id,
                                                             p_operation_time    => Sysdate,
                                                             p_description       => '现金事务编号[' ||
                                                                                    v_csh_trx_rec.transaction_num ||
                                                                                    '],核销金额:' ||
                                                                                    v_write_off_rec.csh_write_off_amount);
    
      --预收款不能核销为预收款
    Elsif v_write_off_rec.write_off_type =
          csh_write_off_pkg.write_off_type_receipt_pre And
          v_csh_trx_rec.transaction_type =
          csh_transaction_pkg.csh_trx_type_prereceipt And
          v_csh_trx_rec.transaction_category =
          csh_transaction_pkg.csh_trx_category_business Then
      v_err_code := 'CSH_WRITE_OFF_PKG.PRE_WRITE_OFF_PRE_ERROR';
      Raise e_csh_trx_error; --2017/05/04 吉利所有的现金事务必须完全核销，预收款部分核销时必须再次核销为预收款
    Elsif v_write_off_rec.write_off_type =
          csh_write_off_pkg.write_off_type_deposit Then
      --核销保证金池 by zl
      deposit_write_off(p_write_off_rec => v_write_off_rec,
                        p_user_id       => p_user_id);
    Elsif v_write_off_rec.write_off_type = --风险金处理
          csh_write_off_pkg.write_off_type_risk Then
      others_write_off(p_write_off_rec    => v_write_off_rec,
                       p_user_id          => p_user_id,
                       p_transaction_type => csh_write_off_pkg.write_off_type_risk);
    Elsif v_write_off_rec.write_off_type = --核销为客户保证金处理
          csh_write_off_pkg.write_off_type_deposit_cus Then
      deposit_cus_write_off(p_write_off_rec => v_write_off_rec,
                            p_user_id       => p_user_id);
    End If;
    If nvl(v_csh_trx_rec.transaction_amount, 0) = 0 Then
      Null;
    Else
      --更新原现金事务核销相关字段
    
      csh_transaction_pkg.set_csh_trx_write_off_status(p_csh_trx_rec      => v_csh_trx_rec,
                                                       p_write_off_amount => v_write_off_rec.csh_write_off_amount,
                                                       p_user_id          => p_user_id);
    
    End If;
    --生成单笔核销事务凭证
    --modify by lara 11355 20181213 DF系统凭证未确定，先注释
    csh_transaction_je_pkg.create_write_off_je(p_write_off_id => p_write_off_id,
                                               p_user_id      => p_user_id);
  
    csh_write_off_custom_pkg.after_write_off(p_write_off_id => p_write_off_id,
                                             p_user_id      => p_user_id);
  Exception
    When e_csh_trx_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_write_off',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_trx_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'execute_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --核销主入口
  Procedure main_write_off(p_session_id          Number,
                           p_transaction_id      Number,
                           p_cross_currency_flag Varchar2 Default 'N',
                           p_receipt_flag        Varchar2 Default Null,
                           p_user_id             Number) Is
    csh_transaction_rec        csh_transaction%Rowtype;
    v_functional_currency_code gld_set_of_books.functional_currency_code%Type;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%Type;
    v_write_off_id             Number;
    v_amount                   Number;
    e_main_error Exception;
    i                      Number := 0;
    v_count                Number;
    r_hl_transaction_split hl_transaction_split%Rowtype;
    v_hl_sp_id             Number;
    v_write_off_amount     Number;
    v_fin_create_je_flag   Varchar2(100);
  Begin
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => csh_transaction_rec);
  
    If csh_transaction_rec.transaction_category <>
       csh_transaction_pkg.csh_trx_category_business Then
      v_err_code := 'CSH_WRITE_OFF_PKG.TRX_CATEGORY_ERROR';
      Raise e_main_error;
    End If;
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => csh_transaction_rec.company_id);
    If v_functional_currency_code Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_FUNCTIONAL_CURRENCY_ERROR';
      Raise e_main_error;
    End If;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => csh_transaction_rec.company_id);
    If v_set_of_books_id Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_SET_OF_BOOKS_ERROR';
      Raise e_main_error;
    End If;
    For c_write_off_temp In (Select *
                               From csh_write_off_temp t
                              Where t.session_id = p_session_id
                             /* AND t.wfl_instance_id IS NULL  -- modify by 8754 20181218 宏菱租赁不要走工作流，去除该过滤条件
                             AND t.transaction_id IS NULL*/
                             ) Loop
      v_write_off_id := insert_csh_write_off(p_csh_write_off_temp_rec => c_write_off_temp,
                                             p_csh_transaction_rec    => csh_transaction_rec,
                                             p_set_of_books_id        => v_set_of_books_id,
                                             p_cross_currency_flag    => p_cross_currency_flag,
                                             p_user_id                => p_user_id);
    
      execute_write_off(p_write_off_id        => v_write_off_id,
                        p_cross_currency_flag => p_cross_currency_flag,
                        p_user_id             => p_user_id);
      --保证金核销租金,新增一条保证金outflow的核销记录
    
    --收款核销，处理对应的已生成的坐扣数据
    /*IF p_receipt_flag = 'Y' THEN
                                                                                                                                                                                                                    BEGIN
                                                                                                                                                                                                                      SELECT d.amount
                                                                                                                                                                                                                        INTO v_amount
                                                                                                                                                                                                                        FROM csh_payment_req_ln_ddct d
                                                                                                                                                                                                                       WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                                                                         AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                                                                         AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                                                                         AND d.deduction_flag = 'N';
                                                                                                                                                                                                                      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'v_amount:' || v_amount || ',write_off_due_amount:' ||
                                                                                                                                                                                                                                                                                                   c_write_off_temp.write_off_due_amount,
                                                                                                                                                                                                                                                                      p_created_by              => p_user_id,
                                                                                                                                                                                                                                                                      p_package_name            => 'csh_write_off_pkg',
                                                                                                                                                                                                                                                                      p_procedure_function_name => 'test_main_write_off');
                                                                                                                                                                                                                      IF v_amount - c_write_off_temp.write_off_due_amount <= 0 THEN
                                                                                                                                                                                                                        DELETE FROM csh_payment_req_ln_ddct d
                                                                                                                                                                                                                         WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                                                                           AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                                                                           AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                                                                           AND d.deduction_flag = 'N';
                                                                                                                                                                                                                      ELSIF v_amount - c_write_off_temp.write_off_due_amount > 0 THEN
                                                                                                                                                                                                                        UPDATE csh_payment_req_ln_ddct d
                                                                                                                                                                                                                           SET d.amount           = d.amount - c_write_off_temp.write_off_due_amount,
                                                                                                                                                                                                                               d.last_update_date = SYSDATE,
                                                                                                                                                                                                                               d.last_updated_by  = p_user_id
                                                                                                                                                                                                                         WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                                                                           AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                                                                           AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                                                                           AND d.deduction_flag = 'N';
                                                                                                                                                                                                                      END IF;
                                                                                                                                                                                                                    EXCEPTION
                                                                                                                                                                                                                      WHEN no_data_found THEN
                                                                                                                                                                                                                        NULL;
                                                                                                                                                                                                                    END;
                                                                                                                                                                                                                  
                                                                                                                                                                                                                  END IF;*/
    
    End Loop;
    --modify by 20160902 Spencer 3893 保证金抵扣租金调用次逻辑
    /*IF nvl(csh_transaction_rec.transaction_amount,
           0) = 0
       AND csh_transaction_rec.transaction_type = 'RECEIPT' THEN
      csh_deposit_write_off_pkg.insert_deposit_write_off(p_csh_trx_rec => csh_transaction_rec,
                                                         p_user_id     => p_user_id);
    END IF;*/
    --现金事物拆分
  
    --现金事务核销时，现金事务及核销行 合并生成的凭证
    /*  csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
    p_user_id        => p_user_id);*/
    -- 删除待处理数据
    Delete From csh_write_off_temp ot Where ot.session_id = p_session_id;
    /*delete_csh_write_off_temp(p_session_id => p_session_id,
    p_user_id    => p_user_id);*/
    csh_transaction_je_pkg.create_advance_write_off_je(p_transaction_id => p_transaction_id,
                                                       p_user_id        => p_user_id);
    --合核销凭证立即传输 (取消)
    /*hl_sbo_inf_pkg.create_sbo_immediately_xml(p_je_transaction_code => 'HL_CSH_CONSOLIDATION',
    p_user_id             => p_user_id);*/
  Exception
    When e_main_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'main_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'main_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --保证金核销以及风险金核销插入对应的现金事务
  Procedure insert_special_write_off(p_csh_trx_rec csh_transaction%Rowtype,
                                     p_user_id     Number) As
    v_write_off_id Number;
    v_pay_amount   Number;
    -- v_con_cashflow_rec con_contract_cashflow%ROWTYPE;
  Begin
  
    --获取金额
    Select nvl(Sum(wo.csh_write_off_amount), 0)
      Into v_pay_amount
      From csh_write_off wo
     Where wo.csh_transaction_id = p_csh_trx_rec.transaction_id;
  
    /* SELECT *
     INTO v_con_cashflow_rec
     FROM con_contract_cashflow cf
    WHERE cf.contract_id = p_csh_trx_rec.source_doc_id
      AND cf.cashflow_id = p_csh_trx_rec.source_doc_line_id;*/
  
    csh_write_off_pkg.insert_csh_write_off(p_write_off_id                => v_write_off_id,
                                           p_write_off_type              => csh_write_off_pkg.write_off_type_payment_debt,
                                           p_write_off_date              => p_csh_trx_rec.transaction_date,
                                           p_internal_period_num         => p_csh_trx_rec.internal_period_num,
                                           p_period_name                 => p_csh_trx_rec.period_name,
                                           p_csh_transaction_id          => p_csh_trx_rec.transaction_id,
                                           p_csh_write_off_amount        => v_pay_amount,
                                           p_subsequent_csh_trx_id       => '',
                                           p_subseq_csh_write_off_amount => '',
                                           p_reversed_flag               => 'N',
                                           p_reversed_write_off_id       => '',
                                           p_reversed_date               => '',
                                           p_cashflow_id                 => '',
                                           p_contract_id                 => '',
                                           p_times                       => '',
                                           p_cf_item                     => '',
                                           p_cf_type                     => '',
                                           p_penalty_calc_date           => '',
                                           p_write_off_due_amount        => v_pay_amount,
                                           p_write_off_principal         => '',
                                           p_write_off_interest          => '',
                                           p_opposite_doc_category       => '',
                                           p_opposite_doc_type           => '',
                                           p_opposite_doc_id             => '',
                                           p_opposite_doc_line_id        => '',
                                           p_opposite_doc_detail_id      => '',
                                           p_opposite_write_off_amount   => '',
                                           p_create_je_mothed            => '',
                                           p_create_je_flag              => 'N',
                                           p_gld_interface_flag          => 'N',
                                           p_description                 => '',
                                           p_user_id                     => p_user_id);
    csh_write_off_pkg.execute_write_off(p_write_off_id => v_write_off_id,
                                        p_user_id      => p_user_id);
  
  End;
  --核销主入口
  Procedure main_write_off_new(p_transaction_id      Number,
                               p_cross_currency_flag Varchar2 Default 'N',
                               p_receipt_flag        Varchar2 Default Null,
                               p_user_id             Number) Is
    csh_transaction_rec        csh_transaction%Rowtype;
    v_functional_currency_code gld_set_of_books.functional_currency_code%Type;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%Type;
    v_write_off_id             Number;
    v_amount                   Number;
    e_main_error Exception;
    r_csh_transaction_rec  csh_transaction%Rowtype;
    v_write_off_date       Date;
    v_created_by           Number;
    v_count                Number;
    v_hl_sp_id             Number;
    v_write_off_amount     Number;
    r_hl_transaction_split hl_transaction_split%Rowtype;
    v_fin_create_je_flag   Number;
    v_total_amount         Number;
  Begin
    hand_debug_pkg.log('main_write_off_new->p_transaction_id:' ||
                       p_transaction_id);
    --风险金核销债权后 add by zyx 2017-04-21
    For rec In (Select cot.write_off_due_amount
                  From csh_write_off_temp cot, con_contract_cashflow ccc
                 Where cot.document_id = ccc.contract_id
                   And cot.document_line_id = ccc.cashflow_id
                   And ccc.cf_item = 56
                   And cot.transaction_id = p_transaction_id) Loop
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
                   And cot.transaction_id = p_transaction_id) Loop
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
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => csh_transaction_rec);
  
    If csh_transaction_rec.transaction_category <>
       csh_transaction_pkg.csh_trx_category_business Then
      v_err_code := 'CSH_WRITE_OFF_PKG.TRX_CATEGORY_ERROR';
      Raise e_main_error;
    End If;
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => csh_transaction_rec.company_id);
    If v_functional_currency_code Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_FUNCTIONAL_CURRENCY_ERROR';
      Raise e_main_error;
    End If;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => csh_transaction_rec.company_id);
    If v_set_of_books_id Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_SET_OF_BOOKS_ERROR';
      Raise e_main_error;
    End If;
    For c_write_off_temp In (Select *
                               From csh_write_off_temp t
                              Where t.transaction_id = p_transaction_id) Loop
      v_write_off_id := insert_csh_write_off(p_csh_write_off_temp_rec => c_write_off_temp,
                                             p_csh_transaction_rec    => csh_transaction_rec,
                                             p_set_of_books_id        => v_set_of_books_id,
                                             p_cross_currency_flag    => p_cross_currency_flag,
                                             p_user_id                => p_user_id);
      Begin
        Select zi.submitted_by
          Into v_created_by
          From zj_wfl_workflow_instance zi
         Where zi.instance_id = c_write_off_temp.wfl_instance_id;
      Exception
        When no_data_found Then
          v_created_by := p_user_id;
      End;
    
      Update csh_write_off co
         Set co.created_by = v_created_by
       Where co.write_off_id = v_write_off_id;
    
      Update csh_write_off_temp t
         Set t.write_off_id = v_write_off_id
       Where t.temp_id = c_write_off_temp.temp_id;
      execute_write_off(p_write_off_id        => v_write_off_id,
                        p_cross_currency_flag => p_cross_currency_flag,
                        p_user_id             => p_user_id);
      v_write_off_date := c_write_off_temp.write_off_date;
    
      --收款核销，处理对应的已生成的坐扣数据
      If p_receipt_flag = 'Y' Then
        Begin
          Select d.amount
            Into v_amount
            From csh_payment_req_ln_ddct d
           Where d.ref_doc_category = 'CONTRACT'
             And d.ref_doc_id = c_write_off_temp.document_id
             And d.ref_doc_line_id = c_write_off_temp.document_line_id
             And d.deduction_flag = 'N';
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'v_amount:' ||
                                                                                       v_amount ||
                                                                                       ',write_off_due_amount:' ||
                                                                                       c_write_off_temp.write_off_due_amount,
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_write_off_pkg',
                                                          p_procedure_function_name => 'test_main_write_off');
          If v_amount - c_write_off_temp.write_off_due_amount <= 0 Then
            Delete From csh_payment_req_ln_ddct d
             Where d.ref_doc_category = 'CONTRACT'
               And d.ref_doc_id = c_write_off_temp.document_id
               And d.ref_doc_line_id = c_write_off_temp.document_line_id
               And d.deduction_flag = 'N';
          Elsif v_amount - c_write_off_temp.write_off_due_amount > 0 Then
            Update csh_payment_req_ln_ddct d
               Set d.amount           = d.amount -
                                        c_write_off_temp.write_off_due_amount,
                   d.last_update_date = Sysdate,
                   d.last_updated_by  = p_user_id
             Where d.ref_doc_category = 'CONTRACT'
               And d.ref_doc_id = c_write_off_temp.document_id
               And d.ref_doc_line_id = c_write_off_temp.document_line_id
               And d.deduction_flag = 'N';
          End If;
        Exception
          When no_data_found Then
            Null;
        End;
      
      End If;
    
    End Loop;
    --modify by 20160902 Spencer 3893 保证金抵扣租金调用次逻辑
    /*if nvl(csh_transaction_rec.transaction_amount, 0) = 0 and csh_transaction_rec.transaction_type = 'RECEIPT' then
      csh_deposit_write_off_pkg.insert_deposit_write_off(p_csh_trx_rec => csh_transaction_rec,
                                                         p_user_id     => p_user_id);
    end if;*/
  
    /*add by xuls 2016-12-1 如果是保证金或者风险金进行抵扣保证金*/
    If csh_transaction_rec.transaction_type = 'DEPOSIT' Or
       csh_transaction_rec.transaction_type = 'RISK' Then
      --如果是保证金或者风险金。要进行特别处理
      --1、 插入0现金流事务 
      r_csh_transaction_rec                    := csh_transaction_rec;
      r_csh_transaction_rec.transaction_amount := 0;
      If csh_transaction_rec.transaction_type = 'DEPOSIT' Then
        r_csh_transaction_rec.transaction_type := 'DEDUCTION_DEPOSIT';
      Elsif csh_transaction_rec.transaction_type = 'RISK' Then
        r_csh_transaction_rec.transaction_type := 'DEDUCTION_RISK';
      End If;
      r_csh_transaction_rec.transaction_id      := csh_transaction_s.nextval;
      r_csh_transaction_rec.transaction_num     := csh_transaction_pkg.get_csh_transaction_num(p_transaction_type => 'DEDUCTION',
                                                                                               p_transaction_date => v_write_off_date,
                                                                                               p_company_id       => csh_transaction_rec.company_id,
                                                                                               p_user_id          => p_user_id);
      r_csh_transaction_rec.transaction_date    := v_write_off_date;
      r_csh_transaction_rec.write_off_flag      := 'FULL';
      r_csh_transaction_rec.penalty_calc_date   := v_write_off_date;
      r_csh_transaction_rec.write_off_amount    := 0;
      r_csh_transaction_rec.cashflow_amount     := 0;
      r_csh_transaction_rec.creation_date       := Sysdate;
      r_csh_transaction_rec.created_by          := p_user_id;
      r_csh_transaction_rec.last_update_date    := Sysdate;
      r_csh_transaction_rec.full_write_off_date := v_write_off_date;
      r_csh_transaction_rec.create_je_flag      := 'N';
      r_csh_transaction_rec.last_updated_by     := p_user_id;
      r_csh_transaction_rec.internal_period_num := to_char(v_write_off_date,
                                                           'YYYYMM');
      r_csh_transaction_rec.period_name         := to_char(v_write_off_date,
                                                           'YYYY-MM');
      r_csh_transaction_rec.source_csh_trx_type := csh_transaction_rec.transaction_type;
      r_csh_transaction_rec.source_csh_trx_id   := csh_transaction_rec.transaction_id;
    
      Insert Into csh_transaction Values r_csh_transaction_rec;
    
      --更新之前的核销事务的现金事务ID
      Update csh_write_off cwo
         Set cwo.csh_transaction_id = r_csh_transaction_rec.transaction_id
       Where cwo.csh_transaction_id = csh_transaction_rec.transaction_id
         And cwo.write_off_id In
             (Select ct.write_off_id
                From csh_write_off_temp ct
               Where ct.transaction_id = p_transaction_id);
    
      --2、 插入对应的保证金风险金核销事务 
      insert_special_write_off(r_csh_transaction_rec, p_user_id);
      --3、 插入对应的应收款项现金流 
      For c_cwos In (Select *
                       From csh_write_off cwo
                      Where cwo.csh_transaction_id =
                            r_csh_transaction_rec.transaction_id
                        And cwo.write_off_type != 'PAYMENT_DEBT'
                        And cwo.cashflow_id Is Not Null) Loop
        special_write_off(c_cwos,
                          p_user_id,
                          csh_transaction_rec.transaction_type);
      End Loop;
    End If;
  
    --现金事务核销时，现金事务及核销行 合并生成的凭证
    /*add by xuls 2016-12-1 如果是保证金或者风险金进行抵扣保证金*/
    /*   if csh_transaction_rec.transaction_type = 'DEPOSIT' or
       csh_transaction_rec.transaction_type = 'RISK' then
      csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => r_csh_transaction_rec.transaction_id,
                                                     p_user_id        => p_user_id);
    else*/
    /*csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
    p_user_id        => p_user_id);*/
  
    If csh_transaction_rec.Lease_Channel = '01' Then
      v_fin_create_je_flag := gld_je_template_pkg.create_je(p_je_transaction_code => 'HL_CSH_CONSOLIDATION_DF',
                                                            p_company_id          => 1, --r_acr_invoice_hd_rec.spv_company_id,
                                                            p_je_company_id       => 1,
                                                            p_user_id             => p_user_id,
                                                            /*凭证头id*/
                                                            p_journal_header_id => Null,
                                                            /*以下为业务参数*/
                                                            p_hd_source_table         => 'CSH_TRANSACTION',
                                                            p_hd_source_id            => p_transaction_id,
                                                            p_ln_source_table         => 'CSH_TRANSACTION',
                                                            p_ln_source_id            => p_transaction_id,
                                                            p_journal_date            => Sysdate,
                                                            p_transaction_date        => Sysdate,
                                                            p_currency_code           => 'CNY',
                                                            p_exchange_rate_quotation => 'DIRECT QUOTATION',
                                                            p_hd_exchange_rate_type   => 'MANUAL',
                                                            p_hd_exchange_rate        => '1',
                                                            p_ln_exchange_rate_type   => 'MANUAL',
                                                            p_ln_exchange_rate        => '1');
      If v_fin_create_je_flag = 0 Then
        Update csh_transaction
           Set create_je_flag   = 'Y',
               last_update_date = Sysdate,
               last_updated_by  = p_user_id
         Where transaction_id = p_transaction_id;
        Update csh_write_off t
           Set t.create_je_flag   = 'Y',
               t.last_update_date = Sysdate,
               t.last_updated_by  = p_user_id
         Where t.csh_transaction_id = p_transaction_id
           And t.reversed_flag = 'N'
           And t.create_je_flag = 'N';
      End If;
    
    Else
      --现金事物拆分
      Select ceil(Count(1) /
                  sys_parameter_pkg.value('HL_SBO_JE_SINGLE_LIMIT'))
        Into v_count
        From csh_write_off t
       Where t.csh_transaction_id = p_transaction_id
         And nvl(t.reversed_flag, 'N') = 'N';
      For i In 1 .. v_count Loop
        Select hl_transaction_split_s.nextval Into v_hl_sp_id From dual;
        For rec_transaction In (Select *
                                  From csh_write_off cwo
                                 Where cwo.csh_transaction_id =
                                       p_transaction_id
                                   And nvl(cwo.reversed_flag, 'N') = 'N'
                                   And cwo.batch_id Is Null
                                   And rownum <=
                                       sys_parameter_pkg.value('HL_SBO_JE_SINGLE_LIMIT')
                                 Order By 1 Desc) Loop
          --核销记录更新为同一批次
          Update csh_write_off c
             Set c.batch_id         = v_hl_sp_id,
                 c.last_update_date = Sysdate,
                 c.last_updated_by  = p_user_id
           Where c.write_off_id = rec_transaction.write_off_id;
          --计算该批次的核销金额合计
        /*  v_write_off_amount := nvl(rec_transaction.csh_write_off_amount, 0);
                                                                                                                                                                                                                                                                                                                                                                                                                                    v_total_amount:=+v_write_off_amount;*/
        End Loop;
        Select Sum(cwo.csh_write_off_amount)
          Into v_write_off_amount
          From csh_write_off cwo
         Where cwo.csh_transaction_id = p_transaction_id
           And cwo.batch_id = v_hl_sp_id
           And rownum <= sys_parameter_pkg.value('HL_SBO_JE_SINGLE_LIMIT');
        --中间表插入数据
        r_hl_transaction_split.hl_sp_id           := v_hl_sp_id;
        r_hl_transaction_split.transaction_amount := v_write_off_amount;
        r_hl_transaction_split.transaction_id     := p_transaction_id;
        r_hl_transaction_split.created_by         := p_user_id;
        r_hl_transaction_split.created_date       := Sysdate;
        r_hl_transaction_split.last_update_by     := p_user_id;
        r_hl_transaction_split.last_update_date   := Sysdate;
        Insert Into hl_transaction_split Values r_hl_transaction_split;
      End Loop;
      For transaction_je_create_rec In (Select *
                                          From hl_transaction_split t
                                         Where t.transaction_id =
                                               p_transaction_id
                                           And nvl(t.je_flag, 'N') = 'N') Loop
        v_fin_create_je_flag := gld_je_template_pkg.create_je(p_je_transaction_code => 'HL_CSH_CONSOLIDATION',
                                                              p_company_id          => 1, --r_acr_invoice_hd_rec.spv_company_id,
                                                              p_je_company_id       => 1,
                                                              p_user_id             => p_user_id,
                                                              /*凭证头id*/
                                                              p_journal_header_id => Null,
                                                              /*以下为业务参数*/
                                                              p_hd_source_table         => 'HL_TRANSACTION_SPLIT',
                                                              p_hd_source_id            => transaction_je_create_rec.hl_sp_id,
                                                              p_ln_source_table         => 'HL_TRANSACTION_SPLIT',
                                                              p_ln_source_id            => transaction_je_create_rec.hl_sp_id,
                                                              p_journal_date            => Sysdate,
                                                              p_transaction_date        => Sysdate,
                                                              p_currency_code           => 'CNY',
                                                              p_exchange_rate_quotation => 'DIRECT QUOTATION',
                                                              p_hd_exchange_rate_type   => 'MANUAL',
                                                              p_hd_exchange_rate        => '1',
                                                              p_ln_exchange_rate_type   => 'MANUAL',
                                                              p_ln_exchange_rate        => '1');
        If v_fin_create_je_flag = 0 Then
          Update csh_transaction
             Set create_je_flag   = 'Y',
                 last_update_date = Sysdate,
                 last_updated_by  = p_user_id
           Where transaction_id = p_transaction_id;
          Update hl_transaction_split
             Set je_flag          = 'Y',
                 last_update_date = Sysdate,
                 last_update_by   = p_user_id
           Where transaction_id = p_transaction_id;
          Update csh_write_off t
             Set t.create_je_flag   = 'Y',
                 t.last_update_date = Sysdate,
                 t.last_updated_by  = p_user_id
           Where t.csh_transaction_id = p_transaction_id
             And t.reversed_flag = 'N'
             And t.create_je_flag = 'N';
        End If;
      End Loop;
    End If; -- END WUTS
  
    --  end if;
  
    -- 删除待处理数据
    /*delete_csh_write_off_temp(p_session_id => p_session_id,
    p_user_id    => p_user_id);*/
    Delete From csh_write_off_temp ot
     Where ot.transaction_id = p_transaction_id;
    csh_transaction_je_pkg.create_advance_write_off_je(p_transaction_id => p_transaction_id,
                                                       p_user_id        => p_user_id);
    --合核销凭证立即传输
    /*hl_sbo_inf_pkg.create_sbo_immediately_xml(p_je_transaction_code => 'HL_CSH_CONSOLIDATION',
    p_user_id             => p_user_id);*/
  
    /*v_fin_create_je_flag := gld_je_template_pkg.create_je(p_je_transaction_code => 'HL_CSH_CONSOLIDATION',
    p_company_id          => 1, --r_acr_invoice_hd_rec.spv_company_id,
    p_je_company_id       => 1,
    p_user_id             => p_user_id,
    \*凭证头id*\
    p_journal_header_id => NULL,
    \*以下为业务参数*\
    p_hd_source_table         => 'CSH_TRANSACTION',
    p_hd_source_id            => p_transaction_id,
    p_ln_source_table         => 'CSH_TRANSACTION',
    p_ln_source_id            => transaction_je_create_rec.hl_sp_id,
    p_journal_date            => SYSDATE,
    p_transaction_date        => SYSDATE,
    p_currency_code           => 'CNY',
    p_exchange_rate_quotation => 'DIRECT QUOTATION',
    p_hd_exchange_rate_type   => 'MANUAL',
    p_hd_exchange_rate        => '1',
    p_ln_exchange_rate_type   => 'MANUAL',
    p_ln_exchange_rate        => '1');*/
  Exception
    When e_main_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'main_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'main_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure deduction_write_off(p_session_id          Number,
                                p_company_id          Number,
                                p_bp_id               Number,
                                p_transaction_date    Date,
                                p_description         Varchar2,
                                p_source_csh_trx_type Varchar2 Default Null,
                                p_source_csh_trx_id   Number Default Null,
                                p_source_doc_category Varchar2 Default Null,
                                p_source_doc_type     Varchar2 Default Null,
                                p_source_doc_id       Number Default Null,
                                p_source_doc_line_id  Number Default Null,
                                p_user_id             Number,
                                p_transaction_id      Out Number) Is
    v_transaction_id Number;
  
    v_currency            con_contract.currency%Type;
    v_period_name         gld_periods.period_name%Type;
    v_period_year         gld_periods.period_year%Type;
    v_period_num          gld_periods.period_num%Type;
    v_internal_period_num gld_periods.internal_period_num%Type;
  
    v_amt_in  Number;
    v_amt_out Number;
  
    e_period_not_found Exception;
    e_diff_currency    Exception;
    e_inout_amt_err    Exception;
  Begin
  
    gld_common_pkg.get_gld_period_name(p_company_id          => p_company_id,
                                       p_je_company_id       => p_company_id,
                                       p_date                => p_transaction_date,
                                       p_period_name         => v_period_name,
                                       p_period_year         => v_period_year,
                                       p_period_num          => v_period_num,
                                       p_internal_period_num => v_internal_period_num);
  
    If v_period_name Is Null Or v_internal_period_num Is Null Then
      Raise e_period_not_found;
    End If;
  
    Begin
      Select c.currency
        Into v_currency
        From csh_write_off_temp t, con_contract c
       Where t.session_id = p_session_id
         And t.document_id = c.contract_id
       Group By c.currency;
    Exception
      When no_data_found Then
        Return;
      When too_many_rows Then
        Raise e_diff_currency;
    End;
  
    --检查收付抵扣金额是否相等
    Select Sum(t.write_off_due_amount)
      Into v_amt_in
      From csh_write_off_temp t
     Where t.session_id = p_session_id
       And t.write_off_type In
           (write_off_type_receipt_credit, write_off_type_pre_credit);
  
    Select Sum(t.write_off_due_amount)
      Into v_amt_out
      From csh_write_off_temp t
     Where t.session_id = p_session_id
       And t.transaction_id Is Null
       And t.wfl_instance_id Is Null
       And t.write_off_type In
           (write_off_type_payment_debt, write_off_type_pre_debt);
  
    If nvl(v_amt_in, 0) <> nvl(v_amt_out, 0) Then
      Raise e_inout_amt_err;
    End If;
  
    csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
                                               p_transaction_num         => Null,
                                               p_transaction_category    => csh_transaction_pkg.csh_trx_category_business,
                                               p_transaction_type        => csh_transaction_pkg.csh_trx_type_deduction,
                                               p_transaction_date        => p_transaction_date,
                                               p_penalty_calc_date       => p_transaction_date,
                                               p_bank_slip_num           => Null,
                                               p_company_id              => p_company_id,
                                               p_internal_period_num     => v_internal_period_num,
                                               p_period_name             => v_period_name,
                                               p_payment_method_id       => Null,
                                               p_distribution_set_id     => Null,
                                               p_cashflow_amount         => 0,
                                               p_currency_code           => v_currency,
                                               p_transaction_amount      => 0,
                                               p_exchange_rate_type      => Null,
                                               p_exchange_rate_quotation => Null,
                                               p_exchange_rate           => 1,
                                               p_bank_account_id         => Null,
                                               p_bp_category             => Null,
                                               p_bp_id                   => p_bp_id,
                                               p_bp_bank_account_id      => Null,
                                               p_bp_bank_account_num     => Null,
                                               p_description             => p_description,
                                               p_handling_charge         => Null,
                                               p_posted_flag             => 'N',
                                               p_reversed_flag           => 'N',
                                               p_reversed_date           => Null,
                                               p_returned_flag           => 'NOT',
                                               p_returned_amount         => Null,
                                               p_write_off_flag          => 'FULL',
                                               p_write_off_amount        => 0,
                                               p_full_write_off_date     => p_transaction_date,
                                               p_twin_csh_trx_id         => Null,
                                               p_return_from_csh_trx_id  => Null,
                                               p_reversed_csh_trx_id     => Null,
                                               p_source_csh_trx_type     => p_source_csh_trx_type,
                                               p_source_csh_trx_id       => p_source_csh_trx_id,
                                               p_source_doc_category     => p_source_doc_category,
                                               p_source_doc_type         => p_source_doc_type,
                                               p_source_doc_id           => p_source_doc_id,
                                               p_source_doc_line_id      => p_source_doc_line_id,
                                               p_create_je_mothed        => Null,
                                               p_create_je_flag          => 'N',
                                               p_gld_interface_flag      => 'N',
                                               p_user_id                 => p_user_id);
  
    p_transaction_id := v_transaction_id;
    csh_transaction_pkg.post_csh_transaction(p_transaction_id => v_transaction_id,
                                             p_user_id        => p_user_id);
  
    main_write_off(p_session_id          => p_session_id,
                   p_transaction_id      => v_transaction_id,
                   p_cross_currency_flag => 'N',
                   p_user_id             => p_user_id);
  
  Exception
    When e_period_not_found Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.GLD_PERIOD_NOTFOUND',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_diff_currency Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_DIFF_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_inout_amt_err Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_INOUT_AMT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'deduction_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure main_write_off_wfl(p_instance_id         Number,
                               p_transaction_id      Number,
                               p_cross_currency_flag Varchar2 Default 'N',
                               p_receipt_flag        Varchar2 Default Null,
                               p_user_id             Number) Is
    csh_transaction_rec        csh_transaction%Rowtype;
    v_functional_currency_code gld_set_of_books.functional_currency_code%Type;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%Type;
    v_write_off_id             Number;
    v_amount                   Number;
    v_created_by               Number;
    e_main_error Exception;
  Begin
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => csh_transaction_rec);
  
    If csh_transaction_rec.transaction_category <>
       csh_transaction_pkg.csh_trx_category_business Then
      v_err_code := 'CSH_WRITE_OFF_PKG.TRX_CATEGORY_ERROR';
      Raise e_main_error;
    End If;
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => csh_transaction_rec.company_id);
    If v_functional_currency_code Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_FUNCTIONAL_CURRENCY_ERROR';
      Raise e_main_error;
    End If;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => csh_transaction_rec.company_id);
    If v_set_of_books_id Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_SET_OF_BOOKS_ERROR';
      Raise e_main_error;
    End If;
    For c_write_off_temp In (Select *
                               From csh_write_off_temp t
                              Where t.wfl_instance_id = p_instance_id) Loop
      v_write_off_id := insert_csh_write_off(p_csh_write_off_temp_rec => c_write_off_temp,
                                             p_csh_transaction_rec    => csh_transaction_rec,
                                             p_set_of_books_id        => v_set_of_books_id,
                                             p_cross_currency_flag    => p_cross_currency_flag,
                                             p_user_id                => p_user_id);
    
      Begin
        Select zi.submitted_by
          Into v_created_by
          From zj_wfl_workflow_instance zi
         Where zi.instance_id = c_write_off_temp.wfl_instance_id;
      Exception
        When no_data_found Then
          v_created_by := p_user_id;
      End;
    
      Update csh_write_off co
         Set co.created_by = v_created_by
       Where co.write_off_id = v_write_off_id;
    
      execute_write_off(p_write_off_id        => v_write_off_id,
                        p_cross_currency_flag => p_cross_currency_flag,
                        p_user_id             => p_user_id);
      --保证金核销租金,新增一条保证金outflow的核销记录
    
      --收款核销，处理对应的已生成的坐扣数据
      If p_receipt_flag = 'Y' Then
        Begin
          Select d.amount
            Into v_amount
            From csh_payment_req_ln_ddct d
           Where d.ref_doc_category = 'CONTRACT'
             And d.ref_doc_id = c_write_off_temp.document_id
             And d.ref_doc_line_id = c_write_off_temp.document_line_id
             And d.deduction_flag = 'N';
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'v_amount:' ||
                                                                                       v_amount ||
                                                                                       ',write_off_due_amount:' ||
                                                                                       c_write_off_temp.write_off_due_amount,
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_write_off_pkg',
                                                          p_procedure_function_name => 'test_main_write_off');
          If v_amount - c_write_off_temp.write_off_due_amount <= 0 Then
            Delete From csh_payment_req_ln_ddct d
             Where d.ref_doc_category = 'CONTRACT'
               And d.ref_doc_id = c_write_off_temp.document_id
               And d.ref_doc_line_id = c_write_off_temp.document_line_id
               And d.deduction_flag = 'N';
          Elsif v_amount - c_write_off_temp.write_off_due_amount > 0 Then
            Update csh_payment_req_ln_ddct d
               Set d.amount           = d.amount -
                                        c_write_off_temp.write_off_due_amount,
                   d.last_update_date = Sysdate,
                   d.last_updated_by  = p_user_id
             Where d.ref_doc_category = 'CONTRACT'
               And d.ref_doc_id = c_write_off_temp.document_id
               And d.ref_doc_line_id = c_write_off_temp.document_line_id
               And d.deduction_flag = 'N';
          End If;
        Exception
          When no_data_found Then
            Null;
        End;
      
      End If;
    
    End Loop;
  
    --现金事务核销时，现金事务及核销行 合并生成的凭证
    csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
                                                   p_user_id        => p_user_id);
    -- 删除待处理数据
    Delete From csh_write_off_temp c
     Where c.wfl_instance_id = p_instance_id;
  
  Exception
    When e_main_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'main_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'main_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End main_write_off_wfl;

  Procedure deduction_write_off_wfl(p_instance_id      Number,
                                    p_company_id       Number,
                                    p_bp_id            Number,
                                    p_transaction_date Date,
                                    p_description      Varchar2,
                                    p_user_id          Number,
                                    p_transaction_id   Out Number) Is
    v_transaction_id Number;
  
    v_currency            con_contract.currency%Type;
    v_period_name         gld_periods.period_name%Type;
    v_period_year         gld_periods.period_year%Type;
    v_period_num          gld_periods.period_num%Type;
    v_internal_period_num gld_periods.internal_period_num%Type;
  
    v_amt_in  Number;
    v_amt_out Number;
  
    e_period_not_found Exception;
    e_diff_currency    Exception;
    e_inout_amt_err    Exception;
  Begin
  
    gld_common_pkg.get_gld_period_name(p_company_id          => p_company_id,
                                       p_je_company_id       => p_company_id,
                                       p_date                => p_transaction_date,
                                       p_period_name         => v_period_name,
                                       p_period_year         => v_period_year,
                                       p_period_num          => v_period_num,
                                       p_internal_period_num => v_internal_period_num);
  
    If v_period_name Is Null Or v_internal_period_num Is Null Then
      Raise e_period_not_found;
    End If;
  
    Begin
      Select c.currency
        Into v_currency
        From csh_write_off_temp t, con_contract c
       Where t.wfl_instance_id = p_instance_id
         And t.document_id = c.contract_id
       Group By c.currency;
    Exception
      When no_data_found Then
        Return;
      When too_many_rows Then
        Raise e_diff_currency;
    End;
  
    --检查收付抵扣金额是否相等
    Select Sum(t.write_off_due_amount)
      Into v_amt_in
      From csh_write_off_temp t
     Where t.wfl_instance_id = p_instance_id
       And t.write_off_type In
           (write_off_type_receipt_credit, write_off_type_pre_credit);
  
    Select Sum(t.write_off_due_amount)
      Into v_amt_out
      From csh_write_off_temp t
     Where t.wfl_instance_id = p_instance_id
       And t.write_off_type In
           (write_off_type_payment_debt, write_off_type_pre_debt);
  
    If nvl(v_amt_in, 0) <> nvl(v_amt_out, 0) Then
      Raise e_inout_amt_err;
    End If;
  
    csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
                                               p_transaction_num         => Null,
                                               p_transaction_category    => csh_transaction_pkg.csh_trx_category_business,
                                               p_transaction_type        => csh_transaction_pkg.csh_trx_type_deduction,
                                               p_transaction_date        => p_transaction_date,
                                               p_penalty_calc_date       => p_transaction_date,
                                               p_bank_slip_num           => Null,
                                               p_company_id              => p_company_id,
                                               p_internal_period_num     => v_internal_period_num,
                                               p_period_name             => v_period_name,
                                               p_payment_method_id       => Null,
                                               p_distribution_set_id     => Null,
                                               p_cashflow_amount         => 0,
                                               p_currency_code           => v_currency,
                                               p_transaction_amount      => 0,
                                               p_exchange_rate_type      => Null,
                                               p_exchange_rate_quotation => Null,
                                               p_exchange_rate           => 1,
                                               p_bank_account_id         => Null,
                                               p_bp_category             => Null,
                                               p_bp_id                   => p_bp_id,
                                               p_bp_bank_account_id      => Null,
                                               p_bp_bank_account_num     => Null,
                                               p_description             => p_description,
                                               p_handling_charge         => Null,
                                               p_posted_flag             => 'N',
                                               p_reversed_flag           => 'N',
                                               p_reversed_date           => Null,
                                               p_returned_flag           => 'NOT',
                                               p_returned_amount         => Null,
                                               p_write_off_flag          => 'FULL',
                                               p_write_off_amount        => 0,
                                               p_full_write_off_date     => p_transaction_date,
                                               p_twin_csh_trx_id         => Null,
                                               p_return_from_csh_trx_id  => Null,
                                               p_reversed_csh_trx_id     => Null,
                                               p_source_csh_trx_type     => Null,
                                               p_source_csh_trx_id       => Null,
                                               p_source_doc_category     => Null,
                                               p_source_doc_type         => Null,
                                               p_source_doc_id           => Null,
                                               p_source_doc_line_id      => Null,
                                               p_create_je_mothed        => Null,
                                               p_create_je_flag          => 'N',
                                               p_gld_interface_flag      => 'N',
                                               p_user_id                 => p_user_id);
  
    p_transaction_id := v_transaction_id;
    csh_transaction_pkg.post_csh_transaction(p_transaction_id => v_transaction_id,
                                             p_user_id        => p_user_id);
  
    main_write_off_wfl(p_instance_id         => p_instance_id,
                       p_transaction_id      => v_transaction_id,
                       p_cross_currency_flag => 'N',
                       p_user_id             => p_user_id);
  
  Exception
    When e_period_not_found Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.GLD_PERIOD_NOTFOUND',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_diff_currency Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_DIFF_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_inout_amt_err Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_INOUT_AMT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'deduction_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'deduction_write_off_wfl');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End deduction_write_off_wfl;

  Procedure save_pay_check(p_write_off_id Number,
                           p_pay_check    Varchar2,
                           p_user_id      Number) Is
  Begin
    Update csh_write_off co
       Set co.pay_check        = p_pay_check,
           co.last_updated_by  = p_user_id,
           co.last_update_date = Sysdate
     Where co.write_off_id = p_write_off_id;
  End save_pay_check;

  --匹配本次收款核销项目
  --首付款 > 付款申请编号
  --保理本金 > 赎证申请编号
  --管理费 > 库融申请编号
  Function match_write_off_cf_item(p_description Varchar2) Return Varchar2 Is
    v_match_code Varchar2(200);
    v_exist_flag Varchar2(1);
  
    Procedure set_match_code(p_match_code Varchar2) Is
    Begin
      If v_match_code Is Not Null Then
        If v_match_code <> p_match_code Then
          v_match_code := 'ERROR';
        End If;
      Else
        v_match_code := p_match_code;
      End If;
    End;
  Begin
    For c_rec In (Select regexp_substr(p_description, '[^、]+', 1, rownum) As document_number
                    From dual
                  Connect By rownum <=
                             length(p_description) -
                             length(regexp_replace(p_description, '、', '')) + 1) Loop
      --匹配是否是付款申请
      Begin
        Select 'Y'
          Into v_exist_flag
          From dual
         Where Exists
         (Select 1
                  From csh_payment_req_hd h
                 Where h.payment_req_number = c_rec.document_number);
        set_match_code('PAYMENT_REQ');
      Exception
        When no_data_found Then
          v_exist_flag := 'N';
      End;
    
      --匹配是否是库融申请
      Begin
        Select 'Y'
          Into v_exist_flag
          From dual
         Where Exists
         (Select 1
                  From prj_project p
                 Where p.project_number = c_rec.document_number);
        set_match_code('DEALER_REQ');
      Exception
        When no_data_found Then
          v_exist_flag := 'N';
      End;
    
      --匹配是否是赎证申请
      Begin
        Select 'Y'
          Into v_exist_flag
          From dual
         Where Exists
         (
                --select 1 from con_redemption_certificate c where c.batch_code = c_rec.document_number
                Select 1
                  From hls_document_history
                 Where document_category = 'CONTRACT'
                   And DOCUMENT_HISTORY_ID In
                       (Select contract_id
                          From con_Contract
                         Where data_class = 'CHANGE_REQ'
                           And et_batch_id =
                               (Select batch_id
                                  From con_redemption_certificate
                                 Where batch_code = c_rec.document_number)));
        set_match_code('ET_REQ');
      Exception
        When no_data_found Then
          v_exist_flag := 'N';
      End;
    End Loop;
  
    v_match_code := nvl(v_match_code, 'NULL');
  
    Return v_match_code;
  
  End match_write_off_cf_item;

  --核销数据插入
  Procedure insert_write_off_tmp(p_contract_id    Number,
                                 p_cf_item        Number,
                                 p_session_id     Number,
                                 p_user_id        Number,
                                 p_transaction_id Number) Is
    r_csh_transaction csh_transaction%Rowtype;
  Begin
  
    Select *
      Into r_csh_transaction
      From csh_transaction c
     Where c.transaction_id = p_transaction_id;
  
    For c_cf In (Select *
                   From con_contract_cashflow cc
                  Where cc.contract_id = p_contract_id
                    And cc.cf_item = p_cf_item
                    And cc.cf_direction = 'INFLOW'
                    And cc.due_amount > 0
                    And cc.write_off_flag <> 'FULL'
                  Order By cc.times) Loop
      If (c_cf.due_amount - nvl(c_cf.received_amount, 0)) > 0 Then
        insert_csh_write_off_temp(p_session_id           => p_session_id,
                                  p_write_off_type       => 'RECEIPT_CREDIT',
                                  p_transaction_category => r_csh_transaction.transaction_category,
                                  p_transaction_type     => r_csh_transaction.transaction_type,
                                  p_write_off_date       => trunc(Sysdate),
                                  p_write_off_due_amount => c_cf.due_amount -
                                                            nvl(c_cf.received_amount,
                                                                0),
                                  p_write_off_principal  => Null,
                                  p_write_off_interest   => Null,
                                  p_company_id           => r_csh_transaction.company_id,
                                  p_document_category    => 'CONTRACT',
                                  p_document_id          => p_contract_id,
                                  p_document_line_id     => c_cf.cashflow_id,
                                  p_description          => Null,
                                  p_user_id              => p_user_id,
                                  p_transaction_id       => p_transaction_id);
      End If;
    End Loop;
  
  End insert_write_off_tmp;

  --add by 8754 批量核销
  Procedure batch_write_off(p_transaction_id Number,
                            p_session_id     Number,
                            p_user_id        Number) Is
    r_csh_transaction csh_transaction%Rowtype;
  
    v_err_message         Varchar2(2000);
    v_match_code          Varchar2(200);
    v_contract_id         Number;
    v_total_wirte_off_amt Number := 0;
    v_temp_index          Number;
  
    e_batch_write_off_err Exception;
  Begin
    Select *
      Into r_csh_transaction
      From csh_transaction c
     Where c.transaction_id = p_transaction_id;
  
    If r_csh_transaction.description Is Null Then
      v_err_message := '未匹配核销现金流，无法自动核销!';
      Raise e_batch_write_off_err;
    End If;
  
    If r_csh_transaction.transaction_type <> 'RECEIPT' Then
      v_err_message := '非收款类型，无法自动核销!';
      Raise e_batch_write_off_err;
    End If;
    --add by wuts for 2019-01-10
    If r_csh_transaction.lease_channel = '00' Then
      v_err_message := 'CF业务无法批量核销!';
      Raise e_batch_write_off_err;
    End If;
    --end wuts
    --匹配本次收款核销项目
    v_match_code := match_write_off_cf_item(r_csh_transaction.description);
  
    If v_match_code Not In ('PAYMENT_REQ', 'DEALER_REQ', 'ET_REQ') Then
      v_err_message := '匹配申请【付款申请|库融申请|赎证申请】失败,请检查！';
      Raise e_batch_write_off_err;
    End If;
    --首付款 > 付款申请编号
    --保理本金 > 赎证申请编号
    --管理费 > 库融申请编号
  
    Delete From csh_write_off_temp c
     Where c.session_id = p_session_id
        Or c.transaction_id = p_transaction_id;
  
    For c_rec In (Select regexp_substr(Trim(Replace(r_csh_transaction.description,
                                                    chr(10),
                                                    '')),
                                       '[^、]+',
                                       1,
                                       rownum) As document_number
                    From dual
                  Connect By rownum <=
                             length(Trim(Replace(r_csh_transaction.description,
                                                 chr(10),
                                                 ''))) -
                             length(regexp_replace(Trim(Replace(r_csh_transaction.description,
                                                                chr(10),
                                                                '')),
                                                   '、',
                                                   '')) + 1) Loop
      If v_match_code = 'PAYMENT_REQ' Then
        For c_ln In (Select l.ref_doc_id
                       From csh_payment_req_ln l
                      Where Exists
                      (Select 1
                               From csh_payment_req_hd h
                              Where h.payment_req_id = l.payment_req_id
                                And h.payment_req_number =
                                    c_rec.document_number)
                      Group By l.ref_doc_id) Loop
          insert_write_off_tmp(p_contract_id    => c_ln.ref_doc_id,
                               p_cf_item        => 303, --首付款
                               p_session_id     => p_session_id,
                               p_user_id        => p_user_id,
                               p_transaction_id => p_transaction_id);
        End Loop;
      End If;
    
      If v_match_code = 'DEALER_REQ' Then
        For c_ln In (Select c.contract_id
                       From con_contract c
                      Where c.data_class = 'NORMAL'
                        And Exists
                      (Select 1
                               From prj_project p
                              Where p.project_id = c.project_id
                                And p.project_number = c_rec.document_number)) Loop
          insert_write_off_tmp(p_contract_id    => c_ln.contract_id,
                               p_cf_item        => 301, --管理费
                               p_session_id     => p_session_id,
                               p_user_id        => p_user_id,
                               p_transaction_id => p_transaction_id);
        End Loop;
      End If;
    
      If v_match_code = 'ET_REQ' Then
        /*   select h.contract_id
            into v_contract_id
            from con_contract_et_hd h
           where h.et_agreement_number = c_rec.document_number;
        */
      
        For c_ln In (Select DOCUMENT_ID
                       From hls_document_history
                      Where document_category = 'CONTRACT'
                        And DOCUMENT_HISTORY_ID In
                            (Select contract_id
                               From con_Contract
                              Where data_class = 'CHANGE_REQ'
                                And et_batch_id =
                                    (Select batch_id
                                       From con_redemption_certificate
                                      Where batch_code = c_rec.document_number))) Loop
          insert_write_off_tmp(p_contract_id    => c_ln.document_id,
                               p_cf_item        => 302, --赎证款
                               p_session_id     => p_session_id,
                               p_user_id        => p_user_id,
                               p_transaction_id => p_transaction_id);
        End Loop;
      
      End If;
    End Loop;
  
    --校验 现金事物金额 = sum (核销金额)
    Select nvl(Sum(nvl(c.write_off_due_amount, 0)), 0)
      Into v_total_wirte_off_amt
      From csh_write_off_temp c
     Where c.session_id = p_session_id;
  
    If r_csh_transaction.transaction_amount <> v_total_wirte_off_amt Then
      v_err_message := '收款金额与应收金额不一致,请手工核销!';
      Raise e_batch_write_off_err;
    End If;
  
    --现金事物金额与核销金额做比较
    /*for c_write_off in (select * from csh_write_off_temp c 
                               where c.session_id = p_session_id order by c.temp_id)loop
        v_temp_index := c_write_off.temp_id;
        
        v_total_wirte_off_amt := v_total_wirte_off_amt + c_write_off.write_off_due_amount;
        
        if v_total_wirte_off_amt > (r_csh_transaction.transaction_amount - nvl(r_csh_transaction.write_off_amount,0)) then
           update csh_write_off_temp c
              set c.write_off_due_amount = c_write_off.write_off_due_amount - 
                                         (v_total_wirte_off_amt-r_csh_transaction.transaction_amount + nvl(r_csh_transaction.write_off_amount,0))
                                           
            where c.temp_id = v_temp_index;
           exit;
        end if;
    end loop;
    
    delete from csh_write_off_temp c where c.session_id = p_session_id and c.temp_id > v_temp_index;*/
  
  Exception
    When e_batch_write_off_err Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_err_message,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'batch_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'batch_write_off');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  End batch_write_off;

  Function check_contract_exist_flag(p_transaction_id Number,
                                     p_contract_id    Number) Return Varchar2 Is
    v_ret             Varchar2(1);
    v_match_code      Varchar2(200);
    v_contract_id     Number;
    r_csh_transaction csh_transaction%Rowtype;
  Begin
    Select *
      Into r_csh_transaction
      From csh_transaction c
     Where c.transaction_id = p_transaction_id;
  
    --匹配本次收款核销项目
    v_match_code := match_write_off_cf_item(r_csh_transaction.description);
  
    For c_rec In (Select regexp_substr(r_csh_transaction.description,
                                       '[^、]+',
                                       1,
                                       rownum) As document_number
                    From dual
                  Connect By rownum <=
                             length(r_csh_transaction.description) -
                             length(regexp_replace(r_csh_transaction.description,
                                                   '、',
                                                   '')) + 1) Loop
      If v_match_code = 'PAYMENT_REQ' Then
        For c_ln In (Select l.ref_doc_id
                       From csh_payment_req_ln l
                      Where Exists
                      (Select 1
                               From csh_payment_req_hd h
                              Where h.payment_req_id = l.payment_req_id
                                And h.payment_req_number =
                                    c_rec.document_number)
                      Group By l.ref_doc_id) Loop
          If c_ln.ref_doc_id = p_contract_id Then
            Return 'Y';
          End If;
        End Loop;
      End If;
    
      If v_match_code = 'DEALER_REQ' Then
        For c_ln In (Select c.contract_id
                       From con_contract c
                      Where c.data_class = 'NORMAL'
                        And Exists
                      (Select 1
                               From prj_project p
                              Where p.project_id = c.project_id
                                And p.project_number = c_rec.document_number)) Loop
          If c_ln.contract_id = p_contract_id Then
            Return 'Y';
          End If;
        End Loop;
      End If;
    
      If v_match_code = 'ET_REQ' Then
        Select h.contract_id
          Into v_contract_id
          From con_contract_et_hd h
         Where h.et_agreement_number = c_rec.document_number;
      
        If v_contract_id = p_contract_id Then
          Return 'Y';
        End If;
      End If;
    End Loop;
  
    Return 'N';
  
  End check_contract_exist_flag;

  --返回DF标志
  Function get_cf_df(p_transaction_id Number) Return Varchar2 Is
    v_ret             Varchar2(1);
    v_match_code      Varchar2(200);
    v_contract_id     Number;
    r_con_contract    con_contract%Rowtype;
    r_csh_transaction csh_transaction%Rowtype;
  Begin
    Select *
      Into r_csh_transaction
      From csh_transaction c
     Where c.transaction_id = p_transaction_id;
  
    --匹配本次收款核销项目
    v_match_code := match_write_off_cf_item(r_csh_transaction.description);
    
   -- modified by Liyuan 处理无摘要的DF
    --非这三种申请的一律当cf处理
    If v_match_code In ('PAYMENT_REQ', 'DEALER_REQ', 'ET_REQ') Then
    
      For c_rec In (Select regexp_substr(r_csh_transaction.description,
                                         '[^、]+',
                                         1,
                                         rownum) As document_number
                      From dual
                    Connect By rownum <=
                               length(r_csh_transaction.description) -
                               length(regexp_replace(r_csh_transaction.description,
                                                     '、',
                                                     '')) + 1) Loop
        If v_match_code = 'PAYMENT_REQ' Then
          For c_ln In (Select l.ref_doc_id
                         From csh_payment_req_ln l
                        Where Exists
                        (Select 1
                                 From csh_payment_req_hd h
                                Where h.payment_req_id = l.payment_req_id
                                  And h.payment_req_number =
                                      c_rec.document_number)
                        Group By l.ref_doc_id) Loop
            Select *
              Into r_con_contract
              From con_contract c
             Where c.contract_id = c_ln.ref_doc_id;
            If r_con_contract.lease_channel = '01' Then
              Return 'Y';
            End If;
          End Loop;
        End If;
      
        If v_match_code = 'DEALER_REQ' Then
          For c_ln In (Select c.contract_id
                         From con_contract c
                        Where c.data_class = 'NORMAL'
                          And Exists
                        (Select 1
                                 From prj_project p
                                Where p.project_id = c.project_id
                                  And p.project_number =
                                      c_rec.document_number)) Loop
            Select *
              Into r_con_contract
              From con_contract c
             Where c.contract_id = c_ln.contract_id;
            If r_con_contract.lease_channel = '01' Then
              Return 'Y';
            End If;
          End Loop;
        End If;
      
        If v_match_code = 'ET_REQ' Then
          Select h.contract_id
            Into v_contract_id
            From con_contract_et_hd h
           Where h.et_agreement_number = c_rec.document_number;
        
          Select *
            Into r_con_contract
            From con_contract c
           Where c.contract_id = v_contract_id;
          If r_con_contract.lease_channel = '01' Then
            Return 'Y';
          End If;
        End If;
      End Loop;
    Elsif v_match_code Not In ('PAYMENT_REQ', 'DEALER_REQ', 'ET_REQ') And
          r_csh_transaction.lease_channel = '01' Then
      Return 'Y';
    Else
      Return 'N';
    End If;
    -- Return 'N';
   -- end add by Liyuan 
  End get_cf_df;
  -- add by Liyuan df批量核销 
  Procedure batch_write_off_df(p_transaction_id_num Varchar2,
                               p_bp_id              Number,
                               p_fee_type           Varchar2,
                               p_session_id         Number,
                               p_user_id            Number) Is
    r_csh_transaction csh_transaction%Rowtype;
    v_err_message     Varchar2(2000);
    e_batch_write_off_err Exception;
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
      Select *
        Into r_csh_transaction
        From csh_transaction cs
       Where cs.transaction_id = i_transaction_id.transaction_id;
    
      If r_csh_transaction.bp_id Is Null Or
         r_csh_transaction.fee_type Is Null Then
        v_err_message := '未匹配核销现金流，无法自动核销!';
        Raise e_batch_write_off_err;
      End If;
      If r_csh_transaction.transaction_type <> 'RECEIPT' Then
        v_err_message := '非收款类型，无法自动核销!';
        Raise e_batch_write_off_err;
      End If;
    End Loop;
  
    update_for_csh_table(p_transaction_id_num,
                         p_bp_id,
                         p_session_id,
                         p_user_id);
    -- 跟据商业伙伴及费用类型(cf_item)匹配到所有合同ID
    For i_cur In (Select cb.*
                    From con_contract cb
                   Where cb.bp_id_tenant = p_bp_id
                     And cb.data_class = 'NORMAL'
                     And cb.lease_channel = '01') Loop
      insert_write_off_df_tmp(p_contract_id => i_cur.contract_id,
                              p_cf_item     => p_fee_type,
                              p_session_id  => p_session_id,
                              p_user_id     => p_user_id);
    End Loop;
  
    --校验 现金事物金额 = sum (核销金额)
    /*Select nvl(Sum(nvl(c.write_off_due_amount, 0)), 0)
      Into v_total_wirte_off_amt
      From csh_write_off_temp c
     Where c.session_id = p_session_id;
    
    If r_csh_transaction.transaction_amount < v_total_wirte_off_amt Then
      v_err_message := '收款金额与应收金额不一致,请手工核销!';
      Raise e_batch_write_off_err;
    End If;*/
  
    --现金事物金额与核销金额做比较
    /*for c_write_off in (select * from csh_write_off_temp c 
                               where c.session_id = p_session_id order by c.temp_id)loop
        v_temp_index := c_write_off.temp_id;
        
        v_total_wirte_off_amt := v_total_wirte_off_amt + c_write_off.write_off_due_amount;
        
        if v_total_wirte_off_amt > (r_csh_transaction.transaction_amount - nvl(r_csh_transaction.write_off_amount,0)) then
           update csh_write_off_temp c
              set c.write_off_due_amount = c_write_off.write_off_due_amount - 
                                         (v_total_wirte_off_amt-r_csh_transaction.transaction_amount + nvl(r_csh_transaction.write_off_amount,0))
                                           
            where c.temp_id = v_temp_index;
           exit;
        end if;
    end loop;
    
    delete from csh_write_off_temp c where c.session_id = p_session_id and c.temp_id > v_temp_index;*/
  
  Exception
    When e_batch_write_off_err Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_err_message,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'batch_write_off_df');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'batch_write_off_df');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End batch_write_off_df;

  Procedure update_for_csh_table(p_transaction_id_num Varchar2,
                                 p_bp_id              Number,
                                 p_session_id         Number,
                                 p_user_id            Number) Is
  Begin
    -- 每次df批量重置需要显示的相关收款事务表的Session
    If p_bp_id Is Not Null Then
      Update csh_transaction c Set c.ref_n02 = Null;
    End If;
    -- 循环收款事务id，更新csh_transaction ref_n02 为当前Session
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
      Delete From csh_write_off_temp co
       Where co.session_id = p_session_id
          Or co.transaction_id = i_transaction_id.transaction_id;
    
      Update csh_transaction c
         Set c.ref_n02          = p_session_id,
             c.last_update_date = Sysdate,
             c.last_updated_by  = p_user_id,
             c.ref_n03          = c.transaction_amount
       Where c.transaction_id = i_transaction_id.transaction_id;
    End Loop;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'update_for_csh_table');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End update_for_csh_table;

  -- 需核销数据插入
  Procedure insert_write_off_df_tmp(p_contract_id Number,
                                    p_cf_item     Number,
                                    p_session_id  Number,
                                    p_user_id     Number) Is
    v_transaction_date     Date;
    v_transaction_category csh_transaction.transaction_category%Type;
    v_transaction_type     csh_transaction.transaction_type%Type;
    v_company_id           csh_transaction.company_id%Type;
  Begin
  
    Select Max(c.transaction_date)
      Into v_transaction_date
      From csh_transaction c
     Where c.ref_n02 = p_session_id;
  
    Select c.transaction_category, c.transaction_type, c.company_id
      Into v_transaction_category, v_transaction_type, v_company_id
      From csh_transaction c
     Where c.ref_n02 = p_session_id
       And rownum = 1;
  
    For c_cf In (Select *
                   From con_contract_cashflow cc
                  Where cc.contract_id = p_contract_id
                    And cc.cf_item = p_cf_item
                    And cc.cf_status = 'RELEASE'
                    And cc.cf_direction = 'INFLOW'
                    And cc.due_amount > 0
                    And cc.write_off_flag <> 'FULL'
                    And ((cc.cf_item = 302) Or (cc.cf_item = 304) Or
                        (cc.cf_item = 301 And
                        to_char(cc.due_date, 'yyyymm') <=
                        to_char(v_transaction_date, 'yyyymm')) Or
                        (cc.cf_item = 303 And Exists
                         (Select 1
                             From con_contract c
                            Where c.contract_id = cc.contract_id
                              And c.contract_status = 'NEW')))
                  Order By cc.due_date, cc.times) Loop
      If (c_cf.due_amount - nvl(c_cf.received_amount, 0)) > 0 Then
        insert_csh_write_off_temp(p_session_id           => p_session_id,
                                  p_write_off_type       => 'RECEIPT_CREDIT',
                                  p_transaction_category => v_transaction_category,
                                  p_transaction_type     => v_transaction_type,
                                  p_write_off_date       => trunc(Sysdate),
                                  p_write_off_due_amount => c_cf.due_amount -
                                                            nvl(c_cf.received_amount,
                                                                0),
                                  p_write_off_principal  => Null,
                                  p_write_off_interest   => Null,
                                  p_company_id           => v_company_id,
                                  p_document_category    => 'CONTRACT',
                                  p_document_id          => p_contract_id,
                                  p_document_line_id     => c_cf.cashflow_id,
                                  p_description          => Null,
                                  p_user_id              => p_user_id,
                                  p_transaction_id       => Null);
      End If;
    End Loop;
  
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'insert_write_off_df_tmp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End insert_write_off_df_tmp;
  -- add by Liyuan DF批量核销不计算逾期罚金 
  Procedure execute_csh_write_off_df_temp(p_transaction_id_num Varchar2,
                                          p_temp_id_num        Varchar2,
                                          p_write_off_date     Date,
                                          p_session_id         csh_write_off_temp.session_id%Type,
                                          p_user_id            Number) Is
    e_amount_error Exception;
    v_contract_status Varchar2(20);
    v_et_count        Number;
    e_status_error Exception;
    r_csh_transaction    csh_transaction%Rowtype;
    r_csh_write_off_temp csh_write_off_temp%Rowtype;
    v_lease_channel      Varchar2(10);
    e_cf_advance_receipt Exception;
    v_write_off_due_amount Number;
    v_temp_id_num          Varchar2(5000) := p_temp_id_num;
  Begin
    -- 循环收款事务表数据
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
      Select *
        Into r_csh_transaction
        From csh_transaction c
       Where c.transaction_id = i_transaction_id.transaction_id;
      If R_CSH_TRANSACTION.TRANSACTION_TYPE = 'ADVANCE_RECEIPT' And
         v_lease_channel = '00' Then
        Raise e_cf_advance_receipt;
      End If;
      -- 获取金额数据
      v_write_off_due_amount := round(r_csh_transaction.transaction_amount, 2);
      If v_write_off_due_amount > 0 Then
        For i_temp_id In (Select REGEXP_SUBSTR(v_temp_id_num,
                                               '[^;]+',
                                               1,
                                               rownum) As temp_id
                          
                            From dual
                          Connect By rownum <=
                                     LENGTH(v_temp_id_num) -
                                     LENGTH(regexp_replace(v_temp_id_num,
                                                           ';',
                                                           ''))) Loop
          Select *
            Into r_csh_write_off_temp
            From csh_write_off_temp co
           Where co.temp_id = i_temp_id.temp_id;
        
          If r_csh_write_off_temp.document_id Is Not Null Then
            Select c.contract_status, lease_Channel
              Into v_contract_status, v_lease_channel -- add by wuts
              From con_contract c
             Where c.contract_id = r_csh_write_off_temp.document_id
               For Update Nowait;
            If v_contract_status = 'ETING' Then
              -- 提前结清
              Select Count(*)
                Into v_et_count
                From con_contract_et_hd h
               Where h.contract_id = r_csh_write_off_temp.document_id
                 And h.status = 'APPROVED';
              If v_et_count = 0 Then
                Raise e_status_error;
              End If;
            End If;
          End If;
        
          If v_write_off_due_amount >=
             r_csh_write_off_temp.write_off_due_amount Then
            insert_csh_write_off_temp(p_session_id           => r_csh_write_off_temp.session_id,
                                      p_write_off_type       => r_csh_write_off_temp.write_off_type,
                                      p_transaction_category => r_csh_write_off_temp.transaction_category,
                                      p_transaction_type     => r_csh_write_off_temp.transaction_type,
                                      p_write_off_date       => p_write_off_date,
                                      p_write_off_due_amount => r_csh_write_off_temp.write_off_due_amount,
                                      p_write_off_principal  => Null,
                                      p_write_off_interest   => Null,
                                      p_exchange_rate        => r_csh_write_off_temp.exchange_rate,
                                      p_company_id           => r_csh_write_off_temp.company_id,
                                      p_document_category    => r_csh_write_off_temp.document_category,
                                      p_document_id          => r_csh_write_off_temp.document_id,
                                      p_document_line_id     => r_csh_write_off_temp.document_line_id,
                                      p_description          => r_csh_write_off_temp.description,
                                      p_user_id              => p_user_id,
                                      p_transaction_id       => r_csh_transaction.transaction_id,
                                      p_bp_id                => r_csh_transaction.bp_id,
                                      p_year_flag            => r_csh_write_off_temp.year_flag,
                                      p_quarter_flag         => r_csh_write_off_temp.quarter_flag,
                                      p_month_flag           => r_csh_write_off_temp.month_flag,
                                      p_transfer_type        => r_csh_write_off_temp.transfer_type,
                                      p_risk_in_dec          => r_csh_write_off_temp.risk_in_dec);
            v_write_off_due_amount := v_write_off_due_amount -
                                      r_csh_write_off_temp.write_off_due_amount;
          
            Select Replace(v_temp_id_num,
                           r_csh_write_off_temp.temp_id || ';',
                           Null)
              Into v_temp_id_num
              From dual;
            Delete From csh_write_off_temp t
             Where t.temp_id = r_csh_write_off_temp.temp_id;
          Else
            If v_write_off_due_amount > 0 Then
              insert_csh_write_off_temp(p_session_id           => r_csh_write_off_temp.session_id,
                                        p_write_off_type       => r_csh_write_off_temp.write_off_type,
                                        p_transaction_category => r_csh_write_off_temp.transaction_category,
                                        p_transaction_type     => r_csh_write_off_temp.transaction_type,
                                        p_write_off_date       => p_write_off_date,
                                        p_write_off_due_amount => v_write_off_due_amount,
                                        p_write_off_principal  => Null,
                                        p_write_off_interest   => Null,
                                        p_exchange_rate        => r_csh_write_off_temp.exchange_rate,
                                        p_company_id           => r_csh_write_off_temp.company_id,
                                        p_document_category    => r_csh_write_off_temp.document_category,
                                        p_document_id          => r_csh_write_off_temp.document_id,
                                        p_document_line_id     => r_csh_write_off_temp.document_line_id,
                                        p_description          => r_csh_write_off_temp.description,
                                        p_user_id              => p_user_id,
                                        p_transaction_id       => r_csh_transaction.transaction_id,
                                        p_bp_id                => r_csh_transaction.bp_id,
                                        p_year_flag            => r_csh_write_off_temp.year_flag,
                                        p_quarter_flag         => r_csh_write_off_temp.quarter_flag,
                                        p_month_flag           => r_csh_write_off_temp.month_flag,
                                        p_transfer_type        => r_csh_write_off_temp.transfer_type,
                                        p_risk_in_dec          => r_csh_write_off_temp.risk_in_dec);
              -- 更新剩余未核销金额之后退出，当前收款金额为0，循环下一条收款金额
              Update csh_write_off_temp co
                 Set co.write_off_due_amount = co.write_off_due_amount -
                                               v_write_off_due_amount,
                     co.last_update_date     = Sysdate,
                     co.last_updated_by      = p_user_id
               Where co.temp_id = r_csh_write_off_temp.temp_id;
              Exit;
            End If;
          End If;
        End Loop;
      Else
        Raise e_amount_error;
      End If;
    End Loop;
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
      main_write_off_df(p_session_id     => p_session_id,
                        p_transaction_id => i_transaction_id.transaction_id,
                        p_user_id        => p_user_id);
    End Loop;
  Exception
    When e_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_AMOUNT_NEGATIVE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_df_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_cf_advance_receipt Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CF_ADVANCE_RECEIPT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_df_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_STATUS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'execute_csh_write_off_df_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End execute_csh_write_off_df_temp;

  --核销主入口
  Procedure main_write_off_df(p_session_id          Number,
                              p_transaction_id      Number,
                              p_cross_currency_flag Varchar2 Default 'N',
                              p_receipt_flag        Varchar2 Default Null,
                              p_user_id             Number) Is
    csh_transaction_rec        csh_transaction%Rowtype;
    v_functional_currency_code gld_set_of_books.functional_currency_code%Type;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%Type;
    v_write_off_id             Number;
    --v_amount                   Number;
    e_main_error Exception;
    --i                      Number := 0;
    --v_count                Number;
    --r_hl_transaction_split hl_transaction_split%Rowtype;
    --v_hl_sp_id             Number;
    --v_write_off_amount     Number;
    --v_fin_create_je_flag   Varchar2(100);
  Begin
    csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
                                             p_user_id             => p_user_id,
                                             p_csh_transaction_rec => csh_transaction_rec);
  
    If csh_transaction_rec.transaction_category <>
       csh_transaction_pkg.csh_trx_category_business Then
      v_err_code := 'CSH_WRITE_OFF_PKG.TRX_CATEGORY_ERROR';
      Raise e_main_error;
    End If;
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => csh_transaction_rec.company_id);
    If v_functional_currency_code Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_FUNCTIONAL_CURRENCY_ERROR';
      Raise e_main_error;
    End If;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => csh_transaction_rec.company_id);
    If v_set_of_books_id Is Null Then
      v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_SET_OF_BOOKS_ERROR';
      Raise e_main_error;
    End If;
  
    For c_write_off_temp In (Select *
                               From csh_write_off_temp t
                              Where t.session_id = p_session_id
                                And t.transaction_id = p_transaction_id
                             /* AND t.wfl_instance_id IS NULL  -- modify by 8754 20181218 宏菱租赁不要走工作流，去除该过滤条件
                             AND t.transaction_id IS NULL*/
                             ) Loop
      v_write_off_id := insert_csh_write_off(p_csh_write_off_temp_rec => c_write_off_temp,
                                             p_csh_transaction_rec    => csh_transaction_rec,
                                             p_set_of_books_id        => v_set_of_books_id,
                                             p_cross_currency_flag    => p_cross_currency_flag,
                                             p_user_id                => p_user_id);
    
      execute_write_off(p_write_off_id        => v_write_off_id,
                        p_cross_currency_flag => p_cross_currency_flag,
                        p_user_id             => p_user_id);
      --保证金核销租金,新增一条保证金outflow的核销记录
    
    --收款核销，处理对应的已生成的坐扣数据
    /*IF p_receipt_flag = 'Y' THEN
                                                                                                                                                            BEGIN
                                                                                                                                                              SELECT d.amount
                                                                                                                                                                INTO v_amount
                                                                                                                                                                FROM csh_payment_req_ln_ddct d
                                                                                                                                                               WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                 AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                 AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                 AND d.deduction_flag = 'N';
                                                                                                                                                              sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'v_amount:' || v_amount || ',write_off_due_amount:' ||
                                                                                                                                                                                                                                           c_write_off_temp.write_off_due_amount,
                                                                                                                                                                                                              p_created_by              => p_user_id,
                                                                                                                                                                                                              p_package_name            => 'csh_write_off_pkg',
                                                                                                                                                                                                              p_procedure_function_name => 'test_main_write_off');
                                                                                                                                                              IF v_amount - c_write_off_temp.write_off_due_amount <= 0 THEN
                                                                                                                                                                DELETE FROM csh_payment_req_ln_ddct d
                                                                                                                                                                 WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                   AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                   AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                   AND d.deduction_flag = 'N';
                                                                                                                                                              ELSIF v_amount - c_write_off_temp.write_off_due_amount > 0 THEN
                                                                                                                                                                UPDATE csh_payment_req_ln_ddct d
                                                                                                                                                                   SET d.amount           = d.amount - c_write_off_temp.write_off_due_amount,
                                                                                                                                                                       d.last_update_date = SYSDATE,
                                                                                                                                                                       d.last_updated_by  = p_user_id
                                                                                                                                                                 WHERE d.ref_doc_category = 'CONTRACT'
                                                                                                                                                                   AND d.ref_doc_id = c_write_off_temp.document_id
                                                                                                                                                                   AND d.ref_doc_line_id = c_write_off_temp.document_line_id
                                                                                                                                                                   AND d.deduction_flag = 'N';
                                                                                                                                                              END IF;
                                                                                                                                                            EXCEPTION
                                                                                                                                                              WHEN no_data_found THEN
                                                                                                                                                                NULL;
                                                                                                                                                            END;
                                                                                                                                                          
                                                                                                                                                          END IF;*/
    
    End Loop;
    --modify by 20160902 Spencer 3893 保证金抵扣租金调用次逻辑
    /*IF nvl(csh_transaction_rec.transaction_amount,
           0) = 0
       AND csh_transaction_rec.transaction_type = 'RECEIPT' THEN
      csh_deposit_write_off_pkg.insert_deposit_write_off(p_csh_trx_rec => csh_transaction_rec,
                                                         p_user_id     => p_user_id);
    END IF;*/
    --现金事物拆分
  
    --现金事务核销时，现金事务及核销行 合并生成的凭证
    /*  csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
    p_user_id        => p_user_id);*/
    -- 删除待处理数据
    Delete From csh_write_off_temp ot
     Where ot.session_id = p_session_id
       And ot.transaction_id = p_transaction_id;
    /*delete_csh_write_off_temp(p_session_id => p_session_id,
    p_user_id    => p_user_id);*/
    csh_transaction_je_pkg.create_advance_write_off_je(p_transaction_id => p_transaction_id,
                                                       p_user_id        => p_user_id);
    --合核销凭证立即传输 (取消)
    /*hl_sbo_inf_pkg.create_sbo_immediately_xml(p_je_transaction_code => 'HL_CSH_CONSOLIDATION',
    p_user_id             => p_user_id);*/
  Exception
    When e_main_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_write_off_pkg',
                                                      p_procedure_function_name => 'main_write_off_df');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_write_off_pkg',
                                                     p_procedure_function_name => 'main_write_off_df');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End main_write_off_df;
  -- end add by Liyuan
End csh_write_off_pkg;
/
