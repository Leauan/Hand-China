CREATE OR REPLACE PACKAGE yonda_csh_transaction_pkg IS

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

	PROCEDURE yonda_auto_write_off_log(p_transaction_id  NUMBER DEFAULT NULL,
																		 p_write_off_id    NUMBER DEFAULT NULL,
																		 p_bp_id           NUMBER DEFAULT NULL,
																		 p_contract_id     NUMBER DEFAULT NULL,
																		 p_bank_account_id NUMBER DEFAULT NULL,
																		 p_message         VARCHAR2);

	PROCEDURE auto_transaction_and_write_off(p_batch_id   NUMBER,
																					 p_user_id    NUMBER,
																					 p_company_id NUMBER,
																					 p_bank_type  VARCHAR2 DEFAULT NULL);

END yonda_csh_transaction_pkg;
/
CREATE OR REPLACE PACKAGE BODY yonda_csh_transaction_pkg IS

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

	-- excle 导入收款匹配承租人
	FUNCTION match_bp_by_name(p_bp_name       IN VARCHAR2,
														p_error_message OUT VARCHAR2) RETURN NUMBER AS
		v_bp_id NUMBER;
	BEGIN
		SELECT tt1.bp_id
			INTO v_bp_id
			FROM hls_bp_master tt1
		 WHERE tt1.bp_name = p_bp_name
			 AND EXISTS (SELECT 1
							FROM con_contract_bp
						 WHERE bp_id = tt1.bp_id
							 AND bp_category = 'TENANT');
		p_error_message := NULL;
		RETURN v_bp_id;
	EXCEPTION
		WHEN no_data_found THEN
			p_error_message := '无法匹配到商业伙伴';
			RETURN NULL;
		WHEN too_many_rows THEN
			p_error_message := '匹配到多个商业伙伴';
			RETURN NULL;
	END match_bp_by_name;
	-- excle 导入收款匹配合同，BP+AMOUNT
	FUNCTION match_contract_by_bp_amount(p_bp_id         IN NUMBER,
																			 p_amount        IN NUMBER,
																			 p_error_message OUT VARCHAR2) RETURN NUMBER AS
		v_contract_id NUMBER;
	BEGIN
		SELECT tt1.contract_id
			INTO v_contract_id
			FROM con_contract    tt1,
					 con_contract_bp tt2
		 WHERE tt1.contract_id = tt2.contract_id
			 AND tt2.bp_id = p_bp_id
			 AND tt1.contract_status NOT IN
					 ('CANCEL', 'AD', 'ET', 'TERMINATE', 'SIGN', 'PRINTED', 'NEW')
			 AND tt1.data_class = 'NORMAL'
			 AND EXISTS (SELECT 1
							FROM con_contract_cashflow
						 WHERE contract_id = tt1.contract_id
							 AND cf_direction = 'INFLOW'
							 AND cf_status = 'RELEASE'
							 AND due_amount - nvl(received_amount, 0) = p_amount);
		p_error_message := NULL;
		RETURN v_contract_id;
	EXCEPTION
		WHEN no_data_found THEN
			p_error_message := '无法匹配到可核销合同（状态不匹配/现金流不匹配）';
			RETURN NULL;
		WHEN too_many_rows THEN
			p_error_message := '匹配到多个可核销合同';
			RETURN NULL;
	END match_contract_by_bp_amount;

	FUNCTION get_cashflow_by_contract(p_contract_id   NUMBER,
																		p_amount        NUMBER,
																		p_error_message OUT VARCHAR2)
		RETURN con_contract_cashflow%ROWTYPE AS
		r_con_contract_cashflow con_contract_cashflow%ROWTYPE;
		v_min_times             NUMBER;
	BEGIN
		SELECT MIN(ccf.times)
			INTO v_min_times
			FROM con_contract_cashflow ccf
		 WHERE ccf.cf_status = 'RELEASE'
			 AND ccf.cf_direction = 'INFLOW'
			 AND ccf.due_amount - nvl(ccf.received_amount, 0) = p_amount
			 AND ccf.contract_id = p_contract_id;
		SELECT *
			INTO r_con_contract_cashflow
			FROM con_contract_cashflow ccf
		 WHERE ccf.cf_status = 'RELEASE'
			 AND ccf.cf_direction = 'INFLOW'
			 AND ccf.due_amount - nvl(ccf.received_amount, 0) = p_amount
			 AND ccf.times = v_min_times
			 AND ccf.contract_id = p_contract_id;
		p_error_message := NULL;
		RETURN r_con_contract_cashflow;
	EXCEPTION
		WHEN OTHERS THEN
			p_error_message := '获取现金流失败';
			RETURN NULL;
	END get_cashflow_by_contract;

	PROCEDURE get_bp_band_account(p_bp_bank_account_num IN VARCHAR2,
																p_bp_id               NUMBER,
																p_bp_bank_account_id  OUT NUMBER) AS
	BEGIN
		SELECT tt.bank_account_id
			INTO p_bp_bank_account_id
			FROM hls_bp_master_bank_account tt
		 WHERE tt.bank_account_num = p_bp_bank_account_num
			 AND tt.bp_id = p_bp_id;
	EXCEPTION
		WHEN OTHERS THEN
			NULL;
	END get_bp_band_account;

	PROCEDURE get_company_band_account(p_company_bank_account_num IN VARCHAR2,
																		 p_bank_account_id          OUT NUMBER,
																		 p_currency_code            OUT VARCHAR2) AS
	BEGIN
		SELECT bank_account_id,
					 tt.currency_code
			INTO p_bank_account_id,
					 p_currency_code
			FROM csh_bank_account tt
		 WHERE tt.bank_account_num = p_company_bank_account_num;
	EXCEPTION
		WHEN OTHERS THEN
			NULL;
	END get_company_band_account;

	FUNCTION get_contract_id(p_contract_number VARCHAR2) RETURN NUMBER IS
		v_contract_id NUMBER;
	BEGIN
		SELECT cc.contract_id
			INTO v_contract_id
			FROM con_contract cc
		 WHERE cc.contract_number = p_contract_number
			 AND cc.data_class = 'NORMAL';
		RETURN v_contract_id;
	EXCEPTION
		WHEN no_data_found THEN
			RETURN NULL;
	END get_contract_id;

	/************interface*************/
	PROCEDURE auto_transaction_and_write_off(p_batch_id   NUMBER,
																					 p_user_id    NUMBER,
																					 p_company_id NUMBER,
																					 p_bank_type  VARCHAR2 DEFAULT NULL) AS
		v_bp_id                 NUMBER;
		v_contract_id           NUMBER;
		v_bp_bank_account_id    NUMBER;
		v_bank_account_id       NUMBER;
		v_currency_code         VARCHAR2(30);
		v_auto_write_off_flag   VARCHAR2(1) := 'N';
		v_auto_write_off_type   VARCHAR2(100);
		v_min_times             NUMBER;
		v_period_name           VARCHAR2(30);
		v_internal_period_num   NUMBER;
		v_transaction_id        NUMBER;
		v_session_id            NUMBER;
		v_transaction_num       VARCHAR2(30);
		r_con_contract_cashflow con_contract_cashflow%ROWTYPE;
		r_con_contract_bp       con_contract_bp%ROWTYPE;
		v_head_message          VARCHAR2(2000);
		v_front_message         VARCHAR2(2000);
	
		v_count     NUMBER;
		v_error_msg VARCHAR2(4000);
		e_data_error EXCEPTION;
		v_unreceived_amount NUMBER;
	BEGIN
		IF p_bank_type IS NULL THEN
			--通用导入  未指定银行时保留之前逻辑
			-- lock the tmpt data 
			FOR cc_record IN (SELECT *
													FROM csh_transaction_temp a
												 WHERE a.batch_id = p_batch_id
													 FOR UPDATE NOWAIT) LOOP
				v_contract_id           := NULL; --reset data
				v_bp_id                 := NULL;
				r_con_contract_cashflow := NULL;
				v_auto_write_off_flag   := 'N'; -- reset the control flag
				v_head_message          := to_char(cc_record.transaction_date, 'YYYY-MM-DD') || '来自' ||
																	 cc_record.bp_name || '的一笔' || cc_record.transaction_amount ||
																	 '收款，';
				--1. match bp
				v_bp_id := match_bp_by_name(p_bp_name       => cc_record.bp_name,
																		p_error_message => v_front_message);
				IF v_bp_id IS NOT NULL THEN
					--2. match contract
					v_contract_id := match_contract_by_bp_amount(p_bp_id         => v_bp_id,
																											 p_amount        => cc_record.transaction_amount,
																											 p_error_message => v_front_message);
					IF v_contract_id IS NOT NULL THEN
						--3. get cashflow & bp & contract
						SELECT *
							INTO r_con_contract_bp
							FROM con_contract_bp
						 WHERE contract_id = v_contract_id
							 AND bp_id = v_bp_id
							 AND bp_category = 'TENANT';
						r_con_contract_cashflow := get_cashflow_by_contract(p_contract_id   => v_contract_id,
																																p_amount        => cc_record.transaction_amount,
																																p_error_message => v_front_message);
						IF v_front_message IS NULL THEN
							v_auto_write_off_flag := 'Y'; -- here to control if write off
						END IF;
					END IF;
				END IF;
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
				SELECT v.period_name,
							 gld_common_pkg.get_gld_internal_period_num(p_company_id, v.period_name) internal_period_num
					INTO v_period_name,
							 v_internal_period_num
					FROM (SELECT gld_common_pkg.get_gld_period_name(p_company_id,
																													trunc(cc_record.transaction_date)) period_name
									FROM dual) v;
				-- 6. transaction
				csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
																									 p_transaction_num         => v_transaction_num,
																									 p_transaction_category    => 'BUSINESS',
																									 p_transaction_type        => 'RECEIPT',
																									 p_transaction_date        => trunc(cc_record.transaction_date),
																									 p_penalty_calc_date       => trunc(cc_record.transaction_date),
																									 p_bank_slip_num           => NULL,
																									 p_company_id              => p_company_id,
																									 p_internal_period_num     => v_internal_period_num,
																									 p_period_name             => v_period_name,
																									 p_payment_method_id       => 1,
																									 p_distribution_set_id     => NULL,
																									 p_cashflow_amount         => cc_record.transaction_amount,
																									 p_currency_code           => nvl(v_currency_code,
																																										'CNY'),
																									 p_transaction_amount      => cc_record.transaction_amount,
																									 p_exchange_rate_type      => NULL,
																									 p_exchange_rate_quotation => NULL,
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
																									 p_source_doc_category     => 'CONTRACT',
																									 p_source_doc_type         => NULL,
																									 p_source_doc_id           => v_contract_id,
																									 p_source_doc_line_id      => r_con_contract_cashflow.cashflow_id,
																									 p_create_je_mothed        => NULL,
																									 p_create_je_flag          => 'N',
																									 p_gld_interface_flag      => 'N',
																									 p_user_id                 => p_user_id,
																									 p_ref_contract_id         => NULL,
																									 p_csh_bp_name             => cc_record.bp_name);
				UPDATE csh_transaction ct
					 SET ct.receipt_type = 'IMPORT'
				 WHERE ct.transaction_id = v_transaction_id;
				--7. write off
				IF v_auto_write_off_flag = 'Y' THEN
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
						/*csh_write_off_pkg.main_write_off(p_session_id     => v_session_id,
            p_transaction_id => v_transaction_id,
            p_user_id        => p_user_id);*/
						v_front_message := '自动核销成功';
					EXCEPTION
						WHEN OTHERS THEN
							ROLLBACK TO start_auto_write_off;
							v_front_message := '核销错误，未能自动核销';
					END;
				END IF;
				-- 8. record log
				yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
																 p_bp_id           => v_bp_id,
																 p_contract_id     => v_contract_id,
																 p_bank_account_id => v_bp_bank_account_id,
																 p_message         => v_head_message || v_front_message);
			END LOOP;
		ELSIF p_bank_type IN ('HSBC', 'ICBC') THEN
			--华夏银行、工商银行
			FOR cc_record IN (SELECT *
													FROM csh_transaction_temp a
												 WHERE a.batch_id = p_batch_id
													 FOR UPDATE NOWAIT) LOOP
				v_head_message        := to_char(cc_record.transaction_date, 'YYYY-MM-DD') || '来自' ||
																 cc_record.bp_name || '的一笔' || cc_record.transaction_amount || '收款';
				v_auto_write_off_flag := 'N';
				v_auto_write_off_type := NULL;
				v_min_times           := NULL;
				v_unreceived_amount   := NULL;
				r_con_contract_bp     := NULL;
				v_bp_id               := NULL;
				--1.
				v_contract_id := get_contract_id(p_contract_number => cc_record.contract_number);
				IF v_contract_id IS NOT NULL THEN
					SELECT *
						INTO r_con_contract_bp
						FROM con_contract_bp
					 WHERE contract_id = v_contract_id
						 AND bp_category = 'TENANT';
				
					--2.
					v_bp_id := r_con_contract_bp.bp_id;
				
					--3.匹配规则：
					----1.存在首付款和手续费未核销完成，按未核销金额匹配收款金额
					----2.取最小一期未核销完租金，按未核销金额匹配收款金额
					SELECT nvl(SUM(ccc.due_amount - nvl(ccc.received_amount, 0)), 0)
						INTO v_unreceived_amount
						FROM con_contract_cashflow ccc
					 WHERE ccc.cf_item IN (2, 3)
						 AND ccc.cf_direction = 'INFLOW'
						 AND ccc.cf_status = 'RELEASE'
						 AND ccc.write_off_flag <> 'FULL'
						 AND ccc.contract_id = v_contract_id;
					IF v_unreceived_amount <> 0 THEN
						--1.存在首付款和手续费未核销完成，按未核销金额匹配收款金额
						IF v_unreceived_amount = cc_record.transaction_amount THEN
							v_auto_write_off_type := '首付款和手续费';
							v_auto_write_off_flag := 'Y';
						END IF;
					ELSE
						SELECT MIN(ccc.times)
							INTO v_min_times
							FROM con_contract_cashflow ccc
						 WHERE ccc.cf_item = 1
							 AND ccc.cf_direction = 'INFLOW'
							 AND ccc.cf_status = 'RELEASE'
							 AND ccc.write_off_flag <> 'FULL'
							 AND ccc.contract_id = v_contract_id;
						IF v_min_times IS NOT NULL THEN
							----2.取最小一期未核销完租金，按未核销金额匹配收款金额
							SELECT ccc.due_amount - nvl(ccc.received_amount, 0)
								INTO v_unreceived_amount
								FROM con_contract_cashflow ccc
							 WHERE ccc.cf_item = 1
								 AND ccc.cf_direction = 'INFLOW'
								 AND ccc.cf_status = 'RELEASE'
								 AND ccc.write_off_flag <> 'FULL'
								 AND ccc.times = v_min_times
								 AND ccc.contract_id = v_contract_id;
							IF v_unreceived_amount = cc_record.transaction_amount THEN
								v_auto_write_off_type := '租金';
								v_auto_write_off_flag := 'Y';
							END IF;
						END IF;
					END IF;
				END IF;
			
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
				SELECT v.period_name,
							 gld_common_pkg.get_gld_internal_period_num(p_company_id, v.period_name) internal_period_num
					INTO v_period_name,
							 v_internal_period_num
					FROM (SELECT gld_common_pkg.get_gld_period_name(p_company_id,
																													trunc(cc_record.transaction_date)) period_name
									FROM dual) v;
				-- 6. transaction
				csh_transaction_pkg.insert_csh_transaction(p_transaction_id          => v_transaction_id,
																									 p_transaction_num         => v_transaction_num,
																									 p_transaction_category    => 'BUSINESS',
																									 p_transaction_type        => 'RECEIPT',
																									 p_transaction_date        => cc_record.transaction_date /*trunc(cc_record.transaction_date)*/,
																									 p_penalty_calc_date       => cc_record.transaction_date /*trunc(cc_record.transaction_date)*/,
																									 p_bank_slip_num           => NULL,
																									 p_company_id              => p_company_id,
																									 p_internal_period_num     => v_internal_period_num,
																									 p_period_name             => v_period_name,
																									 p_payment_method_id       => 1,
																									 p_distribution_set_id     => NULL,
																									 p_cashflow_amount         => cc_record.transaction_amount,
																									 p_currency_code           => nvl(v_currency_code,
																																										'CNY'),
																									 p_transaction_amount      => cc_record.transaction_amount,
																									 p_exchange_rate_type      => NULL,
																									 p_exchange_rate_quotation => NULL,
																									 p_exchange_rate           => 1,
																									 p_bank_account_id         => v_bank_account_id,
																									 p_bp_category             => r_con_contract_bp.bp_category,
																									 p_bp_id                   => v_bp_id,
																									 p_bp_bank_account_id      => v_bp_bank_account_id,
																									 p_bp_bank_account_num     => cc_record.bp_bank_account_num,
																									 p_description             => cc_record.description,
																									 p_handling_charge         => 0,
																									 p_posted_flag             => /*'Y'*/ 'N', --等修改完是否及时收款字段，再进行过账
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
																									 p_source_doc_category     => 'CONTRACT',
																									 p_source_doc_type         => NULL,
																									 p_source_doc_id           => NULL,
																									 p_source_doc_line_id      => NULL /*r_con_contract_cashflow.cashflow_id*/,
																									 p_create_je_mothed        => NULL,
																									 p_create_je_flag          => 'N',
																									 p_gld_interface_flag      => 'N',
																									 p_user_id                 => p_user_id,
																									 p_ref_contract_id         => v_contract_id,
																									 p_csh_bp_name             => cc_record.bp_name);
				IF v_auto_write_off_flag = 'Y' THEN
					UPDATE csh_transaction ct
						 SET ct.timely_write_off_flag = 'Y', --及时收款状态改为Y，过账时生成不收款凭证，直接生成收款核销凭证 
								 ct.receipt_type          = 'IMPORT',
								 ct.account_balance       = cc_record.account_balance,
								 ct.contract_number       = cc_record.contract_number
					 WHERE ct.transaction_id = v_transaction_id;
				ELSE
					UPDATE csh_transaction ct
						 SET ct.timely_write_off_flag = 'N', --及时收款状态改为N，过账时生成收款凭证，否则只生成合并过账凭证
								 ct.receipt_type          = 'IMPORT',
								 ct.account_balance       = cc_record.account_balance,
								 ct.contract_number       = cc_record.contract_number
					 WHERE ct.transaction_id = v_transaction_id;
				END IF;
				--过账
				csh_transaction_pkg.post_csh_transaction(p_transaction_id => v_transaction_id,
																								 p_user_id        => p_user_id);
			
				--7. write off
				IF v_auto_write_off_flag = 'Y' THEN
					--SAVEPOINT start_auto_write_off;
					BEGIN
						v_session_id := sys_session_s.nextval;
					
						IF v_auto_write_off_type = '首付款和手续费' THEN
							FOR c_cashflow IN (SELECT *
																	 FROM con_contract_cashflow ccc
																	WHERE ccc.cf_item IN (2, 3)
																		AND ccc.cf_direction = 'INFLOW'
																		AND ccc.cf_status = 'RELEASE'
																		AND ccc.write_off_flag <> 'FULL'
																		AND ccc.contract_id = v_contract_id
																		FOR UPDATE NOWAIT) LOOP
								csh_write_off_pkg.insert_csh_write_off_temp(p_session_id           => v_session_id,
																														p_write_off_type       => 'RECEIPT_CREDIT',
																														p_transaction_category => 'BUSINESS',
																														p_transaction_type     => 'RECEIPT',
																														p_write_off_date       => trunc(SYSDATE),
																														p_write_off_due_amount => nvl(c_cashflow.due_amount,
																																													0) -
																																											nvl(c_cashflow.received_amount,
																																													0),
																														p_write_off_principal  => nvl(c_cashflow.principal,
																																													0) -
																																											nvl(c_cashflow.received_principal,
																																													0),
																														p_write_off_interest   => nvl(c_cashflow.interest,
																																													0) -
																																											nvl(c_cashflow.received_interest,
																																													0),
																														p_company_id           => p_company_id,
																														p_document_category    => 'CONTRACT',
																														p_document_id          => c_cashflow.contract_id,
																														p_document_line_id     => c_cashflow.cashflow_id,
																														p_description          => '收款导入自动核销生成',
																														p_user_id              => p_user_id);
							END LOOP;
						ELSIF v_auto_write_off_type = '租金' THEN
							FOR c_cashflow IN (SELECT *
																	 FROM con_contract_cashflow ccc
																	WHERE ccc.cf_item = 1
																		AND ccc.cf_direction = 'INFLOW'
																		AND ccc.cf_status = 'RELEASE'
																		AND ccc.write_off_flag <> 'FULL'
																		AND ccc.times = v_min_times
																		AND ccc.contract_id = v_contract_id
																		FOR UPDATE NOWAIT) LOOP
								csh_write_off_pkg.insert_csh_write_off_temp(p_session_id           => v_session_id,
																														p_write_off_type       => 'RECEIPT_CREDIT',
																														p_transaction_category => 'BUSINESS',
																														p_transaction_type     => 'RECEIPT',
																														p_write_off_date       => trunc(SYSDATE),
																														p_write_off_due_amount => nvl(c_cashflow.due_amount,
																																													0) -
																																											nvl(c_cashflow.received_amount,
																																													0),
																														p_write_off_principal  => nvl(c_cashflow.principal,
																																													0) -
																																											nvl(c_cashflow.received_principal,
																																													0),
																														p_write_off_interest   => nvl(c_cashflow.interest,
																																													0) -
																																											nvl(c_cashflow.received_interest,
																																													0),
																														p_company_id           => p_company_id,
																														p_document_category    => 'CONTRACT',
																														p_document_id          => c_cashflow.contract_id,
																														p_document_line_id     => c_cashflow.cashflow_id,
																														p_description          => '收款导入自动核销生成',
																														p_user_id              => p_user_id);
							END LOOP;
						END IF;
						csh_write_off_pkg.main_write_off(p_session_id     => v_session_id,
																						 p_transaction_id => v_transaction_id,
																						 p_user_id        => p_user_id);
						v_front_message := '自动核销成功';
					EXCEPTION
						WHEN OTHERS THEN
							--ROLLBACK TO start_auto_write_off;
							v_front_message := '核销错误，未能自动核销';
					END;
				END IF;
				-- 8. record log
				yonda_auto_write_off_log(p_transaction_id  => v_transaction_id,
																 p_bp_id           => v_bp_id,
																 p_contract_id     => v_contract_id,
																 p_bank_account_id => v_bp_bank_account_id,
																 p_message         => v_head_message || v_front_message);
			END LOOP;
		END IF;
	END auto_transaction_and_write_off;

END yonda_csh_transaction_pkg;
/
