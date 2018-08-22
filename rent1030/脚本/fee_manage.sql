begin
--清除function-service关系和function-bm关系
--sys_function_assign_pkg.func_clear('func_code');

--页面注册(页面路径，页面名称，三个权限)
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_receipt_fee.screen','收款事物查询',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_manual_receipt.screen','手工收款新增',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_receipt_verification.screen','收款核销事务查询',0,0,0);

sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/manual_verification.screen','手工核销',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_fee_add.screen','费用新增',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_fee_information.screen','费用查询',0,0,0);
sys_function_assign_pkg.service_load('modules/hls_rent/RENT300/rent_manual_verification.screen','收款核销',0,0,0);


--功能定义
sys_function_assign_pkg.func_load('RENT3003','核销事务查询','','F','modules/hls_rent/RENT300/rent_receipt_verification.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT3003','核销事务查询','','F','modules/hls_rent/RENT300/rent_receipt_verification.screen','1','US');
sys_function_assign_pkg.func_load('RENT3004','收款事物','','F','modules/hls_rent/RENT300/rent_receipt_fee.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT3004','收款事物','','F','modules/hls_rent/RENT300/rent_receipt_fee.screen','1','US');
--sys_function_assign_pkg.func_load('RENT3005','手工收款新增','','F','modules/hls_rent/RENT300/rent_manual_receipt.screen','1','ZHS');
--sys_function_assign_pkg.func_load('RENT3005','手工收款新增','','F','modules/hls_rent/RENT300/rent_manual_receipt.screen','1','US');

sys_function_assign_pkg.func_load('RENT3001','费用信息维护','','F','modules/hls_rent/RENT300/rent_fee_information.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT3001','费用信息维护','','F','modules/hls_rent/RENT300/rent_fee_information.screen','1','US');
sys_function_assign_pkg.func_load('RENT3006','核销页面','','F','modules/hls_rent/RENT300/manual_verification.screen','1','ZHS');
sys_function_assign_pkg.func_load('RENT3006','核销页面','','F','modules/hls_rent/RENT300/manual_verification.screen','1','US');



--功能分配角色
--sys_function_assign_pkg.role_func_load('role_code','func_code');

--分配页面
sys_function_assign_pkg.func_service_load('RENT3003','modules/hls_rent/RENT300/rent_receipt_verification.screen');
sys_function_assign_pkg.func_service_load('RENT3004','modules/hls_rent/RENT300/rent_receipt_fee.screen');
sys_function_assign_pkg.func_service_load('RENT3005','modules/hls_rent/RENT300/rent_manual_receipt.screen');

sys_function_assign_pkg.func_service_load('RENT3001','modules/hls_rent/RENT300/rent_fee_information.screen');
sys_function_assign_pkg.func_service_load('RENT3001','modules/hls_rent/RENT300/rent_fee_add.screen');
sys_function_assign_pkg.func_service_load('RENT3006','modules/hls_rent/RENT300/manual_verification.screen');
sys_function_assign_pkg.func_service_load('RENT3006','modules/hls_rent/RENT300/rent_manual_verification.screen');

--分配bm, bm位置：WEB-INF/classes/
sys_function_assign_pkg.func_bm_load('RENT3003','hls_rent.RENT300.rent_fee_currency');
sys_function_assign_pkg.func_bm_load('RENT3003','hls_rent.RENT300.rent_source_object');
sys_function_assign_pkg.func_bm_load('RENT3003','hls_rent.RENT300.rent_ver_search');
sys_function_assign_pkg.func_bm_load('RENT3004','hls_rent.RENT300.rent_source_object');
sys_function_assign_pkg.func_bm_load('RENT3004','hls_rent.RENT300.rent_receipt_fee');
sys_function_assign_pkg.func_bm_load('RENT3005','hls_rent.RENT300.rent_source_object');
sys_function_assign_pkg.func_bm_load('RENT3005','hls_rent.RENT300.rent_fee_currency');

sys_function_assign_pkg.func_bm_load('RENT3001','hls_rent.RENT300.rent_fee_add');
sys_function_assign_pkg.func_bm_load('RENT3001','hls_rent.RENT300.rent_fee_currency');
sys_function_assign_pkg.func_bm_load('RENT3001','hls_rent.RENT300.rent_fee_objects');
sys_function_assign_pkg.func_bm_load('RENT3001','hls_rent.RENT300.rent_fee_query');
sys_function_assign_pkg.func_bm_load('RENT3006','hls_rent.RENT300.rent_fee_add');
sys_function_assign_pkg.func_bm_load('RENT3006','hls_rent.RENT300.manual_verification_submit');
sys_function_assign_pkg.func_bm_load('RENT3006','hls_rent.RENT300.rent_fee_currency');
sys_function_assign_pkg.func_bm_load('RENT3006','hls_rent.RENT300.rent_manual_query');
sys_function_assign_pkg.func_bm_load('RENT3006','hls_rent.RENT300.rent_source_object');

--菜单定义，参数：p_function_group_code菜单code（二级菜单绑定功能）

sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT3000',p_function_code=>'RENT3003',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT3000',p_function_code=>'RENT3004',p_enabled_flag=>'Y',P_USER_ID=>-1);
--sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT3000',p_function_code=>'RENT3005',p_enabled_flag=>'Y',P_USER_ID=>-1);

sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT3000',p_function_code=>'RENT3001',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RENT3000',p_function_code=>'RENT3006',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;

--注意：一级菜单分配二级菜单仍然去系统里的菜单分配
--注意：最后再更新一下缓存，刷新一下页面
--注意：在sql窗口运行完之后记得commit
/
commit;