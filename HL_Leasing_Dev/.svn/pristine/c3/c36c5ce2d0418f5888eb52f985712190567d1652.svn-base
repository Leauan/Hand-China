declare
v_service_id number;
begin
  --借阅审批页面工作流页面
  v_service_id := zj_wfl_workflow_service_s.nextval;
  insert into zj_wfl_workflow_service(service_id,service_name,service_desc,creation_date,created_by,last_update_date,last_updated_by) 
  values(v_service_id,'modules/cont/CON508/con_borrow_hd_readonly.screen','借阅审批页面',sysdate,-1,sysdate,-1);
  --借阅审批页面工作流页面参数
  insert into zj_wfl_workflow_service_para(service_para_id,service_id,sequence_num,parameter_code,parameter_desc,creation_date,created_by,last_update_date,last_updated_by) 
  values(zj_wfl_workflow_service_para_s.nextval,v_service_id,10,'hd_id','借阅单ID',sysdate,-1,sysdate,-1);
end;