var override_queryfields = [{
			name : 'created_date',
			queryexpression : "trunc(t1.created_date)  =  trunc(to_date(${@created_date},'YYYY-MM-DD'))"
		}

];

override();

var add_datafilters = [ {
	name : 'owner_user_id',
	expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.bp_id_tenant=su.bp_id AND su.bp_category = 'AGENT_DF') or  t1.assignor_id=su.bp_id ) and su.user_id = ${/session/@user_id})"
},
{
	name : 'redemp_payment',
	expression : "t1.redemp_payment >0"
}]

add_datafilter();

