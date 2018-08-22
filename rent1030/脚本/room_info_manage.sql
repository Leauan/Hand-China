begin
--清除function-service关系和function-bm关系
--sys_function_assign_pkg.func_clear('func_code');

--页面注册(页面路径，页面名称，三个权限)
sys_function_assign_pkg.service_load('modules/hls_rent/RENT100/room_info_input.screen','房屋信息新增与维护',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT100/room_info_edit.screen','修改房屋信息',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT100/room_info_new.screen','新增住房信息',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT100/room_info_search.screen','房屋信息查询',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT100/room_info_search_result.screen','房屋信息查询结果',0,0,0);


--功能定义
sys_function_assign_pkg.func_load('RENT1001','房屋信息新增与维护','','F','modules/hls_rent/RENT100/room_info_input.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT1001','房屋信息新增与维护','','F','modules/hls_rent/RENT100/room_info_input.screen','1','US');
sys_function_assign_pkg.func_load('RENT1003','房屋信息查询','','F','modules/hls_rent/RENT100/room_info_search.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT1003','房屋信息查询','','F','modules/hls_rent/RENT100/room_info_search.screen','1','US');

--功能分配角色
--sys_function_assign_pkg.role_func_load('role_code','func_code');

--分配页面
sys_function_assign_pkg.func_service_load('RENT1001','modules/hls_rent/RENT100/room_info_input.screen');
sys_function_assign_pkg.func_service_load('RENT1001','modules/hls_rent/RENT100/room_info_new.screen');
sys_function_assign_pkg.func_service_load('RENT1003','modules/hls_rent/RENT100/room_info_search.screen');

--分配bm, bm位置：WEB-INF/classes/
sys_function_assign_pkg.func_bm_load('RENT1001','hls_rent.RENT100.hls_room_info');
sys_function_assign_pkg.func_bm_load('RENT1001','hls_rent.RENT100.fnd_province');
sys_function_assign_pkg.func_bm_load('RENT1001','hls_rent.RENT100.fnd_country');
sys_function_assign_pkg.func_bm_load('RENT1001','hls_rent.RENT100.fnd_city');
sys_function_assign_pkg.func_bm_load('RENT1003','hls_rent.RENT100.hls_room_info');--不需要.bm

--菜单定义，参数：p_function_group_code菜单code
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT1000',p_function_code=>'RENT1001',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT1000',p_function_code=>'RENT1003',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;

--注意：最后再更新一下缓存
/
commit;