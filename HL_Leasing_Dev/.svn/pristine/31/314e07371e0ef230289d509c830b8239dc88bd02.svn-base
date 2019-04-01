var override_queryfields = [ 
{
	name : 'bp_id',
	queryexpression : "t1.bp_id_tenant=${@bp_id}"
},
{
	name : 'bp_name',
	queryexpression : "exists (select 1 from hls_bp_master hr where hr.bp_id=t1.bp_id_tenant and hr.bp_name like ${@bp_name})"
},
{
	name : 'lease_start_date_from',
	queryexpression : "t1.lease_start_date between to_date(${@lease_start_date_from},'yyyy-mm-dd') and nvl(to_date(${@lease_start_date_to},'yyyy-mm-dd'),t1.lease_start_date)"
},
{
	name : 'lease_start_date_to',
	queryexpression : "t1.lease_start_date between nvl(to_date(${@lease_start_date_from},'yyyy-mm-dd'),t1.lease_start_date) and to_date(${@lease_start_date_to},'yyyy-mm-dd')"
},
{
	field : 'project_id',
	queryoperator : "="
},
{
	field : 'employee_id',
	queryoperator : "="
},
{
	field : 'lease_organization',
	queryoperator : "="
},
{
	field : 'contract_id',
	queryoperator : "="
},
{
	name : 'contract_name',
	queryexpression : "t1.contract_name  like  ${@contract_name}"
},
{
	field : 'lease_channel',
	queryoperator : "="
},
{
	field : 'document_type',
	queryoperator : "="
},
{
	field : 'lease_channel',
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
	field : 'contract_status',
	queryoperator : "="
},
{
	field : 'division',
	queryoperator : "="
}

];

override();
