var override_queryfields = [ 
{
	name : 'bp_name',
	queryexpression : "t1.bp_id_tenant_n like ${@bp_name}"
},
{
	name : 'submit_date_detail_from',
	queryexpression : "to_date(t1.submit_date_detail,'yyyy-mm-dd') >=trunc(to_date(${@submit_date_detail_from},'yyyy-mm-dd'))"
},
{
	name : 'submit_date_detail_to',
	queryexpression : "trunc(to_date(t1.submit_date_detail,'yyyy-mm-dd')) <=to_date(${@submit_date_detail_to},'yyyy-mm-dd')"
},
{
	name : 'create_con_date_from',
	queryexpression : "t1.create_con_date >=to_date(${@create_con_date_from},'yyyy-mm-dd')"
},
{
	name : 'create_con_date_to',
	queryexpression : "t1.create_con_date <=to_date(${@create_con_date_to},'yyyy-mm-dd')"
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
	name : 'contract_creation_date_from', 
	queryexpression : "t1.approved_date >= trunc(to_date(${@contract_creation_date_from},'yyyy-mm-dd') )"
},
{
	name : 'contract_creation_date_to',
	queryexpression : "trunc(t1.approved_date) <=to_date(${@contract_creation_date_to},'yyyy-mm-dd')"
},
{
	name : 'write_off_date_from',
	queryexpression : "to_date(t1.write_off_date,'yyyy-mm-dd') >= to_date(${@write_off_date_from},'yyyy-mm-dd')"
},
{
	name : 'write_off_date_to',
	queryexpression : "to_date(t1.write_off_date,'yyyy-mm-dd') <=to_date(${@write_off_date_to},'yyyy-mm-dd')"
},

//��ͬȡ�����ڴӡ���ͬȡ�����ڵ�
{
	name : 'closed_date_from',
	queryexpression : "t1.closed_date >= trunc(to_date(${@closed_date_from},'yyyy-mm-dd') )"
},
{
	name : 'closed_date_to',
	queryexpression : "trunc(t1.closed_date) <=to_date(${@closed_date_to},'yyyy-mm-dd')"
},
//

{
	field : 'employee_id',
	queryoperator : "="
},
{
	name : 'project_number',
	queryexpression : "t1.project_number like ${@project_number}"
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
	name : 'employee_name_of_manager',
	queryexpression : "t1.employee_id_of_manager like ${@employee_name_of_manager}"
},
{
	field : 'lease_organization',
	queryoperator : "="
},
{
	field : 'lease_channel',
	queryoperator : "="
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
	name : 'company_authority',
	queryexpression : "t1.company_id in (select company_id from fnd_companies start with company_id =${@company_authority} connect by prior company_id = parent_biz_company_id)"
},
{
	name : 'data_class',
	queryexpression : "t1.data_class=${@data_class}"
},
{
	name : 'sec_tenant_name',
	queryexpression : "t1.bp_name_sec_tenant like ${@sec_tenant_name}"
}

];
var add_datafilters=[{
	name:'init_filter',
	expression : " t1.lease_channel='00' and exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or t1.bp_id_agent_level1=su.bp_id) and su.user_id = ${/session/@user_id})"
}];

add_datafilter();


override();
