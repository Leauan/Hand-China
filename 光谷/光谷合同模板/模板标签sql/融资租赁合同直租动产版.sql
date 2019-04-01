--融资租赁合同直租动产版
--合同编号
select CONTENT_NUM as CONTRACT_NUMBER
  from con_contract_content
 where content_id = {$CONTENT_ID$}
 
  --承租人
select ccb.bp_name as TENANT_BP_NAME
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 
   
  --法定代表人
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
           
 --主承租人基本信息
 
--主合同承租人
--承租人

select ccb.bp_name as TENANT_BP_NAME1
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 

-- ADDRESS   承租人  住处   
select hbma.address as TENANT_ORG_ADDRESS
  from hls_bp_master_address_lv hbma    
 where hbma.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'ORG'
                        and ccb.contract_id = {$CONTRACT_ID$})  
   and hbma.address_type = 'COMPANY_ADDRESS'  


--   COMMUNICATION_METHODS     通讯方式
select hbm.communication_methods as TENANT_ORG_CM
  from hls_bp_master hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'    
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})   
 
 --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})
   

--PHONE   电话
select hbma.phone as TENANT_ORG_PHONE
  from hls_bp_master_address_lv hbma 
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb 
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG' 
                       and ccb.contract_id = {$CONTRACT_ID$}) 
   and hbma.address_type = 'COMPANY_ADDRESS'  
                      
 --FAX   传真
select hbma.fax as TENANT_ORG_FAX
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb    
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'    
                       and ccb.contract_id = {$CONTRACT_ID$})
  and hbma.address_type = 'COMPANY_ADDRESS'  

  
  --EMAIL   电邮
select hbma.email as TENANT_ORG_EMAIL
  from hls_bp_master_address_lv   hbma                   
 where hbma.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb   
                     where ccb.bp_category = 'TENANT'  
                       and ccb.bp_class = 'ORG'  
                       and ccb.contract_id = {$CONTRACT_ID$})                                      
   and hbma.address_type = 'COMPANY_ADDRESS'  
   
--CONTACT_PERSON   联系人
select hbmci.contact_person as TENANT_ORG_CONTACT_PERSON
  from hls_bp_master_contact_info_lv hbmci
 where hbmci.bp_id =
       (select ccb.bp_id
          from CON_CONTRACT_BP_LV ccb 
         where ccb.bp_category = 'TENANT' 
           and ccb.bp_class = 'ORG' 
           and ccb.contract_id = {$CONTRACT_ID$}) 
         and rownum =1


--CELL_PHONE   手机
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

-- ID_CARD_NO    乙方（自然人）承租人身份证

select hbm.id_card_no as TENANT_NP_ID_CARD_NO
  from hls_bp_master_lv hbm    
 where hbm.bp_id = (select ccb.bp_id
                       from CON_CONTRACT_BP_LV ccb
                      where ccb.bp_category = 'TENANT' 
                        and ccb.bp_class = 'NP'
                        and ccb.contract_id =  {$CONTRACT_ID$})

-- ADDRESS    乙方（自然人）经常居住地地址
 select address as TENANT_NP_ADDRESS
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
         

 
--PHONE   乙方（自然人）电话
  select phone as TENANT_NP_PHONE
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS'    
 --FAX  乙方（自然人）传真
 select fax as TENANT_NP_FAX
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP' 
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 
--EMAIL  乙方（自然人）电邮
 select email as TENANT_NP_EMAIL
           from hls_bp_master_address_lv hbma 
          where hbma.bp_id =
                (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.bp_class = 'NP'
                    and ccb.contract_id =  {$CONTRACT_ID$})
            and hbma.address_type = 'HOUSE_ADDRESS' 

--CELL_PHONE  乙方（自然人）手机
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
 --对租赁物投保 险种
 select cc.insure_type  as INSURE_TYPE
   from con_contract_lv cc
  where ppli.contract_id = {$CONTRACT_ID$}
           
 --租赁物根据是否有留购金来选择方式：
