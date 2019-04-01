--��֤��ͬ���
select CONTENT_NUM  as CONTRACT_NUMBER
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
  --�׷� ����������
 select name as ORG_NAME1
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
--��֤��

select pbg.bp_name as ENSURE_BP_NAME1
  from prj_bp_guarantor_lv pbg
  left join prj_project_lv pp
    on pbg.project_id = pp.project_id
 where pbg.ref_v03 = 'ENSURE'             
   and pp.contract_id ={$CONTRACT_ID$}
   and rownum= 1
 
 --ס��
 select hbma.address as ENSURE_ADDRESS
   from hls_bp_master_address_lv hbma
  where hbma.bp_id = (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                       where pbg.ref_v03 = 'ENSURE'
                         and pbg.bp_class = 'ORG'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)
    and hbma.address_type = 'REGISTERED_ADDRESS'

--   COMMUNICATION_METHODS     ͨѶ��ʽ
select hbm.communication_methods as ENSURE_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select pbg.bp_id
                      from prj_bp_guarantor_lv pbg
                      left join prj_project_lv pp
                        on pbg.project_id = pp.project_id
                     where pbg.ref_v03 = 'ENSURE'
                       and pbg.bp_class = 'ORG'
                       and pp.contract_id = {$CONTRACT_ID$}
                       and rownum = 1)
                         
--LEGAL_PERSON    ��֤�˷���������
select hbm.legal_person as ENSURE_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select pbg.bp_id
                      from prj_bp_guarantor_lv pbg
                      left join prj_project_lv pp
                        on pbg.project_id = pp.project_id
                     where pbg.ref_v03 = 'ENSURE'
                       and pbg.bp_class = 'ORG'
                       and pp.contract_id = {$CONTRACT_ID$}
                       and rownum = 1)

--PHONE   �绰
select hbma.phone as ENSURE_ORG_PHONE
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select pbg.bp_id
                       from prj_bp_guarantor_lv pbg
                       left join prj_project_lv pp
                         on pbg.project_id = pp.project_id
                      where pbg.ref_v03 = 'ENSURE'
                        and pp.contract_id = {$CONTRACT_ID$}
                        and rownum = 1)
   and hbma.address_type in ('COMPANY_ADDRESS', 'HOUSE_ADDRESS')
   and rownum = 1
 --FAX   ����
select hbma.fax as ENSURE_ORG_FAX
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select pbg.bp_id
                       from prj_bp_guarantor_lv pbg
                       left join prj_project_lv pp
                         on pbg.project_id = pp.project_id
                      where pbg.ref_v03 = 'ENSURE'
                        and pp.contract_id = {$CONTRACT_ID$}
                        and rownum = 1)
   and hbma.address_type in ('COMPANY_ADDRESS', 'HOUSE_ADDRESS')
   and rownum = 1
  --EMAIL   ����
select hbma.email as ENSURE_ORG_EMAIL
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select pbg.bp_id
                       from prj_bp_guarantor_lv pbg
                       left join prj_project_lv pp
                         on pbg.project_id = pp.project_id
                      where pbg.ref_v03 = 'ENSURE'
                        and pp.contract_id = {$CONTRACT_ID$}
                        and rownum = 1)
   and hbma.address_type in ('COMPANY_ADDRESS', 'HOUSE_ADDRESS')
   and rownum = 1
--CONTACT_PERSON   ��ϵ��
select hbmci.contact_person as ENSURE_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
      (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                       where pbg.ref_v03 = 'ENSURE'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)
         and rownum =1


--CELL_PHONE   �ֻ�
select hbmci.cell_phone as ENSURE_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                       where pbg.ref_v03 = 'ENSURE'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)
      and rownum =1
      
-- ADDRESS    ������ס�ص�ַ
 select address as ENSURE_NP_ADDRESS
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id = (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                       where pbg.ref_v03 = 'ENSURE'
                        and pbg.bp_class ='NP'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)                     
    and hbma.address_type = 'HOUSE_ADDRESS' 


-- ID_CARD_NO    ���������֤
select hbm.id_card_no as ENSURE_NP_ID_CARD_NO
  from hls_bp_master_lv hbm   
 where hbm.bp_id = (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                       where pbg.ref_v03 = 'ENSURE'
                        and pbg.bp_class ='NP'
                         and pp.contract_id =41
                         and rownum = 1)                     
  
----------------------------------------------------------------- 
   
 --BP_ID   ���������ˣ�������
select ccb.bp_name as TENANT_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id = {$CONTRACT_ID$}
   and rownum =1

-- ADDRESS    ���������ˣ�������  ס��   
select hbma.address as TENANT_ORG_ADDRESS
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'REGISTERED_ADDRESS'  


--   COMMUNICATION_METHODS   ���������ˣ�  ͨѶ��ʽ
select hbm.communication_methods as TENANT_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'    
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})   
 
 --LEGAL_PERSON    ���������ˣ�����������
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON1
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
     
 --�������ޱ�֤��ͬ   
select CONTENT_NUM as CONTRACT_NUMBER1
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
 --ҵ������ business_type 
select cc.business_type_n as BUSINESS_TYPE
  FROM con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}

--��������
 select decode(cc.annual_pay_times,
              1,
              cc.lease_times * 12,
              4,
              cc.lease_times * 3,
              cc.lease_times) LEASE_TIMES
  from con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}

 --���ޱ���
 select sum(ccc.principal) PRINCIPAL
   from con_contract_cashflow_lv ccc
  where ccc.contract_id = {$CONTRACT_ID$}
  
--������Ϣ
select sum(ccc.interest) INTEREST
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}

--�ܼ�
select sum(ccc.principal) + sum(ccc.interest) TOTAL_AMOUNT
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
    
 
--���ݵ�����ע���ַ�Ƿ�Ϊ�人������
                                       
 select decode(hbma.city_id_n, '�人��', 1, 2) as ENSURE_SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                         where pbg.ref_v03 = 'ENSURE'
                          and pbg.bp_class ='ORG'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)
    and hbma.address_type = 'REGISTERED_ADDRESS'    --ע���ַ
    
    --��ͬ����
  SELECT nvl(CON_CONTENT_COUNTS, 2) as CON_CONTENT_COUNTS
    FROM con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}    
    
   
 select '�人��������������޹�˾' as COMPANY_NAME from dual
    
    
    
    
    
    
    
    
    
