WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool Regiter_sys_mail_send_by_java.log

set feedback off
set define off
begin
--页面注册
	sys_function_assign_pkg.service_load('modules/sys/SYS405/sys_mail_send_by_java.svc','后台邮件发送java');
	sys_function_assign_pkg.service_load('modules/sys/SYS405/test_send_mail.svc','邮件发送测试');
end;
/

commit;
set feedback on
set define on

spool off

exit
