  
       /*�½��־����*/
       update GLD_PERIOD_STATUS t
          set t.monthly_closed_flag = '';
                   /*���������Ϊ1*/
       update fnd_coding_rule_values t set t.current_value=0; 
         delete from sch_concurrent_job jo where jo.job_id !=0;
delete from csh_bank_branch t where t.enabled_flag <>'Y';
delete from  csh_bank_account t where t.enabled_flag<>'Y';
delete from AUT_OWNER_USER_DEFAULT;
delete from hls_lease_channel t where t.enabled_flag<>'Y';
delete from hls_division t where t.enabled_flag<>'Y';
delete from hls_lease_organization t where t.enabled_flag<>'Y';
  
  /*��̨������־��*/
   truncate table SYS_RUNTIME_REQUEST_DETAIL;
   truncate table sys_runtime_request_record;
   truncate table sys_runtime_exception_log;
   truncate table sys_runtime_req_url_detail;
   truncate table SYS_RUNTIME_REQ_REC_ARCHIVE;
   truncate table SYS_RUNTIME_EXP_LOG_ARCHIVE;
   truncate table zj_sys_notify_logs;
   truncate table sys_notice_msg;
   truncate table zj_sys_mailing_list;
   drop sequence sys_notice_msg_s;
   create sequence sys_notice_msg_s;

   drop sequence sys_runtime_req_url_detail_s;
   create sequence sys_runtime_req_url_detail_s;
   
     /*�û���½��¼��*/
       truncate table SYS_USER_LOGINS;
       drop sequence SYS_USER_LOGINS_s;
       create sequence SYS_USER_LOGINS_s;

       /*�¼��������־*/

       truncate table EVT_EVENT_RECORD;
       drop sequence EVT_EVENT_RECORD_s;
       create sequence EVT_EVENT_RECORD_s;

       truncate table EVT_EVENT_HANDLE_LOG;
       drop sequence EVT_EVENT_HANDLE_LOG_s;
       create sequence EVT_EVENT_HANDLE_LOG_s;

       truncate table SYS_RAISE_APP_ERRORS;
       drop sequence SYS_RAISE_APP_ERRORS_s;
       create sequence SYS_RAISE_APP_ERRORS_s;


       truncate table GLD_ACCOUNT_ASGN_CM_TMP;
       truncate table gld_je_template_logs;
       drop sequence gld_je_template_logs_s;
       create sequence gld_je_template_logs_s;
       truncate table sys_condition_matching;
       drop sequence sys_condition_matching_s;
       create sequence sys_condition_matching_s;
       truncate table sys_condition_detail;
       
          
     /*����ӿڱ�*/

       truncate table tbl_cust_docmaster;
       truncate table tbl_cust_docmaster_ht;
       truncate table tbl_result;
       truncate table tbl_result_ht;


       /*������ڼ�*/


       /*job���*/

     
       truncate table sch_concurrent_job_log;
        
     /*�ؼ��ܲ�����¼ɾ��*/
     truncate table hls_doc_operate_history;
     drop sequence hls_doc_operate_history_s;
     create sequence hls_doc_operate_history_s;
     
     truncate table YONDA_DOC_STATUS_HISTORY;
     drop sequence YONDA_DOC_STATUS_HISTORY_S;
     create sequence YONDA_DOC_STATUS_HISTORY_S;
     
     truncate table HLS_STANDARD_HISTORY;
     drop sequence HLS_STANDARD_HISTORY_S;
     create sequence HLS_STANDARD_HISTORY_S;

    /*���������*/
     truncate table hls_lease_item;
     drop sequence  hls_lease_item_s;
     create sequence hls_lease_item_s;
     truncate table hls_lease_item_company;
     drop sequence  hls_lease_item_company_s;
     create sequence hls_lease_item_company_s;
      /*hls_bp_master��ر�*/
     truncate table hls_bp_master;
     truncate table hls_bp_master_address;
     truncate table hls_bp_master_bank_account;
     truncate table hls_bp_master_company;
     truncate table hls_bp_master_contact_info;
     truncate table hls_bp_master_role;

     drop sequence hls_bp_master_s;
     create sequence hls_bp_master_s;
     drop sequence hls_bp_master_address_s;
     create sequence hls_bp_master_address_s;
     drop sequence CSH_BANK_ACCOUNT_S;
     create sequence CSH_BANK_ACCOUNT_S;
     drop sequence hls_bp_master_company_s;
     create sequence hls_bp_master_company_s;
     drop sequence hls_bp_master_contact_info_s;
     create sequence hls_bp_master_contact_info_s;
     drop sequence hls_bp_master_customer_s;
     create sequence hls_bp_master_customer_s;
     drop sequence hls_bp_master_role_s;
     create sequence hls_bp_master_role_s;
     
     /*��Ѻ����Ϣ*/
     truncate table hls_mortgage;
     drop sequence  hls_mortgage_s;
     create sequence hls_mortgage_s;
     
     /*��������*/
     drop sequence hls_document_s;
     create sequence hls_document_s;
         drop sequence HLS_DOCUMENT_LN_S;
         create sequence HLS_DOCUMENT_LN_S;
     
      /*�̻�*/
       truncate table prj_chance;
       truncate table prj_chance_contact_info;
       drop sequence prj_chance_contact_info_s;
       create sequence  prj_chance_contact_info_s;
       
        /*������Ŀ���������뵥��*/

         truncate table prj_project;
         truncate table prj_project_bp;
         truncate table prj_project_risk;
         truncate table prj_project_mortgage;
         drop sequence prj_project_mortgage_s;
         create sequence prj_project_mortgage_s;
         truncate table prj_project_meeting;
         truncate table prj_project_lease_item;
         truncate table prj_bp_hist_evolution;
         drop sequence  prj_bp_hist_evolution_s;
         create sequence  prj_bp_hist_evolution_s;
         drop sequence prj_project_bp_s;
         create sequence prj_project_bp_s;
         drop sequence prj_project_lease_item_s;
         create sequence prj_project_lease_item_s;
         truncate table prj_bp_stock_structure;
         drop sequence  prj_bp_stock_structure_s;
         create sequence  prj_bp_stock_structure_s;
         truncate table prj_project_lease_item_list;
         truncate table prj_bp_management;
         drop sequence prj_bp_management_s;
         create sequence  prj_bp_management_s;
         truncate table prj_special_retail;
         drop sequence prj_special_retail_s;
         create sequence prj_special_retail_s;
         truncate table prj_project_act_ctrler_hd;
         drop sequence prj_project_act_ctrler_hd_s;
         create sequence prj_project_act_ctrler_hd_s;

         truncate table  prj_bp_org_structure;
         truncate table  prj_bp_org_stru_executives;
         truncate table  prj_bp_org_stru_edu_ratio;
         truncate table  prj_bp_org_stru_skill_ratio;
         drop sequence prj_bp_org_structure_s;
         create sequence prj_bp_org_structure_s;
         drop sequence prj_bp_org_stru_executives_s;
         create sequence prj_bp_org_stru_executives_s;
         drop sequence prj_bp_org_stru_edu_ratio_s;
         create sequence prj_bp_org_stru_edu_ratio_s;
         drop sequence prj_bp_org_stru_skill_ratio_s;
         create sequence prj_bp_org_stru_skill_ratio_s;
         truncate table prj_bp_transactor;
         drop sequence  prj_bp_transactor_s;
         create sequence  prj_bp_transactor_s;
         truncate table prj_project_act_ctrler_in_h;
         drop sequence  prj_project_act_ctrler_in_h_s;
         create sequence  prj_project_act_ctrler_in_h_s;
         truncate table prj_project_act_ctrler_in_g;
         drop sequence prj_project_act_ctrler_in_g_s;
         create sequence  prj_project_act_ctrler_in_g_s;
         truncate table prj_project_approval;
         truncate table prj_project_approver;
         truncate table prj_project_approver_group;
         drop sequence  prj_project_approval_s;
         create sequence prj_project_approval_s;
         drop sequence  prj_project_approver_group_s;
         create sequence prj_project_approver_group_s;
         drop sequence  prj_project_approver_s;
         create sequence prj_project_approver_s;
         truncate table prj_project_bp_contact_info;
         drop sequence prj_project_bp_contact_info_s;
         create sequence prj_project_bp_contact_info_s;
         truncate table ast_car_insurance;
         drop sequence ast_car_insurance_s;
         create sequence ast_car_insurance_s;
          truncate table ast_car_condition;
         drop sequence ast_car_condition_s;
         create sequence ast_car_condition_s;
          truncate table ast_car_gps;
         drop sequence ast_car_gps_s;
         create sequence ast_car_gps_s;
         truncate table ast_car_inspection;
         drop sequence ast_car_inspection_s;
         create sequence ast_car_inspection_s;
         truncate table ast_car_insurance_endorse;
         drop sequence ast_car_insurance_endorse_s;
         create sequence ast_car_insurance_endorse_s;
         truncate table ast_car_insurance_records;
         drop sequence ast_car_insurance_records_s;
         create sequence ast_car_insurance_records_s;
         truncate table ast_car_license;
         drop sequence ast_car_license_s;
         create sequence ast_car_license_s;
         truncate table ast_car_trailer;
         drop sequence ast_car_trailer_s;
         create sequence ast_car_trailer_s;
         truncate table ast_car_violation;
         drop sequence ast_car_violation_s;
         create sequence ast_car_violation_s;
          /*������������*/
         truncate table hls_fin_calculator_logs;
         truncate table hls_fin_calculator_hd;
         truncate table HLS_FIN_CALCULATOR_LN;
         truncate table prj_quotation;
         truncate table HLS_FIN_CALCULATOR_LN_FORMULA;
         truncate table HLS_FIN_CALCULATOR_HD_FORMULA;

         drop sequence hls_fin_calculator_logs_s;
         create sequence hls_fin_calculator_logs_s;

         drop sequence hls_fin_calculator_hd_s;
         create sequence hls_fin_calculator_hd_s;

         drop sequence HLS_FIN_CALCULATOR_LN_s;
         create sequence HLS_FIN_CALCULATOR_LN_s;
         
         --������cdd_list_iterm
         truncate table prj_cdd_item;
         truncate table prj_cdd_item_doc_ref;
         truncate table prj_cdd_item_check;
         truncate table prj_cdd_item_list_grp_tab;

         drop sequence prj_cdd_item_s;
         create sequence prj_cdd_item_s;

         drop sequence prj_cdd_item_doc_ref_s;
         create sequence prj_cdd_item_doc_ref_s;

         drop sequence prj_cdd_item_check_s;
         create sequence prj_cdd_item_check_s;
         
         drop sequence prj_cdd_item_list_grp_tab_s;
         create sequence prj_cdd_item_list_grp_tab_s;
          /*������*/
         truncate table fnd_atm_attachment;
         truncate table fnd_atm_attachment_multi;

         drop sequence fnd_atm_attachment_s;
         create sequence fnd_atm_attachment_s;

         drop sequence fnd_atm_attachment_multi_s;
         create sequence fnd_atm_attachment_multi_s;
         /*������ʱ��*/
         truncate table fnd_interface_headers;
         truncate table fnd_interface_lines;
         drop sequence fnd_interface_headers_s;
         create sequence fnd_interface_headers_s;
         drop sequence fnd_interface_lines_s;
         create sequence fnd_interface_lines_s;
         /*���������*/
         truncate table zj_wfl_workflow_instance;
         truncate table zj_wfl_workflow_instance_para;
         truncate table zj_wfl_approve_record;
         truncate table zj_wfl_instance_log;
         truncate table zj_wfl_instance_node_hierarchy;
         truncate table zj_wfl_instance_node_history;
         truncate table zj_wfl_instance_node_rcpt_ht;
         truncate table zj_wfl_instance_node_recipient;
         truncate table zj_wfl_instance_node_hirc_ht;

         drop sequence zj_wfl_workflow_instance_s;
         create sequence zj_wfl_workflow_instance_s;

         drop sequence zj_wfl_approve_record_s;
         create sequence zj_wfl_approve_record_s;

         drop sequence zj_wfl_instance_log_s;
         create sequence zj_wfl_instance_log_s;

         drop sequence zj_wfl_instance_node_hirc_s;
         create sequence zj_wfl_instance_node_hirc_s;

         drop sequence zj_wfl_instance_node_hsty_s;
         create sequence zj_wfl_instance_node_hsty_s;

         drop sequence zj_wfl_instance_node_rcpt_s;
         create sequence zj_wfl_instance_node_rcpt_s;
          /*��ͬ��ر�*/
         truncate table con_contract;
         truncate table con_contract_bp;
         truncate table con_contract_billing_method;
         truncate table con_contract_cashflow;
         truncate table con_contract_cf_item;
         truncate table con_contract_change_req;
         truncate table con_contract_insurance;
         drop sequence con_contract_insurance_s;
         create sequence con_contract_insurance_s;


         truncate table con_contract_et_hd;
         truncate table con_contract_et_ln;

                    
         truncate table con_contract_je;

         truncate table con_contract_lease_item;
         truncate table con_contract_zero_bc;
         truncate table con_finance_income;
         truncate table con_unearned_finance_income;
         truncate table con_contract_content;
         drop sequence con_contract_bp_s;
         create sequence con_contract_bp_s;

         drop sequence con_contract_change_req_cf_s;
         create sequence con_contract_change_req_cf_s;

         drop sequence con_contract_lease_item_s;
         create sequence con_contract_lease_item_s;

         drop sequence con_finance_income_s;
         create sequence con_finance_income_s;
         drop sequence con_unearned_finance_income_s;
         create sequence con_unearned_finance_income_s;
         drop sequence con_contract_content_s;
         create sequence con_contract_content_s;
         /*����ֽ������*/
         truncate table csh_transaction;

         truncate table csh_write_off;
         truncate table csh_transaction_source;

         drop sequence csh_write_off_s;
         create sequence csh_write_off_s;
         drop sequence csh_transaction_source_s;
         create sequence csh_transaction_source_s;
          /*Ӧ�շ�Ʊ*/  /*Ӧ����Ʊ */
         truncate table  acr_invoice_hd;
         truncate table acr_invoice_ln;
       

         /*����*/
         truncate table csh_payment_req_hd;
         truncate table csh_payment_req_ln;
         truncate table csh_payment_req_ln_ddct;
         drop sequence csh_payment_req_ln_ddct_s;
         create sequence csh_payment_req_ln_ddct_s;
         truncate table csh_payment_req_ln_prepay;
          /*ƾ֤���*/
         truncate table hls_journal_header;
         truncate table hls_journal_detail;
         drop sequence hls_journal_header_s;
         create sequence hls_journal_header_s;
         drop sequence hls_journal_detail_s;
         create sequence hls_journal_detail_s;
         
          /*Ȩ��AUT��ر�*/
       truncate table AUT_OWNER_USER_BATCH_TMP;
        truncate table aut_trx_user_authorize;
       drop sequence aut_trx_user_authorize_s;
       create sequence  aut_trx_user_authorize_s;
       
        /*����*/
       
       truncate table fnd_sc_score_result;
       truncate table FND_SC_SCORE;
       truncate table fnd_sc_score_result_dtl;
       drop sequence FND_SC_SCORE_s;
       create sequence FND_SC_SCORE_s;
       drop sequence fnd_sc_score_result_s;
       create sequence fnd_sc_score_result_s;
  drop sequence fnd_sc_score_result_dtl_s;
       create sequence fnd_sc_score_result_dtl_s;

       /*��Ϣ���*/
       truncate table con_contract_change_req_cf;
       drop sequence  con_contract_change_req_cf_s;
       create sequence con_contract_change_req_cf_s;
       truncate table con_contract_change_req_flt;
       /*��ͬ������*/
       truncate table con_contract_change_req;
       truncate table HLS_DOCUMENT_HISTORY;
       truncate table HLS_DOCUMENT_HISTORY_REF;
       drop sequence HLS_DOCUMENT_HISTORY_REF_s;
       create sequence HLS_DOCUMENT_HISTORY_REF_s;

       /*�ʽ�ԤԼ*/
       truncate table tre_funds_reservation;
       drop sequence tre_funds_reservation_s;
       create sequence tre_funds_reservation_s;
       /*�Ʊ�*/
       truncate table rsc_fin_statement_prj_hds;
       drop sequence rsc_fin_statement_prj_hd_s;
       create sequence rsc_fin_statement_prj_hd_s;
       truncate table rsc_fin_statement_prj_lns;
       drop sequence rsc_fin_statement_prj_ln_s;
       create sequence rsc_fin_statement_prj_ln_s;

       /*�������*/
       truncate table TRE_LOAN_CON_REPAYMENT_PLAN;
       drop sequence TRE_LOAN_CON_REPAYMENT_PLAN_s;
       create sequence TRE_LOAN_CON_REPAYMENT_PLAN_s;

       truncate table tre_accrued_interest;
       drop sequence tre_accrued_interest_s;
       create sequence tre_accrued_interest_s;
       truncate table tre_bank_credit_contract;
       truncate table tre_interest_payable;
       drop sequence tre_interest_payable_s;
       create sequence tre_interest_payable_s;
       truncate table tre_loan_con_fin_con;
       drop sequence tre_loan_con_fin_con_s;
       create sequence tre_loan_con_fin_con_s;
       truncate table tre_loan_con_repay_plan_itfc;
       drop sequence tre_loan_con_repay_plan_itfc_s;
       create sequence tre_loan_con_repay_plan_itfc_s;
       truncate table tre_loan_con_withdraw_con;
       drop sequence tre_loan_con_withdraw_con_s;
       create sequence tre_loan_con_withdraw_con_s;
       truncate table tre_loan_con_withdrawal_plan;
       drop sequence tre_loan_con_withdrawal_plan_s;
       create sequence tre_loan_con_withdrawal_plan_s;
       truncate table tre_loan_contract;
       truncate table tre_loan_contract_int_rate;
       drop sequence tre_loan_contract_int_rate_s;
       create sequence tre_loan_contract_int_rate_s;
       truncate table tre_loan_contract_itfc_log;
       drop sequence tre_loan_contract_itfc_log_s;
       create sequence tre_loan_contract_itfc_log_s;
       truncate table tre_loan_contract_itfc;
       drop sequence tre_loan_contract_itfc_s;
       create sequence tre_loan_contract_itfc_s;
       truncate table tre_loan_contract_note_info;
       drop sequence tre_loan_contract_note_info_s;
       create sequence tre_loan_contract_note_info_s;
       truncate table tre_loan_contract_repayment;
       drop sequence tre_loan_contract_repayment_s;
       create sequence tre_loan_contract_repayment_s;
       truncate table tre_loan_finance_analyse;
       drop sequence tre_loan_finance_analyse_s;
       create sequence tre_loan_finance_analyse_s;
       truncate table tre_loan_finance_contract;
       drop sequence tre_loan_finance_contract_s;
       create sequence tre_loan_finance_contract_s;
       truncate table tre_loan_withdraw_flt_rate;
       drop sequence tre_loan_withdraw_flt_rate_s;
       create sequence tre_loan_withdraw_flt_rate_s;

  


       /*�弶����*/
       truncate table RSC_FC_ESTIMATE_RESULT;
       drop sequence RSC_FC_ESTIMATE_RESULT_s;
       create sequence RSC_FC_ESTIMATE_RESULT_s;

       truncate table RSC_FC_ESTIMATE_RESULT_DTL;
       drop sequence RSC_FC_ESTIMATE_RESULT_DTL_S;
       create sequence RSC_FC_ESTIMATE_RESULT_DTL_s;

       truncate table rsc_fc_estimate;
       drop sequence rsc_fc_estimate_S;
       create sequence rsc_fc_estimate_s;

       truncate table con_contract_cashflow_bak;
       drop sequence con_contract_cashflow_bak_s;
       create sequence con_contract_cashflow_bak_s;
       
       --����������
       truncate table PRJ_PROJECT_FAMILY_VISIT;
       drop sequence PRJ_PROJECT_FAMILY_VISIT_S;
       create sequence PRJ_PROJECT_FAMILY_VISIT_S;
       truncate table PRJ_PROJECT_RECORD;
       drop sequence PRJ_PROJECT_RECORD_S;
       create sequence PRJ_PROJECT_RECORD_S;
       truncate table cux_wfl_credit_advice;
       drop sequence cux_wfl_credit_advice_s;
       create sequence cux_wfl_credit_advice_s;
        truncate table cux_wfl_credit_advice_reject;
       drop sequence cux_wfl_credit_advice_reject_s;
       create sequence cux_wfl_credit_advice_reject_s;
       truncate table TEL_REC_FRAUD;
       drop sequence TEL_REC_FRAUD_S;
       create sequence TEL_REC_FRAUD_S;
       --truncate table hls_product_plan_definition;
       --drop sequence hls_product_plan_definition_s;
       --create sequence hls_product_plan_definition_s;
       --truncate table hls_product_plan_to_grant;
       --drop sequence hls_product_plan_to_grant_s;
       --create sequence hls_product_plan_to_grant_s;
       
       --20160529����
       truncate table CON_CONTRACT_LOCATION;
       drop sequence CON_CONTRACT_LOCATION_S;
       create sequence CON_CONTRACT_LOCATION_S;
       truncate table CON_CONTRACT_LOCATION_LN;
       drop sequence CON_CONTRACT_LOCATION_LN_S;
       create sequence CON_CONTRACT_LOCATION_LN_S;
       truncate table CON_EXPRESS_HD;
       drop sequence CON_EXPRESS_HD_S;
       create sequence CON_EXPRESS_HD_S;
       truncate table CON_EXPRESS_LN;
       drop sequence CON_EXPRESS_LN_S;
       create sequence CON_EXPRESS_LN_S;
       truncate table CON_SETTLE_LIST;
       drop sequence CON_SETTLE_LIST_S;
       create sequence CON_SETTLE_LIST_S;
       truncate table DOC_CONTRACT_TMPT_CLAUSE;
       drop sequence DOC_CONTRACT_TMPT_CLAUSE_S;
       create sequence DOC_CONTRACT_TMPT_CLAUSE_S;
       truncate table LEND_CONTENT_LIST;
       drop sequence LEND_CONTENT_LIST_s;
       create sequence LEND_CONTENT_LIST_s;
       
       truncate table AST_CAR_GPS_CARD;
       drop sequence AST_CAR_GPS_CARD_S;
       create sequence AST_CAR_GPS_CARD_S;
  truncate table Ast_Car_Gps_Address;
