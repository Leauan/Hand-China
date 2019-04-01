--保证合同编号
select CONTENT_NUM  as CONTRACT_NUMBER
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
  --甲方 法定代表人
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
                       
  -- 联系人 项目经理
   select cc.employee_name as EMPLOYEE_NAME
     from con_contract_v cc
    where cc.contract_id = {$CONTRACT_ID$}
    
    
  -- 手机
  select ee.mobil as EMPLOYEE_MOBILE
    from exp_employees ee
   where ee.employee_code =
         (select cc.employee_code
            from con_contract_v cc
           where cc.contract_id = {$CONTRACT_ID$})

------------------------------------------------------------------------------------------------------
--保证人

select pbg.bp_name as ENSURE_BP_NAME1
  from prj_bp_guarantor_lv pbg
  left join prj_project_lv pp
    on pbg.project_id = pp.project_id
 where pbg.ref_v03 = 'ENSURE'             
   and pp.contract_id ={$CONTRACT_ID$}
   and rownum= 1
 
 --住所
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

--   COMMUNICATION_METHODS     通讯方式
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
                         
--LEGAL_PERSON    保证人法定代表人
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

--PHONE   电话
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
 --FAX   传真
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
  --EMAIL   电邮
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
--CONTACT_PERSON   联系人
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


--CELL_PHONE   手机
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
      
-- ADDRESS    经常居住地地址
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


-- ID_CARD_NO    出卖人身份证
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
   
 --BP_ID   丙方（法人）承租人
select ccb.bp_name as TENANT_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id = {$CONTRACT_ID$}
   and rownum =1

-- ADDRESS    丙方（法人）承租人  住处   
select hbma.address as TENANT_ORG_ADDRESS
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'REGISTERED_ADDRESS'  


--   COMMUNICATION_METHODS   丙方（法人）  通讯方式
select hbm.communication_methods as TENANT_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'    
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})   
 
 --LEGAL_PERSON    丙方（法人）法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON1
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   丙方（法人）电话
select hbma.phone as TENANT_ORG_PHONE
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb 
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG' 
                       and ccb.contract_id = {$CONTRACT_ID$}) 
                       
 --FAX   丙方（法人）传真
select hbma.fax as TENANT_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})

  
  --EMAIL   丙方（法人）电邮
select hbma.email as TENANT_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb   
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'  
                       and ccb.contract_id = {$CONTRACT_ID$})                                      
 

 --CONTACT_PERSON   丙方（法人）联系人
select hbmci.contact_person as TENANT_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   丙方（法人）手机
select hbmci.cell_phone as TENANT_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1
 
 ------------------------------------------------------------------------------     丙方自然人
 
  --BP_ID   丙方（自然人）承租人
select ccb.bp_name as TENANT_NP_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.bp_class = 'NP' 
   and ccb.contract_id = {$CONTRACT_ID$}

-- ID_CARD_NO    丙方（自然人）承租人身份证

select hbm.id_card_no as TENANT_NP_ID_CARD_NO
  from hls_bp_master_lv hbm    
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    丙方（自然人）经常居住地地址
 select address as TENANT_NP_ADDRESS
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
         

 
--PHONE   丙方（自然人）电话
  select phone as TENANT_NP_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
 --FAX  丙方（自然人）传真
 select fax as TENANT_NP_FAX
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 
--EMAIL  丙（自然人）电邮
 select email as TENANT_NP_EMAIL
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP'
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  丙方（自然人）手机
 select cell_phone as TENANT_NP_CELL_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT'
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'                             
     
 --融资租赁保证合同   
select CONTENT_NUM as CONTRACT_NUMBER1
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
 --业务类型 business_type 
select cc.business_type_n as BUSINESS_TYPE
  FROM con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}

--租赁期限
 select decode(cc.annual_pay_times,
              1,
              cc.lease_times * 12,
              4,
              cc.lease_times * 3,
              cc.lease_times) LEASE_TIMES
  from con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}

 --租赁本金
 select sum(ccc.principal) PRINCIPAL
   from con_contract_cashflow_lv ccc
  where ccc.contract_id = {$CONTRACT_ID$}
  
--租赁利息
select sum(ccc.interest) INTEREST
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}

--总计
select sum(ccc.principal) + sum(ccc.interest) TOTAL_AMOUNT
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
    
 
--根据担保人注册地址是否为武汉来区分
                                       
 select decode(hbma.city_id_n, '武汉市', 1, 2) as ENSURE_SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select pbg.bp_id
                        from prj_bp_guarantor_lv pbg
                        left join prj_project_lv pp
                          on pbg.project_id = pp.project_id
                         where pbg.ref_v03 = 'ENSURE'
                          and pbg.bp_class ='ORG'
                         and pp.contract_id = {$CONTRACT_ID$}
                         and rownum = 1)
    and hbma.address_type = 'REGISTERED_ADDRESS'    --注册地址
    
    --合同份数
  SELECT nvl(CON_CONTENT_COUNTS, 2) as CON_CONTENT_COUNTS
    FROM con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}    
    
   
 select '武汉光谷融资租赁有限公司' as COMPANY_NAME from dual
    
    
    
    
    
    
    
    
    