select decode(nvl(ccc.due_amount, 0), 0, 2, 1) as SELECT_DUE_AMOUNT_8
  from con_contract_cashflow_lv ccc
 where ccc.cf_item = 8
   and ccc.contract_id =  {$CONTRACT_ID$}
  
 --留购金
 select ccc.due_amount as DUE_AMOUNT_8
  from con_contract_cashflow_lv ccc
 where ccc.cf_item = 8
   and ccc.contract_id =  {$CONTRACT_ID$}

--租赁物总价款
select change_number_to_rmb(round(nvl(ccc.due_amount, 0), 2)) as DUE_AMOUNT_0_RMB
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0

select ccc.due_amount as DUE_AMOUNT_0
  from con_contract_cashflow_lv ccc
 where ccc.contract_id = {$CONTRACT_ID$}
   and ccc.cf_item = 0  
   
 --本合同项下的租赁利率采以下第    种方式
 select decode(hfch.int_rate_type, 'FIXED', 1, 2) as INT_RATE_TYPE
  from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
 where cc.contract_id = pq.document_id
   and pq.document_category = 'CONTRACT'
   and pq.calc_session_id = hfch.calc_session_id
   and cc.contract_id =   {$CONTRACT_ID$}
   
   --租赁利率为固定利率，具体为年利率；
   select hfch.int_rate as FIXED_INT_RATE
  from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
 where cc.contract_id = pq.document_id
   and pq.document_category = 'CONTRACT'
   and pq.calc_session_id = hfch.calc_session_id
   and hfch.int_rate_type = 'FIXED'
   and cc.contract_id ={$CONTRACT_ID$}
   
     --租赁利率为浮动利率；
 select hfch.int_rate as FLOATING_INT_RATE
   from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
  where cc.contract_id = pq.document_id
    and pq.document_category = 'CONTRACT'
    and pq.calc_session_id = hfch.calc_session_id
    and hfch.int_rate_type = 'FLOATING'
    and cc.contract_id = {$CONTRACT_ID$}

--利率上浮幅度
select hfch.int_rate_fixing_range as INT_RATE_FIXING_RANGE
  from con_contract cc, hls_fin_calculator_hd hfch, prj_quotation pq
 where cc.contract_id = pq.document_id
   and pq.document_category = 'CONTRACT'
   and pq.calc_session_id = hfch.calc_session_id
   and hfch.int_rate_type = 'FLOATING'
   and cc.contract_id = {$CONTRACT_ID$}
   
 --户名
SELECT  CC.tt_bank_account_name as GG_TT_BANK_ACCOUNT_NAME
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = {$CONTRACT_ID$}

--账号
SELECT CC.tt_bank_account_num as GG_TT_BANK_ACCOUNT_NUM
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = {$CONTRACT_ID$}

--开户行
SELECT CC.tt_bank_branch_name as GG_TT_BANK_BRANCH_NAME
  FROM CON_CONTRACT_LV CC
WHERE CC.contract_id = {$CONTRACT_ID$}
 

 --保证金
select change_number_to_rmb(round(nvl(cc.deposit, 0), 2)) as DEPOSIT_RMB
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}
 
 select round(nvl(cc.deposit, 0), 2) as DEPOSIT
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}         
 
   --手续费
select change_number_to_rmb(round(nvl(cc.lease_charge, 0), 2)) as LEASE_CHARGE_RMB
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}

select round(nvl(cc.lease_charge, 0), 2) as LEASE_CHARGE
  from con_contract_lv cc
 where cc.contract_id = {$CONTRACT_ID$}
 
 -- 16.1保证：                                           
--16.2抵押：                                           
--16.3质押：                                           
--16.4其它：                                          。
--16.1保证：
 select wmsys.wm_concat(pbg.bp_name || pbg.ref_v03_n) BP_NAME_ENSURE
   from prj_bp_guarantor_lv     pbg,
        prj_project_mortgage_lv ppm,
        con_contract_bp_lv      ccb
  where pbg.project_id = ppm.project_id
    and pbg.bp_name = ppm.mortgagor_name
    and ccb.bp_id = pbg.bp_id
    and pbg.ref_v03 = 'ENSURE'
    and ccb.contract_id = {$CONTRACT_ID$}

