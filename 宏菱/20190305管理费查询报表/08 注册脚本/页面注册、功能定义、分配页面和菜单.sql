
begin

--ҳ��ע��
sys_function_assign_pkg.service_load('modules/csh/CSH763/factoring_management_fee_state.screen','����Ѳ�ѯ',1,1,0);
--���ܶ���
sys_function_assign_pkg.func_load('CSH763','����Ѳ�ѯ','','F','modules/csh/CSH763/factoring_management_fee_state.screen','1','ZHS');
sys_function_assign_pkg.func_load('CSH763','����Ѳ�ѯ','','F','modules/csh/CSH763/factoring_management_fee_state.screen','1','US');
--����ҳ��
sys_function_assign_pkg.func_service_load('CSH763','modules/csh/CSH763/factoring_management_fee_state.screen');
--����˵�
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'DF_REPORT',p_function_code=>'CSH763',p_enabled_flag=>'Y',P_USER_ID=>-1);

end;
/
commit;

