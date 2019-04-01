Create Or Replace Package prj_project_df_pkg Is

  -- Author  : LARA
  -- Created : 2018/12/17 19:13:57
  -- Purpose : DF系统项目

  --EXCEL导入项目车辆信息表
  Procedure ins_df_car_interface_temp(p_session_id Number,
                                      p_header_id  Number,
                                      p_company_id Number,
                                      p_user_id    Number);

  --清空批量下载当前session下的所有数据
  Procedure del_df_car_interface_temp(p_session_id Number,
                                      p_company_id Number,
                                      p_user_id    Number);

  Procedure save_prj_bp_contact_info(p_prj_bp_id  Number,
                                     p_bp_id      Number,
                                     p_project_id Number,
                                     p_user_id    Number);

  --初始化商业伙伴
  Procedure save_project_bp(p_project_id Number,
                            p_bp_id      Number,
                            p_user_id    Number);

  --创建库融批次申请
  Procedure create_df_project(p_session_id Number,
                              p_company_id Number,
                              p_user_id    Number);

  --库融申请提交
  Procedure workflow_start(p_project_id Number, p_user_id Number);

  --库融申请审批通过
  Procedure workflow_finish(p_project_id     Number,
                            p_project_status Varchar2,
                            p_user_id        Number,
                            p_instance_id    Number);

  --add by lara 11355 20190214 自动关闭邮件工作流通知
  Procedure close_wfl_mail_notice(p_instance_id Number, p_user_id Number);

  --add by 5390 提供对外方法，导入广三接口数据
  Procedure init_df_car_interface_data(p_order_seq               Varchar2, --序号
                                       p_finance_com_code        Varchar2, --融资机构代码               
                                       p_main_fac_num            Varchar2, --主机厂编号
                                       p_manu_code               Varchar2, --制造商代号
                                       p_dealer_code             Varchar2, --经销商代码
                                       p_dealer_name             Varchar2, --经销商名称
                                       p_model_code              Varchar2, --车型代码
                                       p_color_code              Varchar2, --颜色编码
                                       p_car_price               Varchar2, --车辆售价
                                       p_finance_amount          Varchar2, --融资金额
                                       p_son_code                Varchar2, --SON号
                                       p_item_frame_number       Varchar2, --VIN码
                                       p_item_engine_number      Varchar2, --发动机号
                                       p_qualified_number        Varchar2, --合格证号
                                       p_schedule_departure_date Varchar2, --计划发车日期
                                       p_expected_arrival_date   Varchar2, --预计抵达日期
                                       p_session_id              Number,
                                       p_company_id              Number,
                                       p_user_id                 Number);

