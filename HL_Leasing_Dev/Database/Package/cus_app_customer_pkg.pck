CREATE OR REPLACE PACKAGE cus_app_customer_pkg IS

	-- Author  : gaoyang
	-- Created : 2016-6-29 9:47:00
	-- Purpose : 

	PROCEDURE app_calc(p_project_id            IN OUT NUMBER,
										 p_bp_class              VARCHAR2,
										 p_business_type         VARCHAR2,
										 p_division              VARCHAR2,
										 p_car_type              VARCHAR2,
										 p_brand_id              NUMBER,
										 p_series_id             NUMBER,
										 p_model_id              NUMBER,
										 p_guide_price           NUMBER,
										 p_objective_buy_car     VARCHAR2,
										 p_invoice_price         NUMBER,
										 p_item_frame_number     VARCHAR2,
										 p_used_evaluation_amout NUMBER,
										 p_product_plan_id       NUMBER,
										 p_down_payment_ratio    NUMBER,
										 p_deposit_ratio         NUMBER,
										 p_balloon_ratio         NUMBER,
										 p_times                 IN OUT NUMBER,
										 p_insurance_price       NUMBER,
										 p_travel_tax            NUMBER,
										 p_purchase_tax          NUMBER,
										 p_gps_amount            NUMBER,
										 p_other_amount          NUMBER,
										 p_charge_amount         NUMBER,
										 p_postage               NUMBER,
										 p_user_id               NUMBER,
										 p_pmt                   OUT NUMBER,
										 p_down_payment          OUT NUMBER,
										 p_finance_amount        OUT NUMBER,
										 p_deposit               OUT NUMBER,
										 p_lease_charge          OUT NUMBER,
										 p_balloon               OUT NUMBER,
										 p_first_payment         OUT NUMBER);

	PROCEDURE app_upload_image(p_record_id      OUT fnd_atm_attachment_multi.record_id%TYPE,
														 p_table_name     fnd_atm_attachment_multi.table_name%TYPE,
														 p_table_pk_value fnd_atm_attachment_multi.table_pk_value%TYPE,
														 p_file_name      fnd_atm_attachment.file_name%TYPE,
														 p_file_path      fnd_atm_attachment.file_path%TYPE,
														 p_file_size      fnd_atm_attachment.file_size%TYPE,
														 p_user_id        fnd_atm_attachment_multi.created_by%TYPE,
														 p_attachment_id  OUT fnd_atm_attachment_multi.attachment_id%TYPE);

	PROCEDURE app_prj_bp_save(p_prj_bp_id                   IN OUT NUMBER,
														p_project_id                  NUMBER,
														p_id_card_no                  VARCHAR2,
														p_bp_name                     VARCHAR2,
														p_cell_phone                  VARCHAR2,
														p_academic_background         VARCHAR2,
														p_marital_status              VARCHAR2,
														p_annual_income               NUMBER,
														p_source_of_income            VARCHAR2,
														p_first_time_buyer_flag       VARCHAR,
														p_main_driver_of_car          VARCHAR2,
														p_living_address              VARCHAR2,
														p_living_situation            VARCHAR2,
														p_years_of_living_house       NUMBER,
														p_ownship_of_house            VARCHAR2,
														p_house_loans_flag            VARCHAR2,
														p_address_on_resident_booklit VARCHAR2,
														p_industry                    VARCHAR2,
														p_work_unit                   VARCHAR2,
														p_work_unit_address           VARCHAR2,
														p_work_unit_phone             VARCHAR2,
														p_industry_work_experience    VARCHAR2,
														p_position                    VARCHAR2,
														p_release_form                VARCHAR2,
														p_id_no_sp                    VARCHAR2,
														p_bp_name_sp                  VARCHAR2,
														p_cell_phone_sp               VARCHAR2,
														p_academic_background_sp      VARCHAR2,
														p_source_of_income_db         VARCHAR2,
														p_relationship_sp             VARCHAR2,
														p_description_others          VARCHAR2,
														p_living_address_db           VARCHAR2,
														p_resident_addres             VARCHAR2,
														p_industry_sp                 VARCHAR2,
														p_work_unit_name_sp           VARCHAR2,
														p_work_unit_address_sp        VARCHAR2,
														p_industry_work_exper         VARCHAR2,
														p_position_sp                 VARCHAR2,
														p_gender                      VARCHAR2,
														p_date_of_birth               VARCHAR2,
														p_age                         VARCHAR2,
														p_gender_sp                   VARCHAR2,
														p_date_of_birth_sp            VARCHAR2,
														p_old_sp                      VARCHAR2,
														p_add_province                VARCHAR2,
														p_add_city                    VARCHAR2,
														p_liv_province                VARCHAR2,
														p_liv_city                    VARCHAR2,
														p_work_province               VARCHAR2,
														p_work_city                   VARCHAR2,
														p_resident_add_province       VARCHAR2,
														p_resident_add_city           VARCHAR2,
														p_living_add_province         VARCHAR2,
														p_living_add_city             VARCHAR2,
														p_work_province_sp            VARCHAR2,
														p_work_city_sp                VARCHAR2,
														p_user_id                     NUMBER);

	PROCEDURE app_bp_contact_save(p_prj_contact_info_id IN OUT NUMBER,
																p_prj_bp_id           NUMBER,
																p_contact_person      VARCHAR2,
																p_cell_phone          VARCHAR2,
																p_comments            VARCHAR2,
																p_contact_person_1    VARCHAR2,
																p_cell_phone_1        VARCHAR2,
																p_comments_1          VARCHAR2,
																p_user_id             NUMBER);

	PROCEDURE app_con_for_payment(p_contract_id NUMBER,
																p_user_id     NUMBER);

	PROCEDURE check_app_login(p_access_token  VARCHAR2,
														p_user_id       NUMBER,
														p_error_message OUT VARCHAR2);

	PROCEDURE delete_cdd_atm(p_attachment_id NUMBER);

	PROCEDURE app_paycard_change(p_contract_id          NUMBER,
															 p_direct_debit_bank_id NUMBER,
															 p_withhold_way         VARCHAR2,
															 p_ebank_province       NUMBER,
															 p_ebank_city           NUMBER,
															 p_dd_bank_branch_name  VARCHAR2,
															 p_dd_bank_account_num  VARCHAR2,
															 p_dd_remark            VARCHAR2,
															 p_user_id              NUMBER,
															 p_open_id              VARCHAR2);

	PROCEDURE app_prj_bp_change(p_contract_id          NUMBER,
															p_cell_phone           NUMBER,
															p_invoice_send_address VARCHAR2,
															p_user_id              NUMBER,
															p_open_id              VARCHAR2);
	PROCEDURE con_insurance_save_sumbit(p_contract_id        NUMBER,
																			p_temp_pk            NUMBER,
																			p_cell_phone         NUMBER,
																			p_material_option    VARCHAR2,
																			p_mailmax            VARCHAR2,
																			p_mailling_address   VARCHAR2,
																			p_record_date        DATE,
																			p_insurance_number   VARCHAR2,
																			p_insurance_company  VARCHAR2,
																			p_record_description VARCHAR2,
																			p_user_id            NUMBER,
																			p_open_id            VARCHAR2);
	PROCEDURE check_insurance(p_contract_id                  NUMBER,
														p_ast_car_insurance_records_id IN OUT NUMBER);

	PROCEDURE wx_upload_attachment(p_record_id      OUT fnd_atm_attachment_multi.record_id%TYPE,
																 p_table_name     fnd_atm_attachment_multi.table_name%TYPE,
																 p_table_pk_value fnd_atm_attachment_multi.table_pk_value%TYPE,
																 p_file_name      fnd_atm_attachment.file_name%TYPE,
																 p_file_path      fnd_atm_attachment.file_path%TYPE,
																 p_file_size      fnd_atm_attachment.file_size%TYPE,
																 p_user_id        fnd_atm_attachment_multi.created_by%TYPE);
	PROCEDURE get_verifiction_code(p_id_type          VARCHAR2,
																 p_id_card_no       VARCHAR2,
																 p_user_id          NUMBER,
																 p_verifiction_code IN OUT VARCHAR2,
																 p_cell_phone       IN OUT NUMBER);
	PROCEDURE contract_status(p_contract_id NUMBER,
														p_incept_flag IN OUT VARCHAR2);

	PROCEDURE wx_send_instance_end(p_instance_id    NUMBER,
																 x_return_message OUT VARCHAR2,
																 x_access_token   OUT VARCHAR2);

	FUNCTION get_file_path(p_table_name     VARCHAR2,
												 p_table_value_pk NUMBER) RETURN VARCHAR2;
	FUNCTION get_file_attaid(p_table_name     VARCHAR2,
													 p_table_value_pk NUMBER) RETURN NUMBER;
