create or replace package hls_rent_pkg is

  -- Author  : CONGWEIJING
  -- Created : 2018/8/8 14:11:50
  -- Purpose : 
  type ref_cursor is ref cursor;

  procedure insert_room_info(p_room_type          in varchar2,
                             p_room_area          varchar2,
                             p_bed_free           varchar2,
                             p_landlord_name      varchar2,
                             p_landlord_tel       varchar2,
                             p_room_addr_country  varchar2,
                             p_room_addr_province varchar2,
                             p_room_addr_city     varchar2,
                             p_room_abbr          varchar2,
                             p_intermediary       varchar2,
                             p_intermediary_name  varchar2,
                             p_intermediary_tel   varchar2,
                             p_message            varchar2);
  --费用表插入
  procedure insert_rent_fee_info(p_fee_no         varchar2,
                                 p_fee_add_date   date,
                                 p_fee_first_date date,
                                 p_fee_last_date  date,
                                 p_fee_items      varchar2,
                                 p_fee_sources    varchar2,
                                 p_fee_objects    varchar2,
                                 p_fee_amounts    number,
                                 p_fee_currency   varchar2,
                                 p_message        varchar2);
  /*--费用明细表插入
  procedure insert_rent_fee_detail(p_room_id        in varchar2,
                                   p_fee_items      in varchar2,
                                   p_fee_amounts    in number,
                                   p_fee_first_date in date,
                                   p_fee_last_date  in date);*/

  --根据房屋编号更新房屋信息
  procedure update_room_info(p_room_no            in varchar2,
                             p_room_type          in varchar2,
                             p_room_area          varchar2,
                             p_bed                varchar2,
                             p_landlord_name      varchar2,
                             p_landlord_tel       varchar2,
                             p_room_addr_country  varchar2,
                             p_room_addr_province varchar2,
                             p_room_addr_city     varchar2,
                             p_room_abbr          varchar2,
                             p_intermediary       varchar2,
                             p_intermediary_name  varchar2,
                             p_intermediary_tel   varchar2,
                             p_message            varchar2);
  --插入一条手工收款数据                       
  procedure insert_receipt_fee(p_receipt_objects in varchar2,
                               p_receipt_date    date,
                               p_receipt_ways    varchar2,
                               p_receipt_sources varchar2,
                               p_receipt_amounts varchar2,
                               p_currency        varchar2,
                               p_message         varchar2);

  --插入人员信息                            
  procedure insert_people_info(
                               /*   p_personnel_no in varchar2,*/p_staff_no     in varchar2,
                               p_name         in varchar2,
                               p_gender       in varchar2,
                               p_department   in varchar2,
                               p_base_in      in varchar2,
                               p_phone_number in varchar2,
                               p_email        in varchar2,
                               p_message      in varchar2);
  --根据人员编号更新人员信息 
  procedure update_people_info(p_personnel_no in varchar2,
                               p_staff_no     in varchar2,
                               p_name         in varchar2,
                               p_gender       in varchar2,
                               p_department   in varchar2,
                               p_base_in      in varchar2,
                               p_phone_number in varchar2,
                               p_email        in varchar2,
                               p_message      in varchar2);
  --费用明细表                               
  procedure insert_fee_detail_by_staffno(p_room_id        in varchar2,
                                         p_fee_items      in varchar2,
                                         p_fee_amounts    in number,
                                         p_fee_first_date in date,
                                         p_fee_last_date  in date);
  --手工核销提交
  procedure verification_insert_update(p_contract_no           varchar2,
                                       p_receipt_no            varchar2,
                                       p_staff_no              varchar2,
                                       p_verification_rental   number,
                                       p_verification_water    number,
                                       p_verification_electric number,
                                       p_verification_network  number,
                                       p_verification_cable    number,
                                       p_receipt_sources       varchar2,
                                       p_message               varchar2);
  --核销事务表插入
  procedure insert_payment_verification(v_verification_id   number,
                                        v_verification_no   varchar2,
                                        v_contract_no       varchar2,
                                        v_creditor_project  varchar2,
                                        v_verification_date varchar2,
                                        v_source_type       varchar2,
                                        v_source_object     varchar2,
                                        v_receipt_no        varchar2,
                                        v_currency          varchar2,
                                        v_message           varchar2,
                                        v_verification_fee  number);
  --新版手工核销提交
  procedure verification_insert(p_contract_no           varchar2,
                                p_receipt_no            varchar2,
                                p_staff_no              varchar2,
                                p_verification_rental   number,
                                p_verification_water    number,
                                p_verification_electric number,
                                p_verification_network  number,
                                p_verification_cable    number,
                                p_receipt_sources       varchar2,
                                p_message               varchar2);
  --新版核销事务表插入
  procedure insert_verification_tab(v_verification_id       number,
                                    v_verification_no       varchar2,
                                    v_contract_no           varchar2,
                                    v_verification_date     date,
                                    v_receipt_sources       varchar2,
                                    v_staff_no              varchar2,
                                    v_receipt_no            varchar2,
                                    v_currency              varchar2,
                                    v_message               varchar2,
                                    v_verification_rental   number,
                                    v_verification_water    number,
                                    v_verification_electric number,
                                    v_verification_network  number,
                                    v_verification_cable    number);
