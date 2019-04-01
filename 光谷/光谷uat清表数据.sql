

----- 权限表 单据权限(视情况使用)
------truncate table aut_trx_user_authorize;

-----权限表  分配权限(视情况使用)
------truncate table aut_owner_user_authorize;

------AUT_AUTHORITY_OLD_MV  AUT_AUTHORITY_MV drop后重新编辑

/*后台操作日志表*/
truncate table sys_raise_app_errors;
truncate table hls_sys_log;
truncate table SYS_RUNTIME_REQUEST_DETAIL;
truncate table sys_runtime_request_record;
truncate table sys_runtime_exception_log;
truncate table sys_runtime_req_url_detail;
truncate table SYS_RUNTIME_REQ_REC_ARCHIVE;
truncate table SYS_RUNTIME_EXP_LOG_ARCHIVE;
truncate table SYS_RUNTIME_REQ_TOP_TIMEUSE;
truncate table SYS_RUNTIME_REQ_TOP_USE;


drop sequence SYS_RUNTIME_REQ_TOP_USE_s;
create sequence SYS_RUNTIME_REQ_TOP_USE_s;
drop sequence SYS_RUNTIME_REQ_TOP_TIMEUSE_s;
create sequence SYS_RUNTIME_REQ_TOP_TIMEUSE_s;
drop sequence sys_runtime_req_url_detail_s;
create sequence sys_runtime_req_url_detail_s;



-----app提交人推送表 *********
truncate table FND_REGULATORY_FRAMEWORK;
DROP SEQUENCE jpush_submit_record_s;
create sequence jpush_submit_record_s;
----版本表
truncate table hls_app_version; 
 truncate table GF_WFL_WORKFLOW_APP_LOG;

truncate table HLS_LEASE_ITEM;


truncate table  TRE_LOAN_CONTRACT_CHANGE;
truncate table  TRE_LOAN_CONTRACT_WITHDRAW ;
truncate table  TRE_LOAN_CON_BATCH_INTERFACE ;
truncate table  TRE_LOAN_CON_REPAYMENT_DTL ;
truncate table  TRE_LOAN_CON_WRITE_OFF ;
truncate table  TRE_LOAN_CON_WRITE_OFF_ITFC;
truncate table  TRE_LOAN_REPAYMENT_JE_ITFC;


truncate table TRE_LOAN_CON_CHANGE_REQ_FLT;
truncate table HLS_DOCUMENT_TRANSFER_LOG;
truncate table SDIC_LOAN_CON_RATE_REC_TMP;


truncate table con_flt_int_rate_req_batch;
drop sequence con_flt_int_rate_req_batch_s;
create sequence con_flt_int_rate_req_batch_s;


 
 truncate table csh_transaction_source;
 
 truncate table PRJ_PROJECT_LEASE_ITEM_INF;
drop sequence PRJ_PROJECT_LEASE_ITEM_INF_S;
create sequence PRJ_PROJECT_LEASE_ITEM_INF_S;

 
truncate table  con_batch_adjust_interest_ln;
drop sequence con_batch_adjust_interest_ln_s;
create sequence  con_batch_adjust_interest_ln_s;
truncate table con_batch_adjust_interest_hd;


truncate table prj_project_approval;
truncate table prj_project_approver;

truncate table CON_CONTRACT_SPLIT_HD;
truncate table con_contract_split_ln;
truncate table con_split_log;

drop sequence con_contract_split_hd_s;
create sequence con_contract_split_hd_s;
drop sequence con_contract_split_ln_s;
create sequence con_contract_split_ln_s;



/*关键功能操作记录删除*/
truncate table hls_doc_operate_history;
drop sequence hls_doc_operate_history_s;
create sequence hls_doc_operate_history_s;
/*单据序列*/
drop sequence hls_document_s;
create sequence hls_document_s;




 
/*关联项目（租赁申请单）*/

truncate table prj_project;
truncate table prj_project_bp;
truncate table prj_project_risk;
truncate table prj_project_mortgage;
truncate table prj_project_meeting;
truncate table prj_project_lease_item;

