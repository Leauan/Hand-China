var override_queryfields = [ 
{
	name : 'lease_start_date_from',
	queryexpression : "t1.inception_of_lease >= to_date(${@lease_start_date_from},'yyyy-mm-dd')"
},
{
	name : 'lease_start_date_to',
	queryexpression : "t1.inception_of_lease <= to_date(${@lease_start_date_to},'yyyy-mm-dd')"
}
];

var add_datafilters=[{
	name:'authority_flag',
	expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or t1.bp_id_agent_level1=su.bp_id) and su.user_id = ${/session/@user_id}) and t1.lease_channel='00'"
}];

add_datafilter();

override();
