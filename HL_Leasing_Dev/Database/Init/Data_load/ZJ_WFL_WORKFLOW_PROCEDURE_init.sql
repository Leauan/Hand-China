declare
v_procedure_id number;
begin
  --借阅审批工作流-审批拒绝动作过程
  v_procedure_id := zj_wfl_workflow_procedure_s.nextval;
  insert into zj_wfl_workflow_procedure (PROCEDURE_ID, PROCEDURE_CODE, PROCEDURE_DESC, EXEC_PROCEDURE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, PROCEDURE_TYPE_CODE)
  values (v_procedure_id, 'CUX_CON_BORROW_PKG.REJECT_CON_BORROW', '借阅审批工作流-审批拒绝动作过程', 'CUX_CON_BORROW_PKG.REJECT_CON_BORROW', -1, sysdate, -1, sysdate, 'PROCEDURE');
  --借阅审批工作流-审批拒绝动作过程 参数
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 10, 'P_HD_ID', '借阅单ID', -1, sysdate, -1, sysdate);
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 20, 'P_USER_ID', '当前用户ID', -1, sysdate, -1, sysdate);
  
  --借阅审批工作流-审批通过动作过程
  v_procedure_id := zj_wfl_workflow_procedure_s.nextval;
  insert into zj_wfl_workflow_procedure (PROCEDURE_ID, PROCEDURE_CODE, PROCEDURE_DESC, EXEC_PROCEDURE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, PROCEDURE_TYPE_CODE)
  values (v_procedure_id, 'CUX_CON_BORROW_PKG.APPROVE_CON_BORROW', '借阅审批工作流-审批通过动作过程', 'CUX_CON_BORROW_PKG.APPROVE_CON_BORROW', -1, sysdate, -1, sysdate, 'PROCEDURE');
  --借阅审批工作流-审批通过动作过程 参数
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 10, 'P_HD_ID', '借阅单ID', -1, sysdate, -1, sysdate);
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 20, 'P_USER_ID', '当前用户ID', -1, sysdate, -1, sysdate);
end;