drop sequence prj_project_bp_s;
create sequence prj_project_bp_s;
drop sequence prj_project_lease_item_s;
create sequence prj_project_lease_item_s;
drop sequence PRJ_PROJECT_MORTGAGE_s;
create sequence PRJ_PROJECT_MORTGAGE_s;
drop sequence prj_project_risk_s;
create sequence prj_project_risk_s;
drop sequence prj_project_meeting_s;
create sequence prj_project_meeting_s;


/*关联到租金计算*/
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




--关联到cdd_list_iterm
truncate table prj_cdd_item;
truncate table prj_cdd_item_doc_ref;
truncate table prj_cdd_item_check;

drop sequence prj_cdd_item_s;
create sequence prj_cdd_item_s;

drop sequence prj_cdd_item_doc_ref_s;
create sequence prj_cdd_item_doc_ref_s;

drop sequence prj_cdd_item_check_s;
create sequence prj_cdd_item_check_s;




/*关联商机*/
truncate table prj_chance;
truncate table prj_chance_contact_info;
truncate table PRJ_CHANCE_CONTACT_INFO;
truncate table PRJ_CHANCE_LEASE_ITEM;
 





/*工作流相关*/
truncate table zj_wfl_workflow_instance;
truncate table zj_wfl_workflow_instance_para;
truncate table zj_wfl_approve_record;
truncate table zj_wfl_instance_log;
truncate table zj_wfl_instance_node_hierarchy;
truncate table zj_wfl_instance_node_history;
truncate table zj_wfl_instance_node_rcpt_ht;
truncate table zj_wfl_instance_node_recipient;
truncate table zj_wfl_instance_node_hirc_ht;
truncate table ZJ_SYS_NOTIFY_LOGS;

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



/*合同相关表*/ 
truncate table con_contract;  ------droplast
truncate table con_contract_bp;
truncate table con_contract_billing_method;
truncate table con_contract_cashflow;
truncate table con_contract_cf_item;
truncate table con_contract_change_req;
truncate table con_contract_change_req_cf;
truncate table con_contract_change_req_flt;
truncate table con_contract_et_hd;
truncate table con_contract_et_ln;
truncate table con_contract_insurance;
truncate table con_contract_je;
truncate table con_contract_lease_item;
truncate table con_contract_zero_bc;
truncate table con_finance_income;
truncate table con_unearned_finance_income;
truncate table con_contract_content;
truncate table CON_CONTRACT_MORTGAGE;


drop sequence CON_CONTRACT_MORTGAGE_s;
create sequence CON_CONTRACT_MORTGAGE_s;
drop sequence con_contract_bp_s;
create sequence con_contract_bp_s;

truncate table  CON_DEBT_EXEMPTION_REQ_CF;

drop sequence con_contract_change_req_cf_s;
create sequence con_contract_change_req_cf_s;
drop sequence HLS_DOCUMENT_LN_S;
create sequence HLS_DOCUMENT_LN_S;


drop sequence con_contract_insurance_s;
create sequence con_contract_insurance_s;
drop sequence con_contract_lease_item_s;
create sequence con_contract_lease_item_s;
drop sequence con_contract_zero_bc_s;
create sequence con_contract_zero_bc_s;
drop sequence con_finance_income_s;
create sequence con_finance_income_s;
drop sequence con_unearned_finance_income_s;
create sequence con_unearned_finance_income_s;
drop sequence con_contract_content_s;
create sequence con_contract_content_s;



-----  租后模块
truncate table bp_polling_report;   ------droplast
truncate table hls_bp_master_polling_hd;    ------droplast
truncate table ast_asset_process;
truncate table con_lease_mor_inspection;
truncate table con_polling_report;
truncate table law_cdd_item;
truncate table polling_debt_with_interest;
truncate table hls_bp_master_polling;
truncate table bp_polling_report_visit;
truncate table bp_polling_report_measure;


drop sequence ast_asset_process_s;
drop sequence bp_polling_report_s;
drop sequence con_lease_mor_inspection_s;
drop sequence con_polling_report_s;
drop sequence hls_bp_master_polling_hd_s;
drop sequence law_cdd_item_s;
drop sequence polling_debt_with_interest_s;
drop sequence hls_bp_master_polling_s;
drop sequence bp_polling_report_visit_s;
drop sequence bp_polling_report_measure_s;

