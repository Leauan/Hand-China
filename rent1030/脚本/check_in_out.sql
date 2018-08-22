begin
--清除function-service关系和function-bm关系
--sys_function_assign_pkg.func_clear('func_code');

--页面注册(页面路径，页面名称，三个权限)
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/checkin1.screen','新人员入住',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/checkin2.screen','入住详情',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/checkout.screen','人员退房',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/checkin_save.svc','人员入住SVC',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/contract_detial.screen','合同详情',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT400/checkout_save.svc','人员退房SVC',0,0,0);


--功能定义
sys_function_assign_pkg.func_load('RENT4001','新人员入住','','F','modules/hls_rent/RENT400/checkin1.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT4001','新人员入住','','F','modules/hls_rent/RENT400/checkin1.screen','1','US');
sys_function_assign_pkg.func_load('RENT4002','人员退房','','F','modules/hls_rent/RENT400/checkout.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT4002','人员退房','','F','modules/hls_rent/RENT400/checkout.screen','1','US');

--功能分配角色
--sys_function_assign_pkg.role_func_load('role_code','func_code');

--分配页面
sys_function_assign_pkg.func_service_load('RENT4001','modules/hls_rent/RENT400/checkin1.screen');
sys_function_assign_pkg.func_service_load('RENT4001','modules/hls_rent/RENT400/checkin2.screen');
sys_function_assign_pkg.func_service_load('RENT4002','modules/hls_rent/RENT400/checkout.screen');
sys_function_assign_pkg.func_service_load('RENT4002','modules/hls_rent/RENT400/contract_detial.screen');

--分配bm, bm位置：WEB-INF/classes/
sys_function_assign_pkg.func_bm_load('RENT4001','hls_rent.RENT400.checkin_save');
sys_function_assign_pkg.func_bm_load('RENT4001','hls_rent.RENT500.HLS_room_contract_info');
sys_function_assign_pkg.func_bm_load('RENT4001','hls_rent.RENT400.hls_hsm_info');
sys_function_assign_pkg.func_bm_load('RENT4001','hls_rent.RENT400.HLS_checkedIn_people_info');

sys_function_assign_pkg.func_bm_load('RENT4002','hls_rent.RENT400.checkout');
sys_function_assign_pkg.func_bm_load('RENT4002','hls_rent.RENT400.check_out_save');

--菜单定义，参数：p_function_group_code菜单code
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT4000',p_function_code=>'RENT4001',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT4000',p_function_code=>'RENT4002',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;

--注意：最后再更新一下缓存
/
commit;