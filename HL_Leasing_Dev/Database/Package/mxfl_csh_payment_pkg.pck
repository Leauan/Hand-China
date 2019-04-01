CREATE OR REPLACE PACKAGE mxfl_csh_payment_pkg IS

	-- Author  : huiyong.hu
	-- Created : 2017/10/3 10:41:22
	-- Purpose : 付款支付

	--生成付款批次记录
	PROCEDURE create_payment_ln_batch(p_batch_id   OUT NUMBER,
																		p_bank_type  VARCHAR2,
																		p_company_id NUMBER,
																		p_user_id    NUMBER);
	--导入付款记录
	PROCEDURE import_payment_ln;

	--获取银行信息
	FUNCTION get_bank_account_id(p_bank_type VARCHAR2) RETURN NUMBER;
	--获取银行信息（保险公司账户）
	FUNCTION get_bp_bank_account_id(p_contract_id NUMBER,
																	p_bank_type   VARCHAR2) RETURN NUMBER;

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
											p_bank_type     VARCHAR2,
											p_company_id    NUMBER,
											p_session_id    NUMBER,
											p_user_id       NUMBER,
											po_save_message OUT VARCHAR2);

END mxfl_csh_payment_pkg;
/
CREATE OR REPLACE PACKAGE BODY mxfl_csh_payment_pkg IS

	PROCEDURE insert_payment_ln_batch(p_batch_id          NUMBER,
																		p_payment_req_ln_id NUMBER,
																		p_bank_type         VARCHAR2,
																		p_user_id           NUMBER) IS
	BEGIN
		INSERT INTO csh_payment_req_ln_batch
			(batch_id,
			 payment_req_ln_id,
			 status,
			 bank_type,
			 last_update_date,
			 last_updated_by,
			 creation_date,
			 created_by)
		VALUES
			(p_batch_id,
			 p_payment_req_ln_id,
			 'EXPORT',
			 p_bank_type,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
	END insert_payment_ln_batch;

	--生成付款批次记录
	PROCEDURE create_payment_ln_batch(p_batch_id   OUT NUMBER,
																		p_bank_type  VARCHAR2,
																		p_company_id NUMBER,
																		p_user_id    NUMBER) IS
	BEGIN
		p_batch_id := csh_payment_req_ln_batch_s.nextval;
	
		--是否需要完善限制，待定
		FOR c_req_ln IN (SELECT *
											 FROM csh_payment_req_ln cprl
											WHERE cprl.payment_status <> 'FULL'
												AND EXISTS (SELECT 1
															 FROM csh_payment_req_hd cprh
															WHERE cprh.payment_req_id = cprl.payment_req_id
																AND cprh.approval_status = 'APPROVED'
																AND nvl(cprh.closed_flag, 'N') <> 'Y')
												AND EXISTS (SELECT 1
															 FROM con_contract_cashflow ccc
															WHERE ccc.cashflow_id = cprl.ref_doc_line_id
																AND ccc.cf_item = 5 --保费金额  为了方便测试暂时注释掉
																AND ccc.cf_direction = 'OUTFLOW'
																AND ccc.cf_status = 'RELEASE') --只导出保费 
												AND NOT EXISTS
											(SELECT 1
															 FROM csh_payment_req_ln_batch cprlb
															WHERE cprlb.payment_req_ln_id = cprl.payment_req_ln_id
																AND cprlb.status = 'EXPORT') --不存在已经导出，但未导回数据
												FOR UPDATE) LOOP
		
			insert_payment_ln_batch(p_batch_id          => p_batch_id,
															p_payment_req_ln_id => c_req_ln.payment_req_ln_id,
															p_bank_type         => p_bank_type,
															p_user_id           => p_user_id);
		
			--冻结现金流
			UPDATE con_contract_cashflow ccc
				 SET ccc.cf_status = 'BLOCK'
			 WHERE ccc.cashflow_id = c_req_ln.ref_doc_line_id;
		END LOOP;
	END create_payment_ln_batch;

	--导入付款记录
	PROCEDURE import_payment_ln IS
	BEGIN
		UPDATE csh_payment_req_ln_batch b SET b.status = 'IMPORT';
	
		--释放现金流
		UPDATE con_contract_cashflow ccc
			 SET ccc.cf_status = 'RELEASE'
		 WHERE EXISTS (SELECT 1
							FROM csh_payment_req_ln_batch b,
									 csh_payment_req_ln       l,
									 con_contract_cashflow    c
						 WHERE l.payment_req_ln_id = b.payment_req_ln_id
							 AND c.cashflow_id = l.ref_doc_line_id);
	END import_payment_ln;

	--获取银行信息（公司账户）
	FUNCTION get_bank_account_id(p_bank_type VARCHAR2) RETURN NUMBER IS
		v_bank_account_num VARCHAR2(200);
		v_bank_account_id  NUMBER;
	BEGIN
		--账号写死
		IF p_bank_type = 'HSBC' THEN
			v_bank_account_num := '10567000000310048';
		ELSIF p_bank_type = 'ICBC' THEN
			v_bank_account_num := '1001281219007030000';
		END IF;
	
		BEGIN
			SELECT a.bank_account_id
				INTO v_bank_account_id
				FROM csh_bank_account a
			 WHERE a.bank_account_num = v_bank_account_num
				 AND a.enabled_flag = 'Y'
				 AND rownum = 1;
		EXCEPTION
			WHEN no_data_found THEN
				v_bank_account_id := NULL;
		END;
	
		RETURN v_bank_account_id;
	END get_bank_account_id;

	--获取银行信息（保险公司账户）
	FUNCTION get_bp_bank_account_id(p_contract_id NUMBER,
																	p_bank_type   VARCHAR2) RETURN NUMBER IS
		v_bank_account_id NUMBER;
	BEGIN
		BEGIN
			SELECT a.bank_account_id
				INTO v_bank_account_id
				FROM hls_bp_master_bank_account a,
						 con_contract               cc
			 WHERE cc.insurance_company_id = a.bp_id
				 AND cc.contract_id = p_contract_id
				 AND a.enabled_flag = 'Y'
				 AND rownum = 1; --后期可能要调整，暂时默认只有一条
		EXCEPTION
			WHEN no_data_found THEN
				v_bank_account_id := NULL;
		END;
	
		RETURN v_bank_account_id;
	END get_bp_bank_account_id;

	PROCEDURE delete_interface(p_batch_id NUMBER,
														 p_user_id  NUMBER) IS
	BEGIN
		DELETE FROM csh_payment_import t WHERE t.batch_id = p_batch_id;
	EXCEPTION
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'mxfl_csh_payment_pkg',
																										 p_procedure_function_name => 'delete_interface');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END delete_interface;

	PROCEDURE insert_interface(p_header_id NUMBER,
														 p_batch_id  NUMBER,
														 p_user_id   NUMBER,
														 p_bank_type VARCHAR2 DEFAULT NULL) IS
	BEGIN
		IF p_bank_type = 'HSBC' THEN
			--华夏银行
			FOR c_record IN (SELECT *
												 FROM fnd_interface_lines l
												WHERE l.header_id = p_header_id
													AND l.line_number >= 1
													AND l.attribute_3 IS NOT NULL
													AND l.attribute_4 IS NULL) LOOP
				INSERT INTO csh_payment_import
					(batch_id,
					 import_id,
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
					 csh_payment_import_s.nextval,
					 to_date(c_record.attribute_1, 'YYYY-MM-DD'), --交易日期
					 c_record.attribute_2, --交易描述
					 to_number(c_record.attribute_3), --借方发生额：付款金额
					 --to_number(c_record.attribute_4), --贷方发生额:收款金额
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
													AND l.attribute_6 IS NOT NULL
													AND l.attribute_7 IS NULL) LOOP
				INSERT INTO csh_payment_import
					(batch_id,
					 import_id,
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
					 csh_payment_import_s.nextval,
					 --c_record.attribute_1--凭证号
					 c_record.attribute_2, --本方账号：收款账号
					 c_record.attribute_3, --对方账号：对方账户
					 to_date(c_record.attribute_4, 'yyyy-mm-dd hh24:mi:ss'), --交易日期 保留时分
					 --c_record.attribute_5,--借/贷
					 to_number(c_record.attribute_6), --借方发生额：付款金额
					 --to_number(c_record.attribute_7), --贷方发生额:收款金额
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
	END insert_interface;

	PROCEDURE delete_error_logs(p_batch_id NUMBER) IS
	BEGIN
		DELETE FROM csh_payment_import_logs a WHERE a.batch_id = p_batch_id;
	END delete_error_logs;

	PROCEDURE txn_log(p_temp     IN csh_payment_import%ROWTYPE,
										p_log_text IN VARCHAR2,
										p_user_id  IN NUMBER) IS
	BEGIN
		INSERT INTO csh_payment_import_logs
			(batch_id,
			 import_logs_id,
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
			 csh_payment_import_logs_s.nextval,
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

	PROCEDURE check_data(p_batch_id  NUMBER,
											 p_user_id   NUMBER,
											 p_return_id OUT NUMBER,
											 p_bank_type VARCHAR2 DEFAULT NULL) IS
		v_bp_bank_account_exist_flag VARCHAR2(2) := 'N';
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
	
		IF p_bank_type = 'HSBC' THEN
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
			
				/*--与系统现金事务存在完全相同即不允许导入
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
        END IF;*/
			
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
			
				/*--与系统现金事务存在完全相同即不允许导入
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
        END IF;*/
			
				v_line_num := v_line_num + 1;
			END LOOP;
		END IF;
	END check_data;

	PROCEDURE delete_temp(p_batch_id NUMBER) IS
	BEGIN
		DELETE FROM csh_payment_import t WHERE t.batch_id = p_batch_id;
		DELETE FROM csh_payment_import_logs t WHERE t.batch_id = p_batch_id;
	END delete_temp;

	PROCEDURE auto_write_off(p_batch_id   NUMBER,
													 p_bank_type  VARCHAR2,
													 p_session_id NUMBER,
													 p_company_id NUMBER,
													 p_user_id    NUMBER) IS
		v_batch_id            NUMBER;
		v_payment_req_id      NUMBER;
		v_payment_req_ln_id   NUMBER;
		v_cashflow_id         NUMBER;
		v_period_name         gld_periods.period_name%TYPE;
		v_period_year         gld_periods.period_year%TYPE;
		v_period_num          gld_periods.period_num%TYPE;
		v_internal_period_num gld_periods.internal_period_num%TYPE;
		v_bank_account_id     NUMBER;
		v_bp_bank_account_id  NUMBER;
		v_payment_status      VARCHAR2(30);
	BEGIN
		IF p_bank_type IN ('HSBC', 'ICBC') THEN
			--华夏银行、工商银行
			FOR cc_record IN (SELECT cpi.*
													FROM csh_payment_import cpi
												 WHERE cpi.batch_id = p_batch_id
													 FOR UPDATE NOWAIT) LOOP
				BEGIN
					SELECT cprlb.batch_id,
								 cprl.payment_req_id,
								 cprl.payment_req_ln_id,
								 ccc.cashflow_id
						INTO v_batch_id,
								 v_payment_req_id,
								 v_payment_req_ln_id,
								 v_cashflow_id
						FROM csh_payment_req_ln_batch cprlb,
								 csh_payment_req_ln       cprl,
								 con_contract_cashflow    ccc,
								 con_contract             cc
					 WHERE cprl.payment_req_ln_id = cprlb.payment_req_ln_id
						 AND ccc.cashflow_id = cprl.ref_doc_line_id
						 AND cc.contract_id = ccc.contract_id
						 AND ccc.cf_item = 5 --保费
						 AND cprlb.status = 'EXPORT' --导出状态
						 AND cc.contract_number = cc_record.contract_number; --合同编号
				EXCEPTION
					WHEN no_data_found THEN
						continue;
				END;
			
				--delete
				DELETE FROM csh_payment_req_ln_tmp l
				 WHERE l.type = 'PAYMENT_REQ_PAYMENT'
					 AND l.session_id = p_session_id;
				--insert 
				INSERT INTO csh_payment_req_ln_tmp
					(session_id,
					 TYPE,
					 id,
					 amt)
				VALUES
					(p_session_id,
					 'PAYMENT_REQ_PAYMENT',
					 v_payment_req_ln_id,
					 cc_record.transaction_amount);
			
				gld_common_pkg.get_gld_period_name(p_company_id          => p_company_id,
																					 p_je_company_id       => p_company_id,
																					 p_date                => trunc(cc_record.transaction_date),
																					 p_period_name         => v_period_name,
																					 p_period_year         => v_period_year,
																					 p_period_num          => v_period_num,
																					 p_internal_period_num => v_internal_period_num);
			
				SELECT cba.bank_account_id
					INTO v_bank_account_id
					FROM csh_bank_account cba
				 WHERE cba.bank_account_num = cc_record.bank_account_num
					 AND rownum = 1;
			
				SELECT a.bank_account_id
					INTO v_bp_bank_account_id
					FROM hls_bp_master_bank_account a
				 WHERE a.bank_account_num = cc_record.bp_bank_account_num
					 AND rownum = 1;
			
				--冻结现金流
				UPDATE con_contract_cashflow ccc
					 SET ccc.cf_status = 'RELEASE'
				 WHERE ccc.cashflow_id = v_cashflow_id;
			
				UPDATE csh_payment_req_ln_batch b
					 SET b.status           = 'IMPORT',
							 b.last_updated_by  = p_user_id,
							 b.last_update_date = SYSDATE
				 WHERE b.batch_id = v_batch_id
					 AND b.payment_req_ln_id = v_payment_req_ln_id;
			
				csh_payment_req_pkg.payment_csh_payment(p_payment_req_id          => v_payment_req_id,
																								p_session_id              => p_session_id,
																								p_pay_date                => trunc(cc_record.transaction_date),
																								p_pay_amount              => cc_record.transaction_amount,
																								p_company_id              => p_company_id,
																								p_internal_period_num     => v_internal_period_num,
																								p_period_name             => v_period_name,
																								p_exchange_rate_type      => NULL,
																								p_exchange_rate_quotation => 'DIRECT QUOTATION',
																								p_exchange_rate           => 1,
																								p_bank_account_id         => v_bank_account_id,
																								p_bank_account_num        => cc_record.bank_account_num,
																								p_description             => cc_record.contract_number ||
																																						 '合同受托付款',
																								p_user_id                 => p_user_id,
																								p_cashflow_id             => v_cashflow_id,
																								p_bank_slip_num           => NULL,
																								p_bp_bank_account_id      => v_bp_bank_account_id,
																								p_bp_bank_account_num     => cc_record.bp_bank_account_num,
																								p_handling_charge         => 0,
																								p_payment_method_id       => NULL,
																								p_payment_status          => v_payment_status,
																								p_merge_flag              => 'Y');
			END LOOP;
		END IF;
	END auto_write_off;

	PROCEDURE save_data(p_batch_id      NUMBER,
											p_bank_type     VARCHAR2,
											p_company_id    NUMBER,
											p_session_id    NUMBER,
											p_user_id       NUMBER,
											po_save_message OUT VARCHAR2) AS
	BEGIN
		-- transaction & write off
		auto_write_off(p_batch_id   => p_batch_id,
									 p_bank_type  => p_bank_type,
									 p_company_id => p_company_id,
									 p_session_id => p_session_id,
									 p_user_id    => p_user_id);
		--删除临时表数据
		delete_temp(p_batch_id);
	END save_data;

END mxfl_csh_payment_pkg;
/
