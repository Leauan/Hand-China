var override_queryfields = [ 

{
	field : 'project_number',
	queryoperator : "like"
},
{
	field : 'bp_name',
	queryoperator : "like"
},

{
	name : 'submit_date_from',
	queryexpression : "t1.submit_date >=to_date(${@submit_date_from},'yyyy-mm-dd')"
},
{
	name : 'submit_date_to',
	queryexpression : "trunc(t1.submit_date) <=to_date(${@submit_date_to},'yyyy-mm-dd')"
},
{
	name : 'create_con_date_f',
	queryexpression : "trunc(t1.create_con_date) >=to_date(${@create_con_date_f},'yyyy-mm-dd')"
},
{
	name : 'create_con_date_t',
	queryexpression : "trunc(t1.create_con_date) <=to_date(${@create_con_date_t},'yyyy-mm-dd')"
},


{
	name : 'reject_date_from',
	queryexpression : "t1.reject_date >=to_date(${@reject_date_from},'yyyy-mm-dd')"
},
{
	name : 'reject_date_to',
	queryexpression : "trunc(t1.reject_date) <=to_date(${@reject_date_to},'yyyy-mm-dd')"
},

{
	field : 'division',
	queryoperator : "="
},
{
	field : 'lease_channel',
	queryoperator : "="
},

{
	field : 'project_status',
	queryoperator : "="
},

];
var add_datafilters = [{
	name : 'project_status',
	expression : "t1.project_status in ('APPROVING','CONTRACT_CREATED','APPROVED_RETURN','REJECT','NEW')"
},{
	name : 'lease_channel',
	expression : "t1.lease_channel = '00'"
}];
add_datafilter();
override();
