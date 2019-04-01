CREATE OR REPLACE VIEW HLS_BP_MASTER_LV AS
select t1."BP_CATEGORY",
       t1."COMPANY_ID",
       t1."OWNER_USER_ID",
       t1."BP_ID",
       t1."BP_CODE",
       t1."BP_TYPE",
       t1."BP_CLASS",
       t1."BP_NAME",
       t1."EXTRA_NAM",
       t1."EXTERNAL_BP_CODE",
       t1."ID_TYPE",
       t1."ID_CARD_NO",
       t1."GENDER",
       t1."AGE",
       t1."DATE_OF_BIRTH",
       t1."PLACE_OF_BIRTH",
       t1."LIV_PROVINCE",
       t1."LIV_CITY",
       t1."LIV_DISTRICT",
       t1."LIV_STREET",
       t1."LIVING_ADDRESS",
       t1."ADD_CITY",
       t1."ADD_PROVINCE",
       t1."RESIDENT_ADDRES",
       t1."RESIDENT_STATUS",
       t1."STATE_OF_HEALTH",
       t1."ACADEMIC_BACKGROUND",
       t1."MARITAL_STATUS",
       t1."ETHNIC_GROUP",
       t1."FERTILITY_STATUS",
       t1."NUMBER_OF_CHILDREN",
       t1."CONTACT_PERSON",
       t1."POSITION",
       t1."PHONE",
       t1."PHONE_2",
       t1."CELL_PHONE",
       t1."FAX",
       t1."ZIPCODE",
       t1."EMAIL",
       t1."CELL_PHONE_2",
       t1."WEBSITE",
       t1."E_MAIL",
       t1."QQ",
       t1."WEI_CHAT",
       t1."SOURCE_OF_INCOME",
       t1."ANNUAL_INCOME",
       t1."OTHER_ANNUAL_INCOME",
       t1."OTHER_ASSET",
       t1."CAPITAL_OF_FAMILY",
       t1."LIABILITY_OF_FAMILY",
       t1."GUARANTEE_AMOUNT",
       t1."OWNSHIP_OF_HOUSE",
       t1."HOUSE_LOANS_FLAG",
       t1."SEND_ADDRESS",
       t1."WORK_TYPE",
       t1."WORK_UNIT",
       t1."WORK_PROVINCE",
       t1."WORK_CITY",
       t1."WORK_UNIT_ADDRESS",
       t1."WORK_UNIT_PHONE",
       t1."WORK_UNIT_ZIP",
       t1."COMPANY_NATURE",
       t1."INDUSTRY_WORK_EXPER",
       t1."MAIN_DRIVER_OF_CAR",
       t1."DRIVER_LICENSE_NO",
       t1."LIVING_SITUATION",
       t1."SOURCE_OF_INCOME_DB",
       t1."RELEASE_FORM",
       t1."BUSINESS_LICENSE_NUM",
       t1."ORGANIZATION_CODE",
       t1."TAX_REGISTRY_NUM",
       t1."LOAN_CARD_NUM",
       t1."TAXPAYER_TYPE",
       t1."CORPORATE_CODE",
       t1."REGISTERED_PLACE",
       t1."FOUNDED_DATE",
       t1."REGISTERED_CAPITAL",
       t1."PAID_UP_CAPITAL",
       t1."CURRENCY",
       t1."LEGAL_FORM",
       t1."INDUSTRY",
       t1."ENTERPRISE_SCALE",
       t1."SHAREHOLDERS_BACKGROUND",
       t1."FOA_RATE",
       t1."PORPORTION_OF_GUARANTEE",
       t1."EARNINGS_CONDITION",
       t1."MAIN_BUSINESS_GROWTH",
       t1."ROE",
       t1."CURRENT_RATIO",
       t1."INTEREST_COVER_RATIO",
       t1."DEBT_TO_ASSET_RATIO",
       t1."BP_NAME_SP",
       t1."CARD_TYPE_SP",
       t1."ID_NO_SP",
       t1."GENDER_SP",
       t1."DATE_OF_BIRTH_SP",
       t1."AGE_SP",
       t1."CELL_PHONE_SP",
       t1."ACADEMIC_BACKGROUND_SP",
       t1."LIVING_ADD_CITY",
       t1."LIVING_ADD_PROVINCE",
       t1."LIVING_ADDRESS_SP",
       t1."RESIDENT_ADD_PROVINCE",
       t1."RESIDENT_ADD_CITY",
       t1."RESIDENT_ADDRES_SP",
       t1."WORK_TYPE_SP",
       t1."INDUSTRY_SP",
       t1."INDUSTRY_WORK_EXPERIENCE_SP",
       t1."WORK_UNIT_NAME_SP",
       t1."WORK_UNIT_PHONE_SP",
       t1."WORK_PROVINCE_SP",
       t1."WORK_CITY_SP",
       t1."WORK_UNIT_ADDRESS_SP",
       t1."POSITION_SP",
       t1."SOURCE_OF_INCOME_SP",
       t1."ANNUAL_INCOME_SP",
       t1."OTHER_ANNUAL_INCOME_SP",
       t1."RELATIONSHIP_SP",
       t1."BANK_ID",
       t1."BANK_ACCOUNT_NAME",
       t1."BANK_ACCOUNT_NUM",
       t1."INVOICE_BP_ADDRESS_PHONE_NUM",
       t1."INVOICE_BP_BANK_ACCOUNT",
       t1."INVOICE_TITLE",
       t1."INVOICE_SEND_ADDRESS",
       t1."BP_NAME_LEG",
       t1."ID_CARD_NO_LEG",
       t1."GENDER_LEG",
       t1."DATE_OF_BIRTH_LEG",
       t1."AGE_LEG",
       t1."MARITAL_STATUS_LEG",
       t1."ACADEMIC_BACKGROUND_LEG",
       t1."YEARS_OF_LIVING_HOUSE_LEG",
       t1."RESIDENT_STATUS_LEG",
       t1."CELL_PHONE_LEG",
       t1."EMAIL_LEG",
       t1."START_WORK_LEG",
       t1."LIV_PROVINCE_LEG",
       t1."LIV_CITY_LEG",
       t1."LIV_DISTRICT_LEG",
       t1."LIV_STREET_LEG",
       t1."NET_MONTHLY_INCOME_LEG",
       t1."OWNERSHIP_OF_HOUSE_LEG",
       t1."OTHER_ASSET_LEG",
       t1."CAPITAL_OF_FAMILY_LEG",
       t1."LIABILITY_OF_FAMILY_LEG",
       t1."ADDRESS_ID",
       t1."ENABLED_FLAG",
       t1."CREDIT_FLAG",
       t1."CREDIT_AMOUNT",
       t1."CREDIT_ALT",
       t1."CREDIT_FORBID",
       t1."NC_STATUS",
       t1."KINGDEE_CODE",
       t1."APPROVAL_STATUS",
       t1."AGENT_TYPE",
       t1."REF_FLAG_1",
       t1."REF_FLAG_2",
       t1."REF_FLAG_3",
       t1."REF_FLAG_4",
       t1."CREATED_BY",
       t1."CREATION_DATE",
       t1."LAST_UPDATED_BY",
       t1."LAST_UPDATE_DATE",
       t1."REF_V01",
       t1."REF_V02",
       t1."REF_V03",
       t1."REF_V04",
       t1."REF_V05",
       t1."REF_V06",
       t1."REF_N01",
       t1."REF_N02",
       t1."REF_N03",
       t1."REF_N04",
       t1."REF_N05",
       t1."REF_N06",
       t1."REF_N07",
       t1."REF_N10",
       t1."REF_D01",
       t1."REF_D02",
       t1."REF_D03",
       t1."REF_D04",
       t1."REF_D05",
       t1."YEARS_OF_LIVING_HOUSE",
       t1."NET_MONTHLY_INCOME",
       t1."TOTAL_ASSETS",
       t1."WORK_DISTRICT",
       t1."WOKR_STREET",
       t1."NAME_LEGAL",
       t1."WORK_STREET",
       t1."PARENT_ID",
       t1."DEPOSIT_AMOUNT",
       t1."REGION",
       t1."REF_V07",
       t1."NET_MONTHLY_INCOME_GUA",
       t1."REGISTERED_CAPITAL_ORG",
       t1."PROVINCE_ID",
       t1."CITY_SP",
       t1."SBO_BP_MESSAGE",
       t1."SBO_BP_STATUS",
       t1."DEPARTMENT",
       t1."MONTHLY_INCOME",
       t1."OTHER_MONTHLY_INCOME",
       t1."MONTHLY_EXPENSE",
       t1."MONTH_AMOUNT",
       t1."OCCUPATION",
       t1."EMPLOYMENT_TYPE",
       t1."OWNSHIP_OF_VEHICLE_FLAG",
       t1."PLATE_NO",
       t1."BUY_TIME",
       t1."CURRENT_DRIVER_OF_CAR",
       t1."SOCIAL_SECURITY_FLAG",
       t1."PAY_WATER",
       t1."LEGAL_REP_FLAG",
       t1."RESIDENT_DISTRICT",
       t1."ZIP_ON_RESIDENT_BOOKLIT",
       t1."ADD_PHONE",
       t1."LIV_PHONE",
       t1."SEND_PROVINCE",
       t1."SEND_CITY",
       t1."SEND_DISTRICT",
       t1."SEND_ZIP",
       t1."ETHNIC_GROUP_SP",
       t1."DATE_0F_MARRIAGE_CER",
       t1."MONTHLY_INCOME_SP",
       t1."OTHER_MONTHLY_INCOME_SP",
       t1."EMPLOYMENT_TYPE_SP",
       t1."RESIDENT_ADD_DISTRICT",
       t1."RESIDENT_ZIP_SP",
       t1."ADD_PHONE_SP",
       t1."LIVING_ADD_DISTRICT",
       t1."ZIP_OF_LIVING_ADDRESS_SP",
       t1."LIVING_PHONE_SP",
       t1."WORK_DISTRICT_SP",
       t1."ZIP_OF_WORK_ADDRESS_SP",
       t1."EMAIL_SP",
       t1."ENTRY_DATE",
       t1."CAR_TYPE",
       t1."LATEST_PAYMENT_BASE",
       t1."ZIP_OF_LIVING_ADDRESS",
       t1."OCCUPTION",
       (SELECT bc.description
          FROM hls_bp_category bc
         WHERE bc.bp_category = t1.bp_category) AS bp_category_n,
       (SELECT bt.description
          FROM hls_bp_type bt
         WHERE bt.bp_type = t1.bp_type) AS bp_type_n,
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'HLS211_BP_CLASS'
           AND v.code_value = t1.bp_class) AS bp_class_n,
       (SELECT cu.currency_name
          FROM gld_currency_vl cu
         WHERE cu.currency_code = t1.currency) AS currency_n,
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'HLS211_TAXPAYER_TYPE'
           AND v.code_value = t1.taxpayer_type) AS taxpayer_type_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'SYS_SEX_TYPE'
           and scv.code_value = t1.gender) gender_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_MARRIAGE_STATUS'
           and scv.code_value = t1.marital_status) marital_status_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_SYS_EDUCATIONAL'
           and scv.code_value = t1.academic_background) academic_background_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_SYS_HOUSEHOLD_CODE'
           and scv.code_value = t1.RESIDENT_STATUS) RESIDENT_STATUS_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_HEALTH_STATUS'
           and scv.code_value = t1.STATE_OF_HEALTH) STATE_OF_HEALTH_n,

       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.Liv_Province) Liv_Province_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.liv_city) liv_city_n,
       (select fd.description
          from fnd_district fd
         where fd.district_id = t1.LIV_DISTRICT) LIV_DISTRICT_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_WORK_TYPE'
           and scv.code_value = t1.work_type) work_type_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'WORK_UNIT'
           and scv.code_value = t1.WORK_UNIT) WORK_UNIT_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_SYS_LEGAL_UNIT_PROPERTY'
           and scv.code_value = t1.COMPANY_NATURE) COMPANY_NATURE_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_WORKING_AGE_TYPE'
           and scv.code_value = t1.INDUSTRY_WORK_EXPER) INDUSTRY_WORK_EXPER_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_HOUSE_OWNERSHIP'
           and scv.code_value = t1.OWNSHIP_OF_HOUSE) OWNSHIP_OF_HOUSE_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'SYS_SEX_TYPE'
           and scv.code_value = t1.GENDER_SP) GENDER_SP_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_WORK_TYPE'
           and scv.code_value = t1.WORK_TYPE_SP) WORK_TYPE_SP_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_AGENT_TYPE'
           and scv.code_value = t1.agent_type) agent_type_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_CUS_GUARANT_TOTAL_ASSET'
           and scv.code_value = t1.total_assets) total_assets_n,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.work_province) work_province_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.work_city) work_city_n,
       (select v.code_value_name
          from sys_code_values_v v
         where v.code = 'HLS_CUS_LIVE_DEADLINE'
           and v.code_value = t1.years_of_living_house) years_of_living_house_n,

       (select v.code_value_name value_name
          from sys_code_values_v v
         where v.code = 'HLS_SYS_REGION'
           and v.code_enabled_flag = 'Y'
           and v.code_value_enabled_flag = 'Y'
           and v.code_value = t1.region) region_n,
       (select hbm.bp_name value_name
          from hls_bp_master hbm
         where hbm.enabled_flag = 'Y'
           and hbm.bp_category = 'AGENT'
           and hbm.bp_id = t1.parent_id) parent_id_n,

       (SELECT ha.bank_account_num
          FROM hls_bp_master_bank_account ha
         WHERE ha.bp_id = t1.bp_id
         --  AND t1.bp_category = 'AGENT'
           AND ha.enabled_flag = 'Y'
           and rownum=1) bank_account_number,
       (SELECT ha.bank_branch_name
          FROM hls_bp_master_bank_account ha
         WHERE ha.bp_id = t1.bp_id
        --   AND t1.bp_category = 'AGENT'
           AND ha.enabled_flag = 'Y'
            and rownum=1) bank_branch_name,
       --add by neo 20180426
       (select code_value_name
          from sys_code_values_v scv
         where scv.code = 'OCCUPATION'
           and scv.code_value = t1.OCCUPTION) OCCUPTION_N， (select code_value_name
                                                              from sys_code_values_v scv
                                                             where scv.code =
                                                                   'CAR_TYPE'
                                                               and scv.code_value =
                                                                   t1.CAR_TYPE) CAR_TYPE_N,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.ADD_PROVINCE) ADD_PROVINCE_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.ADD_CITY) ADD_CITY_n,
       (select fd.description
          from fnd_district fD
         where fD.District_Id = t1.RESIDENT_DISTRICT) RESIDENT_DISTRICT_n,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.SEND_PROVINCE) SEND_PROVINCE_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.SEND_CITY) SEND_CITY_n,
       (select fd.description
          from fnd_district fD
         where fD.District_Id = t1.SEND_DISTRICT) SEND_DISTRICT_n,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.RESIDENT_ADD_PROVINCE) RESIDENT_ADD_PROVINCE_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.RESIDENT_ADD_CITY) RESIDENT_ADD_CITY_n,
       (select fd.description
          from fnd_district fD
         where fD.District_Id = t1.RESIDENT_ADD_DISTRICT) RESIDENT_ADD_DISTRICT_n,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.LIVING_ADD_PROVINCE) LIVING_ADD_PROVINCE_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.LIVING_ADD_CITY) LIVING_ADD_CITY_n,
       (select fd.description
          from fnd_district fD
         where fD.District_Id = t1.LIVING_ADD_DISTRICT) LIVING_ADD_DISTRICT_n,
       (select fp.description
          from fnd_province fp
         where fp.province_id = t1.WORK_PROVINCE_SP) WORK_PROVINCE_SP_n,
       (select fc.description
          from fnd_city fc
         where fc.city_id = t1.WORK_CITY_SP) WORK_CITY_SP_n,
       (select fd.description
          from fnd_district fD
         where fD.District_Id = t1.WORK_DISTRICT_SP) WORK_DISTRICT_SP_n,
       (select code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS_SYS_EDUCATIONAL'
           and scv.code_value = t1.ACADEMIC_BACKGROUND_SP) ACADEMIC_BACKGROUND_SP_N,
       (select code_value_name
          from sys_code_values_v scv
         where scv.code = 'PRJ500N_POSITION_TYPE'
           and scv.code_value = t1.POSITION_SP) POSITION_SP_N,
       (select code_value_name
          from sys_code_values_v scv
         where scv.code = 'EMPLOYMENT_TYPE'
           and scv.code_value = t1.EMPLOYMENT_TYPE_SP) EMPLOYMENT_TYPE_SP_N,
       (select a.description
          from hls_stat_class a
         where a.class_id = t1.industry) industry_n,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'PRJ500N_POSITION_TYPE'
           and scv.code_value = t1.POSITION) POSITION_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'EMPLOYMENT_TYPE'
           and scv.code_value = t1.EMPLOYMENT_TYPE) EMPLOYMENT_TYPE_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'OWNSHIP_OF_VEHICLE_FLAG'
           and scv.code_value = t1.OWNSHIP_OF_VEHICLE_FLAG) OWNSHIP_OF_VEHICLE_FLAG_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'SOCIAL_SECURITY_FLAG'
           and scv.code_value = t1.SOCIAL_SECURITY_FLAG) SOCIAL_SECURITY_FLAG_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'PAY_WATER'
           and scv.code_value = t1.PAY_WATER) PAY_WATER_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'LEGAL_REP_FLAG'
           and scv.code_value = t1.LEGAL_REP_FLAG) LEGAL_REP_FLAG_N,
       (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'HLS211_ID_TYPE'
           and scv.code_value = t1.id_type) id_type_n,
       (select fd.description value_name
          from fnd_district fd
         where fd.enabled_flag = 'Y'
           and fd.district_id = t1.work_district) work_district_n,

       --add 承租人户口类型 by lrh 89415
 t1.tenant_residence_type,
(select v.code_value_name
         from sys_code_values_v v
         where v.code = 'TENANT_RESIDENCE_TYPE'
         and v.code_value = t1.tenant_residence_type
         and v.code_enabled_flag = 'Y' and v.code_value_enabled_flag = 'Y') tenant_residence_type_n,
           t1.initial_rate,
           t1.life_time,
           t1.REGULATOR,
            (select scv.code_value_name
          from sys_code_values_v scv
         where scv.code = 'REGULATOR_TYPE'
           and scv.code_value = t1.REGULATOR) REGULATOR_N,
           t1.gac_bp_code, --add by lara 11355 20190102 广三经销商编码
           t1.down_payment_ratio, --add by lara 11355 20190108 首付款比例
           -- addby wuts 20190311
           t1.linkage_month_num,
           t1.linkage_flag,
           (select code_value_name
           from sys_code_values_v
           where code='YES_NO'
           and code_value =  t1.linkage_flag) linkage_flag_n,
           --end  addby wuts 20190311
       t1.transfer_margin_ratio -- add by CLyuan
  FROM hls_bp_master t1
  order by t1.bp_code
;