create sequence ast_asset_process_s;
create sequence bp_polling_report_s;
create sequence con_lease_mor_inspection_s;
create sequence con_polling_report_s;
create sequence hls_bp_master_polling_hd_s;
create sequence law_cdd_item_s;
create sequence polling_debt_with_interest_s;
create sequence hls_bp_master_polling_s;
create sequence bp_polling_report_visit_s;
create sequence bp_polling_report_measure_s;



/*rsc相关*/
truncate table rsc_credit_line;
truncate table rsc_credit_doc_status;
drop sequence rsc_credit_doc_status_s;
create sequence rsc_credit_doc_status_s;
truncate table RSC_FIN_STATEMENT_PRJ_LOGS;





/*导入临时表*/
truncate table fnd_interface_headers;
truncate table fnd_interface_lines;
truncate table fnd_interface_log;
drop sequence fnd_interface_headers_s;
create sequence fnd_interface_headers_s;
drop sequence fnd_interface_lines_s;
create sequence fnd_interface_lines_s;
drop sequence fnd_interface_log_s;
create sequence fnd_interface_log_s;




/*附件表*/
truncate table fnd_atm_attachment;
truncate table fnd_atm_attachment_multi;

drop sequence fnd_atm_attachment_s;
create sequence fnd_atm_attachment_s;

drop sequence fnd_atm_attachment_multi_s;
create sequence fnd_atm_attachment_multi_s;



/*相关事务表*/
truncate table csh_transaction;

truncate table csh_write_off;



drop sequence csh_write_off_s;
create sequence csh_write_off_s;



/*
  应收发票
*/

truncate table  acr_invoice_hd;
truncate table acr_invoice_ln;




/*付款*/
truncate table csh_payment_req_hd;
truncate table csh_payment_req_ln;



/*凭证相关*/

truncate table hls_journal_header;
truncate table hls_journal_detail;
truncate table gld_je_history;

drop sequence hls_journal_header_s;
create sequence hls_journal_header_s;
drop sequence hls_journal_detail_s;
create sequence hls_journal_detail_s;



/*用户登陆记录表*/
truncate table SYS_USER_LOGINS;
drop sequence SYS_USER_LOGINS_s;
create sequence SYS_USER_LOGINS_s;



/*事件与错误日志*/
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

truncate table HLS_DOCUMENT_HISTORY;

truncate table HLS_DOCUMENT_HISTORY_REF;
drop sequence HLS_DOCUMENT_HISTORY_REF_s;
create sequence HLS_DOCUMENT_HISTORY_REF_s;




/*job相关*/

delete from sch_concurrent_job jo where jo.job_id !=0;
truncate table  sch_concurrent_job_log;



/*临时表*/
truncate table FND_AGING_RESULT_LN_TMP;
truncate table FND_AGING_RESULT_HD_TMP;
truncate table SYS_CONDITION_MATCHING;
drop sequence SYS_CONDITION_MATCHING_s;
create sequence SYS_CONDITION_MATCHING_s;



/*LSH项目新增部分*/
truncate table prj_project_report;
truncate table prj_project_report_bp;
truncate table prj_report_bp_asset;
truncate table prj_report_bp_cashflow;
truncate table prj_report_bp_credict;
truncate table prj_report_bp_links;
truncate table prj_report_bp_loan;
truncate table prj_report_bp_manager;
truncate table prj_report_bp_pepurchas;
truncate table prj_report_bp_statement;
truncate table prj_report_bp_statement_line;
truncate table prj_report_bp_statement_rcd;
truncate table prj_report_bp_stock;
truncate table PRJ_PROJECT_LEASE_ITEM_INF;
drop sequence PRJ_PROJECT_LEASE_ITEM_INF_s;
create sequence PRJ_PROJECT_LEASE_ITEM_INF_s;



/**/
truncate table csh_transaction_interface;
truncate table csh_transaction_interface_log;
truncate table csh_trx_batch_interface;
truncate table csh_write_off_interface;
drop sequence csh_write_off_interface_s;
create sequence csh_write_off_interface_s;
drop sequence csh_transaction_interface_s;
create sequence csh_transaction_interface_s;