drop sequence Ast_Car_Gps_Address_s;
create sequence Ast_Car_Gps_Address_s;




/*�ַ����*/
truncate table rd_csh_transaction_batch_tmp;
truncate table rd_ebank_spd_account;
truncate table rd_ebank_spd_account_h;
truncate table rd_ebank_spd_ddaccount;
truncate table rd_ebank_spd_ddaccount_h;
truncate table rd_ebank_spd_process;
truncate table rd_ebank_spd_pub;
truncate table rd_ebank_spd_transaction;
truncate table rd_ebank_spd_trans_com;
truncate table rd_ebank_spd_trans_txds71;
truncate table rd_ebank_spd_trans_txds72;
truncate table rd_ebank_spd_trans_txds73;
truncate table rd_ebank_spd_transaction;
truncate table rd_ebank_spd_txds71_doc;
truncate table gh_ebank_stp_doc;
truncate table gh_ebank_stp_trans_doc;

drop sequence rd_ebank_spd_account_s;
drop sequence rd_ebank_spd_account_h_s;
drop sequence rd_ebank_spd_ddaccount_s;
drop sequence rd_ebank_spd_ddaccount_h_s;
drop sequence rd_ebank_spd_process_s;
drop sequence rd_ebank_spd_pub_s;
drop sequence rd_ebank_spd_transaction_s;
drop sequence gh_ebank_stp_doc_s;
drop sequence gh_ebank_stp_trans_doc_s;

