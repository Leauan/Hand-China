--ORG_BP_ID   �׷������ˣ�������
select ccb.bp_name as VENDER_ORG_BP_NAME
  from con_contract_bp_lv ccb
 where ccb.bp_category = 'VENDER'
   and ccb.contract_id = 78

-- ADDRESS    �׷������ˣ�������ס��   
select hbma.address AS VENDER_ORG_ADDRESS   
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  

--   COMMUNICATION_METHODS   �׷������ˣ�  ͨѶ��ʽ
select hbm.communication_methods as VENDER_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'VENDER'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})

--LEGAL_PERSON    �׷������ˣ�����������
select hbm.legal_person as VENDER_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'VENDER'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   �׷������ˣ��绰
select hbma.phone as VENDER_ORG_PHONE
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'                       
 --FAX   �׷������ˣ�����
select hbma.fax as VENDER_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'VENDER'  
                       and ccb.bp_class = 'ORG'   
                       and ccb.contract_id = {$CONTRACT_ID$})
 and hbma.address_type = 'COMPANY_ADDRESS'  
  
  --EMAIL   �׷������ˣ�����
select hbma.email as VENDER_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'VENDER'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})                                       
  and hbma.address_type = 'COMPANY_ADDRESS'  

--CONTACT_PERSON   �׷������ˣ���ϵ��
select hbmci.contact_person as VENDER_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'VENDER' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   �׷������ˣ��ֻ�
select hbmci.cell_phone as VENDER_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'VENDER' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1
----------------------------------------------------------------------------------


--BP_ID   �׷�����Ȼ�ˣ�������
select ccb.bp_name as VENDER_NP_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'VENDER' 
   and ccb.bp_class = 'NP' 
   and ccb.contract_id = {$CONTRACT_ID$}

-- ID_CARD_NO    �׷�����Ȼ�ˣ����������֤

select hbm.id_card_no as VENDER_NP_ID_CARD_NO
  from hls_bp_master_lv hbm   
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    �׷�����Ȼ�ˣ�������ס�ص�ַ
 select address as VENDER_NP_ADDRESS
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id = (select ccb.bp_id
                        from CON_CONTRACT_BP_LV ccb 
                       where ccb.bp_category = 'VENDER' 
                         and ccb.bp_class = 'NP' 
                         and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 
  
 
--PHONE   �׷�����Ȼ�ˣ��绰
 select phone as VENDER_NP_PHONE
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id =
        (select ccb.bp_id
           from CON_CONTRACT_BP_LV ccb 
          where ccb.bp_category = 'VENDER'
            and ccb.bp_class = 'NP' 
            and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 
 --FAX  �׷�����Ȼ�ˣ�����
select fax as VENDER_NP_FAX
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb 
                      where ccb.bp_category = 'VENDER' 
                        and ccb.bp_class = 'NP' 
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'HOUSE_ADDRESS' 

--EMAIL  �׷�����Ȼ�ˣ�����
 select email as VENDER_NP_EMAIL
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id =
        (select ccb.bp_id
           from CON_CONTRACT_BP_LV ccb 
          where ccb.bp_category = 'VENDER' 
            and ccb.bp_class = 'NP' 
            and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  �׷�����Ȼ�ˣ��ֻ�
 select cell_phone as VENDER_NP_CELL_PHONE
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id =
        (select ccb.bp_id
           from CON_CONTRACT_BP_LV ccb 
          where ccb.bp_category = 'VENDER' 
            and ccb.bp_class = 'NP' 
            and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 
 
 ------------------------------------------------------------------
 --�ҷ� ����������
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
 ---------------------------------------------------------------------
 --BP_ID   ���������ˣ�������
select ccb.bp_name as TENANT_ORG_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.bp_class = 'ORG' 
   and ccb.contract_id = {$CONTRACT_ID$}

-- ADDRESS    ���������ˣ�������  ס��   
select hbma.address as TENANT_ORG_ADDRESS
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  


--   COMMUNICATION_METHODS   ���������ˣ�  ͨѶ��ʽ
select hbm.communication_methods as TENANT_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'    
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})   
 
 --LEGAL_PERSON    ���������ˣ�����������
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   ���������ˣ��绰
select hbma.phone as TENANT_ORG_PHONE
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb 
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG' 
                       and ccb.contract_id = {$CONTRACT_ID$}) 
                       
 --FAX   ���������ˣ�����
select hbma.fax as TENANT_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})

  
  --EMAIL   ���������ˣ�����
