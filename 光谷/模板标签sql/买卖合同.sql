--ORG_BP_ID   甲方（法人）出卖人
select ccb.bp_name as VENDER_ORG_BP_NAME
  from con_contract_bp_lv ccb
 where ccb.bp_category = 'VENDER'
   and ccb.contract_id = {$CONTRACT_ID$}

-- ADDRESS    甲方（法人）出卖人住所   
select hbma.address AS VENDER_ORG_ADDRESS   
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  

--   COMMUNICATION_METHODS   甲方（法人）  通讯方式
select hbm.communication_methods as VENDER_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'VENDER'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})

--LEGAL_PERSON    甲方（法人）法定代表人
select hbm.legal_person as VENDER_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'VENDER'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   甲方（法人）电话
select hbma.phone as VENDER_ORG_PHONE
  from hls_bp_master_address_lv hbma
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER'
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'COMPANY_ADDRESS'                       
 --FAX   甲方（法人）传真
select hbma.fax as VENDER_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'VENDER'  
                       and ccb.bp_class = 'ORG'   
                       and ccb.contract_id = {$CONTRACT_ID$})
 and hbma.address_type = 'COMPANY_ADDRESS'  
  
  --EMAIL   甲方（法人）电邮
select hbma.email as VENDER_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'VENDER'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})                                       
  and hbma.address_type = 'COMPANY_ADDRESS'  

--CONTACT_PERSON   甲方（法人）联系人
select hbmci.contact_person as VENDER_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'VENDER' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   甲方（法人）手机
select hbmci.cell_phone as VENDER_ORG_CELL_PHONE
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'VENDER' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
      and rownum =1
      
 --------------------------------------------------------------------------     
      
--BP_ID   甲方（自然人）出卖人
select ccb.bp_name as VENDER_NP_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'VENDER' 
   and ccb.bp_class = 'NP' 
   and ccb.contract_id = {$CONTRACT_ID$}

-- ID_CARD_NO    甲方（自然人）出卖人身份证

select hbm.id_card_no as VENDER_NP_ID_CARD_NO
  from hls_bp_master_lv hbm   
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'VENDER' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    甲方（自然人）经常居住地地址
 select address as VENDER_NP_ADDRESS
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id = (select ccb.bp_id
                        from CON_CONTRACT_BP_LV ccb 
                       where ccb.bp_category = 'VENDER' 
                         and ccb.bp_class = 'NP' 
                         and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 
  
 
--PHONE   甲方（自然人）电话
 select phone as VENDER_NP_PHONE
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id =
        (select ccb.bp_id
           from CON_CONTRACT_BP_LV ccb 
          where ccb.bp_category = 'VENDER'
            and ccb.bp_class = 'NP' 
            and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 
 --FAX  甲方（自然人）传真
select fax as VENDER_NP_FAX
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb 
                      where ccb.bp_category = 'VENDER' 
                        and ccb.bp_class = 'NP' 
                        and ccb.contract_id = {$CONTRACT_ID$})
   and hbma.address_type = 'HOUSE_ADDRESS' 

--EMAIL  甲方（自然人）电邮
 select email as VENDER_NP_EMAIL
   from hls_bp_master_address_lv hbma 
  where hbma.bp_id =
        (select ccb.bp_id
           from CON_CONTRACT_BP_LV ccb 
          where ccb.bp_category = 'VENDER' 
            and ccb.bp_class = 'NP' 
            and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  甲方（自然人）手机
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
 --乙方 法定代表人
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
                       
  --乙方 联系人 项目经理
   select cc.employee_name as EMPLOYEE_NAME
     from con_contract_v cc
    where cc.contract_id = {$CONTRACT_ID$}
    
    
  --乙方  手机
  select ee.mobil as EMPLOYEE_MOBILE
    from exp_employees ee
   where ee.employee_code =
         (select cc.employee_code
            from con_contract_v cc
           where cc.contract_id = 41)
 ---------------------------------------------------------------------
--合同编号
 select contract_number as CONTRACT_NUMBER
    from con_contract_lv
   where contract_id = {$CONTRACT_ID$}


--标的物总价款
select change_number_to_rmb(round(nvl(ccc.due_amount, 0), 2)) as DUE_AMOUNT_0_RMB
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0

select ccc.due_amount as DUE_AMOUNT_0
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0
   
   
   --账号
 select hbmba.bank_account_num as VENDER_BANK_ACCOUNT_NUM
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')
--户名
 select hbmba.bank_account_name as VENDER_BANK_ACCOUNT_NAME
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')
 
 --开户行
   select hbmba.bank_full_name as VENDER_BANK_FULL_NAME
   from hls_bp_master_bank_account_lv hbmba
  where hbmba.bp_id = (select ccb.bp_id
                         from CON_CONTRACT_BP_LV ccb
                        where ccb.contract_id =  {$CONTRACT_ID$}
                          and ccb.bp_category = 'VENDER')    --供应商
 
 
 --9.3 按照第几种解决
--根据承租人注册地址是否为武汉来区分
                                       
 select decode(hbma.city_id_n, '武汉市', 1, 2) as SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'REGISTERED_ADDRESS'          --注册地址             
    
    
    --合同份数
  SELECT nvl(CON_CONTENT_COUNTS, 2) as CON_CONTENT_COUNTS
    FROM con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}
   
    --标的物清单
   Subject matter list    SUBJECT_MATTER_LIST
   select ccli.full_name,  
          ccli.specification,   
          ccli.quantity,   
           ccli.price,     
           ccli.description   
     from prj_project_lease_item_lv ccli 
     left join Prj_Project_Lv pp on ccli.project_id =pp.project_id
     where pp.lease_channel in  (55,70,80,99)
     and ccli.contract_id = {$CONTRACT_ID$}
   
   