create sequence rd_ebank_spd_account_s;
create sequence rd_ebank_spd_account_h_s;
create sequence rd_ebank_spd_ddaccount_s;
create sequence rd_ebank_spd_ddaccount_h_s;
create sequence rd_ebank_spd_process_s;
create sequence rd_ebank_spd_pub_s;
create sequence rd_ebank_spd_transaction_s;
create sequence gh_ebank_stp_doc_s;
create sequence gh_ebank_stp_trans_doc_s;
/* */

/*������صı�*/
truncate table con_collection;
truncate table con_collection_call_hd;
truncate table con_collection_call_ln;
truncate table con_collection_car_reg;
truncate table con_collection_group;
truncate table con_collection_group_area;
truncate table con_collection_hold;
truncate table con_collection_persons;
truncate table con_collection_persons_area;
truncate table con_collection_tool;
truncate table con_collection_tool_ln;
truncate table con_collection_type;
truncate table con_collection_way;

--drop sequence con_collection_s;
--drop sequence con_collection_call_hd_s;
--drop sequence con_collection_call_ln_s;
--drop sequence con_collection_car_reg_s;
--drop sequence con_collection_group_s;
--drop sequence con_collection_group_area_s;
--drop sequence con_collection_hold_s;
--drop sequence con_collection_persons_s;
--drop sequence con_collection_persons_area_s;
drop sequence con_collection_tool_s;
drop sequence con_collection_tool_ln_s;
drop sequence con_collection_type_s;
drop sequence con_collection_way_s;