/*商业伙伴*/

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
drop sequence hls_bp_master_company_s;
create sequence hls_bp_master_company_s;
drop sequence hls_bp_master_contact_info_s;
create sequence hls_bp_master_contact_info_s;
drop sequence hls_bp_master_role_s;
create sequence hls_bp_master_role_s;

truncate table hls_standard_history;
drop sequence hls_standard_history_s;
create sequence hls_standard_history_s;

update fnd_coding_rule_values fc
  set fc.current_value =1;
drop sequence RSC_FIN_STATEMENT_PRJ_LNS_s;
create sequence RSC_FIN_STATEMENT_PRJ_LNS_s;
truncate table RSC_FIN_STATEMENT_PRJ_TMP;
truncate table RSC_FIN_STATEMENT_PRJ_LNS;
truncate table SYS_CONDITION_DETAIL;

truncate table GLD_MAPPING_CONDITIONS;
drop sequence GLD_MAPPING_CONDITIONS_s;
create sequence GLD_MAPPING_CONDITIONS_s;

truncate table HLS_FINANCIAL_CALC_LOGS;
truncate table SYS_SESSION;
drop sequence SYS_SESSION_s;
create sequence SYS_SESSION_s;

truncate table PRJ_PROJECT_APPROVAL;
drop sequence PRJ_PROJECT_APPROVAL_s;
create sequence PRJ_PROJECT_APPROVAL_s;



--清理银行接口
truncate table HLS_EBANK_INTERFACE;
drop sequence HLS_EBANK_INTERFACE_s;
create sequence HLS_EBANK_INTERFACE_s;
truncate table HLS_EBANK_XML_VLAUES; 

truncate table RSC_FIN_ST_TMPLT_LNS1201;
truncate table  SYS_NOTICE_MSG;


truncate table GLD_JE_TEMPLATE_LOGS;
drop sequence gld_je_template_logs_s;
create sequence gld_je_template_logs_s;



truncate table HLS_LAYOUT_BATCH_UPDATE_TMP;




/*清理应收应付发票*/
truncate table ACP_INVOICE_HD;
truncate table ACP_INVOICE_LN;

drop sequence ACP_INVOICE_HD_s;
drop sequence ACP_INVOICE_LN_s;
create sequence ACP_INVOICE_HD_s;
create sequence ACP_INVOICE_LN_s;

truncate table ACR_INVOICE_CREATE_TMP;
drop sequence ACR_INVOICE_CREATE_TMP_s;
create sequence ACR_INVOICE_CREATE_TMP_s;
truncate table ACR_INVOICE_LOCATION;



--清理
truncate table CON_CONTRACT_CONTENT_FILE;
drop sequence CON_CONTRACT_CONTENT_FILE_s;
create sequence CON_CONTRACT_CONTENT_FILE_s;
truncate table CON_CONTRACT_CONTENT_ASSET;
truncate table CON_CONTRACT_ITEM_DETAIL;

truncate table CON_CONTRACT_LAW;
drop sequence CON_CONTRACT_LAW_s;
create sequence CON_CONTRACT_LAW_s;

truncate table CON_CONTRACT_LAW_DEVELOP;


truncate table CON_CONTRACT_LOCATION;
drop sequence CON_CONTRACT_LOCATION_s;
create sequence CON_CONTRACT_LOCATION_s;

truncate table CON_CONTRACT_NOTARIZE;

truncate table CON_CONTRACT_PAYMENT_TERMS;
drop sequence CON_CONTRACT_PAYMENT_TERMS_s;
create sequence CON_CONTRACT_PAYMENT_TERMS_s;

truncate table CON_CONTRACT_PAYMENT_T_CHECK;
drop sequence CON_CONTRACT_PAYMENT_T_CHECK_s;
create sequence CON_CONTRACT_PAYMENT_T_CHECK_s;

truncate table CON_CONTRACT_REPURCHASE_REQ;
drop sequence CON_CONTRACT_REPURCHASE_REQ_s;
create sequence CON_CONTRACT_REPURCHASE_REQ_s;

