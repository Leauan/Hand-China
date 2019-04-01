-- 修改cf_item的描述
Update hls_cashflow_item t
   Set t.description = '移库保证金'
 Where t.cf_item = 304;

/*Select *
  From sys_function s, fnd_descriptions f
 Where s.function_name_id = f.description_id
   And s.function_code = 'CON651';*/

Update fnd_descriptions f
   Set f.description_text = '车辆移库申请创建'
 Where f.description_id = 561299;
