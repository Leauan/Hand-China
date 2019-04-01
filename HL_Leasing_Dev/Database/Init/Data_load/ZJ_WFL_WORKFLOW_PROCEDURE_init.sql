declare
v_procedure_id number;
begin
  --��������������-�����ܾ���������
  v_procedure_id := zj_wfl_workflow_procedure_s.nextval;
  insert into zj_wfl_workflow_procedure (PROCEDURE_ID, PROCEDURE_CODE, PROCEDURE_DESC, EXEC_PROCEDURE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, PROCEDURE_TYPE_CODE)
  values (v_procedure_id, 'CUX_CON_BORROW_PKG.REJECT_CON_BORROW', '��������������-�����ܾ���������', 'CUX_CON_BORROW_PKG.REJECT_CON_BORROW', -1, sysdate, -1, sysdate, 'PROCEDURE');
  --��������������-�����ܾ��������� ����
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 10, 'P_HD_ID', '���ĵ�ID', -1, sysdate, -1, sysdate);
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 20, 'P_USER_ID', '��ǰ�û�ID', -1, sysdate, -1, sysdate);
  
  --��������������-����ͨ����������
  v_procedure_id := zj_wfl_workflow_procedure_s.nextval;
  insert into zj_wfl_workflow_procedure (PROCEDURE_ID, PROCEDURE_CODE, PROCEDURE_DESC, EXEC_PROCEDURE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, PROCEDURE_TYPE_CODE)
  values (v_procedure_id, 'CUX_CON_BORROW_PKG.APPROVE_CON_BORROW', '��������������-����ͨ����������', 'CUX_CON_BORROW_PKG.APPROVE_CON_BORROW', -1, sysdate, -1, sysdate, 'PROCEDURE');
  --��������������-����ͨ���������� ����
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 10, 'P_HD_ID', '���ĵ�ID', -1, sysdate, -1, sysdate);
  insert into zj_wfl_workflow_procedure_para (PROCEDURE_PARA_ID, PROCEDURE_ID, SEQUENCE_NUM, PARAMETER_CODE, PARAMETER_DESC, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  values (zj_wfl_workflow_proc_para_s.nextval, v_procedure_id, 20, 'P_USER_ID', '��ǰ�û�ID', -1, sysdate, -1, sysdate);
end;