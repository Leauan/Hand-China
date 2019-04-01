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
		}, {
			field : 'project_id',
			queryoperator : "="
		}, {
			field : 'employee_id',
			queryoperator : "="
		}, {
			field : 'lease_organization',
			queryoperator : "="
		}, {
			field : 'contract_id',
			queryoperator : "="
		}, {
			name : 'contract_name',
			queryexpression : "t1.contract_name  like  ${@contract_name}"
		}, {
			field : 'lease_channel',
			queryoperator : "="
		}, {
			field : 'document_type',
			queryoperator : "="
		}, {
			field : 'lease_channel',
			queryoperator : "="
		}, {
			field : 'document_type',
			queryoperator : "="
		}, {
			field : 'business_type',
			queryoperator : "="
		}, {
			field : 'contract_status',
			queryoperator : "="
		}, {
			field : 'division',
			queryoperator : "="
		}

];

var add_datafilters = [
		{
			name : "req_status",
			expression : "t1.req_status = 'NEW' and t1.lease_channel='00'"
		},
		{
			name : "ccr_document_type",
			expression : "exists (select 1 from con_contract_change_req r where r.change_req_id = t1.contract_id and r.document_type = 'BASICHAG')"
		},
		{
			name : 'owner_user_id',
			expression : "(${/session/@role_id}=1 or t1.owner_user_id=${/session/@user_id})"
		} ];

override();
add_datafilter();
