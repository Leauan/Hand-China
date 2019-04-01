CREATE OR REPLACE VIEW con_lease_boat_report_lv AS 
SELECT (SELECT c.contract_number
          FROM con_contract c
         WHERE c.contract_id = t1.contract_id
           AND c.data_class = 'NORMAL') AS contract_number, -- 合同编号
       (SELECT c.contract_name
          FROM con_contract c
         WHERE c.contract_id = t1.contract_id
           AND c.data_class = 'NORMAL') AS contract_name, -- 合同名称
       (SELECT m.bp_name
          FROM hls_bp_master m, con_contract c
         WHERE m.bp_id = c.bp_id_tenant
           AND c.contract_id = t1.contract_id) AS bp_id_tenant_n, -- 承租人名称
       (SELECT m.bp_code
          FROM hls_bp_master m, con_contract c 
         WHERE m.bp_id = c.bp_id_tenant
         AND c.contract_id = t1.contract_id) AS bp_code, -- 承租人编号
       t1.full_name, -- 船名
       t1.pattern, -- 规格型号
       t1.quantity, -- 数量
       t1.price, -- 单价
       t1.uom,
       (SELECT t.description_text
          FROM fnd_uom_codes_vl t
         WHERE t.uom_code = t1.uom) uom_n, -- 单位
       t1.original_asset_value, -- 租赁物价值
       t1.net_asset_value, -- 租赁物账面净值
       t1.fixed_assets_site, -- 存放地点
       t1.brand_name, -- 厂家及品牌 
       t1.leave_factory_date, -- 出厂日期/建成日期
       t1.call_sign, -- 呼号
       t1.lease_category,
       t1.configure,
       (SELECT scv.code_value_name
          FROM sys_code_values_v scv
         WHERE scv.code = 'LEASE_CATEGORY_TYPE'
           AND scv.code_value = t1.lease_category) lease_category_n, -- 类型
       t1.imo, -- IMO编号
       t1.ship_model, -- 船型
       t1.nationality, -- 船旗
       t1.ship_classification, -- 船级
       t1.deadweight_capacity, -- 载重(吨)
       t1.navigating_zone, -- 航区
       t1.hull, -- 船体
       t1.overall_length, -- 总长(米)
       t1.molded_breadth, -- 型宽(米)
       t1.molded_depth, -- 型深(米)
       t1.designed_draft, -- 吃水(米)
       t1.all_tonnage, -- 总吨
       t1.net_tonnage, -- 净吨
       t1.main_engine, -- 主机
       t1.rated_power, -- 最大功率
       t1.design_speed, -- 满载航速
       t1.fuel_consumption, -- 油耗
       t1.hold_capacity, -- 货舱容积（立方米）
       t1.crane, -- 吊机
       t1.description, -- 备注
       t1.project_lease_item_id,
       t1.contract_lease_item_id,
       t1.contract_id,
       t1.lease_registed_date,
       t1.valid_term,
       t1.lease_registed_end,
       (SELECT MAX(inspection_date)
          FROM con_lease_mor_inspection
         WHERE document_id = t1.contract_lease_item_id
           AND inspection_category = 'LEASE') last_inspection_date,
       t1.lease_item_id,
       (SELECT hli.short_name
          FROM hls_lease_item hli
         WHERE hli.lease_item_id = t1.lease_item_id) lease_item_id_n,
       t1.short_name,
       t1.serial_number,
       t1.specification,
       t1.vender_id,
       t1.vender_name,
       t1.manufacturer_name,
       (SELECT scv.code_value_name
          FROM sys_code_values_v scv
         WHERE scv.code = 'CUS_MANUFACTURER'
           AND scv.code_value = t1.manufacturer_name) manufacturer_name_n,
       t1.price * t1.quantity total_amount,
       t1.currency,
       (SELECT gc.currency_name
          FROM gld_currency_vl gc
         WHERE gc.currency_code = t1.currency) currency_n,
       t1.manufacturing_date,
       t1.residual_value,
       t1.installation_site,
       t1.aircraft_category,
       t1.airplane_model,
       t1.engine,
       t1.invoice_amt,
       t1.invoice_num,
       t1.invoice_date,
       t1.created_by,
       t1.creation_date,
       t1.last_updated_by,
       t1.last_update_date,
       t1.ref_v01,
       t1.ref_v02,
       t1.ref_v03,
       t1.ref_v04,
       t1.ref_v05,
       t1.ref_n01,
       t1.ref_n02,
       t1.ref_n03,
       t1.ref_n04,
       t1.ref_n05,
       t1.ref_d01,
       t1.ref_d02,
       t1.ref_d03,
       t1.ref_d04,
       t1.ref_d05,
       (SELECT t.bp_name FROM hls_bp_master t WHERE t.bp_id = t1.vender_id) vender_id_n,
       (SELECT scv.code_value_name
          FROM sys_code_values_v scv
         WHERE scv.code = 'CAR_CATEGORY'
           AND scv.code_value = t1.aircraft_category) aircraft_category_n,
       t1.license_plate_number,
       t1.estimated_deliver_date,
       (SELECT scv.code_value_name
          FROM sys_code_values_v scv
         WHERE scv.code = 'PRJ_LEASE_LICENCE_OWNER'
           AND scv.code_value = t1.ref_v05) ref_v05_n,
       t1.model_id,
       (SELECT cm.description
          FROM hls_car_model cm
         WHERE cm.model_id = t1.model_id) model_id_n,
       t1.series_id,
       (SELECT hcs.description
          FROM hls_car_series hcs
         WHERE hcs.series_id = t1.series_id) series_id_n,
       t1.brand_id,
       (SELECT cb.description
          FROM hls_car_brand cb
         WHERE cb.brand_id = t1.brand_id) brand_id_n,
       t1.bp_id_insure,
       (SELECT bm.bp_name
          FROM hls_bp_master bm
         WHERE bm.bp_id = t1.bp_id_insure) bp_id_insure_n,
       t1.insure_type,
       t1.gps_flag,
       t1.lock_flag,
       t1.trip,
       t1.lease_size,
       t1.mortgage_flag,
       t1.ppd_flag,
       t1.cross_flag,
       t1.fin_model,
       t1.warranty,
       t1.warrant_type,
       (SELECT v.code_value_name
          FROM sys_code_values_v v
         WHERE v.code = 'CARD_TYPE'
           AND v.code_enabled_flag = 'Y'
           AND v.code_value_enabled_flag = 'Y'
           AND v.code_value = t1.warrant_type) AS warrant_type_n,
       t1.warrant_name,
       t1.warrant_num,
       t1.warrant_in_date,
       t1.warrant_out_date,
       t1.buy_con_num,
       t1.buy_time
  FROM con_contract_lease_item t1
 WHERE t1.lease_type = 'boat';
