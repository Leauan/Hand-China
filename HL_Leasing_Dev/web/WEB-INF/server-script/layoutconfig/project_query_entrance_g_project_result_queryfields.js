var override_queryfields = [

		{
			field : 'project_name',
			queryoperator : "like"
		},
		{
			field : 'bp_name',
			queryoperator : "like"
		},
		{
			field : 'project_number',
			queryoperator : "like"
		},
		{
			name : 'creation_date_from',
			queryexpression : "t1.creation_date >=to_date(${@creation_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'creation_date_to',
			queryexpression : "trunc(t1.creation_date) <=to_date(${@creation_date_to},'yyyy-mm-dd')"
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
			name : 'reject_date_from',
			queryexpression : "t1.reject_date >=to_date(${@reject_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'reject_date_to',
			queryexpression : "trunc(t1.reject_date) <=to_date(${@reject_date_to},'yyyy-mm-dd')"
		},

		{
			field : 'employee_id',
			queryoperator : "="
		}, {
			field : 'owner_user_id',
			queryoperator : "="
		}, {
			field : 'lease_organization',
			queryoperator : "="
		}, {
			field : 'employee_id_of_manager',
			queryoperator : "="
		}, {
			field : 'division',
			queryoperator : "="
		}, {
			field : 'lease_channel',
			queryoperator : "="
		}, {
			field : 'document_type',
			queryoperator : "="
		}, {
			field : 'project_status',
			queryoperator : "="
		}, {
			field : 'search_term_1',
			queryoperator : "="
		}, {
			field : 'search_term_2',
			queryoperator : "="
		}, {
			name : 'status_not_in',
			queryexpression : "t1.document_type='CARLS'"
		}

];
var add_datafilters = [
		{
			name : 'init_filter',
			expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or t1.invoice_agent_id=su.bp_id) and su.user_id = ${/session/@user_id})"
		}, {
			name : 'project_status',
			expression : "t1.project_status not in ('CLOSED')"
		}, {
			name : 'lease_channel',
			expression : "t1.lease_channel  in ('00')"
		} ];

add_datafilter();

override();
