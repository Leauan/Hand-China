WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool 20190401_df_batch_fill_wfl.log

set feedback off
set define off


DECLARE
r_layout_config hls_doc_layout_config%rowtype;
r_layout_config_lov hls_doc_layout_config_lov%rowtype;
v_layout_config_id number;
BEGIN
SYS_LOAD_HLS_DOC_LAYOUT_PKG.delete_layout('DF_BATCH_FILL_WFL');
SYS_LOAD_HLS_DOC_LAYOUT_PKG.load_layout(P_LAYOUT_CODE=>'DF_BATCH_FILL_WFL',P_DESCRIPTION=>'批量填写(节点中)(DF)',P_DOCUMENT_CATEGORY=>'CONTRACT',P_ORDER_SEQ=>null,P_ENABLED_FLAG=>'Y',P_USER_ID=>1);
SYS_LOAD_HLS_DOC_LAYOUT_PKG.load_layout_tab(P_LAYOUT_CODE=>'DF_BATCH_FILL_WFL',P_TAB_CODE=>'F_FORM',P_TAB_TYPE=>'FORM',P_TAB_DESC=>null,P_ENABLED_FLAG=>'Y',P_PARENT_TAB_CODE=>null,P_TAB_SEQ=>10,P_TAB_GROUP=>null,P_BASE_TABLE=>'CON_MOVE_CARS_LN',P_BASE_TABLE_PK=>'LINE_ID',P_BASE_TABLE_FIELD=>null,P_QUERY_SOURCE=>null,P_PARENT_TABLE=>null,P_CONFIGURABLE=>'Y',P_ROW_COUNT=>1,P_COLUMN_COUNT=>1,P_LABEL_WIDTH=>120,P_FIELD_WIDTH=>150,P_MARGIN_TOP=>3,P_MARGIN_HEIGHT=>200,P_MARGIN_WIDTH=>200,P_SHOW_BOX=>'Y',P_BOX_WIDTH=>300,P_TREE_CODE=>null,P_TREE_LEVEL=>1,P_REPEAT_OBJECT=>null,P_REF_TAB_CODE=>null,P_TAB_REF_SCREEN=>null,P_REPEAT_BINDERTARGET_FLAG=>'N',P_ROOT_TREE_CODE=>null,P_SETUP_HEIGHT=>'ABSOLUTE_HEIGHT',P_HEIGHT=>200,P_SETUP_WIDTH=>'ABSOLUTE_WIDTH',P_WIDTH=>200,P_PARENT_LOADED_OBJECT=>null,P_ATTACHMENT_TAB_GROUP=>null,P_REPEAT_BINDNAME_OBJECT=>null,P_USER_ID=>1,P_QUERY_ONLY=>'N',P_REF_V01=>null,P_REF_V02=>null,P_REF_V03=>null,P_REF_V04=>null,P_REF_V05=>null,P_FETCHALL =>'N',P_QUERY_TAB_CODE =>null,P_FIELDWIDTH =>null,P_FIELDHEIGHT =>null,P_CHECK_BEFORE_DELETE_BM =>null,P_CHECK_AFTER_SAVE_BM =>null,P_SWITCHCARD_VALUE=>null,P_RECREATE_DS_FLAG=>'N');
r_layout_config.config_id:=hls_util_pkg.format_number(hls_doc_layout_config_s.nextval) ;r_layout_config.layout_code:='DF_BATCH_FILL_WFL';r_layout_config.tab_code:='F_FORM' ;r_layout_config.column_name:='DEPOSIT_FLAG';r_layout_config.data_type:='VARCHAR2';r_layout_config.system_flag:='N';r_layout_config.key_field_flag:='N';r_layout_config.enabled_flag:='Y';r_layout_config.display_flag:='Y' ;r_layout_config.display_order:=5;r_layout_config.prompt:='是否收取保证金';r_layout_config.input_mode:='REQUIRED';r_layout_config.validation_type:='COMBOBOX' ;r_layout_config.validation_sql:=null;r_layout_config.lov_return_vcode:='N';r_layout_config.precision:=null;r_layout_config.zero_fill:='FALSE';r_layout_config.allow_format:='FALSE';r_layout_config.allow_decimal:='FALSE';r_layout_config.alignment:=null ;r_layout_config.width:=null;r_layout_config.percent:=null;r_layout_config.default_value:=null;r_layout_config.upper_limit:=null;r_layout_config.lower_limit:=null;r_layout_config.copy_from_parent_tab:='N';r_layout_config.height:=null;r_layout_config.lov_height:=null;r_layout_config.lov_width:=null;r_layout_config.footerrenderer:='N' ;r_layout_config.lov_cascade_para1:=null;r_layout_config.lov_cascade_para2:=null ;r_layout_config.lov_cascade_para3:=null;r_layout_config.underline:='N';r_layout_config.field_group:=null;r_layout_config.switchcard_tab_code:=null;r_layout_config.base_tab_code:=null;r_layout_config.clob_validation_sql:='Select cv.code_value_name value_name, cv.code_value value_code
          From sys_code_values_v cv
         Where cv.code = ''YES_NO''
           And cv.code_enabled_flag = ''Y''
           And cv.code_value_enabled_flag = ''Y''';r_layout_config.field_javascript:=null;r_layout_config.field_bak_flag:='N';r_layout_config.created_by:=1;r_layout_config.last_updated_by:=1;r_layout_config.creation_date:=to_date('2019-04-01','yyyy-mm-dd');r_layout_config.last_update_date:=to_date('2019-04-01','yyyy-mm-dd');r_layout_config.ignore_required := null;SYS_LOAD_HLS_DOC_LAYOUT_PKG.load_layout_config(r_layout_config);
v_layout_config_id := r_layout_config.config_id;
SYS_LOAD_HLS_DOC_LAYOUT_PKG.load_layout_screen(P_LAYOUT_CODE=>'DF_BATCH_FILL_WFL',P_TAB_CODE=>'F_FORM',P_ORDER_SEQ=>1,P_COLUMN_NAME=>'DEPOSIT_FLAG',P_INPUT_MODE=>'REQUIRED',P_COLSPAN=>1,P_ROWSPAN=>1,P_HEIGHT=>null,P_USER_ID=>1);
END;
/
commit;

set feedback on
set define on

spool off

exit
