var override_queryfields = [
		{
			name : 'last_update_date_from',
			queryexpression : "t1.last_update_date_n >= to_date(${@last_update_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'last_update_date_to',
			queryexpression : "t1.last_update_date_n <= to_date(${@last_update_date_to},'yyyy-mm-dd')"
		}

];
var add_datafilters = [ {
	name : 'contract_status',
	expression : "(t1.contract_status in ('PENDING','ET','ETING','ADING','AD'))"

}

];
add_datafilter();
override();