create sequence con_collection_s;
create sequence con_collection_call_hd_s;
create sequence con_collection_call_ln_s;
create sequence con_collection_car_reg_s;
create sequence con_collection_group_s;
create sequence con_collection_group_area_s;
create sequence con_collection_hold_s;
create sequence con_collection_persons_s;
create sequence con_collection_persons_area_s;
create sequence con_collection_tool_s;
create sequence con_collection_tool_ln_s;
create sequence con_collection_type_s;
create sequence con_collection_way_s;
/* */

/*��һ����*/
truncate table gh_one_carguidedprice;
truncate table gh_one_carmake;
truncate table gh_one_carmodel;
truncate table gh_one_cartrim;
truncate table gh_onecar_inter;

/*drop sequence gh_one_carguidedprice_s;
drop sequence gh_one_carmake_s;
drop sequence gh_one_carmodel_s;
drop sequence gh_one_cartrim_s;*/
drop sequence gh_onecar_inter_s;

create sequence gh_one_carguidedprice_s;
create sequence gh_one_carmake_s;
create sequence gh_one_carmodel_s;
create sequence gh_one_cartrim_s;
create sequence gh_onecar_inter_s;
/* */

/*NC�ӿ�*/
truncate table gh_nc_inter_request;
truncate table gh_nc_inter_return;

