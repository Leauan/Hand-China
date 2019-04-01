var override_queryfields = [
		{
			name : 'submit_date_from',
			queryexpression : "to_date(substr(t1.submit_date,1,10),'yyyy-mm-dd') >= to_date(${@submit_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'submit_date_to',
			queryexpression : "to_date(substr(t1.submit_date,1,10),'yyyy-mm-dd') <= to_date(${@submit_date_to},'yyyy-mm-dd')"
		},
		{
			name : 'down_payment_ratio_from',
			queryexpression : "t1.down_payment_ratio >= ${@down_payment_ratio_from}"
		},
		{
			name : 'down_payment_ratio_to',
			queryexpression : "t1.down_payment_ratio < ${@down_payment_ratio_to}"
		} ];

var add_datafilters = [{
	name : 'project_status',
	expression : "t1.project_status in ('APPROVING','CONTRACT_CREATED','APPROVED_RETURN')"
},
{
	name : 'bp_class',
	expression : "t1.bp_class = 'NP'"
}];
add_datafilter();
override();
