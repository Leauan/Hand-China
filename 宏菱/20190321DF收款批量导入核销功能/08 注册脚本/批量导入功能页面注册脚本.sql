--脚本记录

BEGIN
  -- 页面注册
  sys_function_assign_pkg.service_load('modules/csh/CSH511/csh_receipt_batch_import_save.svc','DF批量收款导入SVC',1,1,0);
  sys_function_assign_pkg.service_load('modules/csh/CSH511/csh_receipt_batch_import_trans_upload.screen','DF批量收款导入',1,1,0);
  sys_function_assign_pkg.service_load('modules/csh/CSH511/csh_transaction_receipt_batch_impiort.screen','DF批量收款导入',1,1,0);
  sys_function_assign_pkg.service_load('modules/csh/CSH511/csh_transaction_receipt_batch_import_upload.screen','DF批量收款导入',1,1,0);
  sys_function_assign_pkg.service_load('modules/csh/CSH511/csh_transaction_receipt_batch_import_show_error.screen','DF批量导入错误数据',1,1,0);


-- 分配页面
  sys_function_assign_pkg.func_service_load('CSH511','modules/csh/CSH511/csh_receipt_batch_import_save.svc');
  sys_function_assign_pkg.func_service_load('CSH511','modules/csh/CSH511/csh_receipt_batch_import_trans_upload.screen');
  sys_function_assign_pkg.func_service_load('CSH511','modules/csh/CSH511/csh_transaction_receipt_batch_impiort.screen');
  sys_function_assign_pkg.func_service_load('CSH511','modules/csh/CSH511/csh_transaction_receipt_batch_import_upload.screen');
  sys_function_assign_pkg.func_service_load('CSH511','modules/csh/CSH511/csh_transaction_receipt_batch_import_show_error.screen');
-- 分配功能号
  sys_function_assign_pkg.func_bm_load('CSH511', 'csh.CSH511.csh_fee_type');
  sys_function_assign_pkg.func_bm_load('CSH510', 'csh.CSH511.csh_fee_type');
  sys_function_assign_pkg.func_bm_load('CSH511','csh.CSH511.csh_transaction_batch_temp_logs');
  sys_function_assign_pkg.func_bm_load('CSH511', 'csh.CSH511.csh_transaction_batch_temp');
  sys_function_assign_pkg.func_bm_load('CSH511', 'csh.CSH511.csh_transaction_receipt_batch_import_batch_id');
  sys_function_assign_pkg.func_bm_load('CSH511', 'csh.CSH511.save_batch_data');
  
  
  
END;
