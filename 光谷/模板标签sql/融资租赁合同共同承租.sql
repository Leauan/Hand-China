--�������޺�ͬ��ͬ����

--�������޺�ͬ��ͬ�����ͬ���
select CONTENT_NUM as CONTRACT_NUMBER
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
 --����ͬ������
--BP_ID   �ҷ������ˣ���������
select ccb.bp_name as TENANT_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1
   
   --����
    SELECT ccb.bp_name as TENANT_SEC_BP_NAME
   FROM con_contract_bp_lv ccb
  where ccb.contract_id = {$CONTRACT_ID$}
    and ccb.bp_category = 'TENANT_SEC'
    and rownum = 1
    
    --�׷� ����������
 select name as ORG_NAME
  from exp_employees
 where employee_id = (select employee_id
                        from ((select employee_id
                                 from exp_employee_assigns
                                where position_id =
                                      (select position_id
                                         from exp_org_position
                                        where position_code = '10050')
                                order by creation_date desc))
                       where rownum = 1)
                       
  -- ��ϵ�� ��Ŀ����
   select cc.employee_name as EMPLOYEE_NAME
     from con_contract_v cc
    where cc.contract_id = {$CONTRACT_ID$}
    
    
  -- �ֻ�
  select ee.mobil as EMPLOYEE_MOBILE
    from exp_employees ee
   where ee.employee_code =
         (select cc.employee_code
            from con_contract_v cc
           where cc.contract_id = {$CONTRACT_ID$})

------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------- 
--�������˻�����Ϣ
 
--����ͬ������
--BP_ID   �ҷ������ˣ�������
select ccb.bp_name as TENANT_BP_NAME1
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1

-- ADDRESS    �ҷ������ˣ�������  ס��   
select hbma.address as TENANT_ORG_ADDRESS
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  


--   COMMUNICATION_METHODS   �ҷ������ˣ�  ͨѶ��ʽ
select hbm.communication_methods as TENANT_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'    
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})   
 
 --LEGAL_PERSON    �ҷ������ˣ�����������
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   �ҷ������ˣ��绰
select hbma.phone as TENANT_ORG_PHONE
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb 
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG' 
                       and ccb.contract_id = {$CONTRACT_ID$}) 
   and hbma.address_type = 'COMPANY_ADDRESS'  
                      
 --FAX   �ҷ������ˣ�����
select hbma.fax as TENANT_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})
  and hbma.address_type = 'COMPANY_ADDRESS'  

  
  --EMAIL   �ҷ������ˣ�����
select hbma.email as TENANT_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb   
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'  
                       and ccb.contract_id = {$CONTRACT_ID$})                                      
   and hbma.address_type = 'COMPANY_ADDRESS'  
   
--CONTACT_PERSON   �ҷ������ˣ���ϵ��
select hbmci.contact_person as TENANT_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   �ҷ������ˣ��ֻ�
select hbmci.cell_phone as TENANT_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1   
  
 -------------------------------------------------------------------

-- ID_CARD_NO    �ҷ�����Ȼ�ˣ����������֤

select hbm.id_card_no as TENANT_NP_ID_CARD_NO
  from hls_bp_master_lv hbm    
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    �ҷ�����Ȼ�ˣ�������ס�ص�ַ
 select address as TENANT_NP_ADDRESS
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
         

 
--PHONE   �ҷ�����Ȼ�ˣ��绰
  select phone as TENANT_NP_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
 --FAX  �ҷ�����Ȼ�ˣ�����
 select fax as TENANT_NP_FAX
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 
--EMAIL  �ҷ�����Ȼ�ˣ�����
 select email as TENANT_NP_EMAIL
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP'
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  �ҷ�����Ȼ�ˣ��ֻ�
 select cell_phone as TENANT_NP_CELL_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT'
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'                             
 
 -----------------------------------------------------------------------------------
   --����   �γ���������
 SELECT ccb.bp_name as TENANT_SEC_BP_NAME
   FROM con_contract_bp_lv ccb
  where ccb.contract_id = {$CONTRACT_ID$}
    and ccb.bp_category = 'TENANT_SEC'
    and rownum = 1
-- ADDRESS    ���������ˣ��μ�������  ס��   
select hbma.address as TENANT_SEC_ORG_ADDRESS
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT_SEC'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'


--   COMMUNICATION_METHODS   �����ˣ�  ͨѶ��ʽ
select hbm.communication_methods as TENANT_SEC_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT_SEC'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
 
 --LEGAL_PERSON    �����ˣ�����������
