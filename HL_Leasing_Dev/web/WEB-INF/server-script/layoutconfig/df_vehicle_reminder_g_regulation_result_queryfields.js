
var add_datafilters = [
		{
			name : 'init_filter',
			expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.bp_id_tenant=su.bp_id AND su.bp_category in  ('AGENT_DF','AGENT')) or  t1.assignor_id=su.bp_id ) and su.user_id = ${/session/@user_id})"
		} ];

add_datafilter();
