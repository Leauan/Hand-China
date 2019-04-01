var override_queryfields = [
		{
			name : 'query_time_from',
			queryexpression : "trunc(t1.query_time) >= to_date(${@query_time_from},'yyyy-mm-dd')"
		},
		{
			name : 'query_time_to',
			queryexpression : "trunc(t1.query_time) <= to_date(${@query_time_to},'yyyy-mm-dd')"
		}
		

];
override();