drop sequence gh_nc_inter_request_s;
drop sequence gh_nc_inter_return_s;

create sequence gh_nc_inter_request_s;
create sequence gh_nc_inter_return_s;
/* */
truncate table BASIC_DATA;
drop sequence BASIC_DATA_s;
create sequence BASIC_DATA_s;

/* */
truncate table Sys_Sms_Control;
truncate table Sys_Sms_History;
truncate table Sys_Sms_List;
truncate table Sys_Sms_List_Log;
truncate table Sys_Sms_Server;

drop sequence Sys_Sms_List_s;
drop sequence Sys_Sms_List_Log_s;

create sequence Sys_Sms_List_s;
create sequence Sys_Sms_List_Log_s;

truncate table CON_CONTRACT_DUTY_STATISTICS;

truncate table CON_UNEARNED_TAX_GAB_INCOME;
drop sequence CON_UNEARNED_TAX_GAB_INCOME_S;
create sequence CON_UNEARNED_TAX_GAB_INCOME_S;

truncate table CSH_EBANK;
drop sequence CSH_EBANK_s;
create sequence CSH_EBANK_s;

truncate table CSH_TO_EBANK_AREA;
drop sequence CSH_TO_EBANK_AREA_s;
create sequence CSH_TO_EBANK_AREA_s;

