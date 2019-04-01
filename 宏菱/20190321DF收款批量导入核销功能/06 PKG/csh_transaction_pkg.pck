Create Or Replace Package csh_transaction_pkg Is

  -- Author  : GAOYANG
  -- Created : 2013/5/9 14:43:26
  -- Purpose : 现金事务
  -- Version : 1.18

  ---退款
  csh_trx_return_flag_p      Constant Varchar2(30) := 'PARTIAL';
  csh_trx_return_flag_f      Constant Varchar2(30) := 'FULL';
  csh_trx_return_flag_n      Constant Varchar2(30) := 'NOT';
  csh_trx_return_flag_return Constant Varchar2(30) := 'RETURN'; --退款类型
  --核销
  csh_trx_write_off_flag_p Constant Varchar2(30) := 'PARTIAL'; -- 部分核销
  csh_trx_write_off_flag_n Constant Varchar2(30) := 'NOT'; -- 未核销
  csh_trx_write_off_flag_f Constant Varchar2(30) := 'FULL'; -- 完全核销

  ---冲销
  csh_trx_reversed_flag_n Constant Varchar2(1) := 'N';
  csh_trx_reversed_flag_r Constant Varchar2(1) := 'R';
  csh_trx_reversed_flag_w Constant Varchar2(1) := 'W';

  csh_trx_type_receipt    Constant Varchar2(30) := 'RECEIPT'; -- 收款类型
  csh_trx_type_prereceipt Constant Varchar2(30) := 'ADVANCE_RECEIPT'; -- 预收款类型
  csh_trx_type_payment    Constant Varchar2(30) := 'PAYMENT'; -- 付款类型
  csh_trx_type_deduction  Constant Varchar2(30) := 'DEDUCTION'; -- 收付抵扣

  csh_trx_category_business      Constant Varchar2(30) := 'BUSINESS'; -- 收款类别
  csh_trx_category_loan_withdraw Constant Varchar2(30) := 'LOAN_WITHDRAW'; -- 银行借款
  csh_trx_category_capital_int   Constant Varchar2(30) := 'LOAN_REPAYMENT_CI'; -- 还本付息
  csh_trx_category_capital       Constant Varchar2(30) := 'LOAN_REPAYMENT_C'; -- 本金
  csh_trx_category_interest      Constant Varchar2(30) := 'LOAN_REPAYMENT_I'; -- 利息
  csh_trx_category_factoring     Constant Varchar2(30) := 'LOAN_REPAYMENT_F'; -- 保理还款
  csh_trx_category_factoring_fee Constant Varchar2(30) := 'LOAN_REPAYMENT_FF'; -- 保理费

  csh_trx_type_deposit Constant Varchar2(30) := 'DEPOSIT'; --保证金类型
  csh_trx_type_risk    Constant Varchar2(30) := 'RISK'; --风险金类型

  ---过帐
  csh_trx_posted_flag_yes Constant Varchar2(1) := 'Y';
  csh_trx_posted_flag_no  Constant Varchar2(1) := 'N';

  /* 现金事务编号获取函数 */
  Function get_csh_transaction_num(p_transaction_type Varchar2,
                                   p_transaction_date Date,
                                   p_company_id       Number,
                                   p_user_id          Number) Return Varchar2;

  Procedure lock_csh_transaction(p_transaction_id      In Number,
                                 p_user_id             In Number,
                                 p_csh_transaction_rec Out csh_transaction%Rowtype);

  --更新现金事务核销状态
  Procedure set_csh_trx_write_off_status(p_csh_trx_rec      csh_transaction%Rowtype,
                                         p_write_off_amount Number,
                                         p_user_id          Number);

  --更新被反冲现金事务
  Procedure update_csh_trx_after_reverse(p_transaction_id      Number,
                                         p_reversed_date       Date,
                                         p_reserved_csh_trx_id Number,
                                         p_user_id             Number);

  --核销反冲后更新原现金事务核销金额
  Procedure update_trx_amt_after_reverse(p_transaction_id Number,
                                         p_reverse_amount Number,
                                         p_user_id        Number);

  Function is_trx_return(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean;

  Function is_trx_reverse(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean;

  /*modify by xuls 2014-9-16
  add ref_contract_id
   */
  Procedure insert_csh_transaction(p_transaction_id          Out csh_transaction.transaction_id%Type,
                                   p_transaction_num         csh_transaction.transaction_num%Type,
                                   p_transaction_category    csh_transaction.transaction_category%Type,
                                   p_transaction_type        csh_transaction.transaction_type%Type,
                                   p_transaction_date        csh_transaction.transaction_date%Type,
                                   p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                   p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                   p_company_id              csh_transaction.company_id%Type,
                                   p_internal_period_num     csh_transaction.internal_period_num%Type,
                                   p_period_name             csh_transaction.period_name%Type,
                                   p_payment_method_id       csh_transaction.payment_method_id%Type,
                                   p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                   p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                   p_currency_code           csh_transaction.currency_code%Type,
                                   p_transaction_amount      csh_transaction.transaction_amount%Type,
                                   p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                   p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                   p_exchange_rate           csh_transaction.exchange_rate%Type,
                                   p_bank_account_id         csh_transaction.bank_account_id%Type,
                                   p_bp_category             csh_transaction.bp_category%Type,
                                   p_bp_id                   csh_transaction.bp_id%Type,
                                   p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                   p_bp_bank_account_name    csh_transaction.bp_bank_account_name%Type Default Null, --add by Spener 3893 20160722
                                   p_description             csh_transaction.description%Type,
                                   p_handling_charge         csh_transaction.handling_charge%Type,
                                   p_posted_flag             csh_transaction.posted_flag%Type,
                                   p_reversed_flag           csh_transaction.reversed_flag%Type,
                                   p_reversed_date           csh_transaction.reversed_date%Type,
                                   p_returned_flag           csh_transaction.returned_flag%Type,
                                   p_returned_amount         csh_transaction.returned_amount%Type,
                                   p_write_off_flag          csh_transaction.write_off_flag%Type,
                                   p_write_off_amount        csh_transaction.write_off_amount%Type,
                                   p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                   p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                   p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                   p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                   p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                   p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                   p_source_doc_category     csh_transaction.source_doc_category%Type,
                                   p_source_doc_type         csh_transaction.source_doc_type%Type,
                                   p_source_doc_id           csh_transaction.source_doc_id%Type,
                                   p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                   p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                   p_create_je_flag          csh_transaction.create_je_flag%Type,
                                   p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                   p_user_id                 csh_transaction.created_by%Type,
                                   p_ref_contract_id         csh_transaction.ref_contract_id%Type Default Null,
                                   p_receipt_type            csh_transaction.receipt_type%Type Default Null,
                                   p_csh_bp_name             csh_transaction.csh_bp_name%Type Default Null,
                                   p_ref_n01                 Number Default Null,
                                   p_lease_channel           csh_transaction.lease_channel%Type Default Null,
                                   p_guangsan_flag           csh_transaction.guangsan_flag%Type Default Null,
                                   -- modified by Liyuan
                                   p_fee_type csh_transaction.fee_type%Type Default Null);
  Procedure update_csh_transaction(p_transaction_id          csh_transaction.transaction_id%Type,
                                   p_transaction_num         csh_transaction.transaction_num%Type,
                                   p_transaction_category    csh_transaction.transaction_category%Type,
                                   p_transaction_type        csh_transaction.transaction_type%Type,
                                   p_transaction_date        csh_transaction.transaction_date%Type,
                                   p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                   p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                   p_company_id              csh_transaction.company_id%Type,
                                   p_internal_period_num     csh_transaction.internal_period_num%Type,
                                   p_period_name             csh_transaction.period_name%Type,
                                   p_payment_method_id       csh_transaction.payment_method_id%Type,
                                   p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                   p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                   p_currency_code           csh_transaction.currency_code%Type,
                                   p_transaction_amount      csh_transaction.transaction_amount%Type,
                                   p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                   p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                   p_exchange_rate           csh_transaction.exchange_rate%Type,
                                   p_bank_account_id         csh_transaction.bank_account_id%Type,
                                   p_bp_category             csh_transaction.bp_category%Type,
                                   p_bp_id                   csh_transaction.bp_id%Type,
                                   p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                   p_description             csh_transaction.description%Type,
                                   p_handling_charge         csh_transaction.handling_charge%Type,
                                   p_posted_flag             csh_transaction.posted_flag%Type,
                                   p_reversed_flag           csh_transaction.reversed_flag%Type,
                                   p_reversed_date           csh_transaction.reversed_date%Type,
                                   p_returned_flag           csh_transaction.returned_flag%Type,
                                   p_returned_amount         csh_transaction.returned_amount%Type,
                                   p_write_off_flag          csh_transaction.write_off_flag%Type,
                                   p_write_off_amount        csh_transaction.write_off_amount%Type,
                                   p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                   p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                   p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                   p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                   p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                   p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                   p_source_doc_category     csh_transaction.source_doc_category%Type,
                                   p_source_doc_type         csh_transaction.source_doc_type%Type,
                                   p_source_doc_id           csh_transaction.source_doc_id%Type,
                                   p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                   p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                   p_create_je_flag          csh_transaction.create_je_flag%Type,
                                   p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                   p_user_id                 csh_transaction.created_by%Type,
                                   p_ref_contract_id         csh_transaction.ref_contract_id%Type Default Null,
                                   p_ref_n01                 Number Default Null,
                                   p_lease_channel           csh_transaction.lease_channel%Type Default Null,
                                   p_guangsan_flag           csh_transaction.guangsan_flag%Type Default Null,
                                   -- modified by Liyuan 
                                   p_fee_type csh_transaction.fee_type%Type Default Null);
  --货币兑换维护
  Procedure update_currency_exchange_trx(p_transaction_id          csh_transaction.transaction_id%Type,
                                         p_transaction_num         csh_transaction.transaction_num%Type,
                                         p_transaction_category    csh_transaction.transaction_category%Type,
                                         p_transaction_type        csh_transaction.transaction_type%Type,
                                         p_transaction_date        csh_transaction.transaction_date%Type,
                                         p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                         p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                         p_company_id              csh_transaction.company_id%Type,
                                         p_internal_period_num     csh_transaction.internal_period_num%Type,
                                         p_period_name             csh_transaction.period_name%Type,
                                         p_payment_method_id       csh_transaction.payment_method_id%Type,
                                         p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                         p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                         p_currency_code           csh_transaction.currency_code%Type,
                                         p_transaction_amount      csh_transaction.transaction_amount%Type,
                                         p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                         p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                         p_exchange_rate           csh_transaction.exchange_rate%Type,
                                         p_bank_account_id         csh_transaction.bank_account_id%Type,
                                         p_bp_category             csh_transaction.bp_category%Type,
                                         p_bp_id                   csh_transaction.bp_id%Type,
                                         p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                         p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                         p_description             csh_transaction.description%Type,
                                         p_handling_charge         csh_transaction.handling_charge%Type,
                                         p_posted_flag             csh_transaction.posted_flag%Type,
                                         p_reversed_flag           csh_transaction.reversed_flag%Type,
                                         p_reversed_date           csh_transaction.reversed_date%Type,
                                         p_returned_flag           csh_transaction.returned_flag%Type,
                                         p_returned_amount         csh_transaction.returned_amount%Type,
                                         p_write_off_flag          csh_transaction.write_off_flag%Type,
                                         p_write_off_amount        csh_transaction.write_off_amount%Type,
                                         p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                         p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                         p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                         p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                         p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                         p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                         p_source_doc_category     csh_transaction.source_doc_category%Type,
                                         p_source_doc_type         csh_transaction.source_doc_type%Type,
                                         p_source_doc_id           csh_transaction.source_doc_id%Type,
                                         p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                         p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                         p_create_je_flag          csh_transaction.create_je_flag%Type,
                                         p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                         p_user_id                 csh_transaction.created_by%Type);

  --货币兑换互记TWIN_CSH_TRX_ID
  Procedure save_twin_csh_trx_id(p_transaction_num csh_transaction.transaction_num%Type,
                                 p_user_id         Number);

  --货币兑换过账以后维护
  Procedure upd_currency_trx_after_post(p_transaction_id csh_transaction.transaction_id%Type,
                                        p_bank_slip_num  csh_transaction.bank_slip_num%Type,
                                        p_description    csh_transaction.description%Type,
                                        p_user_id        csh_transaction.created_by%Type);
  --过账以后维护
  Procedure update_csh_transaction_post(p_transaction_id     csh_transaction.transaction_id%Type,
                                        p_bank_slip_num      csh_transaction.bank_slip_num%Type,
                                        p_bp_bank_account_id csh_transaction.bp_bank_account_id%Type,
                                        p_user_id            csh_transaction.created_by%Type);

  Procedure update_csh_post_flag(p_transaction_id Number,
                                 p_user_id        Number,
                                 p_claim          Varchar2 Default Null);
  Procedure delete_csh_transaction(p_transaction_id csh_transaction.transaction_id%Type,
                                   p_user_id        csh_transaction.created_by%Type);
  Procedure post_csh_transaction(p_transaction_id csh_transaction.transaction_id%Type,
                                 p_user_id        csh_transaction.created_by%Type);

  --通用的反冲入口
  Procedure reverse_csh_transaction(p_transaction_id         csh_transaction.transaction_id%Type,
                                    p_reversed_date          csh_transaction.reversed_date%Type,
                                    p_description            csh_transaction.description%Type,
                                    p_user_id                csh_transaction.created_by%Type,
                                    p_reverse_transaction_id Out csh_transaction.transaction_id%Type);
  --收款反冲入口
  Procedure reverse_receipt_csh_trx(p_transaction_id csh_transaction.transaction_id%Type,
                                    p_reversed_date  csh_transaction.reversed_date%Type,
                                    p_bank_slip_num  csh_transaction.bank_slip_num%Type,
                                    p_description    csh_transaction.description%Type,
                                    p_user_id        csh_transaction.created_by%Type);

  Procedure return_csh_transaction(p_transaction_id      csh_transaction.transaction_id%Type,
                                   p_returned_date       Date,
                                   p_returned_amount     csh_transaction.returned_amount%Type,
                                   p_bank_slip_num       csh_transaction.bank_slip_num%Type,
                                   p_payment_method_id   csh_transaction.payment_method_id%Type,
                                   p_bank_account_id     csh_transaction.bank_account_id%Type,
                                   p_bp_bank_account_id  csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num csh_transaction.bp_bank_account_num%Type,
                                   p_description         csh_transaction.description%Type,
                                   p_user_id             csh_transaction.created_by%Type);
  Procedure delete_interface(p_batch_id Number, p_user_id Number);

  Procedure insert_interface(p_header_id Number,
                             p_batch_id  Number,
                             p_user_id   Number);

  Procedure check_data(p_batch_id  Number,
                       p_user_id   Number,
                       p_return_id Out Number);

  Procedure save_data(p_batch_id     Number,
                      p_user_id      Number,
                      p_company_id   Number,
                      v_save_message Out Varchar2);

  Procedure risk_vat_insert(p_vat        Number,
                            p_company_id Number,
                            p_user_id    Number);
  Procedure check_desripction_single(p_description Varchar2,
                                     p_user_id     Number);
  -- add by Liyuan df收款批量导入
  Procedure delete_batch_interface(p_batch_session_id Number,
                                   p_user_id          Number);

  Procedure insert_batch_interface(p_header_id        Number,
                                   p_batch_session_id Number,
                                   p_user_id          Number);

  Function date_data_check(p_data_import In Varchar2) Return Boolean;

  Procedure delete_error_batch_logs(p_batch_session_id Number);

  Procedure txn_batch_log(p_batch_temp In csh_transaction_batch_temp%Rowtype,
                          p_log_text   In Varchar2,
                          p_user_id    In Number,
                          p_flag       In Varchar2);

  Procedure check_batch_data(p_batch_session_id Number, p_user_id Number);

  Function match_bp_by_name(p_bp_name       In Varchar2,
                            p_error_message Out Varchar2) Return Number;

  Procedure save_batch_data(p_batch_session_id Number,
                            p_user_id          Number,
                            p_company_id       Number);
  -- end add by Liyuan  
End csh_transaction_pkg;
/
Create Or Replace Package Body csh_transaction_pkg Is

  v_err_code Varchar2(2000);
  e_lock_trx_error Exception;
  Pragma Exception_Init(e_lock_trx_error, -54);

  Function get_csh_transaction_num(p_transaction_type Varchar2,
                                   p_transaction_date Date,
                                   p_company_id       Number,
                                   p_user_id          Number) Return Varchar2 Is
    v_transaction_num csh_transaction.transaction_num%Type;
    e_trx_num_error Exception;
  Begin
    v_transaction_num := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => 'CSH_TRX',
                                                                  p_document_type     => p_transaction_type,
                                                                  p_company_id        => p_company_id,
                                                                  p_operation_unit_id => Null,
                                                                  p_operation_date    => p_transaction_date,
                                                                  p_created_by        => p_user_id);
    If nvl(v_transaction_num, fnd_code_rule_pkg.c_error) =
       fnd_code_rule_pkg.c_error Then
      Raise e_trx_num_error;
    End If;
    Return v_transaction_num;
  Exception
    When e_trx_num_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_TRANSACTION_NUM_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'get_csh_transaction_num');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --录入0金额校验
  Procedure check_zero_amount(p_csh_transaction_rec In csh_transaction%Rowtype,
                              p_user_id             In Number) Is
    v_zero_amounts_allowed Varchar2(1);
    e_amount_error Exception;
  Begin
  
    If p_csh_transaction_rec.transaction_amount <> 0 Or
       (p_csh_transaction_rec.transaction_amount = 0 And
       p_csh_transaction_rec.transaction_type = csh_trx_type_deduction) Then
      Return;
    End If;
  
    /*SELECT nvl(d.zero_amounts_allowed, 'N')
      INTO v_zero_amounts_allowed
      FROM csh_bank_account_v d
     WHERE d.bank_account_id = p_csh_transaction_rec.bank_account_id;
    
    IF v_zero_amounts_allowed = 'N' THEN
      RAISE e_amount_error;
    END IF;*/
  Exception
    When e_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_ZERO_AMOUNT_CHECK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'zero_amount_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  Procedure lock_csh_transaction(p_transaction_id      In Number,
                                 p_user_id             In Number,
                                 p_csh_transaction_rec Out csh_transaction%Rowtype) Is
  
  Begin
    Select *
      Into p_csh_transaction_rec
      From csh_transaction t
     Where t.transaction_id = p_transaction_id
       For Update Nowait;
  
  Exception
    When e_lock_trx_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_LOCK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'lock_csh_transaction');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --更新现金事务核销状态（包括已核销金额）
  Procedure set_csh_trx_write_off_status(p_csh_trx_rec      csh_transaction%Rowtype,
                                         p_write_off_amount Number,
                                         p_user_id          Number) Is
  
    v_csh_transaction_rec csh_transaction%Rowtype;
    v_sum_write_off_amt   Number := 0;
    v_sum_check_amount    Number := 0;
    v_write_off_flag      Varchar2(30);
    v_last_write_off_date Date;
  
    e_write_off_amount_error Exception;
  Begin
    If p_csh_trx_rec.transaction_type = csh_trx_type_deduction Then
      Return;
    End If;
  
    lock_csh_transaction(p_transaction_id      => p_csh_trx_rec.transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    v_sum_write_off_amt := nvl(p_write_off_amount, 0) +
                           nvl(v_csh_transaction_rec.write_off_amount, 0);
    v_sum_check_amount  := nvl(p_write_off_amount, 0) +
                           nvl(v_csh_transaction_rec.write_off_amount, 0) +
                           nvl(v_csh_transaction_rec.returned_amount, 0);
    If v_sum_check_amount = 0 Then
      v_write_off_flag      := csh_trx_write_off_flag_n;
      v_last_write_off_date := v_csh_transaction_rec.full_write_off_date;
    Elsif v_sum_check_amount > 0 And
          v_sum_check_amount < v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag      := csh_trx_write_off_flag_p;
      v_last_write_off_date := v_csh_transaction_rec.full_write_off_date;
    Elsif v_sum_check_amount = v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag      := csh_trx_write_off_flag_f;
      v_last_write_off_date := csh_write_off_pkg.get_last_write_off_date(p_transaction_id => v_csh_transaction_rec.transaction_id);
    Else
      Raise e_write_off_amount_error;
    End If;
  
    Update csh_transaction t
       Set t.write_off_flag      = v_write_off_flag,
           t.write_off_amount    = v_sum_write_off_amt,
           t.full_write_off_date = v_last_write_off_date,
           t.last_update_date    = Sysdate,
           t.last_updated_by     = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
  
  Exception
    When e_write_off_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_WRITE_OFF_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'set_csh_trx_write_off_status');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --更新退款现金事务信息
  Procedure update_csh_trx_after_return(p_transaction_id  Number,
                                        p_returned_amount Number,
                                        p_user_id         Number) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    v_returned_flag       csh_transaction.returned_flag%Type;
    v_write_off_flag      csh_transaction.write_off_flag%Type;
  
    v_sum_returned_amount Number := 0;
    v_sum_writeoff_amount Number := 0;
  
    e_sum_returned_amount_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    v_sum_returned_amount := nvl(v_csh_transaction_rec.returned_amount, 0) +
                             nvl(p_returned_amount, 0);
    v_sum_writeoff_amount := nvl(v_csh_transaction_rec.returned_amount, 0) +
                             nvl(p_returned_amount, 0) +
                             nvl(v_csh_transaction_rec.write_off_amount, 0);
  
    If v_sum_writeoff_amount = v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag := csh_trx_write_off_flag_f;
    Elsif v_sum_writeoff_amount = 0 Then
      v_write_off_flag := csh_trx_write_off_flag_n;
    Elsif v_sum_writeoff_amount > 0 And
          v_sum_writeoff_amount < v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag := csh_trx_write_off_flag_p;
    Else
      Raise e_sum_returned_amount_error;
    End If;
  
    If v_sum_returned_amount = v_csh_transaction_rec.transaction_amount Then
      v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_f;
    Elsif v_sum_returned_amount = 0 Then
      v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_n;
    Elsif v_sum_returned_amount > 0 And
          v_sum_returned_amount < v_csh_transaction_rec.transaction_amount Then
      v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_p;
    Else
      Raise e_sum_returned_amount_error;
    End If;
  
    Update csh_transaction t
       Set t.returned_flag    = v_returned_flag,
           t.returned_amount  = v_sum_returned_amount,
           t.write_off_flag   = v_write_off_flag,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
  Exception
    When e_sum_returned_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_RETURNED_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_csh_trx_after_return');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --更新被反冲现金事务
  Procedure update_csh_trx_after_reverse(p_transaction_id      Number,
                                         p_reversed_date       Date,
                                         p_reserved_csh_trx_id Number,
                                         p_user_id             Number) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    Update csh_transaction t
       Set t.reversed_flag       = csh_transaction_pkg.csh_trx_reversed_flag_w,
           t.reversed_date       = p_reversed_date,
           t.reversed_csh_trx_id = p_reserved_csh_trx_id,
           t.last_update_date    = Sysdate,
           t.last_updated_by     = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
  End;

  --退款反冲后更新原退款现金事务信息
  Procedure upd_rtn_csh_trx_after_reverse(p_transaction_id Number,
                                          p_user_id        Number) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    v_source_csh_trx_rec  csh_transaction%Rowtype;
    v_returned_flag       csh_transaction.returned_flag%Type;
    v_write_off_flag      csh_transaction.write_off_flag%Type;
    v_sum_returned_amount Number := 0;
    v_sum_writeoff_amount Number := 0;
    e_sum_returned_amount_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    lock_csh_transaction(p_transaction_id      => v_csh_transaction_rec.return_from_csh_trx_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_source_csh_trx_rec);
  
    v_sum_returned_amount := nvl(v_source_csh_trx_rec.returned_amount, 0) -
                             nvl(v_csh_transaction_rec.transaction_amount,
                                 0);
  
    v_sum_writeoff_amount := v_sum_returned_amount +
                             nvl(v_source_csh_trx_rec.write_off_amount, 0);
  
    If v_sum_writeoff_amount = v_source_csh_trx_rec.transaction_amount Then
      v_write_off_flag := csh_trx_write_off_flag_f;
    Elsif v_sum_writeoff_amount = 0 Then
      v_write_off_flag := csh_trx_write_off_flag_n;
    Elsif v_sum_writeoff_amount > 0 And
          v_sum_writeoff_amount < v_source_csh_trx_rec.transaction_amount Then
      v_write_off_flag := csh_trx_write_off_flag_p;
    Else
      Raise e_sum_returned_amount_error;
    End If;
  
    If v_sum_returned_amount = 0 Then
      v_returned_flag := csh_trx_return_flag_n;
    Elsif v_sum_returned_amount = v_source_csh_trx_rec.transaction_amount Then
      v_returned_flag := csh_trx_return_flag_f;
    Elsif v_sum_returned_amount > 0 And
          v_sum_returned_amount < v_source_csh_trx_rec.transaction_amount Then
      v_returned_flag := csh_trx_return_flag_p;
    Else
      Raise e_sum_returned_amount_error;
    End If;
  
    Update csh_transaction t
       Set t.returned_amount  = v_sum_returned_amount,
           t.returned_flag    = v_returned_flag,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.return_from_csh_trx_id;
  Exception
    When e_sum_returned_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_RETURNED_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'upd_rtn_csh_trx_after_reverse');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --核销反冲后更新被反冲现金事务核销金额
  Procedure update_trx_amt_after_reverse(p_transaction_id Number,
                                         p_reverse_amount Number,
                                         p_user_id        Number) Is
    v_csh_transaction_rec  csh_transaction%Rowtype;
    v_sum_write_off_amount Number;
  
    v_sum_check_amount    Number;
    v_write_off_flag      Varchar2(30);
    v_last_write_off_date Date;
    e_sum_writeoff_amount_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    --抵扣的不用更新现金流金额                     
    If v_csh_transaction_rec.transaction_type = csh_trx_type_deduction Then
      Return;
    End If;
  
    v_sum_write_off_amount := nvl(v_csh_transaction_rec.write_off_amount, 0) -
                              nvl(p_reverse_amount, 0);
  
    v_sum_check_amount := nvl(v_csh_transaction_rec.write_off_amount, 0) +
                          nvl(v_csh_transaction_rec.returned_amount, 0) -
                          nvl(p_reverse_amount, 0);
  
    If v_sum_check_amount = 0 Then
      v_write_off_flag      := csh_trx_write_off_flag_n;
      v_last_write_off_date := Null;
    Elsif v_sum_check_amount > 0 And
          v_sum_check_amount < v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag      := csh_trx_write_off_flag_p;
      v_last_write_off_date := Null;
    Elsif v_sum_check_amount = v_csh_transaction_rec.transaction_amount Then
      v_write_off_flag      := csh_trx_write_off_flag_f;
      v_last_write_off_date := csh_write_off_pkg.get_last_write_off_date(p_transaction_id => v_csh_transaction_rec.transaction_id);
    Else
      Raise e_sum_writeoff_amount_error;
    End If;
    --反冲后更新审批状态为新建  20170216  JIANGLEI
    Update csh_transaction t
       Set t.write_off_amount    = v_sum_write_off_amount,
           t.write_off_flag      = v_write_off_flag,
           t.full_write_off_date = v_last_write_off_date,
           t.status              = 'NEW',
           t.last_update_date    = Sysdate,
           t.last_updated_by     = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
  Exception
    When e_sum_writeoff_amount_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_WRITEOFF_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_trx_amt_after_reverse');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --更新银行水单
  Procedure update_bank_slip_num(p_transaction_id csh_transaction.transaction_id%Type,
                                 p_bank_slip_num  csh_transaction.bank_slip_num%Type,
                                 p_user_id        csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    Update csh_transaction t
       Set t.bank_slip_num    = p_bank_slip_num,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
  End;
  Function is_trx_return(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag,
           csh_transaction_pkg.csh_trx_posted_flag_yes) <>
       csh_transaction_pkg.csh_trx_posted_flag_yes Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_POSTED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.returned_flag,
              csh_transaction_pkg.csh_trx_return_flag_n) =
          csh_transaction_pkg.csh_trx_return_flag_f Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_RETURN_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.reversed_flag,
              csh_transaction_pkg.csh_trx_reversed_flag_n) <>
          csh_transaction_pkg.csh_trx_reversed_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_REVERSED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.write_off_flag,
              csh_transaction_pkg.csh_trx_write_off_flag_n) =
          csh_transaction_pkg.csh_trx_write_off_flag_f Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_WRITE_OFF_FLAG_ERROR';
      Return False;
    Else
      Return True;
    End If;
  End;
  Function is_trx_reverse(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag, csh_trx_posted_flag_yes) <>
       csh_trx_posted_flag_yes Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_POSTED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) Not In
          (csh_trx_return_flag_n, csh_trx_return_flag_return) Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_RETURN_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.reversed_flag, csh_trx_reversed_flag_n) <>
          csh_trx_reversed_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_REVERSED_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.write_off_flag,
              csh_trx_write_off_flag_n) <> csh_trx_write_off_flag_n And
          nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) <>
          csh_trx_return_flag_return And
          p_csh_transaction_rec.transaction_type Not In
          (csh_trx_type_payment, 'DEDUCTION') Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_WRITE_OFF_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.write_off_flag,
              csh_trx_write_off_flag_n) <> csh_trx_write_off_flag_f And
          nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) <>
          csh_trx_return_flag_n And
          p_csh_transaction_rec.transaction_type = csh_trx_type_payment Then
      v_err_code := 'CSH_TRANSACTION_PKG.PAYMENT_REVERSE_WRITE_OFF_FLAG_ERROR';
      Return False;
    Elsif nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) =
          csh_trx_return_flag_return And
          nvl(p_csh_transaction_rec.write_off_flag,
              csh_trx_write_off_flag_n) <> csh_trx_write_off_flag_f Then
      v_err_code := 'CSH_TRANSACTION_PKG.RETURN_WRITE_OFF_FLAG_ERROR';
      Return False;
    Else
      Return True;
    End If;
  End;

  Function is_trx_post(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag,
           csh_transaction_pkg.csh_trx_posted_flag_no) =
       csh_transaction_pkg.csh_trx_posted_flag_no Then
      Return True;
    Else
      Return False;
    End If;
  End;
  Function is_trx_update(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag,
           csh_transaction_pkg.csh_trx_posted_flag_no) =
       csh_transaction_pkg.csh_trx_posted_flag_no Then
      Return True;
    Else
      Return False;
    End If;
  End;
  Function is_trx_update_after_post(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag,
           csh_transaction_pkg.csh_trx_posted_flag_no) <>
       csh_transaction_pkg.csh_trx_posted_flag_yes Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_POST_STATUS_CHECK';
      Return False;
    Elsif nvl(p_csh_transaction_rec.reversed_flag,
              csh_transaction_pkg.csh_trx_reversed_flag_n) <>
          csh_transaction_pkg.csh_trx_reversed_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_REVERSE_FLAG_CHECK';
      Return False;
    Else
      Return True;
    End If;
  End;
  Function is_trx_delete(p_csh_transaction_rec In csh_transaction%Rowtype)
    Return Boolean Is
  Begin
    If nvl(p_csh_transaction_rec.posted_flag,
           csh_transaction_pkg.csh_trx_posted_flag_no) <>
       csh_transaction_pkg.csh_trx_posted_flag_no Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_STATUS_CHECK';
      Return False;
    Elsif nvl(p_csh_transaction_rec.reversed_flag,
              csh_transaction_pkg.csh_trx_reversed_flag_n) <>
          csh_transaction_pkg.csh_trx_reversed_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_REVERSE_CHECK';
      Return False;
    Elsif nvl(p_csh_transaction_rec.returned_flag,
              csh_transaction_pkg.csh_trx_return_flag_n) <>
          csh_transaction_pkg.csh_trx_return_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_RETURN_CHECK';
      Return False;
    Elsif nvl(p_csh_transaction_rec.write_off_flag,
              csh_transaction_pkg.csh_trx_write_off_flag_n) <>
          csh_transaction_pkg.csh_trx_write_off_flag_n Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_WRITEOFF_CHECK';
      Return False;
    Else
      Return True;
    End If;
  End;
  Procedure insert_csh_transaction(p_csh_transaction_rec In Out csh_transaction%Rowtype) Is
  Begin
    If p_csh_transaction_rec.transaction_id Is Null Then
      Select csh_transaction_s.nextval
        Into p_csh_transaction_rec.transaction_id
        From dual;
    End If;
    Insert Into csh_transaction Values p_csh_transaction_rec;
  End;
  Procedure check_desripction_single(p_description Varchar2,
                                     p_user_id     Number) Is
    r Number := 0;
    s Number := 0;
    p Number := 0;
    e_description_err Exception;
    v_code_err Varchar2(400);
  Begin
    -- modified by Liyuan 针对摘要修改为不必输
    If Trim(Replace(p_description, chr(10), '')) Is Not Null Or
       Trim(Replace(p_description, chr(10), '')) <> '' Then
      /*v_code_err := 'CSH_TRANSACTION_PKG.CSH510_DESCRIPTION_NULL_ERR';
      Raise e_description_err;*/
    
      For cur_des In (Select regexp_substr(Trim(Replace(p_description,
                                                        chr(10),
                                                        '')),
                                           '[^、]+',
                                           1,
                                           rownum) As document_number
                        From dual
                      Connect By rownum <=
                                 length(Trim(Replace(p_description,
                                                     chr(10),
                                                     ''))) -
                                 length(regexp_replace(Trim(Replace(p_description,
                                                                    chr(10),
                                                                    '')),
                                                       '、',
                                                       '')) + 1) Loop
        If substr(cur_des.document_number, 1, 3) = 'RFQ' Then
          --管理费
          r := r + 1;
        Elsif substr(cur_des.document_number, 1, 1) = 'P' Then
          --首付款
          p := p + 1;
        Elsif substr(cur_des.document_number, 1, 2) = 'SZ' Then
          --赎证
          s := s + 1;
        End If;
      
      End Loop;
      If (r = 0 And p = 0) Or (p = 0 And s = 0) Or (r = 0 And s = 0) Then
        Null; --success
      Else
        v_code_err := 'CSH_TRANSACTION_PKG.CSH510_DESCRIPTION_ERR';
        Raise e_description_err; --error
      End If;
    End If;
    -- end modified by Liyuan
  Exception
    When e_description_err Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_code_err,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'check_desripction_single');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'check_desripction_single');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  End;
  /*add by xuls for ref_contract_id 2014-9-26
   用于增加记录收款合同号
  */
  Procedure insert_csh_transaction(p_transaction_id          Out csh_transaction.transaction_id%Type,
                                   p_transaction_num         csh_transaction.transaction_num%Type,
                                   p_transaction_category    csh_transaction.transaction_category%Type,
                                   p_transaction_type        csh_transaction.transaction_type%Type,
                                   p_transaction_date        csh_transaction.transaction_date%Type,
                                   p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                   p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                   p_company_id              csh_transaction.company_id%Type,
                                   p_internal_period_num     csh_transaction.internal_period_num%Type,
                                   p_period_name             csh_transaction.period_name%Type,
                                   p_payment_method_id       csh_transaction.payment_method_id%Type,
                                   p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                   p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                   p_currency_code           csh_transaction.currency_code%Type,
                                   p_transaction_amount      csh_transaction.transaction_amount%Type,
                                   p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                   p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                   p_exchange_rate           csh_transaction.exchange_rate%Type,
                                   p_bank_account_id         csh_transaction.bank_account_id%Type,
                                   p_bp_category             csh_transaction.bp_category%Type,
                                   p_bp_id                   csh_transaction.bp_id%Type,
                                   p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                   p_bp_bank_account_name    csh_transaction.bp_bank_account_name%Type Default Null, --add by Spener 3893 20160722
                                   p_description             csh_transaction.description%Type,
                                   p_handling_charge         csh_transaction.handling_charge%Type,
                                   p_posted_flag             csh_transaction.posted_flag%Type,
                                   p_reversed_flag           csh_transaction.reversed_flag%Type,
                                   p_reversed_date           csh_transaction.reversed_date%Type,
                                   p_returned_flag           csh_transaction.returned_flag%Type,
                                   p_returned_amount         csh_transaction.returned_amount%Type,
                                   p_write_off_flag          csh_transaction.write_off_flag%Type,
                                   p_write_off_amount        csh_transaction.write_off_amount%Type,
                                   p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                   p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                   p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                   p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                   p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                   p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                   p_source_doc_category     csh_transaction.source_doc_category%Type,
                                   p_source_doc_type         csh_transaction.source_doc_type%Type,
                                   p_source_doc_id           csh_transaction.source_doc_id%Type,
                                   p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                   p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                   p_create_je_flag          csh_transaction.create_je_flag%Type,
                                   p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                   p_user_id                 csh_transaction.created_by%Type,
                                   p_ref_contract_id         csh_transaction.ref_contract_id%Type Default Null,
                                   p_receipt_type            csh_transaction.receipt_type%Type Default Null,
                                   p_csh_bp_name             csh_transaction.csh_bp_name%Type Default Null,
                                   p_ref_n01                 Number,
                                   p_lease_channel           csh_transaction.lease_channel%Type Default Null,
                                   p_guangsan_flag           csh_transaction.guangsan_flag%Type Default Null,
                                   -- modified by Liyuan
                                   p_fee_type csh_transaction.fee_type%Type Default Null) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    v_transaction_num     csh_transaction.transaction_num%Type;
  
    e_trx_num_error Exception;
    v_csh_transaction_id Number;
  Begin
    Select csh_transaction_s.nextval Into v_csh_transaction_id From dual;
    v_csh_transaction_rec.transaction_id := v_csh_transaction_id;
    If p_transaction_num Is Null Then
      v_transaction_num := get_csh_transaction_num(p_transaction_type => p_transaction_type,
                                                   p_company_id       => p_company_id,
                                                   p_transaction_date => p_transaction_date,
                                                   p_user_id          => p_user_id);
    Else
      v_transaction_num := p_transaction_num;
    End If;
  
    --addby wuts
    If p_lease_channel = '01' Then
      check_desripction_single(p_description => p_description,
                               p_user_id     => p_user_id);
    End If;
    --end
    v_csh_transaction_rec.transaction_num         := v_transaction_num;
    v_csh_transaction_rec.transaction_category    := p_transaction_category;
    v_csh_transaction_rec.transaction_type        := p_transaction_type;
    v_csh_transaction_rec.transaction_date        := p_transaction_date;
    v_csh_transaction_rec.penalty_calc_date       := p_penalty_calc_date;
    v_csh_transaction_rec.bank_slip_num           := p_bank_slip_num;
    v_csh_transaction_rec.company_id              := p_company_id;
    v_csh_transaction_rec.internal_period_num     := p_internal_period_num;
    v_csh_transaction_rec.period_name             := p_period_name;
    v_csh_transaction_rec.payment_method_id       := p_payment_method_id;
    v_csh_transaction_rec.distribution_set_id     := p_distribution_set_id;
    v_csh_transaction_rec.cashflow_amount         := p_cashflow_amount;
    v_csh_transaction_rec.currency_code           := p_currency_code;
    v_csh_transaction_rec.transaction_amount      := p_transaction_amount;
    v_csh_transaction_rec.exchange_rate_type      := p_exchange_rate_type;
    v_csh_transaction_rec.exchange_rate_quotation := p_exchange_rate_quotation;
    v_csh_transaction_rec.exchange_rate           := p_exchange_rate;
    v_csh_transaction_rec.bank_account_id         := p_bank_account_id;
    v_csh_transaction_rec.bp_category             := p_bp_category;
    v_csh_transaction_rec.bp_id                   := p_bp_id;
    v_csh_transaction_rec.bp_bank_account_id      := p_bp_bank_account_id;
    v_csh_transaction_rec.bp_bank_account_num     := p_bp_bank_account_num;
    v_csh_transaction_rec.bp_bank_account_name    := p_bp_bank_account_name;
    v_csh_transaction_rec.description             := p_description;
    v_csh_transaction_rec.handling_charge         := p_handling_charge;
    v_csh_transaction_rec.posted_flag             := 'N';
    v_csh_transaction_rec.reversed_flag           := nvl(p_reversed_flag,
                                                         csh_transaction_pkg.csh_trx_reversed_flag_n);
    v_csh_transaction_rec.reversed_date           := p_reversed_date;
    v_csh_transaction_rec.returned_flag           := nvl(p_returned_flag,
                                                         csh_transaction_pkg.csh_trx_return_flag_n);
    v_csh_transaction_rec.returned_amount         := p_returned_amount;
    v_csh_transaction_rec.write_off_flag          := nvl(p_write_off_flag,
                                                         csh_transaction_pkg.csh_trx_write_off_flag_n);
    v_csh_transaction_rec.write_off_amount        := p_write_off_amount;
    v_csh_transaction_rec.full_write_off_date     := p_full_write_off_date;
    v_csh_transaction_rec.twin_csh_trx_id         := p_twin_csh_trx_id;
    v_csh_transaction_rec.return_from_csh_trx_id  := p_return_from_csh_trx_id;
    v_csh_transaction_rec.reversed_csh_trx_id     := p_reversed_csh_trx_id;
    v_csh_transaction_rec.source_csh_trx_type     := p_source_csh_trx_type;
    v_csh_transaction_rec.source_doc_category     := p_source_doc_category;
    v_csh_transaction_rec.source_csh_trx_id       := p_source_csh_trx_id;
    v_csh_transaction_rec.source_doc_type         := p_source_doc_type;
    v_csh_transaction_rec.source_doc_id           := p_source_doc_id;
    v_csh_transaction_rec.source_doc_line_id      := p_source_doc_line_id;
    v_csh_transaction_rec.create_je_mothed        := p_create_je_mothed;
    v_csh_transaction_rec.create_je_flag          := nvl(p_create_je_flag,
                                                         'N');
    v_csh_transaction_rec.gld_interface_flag      := nvl(p_gld_interface_flag,
                                                         'N');
    v_csh_transaction_rec.creation_date           := Sysdate;
    v_csh_transaction_rec.created_by              := p_user_id;
    v_csh_transaction_rec.last_update_date        := Sysdate;
    v_csh_transaction_rec.last_updated_by         := p_user_id;
    v_csh_transaction_rec.csh_bp_name             := p_csh_bp_name;
    -- add by Liyuan 
    v_csh_transaction_rec.receipt_type := p_receipt_type;
    /*add by xuls for ref_contract_id 2014-9-26
     用于增加记录收款合同号
    */
    v_csh_transaction_rec.ref_contract_id := p_ref_contract_id;
    v_csh_transaction_rec.ref_n01         := p_ref_n01;
    --add by wuts  2019-1-2
    v_csh_transaction_rec.lease_channel := p_lease_channel;
    v_csh_transaction_rec.guangsan_flag := p_guangsan_flag;
    -- add by Liyuan
    v_csh_transaction_rec.fee_type := p_fee_type;
  
    insert_csh_transaction(v_csh_transaction_rec);
  
    check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec,
                      p_user_id             => p_user_id);
  
    --针对界面保存并过账按钮处理
    If nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
       csh_transaction_pkg.csh_trx_posted_flag_yes Then
      hls_sys_log_pkg.log('post insert');
      post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
                           p_user_id        => p_user_id);
    End If;
    p_transaction_id := v_csh_transaction_rec.transaction_id;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'insert_csh_transaction');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  /*add by xuls for ref_contract_id 2014-9-26
   用于增加记录收款合同号
  */
  Procedure update_csh_transaction(p_transaction_id          csh_transaction.transaction_id%Type,
                                   p_transaction_num         csh_transaction.transaction_num%Type,
                                   p_transaction_category    csh_transaction.transaction_category%Type,
                                   p_transaction_type        csh_transaction.transaction_type%Type,
                                   p_transaction_date        csh_transaction.transaction_date%Type,
                                   p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                   p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                   p_company_id              csh_transaction.company_id%Type,
                                   p_internal_period_num     csh_transaction.internal_period_num%Type,
                                   p_period_name             csh_transaction.period_name%Type,
                                   p_payment_method_id       csh_transaction.payment_method_id%Type,
                                   p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                   p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                   p_currency_code           csh_transaction.currency_code%Type,
                                   p_transaction_amount      csh_transaction.transaction_amount%Type,
                                   p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                   p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                   p_exchange_rate           csh_transaction.exchange_rate%Type,
                                   p_bank_account_id         csh_transaction.bank_account_id%Type,
                                   p_bp_category             csh_transaction.bp_category%Type,
                                   p_bp_id                   csh_transaction.bp_id%Type,
                                   p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                   p_description             csh_transaction.description%Type,
                                   p_handling_charge         csh_transaction.handling_charge%Type,
                                   p_posted_flag             csh_transaction.posted_flag%Type,
                                   p_reversed_flag           csh_transaction.reversed_flag%Type,
                                   p_reversed_date           csh_transaction.reversed_date%Type,
                                   p_returned_flag           csh_transaction.returned_flag%Type,
                                   p_returned_amount         csh_transaction.returned_amount%Type,
                                   p_write_off_flag          csh_transaction.write_off_flag%Type,
                                   p_write_off_amount        csh_transaction.write_off_amount%Type,
                                   p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                   p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                   p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                   p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                   p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                   p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                   p_source_doc_category     csh_transaction.source_doc_category%Type,
                                   p_source_doc_type         csh_transaction.source_doc_type%Type,
                                   p_source_doc_id           csh_transaction.source_doc_id%Type,
                                   p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                   p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                   p_create_je_flag          csh_transaction.create_je_flag%Type,
                                   p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                   p_user_id                 csh_transaction.created_by%Type,
                                   p_ref_contract_id         csh_transaction.ref_contract_id%Type Default Null,
                                   p_ref_n01                 Number Default Null,
                                   p_lease_channel           csh_transaction.lease_channel%Type Default Null,
                                   p_guangsan_flag           csh_transaction.guangsan_flag%Type Default Null,
                                   -- modified by Liyuan 
                                   p_fee_type csh_transaction.fee_type%Type Default Null) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    e_status_error           Exception;
    e_transaction_type_error Exception;
  Begin
  
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    If Not is_trx_update(v_csh_transaction_rec) Then
      Raise e_status_error;
    End If;
  
    If v_csh_transaction_rec.transaction_type <>
       csh_transaction_pkg.csh_trx_type_receipt Then
      Raise e_transaction_type_error;
    End If;
  
    --addby wuts
    If p_lease_channel = '01' Then
      check_desripction_single(p_description => p_description,
                               p_user_id     => p_user_id);
    End If;
    --end
    v_csh_transaction_rec.transaction_amount := p_transaction_amount;
    v_csh_transaction_rec.bank_account_id    := p_bank_account_id;
  
    check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec,
                      p_user_id             => p_user_id);
  
    Update csh_transaction t1
       Set t1.transaction_category    = p_transaction_category,
           t1.transaction_type        = p_transaction_type,
           t1.transaction_date        = p_transaction_date,
           t1.penalty_calc_date       = p_penalty_calc_date,
           t1.bank_slip_num           = p_bank_slip_num,
           t1.company_id              = p_company_id,
           t1.internal_period_num     = p_internal_period_num,
           t1.period_name             = p_period_name,
           t1.payment_method_id       = p_payment_method_id,
           t1.distribution_set_id     = p_distribution_set_id,
           t1.cashflow_amount         = p_cashflow_amount,
           t1.currency_code           = p_currency_code,
           t1.transaction_amount      = p_transaction_amount,
           t1.exchange_rate_type      = p_exchange_rate_type,
           t1.exchange_rate_quotation = p_exchange_rate_quotation,
           t1.exchange_rate           = p_exchange_rate,
           t1.bank_account_id         = p_bank_account_id,
           t1.bp_category             = p_bp_category,
           t1.bp_id                   = p_bp_id,
           t1.bp_bank_account_id      = p_bp_bank_account_id,
           t1.bp_bank_account_num     = p_bp_bank_account_num,
           t1.description             = p_description,
           t1.handling_charge         = p_handling_charge,
           t1.posted_flag             = csh_transaction_pkg.csh_trx_posted_flag_no,
           t1.reversed_flag           = nvl(p_reversed_flag,
                                            csh_transaction_pkg.csh_trx_reversed_flag_n),
           t1.reversed_date           = p_reversed_date,
           t1.returned_flag           = nvl(p_returned_flag,
                                            csh_transaction_pkg.csh_trx_return_flag_n),
           t1.returned_amount         = p_returned_amount,
           t1.write_off_flag          = nvl(p_write_off_flag,
                                            csh_transaction_pkg.csh_trx_write_off_flag_n),
           t1.write_off_amount        = p_write_off_amount,
           t1.full_write_off_date     = p_full_write_off_date,
           t1.twin_csh_trx_id         = p_twin_csh_trx_id,
           t1.return_from_csh_trx_id  = p_return_from_csh_trx_id,
           t1.reversed_csh_trx_id     = p_reversed_csh_trx_id,
           t1.source_csh_trx_type     = p_source_csh_trx_type,
           t1.source_csh_trx_id       = p_source_csh_trx_id,
           t1.source_doc_category     = p_source_doc_category,
           t1.source_doc_type         = p_source_doc_type,
           t1.source_doc_id           = p_source_doc_id,
           t1.source_doc_line_id      = p_source_doc_line_id,
           t1.create_je_mothed        = p_create_je_mothed,
           t1.create_je_flag          = nvl(p_create_je_flag, 'N'),
           t1.gld_interface_flag      = nvl(p_gld_interface_flag, 'N'),
           t1.last_update_date        = Sysdate,
           t1.last_updated_by         = p_user_id,
           t1.ref_contract_id         = p_ref_contract_id,
           t1.ref_n01                 = p_ref_n01,
           t1.lease_channel           = p_lease_channel,
           t1.guangsan_flag           = p_guangsan_flag,
           -- modified by Liyuan
           t1.fee_type = p_fee_type
     Where t1.transaction_id = p_transaction_id;
    --针对界面保存并过账按钮处理
    If nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
       csh_transaction_pkg.csh_trx_posted_flag_yes Then
      hls_sys_log_pkg.log('post update');
      post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
                           p_user_id        => p_user_id);
    End If;
  Exception
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_UPDATE_STATUS_CHECK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_transaction_type_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_TRANSACTION_TYPE_CHECK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'update_csh_transaction');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --货币兑换维护
  Procedure update_currency_exchange_trx(p_transaction_id          csh_transaction.transaction_id%Type,
                                         p_transaction_num         csh_transaction.transaction_num%Type,
                                         p_transaction_category    csh_transaction.transaction_category%Type,
                                         p_transaction_type        csh_transaction.transaction_type%Type,
                                         p_transaction_date        csh_transaction.transaction_date%Type,
                                         p_penalty_calc_date       csh_transaction.penalty_calc_date%Type,
                                         p_bank_slip_num           csh_transaction.bank_slip_num%Type,
                                         p_company_id              csh_transaction.company_id%Type,
                                         p_internal_period_num     csh_transaction.internal_period_num%Type,
                                         p_period_name             csh_transaction.period_name%Type,
                                         p_payment_method_id       csh_transaction.payment_method_id%Type,
                                         p_distribution_set_id     csh_transaction.distribution_set_id%Type,
                                         p_cashflow_amount         csh_transaction.cashflow_amount%Type,
                                         p_currency_code           csh_transaction.currency_code%Type,
                                         p_transaction_amount      csh_transaction.transaction_amount%Type,
                                         p_exchange_rate_type      csh_transaction.exchange_rate_type%Type,
                                         p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%Type,
                                         p_exchange_rate           csh_transaction.exchange_rate%Type,
                                         p_bank_account_id         csh_transaction.bank_account_id%Type,
                                         p_bp_category             csh_transaction.bp_category%Type,
                                         p_bp_id                   csh_transaction.bp_id%Type,
                                         p_bp_bank_account_id      csh_transaction.bp_bank_account_id%Type,
                                         p_bp_bank_account_num     csh_transaction.bp_bank_account_num%Type,
                                         p_description             csh_transaction.description%Type,
                                         p_handling_charge         csh_transaction.handling_charge%Type,
                                         p_posted_flag             csh_transaction.posted_flag%Type,
                                         p_reversed_flag           csh_transaction.reversed_flag%Type,
                                         p_reversed_date           csh_transaction.reversed_date%Type,
                                         p_returned_flag           csh_transaction.returned_flag%Type,
                                         p_returned_amount         csh_transaction.returned_amount%Type,
                                         p_write_off_flag          csh_transaction.write_off_flag%Type,
                                         p_write_off_amount        csh_transaction.write_off_amount%Type,
                                         p_full_write_off_date     csh_transaction.full_write_off_date%Type,
                                         p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%Type,
                                         p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%Type,
                                         p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%Type,
                                         p_source_csh_trx_type     csh_transaction.source_csh_trx_type%Type,
                                         p_source_csh_trx_id       csh_transaction.source_csh_trx_id%Type,
                                         p_source_doc_category     csh_transaction.source_doc_category%Type,
                                         p_source_doc_type         csh_transaction.source_doc_type%Type,
                                         p_source_doc_id           csh_transaction.source_doc_id%Type,
                                         p_source_doc_line_id      csh_transaction.source_doc_line_id%Type,
                                         p_create_je_mothed        csh_transaction.create_je_mothed%Type,
                                         p_create_je_flag          csh_transaction.create_je_flag%Type,
                                         p_gld_interface_flag      csh_transaction.gld_interface_flag%Type,
                                         p_user_id                 csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    e_status_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    If Not is_trx_update(v_csh_transaction_rec) Then
      Raise e_status_error;
    End If;
  
    v_csh_transaction_rec.transaction_amount := p_transaction_amount;
    v_csh_transaction_rec.bank_account_id    := p_bank_account_id;
  
    check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec,
                      p_user_id             => p_user_id);
  
    Update csh_transaction t1
       Set t1.transaction_category    = p_transaction_category,
           t1.transaction_type        = p_transaction_type,
           t1.transaction_date        = p_transaction_date,
           t1.penalty_calc_date       = p_penalty_calc_date,
           t1.bank_slip_num           = p_bank_slip_num,
           t1.company_id              = p_company_id,
           t1.internal_period_num     = p_internal_period_num,
           t1.period_name             = p_period_name,
           t1.payment_method_id       = p_payment_method_id,
           t1.distribution_set_id     = p_distribution_set_id,
           t1.cashflow_amount         = p_cashflow_amount,
           t1.currency_code           = p_currency_code,
           t1.transaction_amount      = p_transaction_amount,
           t1.exchange_rate_type      = p_exchange_rate_type,
           t1.exchange_rate_quotation = p_exchange_rate_quotation,
           t1.exchange_rate           = p_exchange_rate,
           t1.bank_account_id         = p_bank_account_id,
           t1.bp_category             = p_bp_category,
           t1.bp_id                   = p_bp_id,
           t1.bp_bank_account_id      = p_bp_bank_account_id,
           t1.bp_bank_account_num     = p_bp_bank_account_num,
           t1.description             = p_description,
           t1.handling_charge         = p_handling_charge,
           t1.posted_flag             = csh_transaction_pkg.csh_trx_posted_flag_no,
           t1.reversed_flag           = nvl(p_reversed_flag,
                                            csh_transaction_pkg.csh_trx_reversed_flag_n),
           t1.reversed_date           = p_reversed_date,
           t1.returned_flag           = nvl(p_returned_flag,
                                            csh_transaction_pkg.csh_trx_return_flag_n),
           t1.returned_amount         = p_returned_amount,
           t1.write_off_flag          = nvl(p_write_off_flag,
                                            csh_transaction_pkg.csh_trx_write_off_flag_n),
           t1.write_off_amount        = p_write_off_amount,
           t1.full_write_off_date     = p_full_write_off_date,
           t1.twin_csh_trx_id         = p_twin_csh_trx_id,
           t1.return_from_csh_trx_id  = p_return_from_csh_trx_id,
           t1.reversed_csh_trx_id     = p_reversed_csh_trx_id,
           t1.source_csh_trx_type     = p_source_csh_trx_type,
           t1.source_csh_trx_id       = p_source_csh_trx_id,
           t1.source_doc_category     = p_source_doc_category,
           t1.source_doc_type         = p_source_doc_type,
           t1.source_doc_id           = p_source_doc_id,
           t1.source_doc_line_id      = p_source_doc_line_id,
           t1.create_je_mothed        = p_create_je_mothed,
           t1.create_je_flag          = nvl(p_create_je_flag, 'N'),
           t1.gld_interface_flag      = nvl(p_gld_interface_flag, 'N'),
           t1.last_update_date        = Sysdate,
           t1.last_updated_by         = p_user_id
     Where t1.transaction_id = p_transaction_id;
    --针对界面保存并过账按钮处理
    If nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
       csh_transaction_pkg.csh_trx_posted_flag_yes Then
    
      post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
                           p_user_id        => p_user_id);
    End If;
  Exception
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_UPDATE_STATUS_CHECK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_currency_exchange_trx');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'update_currency_exchange_trx');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --货币兑换互记TWIN_CSH_TRX_ID
  Procedure save_twin_csh_trx_id(p_transaction_num csh_transaction.transaction_num%Type,
                                 p_user_id         Number) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  Begin
    For r_trx_rec In (Select d.transaction_id
                        From csh_transaction d
                       Where d.transaction_num = p_transaction_num) Loop
      lock_csh_transaction(p_transaction_id      => r_trx_rec.transaction_id,
                           p_user_id             => p_user_id,
                           p_csh_transaction_rec => v_csh_transaction_rec);
      Update csh_transaction c
         Set c.twin_csh_trx_id  = r_trx_rec.transaction_id,
             c.last_updated_by  = p_user_id,
             c.last_update_date = Sysdate
       Where c.transaction_num = p_transaction_num
         And c.transaction_id <> r_trx_rec.transaction_id;
    End Loop;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'save_twin_csh_trx_id');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --货币兑换过账以后维护
  Procedure upd_currency_trx_after_post(p_transaction_id csh_transaction.transaction_id%Type,
                                        p_bank_slip_num  csh_transaction.bank_slip_num%Type,
                                        p_description    csh_transaction.description%Type,
                                        p_user_id        csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
    e_flag_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    If Not is_trx_update_after_post(v_csh_transaction_rec) Then
      Raise e_flag_error;
    End If;
  
    Update csh_transaction t
       Set t.bank_slip_num    = p_bank_slip_num,
           t.description      = p_description,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = p_transaction_id;
  Exception
    When e_flag_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'upd_currency_trx_after_post');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'upd_currency_trx_after_post');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  --过账以后维护
  Procedure update_csh_transaction_post(p_transaction_id     csh_transaction.transaction_id%Type,
                                        p_bank_slip_num      csh_transaction.bank_slip_num%Type,
                                        p_bp_bank_account_id csh_transaction.bp_bank_account_id%Type,
                                        p_user_id            csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_flag_error Exception;
  Begin
  
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    /*IF NOT is_trx_update_after_post(v_csh_transaction_rec) THEN
      RAISE e_flag_error;
    END IF;*/
  
    Update csh_transaction t
       Set t.bank_slip_num      = p_bank_slip_num,
           t.bp_bank_account_id = p_bp_bank_account_id,
           t.last_update_date   = Sysdate,
           t.last_updated_by    = p_user_id
     Where t.transaction_id = p_transaction_id;
  
  Exception
    When e_flag_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'update_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'update_csh_transaction_post');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure update_csh_post_flag(p_transaction_id Number,
                                 p_user_id        Number,
                                 p_claim          Varchar2 Default Null) Is
  Begin
    /*update csh_transaction ct
      set ct.posted_flag = 'Y', ct.last_updated_by = p_user_id
    where ct.transaction_id = p_transaction_id;*/
    If p_claim Is Null Then
      Update csh_transaction ct
         Set ct.posted_flag = 'Y', ct.last_updated_by = p_user_id
       Where ct.transaction_id = p_transaction_id;
    Elsif p_claim = 'F' Then
      Update csh_transaction ct
         Set ct.posted_flag = 'F', ct.last_updated_by = p_user_id
       Where ct.transaction_id = p_transaction_id;
    Elsif p_claim = 'Y' Then
      Update csh_transaction ct
         Set ct.posted_flag = 'Y', ct.last_updated_by = p_user_id
       Where ct.transaction_id = p_transaction_id;
    End If;
  End;

  Procedure delete_csh_transaction(p_transaction_id csh_transaction.transaction_id%Type,
                                   p_user_id        csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_status_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    If Not is_trx_delete(v_csh_transaction_rec) Then
      Raise e_status_error;
    End If;
  
    Delete From csh_transaction t
     Where t.transaction_id = p_transaction_id;
  
  Exception
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'delete_status_check',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'delete_csh_transaction');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  Procedure post_csh_transaction(p_transaction_id csh_transaction.transaction_id%Type,
                                 p_user_id        csh_transaction.created_by%Type) Is
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_status_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
    hls_sys_log_pkg.log('post check:' || p_transaction_id);
    If Not is_trx_post(v_csh_transaction_rec) Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH510_POSTED_ERROR';
      Raise e_status_error;
    End If;
    Update csh_transaction t
       Set t.posted_flag      = csh_transaction_pkg.csh_trx_posted_flag_yes,
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.transaction_id = v_csh_transaction_rec.transaction_id;
    --现金事务过账生成的凭证
    csh_transaction_je_pkg.create_transaction_je(p_transaction_id => p_transaction_id,
                                                 p_user_id        => p_user_id);
  
    csh_transaction_custom_pkg.after_post_trx(p_transaction_id => p_transaction_id,
                                              p_user_id        => p_user_id);
  Exception
    When e_status_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'post_csh_transaction',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --通用的反冲入口（收款反冲，付款反冲,收款退款反冲，预收款退款反冲）
  Procedure reverse_csh_transaction(p_transaction_id         csh_transaction.transaction_id%Type,
                                    p_reversed_date          csh_transaction.reversed_date%Type,
                                    p_description            csh_transaction.description%Type,
                                    p_user_id                csh_transaction.created_by%Type,
                                    p_reverse_transaction_id Out csh_transaction.transaction_id%Type) Is
  
    v_period_name         Varchar2(30);
    v_transaction_id      Number;
    v_write_off_id        Number;
    v_internal_period_num gld_periods.internal_period_num%Type;
  
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_reverse_error Exception;
  Begin
  
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    If Not is_trx_reverse(v_csh_transaction_rec) Then
      Raise e_reverse_error;
    End If;
  
    --校验反冲日期
    If p_reversed_date < v_csh_transaction_rec.transaction_date Then
      v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_DATE_ERROR';
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
    --预收款和收款的退款反冲
    If v_csh_transaction_rec.transaction_category =
       csh_trx_category_business And
       (v_csh_transaction_rec.transaction_type = csh_trx_type_prereceipt Or
       nvl(v_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) =
       csh_trx_return_flag_return) Then
      --退款反冲后更新原退款现金事务信息
      If v_csh_transaction_rec.returned_flag = csh_trx_return_flag_return Then
        upd_rtn_csh_trx_after_reverse(p_transaction_id => p_transaction_id,
                                      p_user_id        => p_user_id);
      End If;
      For csh_write_off_rec In (Select *
                                  From csh_write_off t
                                 Where t.subsequent_csh_trx_id =
                                       p_transaction_id
                                   And nvl(t.reversed_flag,
                                           csh_trx_reversed_flag_n) =
                                       csh_trx_reversed_flag_n) Loop
        csh_write_off_pkg.reverse_write_off(p_reverse_write_off_id => v_write_off_id,
                                            p_write_off_id         => csh_write_off_rec.write_off_id,
                                            p_reversed_date        => p_reversed_date,
                                            p_description          => p_description,
                                            p_user_id              => p_user_id,
                                            p_from_csh_trx_flag    => 'Y');
      End Loop;
      --付款反冲中的支付反冲
    Elsif v_csh_transaction_rec.transaction_category =
          csh_trx_category_business And
          v_csh_transaction_rec.transaction_type = csh_trx_type_payment Then
      --更新付款申请
      --modify by zhangdan 86140
      /*For csh_trans_rec In (Select cp.payment_req_ln_id, ct.transaction_id
                              From csh_payment_req_ln cp,
                                   csh_payment_req_hd h,
                                   csh_transaction    ct
                             Where cp.payment_req_id = h.payment_req_id
                               And h.payment_req_id = ct.source_doc_id
                               And ct.transaction_id = p_transaction_id) Loop
        csh_payment_req_pkg.upd_csh_payment_after_reverse(p_transaction_id    => csh_trans_rec.transaction_id,
                                                          p_payment_req_ln_id => csh_trans_rec.payment_req_ln_id,
                                                          p_user_id           => p_user_id);
      End Loop;*/
      csh_payment_req_pkg.upd_csh_payment_after_reverse(p_transaction_id    => p_transaction_id,
                                                        p_payment_req_ln_id => Null,
                                                        p_user_id           => p_user_id);
      For csh_write_off_rec In (Select *
                                  From csh_write_off t
                                 Where t.csh_transaction_id =
                                       p_transaction_id
                                   And nvl(t.reversed_flag,
                                           csh_trx_reversed_flag_n) =
                                       csh_trx_reversed_flag_n) Loop
        csh_write_off_pkg.reverse_write_off(p_reverse_write_off_id => v_write_off_id,
                                            p_write_off_id         => csh_write_off_rec.write_off_id,
                                            p_reversed_date        => p_reversed_date,
                                            p_description          => p_description,
                                            p_user_id              => p_user_id,
                                            p_from_csh_trx_flag    => 'Y');
        If csh_write_off_rec.cf_item = '300' Then
          --反冲 保理融资额 更改 合同状态为 草稿  modify by  wuts 2019-1-11    
          Update con_Contract
             Set contract_status    = 'NEW',
                 INCEPTION_OF_LEASE = '',
                 lease_start_date   = '',
                 lease_end_date     = ''
           Where contract_id = csh_write_off_rec.contract_id;
          --  删除管理费      modify by wuts 2019-1-15
          Delete Con_Contract_Cashflow
           Where contract_id = csh_write_off_rec.contract_id
             And cf_item = 301
             And nvl(write_off_flag, 'NOT') = 'NOT';
        End If;
      End Loop;
    Elsif v_csh_transaction_rec.transaction_category =
          csh_trx_category_business And
          v_csh_transaction_rec.transaction_type = csh_trx_type_deduction Then
    
      For csh_write_off_rec In (Select *
                                  From csh_write_off t
                                 Where t.csh_transaction_id =
                                       p_transaction_id
                                   And nvl(t.reversed_flag,
                                           csh_trx_reversed_flag_n) =
                                       csh_trx_reversed_flag_n) Loop
        csh_write_off_pkg.reverse_write_off(p_reverse_write_off_id => v_write_off_id,
                                            p_write_off_id         => csh_write_off_rec.write_off_id,
                                            p_reversed_date        => p_reversed_date,
                                            p_description          => p_description,
                                            p_user_id              => p_user_id,
                                            p_from_csh_trx_flag    => 'Y');
      End Loop;
    End If;
  
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    insert_csh_transaction(p_transaction_id          => v_transaction_id,
                           p_transaction_num         => '',
                           p_transaction_category    => v_csh_transaction_rec.transaction_category,
                           p_transaction_type        => v_csh_transaction_rec.transaction_type,
                           p_transaction_date        => p_reversed_date,
                           p_penalty_calc_date       => v_csh_transaction_rec.penalty_calc_date,
                           p_bank_slip_num           => v_csh_transaction_rec.bank_slip_num,
                           p_company_id              => v_csh_transaction_rec.company_id,
                           p_internal_period_num     => v_internal_period_num,
                           p_period_name             => v_period_name,
                           p_payment_method_id       => v_csh_transaction_rec.payment_method_id,
                           p_distribution_set_id     => v_csh_transaction_rec.distribution_set_id,
                           p_cashflow_amount         => -1 *
                                                        v_csh_transaction_rec.cashflow_amount,
                           p_currency_code           => v_csh_transaction_rec.currency_code,
                           p_transaction_amount      => -1 *
                                                        v_csh_transaction_rec.transaction_amount,
                           p_exchange_rate_type      => v_csh_transaction_rec.exchange_rate_type,
                           p_exchange_rate_quotation => v_csh_transaction_rec.exchange_rate_quotation,
                           p_exchange_rate           => v_csh_transaction_rec.exchange_rate,
                           p_bank_account_id         => v_csh_transaction_rec.bank_account_id,
                           p_bp_category             => v_csh_transaction_rec.bp_category,
                           p_bp_id                   => v_csh_transaction_rec.bp_id,
                           p_bp_bank_account_id      => v_csh_transaction_rec.bp_bank_account_id,
                           p_bp_bank_account_num     => v_csh_transaction_rec.bp_bank_account_num,
                           p_description             => p_description,
                           p_handling_charge         => v_csh_transaction_rec.handling_charge,
                           p_posted_flag             => csh_transaction_pkg.csh_trx_posted_flag_yes,
                           p_reversed_flag           => csh_transaction_pkg.csh_trx_reversed_flag_r,
                           p_reversed_date           => '',
                           p_returned_flag           => v_csh_transaction_rec.returned_flag,
                           p_returned_amount         => v_csh_transaction_rec.returned_amount,
                           p_write_off_flag          => v_csh_transaction_rec.write_off_flag,
                           p_write_off_amount        => v_csh_transaction_rec.write_off_amount,
                           p_full_write_off_date     => v_csh_transaction_rec.full_write_off_date,
                           p_twin_csh_trx_id         => v_csh_transaction_rec.twin_csh_trx_id,
                           p_return_from_csh_trx_id  => v_csh_transaction_rec.return_from_csh_trx_id,
                           p_reversed_csh_trx_id     => p_transaction_id,
                           p_source_csh_trx_type     => v_csh_transaction_rec.source_csh_trx_type,
                           p_source_csh_trx_id       => v_csh_transaction_rec.source_csh_trx_id,
                           p_source_doc_category     => v_csh_transaction_rec.source_doc_category,
                           p_source_doc_type         => v_csh_transaction_rec.source_doc_type,
                           p_source_doc_id           => v_csh_transaction_rec.source_doc_id,
                           p_source_doc_line_id      => v_csh_transaction_rec.source_doc_line_id,
                           p_create_je_mothed        => v_csh_transaction_rec.create_je_mothed,
                           p_create_je_flag          => 'N',
                           p_gld_interface_flag      => 'N',
                           p_user_id                 => p_user_id,
                           p_csh_bp_name             => v_csh_transaction_rec.csh_bp_name);
    --更新被反冲现金事务
    update_csh_trx_after_reverse(p_transaction_id      => p_transaction_id,
                                 p_reversed_date       => p_reversed_date,
                                 p_reserved_csh_trx_id => v_transaction_id,
                                 p_user_id             => p_user_id);
    --生成现金事务的过账反冲凭证
    csh_transaction_je_pkg.create_transaction_reverse_je(p_transaction_id => v_transaction_id,
                                                         p_user_id        => p_user_id);
    p_reverse_transaction_id := v_transaction_id;
  Exception
    When e_reverse_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'reverse_csh_transaction',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'reverse_csh_transaction');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --收款反冲入口
  Procedure reverse_receipt_csh_trx(p_transaction_id csh_transaction.transaction_id%Type,
                                    p_reversed_date  csh_transaction.reversed_date%Type,
                                    p_bank_slip_num  csh_transaction.bank_slip_num%Type,
                                    p_description    csh_transaction.description%Type,
                                    p_user_id        csh_transaction.created_by%Type) Is
    e_reverse_error Exception;
    v_csh_transaction_rec csh_transaction%Rowtype;
    v_transaction_id      csh_transaction.transaction_id%Type;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    reverse_csh_transaction(p_transaction_id         => p_transaction_id,
                            p_reversed_date          => p_reversed_date,
                            p_description            => p_description,
                            p_user_id                => p_user_id,
                            p_reverse_transaction_id => v_transaction_id);
    --更新银行水单
    update_bank_slip_num(p_transaction_id => v_transaction_id,
                         p_bank_slip_num  => p_bank_slip_num,
                         p_user_id        => p_user_id);
  
    -- 反冲回来 过账标志变为N
    Update CSH_TRANSACTION ct
       Set ct.posted_flag = 'N', ct.reversed_flag = 'N'
     Where ct.transaction_id = p_transaction_id;
  
  Exception
    When e_reverse_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'reverse_receipt_csh_trx',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'reverse_receipt_csh_trx');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;
  --收款退款入口
  Procedure return_csh_transaction(p_transaction_id      csh_transaction.transaction_id%Type,
                                   p_returned_date       Date,
                                   p_returned_amount     csh_transaction.returned_amount%Type,
                                   p_bank_slip_num       csh_transaction.bank_slip_num%Type,
                                   p_payment_method_id   csh_transaction.payment_method_id%Type,
                                   p_bank_account_id     csh_transaction.bank_account_id%Type,
                                   p_bp_bank_account_id  csh_transaction.bp_bank_account_id%Type,
                                   p_bp_bank_account_num csh_transaction.bp_bank_account_num%Type,
                                   p_description         csh_transaction.description%Type,
                                   p_user_id             csh_transaction.created_by%Type) Is
    v_period_name         Varchar2(30);
    v_transaction_id      Number;
    v_write_off_id        Number;
    v_internal_period_num gld_periods.internal_period_num%Type;
  
    v_csh_transaction_rec csh_transaction%Rowtype;
  
    e_return_error Exception;
  Begin
    lock_csh_transaction(p_transaction_id      => p_transaction_id,
                         p_user_id             => p_user_id,
                         p_csh_transaction_rec => v_csh_transaction_rec);
  
    If Not csh_transaction_pkg.is_trx_return(v_csh_transaction_rec) Then
      v_err_code := 'CSH_TRANSACTION_PKG.CSH_TRX_RETURN_FLAG_ERROR';
      Raise e_return_error;
    End If;
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
  
    insert_csh_transaction(p_transaction_id          => v_transaction_id,
                           p_transaction_num         => '',
                           p_transaction_category    => v_csh_transaction_rec.transaction_category,
                           p_transaction_type        => v_csh_transaction_rec.transaction_type,
                           p_transaction_date        => Sysdate,
                           p_penalty_calc_date       => '',
                           p_bank_slip_num           => p_bank_slip_num,
                           p_company_id              => v_csh_transaction_rec.company_id,
                           p_internal_period_num     => v_internal_period_num,
                           p_period_name             => v_period_name,
                           p_payment_method_id       => p_payment_method_id,
                           p_distribution_set_id     => v_csh_transaction_rec.distribution_set_id,
                           p_cashflow_amount         => -1 *
                                                        p_returned_amount,
                           p_currency_code           => v_csh_transaction_rec.currency_code,
                           p_transaction_amount      => p_returned_amount,
                           p_exchange_rate_type      => v_csh_transaction_rec.exchange_rate_type,
                           p_exchange_rate_quotation => v_csh_transaction_rec.exchange_rate_quotation,
                           p_exchange_rate           => v_csh_transaction_rec.exchange_rate,
                           p_bank_account_id         => p_bank_account_id,
                           p_bp_category             => v_csh_transaction_rec.bp_category,
                           p_bp_id                   => v_csh_transaction_rec.bp_id,
                           p_bp_bank_account_id      => p_bp_bank_account_id,
                           p_bp_bank_account_num     => p_bp_bank_account_num,
                           p_description             => p_description,
                           p_handling_charge         => '',
                           p_posted_flag             => csh_transaction_pkg.csh_trx_posted_flag_yes,
                           p_reversed_flag           => csh_transaction_pkg.csh_trx_reversed_flag_n,
                           p_reversed_date           => '',
                           p_returned_flag           => csh_transaction_pkg.csh_trx_return_flag_return,
                           p_returned_amount         => '',
                           p_write_off_flag          => csh_transaction_pkg.csh_trx_write_off_flag_f,
                           p_write_off_amount        => '',
                           p_full_write_off_date     => '',
                           p_twin_csh_trx_id         => '',
                           p_return_from_csh_trx_id  => p_transaction_id,
                           p_reversed_csh_trx_id     => '',
                           p_source_csh_trx_type     => v_csh_transaction_rec.transaction_type,
                           p_source_csh_trx_id       => p_transaction_id,
                           p_source_doc_category     => '',
                           p_source_doc_type         => '',
                           p_source_doc_id           => '',
                           p_source_doc_line_id      => '',
                           p_create_je_mothed        => '',
                           p_create_je_flag          => 'N',
                           p_gld_interface_flag      => 'N',
                           p_user_id                 => p_user_id,
                           p_csh_bp_name             => v_csh_transaction_rec.csh_bp_name);
    --更新被退款现金事务信息
    update_csh_trx_after_return(p_transaction_id  => p_transaction_id,
                                p_returned_amount => p_returned_amount,
                                p_user_id         => p_user_id);
    --收款、预收款的退款需要在核销表中插一条退款事务
    If v_csh_transaction_rec.transaction_type In
       (csh_trx_type_prereceipt, csh_trx_type_receipt, csh_trx_type_deposit) Then
    
      csh_write_off_pkg.return_write_off(p_return_write_off_id   => v_write_off_id,
                                         p_transaction_id        => p_transaction_id,
                                         p_return_transaction_id => v_transaction_id,
                                         p_returned_date         => p_returned_date,
                                         p_returned_amount       => p_returned_amount,
                                         p_description           => p_description,
                                         p_user_id               => p_user_id);
    End If;
  Exception
    When e_return_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_transaction_pkg',
                                                      p_procedure_function_name => 'return_csh_transaction',
                                                      p_token_1                 => '#TRANSACTION_NUM',
                                                      p_token_value_1           => v_csh_transaction_rec.transaction_num);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_transaction_pkg',
                                                     p_procedure_function_name => 'return_csh_transaction');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  ---add by zlf   2014/11/24

  Procedure delete_interface(p_batch_id Number, p_user_id Number) Is
  Begin
    Delete From csh_transaction_temp t Where t.batch_id = p_batch_id;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_TRANSACTION',
                                                     p_procedure_function_name => 'DELETE_INTERFACE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End delete_interface;

  Procedure insert_interface(p_header_id Number,
                             p_batch_id  Number,
                             p_user_id   Number) Is
    Cursor c_data Is
      Select *
        From fnd_interface_lines
       Where header_id = p_header_id
         And line_number >= 1;
  Begin
    For c_record In c_data Loop
    
      Insert Into csh_transaction_temp
        (batch_id,
         csh_transaction_temp_id,
         transaction_date,
         description,
         transaction_amount,
         bp_bank_account_num,
         bp_name,
         bank_account_num,
         bank_serial_num,
         sys_date,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      Values
        (p_batch_id,
         csh_transaction_temp_s.nextval,
         to_date(c_record.attribute_1, 'YYYY-MM-DD'),
         c_record.attribute_2,
         to_number(c_record.attribute_3),
         c_record.attribute_4,
         c_record.attribute_5,
         c_record.attribute_6,
         c_record.attribute_7,
         to_date(c_record.attribute_8, 'YYYY-MM-DD'),
         p_user_id,
         Sysdate,
         p_user_id,
         Sysdate);
    End Loop;
  End;

  Procedure delete_temp(p_batch_id Number) Is
  Begin
    --delete from fnd_interface_lines t where t.line_id = p_batch_id;
    Delete From csh_transaction_temp t
    
     Where t.batch_id = p_batch_id;
    Delete From csh_transaction_temp_logs;
  End delete_temp;

  Procedure delete_error_logs(p_batch_id Number) Is
  
  Begin
    Delete From csh_transaction_temp_logs a Where a.batch_id = p_batch_id;
  End delete_error_logs;

  Procedure txn_log(p_temp     In csh_transaction_temp%Rowtype,
                    p_log_text In Varchar2,
                    p_user_id  In Number) Is
  Begin
    Insert Into csh_transaction_temp_logs
      (batch_id,
       csh_transaction_temp_log_id,
       transaction_date,
       description,
       transaction_amount,
       bp_bank_account_num,
       bp_name,
       bank_account_num,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       log_text)
    Values
      (p_temp.batch_id,
       csh_transaction_temp_logs_s.nextval,
       p_temp.transaction_date,
       p_temp.description,
       p_temp.transaction_amount,
       p_temp.bp_bank_account_num,
       p_temp.bp_name,
       p_temp.bank_account_num,
       p_user_id,
       Sysdate,
       p_user_id,
       Sysdate,
       p_log_text);
  End txn_log;

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

  Procedure check_data(p_batch_id  Number,
                       p_user_id   Number,
                       p_return_id Out Number) Is
    v_bp_name_exist_flag         Varchar2(2) := 'N';
    v_bp_bank_account_exist_flag Varchar2(2) := 'N';
    v_bp_name_num                Number;
    v_column_num                 Number := 1;
    v_line_num                   Number := 2;
    v_log_text                   Varchar(500);
    e_bp_name_num_error          Exception;
    e_date_null_error            Exception;
    e_description_null_error     Exception;
    e_amount_null_error          Exception;
    e_bp_account_null_error      Exception;
    e_bank_serial_num_null_error Exception;
  Begin
    delete_error_logs(p_batch_id);
    p_return_id := 1;
    For c_record In (Select *
                       From csh_transaction_temp c
                      Where c.batch_id = p_batch_id) Loop
      Begin
        If c_record.transaction_date Is Null Then
          Raise e_date_null_error;
        End If;
      Exception
        When e_date_null_error Then
          p_return_id  := 0;
          v_column_num := 1;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,入账日期为空';
          txn_log(c_record, v_log_text, p_user_id);
      End;
      /*begin
        if c_record.description is null then
          raise e_description_null_error;
        end if;
      exception
        when e_description_null_error then
          p_return_id  := 0;
          v_column_num := 2;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,用途为空';
          txn_log(c_record, v_log_text, p_user_id);
      end;*/
      Begin
        If c_record.transaction_amount Is Null Then
          Raise e_amount_null_error;
        End If;
      Exception
        When e_amount_null_error Then
          p_return_id  := 0;
          v_column_num := 3;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,入账金额为空';
          txn_log(c_record, v_log_text, p_user_id);
      End;
      /*begin
        if c_record.bp_bank_account_num is null then
          raise e_bp_account_null_error;
        end if;
      exception
        when e_bp_account_null_error then
          p_return_id  := 0;
          v_column_num := 4;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,对方账户为空';
          txn_log(c_record, v_log_text, p_user_id);
      end;*/
      /*      begin
        select 'Y'
          into v_bp_name_exist_flag
          from dual
         where exists (select 1
                  from con_contract_lv v
                 where v.bp_id_tenant_n = c_record.bp_name
                   and v.data_class = 'NORMAL');
      exception
        when no_data_found then
          p_return_id  := 0;
          v_column_num := 5;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,对方户名在系统中不存在';
          txn_log(c_record, v_log_text, p_user_id);
      END;*/
    
      /*begin
        select count(1)
          into v_bp_name_num
          from con_contract_lv v
         where v.bp_id_tenant_n = c_record.bp_name
           and v.data_class = 'NORMAL';
        if v_bp_name_num > 1 then
          raise e_bp_name_num_error;
        end if;
      exception
        when e_bp_name_num_error then
          p_return_id  := 0;
          v_column_num := 5;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,对方户名在系统中存在多个';
          txn_log(c_record, v_log_text, p_user_id);
      end;*/
    
      Begin
        Select 'Y'
          Into v_bp_bank_account_exist_flag
          From dual
         Where Exists
         (Select 1
                  From csh_bank_account_v v
                 Where v.bank_account_num = c_record.bank_account_num);
      Exception
        When NO_DATA_FOUND Then
          p_return_id  := 0;
          v_column_num := 6;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,收款账号在系统中不存在';
          txn_log(c_record, v_log_text, p_user_id);
        
      End;
    
      --应黄蓉要求 银行流水号 为非必输
      /*BEGIN
        IF c_record.bank_serial_num IS NULL THEN
          RAISE e_bank_serial_num_null_error;
        END IF;
      EXCEPTION
        WHEN e_bank_serial_num_null_error THEN
          p_return_id  := 0;
          v_column_num := 7;
          v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num ||
                          '列,银行流水号为空';
          txn_log(c_record, v_log_text, p_user_id);
      END;*/
    
      v_line_num := v_line_num + 1;
    End Loop;
  End;

  /*PROCEDURE save_data
  (
    p_batch_id     NUMBER,
    p_user_id      NUMBER,
    p_company_id   NUMBER,
    v_save_message OUT VARCHAR2
  ) IS
    v_bp_id                     NUMBER;
    v_bank_account_id           NUMBER;
    v_transaction_id            NUMBER;
    v_transaction_num           VARCHAR2(30);
    v_period_name               VARCHAR2(30);
    v_internal_period_num       NUMBER;
    v_currency_code             VARCHAR2(30);
    v_bp_category               VARCHAR2(30);
    v_bp_bank_account_id        NUMBER;
    v_contract_num              NUMBER;
    v_cashflow_num              NUMBER;
    v_min_times                 NUMBER;
    v_session_id                NUMBER;
    v_con_contract_cashflow_rec con_contract_cashflow%ROWTYPE;
    v_contract_id               NUMBER;
    v_is_error                  BOOLEAN := FALSE;
    v_write_off_flag            VARCHAR2(30) := 'Y';
    e_null_contract_error     EXCEPTION;
    e_too_many_contract_error EXCEPTION;
    e_null_cashflow_error     EXCEPTION;
    v_contract_rec con_contract%ROWTYPE;
  BEGIN
    FOR c_record IN (SELECT * FROM csh_transaction_temp a WHERE a.batch_id = p_batch_id) LOOP
      -- check bp
      BEGIN
        IF c_record.bp_name IS NULL THEN
          v_bp_id       := NULL;
          v_bp_category := NULL;
          yonda_auto_write_off_log(p_message => '来自帐号：' || c_record.bank_account_num || '的一笔收款' ||
                                                c_record.transaction_amount || '没有对方户名，无法匹配商业伙伴，无法自动核销');
        ELSE
          BEGIN
            SELECT v.bp_id_tenant
              INTO v_bp_id
              FROM con_contract_lv v
             WHERE c_record.bp_name = v.bp_id_tenant_n
                   AND rownum = 1;
            SELECT t.bp_category INTO v_bp_category FROM hls_bp_master t WHERE t.bp_id = v_bp_id;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_bp_id       := NULL;
              v_bp_category := NULL;
              yonda_auto_write_off_log(p_message => c_record.bp_name || '，一笔收款' || c_record.transaction_amount ||
                                                    '未找到对应的商业伙伴，无法自动核销');
          END;
        END IF;
      END;
      -- check account
      BEGIN
        IF c_record.bank_account_num IS NULL THEN
          v_bank_account_id    := NULL;
          v_currency_code      := 'CNY';
          v_bp_bank_account_id := NULL;
        ELSE
          SELECT cbav.bank_account_id,
                 cbav.currency_code,
                 nvl(cbav.bank_account_id,
                     NULL)
            INTO v_bank_account_id,
                 v_currency_code,
                 v_bp_bank_account_id
            FROM csh_bank_account_v cbav
           WHERE cbav.bank_account_num = c_record.bank_account_num
                 AND cbav.enabled_flag = 'Y';
        END IF;
      END;
  
      SELECT v.period_name,
             gld_common_pkg.get_gld_internal_period_num(p_company_id,
                                                        v.period_name) internal_period_num
        INTO v_period_name,
             v_internal_period_num
        FROM (SELECT gld_common_pkg.get_gld_period_name(p_company_id,
                                                        trunc(c_record.transaction_date)) period_name
                FROM dual) v;
  
      insert_csh_transaction(p_transaction_id          => v_transaction_id,
                             p_transaction_num         => v_transaction_num,
                             p_transaction_category    => 'BUSINESS',
                             p_transaction_type        => 'RECEIPT',
                             p_transaction_date        => trunc(c_record.transaction_date),
                             p_penalty_calc_date       => trunc(c_record.transaction_date),
                             p_bank_slip_num           => NULL,
                             p_company_id              => p_company_id,
                             p_internal_period_num     => v_internal_period_num,
                             p_period_name             => v_period_name,
                             p_payment_method_id       => 1,
                             p_distribution_set_id     => NULL,
                             p_cashflow_amount         => c_record.transaction_amount,
                             p_currency_code           => v_currency_code,
                             p_transaction_amount      => c_record.transaction_amount,
                             p_exchange_rate_type      => NULL,
                             p_exchange_rate_quotation => NULL,
                             p_exchange_rate           => 1,
                             p_bank_account_id         => v_bank_account_id,
                             p_bp_category             => v_bp_category,
                             p_bp_id                   => v_bp_id,
                             p_bp_bank_account_id      => v_bp_bank_account_id,
                             p_bp_bank_account_num     => c_record.bp_bank_account_num,
                             p_description             => c_record.description,
                             p_handling_charge         => 0,
                             p_posted_flag             => 'Y',
                             p_reversed_flag           => 'N',
                             p_reversed_date           => NULL,
                             p_returned_flag           => 'NOT',
                             p_returned_amount         => NULL,
                             p_write_off_flag          => 'NOT',
                             p_write_off_amount        => NULL,
                             p_full_write_off_date     => NULL,
                             p_twin_csh_trx_id         => NULL,
                             p_return_from_csh_trx_id  => NULL,
                             p_reversed_csh_trx_id     => NULL,
                             p_source_csh_trx_type     => NULL,
                             p_source_csh_trx_id       => NULL,
                             p_source_doc_category     => NULL,
                             p_source_doc_type         => NULL,
                             p_source_doc_id           => NULL,
                             p_source_doc_line_id      => NULL,
                             p_create_je_mothed        => NULL,
                             p_create_je_flag          => 'N',
                             p_gld_interface_flag      => 'N',
                             p_user_id                 => p_user_id,
                             p_ref_contract_id         => NULL);
      UPDATE csh_transaction ct SET ct.receipt_type = 'IMPORT' WHERE ct.transaction_id = v_transaction_id;
      --begin to write off
      SAVEPOINT start_auto_write_off;
      BEGIN
        SELECT COUNT(1)
          INTO v_contract_num
          FROM con_contract c
         WHERE c.bp_id_tenant = v_bp_id
               AND data_class = 'NORMAL'
               AND c.contract_status NOT IN ('CANCEL',
                                             'AD',
                                             'ET',
                                             'TERMINATE'); -- add by qianming 20150819
        ----如果未根据承租人找到合同，或者找到多条合同，则不核销
  
        IF v_contract_num < 1 THEN
          v_write_off_flag := 'N';
          IF v_bp_id IS NOT NULL THEN
            yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                     p_bp_id           => v_bp_id,
                                     p_bank_account_id => v_bank_account_id,
                                     p_message         => c_record.bp_name || '，一笔收款' || c_record.transaction_amount ||
                                                          '未匹配对应的合同，无法自动核销');
          END IF;
          \*raise e_null_contract_error;*\
        ELSIF v_contract_num > 1 THEN
          v_write_off_flag := 'N';
          yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                   p_bp_id           => v_bp_id,
                                   p_bank_account_id => v_bank_account_id,
                                   p_message         => c_record.bp_name || '，一笔收款' || c_record.transaction_amount ||
                                                        '匹配到多个合同，无法自动核销');
          \*raise e_too_many_contract_error;*\
        ELSE
          ---如果只找到一条合同，记录合同id，并查看与收款金额匹配的该合同的现金流
          SELECT c.contract_id
            INTO v_contract_id
            FROM con_contract c
           WHERE c.bp_id_tenant = v_bp_id
                 AND data_class = 'NORMAL'
                 AND c.contract_status NOT IN ('CANCEL',
                                               'AD',
                                               'ET',
                                               'TERMINATE');
          SELECT cc.* INTO v_contract_rec FROM con_contract cc WHERE cc.contract_id = v_contract_id;
          \*check contract status*\
          IF v_contract_rec.contract_status IN ('SIGN',
                                                'PRINTED',
                                                'NEW') THEN
            yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                     p_bp_id           => v_bp_id,
                                     p_contract_id     => v_contract_id,
                                     p_bank_account_id => v_bank_account_id,
                                     p_message         => c_record.bp_name || '，一笔收款' || c_record.transaction_amount ||
                                                          '匹配的合同状态不正确，无法自动核销');
          ELSE
            SELECT COUNT(1)
              INTO v_cashflow_num
              FROM con_contract_cashflow ccf
             WHERE ccf.cf_status = 'RELEASE'
                   AND ccf.cf_direction = 'INFLOW'
                   AND ccf.due_amount - nvl(ccf.received_amount,
                                            0) = c_record.transaction_amount
                   AND ccf.contract_id = v_contract_id;
  
            IF v_cashflow_num < 1 THEN
              v_write_off_flag := 'N';
              yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                       p_bp_id           => v_bp_id,
                                       p_bank_account_id => v_bank_account_id,
                                       p_message         => c_record.bp_name || '，一笔收款' || c_record.transaction_amount ||
                                                            '匹配的合同没有可核销现金流，无法自动核销');
              \*raise e_null_cashflow_error;*\
            ELSE
              \*raise e_null_cashflow_error;*\
              ---如果找到多条未核销的现金流，则先核销期数最小的那一条
              SELECT MIN(ccf.times)
                INTO v_min_times
                FROM con_contract_cashflow ccf
               WHERE ccf.cf_status = 'RELEASE'
                     AND ccf.cf_direction = 'INFLOW'
                     AND ccf.due_amount - nvl(ccf.received_amount,
                                              0) = c_record.transaction_amount
                     AND ccf.contract_id = v_contract_id;
  
              SELECT *
                INTO v_con_contract_cashflow_rec
                FROM con_contract_cashflow ccf
               WHERE ccf.cf_status = 'RELEASE'
                     AND ccf.cf_direction = 'INFLOW'
                     AND ccf.due_amount - nvl(ccf.received_amount,
                                              0) = c_record.transaction_amount
                     AND ccf.times = v_min_times
                     AND ccf.contract_id = v_contract_id;
              IF NOT v_is_error AND v_write_off_flag = 'Y' THEN
                BEGIN
                  v_session_id := sys_session_s.nextval;
                  csh_write_off_pkg.insert_csh_write_off_temp(p_session_id           => v_session_id,
                                                              p_write_off_type       => 'RECEIPT_CREDIT',
                                                              p_transaction_category => 'BUSINESS',
                                                              p_transaction_type     => 'RECEIPT',
                                                              p_write_off_date       => trunc(SYSDATE),
                                                              p_write_off_due_amount => c_record.transaction_amount,
                                                              p_write_off_principal  => v_con_contract_cashflow_rec.principal -
                                                                                        nvl(v_con_contract_cashflow_rec.received_principal,
                                                                                            0),
                                                              p_write_off_interest   => v_con_contract_cashflow_rec.interest -
                                                                                        nvl(v_con_contract_cashflow_rec.received_interest,
                                                                                            0),
                                                              p_company_id           => p_company_id,
                                                              p_document_category    => 'CONTRACT',
                                                              p_document_id          => v_contract_id,
                                                              p_document_line_id     => v_con_contract_cashflow_rec.cashflow_id,
                                                              p_description          => '收款导入自动核销生成',
                                                              p_user_id              => p_user_id);
                  csh_write_off_pkg.main_write_off(p_session_id     => v_session_id,
                                                   p_transaction_id => v_transaction_id,
                                                   p_user_id        => p_user_id);
  
                  v_save_message := '提交成功，并已自动核销！';
                  yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                           p_bp_id           => v_bp_id,
                                           p_contract_id     => v_contract_id,
                                           p_bank_account_id => v_bank_account_id,
                                           p_message         => c_record.bp_name || '，一笔收款' ||
                                                                c_record.transaction_amount || v_save_message);
                EXCEPTION
                  WHEN OTHERS THEN
                    sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                                SQLERRM,
                                                                   p_created_by              => p_user_id,
                                                                   p_package_name            => 'CSH_TRANSACTION',
                                                                   p_procedure_function_name => 'SAVE_DATA');
                    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                            sys_raise_app_error_pkg.g_err_line_id);
                    ROLLBACK TO start_auto_write_off;
                    v_is_error     := TRUE;
                    v_save_message := '未能自动核销，请检查数据！';
                    yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                             p_bp_id           => v_bp_id,
                                             p_contract_id     => v_contract_id,
                                             p_bank_account_id => v_bank_account_id,
                                             p_message         => c_record.bp_name || '，一笔收款' ||
                                                                  c_record.transaction_amount || v_save_message);
                END;
              END IF;
            END IF;
          END IF;
        END IF;
      EXCEPTION
        WHEN e_null_contract_error THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_IMPORT_CONTRACT_NOT_FOUND',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_transaction_pkg',
                                                          p_procedure_function_name => 'save_data');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
          ROLLBACK TO start_auto_write_off;
          v_is_error     := TRUE;
          v_save_message := '未找到相应合同，无法自动核销！';
        WHEN e_too_many_contract_error THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_IMPORT_TOO_MANY_CONTRACT',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_transaction_pkg',
                                                          p_procedure_function_name => 'save_data');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
          ROLLBACK TO start_auto_write_off;
          v_is_error     := TRUE;
          v_save_message := '找到多条合同，无法自动核销！';
        WHEN e_null_cashflow_error THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_IMPORT_WRITE_OFF_AMOUNT_NOT_MATCH',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_transaction_pkg',
                                                          p_procedure_function_name => 'save_data');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
          ROLLBACK TO start_auto_write_off;
          v_is_error     := TRUE;
          v_save_message := '未找到对应现金流，无法自动核销，请检查金额！';
      END;
    END LOOP;
    --删除临时表数据
    delete_interface(p_batch_id,
                     p_user_id);
    delete_temp(p_batch_id);
  END;*/
  Procedure save_data(p_batch_id     Number,
                      p_user_id      Number,
                      p_company_id   Number,
                      v_save_message Out Varchar2) As
  Begin
    /*sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '该功能正在维护中，请稍后尝试！',
                                                   p_created_by              => p_user_id,
                                                   p_package_name            => 'CSH_TRANSACTION',
                                                   p_procedure_function_name => 'DELETE_INTERFACE');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);*/
    -- transaction & write off
    yonda_csh_transaction_pkg.auto_transaction_and_write_off(p_batch_id   => p_batch_id,
                                                             p_user_id    => p_user_id,
                                                             p_company_id => p_company_id);
    --删除临时表数据
    delete_interface(p_batch_id, p_user_id);
    delete_temp(p_batch_id);
  End save_data;

  Procedure risk_vat_insert(p_vat        Number,
                            p_company_id Number,
                            p_user_id    Number) Is
    r_transaction csh_transaction%Rowtype;
    r_cwo         CSH_WRITE_OFF%Rowtype;
  Begin
    Select c.*
      Into r_transaction
      From csh_transaction c
     Where c.transaction_type = 'RISK'
       And c.company_id = p_company_id
       For Update;
  
    r_cwo.write_off_id         := csh_write_off_s.nextval;
    r_cwo.write_off_type       := 'RISK_CREDIT';
    r_cwo.write_off_date       := trunc(Sysdate);
    r_cwo.internal_period_num  := to_char(Sysdate, 'YYYYMM');
    r_cwo.period_name          := to_char(Sysdate, 'YYYY-MM');
    r_cwo.csh_transaction_id   := r_transaction.transaction_id;
    r_cwo.csh_write_off_amount := p_vat;
    r_cwo.reversed_flag        := 'N';
    r_cwo.write_off_due_amount := p_vat;
    r_cwo.create_je_flag       := 'Y';
    r_cwo.gld_interface_flag   := 'N';
    r_cwo.created_by           := p_user_id;
    r_cwo.creation_date        := Sysdate;
    r_cwo.last_updated_by      := p_user_id;
    r_cwo.last_update_date     := Sysdate;
    r_cwo.pay_dec              := '支付风险金税金';
    Insert Into csh_write_off Values r_cwo;
    Update csh_transaction o
       Set o.write_off_amount = nvl(o.write_off_amount, 0) + p_vat
     Where o.transaction_id = r_transaction.transaction_id;
  
  End risk_vat_insert;
  -- add by Liyuan 以下为df收款批量导入
  Procedure delete_batch_interface(p_batch_session_id Number,
                                   p_user_id          Number) Is
  Begin
    Delete From csh_transaction_batch_temp t
     Where t.batch_session_id = p_batch_session_id;
    delete_error_batch_logs(p_batch_session_id);
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_TRANSACTION',
                                                     p_procedure_function_name => 'DELETE_BATCH_INTERFACE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End delete_batch_interface;

  Procedure insert_batch_interface(p_header_id        Number,
                                   p_batch_session_id Number,
                                   p_user_id          Number) Is
    v_log_text                   Varchar2(2000);
    r_csh_transaction_batch_temp csh_transaction_batch_temp%Rowtype;
    v_fee_type                   Varchar2(30);
    v_guangsan_flag              Varchar2(30);
  Begin
    For i_cur In (Select *
                    From fnd_interface_lines
                   Where header_id = p_header_id
                     And line_number >= 1
                     And Exists
                   (Select 1
                            From fnd_interface_lines f
                           Where f.header_id = p_header_id
                             And f.line_number = 0
                             And Trim(Replace(f.attribute_4, chr(9), '')) =
                                 '交易流水号'
                             And Trim(Replace(f.attribute_7, chr(9), '')) =
                                 '商业伙伴名称'
                             And Trim(Replace(f.attribute_8, chr(9), '')) =
                                 '费用类型'
                             And Trim(Replace(f.attribute_9, chr(9), '')) =
                                 '是否广三代付')) Loop
      If date_data_check(i_cur.attribute_1) Then
        Insert Into csh_transaction_batch_temp
          (csh_transaction_batch_temp_id,
           batch_session_id,
           transaction_date,
           transaction_amount,
           bank_serial_num,
           bp_bank_account_num,
           bp_bank_account_name,
           bp_name,
           fee_type,
           guangsan_flag,
           description,
           lease_channel,
           bank_account_num,
           ref_v02,
           ref_v03,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        Values
          (csh_transaction_batch_temp_s.nextval,
           p_batch_session_id,
           to_date(i_cur.attribute_1, 'YYYY-MM-DD'),
           -- attribute_2  对应报表第二列不存值 B 借
           i_cur.attribute_3,
           Replace(Trim(i_cur.attribute_4), chr(9), ''),
           Replace(Trim(i_cur.attribute_5), chr(9), ''),
           Replace(Trim(i_cur.attribute_6), chr(9), ''),
           Replace(Trim(i_cur.attribute_7), chr(9), ''),
           decode(Replace(Trim(i_cur.attribute_8), chr(9), ''),
                  '管理费',
                  '301',
                  '赎证款',
                  '302',
                  '保理首付款',
                  '303',
                  '提前赎证款',
                  '304',
                  nvl((Select h.cf_item
                        From hls_cashflow_item h
                       Where h.description =
                             Replace(Trim(i_cur.attribute_8), chr(9), '')),
                      '-1')), -- 提前赎证款
           decode(Replace(Trim(i_cur.attribute_9), chr(9), ''),
                  '是',
                  'Y',
                  '否',
                  'N',
                  '-1'),
           Replace(Trim(i_cur.attribute_10), chr(9), ''),
           '01', -- 商业模式 默认
           '11014803237000', -- 收款帐号 默认
           Replace(Trim(i_cur.attribute_8), chr(9), ''),
           Replace(Trim(i_cur.attribute_9), chr(9), ''),
           p_user_id,
           Sysdate,
           p_user_id,
           Sysdate);
      Else
        Select decode(Replace(Trim(i_cur.attribute_8),
                              
                              chr(9),
                              ''),
                      '管理费',
                      '301',
                      '赎证款',
                      '302',
                      '保理首付款',
                      '303',
                      '提前赎证款',
                      '304',
                      nvl((Select h.cf_item
                            From hls_cashflow_item h
                           Where h.description =
                                 Replace(Trim(i_cur.attribute_8), chr(9), '')),
                          '-1')),
               decode(Replace(Trim(i_cur.attribute_9), chr(9), ''),
                      '是',
                      'Y',
                      '否',
                      'N',
                      '-1')
          Into v_fee_type, v_guangsan_flag
          From dual;
      
        r_csh_transaction_batch_temp.batch_session_id := p_batch_session_id;
        r_csh_transaction_batch_temp.transaction_date := Null;
        -- attribute_2  对应报表第二列不存值 B 借
        r_csh_transaction_batch_temp.transaction_amount := i_cur.attribute_3;
        r_csh_transaction_batch_temp.bank_serial_num    := Replace(Trim(i_cur.attribute_4),
                                                                   chr(9),
                                                                   '');
        r_csh_transaction_batch_temp.bp_bank_account_num  := Replace(Trim(i_cur.attribute_5),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.bp_bank_account_name := Replace(Trim(i_cur.attribute_6),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.bp_name              := Replace(Trim(i_cur.attribute_7),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.fee_type             := v_fee_type; -- 提前赎证款
        r_csh_transaction_batch_temp.guangsan_flag        := v_guangsan_flag;
        r_csh_transaction_batch_temp.description          := Replace(Trim(i_cur.attribute_10),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.lease_channel        := '01'; -- 商业模式 默认
        r_csh_transaction_batch_temp.bank_account_num     := '11014803237000'; -- 收款帐号 默认
        r_csh_transaction_batch_temp.ref_v02              := Replace(Trim(i_cur.attribute_8),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.ref_v03              := Replace(Trim(i_cur.attribute_9),
                                                                     chr(9),
                                                                     '');
        r_csh_transaction_batch_temp.created_by           := p_user_id;
        r_csh_transaction_batch_temp.creation_date        := Sysdate;
        r_csh_transaction_batch_temp.last_updated_by      := p_user_id;
        r_csh_transaction_batch_temp.last_update_date     := Sysdate;
        v_log_text                                        := '收款日期格式错误,无法识别,请重新录入!';
        txn_batch_log(r_csh_transaction_batch_temp,
                      v_log_text,
                      p_user_id,
                      'N');
      End If;
    End Loop;
    check_batch_data(p_batch_session_id => p_batch_session_id,
                     p_user_id          => p_user_id);
  End insert_batch_interface;

  -- 针对日期格式的校验
  Function date_data_check(p_data_import In Varchar2) Return Boolean As
    v_date Date;
  Begin
    v_date := to_date(p_data_import, 'yyyy-mm-dd');
    Return True;
  Exception
    When Others Then
      Return False;
  End date_data_check;
  -- add by Liyuan 临时表的数据检查
  Procedure delete_error_batch_logs(p_batch_session_id Number) Is
  Begin
    Delete From csh_df_batch_temp_logs t
     Where t.batch_session_id = p_batch_session_id;
  End delete_error_batch_logs;

  Procedure txn_batch_log(p_batch_temp In csh_transaction_batch_temp%Rowtype,
                          p_log_text   In Varchar2,
                          p_user_id    In Number,
                          p_flag       In Varchar2) Is
  Begin
    Insert Into csh_df_batch_temp_logs
      (csh_df_batch_temp_logs_id,
       batch_session_id,
       transaction_date,
       transaction_amount,
       bank_serial_num,
       bp_bank_account_num,
       bp_bank_account_name,
       bp_name,
       fee_type,
       guangsan_flag,
       description,
       lease_channel,
       bank_account_num,
       log_text,
       ref_v01,
       ref_v02,
       ref_v03,
       creation_date,
       created_by,
       last_updated_by,
       last_update_date)
    Values
      (csh_df_batch_temp_logs_s.nextval,
       p_batch_temp.batch_session_id,
       p_batch_temp.transaction_date,
       p_batch_temp.transaction_amount,
       p_batch_temp.bank_serial_num,
       p_batch_temp.bp_bank_account_num,
       p_batch_temp.bp_bank_account_name,
       p_batch_temp.bp_name,
       p_batch_temp.fee_type,
       p_batch_temp.guangsan_flag,
       p_batch_temp.description,
       p_batch_temp.lease_channel,
       p_batch_temp.bank_account_num,
       p_log_text,
       p_flag,
       p_batch_temp.ref_v02,
       p_batch_temp.ref_v03,
       Sysdate,
       p_user_id,
       p_user_id,
       Sysdate);
  
    If p_flag = 'Y' Then
      Update csh_transaction_batch_temp cb
         Set cb.ref_v01 = p_flag
       Where cb.csh_transaction_batch_temp_id =
             p_batch_temp.csh_transaction_batch_temp_id
         And cb.batch_session_id = p_batch_temp.batch_session_id;
    End If;
  End txn_batch_log;

  Procedure check_batch_data(p_batch_session_id Number, p_user_id Number) Is
    v_line_num        Number := 2;
    v_continue_flag   Boolean;
    v_continue_flag_n Boolean;
    v_log_text        Varchar2(2000) := '';
    e_nullpoint Exception;
    v_line_count Number;
  Begin
    --delete_error_batch_logs(p_batch_session_id);
    For i_cur In (Select *
                    From csh_transaction_batch_temp t
                   Where t.batch_session_id = p_batch_session_id) Loop
      v_continue_flag   := True;
      v_continue_flag_n := True;
      v_log_text := null;
      If i_cur.transaction_date Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '收款日期; ';
      End If;
      If i_cur.transaction_amount Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '收款金额; ';
      End If;
      If i_cur.bank_serial_num Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '银行流水号; ';
      End If;
      If i_cur.bp_bank_account_num Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '打款账号; ';
      End If;
      If i_cur.bp_bank_account_name Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '收款账户名; ';
      End If;
      If i_cur.bp_name Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '商业伙伴名称; ';
      End If;
      If i_cur.ref_v02 Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '费用类型; ';
      End If;
      If i_cur.ref_v03 Is Null Then
        v_continue_flag := False;
        v_log_text      := v_log_text || '是否广三代付; ';
      End If;
    
      If Not v_continue_flag Then
        v_log_text := '请录入必录项: ' || v_log_text;
        txn_batch_log(i_cur, v_log_text, p_user_id, 'N');
      End If;
    
      If v_continue_flag Then
        If i_cur.fee_type Not In ('301', '302', '303', '304') Then
          v_continue_flag_n := False;
          v_log_text        := v_log_text ||
                               '费用类型录入错误, 须在 管理费、赎证款、保理首付款、提前赎证款 中取一项值进行录入。';
        End If;
        If i_cur.guangsan_flag Not In ('Y', 'N') Then
          v_continue_flag_n := False;
          v_log_text        := v_log_text || '是否广三代付请录入“是”或“否”。';
        End If;
        If i_cur.guangsan_flag = 'Y' Then
          If i_cur.bp_bank_account_name = i_cur.bp_name Then
            v_continue_flag_n := False;
            v_log_text        := v_log_text ||
                                 '若“是”广三代付, 则账户名称(打款)请录入广三代付。';
          End If;
        End If;
        If i_cur.guangsan_flag = 'N' Then
          If i_cur.bp_bank_account_name <> i_cur.bp_name Then
            v_continue_flag_n := False;
            v_log_text        := v_log_text ||
                                 '若“否”广三代付, 则账户名称(打款)应与商业伙伴名称一致。';
          End If;
        End If;
      
        If Not v_continue_flag_n Then
          v_log_text := '数据校验错误: ' || v_log_text;
          txn_batch_log(i_cur, v_log_text, p_user_id, 'N');
        End If;
        If v_continue_flag_n Then
          Select Count(1)
            Into v_line_count
            From csh_transaction c
           Where c.bank_slip_num = i_cur.bank_serial_num;
          If v_line_count > 0 Then
            v_log_text := '数据已导入系统, 勿重复导入! 请核对';
            txn_batch_log(i_cur, v_log_text, p_user_id, 'Y');
          Else
            txn_batch_log(i_cur, v_log_text, p_user_id, 'N');
          End If;
        End If;
      End If;
      v_line_num := v_line_num + 1;
    End Loop;
  End check_batch_data;

  Function match_bp_by_name(p_bp_name       In Varchar2,
                            p_error_message Out Varchar2) Return Number As
    v_bp_id Number;
  Begin
    Select tt1.bp_id
      Into v_bp_id
      From hls_bp_master tt1
     Where tt1.bp_name = p_bp_name
       And tt1.enabled_flag = 'Y'
       And Exists (Select 1
              From con_contract_bp
             Where bp_id = tt1.bp_id
               And bp_category = 'AGENT');
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

  Procedure save_batch_data(p_batch_session_id Number,
                            p_user_id          Number,
                            p_company_id       Number) Is
  
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
                        From csh_transaction_batch_temp a
                       Where a.batch_session_id = p_batch_session_id) Loop
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
        v_contract_id := yonda_csh_transaction_pkg.match_contract_by_bp_amount(p_bp_id         => v_bp_id,
                                                                               p_amount        => cc_record.transaction_amount,
                                                                               p_error_message => v_front_message);
        If v_contract_id Is Not Null Then
          --3. get cashflow & bp & contract
          Select *
            Into r_con_contract_bp
            From con_contract_bp
           Where contract_id = v_contract_id
             And bp_id = v_bp_id
             And bp_category = 'AGENT';
          r_con_contract_cashflow := yonda_csh_transaction_pkg.get_cashflow_by_contract(p_contract_id   => v_contract_id,
                                                                                        p_amount        => cc_record.transaction_amount,
                                                                                        p_error_message => v_front_message);
        End If;
      End If;
      -- 4. get account info
      -- no catch exception
      yonda_csh_transaction_pkg.get_bp_band_account(p_bp_bank_account_num => cc_record.bp_bank_account_num,
                                                    p_bp_id               => v_bp_id,
                                                    p_bp_bank_account_id  => v_bp_bank_account_id);
      -- no catch exception
      yonda_csh_transaction_pkg.get_company_band_account(p_company_bank_account_num => cc_record.bank_account_num,
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
      insert_csh_transaction(p_transaction_id          => v_transaction_id,
                             p_transaction_num         => v_transaction_num,
                             p_transaction_category    => 'BUSINESS',
                             p_transaction_type        => 'RECEIPT',
                             p_transaction_date        => trunc(cc_record.transaction_date),
                             p_penalty_calc_date       => trunc(cc_record.transaction_date),
                             p_bank_slip_num           => cc_record.bank_serial_num,
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
                             p_bp_category             => 'AGENT',
                             p_bp_id                   => v_bp_id,
                             p_bp_bank_account_id      => v_bp_bank_account_id,
                             p_bp_bank_account_num     => cc_record.bp_bank_account_num,
                             p_description             => cc_record.description,
                             p_handling_charge         => 0,
                             p_posted_flag             => 'Y', -- 导入的数据自动过账
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
                             p_csh_bp_name             => cc_record.bp_bank_account_name,
                             p_lease_channel           => cc_record.lease_channel,
                             p_guangsan_flag           => cc_record.guangsan_flag,
                             p_fee_type                => cc_record.fee_type);
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
      yonda_csh_transaction_pkg.yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
                                                         p_bp_id           => v_bp_id,
                                                         p_contract_id     => v_contract_id,
                                                         p_bank_account_id => v_bp_bank_account_id,
                                                         p_message         => v_head_message ||
                                                                              v_front_message);
    End Loop;
    delete_batch_interface(p_batch_session_id, p_user_id);
    delete_error_batch_logs(p_batch_session_id);
  End save_batch_data;
  -- end added by Liyuan

End csh_transaction_pkg;
/