End prj_project_df_pkg;
/
Create Or Replace Package Body prj_project_df_pkg Is

  g_document_category Constant Varchar2(100) := 'PROJECT';
  g_exists Number;
  e_get_project_number_err Exception;

  e_lock_table Exception;
  Pragma Exception_Init(e_lock_table, -54);

  Procedure log(p_log Varchar2) Is
    Pragma Autonomous_Transaction;
  Begin
    dbms_output.put_line(p_log);
    Insert Into hl_data_load_logs
      (log_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       message)
    Values
      (hl_data_load_logs_s.nextval, 1, Sysdate, 1, Sysdate, p_log);
    Commit;
  End;

  Function get_project_id Return Number Is
    v_id Number;
  Begin
    Select prj_project_s.nextval Into v_id From dual;
    Return v_id;
  End;

  Function get_project_bp_id Return Number Is
    v_id Number;
  Begin
    Select prj_project_bp_s.nextval Into v_id From dual;
    Return v_id;
  End;

  Function get_prj_df_car_info_id Return Number Is
    v_id Number;
  Begin
    Select prj_project_df_car_info_s.nextval Into v_id From dual;
    Return v_id;
  End;

  Function get_quotation_id Return Number Is
    v_id Number;
  Begin
    Select prj_quotation_s.nextval Into v_id From dual;
    Return v_id;
  End;

  Procedure insert_project(p_project_rec prj_project%Rowtype) Is
  Begin
    Insert Into prj_project Values p_project_rec;
  End;

  Procedure update_project(p_project_rec prj_project%Rowtype) Is
  Begin
    Update prj_project
       Set Row = p_project_rec
     Where project_id = p_project_rec.project_id;
  End;

  Procedure insert_project_bp(p_project_bp_rec prj_project_bp%Rowtype) Is
  Begin
    Insert Into prj_project_bp Values p_project_bp_rec;
  End;

  Procedure update_project_bp(p_project_bp_rec prj_project_bp%Rowtype) Is
  Begin
    Update prj_project_bp
       Set Row = p_project_bp_rec
     Where prj_bp_id = p_project_bp_rec.prj_bp_id;
  End;

  Procedure insert_prj_project_df_car_info(p_project_df_car_info_rec prj_project_df_car_info%Rowtype) Is
  Begin
    Insert Into prj_project_df_car_info Values p_project_df_car_info_rec;
  End;

  Procedure insert_quotation(p_quotation_rec prj_quotation%Rowtype) Is
  Begin
    Insert Into prj_quotation Values p_quotation_rec;
  End;

  Function transfer_char_to_number(p_number Varchar2) Return Number Is
    v_number Number;
  Begin
    If Trim(p_number) Is Not Null Then
      Begin
        v_number := to_number(Replace(p_number, ',', ''));
      Exception
        When Others Then
          v_number := Null;
      End;
    Else
      Return Null;
    End If;
    Return v_number;
  End;

  Function transfer_char_to_percent(p_percent Varchar2) Return Number Is
    v_number Number;
  Begin
    If instr(Trim(p_percent), '%') > 0 Then
      v_number := transfer_char_to_number(Replace(p_percent, '%')) / 100;
    Else
      v_number := transfer_char_to_number(p_percent);
    End If;
    Return v_number;
  End;

  Function transfer_char_to_date(p_date Varchar2) Return Date Is
    v_date Date;
  Begin
    If Trim(p_date) Is Not Null Then
      Begin
        v_date := to_date(p_date, 'yyyy/mm/dd');
      Exception
        When Others Then
          Begin
            v_date := to_date(p_date, 'yyyy-mm-dd');
          Exception
            When Others Then
              Return Null;
          End;
      End;
    Else
      Return Null;
    End If;
    Return v_date;
  End;

  --将同一会话数据导入租赁物表中
  Procedure init_df_car_interface_data(p_order_seq               Varchar2, --序号
                                       p_finance_com_code        Varchar2, --融资机构代码               
                                       p_main_fac_num            Varchar2, --主机厂编号
                                       p_manu_code               Varchar2, --制造商代号
                                       p_dealer_code             Varchar2, --经销商代码
                                       p_dealer_name             Varchar2, --经销商名称
                                       p_model_code              Varchar2, --车型代码
                                       p_color_code              Varchar2, --颜色编码
                                       p_car_price               Varchar2, --车辆售价
                                       p_finance_amount          Varchar2, --融资金额
                                       p_son_code                Varchar2, --SON号
                                       p_item_frame_number       Varchar2, --VIN码
                                       p_item_engine_number      Varchar2, --发动机号
                                       p_qualified_number        Varchar2, --合格证号
                                       p_schedule_departure_date Varchar2, --计划发车日期
                                       p_expected_arrival_date   Varchar2, --预计抵达日期
                                       p_session_id              Number,
                                       p_company_id              Number,
                                       p_user_id                 Number) Is
    v_bp_id              Number;
    v_user_id            Number; --经销商用户id
    v_count              Number;
    v_car_info_id        Number;
    v_credit_last_amount Number;
    v_credit_used_amount Number;
    v_parent_last_amount Number;
    v_parent_used_amount Number;
    v_parent_id          Number;
    v_error_message      Varchar2(2000);
    r_car_info_rec       prj_project_df_car_info%Rowtype;
    r_hls_bp_rec         hls_bp_master%Rowtype;
  Begin
    --1.检查数据，若数据不符合规则先以报错方式反馈
    --检查是否能找到对应经销商(当前无经销商代码数据，待补充后用代码匹配)
  
    --必输性不为空校验
    If p_dealer_code Is Null Then
      v_error_message := v_error_message || '经销商代码不能为空；';
    Elsif p_dealer_name Is Null Then
      v_error_message := v_error_message || '经销商名称不能为空；';
    Elsif p_finance_com_code Is Null Then
      v_error_message := v_error_message || '融资机构代码不能为空；';
    Elsif p_main_fac_num Is Null Then
      v_error_message := v_error_message || '主机厂编号不能为空；';
    Elsif p_manu_code Is Null Then
      v_error_message := v_error_message || '制造商代号不能为空；';
    Elsif p_model_code Is Null Then
      v_error_message := v_error_message || '车型代码不能为空；';
    Elsif p_car_price Is Null Then
      v_error_message := v_error_message || '车辆售价不能为空；';
    Elsif p_finance_amount Is Null Then
      v_error_message := v_error_message || '保理融资金额不能为空；';
    Elsif p_item_frame_number Is Null Then
      v_error_message := v_error_message || 'VIN码不能为空；';
    End If;
  
    --存在性校验
    --1.车型代码
    If p_model_code Is Not Null Then
      v_count := 0;
      For car_type_cur In (Select v.type_id, v.type_code, v.enabled_flag
                             From hls_car_type v) Loop
        If Trim(p_model_code) = car_type_cur.type_code Then
          v_count := 1;
        End If;
      End Loop;
      If v_count = 0 Then
        v_error_message := v_error_message || '车型代码不存在；';
      End If;
    End If;
  
    --2.颜色编码（客户未提供，待定）
  
    --3.经销商代码
    If p_dealer_code Is Not Null Then
      Begin
        Select m.bp_id
          Into v_bp_id
          From hls_bp_master m
         Where m.gac_bp_code = p_dealer_code;
      
        If v_bp_id Is Null Then
          v_error_message := v_error_message || '商业伙伴中未找到对应经销商；';
        Else
          Begin
            Select m.bp_id
              Into v_bp_id
              From hls_bp_master m
             Where m.bp_name = p_dealer_name
               And m.gac_bp_code = p_dealer_code;
          Exception
            When no_data_found Then
              v_error_message := v_error_message || '经销商代码和经销商名称不匹配；';
          End;
        End If;
      
        --获取经销商用户
        Select us.user_id
          Into v_user_id
          From sys_user us
         Where us.bp_category = 'AGENT'
           And us.bp_id = v_bp_id;
      Exception
        When no_data_found Then
          v_error_message := v_error_message || '用户中未找到对应经销商；';
      End;
    
    End If;
  
    --唯一性校验（SON号、VIN码、发动机号，合格证号唯一）
    --2.需与数据库中存量数据校验
    For car_df_cur In (Select t.son_code,
                              t.item_frame_number,
                              t.item_engine_number,
                              t.qualified_number
                         From prj_project_df_car_info t
                        Where Exists (Select 1
                                 From prj_project pp
                                Where pp.project_id = t.project_id
                                  And pp.project_status Not In
                                      ('REJECT', 'CANCEL'))) Loop
      If Trim(car_df_cur.son_code) = p_son_code Then
        v_error_message := v_error_message || 'SON号重复；';
      End If;
    
      If Trim(car_df_cur.item_frame_number) = p_item_frame_number Then
        v_error_message := v_error_message || 'VIN码重复；';
      End If;
    
      If Trim(car_df_cur.item_engine_number) = p_item_engine_number Then
        v_error_message := v_error_message || '发动机号重复；';
      End If;
    
      If Trim(car_df_cur.qualified_number) = p_qualified_number Then
        v_error_message := v_error_message || '合格证号重复；';
      End If;
    End Loop;
  
    --数据性校验 (VIN码,日期,金额)
    If length(Trim(p_item_frame_number)) != 17 Then
      v_error_message := v_error_message || 'VIN码格式错误；';
    End If;
  
    /*   IF p_schedule_departure_date IS NOT NULL AND
       p_expected_arrival_date IS NOT NULL THEN
      if p_schedule_departure_date > p_expected_arrival_date then
        v_error_message := v_error_message || '计划发车日期应在预计抵达日期之前；';
      end if;
    END IF;*/
  
    If p_car_price < 0 Or p_finance_amount < 0 Then
      v_error_message := v_error_message || '金额不能为负值；';
    End If;
  
    --额度校验
    Begin
      Select (l.credit_total_amount -
             (hls_bp_master_credit_pkg.calc_used_amount_bp(p_bp_id   => v_bp_id,
                                                            p_user_id => p_user_id))) As credit_last_amount
        Into v_credit_last_amount
        From hls_bp_master_credit_ln l
       Where l.bp_id = v_bp_id
         And trunc(l.credit_date_from) <= trunc(Sysdate)
         And l.credit_date_to >= trunc(Sysdate)
         And l.enable_flag = 'Y';
    
      Begin
        Select Sum(nvl(dc.finance_amount, 0))
          Into v_credit_used_amount
          From prj_project_df_car_info dc
         Where dc.bp_id = v_bp_id
           And nvl(dc.create_prj_flag, 'N') = 'N';
      
        If v_credit_used_amount Is Null Then
          v_credit_used_amount := 0;
        End If;
      Exception
        When no_data_found Then
          v_credit_used_amount := 0;
      End;
    
      If v_credit_used_amount + p_finance_amount > v_credit_last_amount Then
        v_error_message := v_error_message || '经销商额度不足；';
      End If;
    
    Exception
      When no_data_found Then
        v_error_message := v_error_message || '经销商额度未找到；';
    End;
    --addby wuts 2019-2-26  集团额度校验
    Begin
      Select parent_id
        Into v_parent_id
        From hls_bp_master
       Where bp_id = v_bp_id;
    
      If v_parent_id Is Null Or v_parent_id = '' Or v_parent_id = v_bp_id Then
      
        Null;
      Else
        Select (l.credit_total_amount -
               (hls_bp_master_credit_pkg.calc_used_amount_parent_bp(p_bp_id   => l.bp_id,
                                                                     p_user_id => p_user_id))) As credit_last_amount
          Into v_parent_last_amount
          From hls_bp_master_credit_ln l
         Where l.bp_id = v_parent_id
           And trunc(l.credit_date_from) <= trunc(Sysdate)
           And l.credit_date_to >= trunc(Sysdate)
           And l.enable_flag = 'Y';
      
        Begin
          Select Sum(nvl(dc.finance_amount, 0))
            Into v_parent_used_amount
            From prj_project_df_car_info dc
           Where dc.bp_id = v_parent_id
             And nvl(dc.create_prj_flag, 'N') = 'N';
        
          If v_parent_used_amount Is Null Then
            v_parent_used_amount := 0;
          End If;
        Exception
          When no_data_found Then
            v_parent_used_amount := 0;
        End;
        If v_parent_used_amount + p_finance_amount > v_parent_last_amount Then
          v_error_message := v_error_message || '集团额度不足；';
        End If;
      
      End If;
    
    Exception
      When no_data_found Then
        Null;
    End;
  
    --end
    If v_bp_id Is Not Null Then
      Select *
        Into r_hls_bp_rec
        From hls_bp_master hbm
       Where hbm.bp_id = v_bp_id;
      --联动利率
      If r_hls_bp_rec.initial_rate Is Null Then
        v_error_message := v_error_message || '联动利率未维护;';
      End If;
    
      --首付款比例
      If r_hls_bp_rec.initial_rate Is Null Then
        v_error_message := v_error_message || '首付款比例未维护;';
      End If;
    
    End If;
  
    --2.将接口表中数据插入至车辆信息表
    v_car_info_id                        := get_prj_df_car_info_id;
    r_car_info_rec.car_info_id           := v_car_info_id;
    r_car_info_rec.order_seq             := transfer_char_to_number(p_order_seq);
    r_car_info_rec.finance_com_code      := p_finance_com_code;
    r_car_info_rec.main_fac_num          := p_main_fac_num;
    r_car_info_rec.manu_code             := p_manu_code;
    r_car_info_rec.dealer_code           := p_dealer_code;
    r_car_info_rec.dealer_name           := p_dealer_name;
    r_car_info_rec.model_code            := p_model_code;
    r_car_info_rec.color_code            := p_color_code;
    r_car_info_rec.car_price             := transfer_char_to_number(p_car_price);
    r_car_info_rec.finance_amount        := transfer_char_to_number(p_finance_amount);
    r_car_info_rec.son_code              := p_son_code;
    r_car_info_rec.item_frame_number     := p_item_frame_number;
    r_car_info_rec.item_engine_number    := p_item_engine_number;
    r_car_info_rec.qualified_number      := p_qualified_number;
    r_car_info_rec.sch_departure_date    := transfer_char_to_date(p_schedule_departure_date);
    r_car_info_rec.expected_arrival_date := transfer_char_to_date(p_expected_arrival_date);
    r_car_info_rec.session_id            := p_session_id;
    r_car_info_rec.company_id            := p_company_id;
    r_car_info_rec.error_message         := v_error_message;
    r_car_info_rec.enabled_flag          := 'Y';
    r_car_info_rec.car_status            := 'ORDERD';
    r_car_info_rec.bp_id                 := v_bp_id;
    r_car_info_rec.create_prj_flag       := 'N';
    r_car_info_rec.created_by            := p_user_id;
    r_car_info_rec.creation_date         := Sysdate;
    r_car_info_rec.last_updated_by       := p_user_id;
    r_car_info_rec.last_update_date      := Sysdate;
  
    insert_prj_project_df_car_info(r_car_info_rec);
  
  End init_df_car_interface_data;

  Function get_project_number(p_document_type    Varchar2,
                              p_transaction_date Date,
                              p_company_id       Number,
                              p_user_id          Number) Return Varchar2 Is
    v_no Varchar2(100);
  Begin
    v_no := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => g_document_category,
                                                     p_document_type     => p_document_type,
                                                     p_company_id        => p_company_id,
                                                     p_operation_unit_id => Null,
                                                     p_operation_date    => p_transaction_date,
                                                     p_created_by        => p_user_id);
    If v_no = fnd_code_rule_pkg.c_error Then
      Raise e_get_project_number_err;
    End If;
  
    Return v_no;
  End;

  --初始化商业伙伴联系人信息
  Procedure save_prj_bp_contact_info(p_prj_bp_id  Number,
                                     p_bp_id      Number,
                                     p_project_id Number,
                                     p_user_id    Number) Is
    r_prj_contact_cur   prj_project_bp_contact_info%Rowtype;
    v_prj_bp_conract_id Number;
  Begin
    For hls_bp_contact_cur In (Select hc.contact_info_id
                                 From hls_bp_master_contact_info hc
                                Where hc.bp_id = p_bp_id) Loop
      Select prj_project_bp_contact_info_s.nextval
        Into v_prj_bp_conract_id
        From dual;
    
      r_prj_contact_cur.prj_contact_info_id := v_prj_bp_conract_id;
      r_prj_contact_cur.project_id          := p_project_id;
    
      hls_document_transfer_pkg.doc_to_doc(p_from_doc_table        => 'HLS_BP_MASTER_CONTACT_INFO',
                                           p_from_doc_pk           => hls_bp_contact_cur.contact_info_id,
                                           p_to_doc_table          => 'PRJ_PROJECT_BP_CONTACT_INFO',
                                           p_to_doc_pk             => v_prj_bp_conract_id,
                                           p_copy_method           => 'DOC_TO_HISTORY',
                                           p_user_id               => p_user_id,
                                           p_to_doc_column_1       => 'PRJ_BP_ID',
                                           p_to_doc_column_1_value => p_prj_bp_id,
                                           p_to_doc_column_2       => 'PROJECT_ID',
                                           p_to_doc_column_2_value => p_project_id);
    End Loop;
  
  End;

  --初始化商业伙伴
  Procedure save_project_bp(p_project_id Number,
                            p_bp_id      Number,
                            p_user_id    Number) Is
    v_prj_bp_id      Number;
    r_project_bp_rec prj_project_bp%Rowtype;
  
    r_bp_master_rec hls_bp_master%Rowtype;
  Begin
    Select *
      Into r_bp_master_rec
      From hls_bp_master hbm
     Where hbm.bp_id = p_bp_id;
  
    v_prj_bp_id := get_project_bp_id;
    hls_document_transfer_pkg.doc_to_doc(p_from_doc_table => 'HLS_BP_MASTER',
                                         p_from_doc_pk    => p_bp_id,
                                         p_to_doc_table   => 'PRJ_PROJECT_BP',
                                         p_to_doc_pk      => v_prj_bp_id,
                                         p_copy_method    => 'DOC_TO_HISTORY',
                                         p_user_id        => p_user_id);
  
    Select pb.*
      Into r_project_bp_rec
      From prj_project_bp pb
     Where pb.prj_bp_id = v_prj_bp_id;
  
    r_project_bp_rec.bp_seq              := 1;
    r_project_bp_rec.bp_id               := p_bp_id;
    r_project_bp_rec.project_id          := p_project_id;
    r_project_bp_rec.creat_bp_flg        := 'N';
    r_project_bp_rec.contract_seq        := 1;
    r_project_bp_rec.file_num            := r_bp_master_rec.ref_v02;
    r_project_bp_rec.cooperative_date    := r_bp_master_rec.ref_d05;
    r_project_bp_rec.source_of_income_db := r_bp_master_rec.main_business_growth;
    r_project_bp_rec.created_by          := p_user_id;
    r_project_bp_rec.creation_date       := Sysdate;
    r_project_bp_rec.last_updated_by     := p_user_id;
    r_project_bp_rec.last_update_date    := Sysdate;
  
    update_project_bp(p_project_bp_rec => r_project_bp_rec);
  
    --初始化商业伙伴联系人信息
    save_prj_bp_contact_info(p_prj_bp_id  => v_prj_bp_id,
                             p_bp_id      => p_bp_id,
                             p_project_id => p_project_id,
                             p_user_id    => p_user_id);
  
  End;

  Procedure workflow_return(p_project_id Number) Is
  Begin
    Update prj_project p
       Set p.approved_return_flag = 'Y'
     Where p.project_id = p_project_id;
  End;

  Procedure invalid_hls_standard_history(p_project_id Number,
                                         p_user_id    Number) Is
  Begin
    Update hls_standard_history t
       Set t.confirm_flag     = 'Y',
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.table_pk_value = p_project_id
       And t.table_name = 'PRJ_PROJECT';
  
    Update hls_standard_history t
       Set t.confirm_flag     = 'Y',
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.table_pk_value In
           (Select ppl.project_lease_item_id
              From prj_project_lease_item ppl
             Where ppl.project_id = p_project_id)
       And t.table_name = 'PRJ_PROJECT_LEASE_ITEM';
  
    Update hls_standard_history t
       Set t.confirm_flag     = 'Y',
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.table_pk_value In
           (Select ac.ast_car_insurance_id
              From ast_car_insurance ac
             Where ac.project_id = p_project_id)
       And t.table_name = 'AST_CAR_INSURANCE';
  
    Update hls_standard_history t
       Set t.confirm_flag     = 'Y',
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.table_pk_value In
           (Select ppb.prj_bp_id
              From prj_project_bp ppb
             Where ppb.project_id = p_project_id)
       And t.table_name = 'PRJ_PROJECT_BP';
  
    Update hls_standard_history t
       Set t.confirm_flag     = 'Y',
           t.last_update_date = Sysdate,
           t.last_updated_by  = p_user_id
     Where t.table_pk_value In
           (Select ppbc.prj_contact_info_id
              From prj_project_bp_contact_info ppbc, prj_project_bp ppb
             Where ppb.prj_bp_id = ppbc.prj_bp_id
               And ppb.project_id = p_project_id)
       And t.table_name = 'PRJ_PROJECT_BP_CONTACT_INFO';
  
  End;

  Function get_project_name(p_bp_id In Number) Return Varchar2 As
    v_max_num      Number;
    v_project_name Varchar2(20);
    v_agent_code   Varchar2(30);
  Begin
    --获取经销商代码
    Select hbm.external_bp_code
      Into v_agent_code
      From hls_bp_master hbm
     Where hbm.bp_id = p_bp_id;
  
    Begin
      Select nvl(Max(to_number(substr(pp.project_name,
                                      instr(pp.project_name, '-', 1, 2) + 1))),
                 0) + 1
        Into v_max_num
        From prj_project pp
       Where pp.lease_channel = '01'
         And pp.bp_id_tenant = p_bp_id
         And trunc(pp.submit_date) = trunc(Sysdate);
    Exception
      When no_data_found Then
        v_max_num := 0;
    End;
  
    Select v_agent_code || '-' || to_char(Sysdate, 'YYMMDD') || '-' ||
           nvl(v_max_num, 0)
      Into v_project_name
      From dual;
  
    Return v_project_name;
  End;

  --创建库融批次申请
  Procedure create_df_project(p_session_id Number,
                              p_company_id Number,
                              p_user_id    Number) Is
    r_project_rec prj_project%Rowtype;
    v_project_id  Number;
    v_user_id     Number;
    v_cdd_list_id Number;
    v_unit_id     Number;
    v_assignor_id Number;
    v_son_code    Varchar2(100);
  Begin
    For df_bp_list In (Select dc.bp_id
                         From prj_project_df_car_info dc
                        Where dc.session_id = p_session_id
                          And dc.create_prj_flag = 'N'
                        Group By dc.bp_id) Loop
      --update by 5390 如果出现异常，则应捕获异常 回滚至savepoint 继续进行
      Begin
        Savepoint transaction_savepoint;
        --获取经销商用户
        Select us.user_id
          Into v_user_id
          From sys_user us
         Where us.bp_category = 'AGENT'
           And us.bp_id = df_bp_list.bp_id;
      
        --初始化项目数据
      
        v_project_id                    := get_project_id;
        r_project_rec.project_id        := v_project_id;
        r_project_rec.company_id        := p_company_id;
        r_project_rec.document_category := g_document_category;
        r_project_rec.business_type     := 'FACTORING'; --与SBO凭证行传输租赁类型匹配
        r_project_rec.document_type     := 'CARLS';
        r_project_rec.bp_id_tenant      := df_bp_list.bp_id;
        r_project_rec.invoice_agent_id  := df_bp_list.bp_id;
        r_project_rec.project_name      := get_project_name(df_bp_list.bp_id);
      
        r_project_rec.project_number := get_project_number(p_document_type    => 'CARLS',
                                                           p_transaction_date => trunc(Sysdate),
                                                           p_company_id       => r_project_rec.company_id,
                                                           p_user_id          => v_user_id);
      
        --默认归属自动车部
        Select u.unit_id
          Into v_unit_id
          From exp_org_unit_v u
         Where u.unit_code = '0022';
      
        --update by 5390 广汽三菱的编码为：P00000095
        --当前债转方默认为广汽三菱
        Select hbm.bp_id
          Into v_assignor_id
          From hls_bp_master hbm
         Where hbm.bp_code = 'P00000095'; --'GAC';
      
        --首付款比例当前逻辑以经销商为维度，在CF&DF联动入口维护
        Select hbm.down_payment_ratio
          Into r_project_rec.down_payment_ratio
          From hls_bp_master hbm
         Where hbm.bp_id = df_bp_list.bp_id;
      
        r_project_rec.project_status := 'NEW';
        r_project_rec.lease_channel  := '01';
        r_project_rec.currency       := 'CNY';
        r_project_rec.division       := '00';
        r_project_rec.unit_id        := v_unit_id;
        r_project_rec.assignor_id    := v_assignor_id;
        r_project_rec.cdd_list_id    := prj_cdd_list_s.nextval; --当前默认无资料模板，则导入时初始id
      
        r_project_rec.created_by       := p_user_id;
        r_project_rec.creation_date    := Sysdate;
        r_project_rec.last_updated_by  := p_user_id;
        r_project_rec.last_update_date := Sysdate;
      
        insert_project(p_project_rec => r_project_rec);
      
        --项目创建保存时校验
        prj_project_pkg.project_create_save_check(p_project_id     => v_project_id,
                                                  p_user_id        => p_user_id,
                                                  p_function_code  => '',
                                                  p_function_usage => '',
                                                  p_project_status => r_project_rec.project_status,
                                                  p_cdd_list_id    => v_cdd_list_id);
      
        --初始化商业伙伴
        save_project_bp(p_project_id => v_project_id,
                        p_bp_id      => df_bp_list.bp_id,
                        p_user_id    => p_user_id);
      
        For car_info_list In (Select dc.car_info_id,
                                     dc.dealer_code,
                                     dc.son_code
                                From prj_project_df_car_info dc
                               Where dc.session_id = p_session_id
                                 And dc.bp_id = df_bp_list.bp_id
                                 And dc.create_prj_flag = 'N') Loop
          If car_info_list.son_code Is Null Then
            v_son_code := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => 'PROJECT',
                                                                   p_document_type     => 'DF_PRJ',
                                                                   p_company_id        => p_company_id,
                                                                   p_operation_unit_id => 1,
                                                                   p_operation_date    => Sysdate,
                                                                   p_created_by        => p_user_id,
                                                                   p_agent_code        => car_info_list.dealer_code);
          
            Update prj_project_df_car_info dc
               Set dc.son_code         = v_son_code,
                   dc.last_updated_by  = p_user_id,
                   dc.last_update_date = Sysdate
             Where dc.car_info_id = car_info_list.car_info_id;
          End If;
        
          Update prj_project_df_car_info dc
             Set dc.project_id       = v_project_id,
                 dc.create_prj_flag  = 'Y',
                 dc.company_id       = p_company_id,
                 dc.last_updated_by  = p_user_id,
                 dc.last_update_date = Sysdate
           Where dc.car_info_id = car_info_list.car_info_id;
        
        End Loop;
      
        --提交租赁申请
        prj_project_df_pkg.workflow_start(p_project_id => v_project_id,
                                          p_user_id    => v_user_id);
      
        Select *
          Into r_project_rec
          From prj_project pp
         Where pp.project_id = v_project_id;
      
        --保留当前额度信息
        Select l.credit_total_amount,
               (l.credit_total_amount -
               (hls_bp_master_credit_pkg.calc_used_amount_bp(p_bp_id   => df_bp_list.bp_id,
                                                              p_user_id => p_user_id))) As credit_last_amount,
               l.credit_date_to
          Into r_project_rec.credit_total_amount,
               r_project_rec.credit_last_amount,
               r_project_rec.credit_date_to
          From hls_bp_master_credit_ln l
         Where l.bp_id = df_bp_list.bp_id
           And trunc(l.credit_date_from) <= trunc(Sysdate)
           And l.credit_date_to >= trunc(Sysdate)
           And l.enable_flag = 'Y';
      
        update_project(r_project_rec);
      Exception
        When Others Then
          sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                      Sqlerrm,
                                                         p_created_by              => p_user_id,
                                                         p_package_name            => 'prj_project_df_pkg',
                                                         p_procedure_function_name => 'create_df_project');
          Rollback To transaction_savepoint;
      End;
    End Loop;
    --delete by 5390 不会有异常
    /*EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => v_user_id,
                                                     p_package_name            => 'prj_project_df_pkg',
                                                     p_procedure_function_name => 'create_df_project');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);*/
  End create_df_project;

  --EXCEL导入项目车辆信息表
  Procedure ins_df_car_interface_temp(p_session_id Number,
                                      p_header_id  Number,
                                      p_company_id Number,
                                      p_user_id    Number) Is
  Begin
    For c_record In (Select *
                       From fnd_interface_lines l
                      Where l.header_id = p_header_id
                        And l.line_number <> 0
                        -- modified by Liyuan 添加模板校验
                        And Exists
                      (Select 1
                               From fnd_interface_lines f
                              Where f.header_id = p_header_id
                                And f.line_number = 0
                                And Trim(Replace(f.attribute_2, chr(9), '')) =
                                    '融资机构代码'
                                And Trim(Replace(f.attribute_3, chr(9), '')) =
                                    '主机厂编号'
                                And Trim(Replace(f.attribute_4, chr(9), '')) =
                                    '制造商代号'
                                And Trim(Replace(f.attribute_5, chr(9), '')) =
                                    '经销商代码'
                                And Trim(Replace(f.attribute_7, chr(9), '')) =
                                    '车型代码'
                                And Trim(Replace(f.attribute_11, chr(9), '')) =
                                    'SON号'
                                And Trim(Replace(f.attribute_12, chr(9), '')) =
                                    'VIN码'
                                And Trim(Replace(f.attribute_13, chr(9), '')) =
                                    '发动机号'
                                And Trim(Replace(f.attribute_14, chr(9), '')) =
                                    '合格证号')
                                -- end add by Liyuan    
                      Order By nvl(to_number(Trim(l.attribute_1)), l.line_id)) Loop
      init_df_car_interface_data(p_order_seq               => Trim(c_record.attribute_1), --序号
                                 p_finance_com_code        => Trim(c_record.attribute_2), --融资机构代码               
                                 p_main_fac_num            => Trim(c_record.attribute_3), --主机厂编号
                                 p_manu_code               => Trim(c_record.attribute_4), --制造商代号
                                 p_dealer_code             => Trim(c_record.attribute_5), --经销商代码
                                 p_dealer_name             => Trim(c_record.attribute_6), --经销商名称
                                 p_model_code              => Trim(c_record.attribute_7), --车型代码
                                 p_color_code              => Trim(c_record.attribute_8), --颜色编码
                                 p_car_price               => Trim(c_record.attribute_9), --车辆售价
                                 p_finance_amount          => Trim(c_record.attribute_10), --融资金额
                                 p_son_code                => Trim(c_record.attribute_11), --SON号
                                 p_item_frame_number       => Trim(c_record.attribute_12), --VIN码
                                 p_item_engine_number      => Trim(c_record.attribute_13), --发动机号
                                 p_qualified_number        => Trim(c_record.attribute_14), --合格证号
                                 p_schedule_departure_date => Trim(c_record.attribute_15), --计划发车日期
                                 p_expected_arrival_date   => Trim(c_record.attribute_16), --预计抵达日期
                                 p_session_id              => p_session_id,
                                 p_company_id              => p_company_id,
                                 p_user_id                 => p_user_id);
    
    End Loop;
  
    Delete From fnd_interface_headers h Where h.header_id = p_header_id;
    Delete From fnd_interface_lines l Where l.header_id = p_header_id;
  
  End ins_df_car_interface_temp;

  --清空批量下载当前session下的所有数据
  Procedure del_df_car_interface_temp(p_session_id Number,
                                      p_company_id Number,
                                      p_user_id    Number) Is
  Begin
    Delete From prj_project_df_car_info t
     Where t.session_id = p_session_id
       And t.create_prj_flag = 'N'
       And t.company_id = p_company_id;
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'prj_project_df_pkg',
                                                     p_procedure_function_name => 'del_df_car_interface_temp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End del_df_car_interface_temp;

  Procedure workflow_start(p_project_id Number, p_user_id Number) Is
    r_project_rec prj_project%Rowtype;
    v_instance_id Number;
    e_project_status_err Exception;
    v_document_type     prj_project.document_type%Type;
    v_document_category prj_project.document_category%Type;
    v_cond_para1        Varchar2(200);
    v_workflow_id       Number;
    v_document_info     Varchar2(30);
    v_tenant_name       Varchar2(100);
    v_billing_method    Varchar2(30);
    v_contract_number   Varchar2(30);
    v_bp_category       Varchar2(30);
    v_contract_id       Number;
    e_lock_error Exception;
    Pragma Exception_Init(e_lock_error, -54);
    v_exists_flag Varchar2(1);
  
    v_org_exist_guar_flag   Number; --法人必须有担保人
    v_license_provider_flag Number;
    v_bp_name               Varchar2(200);
    v_date_string           Varchar2(100);
    v_price_list_condition  Varchar2(30);
    v_np_sp_is_guar_flag    Number;
    v_finance_range_code    prj_project_lease_item.financial_range_code%Type;
    e_org_exist_guar_error   Exception;
    e_np_sp_not_guar_error   Exception;
    e_license_provider_error Exception;
    e_price_list_condition   Exception;
    e_attachment_error       Exception;
    v_invoice_price      Number;
    v_score_result       Number;
    v_down_payment_ratio Number;
    v_deposit_ratio      Number;
    v_request_num        Number;
    v_margin_ratio       Number;
    v_deposit_ratio_n    Number;
    v_workflow_desc      Varchar2(100);
    v_lease_channel_desc Varchar2(100);
    v_special_note       Varchar2(1000);
    v_finance_amount     Number;
    v_finance_amount_day Number;
  
    v_month_ratio          prj_project_bp.month_ratio%Type;
    v_registered_place_com prj_project_bp.registered_place_com%Type;
    v_bp_gur_np            prj_project_bp.bp_gur_np%Type;
  
  Begin
    Select *
      Into r_project_rec
      From prj_project
     Where project_id = p_project_id
       For Update Nowait;
  
    Select t.bp_name, to_char(t.creation_date, 'yyyy-mm-dd hh24:mi:ss')
      Into v_bp_name, v_date_string
      From prj_project_bp t
     Where t.project_id = p_project_id
       And t.bp_category = 'AGENT';
  
    --update by hungtehsun 4 宏菱
    Select Count(*)
      Into v_request_num
      From (Select pcf.check_id,
                   pcf.document_id,
                   pcf.document_table,
                   pck.cdd_item_id,
                   pck.send_flag,
                   pck.paper_required,
                   pck.attachment_required,
                   pck.not_applicable
              From prj_cdd_item_doc_ref pcf, prj_cdd_item_check pck
             Where pcf.document_table = 'PRJ_PROJECT'
               And pcf.document_id = p_project_id
               And pck.check_id = pcf.check_id) pp,
           prj_cdd_item pci,
           prj_cdd_item_list_grp_tab lgt,
           prj_cdd_item_tab_group tg,
           (Select sg.tab_group_id
              From prj_cdd_item_tab_sub_group sg
             Start With sg.parent_tab_group_id = 83
            Connect By Prior sg.tab_group_id = sg.parent_tab_group_id
            Union
            Select to_number(83)
              From dual) sg
     Where pci.cdd_item_id = lgt.cdd_item_id
       And lgt.tab_group_id = tg.tab_group_id
       And lgt.tab_group_id = sg.tab_group_id
       And lgt.enabled_flag = 'Y'
       And tg.enabled_flag = 'Y'
       And pci.cdd_item_id = pp.cdd_item_id(+)
       And pci.cdd_list_id =
           (Select pp.cdd_list_id
              From prj_project pp
             Where pp.project_id = p_project_id)
       And lgt.cdd_list_id = pci.cdd_list_id
       And pci.enabled_flag = 'Y'
       And lgt.important_flag = 'Y'
       And Not Exists (Select 1
              From fnd_atm_attachment_multi fam
             Where fam.table_name = 'PRJ_CDD_ITEM_CHECK'
               And fam.table_pk_value = pp.check_id)
     Order By pci.order_seq Asc;
  
    If v_request_num > 0 Then
      Raise e_attachment_error;
    End If;
  
    -- 新建项目 或者关闭项目 时清空hls_stangard_history 表中的记录
    -- add by liukang  20160316
    If r_project_rec.project_status = 'NEW' Or
       r_project_rec.project_status = 'CLOSED' Then
    
      invalid_hls_standard_history(p_project_id => p_project_id,
                                   p_user_id    => p_user_id);
    
    End If;
  
    If (r_project_rec.project_status != 'NEW' And
       r_project_rec.project_status != 'APPROVED_RETURN') Then
      Raise e_project_status_err;
    End If;
  
    v_instance_id := r_project_rec.wfl_instance_id;
  
    Begin
      Select hdt.workflow_id
        Into v_workflow_id
        From hls_document_type hdt
       Where hdt.enabled_flag = 'Y'
         And hdt.document_category = r_project_rec.document_category
         And document_type = r_project_rec.document_type
         And approval_method = 'WORK_FLOW';
    
    Exception
      When no_data_found Then
        sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'NO_DATA_FOUND_ERROR',
                                                        p_created_by              => p_user_id,
                                                        p_package_name            => 'PRJ_PROJECT_PKG',
                                                        p_procedure_function_name => 'SUBMIT_PROJECT');
      
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    End;
  
    If r_project_rec.lease_channel = '01' Then
      Begin
        Select (Select z.workflow_desc
                  From zj_wfl_workflow z
                 Where z.workflow_id = t.workflow_id) As workflow_desc
          Into v_workflow_desc
          From sys_conds_table_gen_1044 t
         Where t.function = 'PRJ500D_DDF';
      Exception
        When Others Then
          Null;
      End;
    
      --获取该申请融资额及当天总申请融资额
      Select Sum(pcd.finance_amount)
        Into v_finance_amount
        From prj_project_df_car_info pcd
       Where pcd.project_id = p_project_id;
    
      Begin
        Select Sum(nvl(pcd.finance_amount, 0))
          Into v_finance_amount_day
          From prj_project_df_car_info pcd
         Where Exists (Select 1
                  From prj_project pp
                 Where pp.project_id = pcd.project_id
                   And trunc(pp.submit_date) = trunc(Sysdate));
      
        If v_finance_amount_day Is Null Then
          v_finance_amount_day := v_finance_amount;
        Else
          v_finance_amount_day := v_finance_amount_day + v_finance_amount;
        End If;
      
      Exception
        When no_data_found Then
          v_finance_amount_day := v_finance_amount;
      End;
      --submit_date
    
      --库容业务走批次申请流程
      hls_workflow_pkg.workflow_start(p_instance_id        => v_instance_id,
                                      p_document_category  => 'PROJECT',
                                      p_document_type      => '',
                                      p_company_id         => r_project_rec.company_id,
                                      p_user_id            => p_user_id,
                                      p_function_code      => 'PRJ500D_DDF',
                                      p_parameter_1        => 'PROJECT_ID',
                                      p_parameter_1_value  => r_project_rec.project_id,
                                      p_parameter_2        => 'DOCUMENT_NUMBER',
                                      p_parameter_2_value  => r_project_rec.project_number || '-' ||
                                                              v_bp_name,
                                      p_parameter_3        => 'BUSINESS_TYPE',
                                      p_parameter_3_value  => r_project_rec.business_type,
                                      p_parameter_4        => 'DOCUMENT_TYPE',
                                      p_parameter_4_value  => r_project_rec.document_type,
                                      p_parameter_5        => 'DOCUMENT_CATEGORY',
                                      p_parameter_5_value  => r_project_rec.document_category,
                                      p_parameter_6        => 'LAYOUT_CODE',
                                      p_parameter_6_value  => 'PROJECT_CREATE_DFF',
                                      p_parameter_7        => 'COMPANY_ID',
                                      p_parameter_7_value  => r_project_rec.company_id,
                                      p_parameter_8        => 'FUNCTION_USAGE',
                                      p_parameter_8_value  => 'QUERY',
                                      p_parameter_9        => 'CALC_TYPE',
                                      p_parameter_9_value  => v_cond_para1,
                                      p_parameter_10       => 'FUNCTION_CODE',
                                      p_parameter_10_value => 'PRJ500D_DDF',
                                      p_parameter_11       => 'MAINTAIN_TYPE',
                                      p_parameter_11_value => 'UPDATE',
                                      p_parameter_12       => 'LAYOUT_CODE_READONLY',
                                      p_parameter_12_value => 'PROJECT_QUERY_DFF',
                                      p_parameter_13       => 'FUNCTION_CODE_NO_BUTTON',
                                      p_parameter_13_value => 'PRJ502D_SPECIAL',
                                      p_parameter_14       => 'P_SOURCE_NODE_ID',
                                      p_parameter_14_value => '',
                                      p_parameter_15       => 'OWNER_USER_ID',
                                      p_parameter_15_value => p_user_id,
                                      p_parameter_16       => 'PROJECT_NUMBER',
                                      p_parameter_16_value => r_project_rec.project_number,
                                      p_parameter_17       => 'BP_NAME',
                                      p_parameter_17_value => v_bp_name,
                                      p_parameter_18       => 'SUBMIT_DATE',
                                      p_parameter_18_value => to_char(Sysdate,
                                                                      'yyyy"年"mm"月"dd"日"'),
                                      p_parameter_19       => 'FINANCE_AMOUNT',
                                      p_parameter_19_value => to_char(v_finance_amount,
                                                                      'FM999,999,999,999,999.00') || '元',
                                      p_parameter_20       => 'FINANCE_AMOUNT_DAY',
                                      p_parameter_20_value => to_char(v_finance_amount_day,
                                                                      'FM999,999,999,999,999.00') || '元'
                                      /*p_parameter_4       => 'DOCUMENT_INFO',
                                                                                                                                                                                                                                    p_parameter_4_value => v_workflow_desc || '-' || r_project_rec.project_number || '-' || v_bp_name || '-' ||
                                                                                                                                                                                                                                                                                  v_lease_channel_desc|| '-' || v_special_note,*/);
    End If;
  
    --add by wcs 2014-10-28 for doc_status
    Select t.document_type, t.document_category
      Into v_document_type, v_document_category
      From prj_project t
     Where t.project_id = p_project_id;
  
    Update prj_project
       Set project_status  = 'APPROVING',
           submit_date     = Sysdate, -- 提交时间
           submitter       = p_user_id, -- 提交人
           wfl_instance_id = v_instance_id
     Where project_id = p_project_id;
  
    yonda_doc_history_pkg.yonda_insert_doc_status(p_document_id       => p_project_id,
                                                  p_document_type     => v_document_type,
                                                  p_document_category => v_document_category,
                                                  p_doc_status        => yonda_doc_history_pkg.yonda_doc_submit,
                                                  p_instance_id       => Null,
                                                  p_user_id           => p_user_id);
  
  Exception
    When e_license_provider_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.LICENSE_PROVIDER_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_price_list_condition Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.PRICE_CONDITION_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_org_exist_guar_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.ORG_NOT_EXIST_GUAR_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_np_sp_not_guar_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.NP_SP_IS_NOT_GUAR_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    When e_attachment_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.ATTACHMENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_project_status_err Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.WORKFLOW_START_PRJ_STATUS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When e_lock_error Then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PRJ_PROJECT_WORKFLOW_PKG.PRJ_PROJECT_LOCK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'prj_project_df_pkg',
                                                      p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'prj_project_df_pkg',
                                                     p_procedure_function_name => 'workflow_start');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End;

  Procedure workflow_finish(p_project_id     Number,
                            p_project_status Varchar2,
                            p_user_id        Number,
                            p_instance_id    Number) Is
    v_project_status     prj_project.project_status%Type;
    v_approval           prj_project_approval%Rowtype;
    r_project_rec        prj_project%Rowtype;
    r_bp_master_rec      hls_bp_master%Rowtype;
    v_tenant_name        Varchar2(200);
    v_business_type      Varchar2(200);
    v_billing_method     Varchar2(200);
    v_contract_id        Number;
    v_contract_number    Varchar2(30);
    v_affiliated_company Varchar2(200);
    v_exist_flag         Varchar2(1);
  Begin
  
    v_project_status := zj_wfl_core_pkg.get_parameter_value(p_instance_id    => p_instance_id,
                                                            p_parameter_name => 'PROJECT_STATUS');
  
    If v_project_status Is Null Then
      v_project_status := p_project_status;
    End If;
  
    --add by zhuxianfei   库容在在审批通过后直接生成到合同
    Select *
      Into r_project_rec
      From prj_project
     Where project_id = p_project_id;
    --end 
    If v_project_status Is Null Then
      --判断退回标志是否为Y，如果是则更新项目状态为退回
      If r_project_rec.approved_return_flag = 'Y' And
         p_project_status = 'REJECT' Then
        v_project_status := 'APPROVED_RETURN';
        --识别完之后将该状态改为N
        Update prj_project p
           Set p.approved_return_flag = 'N'
         Where project_id = p_project_id;
      Else
        v_project_status := p_project_status;
      End If;
    End If;
  
    --库容在审批通过后直接生成到合同 add by lpc 2018/1/10
    If r_project_rec.lease_channel = '01' Then
      Update prj_project p
         Set p.project_status = v_project_status,
             p.approved_date  = decode(v_project_status,
                                       'CONDITIONAL',
                                       p.approved_date,
                                       'APPROVED_RETURN',
                                       p.approved_date,
                                       Sysdate)
       Where p.project_id = p_project_id;
      Select a.bp_name
        Into v_tenant_name
        From prj_project_bp a
       Where a.project_id = p_project_id
         And a.bp_category = 'AGENT'
         And rownum < 2;
      Select a.business_type
        Into v_business_type
        From prj_project a
       Where a.project_id = p_project_id;
      --直租开租金票回租开租息票
      --DF当前逻辑只有管理费开票，使用回租利息开票规则
      Select decode(v_business_type, 'LEASE', 'L_RENTAL', 'LB_INTEREST_17')
        Into v_billing_method
        From dual;
    
      If v_project_status = 'APPROVED' Then
        If r_project_rec.document_type = 'CARLS' Then
          con_contract_df_pkg.save_contract_from_project(p_project_id        => p_project_id,
                                                         p_contract_seq      => 1,
                                                         p_bp_contract_seq   => 1,
                                                         p_con_document_type => 'CARCON',
                                                         p_con_contract_name => v_tenant_name ||
                                                                                '的合同',
                                                         p_billing_method    => v_billing_method,
                                                         p_contract_id       => v_contract_id,
                                                         p_contract_number   => v_contract_number,
                                                         p_user_id           => p_user_id);
        End If;
        --修改项目状态,DF系统仅包括提交，审批通过，审批拒绝，已结清
        Update prj_project p
           Set p.project_status   = v_project_status,
               p.approved_date    = Sysdate,
               p.last_updated_by  = p_user_id,
               p.last_update_date = Sysdate
         Where p.project_id = p_project_id;
      End If;
    End If;
  End;

  --add by lara 11355 20190214 自动关闭邮件工作流通知
  Procedure close_wfl_mail_notice(p_instance_id Number, p_user_id Number) As
    v_num Number;
  Begin
    --找到该节点对应审批人及审批记录
    For record_cur In (Select t1.user_id, t1.record_id
                         From zj_wfl_instance_node_rcpt_v t1
                        Where t1.instance_id = p_instance_id
                          And t1.record_type = 'NOTICE'
                          And Exists
                        (Select 1
                                 From zj_wfl_workflow_node n
                                Where Exists
                                (Select 1
                                         From zj_wfl_workflow w
                                        Where w.workflow_code = 'WFL_PRJ_DEF'
                                          And n.workflow_id = w.workflow_id)
                                  And n.notice_mail_flag = 'Y'
                                  And n.node_id = t1.node_id)) Loop
      v_num := zj_wfl_core_pkg.workflow_approve(p_rcpt_record_id   => record_cur.record_id,
                                                p_node_action_id   => '',
                                                p_comment          => '自动关闭',
                                                p_comment_text_out => '',
                                                p_user_id          => record_cur.user_id);
    End Loop;
  
  Exception
    When Others Then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  Sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'prj_project_df_pkg',
                                                     p_procedure_function_name => 'close_wfl_mail_notice');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  End close_wfl_mail_notice;
  --end add by lara 11355 20190214 自动关闭邮件工作流通知

End prj_project_df_pkg;
/
