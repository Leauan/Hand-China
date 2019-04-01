WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool INITIALIZE_SYSCODE_CON_BORROW_STATUS.log

set feedback off
set define off

begin
	
  sys_code_pkg.delete_sys_code(p_code => 'CON_BORROW_STATUS');
	
  --合同文本借阅状态
  sys_code_pkg.insert_sys_code(p_code             => 'CON_BORROW_STATUS',
                               p_code_name        => '合同文本借阅状态',
                               p_code_prompt      => '合同文本借阅状态',
                               p_code_name_prompt => '合同文本借阅状态',
                               p_language_code    => 'ZHS',
                               p_function_code    => '');
        
  --合同文本借阅状态值                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'NOT_LEND',
                                     p_code_value_name => '未借出',
                                     p_language_code   => 'ZHS',
                                     p_function_code   => '');
                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'NEW',
                                     p_code_value_name => '已创建借阅单',
                                     p_language_code   => 'ZHS',
                                     p_function_code   => '');
                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'APPROVING',
                                     p_code_value_name => '借阅单审批中',
                                     p_language_code   => 'ZHS',
                                     p_enabled_flag	   => 'N',
                                     p_function_code   => ''); 
                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'REJECT',
                                     p_code_value_name => '借阅单被拒绝',
                                     p_language_code   => 'ZHS',
                                     p_enabled_flag	   => 'N',
                                     p_function_code   => ''); 
                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'APPROVED',
                                     p_code_value_name => '已借出',
                                     p_language_code   => 'ZHS',
                                     p_enabled_flag	   => 'N',
                                     p_function_code   => ''); 
                                     
  sys_code_pkg.insert_sys_code_value(p_code            => 'CON_BORROW_STATUS',
                                     p_code_value      => 'RETURNED',
                                     p_code_value_name => '已归还',
                                     p_language_code   => 'ZHS',
                                     p_function_code   => '');  
end;
/
commit;
set feedback on
set define on


spool off

exit
