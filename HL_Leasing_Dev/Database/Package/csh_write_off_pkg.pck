CREATE OR REPLACE PACKAGE csh_write_off_pkg IS

	-- Author  : GAOYANG
	-- Created : 2013/5/20 16:27:15
	-- Purpose :
	-- Version : 1.23

	write_off_type_receipt_credit CONSTANT VARCHAR2(30) := 'RECEIPT_CREDIT'; -- 收款核销债权类型
	write_off_type_receipt_pre    CONSTANT VARCHAR2(30) := 'RECEIPT_ADVANCE_RECEIPT'; -- 收款核销为预收款类型
	write_off_type_pre_credit     CONSTANT VARCHAR2(30) := 'ADVANCE_RECEIPT_CREDIT'; -- 预收款核销债权类型
	write_off_type_return         CONSTANT VARCHAR2(30) := 'CSH_RETURN'; -- 现金退款
	write_off_type_payment_debt   CONSTANT VARCHAR2(30) := 'PAYMENT_DEBT'; -- 付款核销债务
	write_off_type_pre_debt       CONSTANT VARCHAR2(30) := 'PREPAYMENT_DEBT'; -- 预付款核销债务类型

	document_category_contract CONSTANT VARCHAR2(30) := 'CONTRACT'; --租赁合同

	FUNCTION get_last_write_off_date(p_transaction_id NUMBER) RETURN DATE;

	FUNCTION get_csh_write_off_id RETURN NUMBER;
	PROCEDURE set_con_cfw_after_writeoff(p_con_cashflow_rec  con_contract_cashflow%ROWTYPE,
																			 p_csh_write_off_rec csh_write_off%ROWTYPE,
																			 p_user_id           NUMBER);
	PROCEDURE lock_csh_write_off(p_write_off_id      csh_write_off.write_off_id%TYPE,
															 p_user_id           NUMBER,
															 p_csh_write_off_rec OUT csh_write_off%ROWTYPE);

	PROCEDURE upd_write_off_after_reverse(p_write_off_id          NUMBER,
																				p_reversed_date         DATE,
																				p_reserved_write_off_id NUMBER,
																				p_user_id               NUMBER);

	PROCEDURE execute_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%TYPE,
																			 p_write_off_type           csh_write_off_temp.write_off_type%TYPE,
																			 p_transaction_category     csh_write_off_temp.transaction_category%TYPE,
																			 p_transaction_type         csh_write_off_temp.transaction_type%TYPE,
																			 p_write_off_date           csh_write_off_temp.write_off_date%TYPE,
																			 p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%TYPE,
																			 p_write_off_principal      csh_write_off_temp.write_off_principal%TYPE,
																			 p_write_off_interest       csh_write_off_temp.write_off_interest%TYPE,
																			 p_write_off_penalty        NUMBER,
																			 p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%TYPE DEFAULT NULL,
																			 p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%TYPE DEFAULT NULL,
																			 p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%TYPE DEFAULT NULL,
																			 p_exchange_rate            csh_write_off_temp.exchange_rate%TYPE DEFAULT NULL,
																			 p_company_id               csh_write_off_temp.company_id%TYPE,
																			 p_document_category        csh_write_off_temp.document_category%TYPE,
																			 p_document_id              csh_write_off_temp.document_id%TYPE,
																			 p_document_line_id         csh_write_off_temp.document_line_id%TYPE,
																			 p_penalty_cashflow_id      NUMBER,
																			 p_description              csh_write_off_temp.description%TYPE,
																			 p_user_id                  csh_write_off_temp.created_by%TYPE);

	PROCEDURE insert_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%TYPE,
																			p_write_off_type           csh_write_off_temp.write_off_type%TYPE,
																			p_transaction_category     csh_write_off_temp.transaction_category%TYPE,
																			p_transaction_type         csh_write_off_temp.transaction_type%TYPE,
																			p_write_off_date           csh_write_off_temp.write_off_date%TYPE,
																			p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%TYPE,
																			p_write_off_principal      csh_write_off_temp.write_off_principal%TYPE,
																			p_write_off_interest       csh_write_off_temp.write_off_interest%TYPE,
																			p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%TYPE DEFAULT NULL,
																			p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%TYPE DEFAULT NULL,
																			p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%TYPE DEFAULT NULL,
																			p_exchange_rate            csh_write_off_temp.exchange_rate%TYPE DEFAULT NULL,
																			p_company_id               csh_write_off_temp.company_id%TYPE,
																			p_document_category        csh_write_off_temp.document_category%TYPE,
																			p_document_id              csh_write_off_temp.document_id%TYPE,
																			p_document_line_id         csh_write_off_temp.document_line_id%TYPE,
																			p_description              csh_write_off_temp.description%TYPE,
																			p_user_id                  csh_write_off_temp.created_by%TYPE);

	PROCEDURE delete_csh_write_off_temp(p_session_id NUMBER,
																			p_user_id    NUMBER);

	PROCEDURE insert_csh_write_off(p_write_off_id                OUT csh_write_off.write_off_id%TYPE,
																 p_write_off_type              csh_write_off.write_off_type%TYPE,
																 p_write_off_date              csh_write_off.write_off_date%TYPE,
																 p_internal_period_num         csh_write_off.internal_period_num%TYPE,
																 p_period_name                 csh_write_off.period_name%TYPE,
																 p_csh_transaction_id          csh_write_off.csh_transaction_id%TYPE,
																 p_csh_write_off_amount        csh_write_off.csh_write_off_amount%TYPE,
																 p_subsequent_csh_trx_id       csh_write_off.subsequent_csh_trx_id%TYPE,
																 p_subseq_csh_write_off_amount csh_write_off.subseq_csh_write_off_amount%TYPE,
																 p_reversed_flag               csh_write_off.reversed_flag%TYPE,
																 p_reversed_write_off_id       csh_write_off.reversed_write_off_id%TYPE,
																 p_reversed_date               csh_write_off.reversed_date%TYPE,
																 p_cashflow_id                 csh_write_off.cashflow_id%TYPE,
																 p_contract_id                 csh_write_off.contract_id%TYPE,
																 p_times                       csh_write_off.times%TYPE,
																 p_cf_item                     csh_write_off.cf_item%TYPE,
																 p_cf_type                     csh_write_off.cf_type%TYPE,
																 p_penalty_calc_date           csh_write_off.penalty_calc_date%TYPE,
																 p_write_off_due_amount        csh_write_off.write_off_due_amount%TYPE,
																 p_write_off_principal         csh_write_off.write_off_principal%TYPE,
																 p_write_off_interest          csh_write_off.write_off_interest%TYPE,
																 p_write_off_due_amount_cny    csh_write_off.write_off_due_amount_cny%TYPE DEFAULT NULL,
																 p_write_off_principal_cny     csh_write_off.write_off_principal_cny%TYPE DEFAULT NULL,
																 p_write_off_interest_cny      csh_write_off.write_off_interest_cny%TYPE DEFAULT NULL,
																 p_exchange_rate               csh_write_off.exchange_rate%TYPE DEFAULT NULL,
																 p_description                 csh_write_off.description%TYPE,
																 p_opposite_doc_category       csh_write_off.opposite_doc_category%TYPE,
																 p_opposite_doc_type           csh_write_off.opposite_doc_type%TYPE,
																 p_opposite_doc_id             csh_write_off.opposite_doc_id%TYPE,
																 p_opposite_doc_line_id        csh_write_off.opposite_doc_line_id%TYPE,
																 p_opposite_doc_detail_id      csh_write_off.opposite_doc_detail_id%TYPE,
																 p_opposite_write_off_amount   csh_write_off.opposite_write_off_amount%TYPE,
																 p_create_je_mothed            csh_write_off.create_je_mothed%TYPE,
																 p_create_je_flag              csh_write_off.create_je_flag%TYPE,
																 p_gld_interface_flag          csh_write_off.gld_interface_flag%TYPE,
																 p_user_id                     csh_write_off.created_by%TYPE);

	--核销前校验
	PROCEDURE check_before_write_off(p_csh_write_off_rec   csh_write_off%ROWTYPE,
																	 p_csh_trx_rec         csh_transaction%ROWTYPE,
																	 p_cross_currency_flag VARCHAR2 DEFAULT 'N',
																	 p_user_id             NUMBER);

	PROCEDURE return_write_off(p_return_write_off_id   OUT NUMBER,
														 p_transaction_id        NUMBER,
														 p_return_transaction_id NUMBER,
														 p_returned_date         DATE,
														 p_returned_amount       NUMBER,
														 p_description           VARCHAR2,
														 p_user_id               NUMBER);
	--核销反冲主入口
	PROCEDURE reverse_write_off(p_reverse_write_off_id OUT NUMBER,
															p_write_off_id         NUMBER,
															p_reversed_date        DATE,
															p_description          VARCHAR2,
															p_user_id              NUMBER,
															p_from_csh_trx_flag    VARCHAR2 DEFAULT 'N');

	PROCEDURE execute_write_off(p_write_off_id        NUMBER,
															p_cross_currency_flag VARCHAR2 DEFAULT 'N',
															p_user_id             NUMBER);

	--核销主入口
	PROCEDURE main_write_off(p_session_id          NUMBER,
													 p_transaction_id      NUMBER,
													 p_cross_currency_flag VARCHAR2 DEFAULT 'N',
													 p_receipt_flag        VARCHAR2 DEFAULT NULL,
													 p_user_id             NUMBER);

	--收付抵扣主入口
	PROCEDURE deduction_write_off(p_session_id          NUMBER,
																p_company_id          NUMBER,
																p_bp_id               NUMBER,
																p_transaction_date    DATE,
																p_description         VARCHAR2,
																p_source_csh_trx_type VARCHAR2 DEFAULT NULL,
																p_source_csh_trx_id   NUMBER DEFAULT NULL,
																p_source_doc_category VARCHAR2 DEFAULT NULL,
																p_source_doc_type     VARCHAR2 DEFAULT NULL,
																p_source_doc_id       NUMBER DEFAULT NULL,
																p_source_doc_line_id  NUMBER DEFAULT NULL,
																p_user_id             NUMBER,
																p_transaction_id      OUT NUMBER);
