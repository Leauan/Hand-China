var override_queryfields = [
		{
			name : 'contract_number_from',
			queryexpression : "t1.contract_number >= ${@contract_number_from}"
		},
		{
			name : 'contract_number_to',
			queryexpression : "t1.contract_number <=  ${@contract_number_to}"
		},{
			name : 'submit_date_from',
			queryexpression : "t1.approved_date between to_date(${@submit_date_from},'yyyy-mm-dd') and nvl(to_date(${@submit_date_to},'yyyy-mm-dd'),t1.approved_date)"
		},
		{
			name : 'submit_date_to',
			queryexpression : "t1.approved_date between nvl(to_date(${@submit_date_from},'yyyy-mm-dd'),t1.approved_date) and to_date(${@submit_date_to},'yyyy-mm-dd')"
		},{
			name : 'finance_amount',
			queryexpression : "t1.finance_amount >= ${@finance_amount}"
		},
		{
			name : 'finance_amount_to',
			queryexpression : "t1.finance_amount <= ${@finance_amount_to}"
		},
		{
			name : 'approved_date',
			queryexpression : "trunc(t1.approved_date) = trunc(to_date(${@approved_date},'yyyy-mm-dd'))"
		}
		];
var add_datafilters=[{
	name:'init_filter',
	expression : " (t1.bp_id in (select bp_id from sys_user su where (su.user_id = ${/session/@user_id} AND su.user_id <> 1) or (decode(${/session/@user_id},1,'Y','N')='Y')))"
}];

add_datafilter();
override();
