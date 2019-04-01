var override_queryfields = [
	{
		name : 'item_frame_number',
		queryexpression : "t1.item_frame_number like '%'|| ${@item_frame_number} || '%'"
	}
];
override();
var add_datafilters = [
		{
			name : "lease_channel",
			expression : "t1.lease_channel = '01' and t1.contract_status in ('INCEPT') and data_class ='NORMAL'  and (select car_status from con_contract_df_car_info where contract_id =t1.contract_id)='STOCK_IN'"
		},{
			name : 'owner_user_id',
			expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.bp_id_tenant=su.bp_id AND su.bp_category = 'AGENT_DF') or  t1.assignor_id=su.bp_id ) and su.user_id = ${/session/@user_id})"
		}
		];
add_datafilter();