select hbm.legal_person as TENANT_SEC_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT_SEC'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   �����ˣ��绰
select hbma.phone as TENANT_SEC_ORG_PHONE
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT_SEC'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'
                      
 --FAX   �����ˣ�����
select hbma.fax as TENANT_SEC_ORG_FAX
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT_SEC'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'

  
  --EMAIL   �����ˣ�����
select hbma.email as TENANT_SEC_ORG_EMAIL
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT_SEC'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'
   
--CONTACT_PERSON   �����ˣ���ϵ��
select hbmci.contact_person as TENANT_SEC_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb
         where ccb.bp_category = 'TENANT_SEC'
           and ccb.bp_class = 'ORG'
           and ccb.contract_id = {$CONTRACT_ID$})
   and rownum = 1


--CELL_PHONE   �����ˣ��ֻ�
select hbmci.cell_phone as TENANT_SEC_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT_SEC' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1   
  
 -------------------------------------------------------------------


-- ID_CARD_NO    ����Ȼ�ˣ����������֤

select hbm.id_card_no as TENANT_SEC_NP_ID_CARD_NO
  from hls_bp_master_lv hbm    
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT_SEC' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    ����Ȼ�ˣ�������ס�ص�ַ
 select address as TENANT_SEC_NP_ADDRESS
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT_SEC' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
         

 
--PHONE   ����Ȼ�ˣ��绰
  select phone as TENANT_SEC_NP_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT_SEC' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
 --FAX  ����Ȼ�ˣ�����
 select fax as TENANT_SEC_NP_FAX
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT_SEC' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 
--EMAIL  ����Ȼ�ˣ�����
 select email as TENANT_SEC_NP_EMAIL
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT_SEC' 
                    and ccb.bp_class = 'NP'
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  �����μ�����Ȼ�ˣ��ֻ�
 select cell_phone as TENANT_SEC_NP_CELL_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT_SEC'
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'           

--��������Ͷ�� ����
 select cc.insure_type as INSURE_TYPE
   from con_contract_lv cc
  where cc.contract_id = {$CONTRACT_ID$}


--�������ܼۿ�
select change_number_to_rmb(round(nvl(ccc.due_amount, 0), 2)) as DUE_AMOUNT_0_RMB
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0

select ccc.due_amount as DUE_AMOUNT_0
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0  
   
  --����������Ƿ�����������ѡ��ʽ��
select decode(nvl(ccc.due_amount, 0), 0, 2, 1) as SELECT_DUE_AMOUNT_8
  from con_contract_cashflow_lv ccc
 where ccc.cf_item = 8
   and ccc.contract_id =  {$CONTRACT_ID$}
  
 --������
 select ccc.due_amount as DUE_AMOUNT_8
  from con_contract_cashflow_lv ccc
 where ccc.cf_item = 8
   and ccc.contract_id =  {$CONTRACT_ID$}  
   
   
 --����ͬ���µ��������ʲ����µ�    �ַ�ʽ
 select decode(nvl(hfch.int_rate_type, ''), 'FIXED', 1, 2) as INT_RATE_TYPE
   from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
  where cc.contract_id = pq.document_id
    and pq.document_category = 'CONTRACT'
    and pq.calc_session_id = hfch.calc_session_id
    and cc.contract_id = {$CONTRACT_ID$}
 
   --��������Ϊ�̶����ʣ�����Ϊ�����ʣ�
 select round(hfch.int_rate,4)*100 || '%' as FIXED_INT_RATE
   from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
  where cc.contract_id = pq.document_id
    and pq.document_category = 'CONTRACT'
    and pq.calc_session_id = hfch.calc_session_id
    and hfch.int_rate_type = 'FIXED'
    and cc.contract_id = {$CONTRACT_ID$}
   
     --��������Ϊ�������ʣ�
 select round(hfch.int_rate,4)*100 || '%' as FLOATING_INT_RATE
   from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
  where cc.contract_id = pq.document_id
    and pq.document_category = 'CONTRACT'
    and pq.calc_session_id = hfch.calc_session_id
    and hfch.int_rate_type = 'FLOATING'
    and cc.contract_id ={$CONTRACT_ID$}

--�����ϸ�����
select round(hfch.int_rate_fixing_range,4)*100 || '%' as INT_RATE_FIXING_RANGE
  from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
 where cc.contract_id = pq.document_id
   and pq.document_category = 'CONTRACT'
   and pq.calc_session_id = hfch.calc_session_id
   and hfch.int_rate_type = 'FLOATING'
   and cc.contract_id = {$CONTRACT_ID$}
   