--16.2抵押： 
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
                                          
--16.3质押：
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
                                           
--16.4其它：




 --所在地址选择
  select decode(hbma.city_id_n, '武汉市', 1, 2) as SELECT_SCHEME
   from hls_bp_master_address_lv hbma
  where bp_id = (select ccb.bp_id
                   from CON_CONTRACT_BP_LV ccb 
                  where ccb.bp_category = 'TENANT' 
                    and ccb.contract_id = {$CONTRACT_ID$})
    and hbma.address_type = 'REGISTERED_ADDRESS' 
    
   --合同份数
  SELECT nvl(CON_CONTENT_COUNTS, 2) as CON_CONTENT_COUNTS
    FROM con_contract_lv cc
   where cc.contract_id = {$CONTRACT_ID$}      
  
  --光谷法定代表人
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
  
  --承租人
select ccb.bp_name as TENANT_BP_NAME2
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 
  
  --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON1
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})

 
      --租赁物清单
       --SUBJECT_MATTER_LIST1
      select ccli.full_name,  
          ccli.specification,
          ccli.quantity,   
           ccli.price,     
           ccli.description   
     from prj_project_lease_item_lv ccli 
     left join Prj_Project_Lv pp on ccli.project_id =pp.project_id
     where pp.lease_channel in  (55,70,80,99)
     and ccli.contract_id = {$CONTRACT_ID$}
     
      --购买合同编号
  select CONTENT_NUM as PURCHASE_CONTRACT_NUMBER
    from con_contract_content CCC
   where templet_id =
         (select CCT.TEMPLET_ID
            from con_clause_templet cct
           where cct.templet_code = 'PURCHASE_CONTRACT') 
     AND CONTRACT_ID = {$CONTRACT_ID$}
     
       --光谷法定代表人
  select name as ORG_NAME2
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
 
 --承租人
select ccb.bp_name as TENANT_BP_NAME3
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 
  
  --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON2
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})    
   
  --承租人
select ccb.bp_name as TENANT_BP_NAME4
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 
 
 --合同编号
select CONTENT_NUM as CONTRACT_NUMBER1
  from con_contract_content
 where content_id = {$CONTENT_ID$}
   
 --合同编号
select CONTENT_NUM as CONTRACT_NUMBER2
  from con_contract_content
 where content_id = {$CONTENT_ID$} 

  --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON3
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})    

 --合同编号
select CONTENT_NUM as CONTRACT_NUMBER3
  from con_contract_content
 where content_id = {$CONTENT_ID$}    
 
  --合同编号
select CONTENT_NUM as CONTRACT_NUMBER4
  from con_contract_content
 where content_id = {$CONTENT_ID$}    
 
 --租金支付表  
 --RENT_PAYMENT_FORM
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

       --光谷法定代表人
  select name as ORG_NAME3
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
                       
 --承租人
select ccb.bp_name as TENANT_BP_NAME5
  from con_contract_bp_lv ccb 
 where ccb.bp_category = 'TENANT' 
   and ccb.contract_id =  {$CONTRACT_ID$}
   and rownum =1 
  
  --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON4
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})                        
                       
  --合同编号
select CONTENT_NUM as CONTRACT_NUMBER5
  from con_contract_content
 where content_id = {$CONTENT_ID$}                           
   
  --租金支付表  
 --RENT_PAYMENT_FORM1
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
                     
  
     --光谷法定代表人
  select name as ORG_NAME4
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
  
  --LEGAL_PERSON   法定代表人
select hbm.legal_person as TENANT_ORG_LEGAL_PERSON5
  from hls_bp_master_lv hbm
 where hbm.bp_id = (select ccb.bp_id
                      from CON_CONTRACT_BP_LV ccb
                     where ccb.bp_category = 'TENANT'
                       and ccb.bp_class = 'ORG'
                       and ccb.contract_id = {$CONTRACT_ID$})                        
                       
