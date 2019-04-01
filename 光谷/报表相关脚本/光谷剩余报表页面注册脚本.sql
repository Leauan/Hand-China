WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;



set feedback off
set define off

begin

--页面注册
sys_function_assign_pkg.service_load('modules/cont/CON950/con_lease_item_general_report.lview','通用租赁物报表',1,1,0);
sys_function_assign_pkg.service_load('modules/cont/CON960/con_lease_item_plane_report.lview','飞机租赁物报表',1,1,0);
sys_function_assign_pkg.service_load('modules/cont/CON970/con_lease_item_boat_report.lview','船舶租赁物报表',1,1,0);
sys_function_assign_pkg.service_load('modules/cont/CON980/con_lease_item_service_report.lview','公共事业租赁物报表',1,1,0);
sys_function_assign_pkg.service_load('modules/cont/CON990/con_delivered_project_report.lview','已投放项目表',1,1,0);
--功能定义
sys_function_assign_pkg.func_load('CON950','通用租赁物报表','','F','modules/cont/CON950/con_lease_item_general_report.lview','1','ZHS');
sys_function_assign_pkg.func_load('CON960','飞机租赁物报表','','F','modules/cont/CON960/con_lease_item_plane_report.lview','1','ZHS');
sys_function_assign_pkg.func_load('CON970','船舶租赁物报表','','F','modules/cont/CON970/con_lease_item_boat_report.lview','1','ZHS');
sys_function_assign_pkg.func_load('CON980','公共事业租赁物报表','','F','modules/cont/CON980/con_lease_item_service_report.lview','1','ZHS');
sys_function_assign_pkg.func_load('CON990','已投放项目表','','F','modules/cont/CON990/con_delivered_project_report.lview','1','ZHS');
--分配页面
sys_function_assign_pkg.func_service_load('CON950','modules/cont/CON950/con_lease_item_general_report.lview');
sys_function_assign_pkg.func_service_load('CON960','modules/cont/CON960/con_lease_item_plane_report.lview');
sys_function_assign_pkg.func_service_load('CON970','modules/cont/CON970/con_lease_item_boat_report.lview');
sys_function_assign_pkg.func_service_load('CON980','modules/cont/CON980/con_lease_item_service_report.lview');
sys_function_assign_pkg.func_service_load('CON990','modules/cont/CON990/con_delivered_project_report.lview');

sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RPT1300',p_function_code=>'CON950',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RPT1300',p_function_code=>'CON960',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RPT1300',p_function_code=>'CON970',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RPT1300',p_function_code=>'CON980',p_enabled_flag=>'Y',P_USER_ID=>-1);
sys_load_sys_function_grp_pkg.sys_function_group_item_load(p_function_group_code=>'RPT1300',p_function_code=>'CON990',p_enabled_flag=>'Y',P_USER_ID=>-1);
end;
/
commit;
set feedback on
set define on

spool off
exit 