truncate table CFL_WF_APPROVER_INSTANCE;

truncate table CFL_WF_APPROVER_RELATION;
drop sequence CFL_WF_APPROVER_RELATION_S; 
create sequence CFL_WF_APPROVER_RELATION_S; 

truncate table CFL_WFL_APPROVER_GROUP;
drop sequence CFL_WFL_APPROVER_GROUP_s; 
create sequence CFL_WFL_APPROVER_GROUP_s; 

truncate table CON_CONTRACT_ADD_APPLY;
  drop sequence CON_CONTRACT_ADD_APPLY_S;
  create sequence CON_CONTRACT_ADD_APPLY_S;
  
truncate table CON_CONTRACT_CONTENT_HISTORY;
  drop sequence CON_CONTRACT_CONTENT_HISTORY_S;
  create sequence CON_CONTRACT_CONTENT_HISTORY_S;
  
truncate table CON_CONTRACT_ITEM_DETAIL;
drop sequence CON_CONTRACT_ITEM_DETAIL_S;
create sequence CON_CONTRACT_ITEM_DETAIL_S;

truncate table CON_CONTRACT_TMPT_CLAUSE;
drop sequence CON_CONTRACT_TMPT_CLAUSE_S;
create sequence CON_CONTRACT_TMPT_CLAUSE_S;