truncate table CON_CONTRACT_REVIEW;
drop sequence CON_CONTRACT_REVIEW_s;
create sequence CON_CONTRACT_REVIEW_s;




truncate table CON_CONTRACT_TERMINATE;
drop sequence CON_CONTRACT_TERMINATE_s;
create sequence CON_CONTRACT_TERMINATE_s;


truncate table  CON_DEBT_EXEMPTION_REQ;

truncate table CON_DOC_BORROWING_APP_HD;
drop sequence CON_DOC_BORROWING_APP_HD_s;
create sequence CON_DOC_BORROWING_APP_HD_s;

truncate table CON_DOC_BORROWING_APP_LN;
drop sequence CON_DOC_BORROWING_APP_LN_s;
create sequence CON_DOC_BORROWING_APP_LN_s;

truncate table CON_DOC_BRW_APP_RENEW;
drop sequence CON_DOC_BRW_APP_RENEW_s;
create sequence CON_DOC_BRW_APP_RENEW_s;

truncate table CON_DUNNING_LETTER;
drop sequence CON_DUNNING_LETTER_s;
create sequence CON_DUNNING_LETTER_s;

truncate table CON_DUN_RECORD;
drop sequence CON_DUN_RECORD_s;
create sequence CON_DUN_RECORD_s;

truncate table CON_FLOATING_INTEREST_RATE_LOG;


truncate table CON_OVERDUE_PENALTY_RPT_HD;
drop sequence CON_OVERDUE_PENALTY_RPT_HD_s;
create sequence CON_OVERDUE_PENALTY_RPT_HD_s;

truncate table CON_OVERDUE_PENALTY_RPT_LN;
drop sequence CON_OVERDUE_PENALTY_RPT_LN_s;
create sequence CON_OVERDUE_PENALTY_RPT_LN_s;

truncate table CON_VISIT_REPORT_HDS;


truncate table CSH_PAYMENT_REQ_LN_DDCT;


truncate table CSH_PAYMENT_REQ_LN_PREPAY;

truncate table CSH_PAYMENT_REQ_TMP;


truncate table LEG_LEGAL_COST_CON;
drop sequence LEG_LEGAL_COST_CON_s;
create sequence LEG_LEGAL_COST_CON_s;


truncate table LEG_LEGAL_FEE;
drop sequence LEG_LEGAL_FEE_s;
create sequence LEG_LEGAL_FEE_s;
truncate table LEG_LEGAL_FEE_INTERFACE;
truncate table LEG_LEGAL_LETTER;
drop sequence LEG_LEGAL_LETTER_s;
create sequence LEG_LEGAL_LETTER_s;
truncate table LEG_LITIGATION_INF;
drop sequence LEG_LITIGATION_INF_s;
create sequence LEG_LITIGATION_INF_s;



--保险和诉讼相关
drop sequence INS_COM_MASTER_s;
create sequence INS_COM_MASTER_s;


truncate table INS_INSURANCE_POLICY;
drop sequence INS_INSURANCE_POLICY_s;
create sequence INS_INSURANCE_POLICY_s;

truncate table LEG_COMPULSORY_EXECUTION_INF;
drop sequence LEG_COMPULSORY_EXECUTION_INF_s;
create sequence LEG_COMPULSORY_EXECUTION_INF_s;
truncate table LEG_COMPULSORY_EXEC_IMP_CON;
drop sequence LEG_COMPULSORY_EXEC_IMP_CON_s;
create sequence LEG_COMPULSORY_EXEC_IMP_CON_s;
truncate table LEG_COMPULSORY_EXEC_IMP_LITI;
drop sequence LEG_COMPULSORY_EXEC_IMP_LITI_s;
create sequence LEG_COMPULSORY_EXEC_IMP_LITI_s;

truncate table LEG_EXTERNAL_AGENCY;
drop sequence LEG_EXTERNAL_AGENCY_s;
create sequence LEG_EXTERNAL_AGENCY_s;

truncate table LEG_LEGAL_CONTENT;
drop sequence LEG_LEGAL_CONTENT_s;
create sequence LEG_LEGAL_CONTENT_s;