--����
SELECT  CC.tt_bank_account_name as GG_TT_BANK_ACCOUNT_NAME
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = {$CONTRACT_ID$}

--�˺�
SELECT CC.tt_bank_account_num as GG_TT_BANK_ACCOUNT_NUM
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = {$CONTRACT_ID$}

--������
SELECT CC.tt_bank_branch_name as GG_TT_BANK_BRANCH_NAME
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = 41

--��֤��
select change_number_to_rmb(round(nvl(cc.deposit, 0), 2)) as DEPOSIT_RMB
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}
 
 select round(nvl(cc.deposit, 0), 2) as DEPOSIT
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}

--������
select change_number_to_rmb(round(nvl(cc.lease_charge, 0), 2)) as LEASE_CHARGE_RMB
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}

select round(nvl(cc.lease_charge, 0), 2) as LEASE_CHARGE
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}
 
 --��16������
 --16.1��֤��
 select wmsys.wm_concat(pbg.bp_name || pbg.ref_v03_n) BP_NAME_ENSURE
   from prj_bp_guarantor_lv     pbg,
        prj_project_mortgage_lv ppm,
        con_contract_bp_lv      ccb
  where pbg.project_id = ppm.project_id
    and pbg.bp_name = ppm.mortgagor_name
    and ccb.bp_id = pbg.bp_id
    and pbg.ref_v03 = 'ENSURE'
    and ccb.contract_id = {$CONTRACT_ID$}

--16.2��Ѻ�� 
select wmsys.wm_concat(pbg.bp_name || ' ' || pbg.ref_v03_n || ' ' ||
                       ppm.mortgage_name) BP_NAME_HYPOTHECATE
  from prj_bp_guarantor_lv     pbg,
       prj_project_mortgage_lv ppm,
       con_contract_bp_lv      ccb
 where pbg.project_id = ppm.project_id
   and pbg.bp_name = ppm.mortgagor_name
   and ccb.bp_id = pbg.bp_id
   and pbg.ref_v03 = 'HYPOTHECATE'
   and ccb.contract_id = {$CONTRACT_ID$}
                                          
--16.3��Ѻ��
select wmsys.wm_concat(pbg.bp_name || ' ' || pbg.ref_v03_n || ' ' ||
                       ppm.mortgage_name) BP_NAME_JOINT
  from prj_bp_guarantor_lv     pbg,
       prj_project_mortgage_lv ppm,
       con_contract_bp_lv      ccb
 where pbg.project_id = ppm.project_id
   and pbg.bp_name = ppm.mortgagor_name
   and ccb.bp_id = pbg.bp_id
   and pbg.ref_v03 = 'JOINT'
   and ccb.contract_id = {$CONTRACT_ID$}
                                           
--16.4������                                          ��
  
 
 --���ڵ�ַѡ��

  select decode(nvl(hbma.city_id_n,2), '�人��', 1, 2) as SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.contract_id = 41
                    )
    and hbma.address_type = 'REGISTERED_ADDRESS' 
    
    
   --��ͬ����
  SELECT nvl(CON_CONTENT_COUNTS, 2) as CON_CONTENT_COUNTS
    FROM con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}       
   
 --  SUBJECT_MATTER_LIST1
   --�������嵥
    select ccli.full_name,  
          ccli.specification,
          ccli.quantity,   
           ccli.price,     
           ccli.description   
     from prj_project_lease_item_lv ccli 
     left join Prj_Project_Lv pp on ccli.project_id =pp.project_id
     where pp.lease_channel in  (55,70,80,99)
     and ccli.contract_id = {$CONTRACT_ID$}
--������ͬ���
  select CONTENT_NUM  as SALES_CONTRACT_NUMBER2
   from con_contract_content CCC
  where templet_id = (select CCT.TEMPLET_ID
                        from con_clause_templet cct
                       where cct.templet_code = 'SALES_CONTRACT')
    AND CONTRACT_ID = {$CONTRACT_ID$}
    
--�������޺�ͬ��ͬ�����ͬ���
select CONTENT_NUM as CONTRACT_NUMBER1
  from con_contract_content
 where content_id = {$CONTENT_ID$}

--���֧����  
-- RENT_PAYMENT_FORM
 select ccc.due_date,
       ccc.times,
       ccc.due_amount,
       ccc.interest,
       ccc.principal,
       ccc.outstanding_rental_tax_incld
  from con_contract_cashflow_lv ccc
 where ccc.cf_item = 1
   and ccc.contract_id = {$CONTRACT_ID$}
 order by ccc.due_date asc

    
