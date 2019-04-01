WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool INITIALIZE_MESSAGE.log

set feedback off
set define off
begin
  
  sys_message_pkg.delete_pkg_message('CSH_TRANSACTION_PKG.CSH_WRITE_OFF_AMOUNT_ERROR');
  sys_message_pkg.insert_message('CSH_TRANSACTION_PKG.CSH_WRITE_OFF_AMOUNT_ERROR', '错误','核销金额大于未核销金额,请检查!','ZHS');
  
end;
/
commit;
set feedback on
set define on


spool off

exit