/*truncate table contract_indicator_rep;
drop sequence contract_indicator_rep_S;
create sequence contract_indicator_rep_S;*/

/*truncate table GLD_COMPANY_ACCOUNTS_REF;
  drop sequence GLD_COMPANY_ACCOUNTS_REF_S;
  create sequence GLD_COMPANY_ACCOUNTS_REF_S;*/
  
truncate table HLS_BP_MASTER_CREDIT_LIMIT; 
  drop sequence HLS_BP_MASTER_CREDIT_LIMIT_S;
  create sequence HLS_BP_MASTER_CREDIT_LIMIT_S;

truncate table   HLS_CAR_ORGANIZATION;
  drop sequence HLS_CAR_ORGANIZATION_S;
  create sequence HLS_CAR_ORGANIZATION_S;

truncate table HLS_DOC_FILE_CONTENT;
  drop sequence HLS_DOC_FILE_CONTENT_S;
  create sequence HLS_DOC_FILE_CONTENT_S; 

truncate table HLS_DOCUMENT_FUNCTION;
   drop sequence HLS_DOCUMENT_FUNCTION_S;
  create sequence HLS_DOCUMENT_FUNCTION_S; 
  
/*truncate table HLS_DOCUMENT_NODE_BRANCH;
    drop sequence HLS_DOCUMENT_NODE_BRANCH_S;
  create sequence HLS_DOCUMENT_NODE_BRANCH_S; */
  
truncate table PRJ_ACT_CTRLER_ASSET;
  drop sequence PRJ_ACT_CTRLER_ASSET_S;
  create sequence PRJ_ACT_CTRLER_ASSET_S;
  
truncate table PRJ_BP_RELATION_ENTERPRISE;
   drop sequence PRJ_BP_RELATION_ENTERPRISE_S;
  create sequence PRJ_BP_RELATION_ENTERPRISE_S; 
  
truncate table PRJ_RELATION_WITH_TENANT;
   drop sequence PRJ_RELATION_WITH_TENANT_S;
  create sequence PRJ_RELATION_WITH_TENANT_S; 

truncate table YONDA_4S_AREA_DIRECTOR;
  drop sequence YONDA_4S_AREA_DIRECTOR_S;
  create sequence YONDA_4S_AREA_DIRECTOR_S;

  truncate table prj_quotation_cashflow;
   drop sequence prj_quotation_cashflow_s;
  create sequence prj_quotation_cashflow_s;