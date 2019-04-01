
begin

--页面注册
sys_function_assign_pkg.service_load('modules/csh/CSH763/factoring_management_fee_state.screen','管理费查询',1,1,0);
--功能定义
sys_function_assign_pkg.func_load('CSH763','管理费查询','','F','modules/csh/CSH763/factoring_management_fee_state.screen','1','ZHS');
sys_function_assign_pkg.func_load('CSH763','管理费查询','','F','modules/csh/CSH763/factoring_management_fee_state.screen','1','US');
--分配页面
sys_function_assign_pkg.func_service_load('CSH763','modules/csh/CSH763/factoring_management_fee_state.screen');
--分配菜单
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'DF_REPORT',p_function_code=>'CSH763',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;
/
commit;