end hls_rent_pkg;
/
create or replace package body hls_rent_pkg is
  procedure insert_room_info(p_room_type          in varchar2,
                             p_room_area          varchar2,
                             p_bed_free           varchar2,
                             p_landlord_name      varchar2,
                             p_landlord_tel       varchar2,
                             p_room_addr_country  varchar2,
                             p_room_addr_province varchar2,
                             p_room_addr_city     varchar2,
                             p_room_abbr          varchar2,
                             p_intermediary       varchar2,
                             p_intermediary_name  varchar2,
                             p_intermediary_tel   varchar2,
                             p_message            varchar2) is
    v_room_id number := hls_room_info_s.nextval;
    v_room_no varchar2(30);
  begin
    select 'FW' || to_char(sysdate, 'YYYYmmdd') ||
           trim(to_char((1000 + hls_room_info_s1.nextval)))
      into v_room_no
      from dual;
    insert into hls_room_info
      (room_id,
       room_no,
       room_abbr,
       room_type,
       room_area,
       bed,
       bed_used,
       bed_free,
       landlord_name,
       landlord_tel,
       intermediary,
       intermediary_name,
       intermediary_tel,
       message,
       room_addr_country,
       room_addr_province,
       room_addr_city,
       room_status,
       creation_date,
       created_by,
       last_updated_by,
       last_update_date)
    values
      (v_room_id,
       v_room_no,
       p_room_abbr,
       p_room_type,
       p_room_area,
       p_bed_free,
       0,
       p_bed_free,
       p_landlord_name,
       p_landlord_tel,
       p_intermediary,
       p_intermediary_name,
       p_intermediary_tel,
       p_message,
       p_room_addr_country,
       p_room_addr_province,
       p_room_addr_city,
       1,
       sysdate,
       1,
       -1,
       sysdate);
  end insert_room_info;
  --费用单新增
  procedure insert_rent_fee_info(p_fee_no         varchar2,
                                 p_fee_add_date   date,
                                 p_fee_first_date date,
                                 p_fee_last_date  date,
                                 p_fee_items      varchar2,
                                 p_fee_sources    varchar2,
                                 p_fee_objects    varchar2,
                                 p_fee_amounts    number,
                                 p_fee_currency   varchar2,
                                 p_message        varchar2) is
    v_fee_id hls_rent_fee_info.fee_id%type := hls_rent_fee_info_s.nextval;
    v_fee_no hls_rent_fee_info.fee_no%type := 'FYD' ||
                                              to_char(sysdate, 'yyyymmdd') ||
                                              trim(to_char(1000 + v_fee_id));
  
  begin
  
    insert into hls_rent_fee_info
      (fee_id,
       fee_no,
       fee_add_date,
       fee_first_date,
       fee_last_date,
       fee_items,
       fee_sources,
       fee_objects,
       fee_amounts,
       fee_currency,
       message,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    values
      (v_fee_id,
       v_fee_no,
       p_fee_add_date,
       p_fee_first_date,
       p_fee_last_date,
       p_fee_items,
       p_fee_sources,
       p_fee_objects,
       p_fee_amounts,
       p_fee_currency,
       p_message,
       1,
       sysdate,
       -1,
       sysdate);
    insert_fee_detail_by_staffno(p_fee_objects,
                                 p_fee_items,
                                 p_fee_amounts,
                                 p_fee_first_date,
                                 p_fee_last_date);
  end insert_rent_fee_info;
  /*--按新增的一条收费费用来计算明细
  procedure insert_rent_fee_detail(p_room_id        in varchar2,
                                   p_fee_items      in varchar2,
                                   p_fee_amounts    in number,
                                   p_fee_first_date in date,
                                   p_fee_last_date  in date) is
    v_every_date     date := p_fee_first_date;
    v_fee_detail_id  number;
    v_contract_no    varchar2(30);
    v_count          number;
    v_room_price     number;
    v_water_price    number;
    v_electric_price number;
    v_network_price  number;
    v_cable_price    number;
    v_fee_period     number := 1;
    cursor fee_cursor is
      select hfi.fee_no         fee_no,
             hfi.fee_first_date fee_first_date,
             hfi.fee_last_date  fee_last_date,
             hfi.fee_items      fee_items,
             hfi.fee_objects    fee_objects,
             hfi.fee_amounts    fee_amounts
        from hls_rent_fee_info hfi;
  
  begin
    select hls_contract_info.contract_id
      into v_contract_no
      from hls_contract_info
     where hls_contract_info.room_id = p_room_id;
    for i_cursor in fee_cursor loop
      --判断期数，
      \* 传入的房间号与表中原存在的房间号逐一遍历进行对比，
        如果之前存在此房间号且各项费用都收取一次则判定此次
      为二期收费*\
      --房间号相同且收费项目与之前存在项目相同，
      if i_cursor.fee_objects = p_room_id and
         i_cursor.fee_items = p_fee_items then
        v_fee_period := v_fee_period + 1;
        \* else 
        v_fee_period := 1;*\
      end if;
    end loop;
  
    --从费用开始日+1循环到费用结束日，根据room_id计算在员工租住时间内这一天所住的人数
    while v_every_date < p_fee_last_date loop
      select count(hh.staff_no)
        into v_count
        from hls_hsm hh, hls_contract_info hci
       where hh.contract_no = hci.h_contract_number
         and hci.room_id = p_room_id
         and v_every_date between hh.live_start_date and hh.check_out_date;
      --根据合同号及这一天租住的人数分摊日租金
      select round((hci1.sum_price /
                   (hci1.contract_finish_date - hci1.contract_start_date)) /
                   v_count,
                   2)
        into v_room_price
        from hls_hsm hh1, hls_contract_info hci1
       where hh1.contract_no = hci1.h_contract_number
         and hci1.room_id = p_room_id;
      --同理计算这一天的各项费用
      --计算水费
      if p_fee_items = 'fee_items_1' then
        select round((p_fee_amounts / (p_fee_last_date - p_fee_first_date)) /
                     v_count,
                     2)
          into v_water_price
          from dual;
      end if;
      --计算电费
      if p_fee_items = 'fee_items_2' then
        select round((p_fee_amounts / (p_fee_last_date - p_fee_first_date)) /
                     v_count,
                     2)
          into v_electric_price
          from dual;
      end if;
      --计算网络费用
      if p_fee_items = 'fee_items_3' then
        select round((p_fee_amounts / (p_fee_last_date - p_fee_first_date)) /
                     v_count,
                     2)
          into v_network_price
          from dual;
      end if;
      --计算有线电视费用
      if p_fee_items = 'fee_items_4' then
        select round((p_fee_amounts / (p_fee_last_date - p_fee_first_date)) /
                     v_count,
                     2)
          into v_cable_price
          from dual;
      end if;
      v_fee_detail_id := hls_fee_detail_s.nextval;
      --如果一期别的费用数据过长
      insert into hls_fee_detail
        (fee_detail_id,
         starff_no,
         periods,
         apportion_rental,
         apportion_water,
         apportion_electric,
         apportion_network,
         apportion_cable)
      values
        (v_fee_detail_id,
         v_contract_no,
         v_fee_period,
         v_room_price,
         v_water_price,
         v_electric_price,
         v_network_price,
         v_cable_price);
      v_every_date := v_every_date + 1;
    end loop;
  end insert_rent_fee_detail;*/

  --根据房屋编号更新房屋信息
  procedure update_room_info(p_room_no            in varchar2,
                             p_room_type          in varchar2,
                             p_room_area          varchar2,
                             p_bed                varchar2,
                             p_landlord_name      varchar2,
                             p_landlord_tel       varchar2,
                             p_room_addr_country  varchar2,
                             p_room_addr_province varchar2,
                             p_room_addr_city     varchar2,
                             p_room_abbr          varchar2,
                             p_intermediary       varchar2,
                             p_intermediary_name  varchar2,
                             p_intermediary_tel   varchar2,
                             p_message            varchar2) is
    v_room_type          varchar2(200) := p_room_type;
    v_room_area          varchar2(200) := p_room_area;
    v_bed                varchar2(200) := p_bed;
    v_room_addr_country  varchar2(200) := p_room_addr_country;
    v_room_addr_province varchar2(200) := p_room_addr_province;
    v_room_addr_city     varchar2(200) := p_room_addr_city;
  begin
    if (v_room_type is null or v_room_type = '') then
      select h.room_type
        into v_room_type
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    if (v_room_area is null or v_room_area = '') then
      select h.room_area
        into v_room_area
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    if (v_bed is null or v_bed = '') then
      select h.bed
        into v_bed
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    if (v_room_addr_country is null or v_room_addr_country = '') then
      select h.room_addr_country
        into v_room_addr_country
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    if (v_room_addr_province is null or v_room_addr_province = '') then
      select h.room_addr_province
        into v_room_addr_province
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    if (v_room_addr_city is null or v_room_addr_city = '') then
      select h.room_addr_city
        into v_room_addr_city
        from hls_room_info h
       where h.room_no = p_room_no;
    end if;
    update hls_room_info
       set room_abbr          = p_room_abbr,
           room_type          = v_room_type,
           room_area          = v_room_area,
           bed                = v_bed,
           landlord_name      = p_landlord_name,
           landlord_tel       = p_landlord_tel,
           intermediary       = p_intermediary,
           intermediary_name  = p_intermediary_name,
           intermediary_tel   = p_intermediary_tel,
           message            = p_message,
           room_addr_country  = v_room_addr_country,
           room_addr_province = v_room_addr_province,
           room_addr_city     = v_room_addr_city,
           last_update_date   = sysdate
     where room_no = p_room_no;
  end;

  --插入一条手工收款数据
  procedure insert_receipt_fee(p_receipt_objects in varchar2,
                               
                               p_receipt_date    date,
                               p_receipt_ways    varchar2,
                               p_receipt_sources varchar2,
                               p_receipt_amounts varchar2,
                               p_currency        varchar2,
                               p_message         varchar2) is
    v_receipt_id  number := hls_rent_receipt_fee_s.nextval;
    v_receipt_no  varchar2(30);
    v_contract_no varchar2(30); --根据员工编号查找合同编号
    v_count       number;
  begin
    select 'SKXZ' || to_char(sysdate, 'YYYYmmdd') ||
           trim(to_char((1000 + hls_rent_receipt_fee_s1.nextval)))
      into v_receipt_no
      from dual;
    select contract_no
      into v_contract_no
      from hls_hsm
     where staff_no = p_receipt_objects;
    if p_receipt_sources = 'room_people' then
      /*select count(1)
        into v_count
        from hls_rent_receipt_fee hrf
       where hrf.receipt_objects = p_receipt_objects;
      if v_count != 0 then
        update hls_rent_receipt_fee hrf
           set hrf.receipt_amounts = hrf.receipt_amounts + p_receipt_amounts
         where hrf.receipt_objects = p_receipt_objects;
      else*/
      insert into hls_rent_receipt_fee
        (receipt_id,
         receipt_no,
         receipt_sources,
         receipt_objects,
         receipt_ways,
         receipt_date,
         receipt_amounts,
         currency,
         contract_no,
         message,
         creation_date,
         created_by,
         last_updated_by,
         last_update_date)
      values
        (v_receipt_id,
         v_receipt_no,
         p_receipt_sources,
         p_receipt_objects,
         p_receipt_ways,
         p_receipt_date,
         p_receipt_amounts,
         p_currency,
         v_contract_no,
         p_message,
         sysdate,
         1,
         -1,
         sysdate);
      /*end if;*/
    else
      insert into hls_rent_receipt_fee
        (receipt_id,
         receipt_no,
         receipt_sources,
         receipt_objects,
         receipt_ways,
         receipt_date,
         receipt_amounts,
         currency,
         contract_no,
         message,
         creation_date,
         created_by,
         last_updated_by,
         last_update_date)
      values
        (v_receipt_id,
         v_receipt_no,
         'others',
         '',
         p_receipt_ways,
         p_receipt_date,
         p_receipt_amounts,
         p_currency,
         v_contract_no,
         p_message,
         sysdate,
         1,
         -1,
         sysdate);
    end if;
  end insert_receipt_fee;
  --插入人员信息
  procedure insert_people_info(
                               /*   p_personnel_no in varchar2,*/p_staff_no     in varchar2,
                               p_name         in varchar2,
                               p_gender       in varchar2,
                               p_department   in varchar2,
                               p_base_in      in varchar2,
                               p_phone_number in varchar2,
                               p_email        in varchar2,
                               p_message      in varchar2) is
    v_people_id    number := hls_people_info_s.nextval;
    v_personnel_no varchar2(30);
  
  begin
    select 'RZRY' || to_char(sysdate, 'YYYYMM') ||
           trim(to_char((1000 + hls_people_info_s1.nextval)))
      into v_personnel_no
      from dual;
  
    insert into hls_hsm
    
      (people_id,
       personnel_no,
       staff_no,
       name,
       gender,
       department,
       base_in,
       phone_number,
       people_status,
       email,
       message,
       leaving_date,
       live_start_date,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    values
      (v_people_id,
       v_personnel_no,
       p_staff_no,
       p_name,
       p_gender,
       p_department,
       p_base_in,
       p_phone_number,
       'type1',
       p_email,
       p_message,
       sysdate,
       sysdate,
       1,
       sysdate,
       -1,
       sysdate);
  end;

  --根据人员编号更新人员信息   
  procedure update_people_info(p_personnel_no in varchar2,
                               p_staff_no     in varchar2,
                               p_name         in varchar2,
                               p_gender       in varchar2,
                               p_department   in varchar2,
                               p_base_in      in varchar2,
                               p_phone_number in varchar2,
                               p_email        in varchar2,
                               p_message      in varchar2) is
    v_gender     varchar2(30) := p_gender;
    v_department varchar2(30) := p_department;
    v_base_in    varchar2(30) := p_base_in;
  begin
    if (v_gender is null or v_gender = '') then
      select h.gender
        into v_gender
        from hls_hsm h
       where h.personnel_no = p_personnel_no;
    end if;
    if (v_department is null or v_department = '') then
      select h.department
        into v_department
        from hls_hsm h
       where h.personnel_no = p_personnel_no;
    end if;
    if (v_base_in is null or v_base_in = '') then
      select h.base_in
        into v_base_in
        from hls_hsm h
       where h.personnel_no = p_personnel_no;
    end if;
    update hls_hsm
       set staff_no         = p_staff_no,
           name             = p_name,
           gender           = v_gender,
           department       = v_department,
           base_in          = v_base_in,
           phone_number     = p_phone_number,
           email            = p_email,
           message          = p_message,
           last_update_date = sysdate
     where personnel_no = p_personnel_no;
  end;
  procedure insert_fee_detail_by_staffno(p_room_id        in varchar2,
                                         p_fee_items      in varchar2,
                                         p_fee_amounts    in number,
                                         p_fee_first_date in date,
                                         p_fee_last_date  in date) is
    v_every_date     date := p_fee_first_date;
    v_fee_detail_id  number;
    v_starff_no      varchar2(30);
    v_count          number;
    v_room_price     number;
    v_water_price    number;
    v_electric_price number;
    v_network_price  number;
    v_cable_price    number;
    v_fee_period     number := 1;
    type staff_type is table of hls_hsm.staff_no%type index by binary_integer;
    v_staff_table staff_type;
  
    cursor fee_cursor is
      select hfi.fee_no         fee_no,
             hfi.fee_first_date fee_first_date,
             hfi.fee_last_date  fee_last_date,
             hfi.fee_items      fee_items,
             hfi.fee_objects    fee_objects,
             hfi.fee_amounts    fee_amounts
        from hls_rent_fee_info hfi;
  begin
    for i_cursor in fee_cursor loop
      if (i_cursor.fee_items != null or i_cursor.fee_items != '') and
         (i_cursor.fee_objects != null or i_cursor.fee_items != '') then
        if i_cursor.fee_items = p_fee_items and
           i_cursor.fee_objects = p_room_id then
          v_fee_period := v_fee_period + 1;
        end if;
      end if;
    end loop;
    while v_every_date <= p_fee_last_date loop
    
      select count(hh.staff_no)
        into v_count
        from hls_hsm hh, hls_contract_info hci
       where hh.contract_no = hci.h_contract_number
         and hci.room_id = p_room_id
         and v_every_date between hh.live_start_date and
             nvl(hh.check_out_date, date '2099-01-01');
      --得到这一天住在该房间的每一员工的员工号      
      if v_count > 0 then
        for i in 1 .. v_count loop
          select staff_no
            into v_staff_table(i)
            from (select hh.staff_no
                    from hls_hsm hh, hls_contract_info hci
                   where hh.contract_no = hci.h_contract_number
                     and hci.room_id = p_room_id
                     and (v_every_date between hh.live_start_date and
                         nvl(hh.check_out_date, date '2099-01-01'))
                     and rownum <= i)
          minus (select hh.staff_no
                   from hls_hsm hh, hls_contract_info hci
                  where hh.contract_no = hci.h_contract_number
                    and hci.room_id = p_room_id
                    and (v_every_date between hh.live_start_date and
                        nvl(hh.check_out_date, date '2099-01-01'))
                    and rownum <= i - 1);
        end loop;
        --根据员工号以及收费项目进行收费明细表的数据插入(每位员工都进行数据平摊并插入)
        for i in 1 .. v_count loop
          /*计算日租金的平摊，由于日租金是按总金额除以合同生效结束日，所以日租金固定
          这里会出现相同的多行数据，故取rownum=1；
          人数不同平摊金额不一样，取rownum=1的日租金来除以人数进行平摊*/
          select round((hci1.sum_price / (hci1.contract_finish_date -
                       hci1.contract_start_date)) / v_count,
                       2)
            into v_room_price
            from hls_hsm hh1, hls_contract_info hci1
           where hh1.contract_no = hci1.h_contract_number
             and hci1.room_id = p_room_id
             and rownum <= 1;
          --同理计算这一天的各项费用
          --计算水费
          if p_fee_items = 'fee_items_1' then
            select round((p_fee_amounts /
                         (p_fee_last_date - p_fee_first_date)) / v_count,
                         2)
              into v_water_price
              from dual;
          end if;
          --计算电费
          if p_fee_items = 'fee_items_2' then
            select round((p_fee_amounts /
                         (p_fee_last_date - p_fee_first_date)) / v_count,
                         2)
              into v_electric_price
              from dual;
          end if;
          --计算网络费用
          if p_fee_items = 'fee_items_3' then
            select round((p_fee_amounts /
                         (p_fee_last_date - p_fee_first_date)) / v_count,
                         2)
              into v_network_price
              from dual;
          end if;
          --计算有线电视费用
          if p_fee_items = 'fee_items_4' then
            select round((p_fee_amounts /
                         (p_fee_last_date - p_fee_first_date)) / v_count,
                         2)
              into v_cable_price
              from dual;
          end if;
          v_fee_detail_id := hls_fee_detail_s.nextval;
          /*          对于今天还在住宿的员工来说算出其所平摊的费用即可插入明细表
          ，遍历住在同一房间的每位员工 */
          insert into hls_fee_detail
            (fee_detail_id,
             staff_no,
             periods,
             apportion_rental,
             apportion_water,
             apportion_electric,
             apportion_network,
             apportion_cable)
          values
            (v_fee_detail_id,
             v_staff_table(i),
             v_fee_period,
             v_room_price,
             v_water_price,
             v_electric_price,
             v_network_price,
             v_cable_price);
        end loop;
      end if;
      v_every_date := v_every_date + 1;
    end loop;
  end insert_fee_detail_by_staffno;
  --手工核销提交
  procedure verification_insert_update(p_contract_no           varchar2,
                                       p_receipt_no            varchar2,
                                       p_staff_no              varchar2,
                                       p_verification_rental   number,
                                       p_verification_water    number,
                                       p_verification_electric number,
                                       p_verification_network  number,
                                       p_verification_cable    number,
                                       p_receipt_sources       varchar2,
                                       p_message               varchar2) is
    cursor verification_cursor is
      select hpv.creditor_project creditor_project,
             hpv.source_type      source_type,
             hpv.receipt_no       receipt_no,
             hpv.source_object    source_object,
             hpv.verification_fee verification_fee
        from hls_payment_verification hpv
       where hpv.contract_no = p_contract_no;
    v_update_insert   varchar2(30) := 'insert';
    v_verification_no varchar2(30);
    v_number_contract number;
    v_number_staff    number;
  begin
  
    select 'SKHX' || to_char(sysdate, 'yyyymmdd') ||
           trim(to_char(1000 + hls_payment_verification_s.nextval))
      into v_verification_no
      from dual;
    --如果合同存在，游标不为空，则根据员工号更新数据
    --如果该合同下的员工存在，则更新
    --不存在，则插入
    select count(1)
      into v_number_contract
      from hls_payment_verification hpv
     where hpv.contract_no = p_contract_no;
    if v_number_contract != 0 then
      select count(1)
        into v_number_staff
        from hls_payment_verification hpv
       where hpv.source_object = p_staff_no;
    
      --租金
      if v_number_staff != 0 then
        --存在即更新，
      
        update hls_payment_verification hpv
           set hpv.verification_fee = p_verification_rental +
                                      hpv.verification_fee
         where hpv.source_object = p_staff_no
           and hpv.creditor_project = '租金';
      
        --水
      
        update hls_payment_verification hpv
           set hpv.verification_fee = p_verification_water +
                                      hpv.verification_fee
         where hpv.creditor_project = p_staff_no
           and hpv.creditor_project = 'fee_items_1';
      
        --电
      
        update hls_payment_verification hpv
           set hpv.verification_fee = p_verification_electric +
                                      hpv.verification_fee
         where hpv.creditor_project = p_staff_no
           and hpv.creditor_project = 'fee_items_2';
      
        --网络
      
        update hls_payment_verification hpv
           set hpv.verification_fee = p_verification_rental +
                                      hpv.verification_fee
         where hpv.creditor_project = p_staff_no
           and hpv.creditor_project = 'fee_items_3';
      
        --电视
      
        update hls_payment_verification hpv
           set hpv.verification_fee = p_verification_rental +
                                      hpv.verification_fee
         where hpv.creditor_project = p_staff_no
           and hpv.creditor_project = 'fee_items_4';
      else
        --租金
      
        insert_payment_verification(hls_payment_verification_s.nextval,
                                    v_verification_no,
                                    p_contract_no,
                                    '租金',
                                    sysdate,
                                    p_receipt_sources,
                                    p_staff_no,
                                    p_receipt_no,
                                    'CNY',
                                    p_message,
                                    p_verification_rental);
      
        --水
      
        insert_payment_verification(hls_payment_verification_s.nextval,
                                    v_verification_no,
                                    p_contract_no,
                                    'fee_items_1',
                                    sysdate,
                                    p_receipt_sources,
                                    p_staff_no,
                                    p_receipt_no,
                                    'CNY',
                                    p_message,
                                    p_verification_water);
      
        --电
      
        insert_payment_verification(hls_payment_verification_s.nextval,
                                    v_verification_no,
                                    p_contract_no,
                                    'fee_items_2',
                                    sysdate,
                                    p_receipt_sources,
                                    p_staff_no,
                                    p_receipt_no,
                                    'CNY',
                                    p_message,
                                    p_verification_electric);
      
        --网络
      
        insert_payment_verification(hls_payment_verification_s.nextval,
                                    v_verification_no,
                                    p_contract_no,
                                    'fee_items_3',
                                    sysdate,
                                    p_receipt_sources,
                                    p_staff_no,
                                    p_receipt_no,
                                    'CNY',
                                    p_message,
                                    p_verification_network);
      
        --电视
      
        insert_payment_verification(hls_payment_verification_s.nextval,
                                    v_verification_no,
                                    p_contract_no,
                                    'fee_items_4',
                                    sysdate,
                                    p_receipt_sources,
                                    p_staff_no,
                                    p_receipt_no,
                                    'CNY',
                                    p_message,
                                    p_verification_cable);
      
      end if;
      ------------------------
    else
      --租金
      insert_payment_verification(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  '租金',
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_rental);
    
      --水
    
      insert_payment_verification(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  'fee_items_1',
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_water);
    
      --电
    
      insert_payment_verification(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  'fee_items_2',
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_electric);
    
      --网络
    
      insert_payment_verification(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  'fee_items_3',
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_network);
    
      --电视
    
      insert_payment_verification(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  'fee_items_4',
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_cable);
    end if;
    --更新收款事务表
    update hls_rent_receipt_fee hrf
       set hrf.verification_amounts = nvl(p_verification_rental, 0) +
                                      nvl(p_verification_water, 0) +
                                      nvl(p_verification_electric, 0) +
                                      nvl(p_verification_network, 0) +
                                      nvl(p_verification_cable, 0) +
                                      nvl(hrf.verification_amounts, 0),
           hrf.verification_no      = v_verification_no
     where hrf.receipt_objects = p_staff_no;
  
  end verification_insert_update;
  --插入核销事务表
  procedure insert_payment_verification(v_verification_id   number,
                                        v_verification_no   varchar2,
                                        v_contract_no       varchar2,
                                        v_creditor_project  varchar2,
                                        v_verification_date varchar2,
                                        v_source_type       varchar2,
                                        v_source_object     varchar2,
                                        v_receipt_no        varchar2,
                                        v_currency          varchar2,
                                        v_message           varchar2,
                                        v_verification_fee  number) is
  begin
    insert into hls_payment_verification
      (verification_id,
       verification_no,
       contract_no,
       creditor_project,
       verification_date,
       source_type,
       source_object,
       receipt_no,
       currency,
       message,
       verification_fee)
    values
      (v_verification_id,
       v_verification_no,
       v_contract_no,
       v_creditor_project,
       v_verification_date,
       v_source_type,
       v_source_object,
       v_receipt_no,
       v_currency,
       v_message,
       v_verification_fee);
  end insert_payment_verification;

  --新版手工核销提交
  procedure verification_insert(p_contract_no           varchar2,
                                p_receipt_no            varchar2,
                                p_staff_no              varchar2,
                                p_verification_rental   number,
                                p_verification_water    number,
                                p_verification_electric number,
                                p_verification_network  number,
                                p_verification_cable    number,
                                p_receipt_sources       varchar2,
                                p_message               varchar2) is
    v_verification_no varchar2(30);
    v_number_contract number;
    v_number_staff    number;
    v_number_receipt  number;
  begin
    select 'SKHX' || to_char(sysdate, 'yyyymmdd') ||
           trim(to_char(1000 + hls_payment_verification_s.nextval))
      into v_verification_no
      from dual;
    --如果合同存在，游标不为空，则根据员工号更新数据
    --如果该合同下的员工存在，则更新
    --不存在，则插入
    select count(1)
      into v_number_contract
      from hls_verification_tab hvt
     where hvt.contract_no = p_contract_no;
  
    if v_number_contract != 0 then
      select count(1)
        into v_number_staff
        from hls_verification_tab hvt
       where hvt.source_object = p_staff_no;
    
      if v_number_staff != 0 then
        select count(1)
          into v_number_receipt
          from hls_verification_tab hvt
         where hvt.receipt_no = p_receipt_no;
        --更新
        if v_number_receipt != 0 then
          update hls_verification_tab hvt
             set hvt.credit_item_rent     = p_verification_rental +
                                            nvl(hvt.credit_item_rent, 0),
                 hvt.credit_item_water    = p_verification_water +
                                            nvl(hvt.credit_item_water, 0),
                 hvt.credit_item_electric = p_verification_electric +
                                            nvl(hvt.credit_item_electric, 0),
                 hvt.credit_item_network  = p_verification_network +
                                            nvl(hvt.credit_item_network, 0),
                 hvt.credit_item_cable    = p_verification_cable +
                                            nvl(hvt.credit_item_cable, 0)
           where hvt.receipt_no = p_receipt_no;
        else
          insert_verification_tab(hls_payment_verification_s.nextval,
                                  v_verification_no,
                                  p_contract_no,
                                  sysdate,
                                  p_receipt_sources,
                                  p_staff_no,
                                  p_receipt_no,
                                  'CNY',
                                  p_message,
                                  p_verification_rental,
                                  p_verification_water,
                                  p_verification_electric,
                                  p_verification_network,
                                  p_verification_cable);
        end if;
      else
        --insert
        insert_verification_tab(hls_payment_verification_s.nextval,
                                v_verification_no,
                                p_contract_no,
                                sysdate,
                                p_receipt_sources,
                                p_staff_no,
                                p_receipt_no,
                                'CNY',
                                p_message,
                                p_verification_rental,
                                p_verification_water,
                                p_verification_electric,
                                p_verification_network,
                                p_verification_cable);
      end if;
    else
      insert_verification_tab(hls_payment_verification_s.nextval,
                              v_verification_no,
                              p_contract_no,
                              sysdate,
                              p_receipt_sources,
                              p_staff_no,
                              p_receipt_no,
                              'CNY',
                              p_message,
                              p_verification_rental,
                              p_verification_water,
                              p_verification_electric,
                              p_verification_network,
                              p_verification_cable);
    end if;
    update hls_rent_receipt_fee hrf
       set hrf.verification_amounts = nvl(p_verification_rental, 0) +
                                      nvl(p_verification_water, 0) +
                                      nvl(p_verification_electric, 0) +
                                      nvl(p_verification_network, 0) +
                                      nvl(p_verification_cable, 0) +
                                      nvl(hrf.verification_amounts, 0),
           hrf.verification_no      = v_verification_no
     where hrf.receipt_objects = p_staff_no
       and hrf.receipt_no = p_receipt_no;
  
  end verification_insert;
  --新版核销事务表插入
  procedure insert_verification_tab(v_verification_id       number,
                                    v_verification_no       varchar2,
                                    v_contract_no           varchar2,
                                    v_verification_date     date,
                                    v_receipt_sources       varchar2,
                                    v_staff_no              varchar2,
                                    v_receipt_no            varchar2,
                                    v_currency              varchar2,
                                    v_message               varchar2,
                                    v_verification_rental   number,
                                    v_verification_water    number,
                                    v_verification_electric number,
                                    v_verification_network  number,
                                    v_verification_cable    number) is
  begin
    insert into hls_verification_tab
      (verification_id,
       verification_no,
       contract_no,
       verification_date,
       source_type,
       source_object,
       receipt_no,
       currency,
       message,
       credit_item_rent,
       credit_item_water,
       credit_item_electric,
       credit_item_network,
       credit_item_cable)
    values
      (v_verification_id,
       v_verification_no,
       v_contract_no,
       v_verification_date,
       v_receipt_sources,
       v_staff_no,
       v_receipt_no,
       v_currency,
       v_message,
       v_verification_rental,
       v_verification_water,
       v_verification_electric,
       v_verification_network,
       v_verification_cable);
  end insert_verification_tab;
end hls_rent_pkg;
/