END csh_write_off_pkg;
/
CREATE OR REPLACE PACKAGE BODY csh_write_off_pkg IS

	v_err_code VARCHAR2(2000);
	e_lock_error EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_lock_error, -54);

	FUNCTION get_csh_write_off_id RETURN NUMBER IS
		v_write_off_id NUMBER;
	BEGIN
		SELECT csh_write_off_s.nextval INTO v_write_off_id FROM dual;
		RETURN v_write_off_id;
	END get_csh_write_off_id;

	FUNCTION get_last_write_off_date(p_transaction_id NUMBER) RETURN DATE IS
		v_last_write_off_date DATE;
	BEGIN
		SELECT MAX(w.write_off_date)
			INTO v_last_write_off_date
			FROM csh_write_off w
		 WHERE w.csh_transaction_id = p_transaction_id;
	
		RETURN v_last_write_off_date;
	END get_last_write_off_date;

	FUNCTION get_con_last_writeoff_date(p_cashflow_id NUMBER) RETURN DATE IS
		v_last_write_off_date DATE;
	BEGIN
		SELECT MAX(w.write_off_date)
			INTO v_last_write_off_date
			FROM csh_write_off w
		 WHERE w.cashflow_id = p_cashflow_id;
		RETURN v_last_write_off_date;
	END;

	FUNCTION is_write_off_reverse(p_csh_transaction_rec IN csh_transaction%ROWTYPE,
																p_user_id             NUMBER) RETURN BOOLEAN IS
		v_ctx_rec csh_transaction%ROWTYPE;
	BEGIN
		IF nvl(p_csh_transaction_rec.returned_flag, csh_transaction_pkg.csh_trx_return_flag_n) =
			 csh_transaction_pkg.csh_trx_return_flag_return THEN
			RETURN TRUE;
		ELSIF nvl(p_csh_transaction_rec.posted_flag, csh_transaction_pkg.csh_trx_posted_flag_yes) <>
					csh_transaction_pkg.csh_trx_posted_flag_yes THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_POSTED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.reversed_flag, csh_transaction_pkg.csh_trx_reversed_flag_n) <>
					csh_transaction_pkg.csh_trx_reversed_flag_n THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_REVERSED_FLAG_ERROR';
			RETURN FALSE;
		ELSIF nvl(p_csh_transaction_rec.write_off_flag, csh_transaction_pkg.csh_trx_write_off_flag_n) =
					csh_transaction_pkg.csh_trx_write_off_flag_n THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.REVERSE_WRITE_OFF_FLAG_ERROR';
			RETURN FALSE;
		END IF;
		FOR r_writeoff_rec IN (SELECT d.subsequent_csh_trx_id
														 FROM csh_write_off d
														WHERE d.csh_transaction_id = p_csh_transaction_rec.transaction_id
															AND d.subsequent_csh_trx_id IS NOT NULL
															AND nvl(d.reversed_flag, csh_transaction_pkg.csh_trx_reversed_flag_n) =
																	csh_transaction_pkg.csh_trx_reversed_flag_n) LOOP
		
			csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => r_writeoff_rec.subsequent_csh_trx_id,
																							 p_user_id             => p_user_id,
																							 p_csh_transaction_rec => v_ctx_rec);
		
			IF nvl(v_ctx_rec.write_off_flag, csh_transaction_pkg.csh_trx_write_off_flag_n) <>
				 csh_transaction_pkg.csh_trx_write_off_flag_n THEN
				v_err_code := 'CSH_WRITE_OFF_PKG.SUBSEQUENT_REVERSE_WRITE_OFF_FLAG_ERROR';
				RETURN FALSE;
			ELSIF nvl(v_ctx_rec.returned_flag, csh_transaction_pkg.csh_trx_return_flag_n) <>
						csh_transaction_pkg.csh_trx_return_flag_n THEN
				v_err_code := 'CSH_WRITE_OFF_PKG.SUBSEQUENT_REVERSE_RETURN_FLAG_ERROR';
				RETURN FALSE;
			END IF;
		END LOOP;
		RETURN TRUE;
	END;

	--索合同行表
	PROCEDURE lock_con_contract_cashflow(p_cashflow_id      con_contract_cashflow.cashflow_id%TYPE,
																			 p_user_id          NUMBER,
																			 p_con_cashflow_rec OUT con_contract_cashflow%ROWTYPE) IS
	BEGIN
		SELECT *
			INTO p_con_cashflow_rec
			FROM con_contract_cashflow t
		 WHERE t.cashflow_id = p_cashflow_id
			 FOR UPDATE NOWAIT;
	
	EXCEPTION
		WHEN e_lock_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CON_LOCK_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'lock_con_contract_cashflow');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--索csh_write_off
	PROCEDURE lock_csh_write_off(p_write_off_id      csh_write_off.write_off_id%TYPE,
															 p_user_id           NUMBER,
															 p_csh_write_off_rec OUT csh_write_off%ROWTYPE) IS
	BEGIN
		SELECT *
			INTO p_csh_write_off_rec
			FROM csh_write_off t
		 WHERE t.write_off_id = p_write_off_id
			 FOR UPDATE NOWAIT;
	
	EXCEPTION
		WHEN e_lock_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_LOCK_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'lock_csh_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--更新被反冲的核销事务
	PROCEDURE upd_write_off_after_reverse(p_write_off_id          NUMBER,
																				p_reversed_date         DATE,
																				p_reserved_write_off_id NUMBER,
																				p_user_id               NUMBER) IS
		v_csh_write_off_rec csh_write_off%ROWTYPE;
	BEGIN
		lock_csh_write_off(p_write_off_id      => p_write_off_id,
											 p_user_id           => p_user_id,
											 p_csh_write_off_rec => v_csh_write_off_rec);
		UPDATE csh_write_off t
			 SET t.reversed_flag         = csh_transaction_pkg.csh_trx_reversed_flag_w,
					 t.reversed_date         = p_reversed_date,
					 t.reversed_write_off_id = p_reserved_write_off_id,
					 t.last_update_date      = SYSDATE,
					 t.last_updated_by       = p_user_id
		 WHERE t.write_off_id = v_csh_write_off_rec.write_off_id;
	END;

	--更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
	PROCEDURE set_con_cfw_after_writeoff(p_con_cashflow_rec  con_contract_cashflow%ROWTYPE,
																			 p_csh_write_off_rec csh_write_off%ROWTYPE,
																			 p_user_id           NUMBER) IS
		v_write_off_due_amount NUMBER;
		v_write_off_principal  NUMBER;
		v_write_off_interest   NUMBER;
	
		v_last_write_off_date DATE;
		v_transaction_date    DATE;
	
		v_write_off_flag VARCHAR2(30);
	
		v_con_cf_rec con_contract_cashflow%ROWTYPE;
		e_cfw_con_error EXCEPTION;
	
		v_count              NUMBER;
		v_document_type      VARCHAR2(30);
		v_document_category  VARCHAR2(30);
		r_contract_cashflow  con_contract_cashflow%ROWTYPE;
		v_write_off_count    NUMBER;
		v_inception_of_lease DATE;
		v_error_msg          VARCHAR2(4000);
		e_data_error EXCEPTION;
	BEGIN
	
		v_write_off_due_amount := nvl(p_con_cashflow_rec.received_amount, 0) +
															nvl(p_csh_write_off_rec.write_off_due_amount, 0);
		v_write_off_principal  := nvl(p_con_cashflow_rec.received_principal, 0) +
															nvl(p_csh_write_off_rec.write_off_principal, 0);
		v_write_off_interest   := nvl(p_con_cashflow_rec.received_interest, 0) +
															nvl(p_csh_write_off_rec.write_off_interest, 0);
	
		IF v_write_off_due_amount = 0 THEN
			v_last_write_off_date := NULL;
			v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_n;
		ELSE
			IF nvl(p_con_cashflow_rec.due_amount, 0) = v_write_off_due_amount THEN
				v_last_write_off_date := get_con_last_writeoff_date(p_cashflow_id => p_con_cashflow_rec.cashflow_id);
				v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_f;
			ELSIF nvl(p_con_cashflow_rec.due_amount, 0) > v_write_off_due_amount THEN
				v_last_write_off_date := NULL;
				v_write_off_flag      := csh_transaction_pkg.csh_trx_write_off_flag_p;
			ELSE
				v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_DUE_AMOUNT_ERROR';
				RAISE e_cfw_con_error;
			END IF;
		END IF;
	
		IF nvl(p_con_cashflow_rec.principal, 0) < v_write_off_principal THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_PRINCIPAL_ERROR';
			RAISE e_cfw_con_error;
		END IF;
	
		IF nvl(p_con_cashflow_rec.interest, 0) < v_write_off_interest THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_CON_INTEREST_ERROR';
			RAISE e_cfw_con_error;
		END IF;
	
		UPDATE con_contract_cashflow t
			 SET t.received_amount        = v_write_off_due_amount,
					 t.received_principal     = v_write_off_principal,
					 t.received_interest      = v_write_off_interest,
					 t.received_amount_cny    = nvl(t.received_amount_cny, 0) +
																			nvl(p_csh_write_off_rec.write_off_due_amount_cny, 0),
					 t.received_principal_cny = nvl(t.received_principal_cny, 0) +
																			nvl(p_csh_write_off_rec.write_off_principal_cny, 0),
					 t.received_interest_cny  = nvl(t.received_interest_cny, 0) +
																			nvl(p_csh_write_off_rec.write_off_interest_cny, 0),
					 t.write_off_flag         = v_write_off_flag,
					 t.full_write_off_date    = v_last_write_off_date,
					 t.last_received_date    =
					 (SELECT a.transaction_date
							FROM csh_transaction a
						 WHERE a.transaction_id = p_csh_write_off_rec.csh_transaction_id),
					 t.last_update_date       = SYSDATE,
					 t.last_updated_by        = p_user_id
		 WHERE t.cashflow_id = p_con_cashflow_rec.cashflow_id;
	
		--add 20171009 待放款：该合同首付款手续费核销完成后，把状态改为待放款/UNDER_LENT
		IF p_con_cashflow_rec.cf_item IN (2, 3) THEN
			BEGIN
				SELECT *
					INTO r_contract_cashflow
					FROM con_contract_cashflow ccc
				 WHERE ccc.contract_id = p_con_cashflow_rec.contract_id
					 AND ccc.cf_item IN (2, 3)
					 AND ccc.cf_item <> p_con_cashflow_rec.cf_item
					 AND ccc.cf_direction = 'INFLOW';
			EXCEPTION
				WHEN no_data_found THEN
					r_contract_cashflow := NULL;
			END;
		
			IF (r_contract_cashflow.write_off_flag = 'FULL' AND v_write_off_flag = 'FULL') OR
				--增加不同时存在两条现金流的情况
				 (r_contract_cashflow.write_off_flag IS NULL AND v_write_off_flag = 'FULL') THEN
				--完全核销
				UPDATE con_contract cc
					 SET cc.user_status_1    = 'UNDER_LENT', --待放款
							 cc.last_updated_by  = p_user_id,
							 cc.last_update_date = SYSDATE
				 WHERE cc.contract_id = p_con_cashflow_rec.contract_id;
				hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CONTRACT',
																															 p_document_id       => p_con_cashflow_rec.contract_id,
																															 p_operation_code    => 'CON_PENDING_PAYMENT',
																															 p_user_id           => p_user_id,
																															 p_operation_time    => SYSDATE,
																															 p_description       => NULL);
				SELECT t.document_type,
							 t.document_category
					INTO v_document_type,
							 v_document_category
					FROM con_contract t
				 WHERE t.contract_id = p_con_cashflow_rec.contract_id;
				yonda_doc_history_pkg.yonda_insert_doc_status(p_document_id       => p_con_cashflow_rec.contract_id,
																											p_document_type     => v_document_type,
																											p_document_category => v_document_category,
																											p_doc_status        => yonda_doc_history_pkg.yonda_con_pending_payment,
																											p_instance_id       => NULL,
																											p_user_id           => p_user_id);
			ELSIF (r_contract_cashflow.write_off_flag = 'FULL' AND
						p_con_cashflow_rec.write_off_flag = 'FULL' AND v_write_off_flag <> 'FULL') OR
					 --增加不同时存在两条现金流的情况
						(r_contract_cashflow.write_off_flag IS NULL AND
						p_con_cashflow_rec.write_off_flag = 'FULL' AND v_write_off_flag <> 'FULL') THEN
				--完全核销 ==> 未完全核销  即出现反冲  执行修改状态
			
				SELECT cc.inception_of_lease
					INTO v_inception_of_lease
					FROM con_contract cc
				 WHERE cc.contract_id = p_con_cashflow_rec.contract_id;
				IF v_inception_of_lease IS NOT NULL THEN
					v_error_msg := '合同已起租，不允许反冲首付款！';
					RAISE e_data_error;
				END IF;
			
				UPDATE con_contract cc
					 SET cc.user_status_1    = 'SIGN', --合规审查通过状态
							 cc.last_updated_by  = p_user_id,
							 cc.last_update_date = SYSDATE
				 WHERE cc.contract_id = p_con_cashflow_rec.contract_id;
				hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CONTRACT',
																															 p_document_id       => p_con_cashflow_rec.contract_id,
																															 p_operation_code    => 'CON_DOWNPAYMENT_REVERSE',
																															 p_user_id           => p_user_id,
																															 p_operation_time    => SYSDATE,
																															 p_description       => NULL);
				SELECT t.document_type,
							 t.document_category
					INTO v_document_type,
							 v_document_category
					FROM con_contract t
				 WHERE t.contract_id = p_con_cashflow_rec.contract_id;
				yonda_doc_history_pkg.yonda_insert_doc_status(p_document_id       => p_con_cashflow_rec.contract_id,
																											p_document_type     => v_document_type,
																											p_document_category => v_document_category,
																											p_doc_status        => yonda_doc_history_pkg.yonda_con_downpayment_reverse,
																											p_instance_id       => NULL,
																											p_user_id           => p_user_id);
			END IF;
		
			/*SELECT COUNT(1)
        INTO v_count
        FROM con_contract_cashflow ccc
       WHERE ccc.contract_id = p_con_cashflow_rec.contract_id
         AND ccc.cf_item IN (2, 3)
         AND ccc.cf_direction = 'INFLOW'
         AND ccc.write_off_flag <> 'FULL';
      
      IF v_count = 0 THEN
        --完全核销
        UPDATE con_contract cc
           SET cc.user_status_1    = 'UNDER_LENT',
               cc.last_updated_by  = p_user_id,
               cc.last_update_date = SYSDATE
         WHERE cc.contract_id = p_con_cashflow_rec.contract_id;
        hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CONTRACT',
                                                               p_document_id       => p_con_cashflow_rec.contract_id,
                                                               p_operation_code    => 'CON_PENDING_PAYMENT',
                                                               p_user_id           => p_user_id,
                                                               p_operation_time    => SYSDATE,
                                                               p_description       => NULL);
      
        SELECT t.document_type,
               t.document_category
          INTO v_document_type,
               v_document_category
          FROM con_contract t
         WHERE t.contract_id = p_con_cashflow_rec.contract_id;
        yonda_doc_history_pkg.yonda_insert_doc_status(p_document_id       => p_con_cashflow_rec.contract_id,
                                                      p_document_type     => v_document_type,
                                                      p_document_category => v_document_category,
                                                      p_doc_status        => yonda_doc_history_pkg.yonda_con_pending_payment,
                                                      p_instance_id       => NULL,
                                                      p_user_id           => p_user_id);
      END IF;*/
		END IF;
	
		--add 20171009 付款起租：保费支付完全，起租合同
		IF p_con_cashflow_rec.cf_item = 5 THEN
			IF v_write_off_flag = 'FULL' THEN
				--完全核销  执行起租
				con_contract_pkg.contract_incept(p_contract_id             => p_con_cashflow_rec.contract_id,
																				 p_exchange_rate_quotation => 'DIRECT QUOTATION',
																				 p_exchange_rate_type      => NULL,
																				 p_exchange_rate           => 1,
																				 p_inception_of_lease      => trunc(v_last_write_off_date),
																				 p_base_rate_new           => NULL,
																				 p_user_id                 => p_user_id);
			ELSIF p_con_cashflow_rec.write_off_flag = 'FULL' AND
						v_write_off_flag <> 'FULL' THEN
				--完全核销 ==> 未完全核销  即出现反冲  执行反起租
				--起租后反冲，需重置合同状态，并删除现金流，由于起租凭证放在付款合并过账事务里面，无需单独反冲
			
				--合同现金流已核销，不允许反冲
				SELECT COUNT(1)
					INTO v_write_off_count
					FROM con_contract_cashflow c
				 WHERE c.cf_direction IN ('INFLOW', 'OUTFLOW')
					 AND c.times > 0
					 AND c.write_off_flag <> 'NOT'
					 AND c.contract_id = p_con_cashflow_rec.contract_id;
				IF v_write_off_count > 0 THEN
					v_error_msg := '合同现金流已核销，不允许反冲付款！';
					RAISE e_data_error;
				END IF;
			
				--起租时插入的现金流，反冲时删除掉
				DELETE FROM con_contract_cashflow ccc
				 WHERE ccc.contract_id = p_con_cashflow_rec.contract_id
					 AND ccc.cf_direction = 'NONCASH'
					 AND ccc.cf_item = 1
					 AND ccc.times = 0;
			
				--修改成签约、待付款状态
				UPDATE con_contract cc
					 SET cc.contract_status    = 'SIGN',
							 cc.inception_of_lease = NULL,
							 cc.user_status_1      = 'UNDER_LENT', --待付款
							 cc.last_updated_by    = p_user_id,
							 cc.last_update_date   = SYSDATE
				 WHERE cc.contract_id = p_con_cashflow_rec.contract_id;
			
				--插入合同操作历史
				hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CONTRACT',
																															 p_document_id       => p_con_cashflow_rec.contract_id,
																															 p_operation_code    => 'CON_INCEPT_REVERSE',
																															 p_user_id           => p_user_id,
																															 p_operation_time    => SYSDATE,
																															 p_description       => NULL);
				SELECT t.document_type,
							 t.document_category
					INTO v_document_type,
							 v_document_category
					FROM con_contract t
				 WHERE t.contract_id = p_con_cashflow_rec.contract_id;
				yonda_doc_history_pkg.yonda_insert_doc_status(p_document_id       => p_con_cashflow_rec.contract_id,
																											p_document_type     => v_document_type,
																											p_document_category => v_document_category,
																											p_doc_status        => yonda_doc_history_pkg.yonda_con_incept_reverse,
																											p_instance_id       => NULL,
																											p_user_id           => p_user_id);
			END IF;
		END IF;
	EXCEPTION
		WHEN e_data_error THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_msg,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'set_con_cfw_after_writeoff');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_cfw_con_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'set_con_cfw_after_writeoff');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END set_con_cfw_after_writeoff;

	--更新subsequent_csh_trx_id
	PROCEDURE update_subsequent_csh_trx_id(p_write_off_id   NUMBER,
																				 p_transaction_id NUMBER,
																				 p_user_id        NUMBER) IS
		v_csh_write_off_rec csh_write_off%ROWTYPE;
	BEGIN
		lock_csh_write_off(p_write_off_id      => p_write_off_id,
											 p_user_id           => p_user_id,
											 p_csh_write_off_rec => v_csh_write_off_rec);
		UPDATE csh_write_off d
			 SET d.subsequent_csh_trx_id       = p_transaction_id,
					 d.subseq_csh_write_off_amount = v_csh_write_off_rec.csh_write_off_amount,
					 d.last_update_date            = SYSDATE,
					 d.last_updated_by             = p_user_id
		 WHERE d.write_off_id = p_write_off_id;
	END;

	PROCEDURE execute_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%TYPE,
																			 p_write_off_type           csh_write_off_temp.write_off_type%TYPE,
																			 p_transaction_category     csh_write_off_temp.transaction_category%TYPE,
																			 p_transaction_type         csh_write_off_temp.transaction_type%TYPE,
																			 p_write_off_date           csh_write_off_temp.write_off_date%TYPE,
																			 p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%TYPE,
																			 p_write_off_principal      csh_write_off_temp.write_off_principal%TYPE,
																			 p_write_off_interest       csh_write_off_temp.write_off_interest%TYPE,
																			 p_write_off_penalty        NUMBER,
																			 p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%TYPE DEFAULT NULL,
																			 p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%TYPE DEFAULT NULL,
																			 p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%TYPE DEFAULT NULL,
																			 p_exchange_rate            csh_write_off_temp.exchange_rate%TYPE DEFAULT NULL,
																			 p_company_id               csh_write_off_temp.company_id%TYPE,
																			 p_document_category        csh_write_off_temp.document_category%TYPE,
																			 p_document_id              csh_write_off_temp.document_id%TYPE,
																			 p_document_line_id         csh_write_off_temp.document_line_id%TYPE,
																			 p_penalty_cashflow_id      NUMBER,
																			 p_description              csh_write_off_temp.description%TYPE,
																			 p_user_id                  csh_write_off_temp.created_by%TYPE) IS
		e_amount_error EXCEPTION;
		v_count NUMBER := 0;
	BEGIN
		IF nvl(p_write_off_due_amount, 0) > 0 THEN
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
																p_user_id                  => p_user_id);
		ELSE
			v_count := v_count + 1;
		END IF;
		IF nvl(p_write_off_penalty, 0) > 0 AND
			 p_penalty_cashflow_id IS NOT NULL THEN
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
																p_user_id              => p_user_id);
		ELSE
			v_count := v_count + 1;
		END IF;
		IF v_count = 2 THEN
			RAISE e_amount_error;
		END IF;
	EXCEPTION
		WHEN e_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_AMOUNT_NEGATIVE_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'execute_csh_write_off_temp');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE insert_csh_write_off_temp(p_csh_write_off_temp_rec IN OUT csh_write_off_temp%ROWTYPE) IS
	BEGIN
		INSERT INTO csh_write_off_temp VALUES p_csh_write_off_temp_rec;
	END;

	PROCEDURE insert_csh_write_off_temp(p_session_id               csh_write_off_temp.session_id%TYPE,
																			p_write_off_type           csh_write_off_temp.write_off_type%TYPE,
																			p_transaction_category     csh_write_off_temp.transaction_category%TYPE,
																			p_transaction_type         csh_write_off_temp.transaction_type%TYPE,
																			p_write_off_date           csh_write_off_temp.write_off_date%TYPE,
																			p_write_off_due_amount     csh_write_off_temp.write_off_due_amount%TYPE,
																			p_write_off_principal      csh_write_off_temp.write_off_principal%TYPE,
																			p_write_off_interest       csh_write_off_temp.write_off_interest%TYPE,
																			p_write_off_due_amount_cny csh_write_off_temp.write_off_due_amount_cny%TYPE DEFAULT NULL,
																			p_write_off_principal_cny  csh_write_off_temp.write_off_principal_cny%TYPE DEFAULT NULL,
																			p_write_off_interest_cny   csh_write_off_temp.write_off_interest_cny%TYPE DEFAULT NULL,
																			p_exchange_rate            csh_write_off_temp.exchange_rate%TYPE DEFAULT NULL,
																			p_company_id               csh_write_off_temp.company_id%TYPE,
																			p_document_category        csh_write_off_temp.document_category%TYPE,
																			p_document_id              csh_write_off_temp.document_id%TYPE,
																			p_document_line_id         csh_write_off_temp.document_line_id%TYPE,
																			p_description              csh_write_off_temp.description%TYPE,
																			p_user_id                  csh_write_off_temp.created_by%TYPE) IS
	
		v_record   csh_write_off_temp%ROWTYPE;
		cou_number NUMBER;
	BEGIN
		/* select  count(1)  into cou_number from con_contract cc where cc.contract_id=p_document_id and cc.user_status_1='SIGN' and  to_char(cc.payment_valid_date,'YYYY-MM-DD')>to_char(sysdate,'YYYY-MM-DD');
    if cou_number=0 then
      return;
      end if;*/
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
		v_record.description              := p_description;
		v_record.creation_date            := SYSDATE;
		v_record.created_by               := p_user_id;
		v_record.last_update_date         := SYSDATE;
		v_record.last_updated_by          := p_user_id;
		insert_csh_write_off_temp(v_record);
	END;

	PROCEDURE delete_csh_write_off_temp(p_session_id NUMBER,
																			p_user_id    NUMBER) IS
	BEGIN
		DELETE FROM csh_write_off_temp t
		 WHERE t.session_id = p_session_id
				OR (SYSDATE - t.creation_date) > 1;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'delete_csh_write_off_temp');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END delete_csh_write_off_temp;

	FUNCTION insert_csh_write_off(p_csh_write_off_temp_rec csh_write_off_temp%ROWTYPE,
																p_csh_transaction_rec    csh_transaction%ROWTYPE,
																p_set_of_books_id        NUMBER,
																p_cross_currency_flag    VARCHAR2 DEFAULT 'N',
																p_user_id                NUMBER) RETURN NUMBER IS
		v_write_off_id             NUMBER;
		v_csh_write_off_amount     NUMBER;
		v_write_off_due_amount     NUMBER;
		v_write_off_principal      NUMBER;
		v_write_off_interest       NUMBER;
		v_write_off_due_amount_cny NUMBER;
		v_write_off_principal_cny  NUMBER;
		v_write_off_interest_cny   NUMBER;
		v_write_off_penalty        NUMBER;
		v_precision                NUMBER;
		v_period_name              VARCHAR2(30);
		v_internal_period_num      gld_periods.internal_period_num%TYPE;
	
		v_con_cashflow_rec con_contract_cashflow%ROWTYPE;
	
		e_insert_write_off_error EXCEPTION;
	BEGIN
		v_precision := fnd_format_mask_pkg.get_gld_amount_precision(p_currency_code   => p_csh_transaction_rec.currency_code,
																																p_set_of_books_id => p_set_of_books_id);
	
		IF p_csh_write_off_temp_rec.write_off_type IN
			 (csh_write_off_pkg.write_off_type_receipt_credit,
				csh_write_off_pkg.write_off_type_pre_credit,
				csh_write_off_pkg.write_off_type_payment_debt) THEN
			--索合同表
			lock_con_contract_cashflow(p_cashflow_id      => p_csh_write_off_temp_rec.document_line_id,
																 p_user_id          => p_user_id,
																 p_con_cashflow_rec => v_con_cashflow_rec);
		END IF;
		IF v_precision IS NOT NULL THEN
			IF p_cross_currency_flag = 'Y' AND
				 p_csh_transaction_rec.currency_code = 'CNY' THEN
				v_csh_write_off_amount     := round(nvl(p_csh_write_off_temp_rec.write_off_due_amount_cny,
																								0),
																						v_precision);
				v_write_off_due_amount_cny := round(p_csh_write_off_temp_rec.write_off_due_amount_cny,
																						v_precision);
			
				v_write_off_principal_cny := round(p_csh_write_off_temp_rec.write_off_principal_cny,
																					 v_precision);
				v_write_off_interest_cny  := round(p_csh_write_off_temp_rec.write_off_interest_cny,
																					 v_precision);
			ELSE
				v_csh_write_off_amount     := round(nvl(p_csh_write_off_temp_rec.write_off_due_amount, 0),
																						v_precision);
				v_write_off_due_amount_cny := NULL;
				v_write_off_principal_cny  := NULL;
				v_write_off_interest_cny   := NULL;
			
			END IF;
		
			v_write_off_due_amount := round(p_csh_write_off_temp_rec.write_off_due_amount, v_precision);
			v_write_off_principal  := round(p_csh_write_off_temp_rec.write_off_principal, v_precision);
			v_write_off_interest   := round(p_csh_write_off_temp_rec.write_off_interest, v_precision);
		ELSE
		
			IF p_cross_currency_flag = 'Y' AND
				 p_csh_transaction_rec.currency_code = 'CNY' THEN
				v_csh_write_off_amount := nvl(p_csh_write_off_temp_rec.write_off_due_amount_cny, 0);
			
				v_write_off_due_amount_cny := p_csh_write_off_temp_rec.write_off_due_amount_cny;
			
				v_write_off_principal_cny := p_csh_write_off_temp_rec.write_off_principal_cny;
				v_write_off_interest_cny  := p_csh_write_off_temp_rec.write_off_interest_cny;
			
			ELSE
			
				v_csh_write_off_amount     := nvl(p_csh_write_off_temp_rec.write_off_due_amount, 0);
				v_write_off_due_amount_cny := NULL;
				v_write_off_principal_cny  := NULL;
				v_write_off_interest_cny   := NULL;
			END IF;
			v_write_off_due_amount := p_csh_write_off_temp_rec.write_off_due_amount;
			v_write_off_principal  := p_csh_write_off_temp_rec.write_off_principal;
			v_write_off_interest   := p_csh_write_off_temp_rec.write_off_interest;
		END IF;
		-- 期间
		v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_csh_transaction_rec.company_id,
																												p_date       => p_csh_write_off_temp_rec.write_off_date);
		IF v_period_name IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_ERROR';
			RAISE e_insert_write_off_error;
		END IF;
		v_internal_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => p_csh_transaction_rec.company_id,
																																				p_period_name => v_period_name);
		IF v_internal_period_num IS NULL THEN
			v_err_code := 'CSH_TRANSACTION_PKG.REVERSE_PERIOD_NUM_ERROR';
			RAISE e_insert_write_off_error;
		END IF;
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
												 p_contract_id                 => v_con_cashflow_rec.contract_id,
												 p_times                       => v_con_cashflow_rec.times,
												 p_cf_item                     => v_con_cashflow_rec.cf_item,
												 p_cf_type                     => v_con_cashflow_rec.cf_type,
												 p_penalty_calc_date           => p_csh_transaction_rec.transaction_date,
												 -- modify BY Spencer 3893 20160825 延迟履行金计算日修改为取核销日期
												 --p_penalty_calc_date => p_csh_write_off_temp_rec.write_off_date,
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
												 p_user_id                   => p_user_id);
	
		RETURN v_write_off_id;
	EXCEPTION
		WHEN e_insert_write_off_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'insert_csh_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE insert_csh_write_off(p_csh_write_off_rec IN OUT csh_write_off%ROWTYPE) IS
	BEGIN
		IF p_csh_write_off_rec.write_off_id IS NULL THEN
			SELECT csh_write_off_s.nextval INTO p_csh_write_off_rec.write_off_id FROM dual;
		END IF;
		INSERT INTO csh_write_off VALUES p_csh_write_off_rec;
	END;

	PROCEDURE insert_csh_write_off(p_write_off_id                OUT csh_write_off.write_off_id%TYPE,
																 p_write_off_type              csh_write_off.write_off_type%TYPE,
																 p_write_off_date              csh_write_off.write_off_date%TYPE,
																 p_internal_period_num         csh_write_off.internal_period_num%TYPE,
																 p_period_name                 csh_write_off.period_name%TYPE,
																 p_csh_transaction_id          csh_write_off.csh_transaction_id%TYPE,
																 p_csh_write_off_amount        csh_write_off.csh_write_off_amount%TYPE,
																 p_subsequent_csh_trx_id       csh_write_off.subsequent_csh_trx_id%TYPE,
																 p_subseq_csh_write_off_amount csh_write_off.subseq_csh_write_off_amount%TYPE,
																 p_reversed_flag               csh_write_off.reversed_flag%TYPE,
																 p_reversed_write_off_id       csh_write_off.reversed_write_off_id%TYPE,
																 p_reversed_date               csh_write_off.reversed_date%TYPE,
																 p_cashflow_id                 csh_write_off.cashflow_id%TYPE,
																 p_contract_id                 csh_write_off.contract_id%TYPE,
																 p_times                       csh_write_off.times%TYPE,
																 p_cf_item                     csh_write_off.cf_item%TYPE,
																 p_cf_type                     csh_write_off.cf_type%TYPE,
																 p_penalty_calc_date           csh_write_off.penalty_calc_date%TYPE,
																 p_write_off_due_amount        csh_write_off.write_off_due_amount%TYPE,
																 p_write_off_principal         csh_write_off.write_off_principal%TYPE,
																 p_write_off_interest          csh_write_off.write_off_interest%TYPE,
																 p_write_off_due_amount_cny    csh_write_off.write_off_due_amount_cny%TYPE DEFAULT NULL,
																 p_write_off_principal_cny     csh_write_off.write_off_principal_cny%TYPE DEFAULT NULL,
																 p_write_off_interest_cny      csh_write_off.write_off_interest_cny%TYPE DEFAULT NULL,
																 p_exchange_rate               csh_write_off.exchange_rate%TYPE DEFAULT NULL,
																 p_description                 csh_write_off.description%TYPE,
																 p_opposite_doc_category       csh_write_off.opposite_doc_category%TYPE,
																 p_opposite_doc_type           csh_write_off.opposite_doc_type%TYPE,
																 p_opposite_doc_id             csh_write_off.opposite_doc_id%TYPE,
																 p_opposite_doc_line_id        csh_write_off.opposite_doc_line_id%TYPE,
																 p_opposite_doc_detail_id      csh_write_off.opposite_doc_detail_id%TYPE,
																 p_opposite_write_off_amount   csh_write_off.opposite_write_off_amount%TYPE,
																 p_create_je_mothed            csh_write_off.create_je_mothed%TYPE,
																 p_create_je_flag              csh_write_off.create_je_flag%TYPE,
																 p_gld_interface_flag          csh_write_off.gld_interface_flag%TYPE,
																 p_user_id                     csh_write_off.created_by%TYPE) IS
		v_record           csh_write_off%ROWTYPE;
		v_csh_write_off_id NUMBER;
	BEGIN
		SELECT csh_write_off_s.nextval INTO v_csh_write_off_id FROM dual;
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
		v_record.creation_date               := SYSDATE;
		v_record.last_updated_by             := p_user_id;
		v_record.last_update_date            := SYSDATE;
		insert_csh_write_off(v_record);
		p_write_off_id := v_record.write_off_id;
	END;

	--核销前金额校验
	PROCEDURE check_before_write_off(p_csh_write_off_rec   csh_write_off%ROWTYPE,
																	 p_csh_trx_rec         csh_transaction%ROWTYPE,
																	 p_cross_currency_flag VARCHAR2 DEFAULT 'N',
																	 p_user_id             NUMBER) IS
		e_amount_error              EXCEPTION;
		e_trx_writeoff_amount_error EXCEPTION;
		e_cf_type_amount_error      EXCEPTION;
		e_currency_error            EXCEPTION;
		v_con_cashflow_rec   con_contract_cashflow%ROWTYPE;
		v_con_contract_rec   con_contract%ROWTYPE;
		v_un_writeoff_amount NUMBER;
	BEGIN
		IF nvl(p_csh_write_off_rec.write_off_due_amount, 0) < 0 OR
			 nvl(p_csh_write_off_rec.write_off_principal, 0) < 0 OR
			 nvl(p_csh_write_off_rec.write_off_interest, 0) < 0 THEN
			RAISE e_amount_error;
		END IF;
		IF nvl(p_csh_write_off_rec.write_off_due_amount, 0) +
			 nvl(p_csh_write_off_rec.write_off_principal, 0) +
			 nvl(p_csh_write_off_rec.write_off_interest, 0) <= 0 THEN
			RAISE e_amount_error;
		END IF;
		IF p_csh_write_off_rec.write_off_type IN
			 (csh_write_off_pkg.write_off_type_receipt_credit,
				csh_write_off_pkg.write_off_type_pre_credit) AND
			 p_csh_trx_rec.transaction_type IN
			 (csh_transaction_pkg.csh_trx_type_receipt, csh_transaction_pkg.csh_trx_type_prereceipt) AND
			 p_csh_trx_rec.transaction_category = csh_transaction_pkg.csh_trx_category_business THEN
			lock_con_contract_cashflow(p_cashflow_id      => p_csh_write_off_rec.cashflow_id,
																 p_user_id          => p_user_id,
																 p_con_cashflow_rec => v_con_cashflow_rec);
		
			v_con_contract_rec := con_contract_pkg.get_contract_rec(p_contract_id => v_con_cashflow_rec.contract_id,
																															p_user_id     => p_user_id);
		
			IF nvl(p_cross_currency_flag, 'N') = 'N' AND
				 v_con_contract_rec.currency <> p_csh_trx_rec.currency_code THEN
				RAISE e_currency_error;
			END IF;
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
		END IF;
	EXCEPTION
		WHEN e_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_AMOUNT_NEGATIVE_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'check_receipt_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_currency_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.WRITE_OFF_CURRENCY_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'check_receipt_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_cf_type_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.CF_TYPE_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'check_receipt_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_trx_writeoff_amount_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_WRITE_OFF_PKG.TRX_WRITEOFF_AMOUNT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'check_receipt_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--收款、预收款的退款需要在核销表中插一条退款事务
	PROCEDURE return_write_off(p_return_write_off_id   OUT NUMBER,
														 p_transaction_id        NUMBER,
														 p_return_transaction_id NUMBER,
														 p_returned_date         DATE,
														 p_returned_amount       NUMBER,
														 p_description           VARCHAR2,
														 p_user_id               NUMBER) IS
		v_write_off_id        NUMBER;
		v_period_name         VARCHAR2(30);
		v_internal_period_num gld_periods.internal_period_num%TYPE;
	
		v_csh_transaction_rec csh_transaction%ROWTYPE;
	
		e_return_error EXCEPTION;
	BEGIN
		csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
																						 p_user_id             => p_user_id,
																						 p_csh_transaction_rec => v_csh_transaction_rec);
	
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
		insert_csh_write_off(p_write_off_id                => v_write_off_id,
												 p_write_off_type              => csh_write_off_pkg.write_off_type_return,
												 p_write_off_date              => p_returned_date,
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
		csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
																									 p_user_id        => p_user_id);
		p_return_write_off_id := v_write_off_id;
	EXCEPTION
		WHEN e_return_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'return_write_off',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'return_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		
	END;
	--反冲明细
	PROCEDURE reverse_write_off(p_reverse_write_off_id OUT NUMBER,
															p_write_off_id         NUMBER,
															p_reversed_date        DATE,
															p_period_name          VARCHAR2,
															p_internal_period_num  NUMBER,
															p_description          VARCHAR2,
															p_user_id              NUMBER) IS
		v_write_off_id NUMBER;
	
		v_csh_write_off_rec csh_write_off%ROWTYPE;
	BEGIN
	
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
												 p_user_id                   => p_user_id);
		--更新被反冲的核销事务
		upd_write_off_after_reverse(p_write_off_id          => p_write_off_id,
																p_reversed_date         => p_reversed_date,
																p_reserved_write_off_id => v_write_off_id,
																p_user_id               => p_user_id);
		p_reverse_write_off_id := v_write_off_id;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'reverse_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--核销反冲主入口（收款核销债权反冲，预收款核销债权反冲，收款核销预收款反冲，退款反冲，付款反冲）
	PROCEDURE reverse_write_off(p_reverse_write_off_id OUT NUMBER,
															p_write_off_id         NUMBER,
															p_reversed_date        DATE,
															p_description          VARCHAR2,
															p_user_id              NUMBER,
															p_from_csh_trx_flag    VARCHAR2 DEFAULT 'N') IS
	
		v_csh_write_off_rec         csh_write_off%ROWTYPE;
		v_csh_reverse_write_off_rec csh_write_off%ROWTYPE;
		v_csh_transaction_rec       csh_transaction%ROWTYPE;
		v_subsequent_csh_trx_rec    csh_transaction%ROWTYPE;
		v_con_cashflow_rec          con_contract_cashflow%ROWTYPE;
		v_internal_period_num       gld_periods.internal_period_num%TYPE;
	
		v_reverse_write_off_id NUMBER;
		v_transaction_id       NUMBER;
		v_period_name          VARCHAR2(30);
	
		e_reverse_error EXCEPTION;
	BEGIN
		lock_csh_write_off(p_write_off_id      => p_write_off_id,
											 p_user_id           => p_user_id,
											 p_csh_write_off_rec => v_csh_write_off_rec);
	
		csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.csh_transaction_id,
																						 p_user_id             => p_user_id,
																						 p_csh_transaction_rec => v_csh_transaction_rec);
		IF v_csh_write_off_rec.write_off_type = write_off_type_return THEN
			csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.subsequent_csh_trx_id,
																							 p_user_id             => p_user_id,
																							 p_csh_transaction_rec => v_csh_transaction_rec);
		ELSIF v_csh_write_off_rec.write_off_type = write_off_type_receipt_pre THEN
			csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => v_csh_write_off_rec.subsequent_csh_trx_id,
																							 p_user_id             => p_user_id,
																							 p_csh_transaction_rec => v_subsequent_csh_trx_rec);
		END IF;
		IF p_from_csh_trx_flag = 'N' AND
			 v_csh_write_off_rec.write_off_type IN (write_off_type_return, write_off_type_payment_debt) THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.WRITEOFF_SOURCE_ERROR';
			RAISE e_reverse_error;
		END IF;
		IF p_from_csh_trx_flag = 'N' AND
			 nvl(v_csh_transaction_rec.transaction_amount, 0) != 0 AND
			 v_csh_write_off_rec.write_off_type IN (write_off_type_return, write_off_type_payment_debt) THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.WRITEOFF_SOURCE_ERROR';
			RAISE e_reverse_error;
		END IF;
		IF NOT is_write_off_reverse(v_csh_transaction_rec, p_user_id) THEN
			RAISE e_reverse_error;
		END IF;
		--校验反冲日期
		IF p_reversed_date < v_csh_write_off_rec.write_off_date THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.REVERSE_WRITE_OFF_DATE_ERROR';
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
		--收款核销预收款反冲
		IF v_csh_write_off_rec.write_off_type = csh_write_off_pkg.write_off_type_receipt_pre THEN
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
		END IF;
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
	
		IF v_csh_write_off_rec.write_off_type IN
			 (write_off_type_receipt_credit, write_off_type_pre_credit, write_off_type_payment_debt) THEN
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
		END IF;
	
		--生成单笔核销反冲事务凭证
		csh_transaction_je_pkg.create_write_off_reverse_je(p_write_off_id => v_reverse_write_off_id,
																											 p_user_id      => p_user_id);
		--生产核销反冲凭证
		csh_transaction_je_pkg.create_trx_writeoff_reverse_je(p_transaction_id => v_csh_write_off_rec.csh_transaction_id,
																													p_reversed_date  => p_reversed_date,
																													p_user_id        => p_user_id);
	
		p_reverse_write_off_id := v_reverse_write_off_id;
	EXCEPTION
		WHEN e_reverse_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'reverse_write_off',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_transaction_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'reverse_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	--明细核销情况

	/*收款核销预收款增加传送ref_contract_id*/
	PROCEDURE execute_write_off(p_write_off_id        NUMBER,
															p_cross_currency_flag VARCHAR2 DEFAULT 'N',
															p_user_id             NUMBER) IS
		v_write_off_rec    csh_write_off%ROWTYPE;
		v_csh_trx_rec      csh_transaction%ROWTYPE;
		v_con_cashflow_rec con_contract_cashflow%ROWTYPE;
	
		v_transaction_id NUMBER;
		v_cf_item        NUMBER;
		e_csh_trx_error EXCEPTION;
	BEGIN
		SELECT * INTO v_write_off_rec FROM csh_write_off WHERE write_off_id = p_write_off_id;
	
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
		IF v_write_off_rec.write_off_type IN
			 (write_off_type_receipt_credit, write_off_type_pre_credit, write_off_type_payment_debt) AND
			 v_csh_trx_rec.transaction_type IN
			 (csh_transaction_pkg.csh_trx_type_receipt,
				csh_transaction_pkg.csh_trx_type_prereceipt,
				csh_transaction_pkg.csh_trx_type_payment,
				csh_transaction_pkg.csh_trx_type_deduction) AND
			 v_csh_trx_rec.transaction_category = csh_transaction_pkg.csh_trx_category_business THEN
			lock_con_contract_cashflow(p_cashflow_id      => v_write_off_rec.cashflow_id,
																 p_user_id          => p_user_id,
																 p_con_cashflow_rec => v_con_cashflow_rec);
		
			--更新合同现金流表（CON_CONTRACT_CASHFLOW）中被核销行记录
			set_con_cfw_after_writeoff(p_con_cashflow_rec  => v_con_cashflow_rec,
																 p_csh_write_off_rec => v_write_off_rec,
																 p_user_id           => p_user_id);
		
			-- 如果是收款核销提前结清，保证金，多退少补，判断是否结清
			-- add by qianming 20150520
			/*IF v_con_cashflow_rec.cf_item IN (200, 52, 907, 908) THEN
        con_contract_et_pkg.et_judge_receipted(p_contract_id => v_con_cashflow_rec.contract_id,
                                               p_cashflow_id => v_con_cashflow_rec.cashflow_id,
                                               p_user_id     => p_user_id);
      END IF;*/
		
			hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CSH_TRX',
																														 p_document_id       => v_csh_trx_rec.transaction_id,
																														 p_operation_code    => write_off_type_receipt_credit,
																														 p_user_id           => p_user_id,
																														 p_operation_time    => SYSDATE,
																														 p_description       => '现金事务编号[' ||
																																										v_csh_trx_rec.transaction_num ||
																																										'],核销金额:' ||
																																										v_write_off_rec.csh_write_off_amount);
		
			--add by wcs 2014-10-30
			/*con_contract_pkg.contract_incept_automatic(p_contract_id => v_con_cashflow_rec.contract_id,
      p_incept_date => to_date(v_write_off_rec.write_off_date),
      p_user_id     => p_user_id);*/
		
		ELSIF v_write_off_rec.write_off_type = csh_write_off_pkg.write_off_type_receipt_pre AND
					v_csh_trx_rec.transaction_type = csh_transaction_pkg.csh_trx_type_receipt AND
					v_csh_trx_rec.transaction_category = csh_transaction_pkg.csh_trx_category_business THEN
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
																								 p_description             => v_csh_trx_rec.description,
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
																								 p_ref_contract_id         => v_csh_trx_rec.ref_contract_id); --add by xuls 2014-9-26 for ref_contract_id
			--更新subsequent_csh_trx_id等字段信息
			update_subsequent_csh_trx_id(p_write_off_id   => p_write_off_id,
																	 p_transaction_id => v_transaction_id,
																	 p_user_id        => p_user_id);
		
			hls_doc_operate_history_pkg.insert_doc_operate_history(p_document_category => 'CSH_TRX',
																														 p_document_id       => v_write_off_rec.csh_transaction_id,
																														 p_operation_code    => write_off_type_receipt_pre,
																														 p_user_id           => p_user_id,
																														 p_operation_time    => SYSDATE,
																														 p_description       => '现金事务编号[' ||
																																										v_csh_trx_rec.transaction_num ||
																																										'],核销金额:' ||
																																										v_write_off_rec.csh_write_off_amount);
		
			--预收款不能核销为预收款
		ELSIF v_write_off_rec.write_off_type = csh_write_off_pkg.write_off_type_receipt_pre AND
					v_csh_trx_rec.transaction_type = csh_transaction_pkg.csh_trx_type_prereceipt AND
					v_csh_trx_rec.transaction_category = csh_transaction_pkg.csh_trx_category_business THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.PRE_WRITE_OFF_PRE_ERROR';
			RAISE e_csh_trx_error;
		END IF;
		IF nvl(v_csh_trx_rec.transaction_amount, 0) = 0 THEN
			NULL;
		ELSE
			--更新原现金事务核销相关字段
		
			csh_transaction_pkg.set_csh_trx_write_off_status(p_csh_trx_rec      => v_csh_trx_rec,
																											 p_write_off_amount => v_write_off_rec.csh_write_off_amount,
																											 p_user_id          => p_user_id);
		
		END IF;
		--生成单笔核销事务凭证
		csh_transaction_je_pkg.create_write_off_je(p_write_off_id => p_write_off_id,
																							 p_user_id      => p_user_id);
	
		csh_write_off_custom_pkg.after_write_off(p_write_off_id => p_write_off_id,
																						 p_user_id      => p_user_id);
	EXCEPTION
		WHEN e_csh_trx_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'execute_write_off',
																											p_token_1                 => '#TRANSACTION_NUM',
																											p_token_value_1           => v_csh_trx_rec.transaction_num);
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'execute_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;
	--核销主入口
	PROCEDURE main_write_off(p_session_id          NUMBER,
													 p_transaction_id      NUMBER,
													 p_cross_currency_flag VARCHAR2 DEFAULT 'N',
													 p_receipt_flag        VARCHAR2 DEFAULT NULL,
													 p_user_id             NUMBER) IS
		csh_transaction_rec        csh_transaction%ROWTYPE;
		v_functional_currency_code gld_set_of_books.functional_currency_code%TYPE;
		v_set_of_books_id          gld_set_of_books.set_of_books_id%TYPE;
		v_write_off_id             NUMBER;
	
		v_amount NUMBER;
	
		e_main_error EXCEPTION;
	BEGIN
		csh_transaction_pkg.lock_csh_transaction(p_transaction_id      => p_transaction_id,
																						 p_user_id             => p_user_id,
																						 p_csh_transaction_rec => csh_transaction_rec);
	
		IF csh_transaction_rec.transaction_category <> csh_transaction_pkg.csh_trx_category_business THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.TRX_CATEGORY_ERROR';
			RAISE e_main_error;
		END IF;
		-- 取公司本位币
		v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => csh_transaction_rec.company_id);
		IF v_functional_currency_code IS NULL THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_FUNCTIONAL_CURRENCY_ERROR';
			RAISE e_main_error;
		END IF;
		-- 取帐套
		v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => csh_transaction_rec.company_id);
		IF v_set_of_books_id IS NULL THEN
			v_err_code := 'CSH_WRITE_OFF_PKG.CSH_WRITE_OFF_SET_OF_BOOKS_ERROR';
			RAISE e_main_error;
		END IF;
		FOR c_write_off_temp IN (SELECT * FROM csh_write_off_temp t WHERE t.session_id = p_session_id) LOOP
			v_write_off_id := insert_csh_write_off(p_csh_write_off_temp_rec => c_write_off_temp,
																						 p_csh_transaction_rec    => csh_transaction_rec,
																						 p_set_of_books_id        => v_set_of_books_id,
																						 p_cross_currency_flag    => p_cross_currency_flag,
																						 p_user_id                => p_user_id);
		
			execute_write_off(p_write_off_id        => v_write_off_id,
												p_cross_currency_flag => p_cross_currency_flag,
												p_user_id             => p_user_id);
			--保证金核销租金,新增一条保证金outflow的核销记录
		
			/*--add by 9188 2016/12/27 自动计算罚息
      FOR cu IN (SELECT tt.cashflow_id, tt.contract_id
                   FROM con_contract_cashflow tt
                  WHERE tt.cashflow_id = c_write_off_temp.document_line_id) LOOP
        con_overdue_penalty_pkg.overdue_dayend(p_contract_id => cu.contract_id,
                                               p_cashflow_id => cu.cashflow_id,
                                               p_calc_date => trunc(SYSDATE),
                                               p_user_id => p_user_id);
      END LOOP;*/
		
			--收款核销，处理对应的已生成的坐扣数据 
			IF p_receipt_flag = 'Y' THEN
				BEGIN
					SELECT d.amount
						INTO v_amount
						FROM csh_payment_req_ln_ddct d
					 WHERE d.ref_doc_category = 'CONTRACT'
						 AND d.ref_doc_id = c_write_off_temp.document_id
						 AND d.ref_doc_line_id = c_write_off_temp.document_line_id
						 AND d.deduction_flag = 'N';
					sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'v_amount:' ||
																																											 v_amount ||
																																											 ',write_off_due_amount:' ||
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
			
			END IF;
		END LOOP;
		--modify by 20160902 Spencer 3893 保证金抵扣租金调用次逻辑
		IF nvl(csh_transaction_rec.transaction_amount, 0) = 0 AND
			 csh_transaction_rec.transaction_type = 'RECEIPT' THEN
			csh_deposit_write_off_pkg.insert_deposit_write_off(p_csh_trx_rec => csh_transaction_rec,
																												 p_user_id     => p_user_id);
		END IF;
		--现金事务核销时，现金事务及核销行 合并生成的凭证
		csh_transaction_je_pkg.create_trx_write_off_je(p_transaction_id => p_transaction_id,
																									 p_user_id        => p_user_id);
		-- 删除待处理数据
		delete_csh_write_off_temp(p_session_id => p_session_id, p_user_id => p_user_id);
	EXCEPTION
		WHEN e_main_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'main_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'main_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE deduction_write_off(p_session_id          NUMBER,
																p_company_id          NUMBER,
																p_bp_id               NUMBER,
																p_transaction_date    DATE,
																p_description         VARCHAR2,
																p_source_csh_trx_type VARCHAR2 DEFAULT NULL,
																p_source_csh_trx_id   NUMBER DEFAULT NULL,
																p_source_doc_category VARCHAR2 DEFAULT NULL,
																p_source_doc_type     VARCHAR2 DEFAULT NULL,
																p_source_doc_id       NUMBER DEFAULT NULL,
																p_source_doc_line_id  NUMBER DEFAULT NULL,
																p_user_id             NUMBER,
																p_transaction_id      OUT NUMBER) IS
		v_transaction_id NUMBER;
	
		v_currency            con_contract.currency%TYPE;
		v_period_name         gld_periods.period_name%TYPE;
		v_period_year         gld_periods.period_year%TYPE;
		v_period_num          gld_periods.period_num%TYPE;
		v_internal_period_num gld_periods.internal_period_num%TYPE;
	
		v_amt_in  NUMBER;
		v_amt_out NUMBER;
	
		e_period_not_found EXCEPTION;
		e_diff_currency    EXCEPTION;
		e_inout_amt_err    EXCEPTION;
	BEGIN
	
		gld_common_pkg.get_gld_period_name(p_company_id          => p_company_id,
																			 p_je_company_id       => p_company_id,
																			 p_date                => p_transaction_date,
																			 p_period_name         => v_period_name,
																			 p_period_year         => v_period_year,
																			 p_period_num          => v_period_num,
																			 p_internal_period_num => v_internal_period_num);
	
		IF v_period_name IS NULL OR
			 v_internal_period_num IS NULL THEN
			RAISE e_period_not_found;
		END IF;
	
		BEGIN
			SELECT c.currency
				INTO v_currency
				FROM csh_write_off_temp t,
						 con_contract       c
			 WHERE t.session_id = p_session_id
				 AND t.document_id = c.contract_id
			 GROUP BY c.currency;
		EXCEPTION
			WHEN no_data_found THEN
				RETURN;
			WHEN too_many_rows THEN
				RAISE e_diff_currency;
		END;
	
		--检查收付抵扣金额是否相等
		SELECT SUM(t.write_off_due_amount)
			INTO v_amt_in
			FROM csh_write_off_temp t
		 WHERE t.session_id = p_session_id
			 AND t.write_off_type IN (write_off_type_receipt_credit, write_off_type_pre_credit);
	
		SELECT SUM(t.write_off_due_amount)
			INTO v_amt_out
			FROM csh_write_off_temp t
		 WHERE t.session_id = p_session_id
			 AND t.write_off_type IN (write_off_type_payment_debt, write_off_type_pre_debt);
	
		IF nvl(v_amt_in, 0) <> nvl(v_amt_out, 0) THEN
			RAISE e_inout_amt_err;
		END IF;
	
		csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
																							 p_transaction_num         => NULL,
																							 p_transaction_category    => csh_transaction_pkg.csh_trx_category_business,
																							 p_transaction_type        => csh_transaction_pkg.csh_trx_type_deduction,
																							 p_transaction_date        => p_transaction_date,
																							 p_penalty_calc_date       => p_transaction_date,
																							 p_bank_slip_num           => NULL,
																							 p_company_id              => p_company_id,
																							 p_internal_period_num     => v_internal_period_num,
																							 p_period_name             => v_period_name,
																							 p_payment_method_id       => NULL,
																							 p_distribution_set_id     => NULL,
																							 p_cashflow_amount         => 0,
																							 p_currency_code           => v_currency,
																							 p_transaction_amount      => 0,
																							 p_exchange_rate_type      => NULL,
																							 p_exchange_rate_quotation => NULL,
																							 p_exchange_rate           => 1,
																							 p_bank_account_id         => NULL,
																							 p_bp_category             => NULL,
																							 p_bp_id                   => p_bp_id,
																							 p_bp_bank_account_id      => NULL,
																							 p_bp_bank_account_num     => NULL,
																							 p_description             => p_description,
																							 p_handling_charge         => NULL,
																							 p_posted_flag             => 'N',
																							 p_reversed_flag           => 'N',
																							 p_reversed_date           => NULL,
																							 p_returned_flag           => 'NOT',
																							 p_returned_amount         => NULL,
																							 p_write_off_flag          => 'FULL',
																							 p_write_off_amount        => 0,
																							 p_full_write_off_date     => p_transaction_date,
																							 p_twin_csh_trx_id         => NULL,
																							 p_return_from_csh_trx_id  => NULL,
																							 p_reversed_csh_trx_id     => NULL,
																							 p_source_csh_trx_type     => p_source_csh_trx_type,
																							 p_source_csh_trx_id       => p_source_csh_trx_id,
																							 p_source_doc_category     => p_source_doc_category,
																							 p_source_doc_type         => p_source_doc_type,
																							 p_source_doc_id           => p_source_doc_id,
																							 p_source_doc_line_id      => p_source_doc_line_id,
																							 p_create_je_mothed        => NULL,
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
	
	EXCEPTION
		WHEN e_period_not_found THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.GLD_PERIOD_NOTFOUND',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'deduction_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_diff_currency THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_DIFF_CURRENCY_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'deduction_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN e_inout_amt_err THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_TRANSACTION_PKG.DEDUCTION_INOUT_AMT_ERROR',
																											p_created_by              => p_user_id,
																											p_package_name            => 'csh_write_off_pkg',
																											p_procedure_function_name => 'deduction_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'csh_write_off_pkg',
																										 p_procedure_function_name => 'deduction_write_off');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

END csh_write_off_pkg;
/
