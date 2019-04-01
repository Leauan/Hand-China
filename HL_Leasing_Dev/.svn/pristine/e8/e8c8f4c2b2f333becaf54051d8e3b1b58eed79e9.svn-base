var override_queryfields = [ 
{
	name : 'bp_id',
	queryexpression : "t1.bp_id_tenant = ${@bp_id}"
},
{
	name : 'approved_date_from',
	queryexpression : "t1.APPROVED_DATE >= trunc(to_date(${@approved_date_from},'yyyy-mm-dd'))"
},
{
	name : 'approved_date_to',
	queryexpression : "trunc(t1.APPROVED_DATE) <= to_date(${@approved_date_to},'yyyy-mm-dd')"
},
{
	name : 'lease_start_date_from',
	queryexpression : "t1.inception_of_lease >= trunc(to_date(${@lease_start_date_from},'yyyy-mm-dd') )"
},
{
	name : 'lease_start_date_to',
	queryexpression : "trunc(t1.inception_of_lease) <=to_date(${@lease_start_date_to},'yyyy-mm-dd')"
},
{
	name : 'project_id',
	queryexpression : "t1.project_id = ${@project_id}"
},
{
	name : 'project_number',
	queryexpression : "t1.project_number like ${@project_number}"
},
{
	name : 'project_id_n',
	queryexpression : "t1.project_id_n = ${@project_name}"
},
{
	name : 'regulator',
	queryexpression : "t1.regulator = ${@regulator}"
},
{
	field : 'contract_id',
	queryoperator : "="
},
{
	field : 'contract_number',
	queryoperator : "like"
},
{
	field : 'contract_status',
	queryoperator : "="
},
{
	field : 'division',
	queryoperator : "="
},
{
	field : 'document_type',
	queryoperator : "="
},
{
	field : 'business_type',
	queryoperator : "="
},
{
	name : 'data_class',
	queryexpression : "t1.data_class=${@data_class}"
},
{
	name : 'item_frame_number',
	queryexpression : "t1.item_frame_number like '%'|| ${@item_frame_number} || '%'"
}
];
var add_datafilters=[{
	name:'init_filter',
	expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or t1.bp_id_agent_level1=su.bp_id) and su.user_id = ${/session/@user_id})"
}, {
	name : 'lease_channel',
	expression : "t1.lease_channel in ('01')"
}];

add_datafilter();


override();
