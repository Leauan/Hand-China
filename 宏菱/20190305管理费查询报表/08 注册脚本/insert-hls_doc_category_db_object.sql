INSERT INTO hls_doc_category_db_object
  (document_category,
   object_name,
   object_type,
   created_by,
   creation_date,
   last_updated_by,
   last_update_date)
VALUES
  ('CONTRACT', --单据类型
   'FACTORING_MANAGEMENT_FEE_LV', --数据库表名或视图名
   'VIEW',
   -1,
   SYSDATE,
   -1,
   SYSDATE);