truncate table PRJ_PROJECT_ACT_CTRLER_HD;
drop sequence PRJ_PROJECT_ACT_CTRLER_HD_s;
create sequence PRJ_PROJECT_ACT_CTRLER_HD_s;

truncate table PRJ_PROJECT_APPROVER;
drop sequence PRJ_PROJECT_APPROVER_s;
create sequence PRJ_PROJECT_APPROVER_s;

truncate table PRJ_PROJECT_CONTENT;


truncate table PRJ_PROJECT_ESTIMATE;
drop sequence PRJ_PROJECT_ESTIMATE_s;
create sequence PRJ_PROJECT_ESTIMATE_s;

truncate table PRJ_PROJECT_LEASE_ITEM_LIST;

truncate table PRJ_PROJECT_LEASE_ITEM_LOG;
truncate table PRJ_PROJECT_LEASE_ITEM_TEMP;
truncate table PRJ_PROJECT_LI_LIST_TEMP;
truncate table PRJ_QUOTATION_SPLIT;
drop sequence PRJ_QUOTATION_SPLIT_s;
create sequence PRJ_QUOTATION_SPLIT_s;

truncate table PRJ_REPORT_BP_PEPURCHASE;
drop sequence PRJ_REPORT_BP_PEPURCHASE_s;
create sequence PRJ_REPORT_BP_PEPURCHASE_s;

truncate table PRJ_WFL_CALCULATOR_HD;

truncate table GLD_BALANCES;
truncate table gld_detail_balances;

truncate table  zj_sys_mailing_list;
truncate table zj_sys_mailing_list_ht;
truncate table ZJ_SYS_NOTIFY_RECORD;

truncate table sys_sms_list;
truncate table sys_sms_history;

truncate  table tre_funds_reservation;
drop sequence tre_funds_reservation_s;
create sequence tre_funds_reservation_s;


truncate  table TRE_BANK_CREDIT_CONTRACT;

truncate  table tre_loan_contract;


truncate  table bgfl_tre_factoring_contract;
drop sequence bgfl_tre_factoring_contract_s;
create sequence bgfl_tre_factoring_contract_s;

truncate  table tre_loan_con_withdrawal_plan;
drop sequence tre_loan_con_withdrawal_plan_s;
create sequence tre_loan_con_withdrawal_plan_s;

truncate table tre_loan_con_repayment_plan;
drop sequence tre_loan_con_repayment_plan_s;
create sequence tre_loan_con_repayment_plan_s;

truncate  table tre_loan_con_change_req_cf;
drop sequence tre_loan_con_change_req_cf_s;
create sequence tre_loan_con_change_req_cf_s;

truncate  table CON_BATCH_ADJUST_INTEREST_HD;
drop sequence CON_BATCH_ADJUST_INTEREST_HD_S;
create sequence CON_BATCH_ADJUST_INTEREST_HD_S;

drop materialized view log on aut_trx_user_authorize;   
drop materialized view log on aut_owner_user_authorize;   
CREATE MATERIALIZED VIEW LOG ON aut_trx_user_authorize WITH rowid INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON aut_owner_user_authorize WITH rowid INCLUDING NEW VALUES;
    
drop MATERIALIZED VIEW AUT_AUTHORITY_OLD_MV  ;
CREATE MATERIALIZED VIEW AUT_AUTHORITY_OLD_MV
REFRESH FORCE ON COMMIT
AS
SELECT a1.trx_category,
       a1.trx_id,
       a1.user_id,
       a2.owner_user_id,
       a2.authorized_user_id,
       a1.rowid trx_user_rowid,
       a2.rowid owner_user_rowid,
       a1.start_date trx_user_start_date,
       a1.end_date trx_user_end_date,
       a2.start_date owner_user_start_date,
       a2.end_date owner_user_end_date
  FROM aut_trx_user_authorize   a1,
       aut_owner_user_authorize a2
 WHERE a1.user_id = a2.owner_user_id
   AND a1.trx_category = a2.trx_category
   --AND nvl(a1.ref_v01,'Y') = 'Y';



