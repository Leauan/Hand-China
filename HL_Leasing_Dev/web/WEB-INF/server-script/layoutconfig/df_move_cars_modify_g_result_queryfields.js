var override_queryfields = [
    {
        name : 'hd_number',
        queryexpression : "t1.hd_number like '%'|| ${@hd_number} || '%'"
    },
	{
		name : 'description',
		queryexpression : "t1.user_id_n like '%'|| ${@description} || '%'"
	},
    {
        name : 'created_date',
        queryexpression : "trunc(t1.created_date)  =  trunc(to_date(${@created_date},'YYYY-MM-DD'))"
    }

];
override();
var add_datafilters = [ {
	name : 'user_id',
	expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.bp_id=su.bp_id AND su.bp_category = 'AGENT_DF') ) and su.user_id = ${/session/@user_id})"
} ];

add_datafilter();

