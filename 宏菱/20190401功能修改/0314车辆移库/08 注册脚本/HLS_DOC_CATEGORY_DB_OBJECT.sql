 INSERT INTO HLS_DOC_CATEGORY_DB_OBJECT
  (DOCUMENT_CATEGORY,
   OBJECT_NAME,
   OBJECT_TYPE,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
VALUES
  ('CONTRACT', 'con_move_cars_hd', 'TABLE', -1, SYSDATE, -1, SYSDATE);
  
  
  INSERT INTO HLS_DOC_CATEGORY_DB_OBJECT
  (DOCUMENT_CATEGORY,
   OBJECT_NAME,
   OBJECT_TYPE,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
VALUES
  ('CONTRACT', 'con_move_cars_hd_lv', 'VIEW', -1, SYSDATE, -1, SYSDATE);
  
 INSERT INTO HLS_DOC_CATEGORY_DB_OBJECT
  (DOCUMENT_CATEGORY,
   OBJECT_NAME,
   OBJECT_TYPE,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
VALUES
  ('CONTRACT', 'con_move_cars_ln', 'TABLE', -1, SYSDATE, -1, SYSDATE);
  
  
  INSERT INTO HLS_DOC_CATEGORY_DB_OBJECT
  (DOCUMENT_CATEGORY,
   OBJECT_NAME,
   OBJECT_TYPE,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
VALUES
  ('CONTRACT', 'con_move_cars_ln_lv', 'VIEW', -1, SYSDATE, -1, SYSDATE);

-- ���⹦�ܺ� 
Insert Into sys_function_dynamic
  (function_code,
   function_name,
   sequence,
   creation_date,
   created_by,
   last_update_date,
   last_updated_by)
Values
  ('CON651R', '������д', 1, Sysdate, -1, Sysdate, -1);
  
  
Insert Into sys_function_dynamic
  (function_code,
   function_name,
   sequence,
   creation_date,
   created_by,
   last_update_date,
   last_updated_by)
Values
  ('CON651N', '�����ƿ�����', 1, Sysdate, -1, Sysdate, -1);
  
    
Insert Into sys_function_dynamic
  (function_code,
   function_name,
   sequence,
   creation_date,
   created_by,
   last_update_date,
   last_updated_by)
Values
  ('CON652N', '�����ƿ�����', 1, Sysdate, -1, Sysdate, -1);


  
Insert Into sys_function_dynamic
  (function_code,
   function_name,
   sequence,
   creation_date,
   created_by,
   last_update_date,
   last_updated_by)
Values
  ('CON652D', '�����ƿ�����', 1, Sysdate, -1, Sysdate, -1);


Insert Into sys_function_dynamic
  (function_code,
   function_name,
   sequence,
   creation_date,
   created_by,
   last_update_date,
   last_updated_by)
Values
  ('CON652R', '�����ƿ�����', 1, Sysdate, -1, Sysdate, -1);
