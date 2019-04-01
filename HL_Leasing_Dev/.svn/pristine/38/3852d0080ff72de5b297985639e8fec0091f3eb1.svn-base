CREATE OR REPLACE PACKAGE cux_con_borrow_pkg IS

	-- Author  : hhy
	-- Created : 2017/12/6 16:41:46
	-- Purpose : 合同文本借阅

	c_borrow_status_10 CONSTANT VARCHAR2(30) := '10'; -- 未借出
	--c_borrow_status_20 CONSTANT VARCHAR2(30) := '20'; -- 新建
	c_borrow_status_30 CONSTANT VARCHAR2(30) := '30'; -- 已借出
	c_borrow_status_40 CONSTANT VARCHAR2(30) := '40'; -- 已归还

	PROCEDURE insert_con_borrow_hd(po_hd_id       OUT NUMBER,
																 p_borrowers_id NUMBER,
																 p_user_id      NUMBER);

	PROCEDURE insert_con_borrow_ln(p_hd_id       NUMBER,
																 p_contract_id NUMBER,
																 p_user_id     NUMBER);

	PROCEDURE delete_con_borrow_new(p_hd_id   NUMBER,
																	p_user_id NUMBER);

	PROCEDURE update_con_borrow_hd(p_hd_id            NUMBER,
																 p_borrowers_id     NUMBER,
																 p_borrow_date_from DATE,
																 p_borrow_date_to   DATE,
																 p_borrow_status    VARCHAR2,
																 p_user_id          NUMBER);

	PROCEDURE delete_con_borrow_ln(p_ln_id   NUMBER,
																 p_user_id NUMBER);

	PROCEDURE confirm_con_borrow(p_hd_id   NUMBER,
															 p_user_id NUMBER);

	PROCEDURE return_con_borrow_sign(p_contract_id NUMBER,
																	 p_user_id     NUMBER);

	PROCEDURE return_con_borrow(p_hd_id   NUMBER,
															p_user_id NUMBER);

	PROCEDURE delete_con_borrow_content(p_hd_id   NUMBER,
																			p_user_id NUMBER);

	PROCEDURE insert_con_borrow_content_type(p_hd_id       NUMBER,
																					 p_description VARCHAR2,
																					 p_checked     VARCHAR2,
																					 p_user_id     NUMBER);

	PROCEDURE create_con_borrow_content(p_hd_id   NUMBER,
																			p_user_id NUMBER);

	PROCEDURE insert_con_borrow_content_dl(p_hd_id   NUMBER,
																				 p_user_id NUMBER);
