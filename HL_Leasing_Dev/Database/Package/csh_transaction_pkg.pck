CREATE OR REPLACE PACKAGE csh_transaction_pkg IS

	-- Author  : GAOYANG
	-- Created : 2013/5/9 14:43:26
	-- Purpose : 现金事务
	-- Version : 1.18

	---退款
	csh_trx_return_flag_p      CONSTANT VARCHAR2(30) := 'PARTIAL';
	csh_trx_return_flag_f      CONSTANT VARCHAR2(30) := 'FULL';
	csh_trx_return_flag_n      CONSTANT VARCHAR2(30) := 'NOT';
	csh_trx_return_flag_return CONSTANT VARCHAR2(30) := 'RETURN'; --退款类型
	--核销
	csh_trx_write_off_flag_p CONSTANT VARCHAR2(30) := 'PARTIAL'; -- 部分核销
	csh_trx_write_off_flag_n CONSTANT VARCHAR2(30) := 'NOT'; -- 未核销
	csh_trx_write_off_flag_f CONSTANT VARCHAR2(30) := 'FULL'; -- 完全核销

	---冲销
	csh_trx_reversed_flag_n CONSTANT VARCHAR2(1) := 'N';
	csh_trx_reversed_flag_r CONSTANT VARCHAR2(1) := 'R';
	csh_trx_reversed_flag_w CONSTANT VARCHAR2(1) := 'W';

	csh_trx_type_receipt    CONSTANT VARCHAR2(30) := 'RECEIPT'; -- 收款类型
	csh_trx_type_prereceipt CONSTANT VARCHAR2(30) := 'ADVANCE_RECEIPT'; -- 预收款类型
	csh_trx_type_payment    CONSTANT VARCHAR2(30) := 'PAYMENT'; -- 付款类型
	csh_trx_type_deduction  CONSTANT VARCHAR2(30) := 'DEDUCTION'; -- 收付抵扣

	csh_trx_category_business      CONSTANT VARCHAR2(30) := 'BUSINESS'; -- 收款类别
	csh_trx_category_loan_withdraw CONSTANT VARCHAR2(30) := 'LOAN_WITHDRAW'; -- 银行借款
	csh_trx_category_capital_int   CONSTANT VARCHAR2(30) := 'LOAN_REPAYMENT_CI'; -- 还本付息
	csh_trx_category_capital       CONSTANT VARCHAR2(30) := 'LOAN_REPAYMENT_C'; -- 本金
	csh_trx_category_interest      CONSTANT VARCHAR2(30) := 'LOAN_REPAYMENT_I'; -- 利息
	csh_trx_category_factoring     CONSTANT VARCHAR2(30) := 'LOAN_REPAYMENT_F'; -- 保理还款
	csh_trx_category_factoring_fee CONSTANT VARCHAR2(30) := 'LOAN_REPAYMENT_FF'; -- 保理费

	---过帐
	csh_trx_posted_flag_yes CONSTANT VARCHAR2(1) := 'Y';
	csh_trx_posted_flag_no  CONSTANT VARCHAR2(1) := 'N';

	/* 现金事务编号获取函数 */
	FUNCTION get_csh_transaction_num(p_transaction_type VARCHAR2,
																	 p_transaction_date DATE,
																	 p_company_id       NUMBER,
																	 p_user_id          NUMBER) RETURN VARCHAR2;

	PROCEDURE lock_csh_transaction(p_transaction_id      IN NUMBER,
																 p_user_id             IN NUMBER,
																 p_csh_transaction_rec OUT csh_transaction%ROWTYPE);

	--更新现金事务核销状态
	PROCEDURE set_csh_trx_write_off_status(p_csh_trx_rec      csh_transaction%ROWTYPE,
																				 p_write_off_amount NUMBER,
																				 p_user_id          NUMBER);

	--更新被反冲现金事务
	PROCEDURE update_csh_trx_after_reverse(p_transaction_id      NUMBER,
																				 p_reversed_date       DATE,
																				 p_reserved_csh_trx_id NUMBER,
																				 p_user_id             NUMBER);

	--核销反冲后更新原现金事务核销金额
	PROCEDURE update_trx_amt_after_reverse(p_transaction_id NUMBER,
																				 p_reverse_amount NUMBER,
																				 p_user_id        NUMBER);

	FUNCTION is_trx_return(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN;

	FUNCTION is_trx_reverse(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN;

	/*modify by xuls 2014-9-16
  add ref_contract_id
   */
	PROCEDURE insert_csh_transaction(p_transaction_id          OUT csh_transaction.transaction_id%TYPE,
																	 p_transaction_num         csh_transaction.transaction_num%TYPE,
																	 p_transaction_category    csh_transaction.transaction_category%TYPE,
																	 p_transaction_type        csh_transaction.transaction_type%TYPE,
																	 p_transaction_date        csh_transaction.transaction_date%TYPE,
																	 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																	 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																	 p_company_id              csh_transaction.company_id%TYPE,
																	 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																	 p_period_name             csh_transaction.period_name%TYPE,
																	 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																	 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																	 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																	 p_currency_code           csh_transaction.currency_code%TYPE,
																	 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																	 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																	 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																	 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																	 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																	 p_bp_category             csh_transaction.bp_category%TYPE,
																	 p_bp_id                   csh_transaction.bp_id%TYPE,
																	 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																	 p_bp_bank_account_name    csh_transaction.bp_bank_account_name%TYPE DEFAULT NULL, --add by Spener 3893 20160722
																	 p_description             csh_transaction.description%TYPE,
																	 p_handling_charge         csh_transaction.handling_charge%TYPE,
																	 p_posted_flag             csh_transaction.posted_flag%TYPE,
																	 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																	 p_reversed_date           csh_transaction.reversed_date%TYPE,
																	 p_returned_flag           csh_transaction.returned_flag%TYPE,
																	 p_returned_amount         csh_transaction.returned_amount%TYPE,
																	 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																	 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																	 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																	 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																	 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																	 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																	 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																	 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																	 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																	 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																	 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																	 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																	 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																	 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																	 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																	 p_user_id                 csh_transaction.created_by%TYPE,
																	 p_ref_contract_id         csh_transaction.ref_contract_id%TYPE DEFAULT NULL,
																	 p_receipt_type            csh_transaction.receipt_type%TYPE DEFAULT NULL,
																	 p_csh_bp_name             csh_transaction.csh_bp_name%TYPE DEFAULT NULL);
	PROCEDURE update_csh_transaction(p_transaction_id          csh_transaction.transaction_id%TYPE,
																	 p_transaction_num         csh_transaction.transaction_num%TYPE,
																	 p_transaction_category    csh_transaction.transaction_category%TYPE,
																	 p_transaction_type        csh_transaction.transaction_type%TYPE,
																	 p_transaction_date        csh_transaction.transaction_date%TYPE,
																	 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																	 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																	 p_company_id              csh_transaction.company_id%TYPE,
																	 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																	 p_period_name             csh_transaction.period_name%TYPE,
																	 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																	 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																	 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																	 p_currency_code           csh_transaction.currency_code%TYPE,
																	 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																	 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																	 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																	 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																	 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																	 p_bp_category             csh_transaction.bp_category%TYPE,
																	 p_bp_id                   csh_transaction.bp_id%TYPE,
																	 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																	 p_description             csh_transaction.description%TYPE,
																	 p_handling_charge         csh_transaction.handling_charge%TYPE,
																	 p_posted_flag             csh_transaction.posted_flag%TYPE,
																	 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																	 p_reversed_date           csh_transaction.reversed_date%TYPE,
																	 p_returned_flag           csh_transaction.returned_flag%TYPE,
																	 p_returned_amount         csh_transaction.returned_amount%TYPE,
																	 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																	 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																	 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																	 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																	 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																	 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																	 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																	 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																	 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																	 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																	 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																	 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																	 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																	 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																	 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																	 p_user_id                 csh_transaction.created_by%TYPE,
																	 p_ref_contract_id         csh_transaction.ref_contract_id%TYPE DEFAULT NULL);
	--货币兑换维护
	PROCEDURE update_currency_exchange_trx(p_transaction_id          csh_transaction.transaction_id%TYPE,
																				 p_transaction_num         csh_transaction.transaction_num%TYPE,
																				 p_transaction_category    csh_transaction.transaction_category%TYPE,
																				 p_transaction_type        csh_transaction.transaction_type%TYPE,
																				 p_transaction_date        csh_transaction.transaction_date%TYPE,
																				 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																				 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																				 p_company_id              csh_transaction.company_id%TYPE,
																				 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																				 p_period_name             csh_transaction.period_name%TYPE,
																				 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																				 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																				 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																				 p_currency_code           csh_transaction.currency_code%TYPE,
																				 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																				 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																				 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																				 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																				 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																				 p_bp_category             csh_transaction.bp_category%TYPE,
																				 p_bp_id                   csh_transaction.bp_id%TYPE,
																				 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																				 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																				 p_description             csh_transaction.description%TYPE,
																				 p_handling_charge         csh_transaction.handling_charge%TYPE,
																				 p_posted_flag             csh_transaction.posted_flag%TYPE,
																				 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																				 p_reversed_date           csh_transaction.reversed_date%TYPE,
																				 p_returned_flag           csh_transaction.returned_flag%TYPE,
																				 p_returned_amount         csh_transaction.returned_amount%TYPE,
																				 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																				 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																				 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																				 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																				 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																				 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																				 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																				 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																				 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																				 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																				 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																				 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																				 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																				 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																				 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																				 p_user_id                 csh_transaction.created_by%TYPE);

	--货币兑换互记TWIN_CSH_TRX_ID
	PROCEDURE save_twin_csh_trx_id(p_transaction_num csh_transaction.transaction_num%TYPE,
																 p_user_id         NUMBER);

	--货币兑换过账以后维护
	PROCEDURE upd_currency_trx_after_post(p_transaction_id csh_transaction.transaction_id%TYPE,
																				p_bank_slip_num  csh_transaction.bank_slip_num%TYPE,
																				p_description    csh_transaction.description%TYPE,
																				p_user_id        csh_transaction.created_by%TYPE);
	--过账以后维护
	PROCEDURE update_csh_transaction_post(p_transaction_id     csh_transaction.transaction_id%TYPE,
																				p_bank_slip_num      csh_transaction.bank_slip_num%TYPE,
																				p_bp_bank_account_id csh_transaction.bp_bank_account_id%TYPE,
																				p_user_id            csh_transaction.created_by%TYPE);

	PROCEDURE update_csh_post_flag(p_transaction_id NUMBER,
																 p_user_id        NUMBER,
																 p_claim          VARCHAR2 DEFAULT NULL);
	PROCEDURE delete_csh_transaction(p_transaction_id csh_transaction.transaction_id%TYPE,
																	 p_user_id        csh_transaction.created_by%TYPE);
	PROCEDURE post_csh_transaction(p_transaction_id csh_transaction.transaction_id%TYPE,
																 p_user_id        csh_transaction.created_by%TYPE);

	--通用的反冲入口
	PROCEDURE reverse_csh_transaction(p_transaction_id         csh_transaction.transaction_id%TYPE,
																		p_reversed_date          csh_transaction.reversed_date%TYPE,
																		p_description            csh_transaction.description%TYPE,
																		p_user_id                csh_transaction.created_by%TYPE,
																		p_reverse_transaction_id OUT csh_transaction.transaction_id%TYPE);
	--收款反冲入口
	PROCEDURE reverse_receipt_csh_trx(p_transaction_id csh_transaction.transaction_id%TYPE,
																		p_reversed_date  csh_transaction.reversed_date%TYPE,
																		p_bank_slip_num  csh_transaction.bank_slip_num%TYPE,
																		p_description    csh_transaction.description%TYPE,
																		p_user_id        csh_transaction.created_by%TYPE);

	PROCEDURE return_csh_transaction(p_transaction_id      csh_transaction.transaction_id%TYPE,
																	 p_returned_date       DATE,
																	 p_returned_amount     csh_transaction.returned_amount%TYPE,
																	 p_bank_slip_num       csh_transaction.bank_slip_num%TYPE,
																	 p_payment_method_id   csh_transaction.payment_method_id%TYPE,
																	 p_bank_account_id     csh_transaction.bank_account_id%TYPE,
																	 p_bp_bank_account_id  csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num csh_transaction.bp_bank_account_num%TYPE,
																	 p_description         csh_transaction.description%TYPE,
																	 p_user_id             csh_transaction.created_by%TYPE);
	PROCEDURE delete_interface(p_batch_id NUMBER,
														 p_user_id  NUMBER);

	PROCEDURE insert_interface(p_header_id NUMBER,
														 p_batch_id  NUMBER,
														 p_user_id   NUMBER,
														 p_bank_type VARCHAR2 DEFAULT NULL);

	PROCEDURE check_data(p_batch_id  NUMBER,
											 p_user_id   NUMBER,
											 p_return_id OUT NUMBER,
											 p_bank_type VARCHAR2 DEFAULT NULL);

	PROCEDURE save_data(p_batch_id      NUMBER,
											p_user_id       NUMBER,
											p_company_id    NUMBER,
											po_save_message OUT VARCHAR2,
											p_bank_type     VARCHAR2 DEFAULT NULL);
	--查找付款方式 和
	FUNCTION search_payment_method(p_cashflow_id NUMBER,
																 p_earch       VARCHAR2) RETURN VARCHAR2;

	--add 20171020 未及时核销收款事务生成收款凭证job 每天凌晨跑 
	FUNCTION create_receipt_trx_je(p_user_id NUMBER) RETURN VARCHAR2;

END csh_transaction_pkg;
/
CREATE OR REPLACE PACKAGE BODY csh_transaction_pkg IS

	v_err_code VARCHAR2(2000);
	e_lock_trx_error EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_lock_trx_error, -54);

	FUNCTION get_csh_transaction_num(p_transaction_type VARCHAR2,
																	 p_transaction_date DATE,
																	 p_company_id       NUMBER,
																	 p_user_id          NUMBER) RETURN VARCHAR2 IS
		v_transaction_num csh_transaction.transaction_num%TYPE;
		e_trx_num_error EXCEPTION;
	BEGIN
		v_transaction_num := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => 'CSH_TRX',
																																	p_document_type     => p_transaction_type,
																																	p_company_id        => p_company_id,
																																	p_operation_unit_id => NULL,
																																	p_operation_date    => p_transaction_date,
																																	p_created_by        => p_user_id);
		IF nvl(v_transaction_num, fnd_code_rule_pkg.c_error) = fnd_code_rule_pkg.c_error THEN
			RAISE e_trx_num_error;
		END IF;
		RETURN v_transaction_num;
	EXCEPTION
		WHEN e_trx_num_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_TRANSACTION_NUM_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'get_csh_transaction_num');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--录入0金额校验
	PROCEDURE check_zero_amount(p_csh_transaction_rec IN csh_transaction%ROWTYPE,
															p_user_id             IN NUMBER) IS
		v_zero_amounts_allowed VARCHAR2(1);
		e_amount_error EXCEPTION;
	BEGIN
	
		IF p_csh_transaction_rec.transaction_amount <> 0 OR
			 (p_csh_transaction_rec.transaction_amount = 0 AND
			 p_csh_transaction_rec.transaction_type = csh_trx_type_deduction) THEN
			RETURN;
		END IF;
	
		/*SELECT nvl(d.zero_amounts_allowed, 'N')
      INTO v_zero_amounts_allowed
      FROM csh_bank_account_v d
     WHERE d.bank_account_id = p_csh_transaction_rec.bank_account_id;
    
    IF v_zero_amounts_allowed = 'N' THEN
      RAISE e_amount_error;
    END IF;*/
	EXCEPTION
		WHEN e_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_ZERO_AMOUNT_CHECK',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'zero_amount_check');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	PROCEDURE lock_csh_transaction(p_transaction_id      IN NUMBER,
																 p_user_id             IN NUMBER,
																 p_csh_transaction_rec OUT csh_transaction%ROWTYPE) IS
	
	BEGIN
		SELECT *
			INTO p_csh_transaction_rec
			FROM csh_transaction t
		 WHERE t.transaction_id = p_transaction_id
			 FOR UPDATE NOWAIT;
	
	EXCEPTION
		WHEN e_lock_trx_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_LOCK',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'lock_csh_transaction');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--更新现金事务核销状态（包括已核销金额）
	PROCEDURE set_csh_trx_write_off_status(p_csh_trx_rec      csh_transaction%ROWTYPE,
																				 p_write_off_amount NUMBER,
																				 p_user_id          NUMBER) IS
	
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		v_sum_write_off_amt   NUMBER := 0;
		v_sum_check_amount    NUMBER := 0;
		v_write_off_flag      VARCHAR2(30);
		v_last_write_off_date DATE;
	
		e_write_off_amount_error EXCEPTION;
	BEGIN
		IF p_csh_trx_rec.transaction_type = csh_trx_type_deduction THEN
			RETURN;
		END IF;
	
		lock_csh_transaction(p_transaction_id      => p_csh_trx_rec.transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		v_sum_write_off_amt := nvl(p_write_off_amount, 0) +
													 nvl(v_csh_transaction_rec.write_off_amount, 0);
		v_sum_check_amount  := nvl(p_write_off_amount, 0) +
													 nvl(v_csh_transaction_rec.write_off_amount, 0) +
													 nvl(v_csh_transaction_rec.returned_amount, 0);
		IF v_sum_check_amount = 0 THEN
			v_write_off_flag      := csh_trx_write_off_flag_n;
			v_last_write_off_date := v_csh_transaction_rec.full_write_off_date;
		ELSIF v_sum_check_amount > 0 AND
					v_sum_check_amount < v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag      := csh_trx_write_off_flag_p;
			v_last_write_off_date := v_csh_transaction_rec.full_write_off_date;
		ELSIF v_sum_check_amount = v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag      := csh_trx_write_off_flag_f;
			v_last_write_off_date := csh_write_off_pkg.get_last_write_off_date(p_transaction_id => v_csh_transaction_rec.transaction_id);
		ELSE
			RAISE e_write_off_amount_error;
		END IF;
	
		UPDATE csh_transaction t
			 SET t.write_off_flag      = v_write_off_flag,
					 t.write_off_amount    = v_sum_write_off_amt,
					 t.full_write_off_date = v_last_write_off_date,
					 t.last_update_date    = SYSDATE,
					 t.last_updated_by     = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	
	EXCEPTION
		WHEN e_write_off_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_WRITE_OFF_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'set_csh_trx_write_off_status');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--更新退款现金事务信息
	PROCEDURE update_csh_trx_after_return(p_transaction_id  NUMBER,
																				p_returned_amount NUMBER,
																				p_user_id         NUMBER) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		v_returned_flag       csh_transaction.returned_flag%TYPE;
		v_write_off_flag      csh_transaction.write_off_flag%TYPE;
	
		v_sum_returned_amount NUMBER := 0;
		v_sum_writeoff_amount NUMBER := 0;
	
		e_sum_returned_amount_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		v_sum_returned_amount := nvl(v_csh_transaction_rec.returned_amount, 0) +
														 nvl(p_returned_amount, 0);
		v_sum_writeoff_amount := nvl(v_csh_transaction_rec.returned_amount, 0) +
														 nvl(p_returned_amount, 0) +
														 nvl(v_csh_transaction_rec.write_off_amount, 0);
	
		IF v_sum_writeoff_amount = v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag := csh_trx_write_off_flag_f;
		ELSIF v_sum_writeoff_amount = 0 THEN
			v_write_off_flag := csh_trx_write_off_flag_n;
		ELSIF v_sum_writeoff_amount > 0 AND
					v_sum_writeoff_amount < v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag := csh_trx_write_off_flag_p;
		ELSE
			RAISE e_sum_returned_amount_error;
		END IF;
	
		IF v_sum_returned_amount = v_csh_transaction_rec.transaction_amount THEN
			v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_f;
		ELSIF v_sum_returned_amount = 0 THEN
			v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_n;
		ELSIF v_sum_returned_amount > 0 AND
					v_sum_returned_amount < v_csh_transaction_rec.transaction_amount THEN
			v_returned_flag := csh_transaction_pkg.csh_trx_return_flag_p;
		ELSE
			RAISE e_sum_returned_amount_error;
		END IF;
	
		UPDATE csh_transaction t
			 SET t.returned_flag    = v_returned_flag,
					 t.returned_amount  = v_sum_returned_amount,
					 t.write_off_flag   = v_write_off_flag,
					 t.last_update_date = SYSDATE,
					 t.last_updated_by  = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	EXCEPTION
		WHEN e_sum_returned_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_RETURNED_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_csh_trx_after_return');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--更新被反冲现金事务
	PROCEDURE update_csh_trx_after_reverse(p_transaction_id      NUMBER,
																				 p_reversed_date       DATE,
																				 p_reserved_csh_trx_id NUMBER,
																				 p_user_id             NUMBER) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		UPDATE csh_transaction t
			 SET t.reversed_flag       = csh_transaction_pkg.csh_trx_reversed_flag_w,
					 t.reversed_date       = p_reversed_date,
					 t.reversed_csh_trx_id = p_reserved_csh_trx_id,
					 t.last_update_date    = SYSDATE,
					 t.last_updated_by     = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	END;

	--退款反冲后更新原退款现金事务信息
	PROCEDURE upd_rtn_csh_trx_after_reverse(p_transaction_id NUMBER,
																					p_user_id        NUMBER) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		v_source_csh_trx_rec  csh_transaction%ROWTYPE;
		v_returned_flag       csh_transaction.returned_flag%TYPE;
		v_write_off_flag      csh_transaction.write_off_flag%TYPE;
		v_sum_returned_amount NUMBER := 0;
		v_sum_writeoff_amount NUMBER := 0;
		e_sum_returned_amount_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		lock_csh_transaction(p_transaction_id      => v_csh_transaction_rec.return_from_csh_trx_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_source_csh_trx_rec);
	
		v_sum_returned_amount := nvl(v_source_csh_trx_rec.returned_amount, 0) -
														 nvl(v_csh_transaction_rec.transaction_amount, 0);
	
		v_sum_writeoff_amount := v_sum_returned_amount +
														 nvl(v_source_csh_trx_rec.write_off_amount, 0);
	
		IF v_sum_writeoff_amount = v_source_csh_trx_rec.transaction_amount THEN
			v_write_off_flag := csh_trx_write_off_flag_f;
		ELSIF v_sum_writeoff_amount = 0 THEN
			v_write_off_flag := csh_trx_write_off_flag_n;
		ELSIF v_sum_writeoff_amount > 0 AND
					v_sum_writeoff_amount < v_source_csh_trx_rec.transaction_amount THEN
			v_write_off_flag := csh_trx_write_off_flag_p;
		ELSE
			RAISE e_sum_returned_amount_error;
		END IF;
	
		IF v_sum_returned_amount = 0 THEN
			v_returned_flag := csh_trx_return_flag_n;
		ELSIF v_sum_returned_amount = v_source_csh_trx_rec.transaction_amount THEN
			v_returned_flag := csh_trx_return_flag_f;
		ELSIF v_sum_returned_amount > 0 AND
					v_sum_returned_amount < v_source_csh_trx_rec.transaction_amount THEN
			v_returned_flag := csh_trx_return_flag_p;
		ELSE
			RAISE e_sum_returned_amount_error;
		END IF;
	
		UPDATE csh_transaction t
			 SET t.returned_amount  = v_sum_returned_amount,
					 t.returned_flag    = v_returned_flag,
					 t.last_update_date = SYSDATE,
					 t.last_updated_by  = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.return_from_csh_trx_id;
	EXCEPTION
		WHEN e_sum_returned_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_RETURNED_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'upd_rtn_csh_trx_after_reverse');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--核销反冲后更新被反冲现金事务核销金额
	PROCEDURE update_trx_amt_after_reverse(p_transaction_id NUMBER,
																				 p_reverse_amount NUMBER,
																				 p_user_id        NUMBER) IS
		v_csh_transaction_rec  csh_transaction%ROWTYPE;
		v_sum_write_off_amount NUMBER;
	
		v_sum_check_amount    NUMBER;
		v_write_off_flag      VARCHAR2(30);
		v_last_write_off_date DATE;
		e_sum_writeoff_amount_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		v_sum_write_off_amount := nvl(v_csh_transaction_rec.write_off_amount, 0) -
															nvl(p_reverse_amount, 0);
	
		v_sum_check_amount := nvl(v_csh_transaction_rec.write_off_amount, 0) +
													nvl(v_csh_transaction_rec.returned_amount, 0) -
													nvl(p_reverse_amount, 0);
	
		IF v_sum_check_amount = 0 THEN
			v_write_off_flag      := csh_trx_write_off_flag_n;
			v_last_write_off_date := NULL;
		ELSIF v_sum_check_amount > 0 AND
					v_sum_check_amount < v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag      := csh_trx_write_off_flag_p;
			v_last_write_off_date := NULL;
		ELSIF v_sum_check_amount = v_csh_transaction_rec.transaction_amount THEN
			v_write_off_flag      := csh_trx_write_off_flag_f;
			v_last_write_off_date := csh_write_off_pkg.get_last_write_off_date(p_transaction_id => v_csh_transaction_rec.transaction_id);
		ELSE
			RAISE e_sum_writeoff_amount_error;
		END IF;
	
		UPDATE csh_transaction t
			 SET t.write_off_amount    = v_sum_write_off_amount,
					 t.write_off_flag      = v_write_off_flag,
					 t.full_write_off_date = v_last_write_off_date,
					 t.last_update_date    = SYSDATE,
					 t.last_updated_by     = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	EXCEPTION
		WHEN e_sum_writeoff_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH_WRITEOFF_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_trx_amt_after_reverse');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--更新银行水单
	PROCEDURE update_bank_slip_num(p_transaction_id csh_transaction.transaction_id%TYPE,
																 p_bank_slip_num  csh_transaction.bank_slip_num%TYPE,
																 p_user_id        csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		UPDATE csh_transaction t
			 SET t.bank_slip_num    = p_bank_slip_num,
					 t.last_update_date = SYSDATE,
					 t.last_updated_by  = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	END;
	FUNCTION is_trx_return(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_yes) <>
			 csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_POSTED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.returned_flag, csh_transaction_pkg.csh_trx_return_flag_n) =
					csh_transaction_pkg.csh_trx_return_flag_f THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_RETURN_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.reversed_flag, csh_transaction_pkg.csh_trx_reversed_flag_n) <>
					csh_transaction_pkg.csh_trx_reversed_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_REVERSED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.write_off_flag, csh_transaction_pkg.csh_trx_write_off_flag_n) =
					csh_transaction_pkg.csh_trx_write_off_flag_f THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_WRITE_OFF_FLAG_ERROR';
			RETURN FALSE;
		ELSE
			RETURN TRUE;
		END IF;
	END;
	FUNCTION is_trx_reverse(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_trx_posted_flag_yes) <> csh_trx_posted_flag_yes THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_POSTED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) NOT IN
					(csh_trx_return_flag_n, csh_trx_return_flag_return) THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_RETURN_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.reversed_flag, csh_trx_reversed_flag_n) <>
					csh_trx_reversed_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_REVERSED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.write_off_flag, csh_trx_write_off_flag_n) <>
					csh_trx_write_off_flag_n AND
					nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) <>
					csh_trx_return_flag_return AND
					p_csh_transaction_rec.transaction_type <> csh_trx_type_payment THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_WRITE_OFF_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.write_off_flag, csh_trx_write_off_flag_n) <>
					csh_trx_write_off_flag_f AND
					nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) <>
					csh_trx_return_flag_n AND
					p_csh_transaction_rec.transaction_type = csh_trx_type_payment THEN
			v_err_code := 'CSH_TRANSACTION_PKG.PAYMENT_REVERSE_WRITE_OFF_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) =
					csh_trx_return_flag_return AND
					nvl(p_csh_transaction_rec.write_off_flag, csh_trx_write_off_flag_n) <>
					csh_trx_write_off_flag_f THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_WRITE_OFF_FLAG_ERROR';
			RETURN FALSE;
		ELSE
			RETURN TRUE;
		END IF;
	END;

	FUNCTION is_trx_post(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
			 csh_transaction_pkg.csh_trx_posted_flag_no THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
	FUNCTION is_trx_update(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
			 csh_transaction_pkg.csh_trx_posted_flag_no THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
	FUNCTION is_trx_update_after_post(p_csh_transaction_rec IN csh_transaction%ROWTYPE)
		RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) <>
			 csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_POST_STATUS_CHECK';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.reversed_flag, csh_transaction_pkg.csh_trx_reversed_flag_n) <>
					csh_transaction_pkg.csh_trx_reversed_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_REVERSE_FLAG_CHECK';
			RETURN FALSE;
		ELSE
			RETURN TRUE;
		END IF;
	END;
	FUNCTION is_trx_delete(p_csh_transaction_rec IN csh_transaction%ROWTYPE) RETURN BOOLEAN IS
	BEGIN
		IF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) <>
			 csh_transaction_pkg.csh_trx_posted_flag_no THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_STATUS_CHECK';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.reversed_flag, csh_transaction_pkg.csh_trx_reversed_flag_n) <>
					csh_transaction_pkg.csh_trx_reversed_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_REVERSE_CHECK';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.returned_flag, csh_transaction_pkg.csh_trx_return_flag_n) <>
					csh_transaction_pkg.csh_trx_return_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_RETURN_CHECK';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.write_off_flag, csh_transaction_pkg.csh_trx_write_off_flag_n) <>
					csh_transaction_pkg.csh_trx_write_off_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_DELETE_WRITEOFF_CHECK';
			RETURN FALSE;
		ELSE
			RETURN TRUE;
		END IF;
	END;
	PROCEDURE insert_csh_transaction(p_csh_transaction_rec IN OUT csh_transaction%ROWTYPE) IS
	BEGIN
		IF p_csh_transaction_rec.transaction_id IS NULL THEN
			SELECT csh_transaction_s.nextval INTO p_csh_transaction_rec.transaction_id FROM dual;
		END IF;
		INSERT INTO csh_transaction VALUES p_csh_transaction_rec;
	END;

	/*add by xuls for ref_contract_id 2014-9-26
   用于增加记录收款合同号
  */
	PROCEDURE insert_csh_transaction(p_transaction_id          OUT csh_transaction.transaction_id%TYPE,
																	 p_transaction_num         csh_transaction.transaction_num%TYPE,
																	 p_transaction_category    csh_transaction.transaction_category%TYPE,
																	 p_transaction_type        csh_transaction.transaction_type%TYPE,
																	 p_transaction_date        csh_transaction.transaction_date%TYPE,
																	 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																	 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																	 p_company_id              csh_transaction.company_id%TYPE,
																	 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																	 p_period_name             csh_transaction.period_name%TYPE,
																	 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																	 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																	 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																	 p_currency_code           csh_transaction.currency_code%TYPE,
																	 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																	 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																	 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																	 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																	 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																	 p_bp_category             csh_transaction.bp_category%TYPE,
																	 p_bp_id                   csh_transaction.bp_id%TYPE,
																	 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																	 p_bp_bank_account_name    csh_transaction.bp_bank_account_name%TYPE DEFAULT NULL, --add by Spener 3893 20160722
																	 p_description             csh_transaction.description%TYPE,
																	 p_handling_charge         csh_transaction.handling_charge%TYPE,
																	 p_posted_flag             csh_transaction.posted_flag%TYPE,
																	 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																	 p_reversed_date           csh_transaction.reversed_date%TYPE,
																	 p_returned_flag           csh_transaction.returned_flag%TYPE,
																	 p_returned_amount         csh_transaction.returned_amount%TYPE,
																	 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																	 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																	 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																	 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																	 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																	 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																	 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																	 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																	 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																	 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																	 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																	 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																	 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																	 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																	 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																	 p_user_id                 csh_transaction.created_by%TYPE,
																	 p_ref_contract_id         csh_transaction.ref_contract_id%TYPE DEFAULT NULL,
																	 p_receipt_type            csh_transaction.receipt_type%TYPE DEFAULT NULL,
																	 p_csh_bp_name             csh_transaction.csh_bp_name%TYPE DEFAULT NULL) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		v_transaction_num     csh_transaction.transaction_num%TYPE;
	
		e_trx_num_error EXCEPTION;
		v_csh_transaction_id NUMBER;
	BEGIN
		SELECT csh_transaction_s.nextval INTO v_csh_transaction_id FROM dual;
		v_csh_transaction_rec.transaction_id := v_csh_transaction_id;
		IF p_transaction_num IS NULL THEN
			v_transaction_num := get_csh_transaction_num(p_transaction_type => p_transaction_type,
																									 p_company_id       => p_company_id,
																									 p_transaction_date => p_transaction_date,
																									 p_user_id          => p_user_id);
		ELSE
			v_transaction_num := p_transaction_num;
		END IF;
	
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
		v_csh_transaction_rec.posted_flag             := csh_transaction_pkg.csh_trx_posted_flag_no;
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
		v_csh_transaction_rec.create_je_flag          := nvl(p_create_je_flag, 'N');
		v_csh_transaction_rec.gld_interface_flag      := nvl(p_gld_interface_flag, 'N');
		v_csh_transaction_rec.creation_date           := SYSDATE;
		v_csh_transaction_rec.created_by              := p_user_id;
		v_csh_transaction_rec.last_update_date        := SYSDATE;
		v_csh_transaction_rec.last_updated_by         := p_user_id;
		v_csh_transaction_rec.csh_bp_name             := p_csh_bp_name;
		/*add by xuls for ref_contract_id 2014-9-26
     用于增加记录收款合同号
    */
		v_csh_transaction_rec.ref_contract_id := p_ref_contract_id;
	
		insert_csh_transaction(v_csh_transaction_rec);
	
		check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec, p_user_id => p_user_id);
	
		--针对界面保存并过账按钮处理
		IF nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
			 csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
													 p_user_id        => p_user_id);
		END IF;
		p_transaction_id := v_csh_transaction_rec.transaction_id;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'insert_csh_transaction');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	/*add by xuls for ref_contract_id 2014-9-26
   用于增加记录收款合同号
  */
	PROCEDURE update_csh_transaction(p_transaction_id          csh_transaction.transaction_id%TYPE,
																	 p_transaction_num         csh_transaction.transaction_num%TYPE,
																	 p_transaction_category    csh_transaction.transaction_category%TYPE,
																	 p_transaction_type        csh_transaction.transaction_type%TYPE,
																	 p_transaction_date        csh_transaction.transaction_date%TYPE,
																	 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																	 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																	 p_company_id              csh_transaction.company_id%TYPE,
																	 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																	 p_period_name             csh_transaction.period_name%TYPE,
																	 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																	 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																	 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																	 p_currency_code           csh_transaction.currency_code%TYPE,
																	 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																	 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																	 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																	 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																	 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																	 p_bp_category             csh_transaction.bp_category%TYPE,
																	 p_bp_id                   csh_transaction.bp_id%TYPE,
																	 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																	 p_description             csh_transaction.description%TYPE,
																	 p_handling_charge         csh_transaction.handling_charge%TYPE,
																	 p_posted_flag             csh_transaction.posted_flag%TYPE,
																	 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																	 p_reversed_date           csh_transaction.reversed_date%TYPE,
																	 p_returned_flag           csh_transaction.returned_flag%TYPE,
																	 p_returned_amount         csh_transaction.returned_amount%TYPE,
																	 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																	 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																	 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																	 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																	 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																	 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																	 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																	 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																	 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																	 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																	 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																	 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																	 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																	 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																	 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																	 p_user_id                 csh_transaction.created_by%TYPE,
																	 p_ref_contract_id         csh_transaction.ref_contract_id%TYPE DEFAULT NULL) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		e_status_error           EXCEPTION;
		e_transaction_type_error EXCEPTION;
	BEGIN
	
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		IF NOT is_trx_update(v_csh_transaction_rec) THEN
			RAISE e_status_error;
		END IF;
	
		IF v_csh_transaction_rec.transaction_type <> csh_transaction_pkg.csh_trx_type_receipt THEN
			RAISE e_transaction_type_error;
		END IF;
	
		v_csh_transaction_rec.transaction_amount := p_transaction_amount;
		v_csh_transaction_rec.bank_account_id    := p_bank_account_id;
	
		check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec, p_user_id => p_user_id);
	
		UPDATE csh_transaction t1
			 SET t1.transaction_category    = p_transaction_category,
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
					 t1.last_update_date        = SYSDATE,
					 t1.last_updated_by         = p_user_id,
					 t1.ref_contract_id         = p_ref_contract_id
		 WHERE t1.transaction_id = p_transaction_id;
		--针对界面保存并过账按钮处理
		IF nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
			 csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
													 p_user_id        => p_user_id);
		END IF;
	EXCEPTION
		WHEN e_status_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_UPDATE_STATUS_CHECK',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_status_check');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_transaction_type_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_TRANSACTION_TYPE_CHECK',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_status_check');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'update_csh_transaction');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--货币兑换维护
	PROCEDURE update_currency_exchange_trx(p_transaction_id          csh_transaction.transaction_id%TYPE,
																				 p_transaction_num         csh_transaction.transaction_num%TYPE,
																				 p_transaction_category    csh_transaction.transaction_category%TYPE,
																				 p_transaction_type        csh_transaction.transaction_type%TYPE,
																				 p_transaction_date        csh_transaction.transaction_date%TYPE,
																				 p_penalty_calc_date       csh_transaction.penalty_calc_date%TYPE,
																				 p_bank_slip_num           csh_transaction.bank_slip_num%TYPE,
																				 p_company_id              csh_transaction.company_id%TYPE,
																				 p_internal_period_num     csh_transaction.internal_period_num%TYPE,
																				 p_period_name             csh_transaction.period_name%TYPE,
																				 p_payment_method_id       csh_transaction.payment_method_id%TYPE,
																				 p_distribution_set_id     csh_transaction.distribution_set_id%TYPE,
																				 p_cashflow_amount         csh_transaction.cashflow_amount%TYPE,
																				 p_currency_code           csh_transaction.currency_code%TYPE,
																				 p_transaction_amount      csh_transaction.transaction_amount%TYPE,
																				 p_exchange_rate_type      csh_transaction.exchange_rate_type%TYPE,
																				 p_exchange_rate_quotation csh_transaction.exchange_rate_quotation%TYPE,
																				 p_exchange_rate           csh_transaction.exchange_rate%TYPE,
																				 p_bank_account_id         csh_transaction.bank_account_id%TYPE,
																				 p_bp_category             csh_transaction.bp_category%TYPE,
																				 p_bp_id                   csh_transaction.bp_id%TYPE,
																				 p_bp_bank_account_id      csh_transaction.bp_bank_account_id%TYPE,
																				 p_bp_bank_account_num     csh_transaction.bp_bank_account_num%TYPE,
																				 p_description             csh_transaction.description%TYPE,
																				 p_handling_charge         csh_transaction.handling_charge%TYPE,
																				 p_posted_flag             csh_transaction.posted_flag%TYPE,
																				 p_reversed_flag           csh_transaction.reversed_flag%TYPE,
																				 p_reversed_date           csh_transaction.reversed_date%TYPE,
																				 p_returned_flag           csh_transaction.returned_flag%TYPE,
																				 p_returned_amount         csh_transaction.returned_amount%TYPE,
																				 p_write_off_flag          csh_transaction.write_off_flag%TYPE,
																				 p_write_off_amount        csh_transaction.write_off_amount%TYPE,
																				 p_full_write_off_date     csh_transaction.full_write_off_date%TYPE,
																				 p_twin_csh_trx_id         csh_transaction.twin_csh_trx_id%TYPE,
																				 p_return_from_csh_trx_id  csh_transaction.return_from_csh_trx_id%TYPE,
																				 p_reversed_csh_trx_id     csh_transaction.reversed_csh_trx_id%TYPE,
																				 p_source_csh_trx_type     csh_transaction.source_csh_trx_type%TYPE,
																				 p_source_csh_trx_id       csh_transaction.source_csh_trx_id%TYPE,
																				 p_source_doc_category     csh_transaction.source_doc_category%TYPE,
																				 p_source_doc_type         csh_transaction.source_doc_type%TYPE,
																				 p_source_doc_id           csh_transaction.source_doc_id%TYPE,
																				 p_source_doc_line_id      csh_transaction.source_doc_line_id%TYPE,
																				 p_create_je_mothed        csh_transaction.create_je_mothed%TYPE,
																				 p_create_je_flag          csh_transaction.create_je_flag%TYPE,
																				 p_gld_interface_flag      csh_transaction.gld_interface_flag%TYPE,
																				 p_user_id                 csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		e_status_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		IF NOT is_trx_update(v_csh_transaction_rec) THEN
			RAISE e_status_error;
		END IF;
	
		v_csh_transaction_rec.transaction_amount := p_transaction_amount;
		v_csh_transaction_rec.bank_account_id    := p_bank_account_id;
	
		check_zero_amount(p_csh_transaction_rec => v_csh_transaction_rec, p_user_id => p_user_id);
	
		UPDATE csh_transaction t1
			 SET t1.transaction_category    = p_transaction_category,
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
					 t1.last_update_date        = SYSDATE,
					 t1.last_updated_by         = p_user_id
		 WHERE t1.transaction_id = p_transaction_id;
		--针对界面保存并过账按钮处理
		IF nvl(p_posted_flag, csh_transaction_pkg.csh_trx_posted_flag_no) =
			 csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			post_csh_transaction(p_transaction_id => v_csh_transaction_rec.transaction_id,
													 p_user_id        => p_user_id);
		END IF;
	EXCEPTION
		WHEN e_status_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.CSH510_UPDATE_STATUS_CHECK',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_currency_exchange_trx');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'update_currency_exchange_trx');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--货币兑换互记TWIN_CSH_TRX_ID
	PROCEDURE save_twin_csh_trx_id(p_transaction_num csh_transaction.transaction_num%TYPE,
																 p_user_id         NUMBER) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	BEGIN
		FOR r_trx_rec IN (SELECT d.transaction_id
												FROM csh_transaction d
											 WHERE d.transaction_num = p_transaction_num) LOOP
			lock_csh_transaction(p_transaction_id      => r_trx_rec.transaction_id,
													 p_user_id             => p_user_id,
													 p_csh_transaction_rec => v_csh_transaction_rec);
			UPDATE csh_transaction c
				 SET c.twin_csh_trx_id  = r_trx_rec.transaction_id,
						 c.last_updated_by  = p_user_id,
						 c.last_update_date = SYSDATE
			 WHERE c.transaction_num = p_transaction_num
				 AND c.transaction_id <> r_trx_rec.transaction_id;
		END LOOP;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'save_twin_csh_trx_id');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--货币兑换过账以后维护
	PROCEDURE upd_currency_trx_after_post(p_transaction_id csh_transaction.transaction_id%TYPE,
																				p_bank_slip_num  csh_transaction.bank_slip_num%TYPE,
																				p_description    csh_transaction.description%TYPE,
																				p_user_id        csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		e_flag_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		IF NOT is_trx_update_after_post(v_csh_transaction_rec) THEN
			RAISE e_flag_error;
		END IF;
	
		UPDATE csh_transaction t
			 SET t.bank_slip_num    = p_bank_slip_num,
					 t.description      = p_description,
					 t.last_update_date = SYSDATE,
					 t.last_updated_by  = p_user_id
		 WHERE t.transaction_id = p_transaction_id;
	EXCEPTION
		WHEN e_flag_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'upd_currency_trx_after_post');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'upd_currency_trx_after_post');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--过账以后维护
	PROCEDURE update_csh_transaction_post(p_transaction_id     csh_transaction.transaction_id%TYPE,
																				p_bank_slip_num      csh_transaction.bank_slip_num%TYPE,
																				p_bp_bank_account_id csh_transaction.bp_bank_account_id%TYPE,
																				p_user_id            csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_flag_error EXCEPTION;
	BEGIN
	
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
		/*IF NOT is_trx_update_after_post(v_csh_transaction_rec) THEN
      RAISE e_flag_error;
    END IF;*/
	
		UPDATE csh_transaction t
			 SET t.bank_slip_num      = p_bank_slip_num,
					 t.bp_bank_account_id = p_bp_bank_account_id,
					 t.last_update_date   = SYSDATE,
					 t.last_updated_by    = p_user_id
		 WHERE t.transaction_id = p_transaction_id;
	
	EXCEPTION
		WHEN e_flag_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'update_status_check');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'update_csh_transaction_post');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE update_csh_post_flag(p_transaction_id NUMBER,
																 p_user_id        NUMBER,
																 p_claim          VARCHAR2 DEFAULT NULL) IS
	BEGIN
		IF p_claim IS NULL THEN
			UPDATE csh_transaction ct
				 SET ct.posted_flag     = 'Y',
						 ct.last_updated_by = p_user_id
			 WHERE ct.transaction_id = p_transaction_id;
		ELSIF p_claim = 'F' THEN
			UPDATE csh_transaction ct
				 SET ct.posted_flag     = 'F',
						 ct.last_updated_by = p_user_id
			 WHERE ct.transaction_id = p_transaction_id;
		ELSIF p_claim = 'Y' THEN
			UPDATE csh_transaction ct
				 SET ct.posted_flag     = 'Y',
						 ct.last_updated_by = p_user_id
			 WHERE ct.transaction_id = p_transaction_id;
		END IF;
	END;

	PROCEDURE delete_csh_transaction(p_transaction_id csh_transaction.transaction_id%TYPE,
																	 p_user_id        csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_status_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
	
		IF NOT is_trx_delete(v_csh_transaction_rec) THEN
			RAISE e_status_error;
		END IF;
	
		DELETE FROM csh_transaction t WHERE t.transaction_id = p_transaction_id;
	
	EXCEPTION
		WHEN e_status_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'delete_status_check',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'delete_csh_transaction');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	PROCEDURE post_csh_transaction(p_transaction_id csh_transaction.transaction_id%TYPE,
																 p_user_id        csh_transaction.created_by%TYPE) IS
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_status_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
	
		IF NOT is_trx_post(v_csh_transaction_rec) THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH510_POSTED_ERROR';
			RAISE e_status_error;
		END IF;
		UPDATE csh_transaction t
			 SET t.posted_flag      = csh_transaction_pkg.csh_trx_posted_flag_yes,
					 t.last_update_date = SYSDATE,
					 t.last_updated_by  = p_user_id
		 WHERE t.transaction_id = v_csh_transaction_rec.transaction_id;
	
		--现金事务过账生成的凭证
		IF nvl(v_csh_transaction_rec.reversed_flag, 'N') <>
			 csh_transaction_pkg.csh_trx_reversed_flag_r THEN
			--现金事务过账生成的凭证
			csh_transaction_je_pkg.create_transaction_je(p_transaction_id => p_transaction_id,
																									 p_user_id        => p_user_id);
		END IF;
	
		csh_transaction_custom_pkg.after_post_trx(p_transaction_id => p_transaction_id,
																							p_user_id        => p_user_id);
	
		/*--反冲过后，将合同状态改为SIGN add by yuanyang for mxfl_project;                                  
    UPDATE con_contract
       SET contract_status = 'SIGN',
           user_status_1   = 'UNDER_LENT'
     WHERE contract_id = (SELECT cl.ref_doc_id
                            FROM csh_payment_req_ln cl
                           WHERE cl.payment_req_id =
                                 (SELECT source_doc_id
                                    FROM csh_transaction
                                   WHERE transaction_id = p_transaction_id));*/
	
	EXCEPTION
		WHEN e_status_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'post_csh_transaction',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--通用的反冲入口（收款反冲，付款反冲,收款退款反冲，预收款退款反冲）
	PROCEDURE reverse_csh_transaction(p_transaction_id         csh_transaction.transaction_id%TYPE,
																		p_reversed_date          csh_transaction.reversed_date%TYPE,
																		p_description            csh_transaction.description%TYPE,
																		p_user_id                csh_transaction.created_by%TYPE,
																		p_reverse_transaction_id OUT csh_transaction.transaction_id%TYPE) IS
	
		v_period_name         VARCHAR2(30);
		v_transaction_id      NUMBER;
		v_write_off_id        NUMBER;
		v_internal_period_num gld_periods.internal_period_num%TYPE;
	
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_reverse_error EXCEPTION;
	BEGIN
	
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
	
		IF NOT is_trx_reverse(v_csh_transaction_rec) THEN
			RAISE e_reverse_error;
		END IF;
	
		--校验反冲日期
		IF p_reversed_date < v_csh_transaction_rec.transaction_date THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_DATE_ERROR';
			RAISE e_reverse_error;
		END IF;
		-- 期间
		v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_csh_transaction_rec.company_id,
																												p_date       => p_reversed_date);
		IF v_period_name IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_ERROR';
			RAISE e_reverse_error;
		END IF;
		v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_csh_transaction_rec.company_id,
																																				p_period_name => v_period_name);
		IF v_internal_period_num IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_NUM_ERROR';
			RAISE e_reverse_error;
		END IF;
		--预收款和收款的退款反冲
		IF v_csh_transaction_rec.transaction_category = csh_trx_category_business AND
			 (v_csh_transaction_rec.transaction_type = csh_trx_type_prereceipt OR
			 nvl(v_csh_transaction_rec.returned_flag, csh_trx_return_flag_n) =
			 csh_trx_return_flag_return) THEN
			--退款反冲后更新原退款现金事务信息
			IF v_csh_transaction_rec.returned_flag = csh_trx_return_flag_return THEN
				upd_rtn_csh_trx_after_reverse(p_transaction_id => p_transaction_id,
																			p_user_id        => p_user_id);
			END IF;
			FOR csh_write_off_rec IN (SELECT *
																	FROM csh_write_off t
																 WHERE t.subsequent_csh_trx_id = p_transaction_id
																	 AND nvl(t.reversed_flag, csh_trx_reversed_flag_n) =
																			 csh_trx_reversed_flag_n) LOOP
				csh_write_off_pkg.reverse_write_off(p_reverse_write_off_id => v_write_off_id,
																						p_write_off_id         => csh_write_off_rec.write_off_id,
																						p_reversed_date        => p_reversed_date,
																						p_description          => p_description,
																						p_user_id              => p_user_id,
																						p_from_csh_trx_flag    => 'Y');
			END LOOP;
			--付款反冲中的支付反冲
		ELSIF v_csh_transaction_rec.transaction_category = csh_trx_category_business AND
					v_csh_transaction_rec.transaction_type = csh_trx_type_payment THEN
			--更新付款申请
			csh_payment_req_pkg.upd_csh_payment_after_reverse(p_transaction_id => p_transaction_id,
																												p_user_id        => p_user_id);
			FOR csh_write_off_rec IN (SELECT *
																	FROM csh_write_off t
																 WHERE t.csh_transaction_id = p_transaction_id
																	 AND nvl(t.reversed_flag, csh_trx_reversed_flag_n) =
																			 csh_trx_reversed_flag_n) LOOP
				csh_write_off_pkg.reverse_write_off(p_reverse_write_off_id => v_write_off_id,
																						p_write_off_id         => csh_write_off_rec.write_off_id,
																						p_reversed_date        => p_reversed_date,
																						p_description          => p_description,
																						p_user_id              => p_user_id,
																						p_from_csh_trx_flag    => 'Y');
			END LOOP;
		END IF;
	
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
													 p_cashflow_amount         => -1 * v_csh_transaction_rec.cashflow_amount,
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
	EXCEPTION
		WHEN e_reverse_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'reverse_csh_transaction',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'reverse_csh_transaction');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--收款反冲入口
	PROCEDURE reverse_receipt_csh_trx(p_transaction_id csh_transaction.transaction_id%TYPE,
																		p_reversed_date  csh_transaction.reversed_date%TYPE,
																		p_bank_slip_num  csh_transaction.bank_slip_num%TYPE,
																		p_description    csh_transaction.description%TYPE,
																		p_user_id        csh_transaction.created_by%TYPE) IS
		e_reverse_error EXCEPTION;
		v_csh_transaction_rec csh_transaction%ROWTYPE;
		v_transaction_id      csh_transaction.transaction_id%TYPE;
	BEGIN
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
	
		/*-- 反冲回来 过账标志变为N
    UPDATE csh_transaction ct
       SET ct.posted_flag   = 'N',
           ct.reversed_flag = 'N'
     WHERE ct.transaction_id = p_transaction_id;*/
	
	EXCEPTION
		WHEN e_reverse_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'reverse_receipt_csh_trx',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'reverse_receipt_csh_trx');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--收款退款入口
	PROCEDURE return_csh_transaction(p_transaction_id      csh_transaction.transaction_id%TYPE,
																	 p_returned_date       DATE,
																	 p_returned_amount     csh_transaction.returned_amount%TYPE,
																	 p_bank_slip_num       csh_transaction.bank_slip_num%TYPE,
																	 p_payment_method_id   csh_transaction.payment_method_id%TYPE,
																	 p_bank_account_id     csh_transaction.bank_account_id%TYPE,
																	 p_bp_bank_account_id  csh_transaction.bp_bank_account_id%TYPE,
																	 p_bp_bank_account_num csh_transaction.bp_bank_account_num%TYPE,
																	 p_description         csh_transaction.description%TYPE,
																	 p_user_id             csh_transaction.created_by%TYPE) IS
		v_period_name         VARCHAR2(30);
		v_transaction_id      NUMBER;
		v_write_off_id        NUMBER;
		v_internal_period_num gld_periods.internal_period_num%TYPE;
	
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_return_error EXCEPTION;
	BEGIN
		lock_csh_transaction(p_transaction_id      => p_transaction_id,
												 p_user_id             => p_user_id,
												 p_csh_transaction_rec => v_csh_transaction_rec);
	
		IF NOT csh_transaction_pkg.is_trx_return(v_csh_transaction_rec) THEN
			v_err_code := 'CSH_TRANSACTION_PKG.CSH_TRX_RETURN_FLAG_ERROR';
			RAISE e_return_error;
		END IF;
		--校验退款日期
		IF p_returned_date < v_csh_transaction_rec.transaction_date THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_DATE_ERROR';
			RAISE e_return_error;
		END IF;
		-- 期间
		v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_csh_transaction_rec.company_id,
																												p_date       => p_returned_date);
		IF v_period_name IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_PERIOD_ERROR';
			RAISE e_return_error;
		END IF;
		v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_csh_transaction_rec.company_id,
																																				p_period_name => v_period_name);
		IF v_internal_period_num IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.RETURN_PERIOD_NUM_ERROR';
			RAISE e_return_error;
		END IF;
	
		insert_csh_transaction(p_transaction_id          => v_transaction_id,
													 p_transaction_num         => '',
													 p_transaction_category    => v_csh_transaction_rec.transaction_category,
													 p_transaction_type        => v_csh_transaction_rec.transaction_type,
													 p_transaction_date        => p_returned_date,
													 p_penalty_calc_date       => '',
													 p_bank_slip_num           => p_bank_slip_num,
													 p_company_id              => v_csh_transaction_rec.company_id,
													 p_internal_period_num     => v_internal_period_num,
													 p_period_name             => v_period_name,
													 p_payment_method_id       => p_payment_method_id,
													 p_distribution_set_id     => v_csh_transaction_rec.distribution_set_id,
													 p_cashflow_amount         => -1 * p_returned_amount,
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
		IF v_csh_transaction_rec.transaction_type IN (csh_trx_type_prereceipt, csh_trx_type_receipt) THEN
		
			csh_write_off_pkg.return_write_off(p_return_write_off_id   => v_write_off_id,
																				 p_transaction_id        => p_transaction_id,
																				 p_return_transaction_id => v_transaction_id,
																				 p_returned_date         => p_returned_date,
																				 p_returned_amount       => p_returned_amount,
																				 p_description           => p_description,
																				 p_user_id               => p_user_id);
		END IF;
	EXCEPTION
		WHEN e_return_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_transaction_pkg',
																											p_procedure_function_name => 'return_csh_transaction',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_transaction_pkg',
																										 p_procedure_function_name => 'return_csh_transaction');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	---add by zlf   2014/11/24

	PROCEDURE delete_interface(p_batch_id NUMBER,
														 p_user_id  NUMBER) IS
	BEGIN
		DELETE FROM csh_transaction_temp t WHERE t.batch_id = p_batch_id;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'CSH_TRANSACTION',
																										 p_procedure_function_name => 'DELETE_INTERFACE');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END delete_interface;

	PROCEDURE insert_interface(p_header_id NUMBER,
														 p_batch_id  NUMBER,
														 p_user_id   NUMBER,
														 p_bank_type VARCHAR2 DEFAULT NULL) IS
		CURSOR c_data IS
			SELECT *
				FROM fnd_interface_lines
			 WHERE header_id = p_header_id
				 AND line_number >= 1;
	BEGIN
		IF p_bank_type IS NULL THEN
			--通用导入  未指定银行时保留之前逻辑
			FOR c_record IN c_data LOOP
				INSERT INTO csh_transaction_temp
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
				VALUES
					(p_batch_id,
					 csh_transaction_temp_s.nextval,
					 to_date(c_record.attribute_1, 'YYYY-MM-DD'), --入账日期
					 c_record.attribute_2, --用途
					 to_number(c_record.attribute_3), --金额
					 c_record.attribute_4, --对方账户
					 c_record.attribute_5, --对方户名
					 c_record.attribute_6, --收款账号
					 c_record.attribute_7, --银行流水号
					 to_date(c_record.attribute_8, 'YYYY-MM-DD'), --时间
					 p_user_id,
					 SYSDATE,
					 p_user_id,
					 SYSDATE);
			END LOOP;
		ELSIF p_bank_type = 'HSBC' THEN
			--华夏银行
			FOR c_record IN (SELECT *
												 FROM fnd_interface_lines l
												WHERE l.header_id = p_header_id
													AND l.line_number >= 1
													AND l.attribute_3 IS NULL
													AND l.attribute_4 IS NOT NULL) LOOP
				INSERT INTO csh_transaction_temp
					(batch_id,
					 csh_transaction_temp_id,
					 transaction_date,
					 description,
					 transaction_amount,
					 account_balance,
					 contract_number,
					 bp_bank_account_num,
					 bp_name,
					 bank_account_num,
					 bank_serial_num,
					 sys_date,
					 created_by,
					 creation_date,
					 last_updated_by,
					 last_update_date)
				VALUES
					(p_batch_id,
					 csh_transaction_temp_s.nextval,
					 to_date(c_record.attribute_1, 'YYYY-MM-DD'), --交易日期
					 c_record.attribute_2, --交易描述
					 --to_number(c_record.attribute_3), --借方发生额：付款金额
					 to_number(c_record.attribute_4), --贷方发生额:收款金额
					 --c_record.attribute_5, --凭证号
					 to_number(c_record.attribute_6), --账户余额
					 c_record.attribute_7, --摘要：合同编号           
					 c_record.attribute_8, --对方账号：对方账户
					 c_record.attribute_9, --对方账号名称：对方户名           
					 --c_record.attribute_10, --对方行名
					 '10567000000310048', --收款账号 --华夏银行收款账号默认写死
					 NULL, --银行流水号
					 NULL /*trunc(SYSDATE)*/, --时间
					 p_user_id,
					 SYSDATE,
					 p_user_id,
					 SYSDATE);
			END LOOP;
		ELSIF p_bank_type = 'ICBC' THEN
			--工商银行  工行title上有一行空行
			FOR c_record IN (SELECT *
												 FROM fnd_interface_lines l
												WHERE l.header_id = p_header_id
													AND l.line_number >= 2
													AND l.attribute_6 IS NULL
													AND l.attribute_7 IS NOT NULL) LOOP
				INSERT INTO csh_transaction_temp
					(batch_id,
					 csh_transaction_temp_id,
					 bank_account_num,
					 bp_bank_account_num,
					 transaction_date,
					 transaction_amount,
					 contract_number,
					 bp_name,
					 account_balance,
					 description,
					 bank_serial_num,
					 sys_date,
					 created_by,
					 creation_date,
					 last_updated_by,
					 last_update_date)
				VALUES
					(p_batch_id,
					 csh_transaction_temp_s.nextval,
					 --c_record.attribute_1--凭证号
					 c_record.attribute_2, --本方账号：收款账号
					 c_record.attribute_3, --对方账号：对方账户
					 to_date(c_record.attribute_4, 'yyyy-mm-dd hh24:mi:ss'), --交易日期 保留时分
					 --c_record.attribute_5,--借/贷
					 --to_number(c_record.attribute_6),--借方发生额：付款金额
					 to_number(c_record.attribute_7), --贷方发生额:收款金额
					 --c_record.attribute_8,--对方行号
					 c_record.attribute_9, --摘要：合同编号   
					 --c_record.attribute_10,--用途  
					 c_record.attribute_11, --对方单位名称:对方户名
					 to_number(c_record.attribute_12), --账户余额
					 c_record.attribute_13, --个性化信息：用途           
					 NULL, --银行流水号
					 NULL /*trunc(SYSDATE)*/, --时间
					 p_user_id,
					 SYSDATE,
					 p_user_id,
					 SYSDATE);
			END LOOP;
		END IF;
	
		--删除导入数据表
		DELETE FROM fnd_interface_headers h WHERE h.header_id = p_header_id;
		DELETE FROM fnd_interface_lines l WHERE l.header_id = p_header_id;
	END;

	PROCEDURE delete_temp(p_batch_id NUMBER) IS
	BEGIN
		--delete from fnd_interface_lines t where t.line_id = p_batch_id;
		DELETE FROM csh_transaction_temp t WHERE t.batch_id = p_batch_id;
		DELETE FROM csh_transaction_temp_logs t WHERE t.batch_id = p_batch_id;
	END delete_temp;

	PROCEDURE delete_error_logs(p_batch_id NUMBER) IS
	
	BEGIN
		DELETE FROM csh_transaction_temp_logs a WHERE a.batch_id = p_batch_id;
	END delete_error_logs;

	PROCEDURE txn_log(p_temp     IN csh_transaction_temp%ROWTYPE,
										p_log_text IN VARCHAR2,
										p_user_id  IN NUMBER) IS
	BEGIN
		INSERT INTO csh_transaction_temp_logs
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
		VALUES
			(p_temp.batch_id,
			 csh_transaction_temp_logs_s.nextval,
			 p_temp.transaction_date,
			 p_temp.description,
			 p_temp.transaction_amount,
			 p_temp.bp_bank_account_num,
			 p_temp.bp_name,
			 p_temp.bank_account_num,
			 p_user_id,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_log_text);
	END txn_log;

	PROCEDURE yonda_auto_write_off_log(p_transaction_id  NUMBER DEFAULT NULL,
																		 p_write_off_id    NUMBER DEFAULT NULL,
																		 p_bp_id           NUMBER DEFAULT NULL,
																		 p_contract_id     NUMBER DEFAULT NULL,
																		 p_bank_account_id NUMBER DEFAULT NULL,
																		 p_message         VARCHAR2) AS
		PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		INSERT INTO yonda_csh_excel_write_off_log
			(log_id,
			 log_date,
			 transaction_id,
			 write_off_id,
			 bp_id,
			 contract_id,
			 bank_account_id,
			 message)
		VALUES
			(yonda_auto_write_off_log_s.nextval,
			 SYSDATE,
			 p_transaction_id,
			 p_write_off_id,
			 p_bp_id,
			 p_contract_id,
			 p_bank_account_id,
			 p_message);
		COMMIT;
	END yonda_auto_write_off_log;

	PROCEDURE check_data(p_batch_id  NUMBER,
											 p_user_id   NUMBER,
											 p_return_id OUT NUMBER,
											 p_bank_type VARCHAR2 DEFAULT NULL) IS
		v_bp_name_exist_flag         VARCHAR2(2) := 'N';
		v_bp_bank_account_exist_flag VARCHAR2(2) := 'N';
		v_bp_name_num                NUMBER;
		v_column_num                 NUMBER := 1;
		v_line_num                   NUMBER := 2;
		v_log_text                   VARCHAR(500);
		e_bp_name_num_error          EXCEPTION;
		e_date_null_error            EXCEPTION;
		e_description_null_error     EXCEPTION;
		e_amount_null_error          EXCEPTION;
		e_bp_account_null_error      EXCEPTION;
		e_bank_serial_num_null_error EXCEPTION;
		v_count NUMBER;
	BEGIN
		delete_error_logs(p_batch_id);
	
		IF p_bank_type IS NULL THEN
			--通用导入  未指定银行时保留之前逻辑
			p_return_id := 1;
			FOR c_record IN (SELECT * FROM csh_transaction_temp c WHERE c.batch_id = p_batch_id) LOOP
				BEGIN
					IF c_record.transaction_date IS NULL THEN
						RAISE e_date_null_error;
					END IF;
				EXCEPTION
					WHEN e_date_null_error THEN
						p_return_id  := 0;
						v_column_num := 1;
						v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num || '列,入账日期为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
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
				BEGIN
					IF c_record.transaction_amount IS NULL THEN
						RAISE e_amount_null_error;
					END IF;
				EXCEPTION
					WHEN e_amount_null_error THEN
						p_return_id  := 0;
						v_column_num := 3;
						v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num || '列,入账金额为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
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
			
				BEGIN
					SELECT 'Y'
						INTO v_bp_bank_account_exist_flag
						FROM dual
					 WHERE EXISTS (SELECT 1
										FROM csh_bank_account_v v
									 WHERE v.bank_account_num = c_record.bank_account_num);
				EXCEPTION
					WHEN no_data_found THEN
						p_return_id  := 0;
						v_column_num := 6;
						v_log_text   := '导入文档中第' || v_line_num || '行第' || v_column_num || '列,收款账号在系统中不存在';
						txn_log(c_record, v_log_text, p_user_id);
					
				END;
			
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
			END LOOP;
		ELSIF p_bank_type = 'HSBC' THEN
			--华夏银行
			p_return_id := 1;
			FOR c_record IN (SELECT * FROM csh_transaction_temp c WHERE c.batch_id = p_batch_id) LOOP
				BEGIN
					IF c_record.transaction_date IS NULL THEN
						RAISE e_date_null_error;
					END IF;
				EXCEPTION
					WHEN e_date_null_error THEN
						p_return_id  := 0;
						v_column_num := 1;
						v_log_text   := '导入文档中第' || v_line_num || '行入账日期为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
			
				BEGIN
					IF c_record.transaction_amount IS NULL THEN
						RAISE e_amount_null_error;
					END IF;
				EXCEPTION
					WHEN e_amount_null_error THEN
						p_return_id  := 0;
						v_column_num := 3;
						v_log_text   := '导入文档中第' || v_line_num || '行入账金额为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
			
				BEGIN
					SELECT 'Y'
						INTO v_bp_bank_account_exist_flag
						FROM dual
					 WHERE EXISTS (SELECT 1
										FROM csh_bank_account_v v
									 WHERE v.bank_account_num = c_record.bank_account_num);
				EXCEPTION
					WHEN no_data_found THEN
						p_return_id  := 0;
						v_column_num := 6;
						v_log_text   := '导入文档中第' || v_line_num || '行收款账号在系统中不存在';
						txn_log(c_record, v_log_text, p_user_id);
					
				END;
			
				--与系统现金事务存在完全相同即不允许导入
				SELECT COUNT(1)
					INTO v_count
					FROM csh_transaction ct
				 WHERE ct.transaction_category = 'BUSINESS'
					 AND ct.transaction_type = 'RECEIPT'
					 AND ct.reversed_flag = 'N' --未反冲
					 AND ct.transaction_amount = c_record.transaction_amount --收款金额
					 AND ct.account_balance = c_record.account_balance --账户余额
					 AND ct.contract_number = c_record.contract_number --合同编号
					 AND ct.bp_bank_account_num = c_record.bp_bank_account_num; --对方账号     
				IF v_count <> 0 THEN
					p_return_id := 0;
					v_log_text  := '导入文档中第' || v_line_num || '行收款记录在系统中已存在';
					txn_log(c_record, v_log_text, p_user_id);
				END IF;
			
				--与excel导入记录存在完全相同即不允许导入
				SELECT COUNT(1)
					INTO v_count
					FROM csh_transaction_temp ctt
				 WHERE ctt.transaction_amount = c_record.transaction_amount --收款金额
					 AND ctt.account_balance = c_record.account_balance --账户余额
					 AND ctt.contract_number = c_record.contract_number --合同编号
					 AND ctt.bp_bank_account_num = c_record.bp_bank_account_num --对方账号
					 AND ctt.csh_transaction_temp_id <> c_record.csh_transaction_temp_id
					 AND ctt.batch_id = p_batch_id;
				IF v_count <> 0 THEN
					p_return_id := 0;
					v_log_text  := '导入文档中第' || v_line_num || '行在导入excel中存在重复记录';
					txn_log(c_record, v_log_text, p_user_id);
				END IF;
			
				v_line_num := v_line_num + 1;
			END LOOP;
		ELSIF p_bank_type = 'ICBC' THEN
			--工商银行
			p_return_id := 1;
			FOR c_record IN (SELECT * FROM csh_transaction_temp c WHERE c.batch_id = p_batch_id) LOOP
				BEGIN
					IF c_record.transaction_date IS NULL THEN
						RAISE e_date_null_error;
					END IF;
				EXCEPTION
					WHEN e_date_null_error THEN
						p_return_id  := 0;
						v_column_num := 1;
						v_log_text   := '导入文档中第' || v_line_num || '行入账日期为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
			
				BEGIN
					IF c_record.transaction_amount IS NULL THEN
						RAISE e_amount_null_error;
					END IF;
				EXCEPTION
					WHEN e_amount_null_error THEN
						p_return_id  := 0;
						v_column_num := 3;
						v_log_text   := '导入文档中第' || v_line_num || '行入账金额为空';
						txn_log(c_record, v_log_text, p_user_id);
				END;
			
				BEGIN
					SELECT 'Y'
						INTO v_bp_bank_account_exist_flag
						FROM dual
					 WHERE EXISTS (SELECT 1
										FROM csh_bank_account_v v
									 WHERE v.bank_account_num = c_record.bank_account_num);
				EXCEPTION
					WHEN no_data_found THEN
						p_return_id  := 0;
						v_column_num := 6;
						v_log_text   := '导入文档中第' || v_line_num || '行收款账号在系统中不存在';
						txn_log(c_record, v_log_text, p_user_id);
				END;
			
				--与系统现金事务存在完全相同即不允许导入
				SELECT COUNT(1)
					INTO v_count
					FROM csh_transaction ct
				 WHERE ct.transaction_category = 'BUSINESS'
					 AND ct.transaction_type = 'RECEIPT'
					 AND ct.reversed_flag = 'N' --未反冲
					 AND ct.transaction_amount = c_record.transaction_amount --收款金额
					 AND ct.account_balance = c_record.account_balance --账户余额
					 AND ct.transaction_date = c_record.transaction_date --交易时间 精确到分 作为判断标准
							--AND ct.contract_number = c_record.contract_number --合同编号
					 AND ct.bp_bank_account_num = c_record.bp_bank_account_num; --对方账号     
				IF v_count <> 0 THEN
					--已存在记录直接删除跳过
					DELETE FROM csh_transaction_temp ctt
					 WHERE ctt.csh_transaction_temp_id = c_record.csh_transaction_temp_id;
					continue;
				END IF;
			
				--与excel导入记录存在完全相同即不允许导入
				SELECT COUNT(1)
					INTO v_count
					FROM csh_transaction_temp ctt
				 WHERE ctt.transaction_amount = c_record.transaction_amount --收款金额
					 AND ctt.account_balance = c_record.account_balance --账户余额
					 AND ctt.transaction_date = c_record.transaction_date --交易时间 精确到分 作为判断标准
							--AND ctt.contract_number = c_record.contract_number --合同编号
					 AND ctt.bp_bank_account_num = c_record.bp_bank_account_num --对方账号
					 AND ctt.csh_transaction_temp_id <> c_record.csh_transaction_temp_id
					 AND ctt.batch_id = p_batch_id;
				IF v_count <> 0 THEN
					p_return_id := 0;
					v_log_text  := '导入文档中第' || v_line_num || '行在导入excel中存在重复记录';
					txn_log(c_record, v_log_text, p_user_id);
				END IF;
			
				v_line_num := v_line_num + 1;
			END LOOP;
		END IF;
	END;

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
	PROCEDURE save_data(p_batch_id      NUMBER,
											p_user_id       NUMBER,
											p_company_id    NUMBER,
											po_save_message OUT VARCHAR2,
											p_bank_type     VARCHAR2 DEFAULT NULL) AS
	BEGIN
		/*sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '该功能正在维护中，请稍后尝试！',
                                                   p_created_by              => p_user_id,
                                                   p_package_name            => 'CSH_TRANSACTION',
                                                   p_procedure_function_name => 'DELETE_INTERFACE');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);*/
		-- transaction & write off
		yonda_csh_transaction_pkg.auto_transaction_and_write_off(p_batch_id   => p_batch_id,
																														 p_user_id    => p_user_id,
																														 p_company_id => p_company_id,
																														 p_bank_type  => p_bank_type);
		--删除临时表数据
		--delete_interface(p_batch_id, p_user_id);
		delete_temp(p_batch_id);
	END save_data;

	--查找付款方式
	FUNCTION search_payment_method(p_cashflow_id NUMBER,
																 p_earch       VARCHAR2) RETURN VARCHAR2 IS
		v_result VARCHAR2(200);
	BEGIN
		IF (p_earch = 'payment_method') THEN
			SELECT description
				INTO v_result
				FROM (SELECT tt.description
								FROM csh_transaction    t,
										 csh_write_off      cs,
										 csh_payment_method tt
							 WHERE cs.cashflow_id = p_cashflow_id
								 AND cs.csh_transaction_id = t.transaction_id
								 AND t.payment_method_id = tt.payment_method_id
								 AND t.write_off_flag = 'FULL'
								 AND cs.reversed_flag = 'N'
							 ORDER BY cs.last_update_date)
			 WHERE rownum = 1;
		ELSIF (p_earch = 'bp_bank_account_num') THEN
			SELECT bp_bank_account_num
				INTO v_result
				FROM (SELECT t.bp_bank_account_num
								FROM csh_transaction t,
										 csh_write_off   cs
							 WHERE cs.cashflow_id = p_cashflow_id
								 AND cs.csh_transaction_id = t.transaction_id
								 AND t.write_off_flag = 'FULL'
								 AND cs.reversed_flag = 'N'
							 ORDER BY cs.last_update_date DESC)
			 WHERE rownum = 1;
		ELSE
			SELECT bp_name
				INTO v_result
				FROM (SELECT h.bp_name
								FROM csh_transaction t,
										 csh_write_off   cs,
										 hls_bp_master   h
							 WHERE cs.cashflow_id = p_cashflow_id
								 AND cs.csh_transaction_id = t.transaction_id
								 AND t.bp_id = h.bp_id
								 AND t.write_off_flag = 'FULL'
								 AND cs.reversed_flag = 'N'
							 ORDER BY 1 DESC)
			 WHERE rownum = 1;
		END IF;
		RETURN v_result;
	END;

	--add 20171020 未及时核销收款事务生成收款凭证job 每天凌晨跑 
	FUNCTION create_receipt_trx_je(p_user_id NUMBER) RETURN VARCHAR2 IS
	BEGIN
		FOR c_receipt_trx IN (SELECT *
														FROM csh_transaction ct
													 WHERE ct.transaction_category = 'BUSINESS'
														 AND ct.transaction_type = 'RECEIPT'
														 AND ct.posted_flag = 'Y'
														 AND ct.reversed_flag = 'N'
														 AND ct.returned_flag = 'NOT'
														 AND trunc(ct.creation_date + 1) = trunc(SYSDATE) --次日生成凭证
														 AND ct.create_je_flag = 'N'
														 FOR UPDATE NOWAIT) LOOP
			--修改成未及时核销状态
			UPDATE csh_transaction ct
				 SET ct.timely_write_off_flag = 'N'
			 WHERE ct.transaction_id = c_receipt_trx.transaction_id;
		
			--现金事务过账生成的凭证
			csh_transaction_je_pkg.create_transaction_je(p_transaction_id => c_receipt_trx.transaction_id,
																									 p_user_id        => p_user_id);
		END LOOP;
	
		hls_dayend_pkg.log(p_log_desc => 'csh_transaction_pkg.create_receipt_trx_je : success');
	
		RETURN sch_system_job_pkg.g_job_result_success;
	EXCEPTION
		WHEN OTHERS THEN
			hls_dayend_pkg.log(p_log_desc      => '错误',
												 p_error_message => '未及时核销收款生成凭证(csh_transaction_pkg.create_receipt_trx_je)过程中发送错误。' ||
																						dbms_utility.format_error_backtrace || ' ' || SQLERRM);
		
			RETURN sch_system_job_pkg.g_job_result_error;
	END create_receipt_trx_je;

END csh_transaction_pkg;
/
