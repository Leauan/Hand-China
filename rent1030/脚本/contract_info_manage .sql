begin
--清除function-service关系和function-bm关系
--sys_function_assign_pkg.func_clear('func_code');

--页面注册(页面路径，页面名称，三个权限)
sys_function_assign_pkg.service_load('modules/hls_rent/RENT500/Create_contract.screen','租房合同新增',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT500/modification.screen','租房合同修改',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT500/search_contract.screen','租房合同',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT500/Search_detial.screen','租房合同详情',0,0,0);

--功能定义
sys_function_assign_pkg.func_load('RENT5001','租房合同新增与维护','','F','modules/hls_rent/RENT500/search_contract.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT5001','租房合同新增与维护','','F','modules/hls_rent/RENT500/search_contract.screen','1','US');

--功能分配角色
--sys_function_assign_pkg.role_func_load('role_code','func_code');

--分配页面
sys_function_assign_pkg.func_service_load('RENT5001','modules/hls_rent/RENT500/Create_contract.screen');
sys_function_assign_pkg.func_service_load('RENT5001','modules/hls_rent/RENT500/modification.screen');
sys_function_assign_pkg.func_service_load('RENT5001','modules/hls_rent/RENT500/search_contract.screen');
sys_function_assign_pkg.func_service_load('RENT5001','modules/hls_rent/RENT500/Search_detial.screen');

--分配bm, bm位置：WEB-INF/classes/
sys_function_assign_pkg.func_bm_load('RENT5001','hls_rent.RENT500.HLS_Contract_info');
sys_function_assign_pkg.func_bm_load('RENT5001','hls_rent.RENT500.HLS_room_contract_info');
sys_function_assign_pkg.func_bm_load('RENT5001','hls_rent.RENT500.HLS_room_info');
sys_function_assign_pkg.func_bm_load('RENT5001','hls_rent.RENT500.modification_contract');
sys_function_assign_pkg.func_bm_load('RENT5001','hls_rent.RENT500.contract_condition');

--菜单定义，参数：p_function_group_code菜单code
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT5000',p_function_code=>'RENT5001',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;

--注意：最后再更新一下缓存
/
commit;