select hbma.email as TENANT_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb   
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'  
                       and ccb.contract_id = {$CONTRACT_ID$})                                      
 

 --CONTACT_PERSON   ���������ˣ���ϵ��
select hbmci.contact_person as TENANT_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   ���������ˣ��ֻ�
select hbmci.cell_phone as TENANT_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1
 
 ------------------------------------------------------------------------------     ������Ȼ��
 
  --BP_ID   ��������Ȼ�ˣ�������
select ccb.bp_name as TENANT_NP_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.bp_class = 'NP' 
   and ccb.contract_id = {$CONTRACT_ID$}

-- ID_CARD_NO    ��������Ȼ�ˣ����������֤

select hbm.id_card_no as TENANT_NP_ID_CARD_NO
  from hls_bp_master_lv hbm    
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    ��������Ȼ�ˣ�������ס�ص�ַ
 select address as TENANT_NP_ADDRESS
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
         

 
--PHONE   ��������Ȼ�ˣ��绰
  select phone as TENANT_NP_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
 --FAX  ��������Ȼ�ˣ�����
 select fax as TENANT_NP_FAX
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 
--EMAIL  ������Ȼ�ˣ�����
 select email as TENANT_NP_EMAIL
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP'
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  ��������Ȼ�ˣ��ֻ�
 select cell_phone as TENANT_NP_CELL_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT'
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'                             
 
 ---------------------------------------------------------------------------------------------------
 --���������޺�ͬ����� CONTRACT_NUMBER
  select contract_number as CONTRACT_NUMBER1
    from con_contract_lv
   where contract_id = {$CONTRACT_ID$}

--������ܼۿ�
select change_number_to_rmb(round(nvl(ccc.due_amount, 0), 2)) as DUE_AMOUNT_0_RMB
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0

select ccc.due_amount as DUE_AMOUNT_0
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0

--6.1 ������Ϣ
--�˺�
 select hbmba.bank_account_num as VENDER_BANK_ACCOUNT_NUM
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')
--����
 select hbmba.bank_account_name as VENDER_BANK_ACCOUNT_NAME
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')
 
 --������
   select hbmba.bank_full_name as VENDER_BANK_FULL_NAME
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')                        

--�׸���
select ccc.due_amount as DUE_AMOUNT_2
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 2

--9.3 ���յڼ��ֽ��
--���ݳ�����ע���ַ�Ƿ�Ϊ�人������
                                       
 select decode(hbma.city_id_n, '�人��', 1, 2) as SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'COMPANY_ADDRESS' 


--�׷����� ע���ַ
select hbma.address as VENDER_ADDRESS
  from hls_bp_master_address_lv hbma   
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER' 
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  

 --������� ����������
 select name as ORG_NAME_1
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

--��������
 --LEGAL_PERSON    ���������ˣ�����������
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON_1
  from hls_bp_master_lv   hbm                   
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'   
                       and ccb.contract_id = {$CONTRACT_ID$})

-- ��ͬǩ��ҳADDRESS    ��˾��ַ  
select hbma.address  as TENANT_ORG_ADDRESS_1
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  
 
 --LEGAL_PERSON    ���� �׷������ˣ�����������
select hbm.legal_person as VENDER_ORG_LEGAL_PERSON1
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'VENDER'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})  
  
 --���� �׷� ע���ַ
select hbma.address as VENDER_ADDRESS1
  from hls_bp_master_address_lv hbma   
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER' 
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  
   
    --���� ������� ����������
 select name as ORG_NAME_2
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
   
 --��������
 --LEGAL_PERSON    ���� ���������ˣ�����������
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON_2
  from hls_bp_master_lv   hbm                   
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'   
                       and ccb.contract_id = {$CONTRACT_ID$})

-- ��ͬǩ��ҳADDRESS    ��˾��ַ  
select hbma.address  as TENANT_ORG_ADDRESS_2
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  
 
   --������嵥
   --select * from prj_project_lv
   --select * from prj_project_lease_item_lv
   select ccli.full_name,
          ccli.specification,
          ccli.vender_name,
         ccli.creation_date��
          ccli.quantity,
           ccli.price
     from prj_project_lease_item_lv ccli
    where ccli.contract_id = {$CONTRACT_ID$}
