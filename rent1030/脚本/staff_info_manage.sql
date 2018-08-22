begin
--清除function-service关系和function-bm关系
--sys_function_assign_pkg.func_clear('func_code');

--页面注册(页面路径，页面名称，三个权限)
sys_function_assign_pkg.service_load('modules/hls_rent/RENT200/hls_hrms_hsm1.screen','入住人员信息新增与维护',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT200/hls_hrms_hsm2.screen','入住人员信息查询',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT200/hls_hrms_hsm_staff_info.screen','入住人员信息查看',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT200/hls_hrms_hsm_staff_info_alter.screen','入住人员信息修改',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT200/hls_hrms_hsm_staff_info_editor.screen','入住人员信息新增',0,0,0);


--功能定义
sys_function_assign_pkg.func_load('RENT2001','入住人员信息新增与维护','','F','modules/hls_rent/RENT200/hls_hrms_hsm1.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT2001','入住人员信息新增与维护','','F','modules/hls_rent/RENT200/hls_hrms_hsm1.screen','1','US');
sys_function_assign_pkg.func_load('RENT2002','入住人员信息查询','','F','modules/hls_rent/RENT200/hls_hrms_hsm2.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT2002','入住人员信息查询','','F','modules/hls_rent/RENT200/hls_hrms_hsm2.screen','1','US');

--功能分配角色
--sys_function_assign_pkg.role_func_load('role_code','func_code');

--分配页面
sys_function_assign_pkg.func_service_load('RENT2001','modules/hls_rent/RENT200/hls_hrms_hsm1.screen');
sys_function_assign_pkg.func_service_load('RENT2001','modules/hls_rent/RENT200/hls_hrms_hsm_staff_info_editor.screen');
sys_function_assign_pkg.func_service_load('RENT2001','modules/hls_rent/RENT200/hls_hrms_hsm_staff_info_alter.screen');
sys_function_assign_pkg.func_service_load('RENT2002','modules/hls_rent/RENT200/hls_hrms_hsm2.screen');
sys_function_assign_pkg.func_service_load('RENT2002','modules/hls_rent/RENT200/hls_hrms_hsm_staff_info.screen');

--分配bm, bm位置：WEB-INF/classes/
sys_function_assign_pkg.func_bm_load('RENT2001','hls_rent.RENT200.hls_staff_info_search');
sys_function_assign_pkg.func_bm_load('RENT2002','hls_rent.RENT200.hls_staff_info_search');


--菜单定义，参数：p_function_group_code菜单code（二级菜单绑定功能）
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT2000',p_function_code=>'RENT2001',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT2000',p_function_code=>'RENT2002',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;

--注意：一级菜单分配二级菜单仍然去系统里的菜单分配
--注意：最后再更新一下缓存，刷新一下页面
--注意：在sql窗口运行完之后记得commit
/
commit;