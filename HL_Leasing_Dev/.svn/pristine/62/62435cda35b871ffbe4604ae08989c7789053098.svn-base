var override_queryfields = [ 
{
	name : 'bp_name',
	queryexpression : "t1.bp_id_tenant_n like ${@bp_name}"
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

override();