END cus_app_customer_pkg;
/
CREATE OR REPLACE PACKAGE BODY cus_app_customer_pkg IS
	--************************************************************
	--MD5密码转换
	-- parameter :
	-- p_password  原密码
	-- return    :
	-- md5后的密码
	--************************************************************

	FUNCTION md5(p_password IN VARCHAR2) RETURN VARCHAR2 IS
		retval VARCHAR2(32);
	BEGIN
		retval := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => p_password));
		RETURN retval;
	END md5;
	PROCEDURE get_price_list(p_product_plan_id  NUMBER,
													 p_product_plan_rec OUT hls_product_plan_definition%ROWTYPE) IS
	
	BEGIN
		SELECT *
			INTO p_product_plan_rec
			FROM hls_product_plan_definition t
		 WHERE t.product_plan_id = p_product_plan_id;
	END;

	PROCEDURE insert_fnd_atm(p_attachment_id    OUT fnd_atm_attachment.attachment_id%TYPE,
													 p_source_type_code fnd_atm_attachment.source_type_code%TYPE,
													 p_source_pk_value  fnd_atm_attachment.source_pk_value%TYPE,
													 p_content          fnd_atm_attachment.content%TYPE DEFAULT NULL,
													 p_file_type_code   fnd_atm_attachment.file_type_code%TYPE,
													 p_mime_type        fnd_atm_attachment.mime_type%TYPE,
													 p_file_name        fnd_atm_attachment.file_name%TYPE,
													 p_file_size        fnd_atm_attachment.file_size%TYPE,
													 p_file_path        fnd_atm_attachment.file_path%TYPE,
													 p_user_id          fnd_atm_attachment.created_by%TYPE) IS
	BEGIN
	
		SELECT fnd_atm_attachment_s.nextval INTO p_attachment_id FROM dual;
	
		INSERT INTO fnd_atm_attachment
			(attachment_id,
			 source_type_code,
			 source_pk_value,
			 content,
			 file_type_code,
			 mime_type,
			 file_name,
			 file_size,
			 file_path,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(p_attachment_id,
			 p_source_type_code,
			 p_source_pk_value,
			 p_content,
			 p_file_type_code,
			 p_mime_type,
			 p_file_name,
			 p_file_size,
			 p_file_path,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
	END;

	PROCEDURE app_calc(p_project_id            IN OUT NUMBER,
										 p_bp_class              VARCHAR2,
										 p_business_type         VARCHAR2,
										 p_division              VARCHAR2,
										 p_car_type              VARCHAR2,
										 p_brand_id              NUMBER,
										 p_series_id             NUMBER,
										 p_model_id              NUMBER,
										 p_guide_price           NUMBER,
										 p_objective_buy_car     VARCHAR2,
										 p_invoice_price         NUMBER,
										 p_item_frame_number     VARCHAR2,
										 p_used_evaluation_amout NUMBER,
										 p_product_plan_id       NUMBER,
										 p_down_payment_ratio    NUMBER,
										 p_deposit_ratio         NUMBER,
										 p_balloon_ratio         NUMBER,
										 p_times                 IN OUT NUMBER,
										 p_insurance_price       NUMBER,
										 p_travel_tax            NUMBER,
										 p_purchase_tax          NUMBER,
										 p_gps_amount            NUMBER,
										 p_other_amount          NUMBER,
										 p_charge_amount         NUMBER,
										 p_postage               NUMBER,
										 p_user_id               NUMBER,
										 p_pmt                   OUT NUMBER,
										 p_down_payment          OUT NUMBER,
										 p_finance_amount        OUT NUMBER,
										 p_deposit               OUT NUMBER,
										 p_lease_charge          OUT NUMBER,
										 p_balloon               OUT NUMBER,
										 p_first_payment         OUT NUMBER) IS
		r_prj_project      prj_project%ROWTYPE;
		r_prj_lease_item   prj_project_lease_item%ROWTYPE;
		r_product_plan_rec hls_product_plan_definition%ROWTYPE;
		r_quotation_rec    prj_quotation%ROWTYPE;
		r_hls_calc_hd      hls_fin_calculator_hd%ROWTYPE;
		v_project_number   VARCHAR2(100);
		v_company_id       NUMBER;
		v_sum_amount       NUMBER;
		v_agent_bp_id      NUMBER;
	BEGIN
	
		get_price_list(p_product_plan_id  => p_product_plan_id,
									 p_product_plan_rec => r_product_plan_rec);
	
		v_sum_amount := nvl(p_invoice_price, 0) + nvl(p_insurance_price, 0) + nvl(p_travel_tax, 0) +
										nvl(p_purchase_tax, 0) + nvl(p_gps_amount, 0) + nvl(p_other_amount, 0) +
										nvl(p_charge_amount, 0) + nvl(p_postage, 0);
	
		BEGIN
			SELECT su.bp_id
				INTO v_agent_bp_id
				FROM sys_user su
			 WHERE su.user_id = p_user_id
				 AND su.bp_category = 'AGENT';
		EXCEPTION
			WHEN no_data_found THEN
				v_agent_bp_id := NULL;
		END;
	
		IF p_project_id IS NOT NULL THEN
			SELECT *
				INTO r_prj_project
				FROM prj_project pp
			 WHERE project_id = p_project_id
				 FOR UPDATE NOWAIT;
		
			UPDATE prj_project pp
				 SET pp.bp_class         = p_bp_class,
						 pp.business_type    = p_business_type,
						 pp.division         = p_division,
						 pp.car_type         = p_car_type,
						 pp.lease_times      = p_times,
						 pp.last_updated_by  = p_user_id,
						 pp.last_update_date = SYSDATE
			 WHERE pp.project_id = p_project_id;
		
			SELECT *
				INTO r_prj_lease_item
				FROM prj_project_lease_item li
			 WHERE li.project_id = r_prj_project.project_id;
		
			r_prj_lease_item.brand_id              := p_brand_id;
			r_prj_lease_item.series_id             := p_series_id;
			r_prj_lease_item.model_id              := p_model_id;
			r_prj_lease_item.guide_price           := p_guide_price;
			r_prj_lease_item.objective_buy_car     := p_objective_buy_car;
			r_prj_lease_item.invoice_price         := p_invoice_price;
			r_prj_lease_item.item_frame_number     := p_item_frame_number;
			r_prj_lease_item.vin_number            := p_item_frame_number;
			r_prj_lease_item.used_evaluation_amout := p_used_evaluation_amout;
			r_prj_lease_item.product_plan_id       := p_product_plan_id;
			r_prj_lease_item.price_list            := r_product_plan_rec.price_list;
			r_prj_lease_item.int_rate_display      := r_product_plan_rec.customer_ratio / 100;
			r_prj_lease_item.down_payment_ratio    := p_down_payment_ratio;
			r_prj_lease_item.down_payment          := round(p_invoice_price * p_down_payment_ratio, 2);
			r_prj_lease_item.deposit_ratio         := p_deposit_ratio;
			r_prj_lease_item.deposit               := round(v_sum_amount * p_deposit_ratio, 2);
		
			r_prj_lease_item.lease_charge_ratio := r_product_plan_rec.lease_charge_ratio / 100;
			r_prj_lease_item.lease_charge       := round(p_invoice_price *
																									 r_product_plan_rec.lease_charge_ratio / 100,
																									 2);
		
			r_prj_lease_item.balloon_ratio    := p_balloon_ratio;
			r_prj_lease_item.balloon          := round(p_invoice_price * p_balloon_ratio, 2);
			r_prj_lease_item.insurance_price  := p_insurance_price;
			r_prj_lease_item.insurance_amount := p_insurance_price;
		
			IF nvl(p_insurance_price, 0) > 0 THEN
				r_prj_lease_item.insurance_flag := 'Y';
			ELSE
				r_prj_lease_item.insurance_flag := 'N';
			END IF;
		
			r_prj_lease_item.lease_times      := p_times;
			r_prj_lease_item.annual_pay_times := 12;
			r_prj_lease_item.travel_tax       := p_travel_tax;
		
			IF nvl(p_travel_tax, 0) = 0 THEN
				r_prj_lease_item.travel_tax_flag := 'N';
			ELSE
				r_prj_lease_item.travel_tax_flag := 'Y';
			END IF;
		
			r_prj_lease_item.purchase_tax := p_purchase_tax;
			IF nvl(p_purchase_tax, 0) > 0 THEN
				r_prj_lease_item.purchase_tax_flag := 'Y';
			ELSE
				r_prj_lease_item.purchase_tax_flag := 'N';
			END IF;
		
			r_prj_lease_item.gps_amount := p_gps_amount;
		
			IF nvl(p_gps_amount, 0) > 0 THEN
				r_prj_lease_item.gps_flag := 'Y';
			ELSE
				r_prj_lease_item.gps_flag := 'N';
			END IF;
		
			r_prj_lease_item.other_amount := p_other_amount;
			IF nvl(p_other_amount, 0) > 0 THEN
				r_prj_lease_item.other_flag := 'Y';
			ELSE
				r_prj_lease_item.other_flag := 'N';
			END IF;
		
			r_prj_lease_item.charge_amount := p_charge_amount;
			IF nvl(p_charge_amount, 0) > 0 THEN
				r_prj_lease_item.charge_flag := 'Y';
			ELSE
				r_prj_lease_item.charge_flag := 'N';
			END IF;
		
			r_prj_lease_item.postage := p_postage;
			IF nvl(p_postage, 0) > 0 THEN
				r_prj_lease_item.postage_flag := 'Y';
			ELSE
				r_prj_lease_item.postage_flag := 'N';
			END IF;
		
			r_prj_lease_item.last_updated_by  := p_user_id;
			r_prj_lease_item.last_update_date := SYSDATE;
		
			UPDATE prj_project_lease_item t
				 SET ROW = r_prj_lease_item
			 WHERE t.project_lease_item_id = r_prj_lease_item.project_lease_item_id;
		ELSE
			p_project_id                     := prj_project_s.nextval;
			r_prj_project.project_id         := p_project_id;
			r_prj_project.document_category  := 'PROJECT';
			r_prj_project.document_type      := 'CARLS';
			r_prj_project.lease_channel      := '01';
			r_prj_project.project_status     := 'NEW';
			r_prj_project.lease_organization := '1000';
			SELECT fc.company_id
				INTO v_company_id
				FROM fnd_companies fc
			 WHERE fc.company_code = '1000';
			r_prj_project.company_id := v_company_id;
			hls_document_save_pkg.get_doc_field(p_document_category => r_prj_project.document_category,
																					p_document_type     => r_prj_project.document_type,
																					p_company_id        => r_prj_project.company_id,
																					p_function_code     => NULL,
																					p_function_usage    => NULL,
																					p_user_id           => p_user_id,
																					p_document_number   => v_project_number);
			r_prj_project.project_number   := v_project_number;
			r_prj_project.bp_class         := p_bp_class;
			r_prj_project.business_type    := p_business_type;
			r_prj_project.division         := p_division;
			r_prj_project.car_type         := p_car_type;
			r_prj_project.lease_times      := p_times;
			r_prj_project.owner_user_id    := p_user_id;
			r_prj_project.created_by       := p_user_id;
			r_prj_project.creation_date    := SYSDATE;
			r_prj_project.last_updated_by  := p_user_id;
			r_prj_project.last_update_date := SYSDATE;
			r_prj_project.invoice_agent_id := v_agent_bp_id;
		
			INSERT INTO prj_project VALUES r_prj_project;
		
			r_prj_lease_item.project_lease_item_id := prj_project_lease_item_s.nextval;
			r_prj_lease_item.project_id            := r_prj_project.project_id;
			r_prj_lease_item.brand_id              := p_brand_id;
			r_prj_lease_item.series_id             := p_series_id;
			r_prj_lease_item.model_id              := p_model_id;
			r_prj_lease_item.guide_price           := p_guide_price;
			r_prj_lease_item.objective_buy_car     := p_objective_buy_car;
			r_prj_lease_item.invoice_price         := p_invoice_price;
			r_prj_lease_item.item_frame_number     := p_item_frame_number;
			r_prj_lease_item.vin_number            := p_item_frame_number;
			r_prj_lease_item.used_evaluation_amout := p_used_evaluation_amout;
			r_prj_lease_item.product_plan_id       := p_product_plan_id;
			r_prj_lease_item.price_list            := r_product_plan_rec.price_list;
			r_prj_lease_item.int_rate_display      := r_product_plan_rec.customer_ratio / 100;
			r_prj_lease_item.down_payment_ratio    := p_down_payment_ratio;
			r_prj_lease_item.down_payment          := round(p_invoice_price * p_down_payment_ratio, 2);
			r_prj_lease_item.deposit_ratio         := p_deposit_ratio;
			r_prj_lease_item.deposit               := round(v_sum_amount * p_deposit_ratio, 2);
			r_prj_lease_item.lease_charge_ratio    := r_product_plan_rec.lease_charge_ratio / 100;
			r_prj_lease_item.lease_charge          := round(p_invoice_price *
																											r_product_plan_rec.lease_charge_ratio / 100,
																											2);
			r_prj_lease_item.balloon_ratio         := p_balloon_ratio;
			r_prj_lease_item.balloon               := round(p_invoice_price * p_balloon_ratio, 2);
			r_prj_lease_item.insurance_price       := p_insurance_price;
			r_prj_lease_item.insurance_amount      := p_insurance_price;
		
			IF nvl(p_insurance_price, 0) > 0 THEN
				r_prj_lease_item.insurance_flag := 'Y';
			ELSE
				r_prj_lease_item.insurance_flag := 'N';
			END IF;
		
			r_prj_lease_item.lease_times      := p_times;
			r_prj_lease_item.annual_pay_times := 12;
		
			r_prj_lease_item.travel_tax := p_travel_tax;
		
			IF nvl(p_travel_tax, 0) = 0 THEN
				r_prj_lease_item.travel_tax_flag := 'N';
			ELSE
				r_prj_lease_item.travel_tax_flag := 'Y';
			END IF;
		
			r_prj_lease_item.purchase_tax := p_purchase_tax;
			IF nvl(p_purchase_tax, 0) > 0 THEN
				r_prj_lease_item.purchase_tax_flag := 'Y';
			ELSE
				r_prj_lease_item.purchase_tax_flag := 'N';
			END IF;
		
			r_prj_lease_item.gps_amount := p_gps_amount;
		
			IF nvl(p_gps_amount, 0) > 0 THEN
				r_prj_lease_item.gps_flag := 'Y';
			ELSE
				r_prj_lease_item.gps_flag := 'N';
			END IF;
		
			r_prj_lease_item.other_amount := p_other_amount;
			IF nvl(p_other_amount, 0) > 0 THEN
				r_prj_lease_item.other_flag := 'Y';
			ELSE
				r_prj_lease_item.other_flag := 'N';
			END IF;
		
			r_prj_lease_item.charge_amount := p_charge_amount;
			IF nvl(p_charge_amount, 0) > 0 THEN
				r_prj_lease_item.charge_flag := 'Y';
			ELSE
				r_prj_lease_item.charge_flag := 'N';
			END IF;
		
			r_prj_lease_item.postage := p_postage;
			IF nvl(p_postage, 0) > 0 THEN
				r_prj_lease_item.postage_flag := 'Y';
			ELSE
				r_prj_lease_item.postage_flag := 'N';
			END IF;
		
			r_prj_lease_item.created_by       := p_user_id;
			r_prj_lease_item.creation_date    := SYSDATE;
			r_prj_lease_item.last_updated_by  := p_user_id;
			r_prj_lease_item.last_update_date := SYSDATE;
		
			INSERT INTO prj_project_lease_item VALUES r_prj_lease_item;
		
		END IF;
	
		yonda_prj_project_pkg.calc_quotation(p_project_lease_item_id => r_prj_lease_item.project_lease_item_id,
																				 p_price_list            => r_prj_lease_item.price_list,
																				 p_product_plan_id       => r_prj_lease_item.product_plan_id,
																				 p_int_rate_display      => r_prj_lease_item.int_rate_display,
																				 p_down_payment_ratio    => r_prj_lease_item.down_payment_ratio,
																				 p_balloon_ratio         => r_prj_lease_item.balloon_ratio,
																				 p_deposit_ratio         => r_prj_lease_item.deposit_ratio,
																				 p_lease_times           => r_prj_lease_item.lease_times,
																				 p_lease_charge_ratio    => r_prj_lease_item.lease_charge_ratio,
																				 p_user_id               => p_user_id);
	
		SELECT *
			INTO r_quotation_rec
			FROM prj_quotation a
		 WHERE a.document_category = 'PROJECT'
			 AND a.document_id = r_prj_project.project_id;
	
		SELECT *
			INTO r_hls_calc_hd
			FROM hls_fin_calculator_hd h
		 WHERE h.calc_session_id = r_quotation_rec.calc_session_id;
	
		p_pmt            := r_hls_calc_hd.pmt;
		p_down_payment   := r_hls_calc_hd.down_payment;
		p_finance_amount := r_hls_calc_hd.finance_amount;
		p_deposit        := r_hls_calc_hd.deposit;
		p_lease_charge   := r_hls_calc_hd.lease_charge;
		p_balloon        := r_hls_calc_hd.balloon;
		p_first_payment  := nvl(r_hls_calc_hd.down_payment, 0) + nvl(r_hls_calc_hd.deposit, 0) +
												nvl(r_hls_calc_hd.lease_charge, 0);
	
	END;

	--由于APP附件名随机生成特别不适合阅读，so 根据类型重置名称,如有必要，后期可将该名字返回前台
	PROCEDURE reset_file_name(p_table_name     fnd_atm_attachment_multi.table_name%TYPE,
														p_table_pk_value fnd_atm_attachment_multi.table_pk_value%TYPE,
														p_file_name      OUT fnd_atm_attachment.file_name%TYPE,
														p_user_id        NUMBER) IS
		v_count NUMBER;
	BEGIN
		IF p_table_name = 'ID_CARD_NO_FRONT' THEN
			--项目身份证反面  身份证正面-姓名
			SELECT decode(ppb.bp_class,
										'NP',
										'身份证正面-' || ppb.bp_name,
										'ORG',
										'身份证正面-' || ppb.corporate_code)
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'ID_CARD_NO_NEGATIVE' THEN
			--项目身份证反面  身份证反面-姓名
			SELECT decode(ppb.bp_class,
										'NP',
										'身份证反面-' || ppb.bp_name,
										'ORG',
										'身份证反面-' || ppb.corporate_code)
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'PASSPORT' THEN
			--项目护照  护照-姓名
			SELECT decode(ppb.bp_class,
										'NP',
										'护照-' || ppb.bp_name,
										'ORG',
										'护照-' || ppb.corporate_code)
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'BUSINESS_CARD' THEN
			--项目名片  名片-姓名
			SELECT decode(ppb.bp_class,
										'NP',
										'名片-' || ppb.bp_name,
										'ORG',
										'名片-' || ppb.corporate_code)
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'BUSINESS_LICENSE_NUM' THEN
			--项目营业执照  营业执照-公司名称
			SELECT '营业执照-' || ppb.bp_name
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'BUSINESS_CONTACT_CARD' THEN
			--项目业务联系人  名片-姓名
			SELECT '名片-' || ppb.contact_name
				INTO p_file_name
				FROM prj_project_bp ppb
			 WHERE ppb.prj_bp_id = p_table_pk_value;
		ELSIF p_table_name = 'DRIVING_LICENSE' THEN
			--项目行驶证  行驶证-车辆识别代码
			SELECT '行驶证-' || ppli.item_frame_number
				INTO p_file_name
				FROM prj_project_lease_item ppli
			 WHERE ppli.project_lease_item_id = p_table_pk_value;
		ELSIF p_table_name = 'CON_CONTRACT_PAYMENT_ADVICE' THEN
			--合同付款通知书  付款通知书
			SELECT '付款通知书-保费金额' || ccpa.insurance_amount || '元'
				INTO p_file_name
				FROM con_contract_payment_advice ccpa
			 WHERE ccpa.payment_advice_id = p_table_pk_value;
		ELSIF p_table_name = 'PRJ_CDD_ITEM_CHECK' THEN
			--合同签约附件列表  付款通知书
			SELECT COUNT(1) + 1
				INTO v_count
				FROM fnd_atm_attachment_multi faam
			 WHERE faam.table_name = p_table_name
				 AND faam.table_pk_value = p_table_pk_value;
		
			SELECT pci.description || '-' || v_count
				INTO p_file_name
				FROM prj_cdd_item_check pcic,
						 prj_cdd_item       pci
			 WHERE pci.cdd_item_id = pcic.cdd_item_id
				 AND pcic.check_id = p_table_pk_value;
		ELSIF p_table_name = 'INSURANCE_PHOTO' THEN
			--合同保单上传  保单
			SELECT '保单-' || ccli.item_frame_number
				INTO p_file_name
				FROM con_contract_lease_item ccli
			 WHERE ccli.contract_lease_item_id = p_table_pk_value;
		ELSIF p_table_name = 'INVOICE_PHOTO' THEN
			--合同保单上传  发票
			SELECT '发票-' || ccli.item_frame_number
				INTO p_file_name
				FROM con_contract_lease_item ccli
			 WHERE ccli.contract_lease_item_id = p_table_pk_value;
		ELSIF p_table_name = 'CONTRACT_PAYMENT_HANDLE' THEN
			--合同首付款待处理  付款凭据
			SELECT '合同' || cc.contract_number || '付款凭据'
				INTO p_file_name
				FROM con_contract cc
			 WHERE cc.contract_id = p_table_pk_value;
		END IF;
	
		IF p_file_name IS NOT NULL THEN
			p_file_name := p_file_name || '.jpg';
		END IF;
	END reset_file_name;

	PROCEDURE app_upload_image(p_record_id      OUT fnd_atm_attachment_multi.record_id%TYPE,
														 p_table_name     fnd_atm_attachment_multi.table_name%TYPE,
														 p_table_pk_value fnd_atm_attachment_multi.table_pk_value%TYPE,
														 p_file_name      fnd_atm_attachment.file_name%TYPE,
														 p_file_path      fnd_atm_attachment.file_path%TYPE,
														 p_file_size      fnd_atm_attachment.file_size%TYPE,
														 p_user_id        fnd_atm_attachment_multi.created_by%TYPE,
														 p_attachment_id  OUT fnd_atm_attachment_multi.attachment_id%TYPE) IS
		v_record        fnd_atm_attachment_multi%ROWTYPE;
		v_attachment_id fnd_atm_attachment.attachment_id%TYPE;
	
		v_file_name fnd_atm_attachment.file_name%TYPE;
	BEGIN
		--由于APP附件名随机生成特别不适合阅读，so 根据类型重置名称,如有必要，后期可将该名字返回前台
		reset_file_name(p_table_name     => p_table_name,
										p_table_pk_value => p_table_pk_value,
										p_file_name      => v_file_name,
										p_user_id        => p_user_id);
	
		SELECT fnd_atm_attachment_multi_s.nextval INTO p_record_id FROM dual;
		insert_fnd_atm(p_attachment_id    => v_attachment_id,
									 p_source_type_code => 'fnd_atm_attachment_multi',
									 p_source_pk_value  => p_record_id,
									 p_file_type_code   => 'jpg',
									 p_mime_type        => 'image/jpeg',
									 p_file_name        => /*p_file_name*/ nvl(v_file_name, p_file_name),
									 p_file_size        => nvl(p_file_size, 9999999),
									 p_file_path        => p_file_path,
									 p_user_id          => p_user_id);
	
		v_record.record_id        := p_record_id;
		v_record.table_name       := p_table_name;
		v_record.table_pk_value   := p_table_pk_value;
		v_record.attachment_id    := v_attachment_id;
		v_record.creation_date    := SYSDATE;
		v_record.created_by       := p_user_id;
		v_record.last_update_date := SYSDATE;
		v_record.last_updated_by  := p_user_id;
	
		INSERT INTO fnd_atm_attachment_multi VALUES v_record;
		p_attachment_id := v_attachment_id;
	END;

	PROCEDURE app_prj_bp_save(p_prj_bp_id                   IN OUT NUMBER,
														p_project_id                  NUMBER,
														p_id_card_no                  VARCHAR2,
														p_bp_name                     VARCHAR2,
														p_cell_phone                  VARCHAR2,
														p_academic_background         VARCHAR2,
														p_marital_status              VARCHAR2,
														p_annual_income               NUMBER,
														p_source_of_income            VARCHAR2,
														p_first_time_buyer_flag       VARCHAR,
														p_main_driver_of_car          VARCHAR2,
														p_living_address              VARCHAR2,
														p_living_situation            VARCHAR2,
														p_years_of_living_house       NUMBER,
														p_ownship_of_house            VARCHAR2,
														p_house_loans_flag            VARCHAR2,
														p_address_on_resident_booklit VARCHAR2,
														p_industry                    VARCHAR2,
														p_work_unit                   VARCHAR2,
														p_work_unit_address           VARCHAR2,
														p_work_unit_phone             VARCHAR2,
														p_industry_work_experience    VARCHAR2,
														p_position                    VARCHAR2,
														p_release_form                VARCHAR2,
														p_id_no_sp                    VARCHAR2,
														p_bp_name_sp                  VARCHAR2,
														p_cell_phone_sp               VARCHAR2,
														p_academic_background_sp      VARCHAR2,
														p_source_of_income_db         VARCHAR2,
														p_relationship_sp             VARCHAR2,
														p_description_others          VARCHAR2,
														p_living_address_db           VARCHAR2,
														p_resident_addres             VARCHAR2,
														p_industry_sp                 VARCHAR2,
														p_work_unit_name_sp           VARCHAR2,
														p_work_unit_address_sp        VARCHAR2,
														p_industry_work_exper         VARCHAR2,
														p_position_sp                 VARCHAR2,
														p_gender                      VARCHAR2,
														p_date_of_birth               VARCHAR2,
														p_age                         VARCHAR2,
														p_gender_sp                   VARCHAR2,
														p_date_of_birth_sp            VARCHAR2,
														p_old_sp                      VARCHAR2,
														p_add_province                VARCHAR2,
														p_add_city                    VARCHAR2,
														p_liv_province                VARCHAR2,
														p_liv_city                    VARCHAR2,
														p_work_province               VARCHAR2,
														p_work_city                   VARCHAR2,
														p_resident_add_province       VARCHAR2,
														p_resident_add_city           VARCHAR2,
														p_living_add_province         VARCHAR2,
														p_living_add_city             VARCHAR2,
														p_work_province_sp            VARCHAR2,
														p_work_city_sp                VARCHAR2,
														p_user_id                     NUMBER) IS
		r_prj_project_bp prj_project_bp%ROWTYPE;
		v_cdd_list_id    NUMBER;
		v_bp_class       VARCHAR2(30);
		r_prj_project    prj_project%ROWTYPE;
		v_cdd_check_id   NUMBER;
	BEGIN
		r_prj_project_bp.project_id                  := p_project_id;
		r_prj_project_bp.id_card_no                  := p_id_card_no;
		r_prj_project_bp.bp_name                     := p_bp_name;
		r_prj_project_bp.cell_phone                  := p_cell_phone;
		r_prj_project_bp.academic_background         := p_academic_background;
		r_prj_project_bp.marital_status              := p_marital_status;
		r_prj_project_bp.annual_income               := p_annual_income;
		r_prj_project_bp.source_of_income            := p_source_of_income;
		r_prj_project_bp.first_time_buyer_flag       := p_first_time_buyer_flag;
		r_prj_project_bp.main_driver_of_car          := p_main_driver_of_car;
		r_prj_project_bp.living_address              := p_living_address;
		r_prj_project_bp.living_situation            := p_living_situation;
		r_prj_project_bp.years_of_living_house       := p_years_of_living_house;
		r_prj_project_bp.ownship_of_house            := p_ownship_of_house;
		r_prj_project_bp.house_loans_flag            := p_house_loans_flag;
		r_prj_project_bp.address_on_resident_booklit := p_address_on_resident_booklit;
		r_prj_project_bp.industry                    := p_industry;
		r_prj_project_bp.work_unit                   := p_work_unit;
		r_prj_project_bp.work_unit_address           := p_work_unit_address;
		r_prj_project_bp.work_unit_phone             := p_work_unit_phone;
		r_prj_project_bp.industry_work_experience    := p_industry_work_experience;
		r_prj_project_bp.position                    := p_position;
		r_prj_project_bp.release_form                := p_release_form;
		r_prj_project_bp.id_type                     := 'ID_CARD';
		r_prj_project_bp.id_no_sp                    := p_id_no_sp;
		r_prj_project_bp.bp_name_sp                  := p_bp_name_sp;
		r_prj_project_bp.cell_phone_sp               := p_cell_phone_sp;
		r_prj_project_bp.academic_background_sp      := p_academic_background_sp;
		r_prj_project_bp.source_of_income_db         := p_source_of_income_db;
		r_prj_project_bp.relationship_sp             := p_relationship_sp;
		r_prj_project_bp.description_others          := p_description_others;
		r_prj_project_bp.living_address_db           := p_living_address_db;
		r_prj_project_bp.resident_addres             := p_resident_addres;
		r_prj_project_bp.industry_sp                 := p_industry_sp;
		r_prj_project_bp.work_unit_name_sp           := p_work_unit_name_sp;
		r_prj_project_bp.work_unit_address_sp        := p_work_unit_address_sp;
		r_prj_project_bp.industry_work_exper         := p_industry_work_exper;
		r_prj_project_bp.position_sp                 := p_position_sp;
		r_prj_project_bp.last_updated_by             := p_user_id;
		r_prj_project_bp.last_update_date            := SYSDATE;
		r_prj_project_bp.gender                      := p_gender;
		r_prj_project_bp.date_of_birth               := to_date(p_date_of_birth, 'yyyy-mm-dd');
		r_prj_project_bp.age                         := p_age;
		r_prj_project_bp.gender_sp                   := p_gender_sp;
		r_prj_project_bp.date_of_birth_sp            := to_date(p_date_of_birth_sp, 'yyyy-mm-dd');
		r_prj_project_bp.old_sp                      := p_old_sp;
		r_prj_project_bp.add_province                := p_add_province;
		r_prj_project_bp.add_city                    := p_add_city;
		r_prj_project_bp.liv_province                := p_liv_province;
		r_prj_project_bp.liv_city                    := p_liv_city;
		r_prj_project_bp.work_province               := p_work_province;
		r_prj_project_bp.work_city                   := p_work_city;
		r_prj_project_bp.resident_add_province       := p_resident_add_province;
		r_prj_project_bp.resident_add_city           := p_resident_add_city;
		r_prj_project_bp.living_add_province         := p_living_add_province;
		r_prj_project_bp.living_add_city             := p_living_add_city;
		r_prj_project_bp.work_province_sp            := p_work_province_sp;
		r_prj_project_bp.work_city_sp                := p_work_city_sp;
	
		SELECT *
			INTO r_prj_project
			FROM prj_project t
		 WHERE t.project_id = r_prj_project_bp.project_id;
	
		r_prj_project_bp.bp_class    := r_prj_project.bp_class;
		r_prj_project_bp.bp_category := 'TENANT';
		IF p_prj_bp_id IS NULL THEN
			p_prj_bp_id                    := prj_project_bp_s.nextval;
			r_prj_project_bp.prj_bp_id     := p_prj_bp_id;
			r_prj_project_bp.created_by    := p_user_id;
			r_prj_project_bp.creation_date := SYSDATE;
			INSERT INTO prj_project_bp VALUES r_prj_project_bp;
		ELSE
			r_prj_project_bp.prj_bp_id := p_prj_bp_id;
			UPDATE prj_project_bp t SET ROW = r_prj_project_bp WHERE t.prj_bp_id = p_prj_bp_id;
		END IF;
	
		yonda_prj_project_pkg.copy_prj_bp_to_bp_master(p_project_id => r_prj_project_bp.project_id,
																									 p_user_id    => p_user_id);
	
		prj_project_pkg.project_create_save_check(p_project_id       => r_prj_project_bp.project_id,
																							p_user_id          => p_user_id,
																							p_function_code    => NULL,
																							p_function_usage   => 'UPDATE',
																							p_save_source_type => NULL,
																							p_cdd_list_id      => v_cdd_list_id);
	
		FOR c_cdd_item IN (SELECT *
												 FROM prj_cdd_item i
												WHERE i.cdd_list_id = v_cdd_list_id
													AND NOT EXISTS (SELECT 1
																 FROM prj_cdd_item_check prc
																WHERE prc.cdd_item_id = i.cdd_item_id)) LOOP
			prj_cdd_item_pkg.prj_cdd_item_check_insert(p_cdd_item_id         => c_cdd_item.cdd_item_id,
																								 p_send_flag           => 'N',
																								 p_paper_required      => 'N',
																								 p_attachment_required => 'N',
																								 p_not_applicable      => 'N',
																								 p_user_id             => p_user_id,
																								 p_check_id            => v_cdd_check_id);
		
			INSERT INTO prj_cdd_item_doc_ref
				(doc_ref_id,
				 document_table,
				 document_id,
				 check_id,
				 created_by,
				 creation_date,
				 last_updated_by,
				 last_update_date)
			VALUES
				(prj_cdd_item_doc_ref_s.nextval,
				 'PRJ_PROJECT',
				 p_project_id,
				 v_cdd_check_id,
				 p_user_id,
				 SYSDATE,
				 p_user_id,
				 SYSDATE);
		
		END LOOP;
	
	END;

	PROCEDURE app_bp_contact_save(p_prj_contact_info_id IN OUT NUMBER,
																p_prj_bp_id           NUMBER,
																p_contact_person      VARCHAR2,
																p_cell_phone          VARCHAR2,
																p_comments            VARCHAR2,
																p_contact_person_1    VARCHAR2,
																p_cell_phone_1        VARCHAR2,
																p_comments_1          VARCHAR2,
																p_user_id             NUMBER) IS
		r_bp_ct prj_project_bp_contact_info%ROWTYPE;
	BEGIN
		r_bp_ct.prj_bp_id        := p_prj_bp_id;
		r_bp_ct.contact_person   := p_contact_person;
		r_bp_ct.cell_phone       := p_cell_phone;
		r_bp_ct.comments         := p_comments;
		r_bp_ct.contact_person_1 := p_contact_person_1;
		r_bp_ct.cell_phone_1     := p_cell_phone_1;
		r_bp_ct.comments_1       := p_comments_1;
		r_bp_ct.last_update_date := SYSDATE;
		r_bp_ct.last_updated_by  := p_user_id;
	
		IF p_prj_contact_info_id IS NULL THEN
			p_prj_contact_info_id       := prj_project_bp_contact_info_s.nextval;
			r_bp_ct.prj_contact_info_id := p_prj_contact_info_id;
			r_bp_ct.created_by          := p_user_id;
			r_bp_ct.creation_date       := SYSDATE;
			INSERT INTO prj_project_bp_contact_info VALUES r_bp_ct;
		ELSE
			r_bp_ct.prj_contact_info_id := p_prj_contact_info_id;
			UPDATE prj_project_bp_contact_info t
				 SET ROW = r_bp_ct
			 WHERE t.prj_contact_info_id = p_prj_contact_info_id;
		END IF;
	END;

	PROCEDURE app_con_for_payment(p_contract_id NUMBER,
																p_user_id     NUMBER) IS
	BEGIN
		cus_csh_payment_wfl_pkg.auto_create_csh_payment(p_contract_id => p_contract_id,
																										p_user_id     => p_user_id);
	END;

	PROCEDURE check_app_login(p_access_token  VARCHAR2,
														p_user_id       NUMBER,
														p_error_message OUT VARCHAR2) IS
		r_hls_sso_token hls_sso_token%ROWTYPE;
		e_app_expired_error EXCEPTION;
		v_access_token VARCHAR2(200);
	BEGIN
		v_access_token := md5(p_access_token);
		SELECT *
			INTO r_hls_sso_token
			FROM hls_sso_token t
		 WHERE t.token = upper(v_access_token)
			 AND t.sso_user_id = p_user_id
			 AND rownum = 1;
	
		IF (SYSDATE - r_hls_sso_token.last_update_date) * 24 * 60 > 60 THEN
			RAISE e_app_expired_error;
		ELSE
			UPDATE hls_sso_token t
				 SET t.last_update_date = SYSDATE,
						 t.last_updated_by  = p_user_id
			 WHERE t.sso_user_id = p_user_id
				 AND t.token = upper(v_access_token);
		END IF;
	
	EXCEPTION
		WHEN e_app_expired_error THEN
			p_error_message := '登录超时,请重新登录！';
		
		WHEN no_data_found THEN
			p_error_message := '没有权限访问,请先登录！';
		
		WHEN OTHERS THEN
			p_error_message := dbms_utility.format_error_backtrace || ' ' || SQLERRM;
	END;

	PROCEDURE delete_cdd_atm(p_attachment_id NUMBER) IS
	BEGIN
		DELETE FROM fnd_atm_attachment faa WHERE faa.attachment_id = p_attachment_id;
		DELETE FROM fnd_atm_attachment_multi atm WHERE atm.attachment_id = p_attachment_id;
	END;
	PROCEDURE app_paycard_change(p_contract_id          NUMBER,
															 p_direct_debit_bank_id NUMBER,
															 p_withhold_way         VARCHAR2,
															 p_ebank_province       NUMBER,
															 p_ebank_city           NUMBER,
															 p_dd_bank_branch_name  VARCHAR2,
															 p_dd_bank_account_num  VARCHAR2,
															 p_dd_remark            VARCHAR2,
															 p_user_id              NUMBER,
															 p_open_id              VARCHAR2) IS
		con_contract_change_req_rec con_contract_change_req%ROWTYPE;
		v_change_req_id             NUMBER;
		v_owner_user_id             NUMBER;
	BEGIN
		/*select *
     into con_contract_change_req_rec
     from con_contract_change_req a
    where a.contract_id = p_contract_id;*/
	
		SELECT cc.owner_user_id
			INTO v_owner_user_id
			FROM con_contract cc
		 WHERE cc.contract_id = p_contract_id;
	
		con_change_req_calc_itfc_pkg.create_change_req(p_contract_id     => p_contract_id,
																									 p_req_date        => SYSDATE,
																									 p_req_type        => 'PAYCARD',
																									 p_description     => '银行卡变更',
																									 p_user_id         => v_owner_user_id,
																									 p_simulation_flag => 'N',
																									 p_change_req_id   => v_change_req_id);
		UPDATE con_contract cc
			 SET cc.direct_debit_bank_id = p_direct_debit_bank_id,
					 cc.withhold_way         = p_withhold_way,
					 cc.dd_bank_branch_name  = p_dd_bank_branch_name,
					 cc.ebank_province       = p_ebank_province,
					 cc.ebank_city           = p_ebank_city,
					 --  cc.emer_contacts       = p_emer_contacts,
					 --  cc.emer_phone          = p_emer_phone,
					 cc.dd_remark           = p_dd_remark　,
					 cc.dd_bank_account_num = p_dd_bank_account_num
		 WHERE cc.contract_id = v_change_req_id;
	
		con_change_req_calc_itfc_pkg.submit_change_req(p_change_req_id => v_change_req_id,
																									 p_user_id       => v_owner_user_id);
	
		-- wx 
		INSERT INTO wx_paycard_open_id_save
			(save_id,
			 open_id,
			 change_req_id,
			 ast_car_insurance_records_id,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(wx_paycard_open_id_save_s.nextval,
			 p_open_id,
			 v_change_req_id,
			 NULL,
			 SYSDATE,
			 -101,
			 SYSDATE,
			 -101);
	
		/*con_change_req_calc_itfc_pkg.confirm_change_req(p_change_req_id => v_change_req_id,
    p_user_id       => p_user_id);*/
	
	END;

	PROCEDURE app_prj_bp_change(p_contract_id          NUMBER,
															p_cell_phone           NUMBER,
															p_invoice_send_address VARCHAR2,
															p_user_id              NUMBER,
															p_open_id              VARCHAR2) IS
		v_change_req_id NUMBER;
		e_app_null_error EXCEPTION;
		v_owner_user_id NUMBER;
	BEGIN
		BEGIN
			IF p_user_id IS NULL THEN
				RAISE e_app_null_error;
			END IF;
		END;
	
		SELECT cc.owner_user_id
			INTO v_owner_user_id
			FROM con_contract cc
		 WHERE cc.contract_id = p_contract_id;
	
		con_change_req_calc_itfc_pkg.create_change_req(p_contract_id     => p_contract_id,
																									 p_req_date        => SYSDATE,
																									 p_req_type        => 'BASICHAG',
																									 p_description     => '联系方式变更',
																									 p_user_id         => v_owner_user_id,
																									 p_simulation_flag => 'N',
																									 p_change_req_id   => v_change_req_id);
	
		--zj_wfl_core_pkg.log(-101, -101, -101, v_change_req_id, -101);
	
		UPDATE con_contract_bp ccb
			 SET ccb.cell_phone           = p_cell_phone,
					 ccb.invoice_send_address = p_invoice_send_address
		 WHERE ccb.bp_category = 'TENANT'
			 AND ccb.contract_id = v_change_req_id;
		con_change_req_calc_itfc_pkg.submit_change_req(p_change_req_id => v_change_req_id,
																									 p_user_id       => v_owner_user_id);
		/*con_change_req_calc_itfc_pkg.confirm_change_req(p_change_req_id => v_change_req_id,
    p_user_id       => p_user_id);*/
	
		INSERT INTO wx_paycard_open_id_save
			(save_id,
			 open_id,
			 change_req_id,
			 ast_car_insurance_records_id,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(wx_paycard_open_id_save_s.nextval,
			 p_open_id,
			 v_change_req_id,
			 NULL,
			 SYSDATE,
			 -101,
			 SYSDATE,
			 -101);
	
	EXCEPTION
		WHEN e_app_null_error THEN
			sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CUS_APP_CUSTOMER_PKG.E_APP_NULL_ERROR',
																											p_created_by              => v_owner_user_id,
																											p_package_name            => 'CUS_APP_CUSTOMER_PKG',
																											p_procedure_function_name => 'APP_PRJ_BP_CHANGE');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
		
	END;

	PROCEDURE con_insurance_save_sumbit(p_contract_id        NUMBER,
																			p_temp_pk            NUMBER,
																			p_cell_phone         NUMBER,
																			p_material_option    VARCHAR2,
																			p_mailmax            VARCHAR2,
																			p_mailling_address   VARCHAR2,
																			p_record_date        DATE,
																			p_insurance_number   VARCHAR2,
																			p_insurance_company  VARCHAR2,
																			p_record_description VARCHAR2,
																			p_user_id            NUMBER,
																			p_open_id            VARCHAR2) IS
		overdue_status_flag            VARCHAR2(1);
		archive_status_flag            VARCHAR2(200);
		v_ast_car_insurance_records_id NUMBER;
		v_owner_user_id                NUMBER;
		v_ast_car_insurance_id         NUMBER;
		v_material_option              VARCHAR2(200);
		v_num                          NUMBER;
		ex                             NUMBER;
		v_open_id                      VARCHAR2(2000);
		v_note                         VARCHAR2(2000);
		--  v_num                          number;
		e_length_error EXCEPTION;
	BEGIN
		-- v_ast_car_insurance_records_id := ast_car_insurance_records_s.nextval;
		BEGIN
			FOR ex IN (SELECT *
									 FROM fnd_atm_attachment_multi fam
									WHERE fam.table_name = 'WX_TEMP'
										AND fam.table_pk_value = p_temp_pk) LOOP
				UPDATE fnd_atm_attachment_multi l
					 SET l.table_name     = 'AST_CAR_INSURANCE_RECORDS',
							 l.table_pk_value = p_temp_pk
				 WHERE l.record_id = ex.record_id;
			END LOOP;
		END;
	
		SELECT cc.overdue_status,
					 cc.archive_status
			INTO overdue_status_flag,
					 archive_status_flag
			FROM con_contract cc
		 WHERE cc.contract_id = p_contract_id;
	
		SELECT cc.owner_user_id
			INTO v_owner_user_id
			FROM con_contract cc
		 WHERE cc.contract_id = p_contract_id;
	
		SELECT a.ast_con_car_insurance_id
			INTO v_ast_car_insurance_id
			FROM ast_con_insurance a
		 WHERE a.contract_id = p_contract_id;
	
		/*select max(a.ast_car_insurance_records_id)
     into v_ast_car_insurance_records_id
     from ast_car_insurance_records a
    where a.contract_id = p_contract_id;*/
	
		IF p_material_option = '1' THEN
			v_material_option := 'SCAN';
		ELSIF p_material_option = '2' THEN
			v_material_option := 'ORIGINAL';
		END IF;
	
		/*select length(p_item_frame_number) into v_num from dual;
    
    if v_num <> 17 then
      raise e_length_error;
    end if;*/
	
		INSERT INTO ast_car_insurance_records
			(ast_car_insurance_records_id,
			 ast_con_car_insurance_id,
			 cell_phone,
			 material_option,
			 mailmax,
			 mailling_address,
			 record_date,
			 insurance_number,
			 insurance_date_from,
			 insurance_date_to,
			 item_frame_number,
			 settle_claim_amount,
			 insurance_company,
			 report_number,
			 record_description,
			 contract_id,
			 created_by,
			 creation_date,
			 last_updated_by,
			 last_update_date)
		VALUES
			(p_temp_pk,
			 v_ast_car_insurance_id,
			 p_cell_phone,
			 v_material_option,
			 p_mailmax,
			 p_mailling_address,
			 p_record_date,
			 p_insurance_number,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 p_insurance_company,
			 NULL,
			 p_record_description,
			 p_contract_id,
			 v_owner_user_id,
			 SYSDATE,
			 v_owner_user_id,
			 SYSDATE);
	
		INSERT INTO wx_paycard_open_id_save
			(save_id,
			 open_id,
			 change_req_id,
			 ast_car_insurance_records_id,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(wx_paycard_open_id_save_s.nextval,
			 p_open_id,
			 NULL,
			 p_temp_pk,
			 SYSDATE,
			 -101,
			 SYSDATE,
			 -101);
	
		--  if overdue_status_flag = 'N' and archive_status_flag = '10' then
		ast_insurance_wfl_pkg.submit_ins_ln(p_ast_car_insurance_records_id => p_temp_pk,
																				p_user_id                      => v_owner_user_id);
		-- end if;
	
	EXCEPTION
		WHEN e_length_error THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '请输入17位正确车架号',
																										 p_created_by              => -101,
																										 p_package_name            => 'cus_app_customer_pkg',
																										 p_procedure_function_name => 'con_insurance_save_sumbit');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE check_insurance(p_contract_id                  NUMBER,
														p_ast_car_insurance_records_id IN OUT NUMBER) IS
		v_num                  NUMBER;
		v_insurance_records_id NUMBER;
		e_insurance_error EXCEPTION;
	BEGIN
		SELECT COUNT(b.ast_car_insurance_records_id)
			INTO v_num
			FROM ast_car_insurance_records b
		 WHERE b.contract_id = p_contract_id;
	
		SELECT MAX(b.ast_car_insurance_records_id)
			INTO v_insurance_records_id
			FROM ast_car_insurance_records b
		 WHERE b.contract_id = p_contract_id;
	
		/*zj_wfl_core_pkg.log(-1,
    -1,
    -1,
    p_contract_id || '--' ||
    p_ast_car_insurance_records_id || '--' || v_num || '--' ||
    v_insurance_records_id,
    -1);*/
	
		IF v_num = 0 THEN
			RAISE e_insurance_error;
		END IF;
		p_ast_car_insurance_records_id := v_insurance_records_id;
	
	EXCEPTION
		WHEN e_insurance_error THEN
			sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '请先点击保存,再上传附件！',
																										 p_created_by              => -101,
																										 p_package_name            => 'cus_app_customer_pkg',
																										 p_procedure_function_name => 'check_insurance');
		
			raise_application_error(sys_raise_app_error_pkg.c_error_number,
															sys_raise_app_error_pkg.g_err_line_id);
	END;

	PROCEDURE wx_upload_attachment(p_record_id      OUT fnd_atm_attachment_multi.record_id%TYPE,
																 p_table_name     fnd_atm_attachment_multi.table_name%TYPE,
																 p_table_pk_value fnd_atm_attachment_multi.table_pk_value%TYPE,
																 p_file_name      fnd_atm_attachment.file_name%TYPE,
																 p_file_path      fnd_atm_attachment.file_path%TYPE,
																 p_file_size      fnd_atm_attachment.file_size%TYPE,
																 p_user_id        fnd_atm_attachment_multi.created_by%TYPE) IS
		v_record               fnd_atm_attachment_multi%ROWTYPE;
		v_attachment_id        fnd_atm_attachment.attachment_id%TYPE;
		v_num                  NUMBER;
		v_insurance_records_id NUMBER;
		v_insurance_id         NUMBER;
		e_insurance_error EXCEPTION;
	BEGIN
		-- v_insurance_records_id := ast_car_insurance_records_s.nextval;
		/*select count(b.ast_car_insurance_records_id)
     into v_num
     from AST_CAR_INSURANCE_RECORDS b
    where b.contract_id = p_table_pk_value;*/
	
		/*select max(b.ast_car_insurance_records_id)
     into v_insurance_records_id
     from AST_CAR_INSURANCE_RECORDS b
    where b.contract_id = p_table_pk_value;*/
	
		-- 因为微客服页面没有单独的保存按钮 在附件上传时就插表需要得到主键
		/*select count(1)
      into v_num
      from AST_CAR_INSURANCE_RECORDS a
     where a.contract_id = p_table_pk_value;
    
    select max(b.ast_car_insurance_records_id)
      into v_insurance_id
      from AST_CAR_INSURANCE_RECORDS b
     where b.contract_id = p_table_pk_value;
    
    if v_num = 0 then
      insert into ast_car_insurance_records
        (ast_car_insurance_records_id,
         AST_CON_CAR_INSURANCE_ID,
         RECORD_DATE,
         INSURANCE_TYPE,
         RECORD_DESCRIPTION,
         SETTLE_CLAIM_AMOUNT,
         REF_V01,
         REF_V02,
         REF_V03,
         REF_V04,
         REF_V05,
         REF_N01,
         REF_N02,
         REF_N03,
         REF_N04,
         REF_N05,
         REF_D01,
         REF_D02,
         REF_D03,
         REF_D04,
         REF_D05,
         CREATION_DATE,
         CREATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         REPORT_NUMBER,
         DAMAGE_SERIOUS_FLAG,
         DAMAGE_LEVEL_DESCRIPTION,
         DOCUMENT_STATUS,
         PAYMENT_FINISH_FLAG,
         STORE_PERSON,
         STORE_PERSON_TEL,
         INS_PERSON,
         INS_PERSON_TEL,
         DOCUMENT_TYPE,
         DOCUMENT_CATEGORY,
         WFL_INSTANCE_ID,
         INSURANCE_NUMBER,
         INSURANCE_COMPANY,
         MATERIAL_OPTION,
         MAILMAX,
         MAILLING_ADDRESS,
         CELL_PHONE,
         ITEM_FRAME_NUMBER,
         INSURANCE_DATE_TO,
         INSURANCE_DATE_FROM,
         contract_id)
      values
        (v_insurance_records_id,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         p_table_pk_value);
    elsif v_num > 0 then
      v_insurance_records_id := v_insurance_id;
    end if;*/
	
		SELECT fnd_atm_attachment_multi_s.nextval INTO p_record_id FROM dual;
		insert_fnd_atm(p_attachment_id    => v_attachment_id,
									 p_source_type_code => 'fnd_atm_attachment_multi',
									 p_source_pk_value  => p_record_id,
									 p_file_type_code   => 'jpg',
									 p_mime_type        => 'image/jpeg',
									 p_file_name        => p_file_name,
									 p_file_size        => nvl(p_file_size, 9999999),
									 p_file_path        => p_file_path,
									 p_user_id          => p_user_id);
	
		v_record.record_id        := p_record_id;
		v_record.table_name       := p_table_name;
		v_record.table_pk_value   := p_table_pk_value;
		v_record.attachment_id    := v_attachment_id;
		v_record.creation_date    := SYSDATE;
		v_record.created_by       := p_user_id;
		v_record.last_update_date := SYSDATE;
		v_record.last_updated_by  := p_user_id;
	
		INSERT INTO fnd_atm_attachment_multi VALUES v_record;
	
		/*EXCEPTION
    WHEN e_insurance_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '请先点击保存,再上传附件！',
                                                     p_created_by              => -101,
                                                     p_package_name            => 'cus_app_customer_pkg',
                                                     p_procedure_function_name => 'check_insurance');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);*/
	
	END;
	PROCEDURE get_verifiction_code(p_id_type          VARCHAR2,
																 p_id_card_no       VARCHAR2,
																 p_user_id          NUMBER,
																 p_verifiction_code IN OUT VARCHAR2,
																 p_cell_phone       IN OUT NUMBER) IS
		v_cell_phone NUMBER;
		v_image_code VARCHAR2(200);
		v_project_id NUMBER;
		v_bp_name    VARCHAR2(200);
	BEGIN
		/*select ppb.cell_phone
     into v_cell_phone
     from prj_project_bp ppb
    where ppb.bp_category = 'TENANT'
      and ppb.project_id = p_project_id;*/
	
		SELECT a.cell_phone
			INTO v_cell_phone
			FROM hls_bp_master a
		 WHERE a.id_type = p_id_type
			 AND a.id_card_no = p_id_card_no;
	
		/* select p.project_id, p.bp_name
     into v_project_id, v_bp_name
     from prj_project_bp p
    where p.bp_category = 'TENANT'
      and p.id_type = p_id_type
      and p.id_card_no = p_id_card_no;*/
	
		/*delete from WX_SEND_MESSAGE a
    where a.project_id = v_project_id
      and a.cell_phone = '86' || v_cell_phone;*/
	
		DELETE FROM wx_send_message a
		 WHERE a.id_type = p_id_type
			 AND a.id_card_no = p_id_card_no
			 AND a.cell_phone = '86' || v_cell_phone;
	
		-- v_image_code := dbms_random.string('x', 6);  
		v_image_code := dbms_random_wx.string_1('x', 6);
		INSERT INTO wx_send_message
			(send_message_id,
			 project_id,
			 cell_phone,
			 image_code,
			 id_type,
			 id_card_no,
			 creation_date,
			 created_by,
			 last_update_date,
			 last_updated_by)
		VALUES
			(wx_send_message_s.nextval,
			 NULL,
			 '86' || v_cell_phone,
			 v_image_code,
			 p_id_type,
			 p_id_card_no,
			 SYSDATE,
			 p_user_id,
			 SYSDATE,
			 p_user_id);
		p_cell_phone       := '86' || v_cell_phone;
		p_verifiction_code := v_image_code;
	END;

	PROCEDURE contract_status(p_contract_id NUMBER,
														p_incept_flag IN OUT VARCHAR2) IS
		v_contract_status VARCHAR2(100);
	BEGIN
		SELECT cc.contract_status
			INTO v_contract_status
			FROM con_contract cc
		 WHERE cc.contract_id = p_contract_id
			 AND cc.data_class = 'NORMAL';
	
		IF v_contract_status = 'INCEPT' THEN
			p_incept_flag := 'Y';
		ELSE
			p_incept_flag := 'N';
		END IF;
	END;

	PROCEDURE wx_send_instance_end(p_instance_id    NUMBER,
																 x_return_message OUT VARCHAR2,
																 x_access_token   OUT VARCHAR2) IS
		v_instance_status NUMBER;
		v_workflow_desc   VARCHAR2(200);
	BEGIN
		SELECT v.instance_status
			INTO v_instance_status
			FROM zj_wfl_workflow_instance_v v
		 WHERE v.instance_id = p_instance_id;
	
		SELECT a.workflow_desc
			INTO v_workflow_desc
			FROM zj_wfl_instance_node_rcpt_v a
		 WHERE a.instance_id = p_instance_id
			 AND rownum = 1;
	
		IF v_instance_status = 10 THEN
			x_return_message := '您好!您的' || v_workflow_desc || '已审批通过!';
		ELSIF v_instance_status = -1 THEN
			x_return_message := '您好!您的' || v_workflow_desc || '审批未通过!';
		END IF;
		x_access_token := sys_guid();
	END;
	FUNCTION get_file_path(p_table_name     VARCHAR2,
												 p_table_value_pk NUMBER) RETURN VARCHAR2 IS
		v_file_path VARCHAR2(2000);
	BEGIN
		SELECT file_path
			INTO v_file_path
			FROM (SELECT at.attachment_id,
									 at.file_path
							FROM fnd_atm_attachment       at,
									 fnd_atm_attachment_multi atm
						 WHERE at.attachment_id = atm.attachment_id
							 AND atm.table_name = p_table_name
							 AND atm.table_pk_value = p_table_value_pk
						 ORDER BY at.attachment_id DESC) t1
		 WHERE rownum = 1;
		RETURN v_file_path;
	EXCEPTION
		WHEN no_data_found THEN
			RETURN '';
	END;

	FUNCTION get_file_attaid(p_table_name     VARCHAR2,
													 p_table_value_pk NUMBER) RETURN NUMBER IS
		v_attachment_id NUMBER;
	BEGIN
		SELECT attachment_id
			INTO v_attachment_id
			FROM (SELECT at.attachment_id,
									 at.file_path
							FROM fnd_atm_attachment       at,
									 fnd_atm_attachment_multi atm
						 WHERE at.attachment_id = atm.attachment_id
							 AND atm.table_name = p_table_name
							 AND atm.table_pk_value = p_table_value_pk
						 ORDER BY at.attachment_id DESC) t1
		 WHERE rownum = 1;
		RETURN v_attachment_id;
	EXCEPTION
		WHEN no_data_found THEN
			RETURN '';
	END;

END cus_app_customer_pkg;
/
