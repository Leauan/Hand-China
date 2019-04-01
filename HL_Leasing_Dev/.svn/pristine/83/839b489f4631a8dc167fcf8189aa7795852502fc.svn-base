WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool INITIALIZE_FUNCTION_CON508.log

set feedback off
set define off
begin
--页面注册
	sys_function_assign_pkg.service_load('modules/sys/SYS403/sys_collection_t2_sms_list.svc','逾期两天发送短信给客户');
	sys_function_assign_pkg.service_load('modules/sys/SYS403/sys_threedays_pay_sms_list.svc','还款前三天发送短信给客户');
end;
/

commit;
set feedback on
set define on

spool off

exit