END cux_con_borrow_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_con_borrow_pkg IS

	PROCEDURE insert_con_borrow_hd(po_hd_id       OUT NUMBER,
																 p_borrowers_id NUMBER,
																 p_user_id      NUMBER) IS
	BEGIN
		po_hd_id := cux_con_borrow_hd_s.nextval;
	
		INSERT INTO cux_con_borrow_hd
			(hd_id,
			 borrowers_id,
			 borrow_date_from,
			 borrow_date_to,
			 borrow_status,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(po_hd_id,
			 p_borrowers_id,
			 NULL,
			 NULL,
			 c_borrow_status_10, --未借出
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
	END insert_con_borrow_hd;


	PROCEDURE insert_con_borrow_ln(p_hd_id       NUMBER,
																 p_contract_id NUMBER,
																 p_user_id     NUMBER) IS
	BEGIN
		INSERT INTO cux_con_borrow_ln
			(ln_id,
			 hd_id,
			 contract_id,
			 borrow_status,
			 return_date,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(cux_con_borrow_ln_s.nextval,
			 p_hd_id,
			 p_contract_id,
			 c_borrow_status_10, --未借出
			 NULL,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
	
		UPDATE con_contract cc
			 SET cc.borrow_status    = c_borrow_status_10, --未借出
					 cc.last_updated_by  = p_user_id,
					 cc.last_update_date = SYSDATE
		 WHERE cc.contract_id = p_contract_id;
	END insert_con_borrow_ln;

	PROCEDURE delete_con_borrow_new(p_hd_id   NUMBER,
																	p_user_id NUMBER) IS
	BEGIN
		--清除该借阅合同列表在其他未借出借阅记录中数据
		FOR c_record IN (SELECT *
											 FROM cux_con_borrow_hd ccbh
											WHERE ccbh.borrow_status = c_borrow_status_10 --未借出
												AND ccbh.hd_id <> p_hd_id
												AND EXISTS (SELECT 1
															 FROM cux_con_borrow_ln ccbl,
																		cux_con_borrow_ln ccbl1
															WHERE ccbl.hd_id = ccbh.hd_id
																AND ccbl1.contract_id = ccbl.contract_id
																AND ccbl1.hd_id = p_hd_id)) LOOP
			DELETE FROM cux_con_borrow_content_dl d WHERE d.hd_id = c_record.hd_id;
			DELETE FROM cux_con_borrow_content_type t WHERE t.hd_id = c_record.hd_id;
			DELETE FROM cux_con_borrow_content t
			 WHERE EXISTS (SELECT 1
								FROM cux_con_borrow_ln l
							 WHERE l.ln_id = t.ln_id
								 AND l.hd_id = c_record.hd_id);
			DELETE FROM cux_con_borrow_ln ccbl WHERE ccbl.hd_id = c_record.hd_id;
			DELETE FROM cux_con_borrow_hd ccbh WHERE ccbh.hd_id = c_record.hd_id;
		END LOOP;
	END delete_con_borrow_new;

	PROCEDURE update_con_borrow_hd(p_hd_id            NUMBER,
																 p_borrowers_id     NUMBER,
																 p_borrow_date_from DATE,
																 p_borrow_date_to   DATE,
																 p_borrow_status    VARCHAR2,
																 p_user_id          NUMBER) IS
	BEGIN
		UPDATE cux_con_borrow_hd ccbh
			 SET ccbh.borrowers_id     = p_borrowers_id,
					 ccbh.borrow_date_from = p_borrow_date_from,
					 ccbh.borrow_date_to   = p_borrow_date_to,
					 ccbh.borrow_status    = p_borrow_status,
					 ccbh.last_updated_by  = p_user_id,
					 ccbh.last_update_date = SYSDATE
		 WHERE ccbh.hd_id = p_hd_id;
	END update_con_borrow_hd;

	PROCEDURE delete_con_borrow_ln(p_ln_id   NUMBER,
																 p_user_id NUMBER) IS
		v_hd_id NUMBER;
		v_count NUMBER;
	BEGIN
		DELETE FROM cux_con_borrow_content_dl ccbcd WHERE ccbcd.ln_id = p_ln_id;
		DELETE FROM cux_con_borrow_content ccbc WHERE ccbc.ln_id = p_ln_id;
		DELETE FROM cux_con_borrow_ln ccbl WHERE ccbl.ln_id = p_ln_id;
	
		/*SELECT ccbl.hd_id INTO v_hd_id FROM cux_con_borrow_ln ccbl WHERE ccbl.ln_id = p_ln_id;
    
    SELECT COUNT(1) INTO v_count FROM cux_con_borrow_ln ccbl WHERE ccbl.hd_id = v_hd_id;
    IF v_count = 0 THEN
      DELETE FROM cux_con_borrow_hd ccbh WHERE ccbh.hd_id = v_hd_id;
    END IF;*/
	END delete_con_borrow_ln;

	PROCEDURE confirm_con_borrow(p_hd_id   NUMBER,
															 p_user_id NUMBER) IS
		r_con_borrow_hd cux_con_borrow_hd%ROWTYPE;
		v_count         NUMBER;
		v_error_msg     VARCHAR2(4000);
		e_data_error EXCEPTION;
	BEGIN
		SELECT * INTO r_con_borrow_hd FROM cux_con_borrow_hd ccbh WHERE ccbh.hd_id = p_hd_id;
	
		IF r_con_borrow_hd.borrow_date_from IS NULL OR
			 r_con_borrow_hd.borrow_date_to IS NULL THEN
			v_error_msg := '请维护好借阅时间从和借阅时间到并保存！';
			RAISE e_data_error;
		END IF;
	
		SELECT COUNT(1) INTO v_count FROM cux_con_borrow_content_type t WHERE t.hd_id = p_hd_id;
	
		IF v_count = 0 THEN
			v_error_msg := '请选择借阅资料！';
			RAISE e_data_error;
		END IF;
	
		SELECT COUNT(1)
			INTO v_count
			FROM fnd_atm_attachment_multi m
		 WHERE m.table_name = 'CUX_CON_BORROW_HD'
			 AND m.table_pk_value = p_hd_id;
	
		IF v_count = 0 THEN
			v_error_msg := '请上传借阅单！';
			RAISE e_data_error;
		END IF;
	
		UPDATE cux_con_borrow_hd ccbh
			 SET ccbh.borrow_status    = c_borrow_status_30, --已借出
					 ccbh.last_updated_by  = p_user_id,
					 ccbh.last_update_date = SYSDATE
		 WHERE ccbh.hd_id = p_hd_id;
	
		UPDATE cux_con_borrow_ln ccbl
			 SET ccbl.borrow_status    = c_borrow_status_30, --已借出
					 ccbl.last_updated_by  = p_user_id,
					 ccbl.last_update_date = SYSDATE
		 WHERE ccbl.hd_id = p_hd_id;
	
		UPDATE con_contract cc
			 SET cc.borrow_status    = c_borrow_status_30, --已借出
					 cc.last_updated_by  = p_user_id,
					 cc.last_update_date = SYSDATE
		 WHERE EXISTS (SELECT 1
							FROM cux_con_borrow_ln ccbl
						 WHERE ccbl.contract_id = cc.contract_id
							 AND ccbl.hd_id = p_hd_id);
	EXCEPTION
		WHEN e_data_error THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_msg,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'cux_con_borrow_pkg',
																										 p_procedure_function_name => 'confirm_con_borrow');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		
		WHEN OTHERS THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
																																									SQLERRM,
																										 p_created_by              => p_user_id,
																										 p_package_name            => 'cux_con_borrow_pkg',
																										 p_procedure_function_name => 'confirm_con_borrow');
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END confirm_con_borrow;

	PROCEDURE return_con_borrow_sign(p_contract_id NUMBER,
																	 p_user_id     NUMBER) IS
		v_hd_id NUMBER;
		v_ln_id NUMBER;
		v_count NUMBER;
	BEGIN
		SELECT ccbl.hd_id,
					 ccbl.ln_id
			INTO v_hd_id,
					 v_ln_id
			FROM cux_con_borrow_ln ccbl
		 WHERE ccbl.borrow_status = c_borrow_status_30 --已借出
			 AND ccbl.contract_id = p_contract_id;
	
		UPDATE cux_con_borrow_ln ccbl
			 SET ccbl.borrow_status    = c_borrow_status_40, --已归还
					 ccbl.return_date      = SYSDATE,
					 ccbl.last_updated_by  = p_user_id,
					 ccbl.last_update_date = SYSDATE
		 WHERE ccbl.ln_id = v_ln_id;
	
		SELECT COUNT(1)
			INTO v_count
			FROM cux_con_borrow_ln ccbl
		 WHERE ccbl.hd_id = v_hd_id
			 AND ccbl.borrow_status <> c_borrow_status_40; --已归还   
	
		IF v_count = 0 THEN
			UPDATE cux_con_borrow_hd ccbh
				 SET ccbh.borrow_status    = c_borrow_status_40, --已归还
						 ccbh.last_updated_by  = p_user_id,
						 ccbh.last_update_date = SYSDATE
			 WHERE ccbh.hd_id = v_hd_id;
		END IF;
	
		UPDATE con_contract cc
			 SET cc.borrow_status    = c_borrow_status_40, --已归还
					 cc.last_updated_by  = p_user_id,
					 cc.last_update_date = SYSDATE
		 WHERE cc.contract_id = p_contract_id;
	END return_con_borrow_sign;

	PROCEDURE return_con_borrow(p_hd_id   NUMBER,
															p_user_id NUMBER) IS
	BEGIN
		UPDATE cux_con_borrow_hd ccbh
			 SET ccbh.borrow_status    = c_borrow_status_40, --已归还
					 ccbh.last_updated_by  = p_user_id,
					 ccbh.last_update_date = SYSDATE
		 WHERE ccbh.hd_id = p_hd_id;
	
		UPDATE cux_con_borrow_ln ccbl
			 SET ccbl.borrow_status    = c_borrow_status_40, --已归还
					 ccbl.return_date      = SYSDATE,
					 ccbl.last_updated_by  = p_user_id,
					 ccbl.last_update_date = SYSDATE
		 WHERE ccbl.hd_id = p_hd_id;
	
		UPDATE con_contract cc
			 SET cc.borrow_status    = c_borrow_status_40, --已归还
					 cc.last_updated_by  = p_user_id,
					 cc.last_update_date = SYSDATE
		 WHERE EXISTS (SELECT 1
							FROM cux_con_borrow_ln ccbl
						 WHERE ccbl.contract_id = cc.contract_id
							 AND ccbl.hd_id = p_hd_id);
	END return_con_borrow;

	PROCEDURE delete_con_borrow_content(p_hd_id   NUMBER,
																			p_user_id NUMBER) IS
	BEGIN
		DELETE FROM cux_con_borrow_content_type t WHERE t.hd_id = p_hd_id;
	
		DELETE FROM cux_con_borrow_content t
		 WHERE EXISTS (SELECT 1
							FROM cux_con_borrow_ln l
						 WHERE l.ln_id = t.ln_id
							 AND l.hd_id = p_hd_id);
	END delete_con_borrow_content;

	PROCEDURE insert_con_borrow_content_type(p_hd_id       NUMBER,
																					 p_description VARCHAR2,
																					 p_checked     VARCHAR2,
																					 p_user_id     NUMBER) IS
	BEGIN
		INSERT INTO cux_con_borrow_content_type
			(type_id,
			 hd_id,
			 description,
			 checked,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(cux_con_borrow_content_type_s.nextval,
			 p_hd_id,
			 p_description,
			 p_checked,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
	END insert_con_borrow_content_type;

	PROCEDURE create_con_borrow_content(p_hd_id   NUMBER,
																			p_user_id NUMBER) IS
	BEGIN
		FOR c_content_type IN (SELECT t.description
														 FROM cux_con_borrow_content_type t
														WHERE t.checked = 'Y'
															AND t.hd_id = p_hd_id) LOOP
			FOR c_attachment IN (SELECT l.ln_id,
																	a.con_atm_id
														 FROM cux_con_borrow_ln       l,
																	con_contract_attachment a
														WHERE a.contract_id = l.contract_id
															AND a.description = c_content_type.description
															AND l.hd_id = p_hd_id) LOOP
				INSERT INTO cux_con_borrow_content
					(content_id,
					 ln_id,
					 con_atm_id,
					 creation_date,
					 created_by,
					 last_update_date,
					 last_updated_by)
				VALUES
					(cux_con_borrow_content_s.nextval,
					 c_attachment.ln_id,
					 c_attachment.con_atm_id,
					 SYSDATE,
					 p_user_id,
					 SYSDATE,
					 p_user_id);
			END LOOP;
		END LOOP;
	END create_con_borrow_content;

	PROCEDURE insert_con_borrow_content_dl(p_hd_id   NUMBER,
																				 p_user_id NUMBER) IS
	BEGIN
		DELETE FROM cux_con_borrow_content_dl d WHERE d.hd_id = p_hd_id;
	
		FOR c_record IN (SELECT ccbl.hd_id,
														ccbl.ln_id,
														ccbc.content_id,
														cca.table_name,
														cca.check_id table_pk_value
											 FROM cux_con_borrow_ln       ccbl,
														cux_con_borrow_content  ccbc,
														con_contract_attachment cca
											WHERE ccbc.ln_id = ccbl.ln_id
												AND cca.con_atm_id = ccbc.con_atm_id
												AND ccbl.hd_id = p_hd_id) LOOP
			FOR c_attachment IN (SELECT faam.*
														 FROM fnd_atm_attachment_multi faam
														WHERE faam.table_name = c_record.table_name
															AND faam.table_pk_value = c_record.table_pk_value) LOOP
				INSERT INTO cux_con_borrow_content_dl
					(content_dl_id,
					 hd_id,
					 ln_id,
					 content_id,
					 record_id,
					 creation_date,
					 created_by,
					 last_update_date,
					 last_updated_by)
				VALUES
					(cux_con_borrow_content_dl_s.nextval,
					 c_record.hd_id,
					 c_record.ln_id,
					 c_record.content_id,
					 c_attachment.record_id,
					 SYSDATE,
					 p_user_id,
					 SYSDATE,
					 p_user_id);
			END LOOP;
		END LOOP;
	END insert_con_borrow_content_dl;

END cux_con_borrow_pkg;
/
