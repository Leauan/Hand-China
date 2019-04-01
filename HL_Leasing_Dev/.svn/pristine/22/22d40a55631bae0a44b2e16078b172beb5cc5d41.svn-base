var override_queryfields = [

		{
			field : 'project_name',
			queryoperator : "like"
		},
		{
			field : 'bp_id_tenant',
			queryoperator : "="
		},
		{
			field : 'project_number',
			queryoperator : "like"
		},
		{
			name : 'submit_date_from',
			queryexpression : "t1.submit_date >=to_date(${@submit_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'submit_date_to',
			queryexpression : "trunc(t1.submit_date) <=to_date(${@submit_date_to},'yyyy-mm-dd')"
		},{
			field : 'lease_organization',
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
		}

];
var add_datafilters = [
		{
			name : 'init_filter',
			expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.bp_id_tenant=su.bp_id AND su.bp_category = 'AGENT_DF') or  t1.assignor_id=su.bp_id ) and su.user_id = ${/session/@user_id})"
		}, {
			name : 'lease_channel',
			expression : "t1.lease_channel in ('01')"
		} ];

add_datafilter();

override();
