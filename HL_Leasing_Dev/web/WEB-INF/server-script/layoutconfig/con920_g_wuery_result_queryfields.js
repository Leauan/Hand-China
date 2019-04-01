var override_queryfields = [
		{
			name : 'inception_date_from',
			queryexpression : "trunc(t1.inception_date) >= to_date(${@inception_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'inception_date_to',
			queryexpression : "trunc(t1.inception_date) <= to_date(${@inception_date_to},'yyyy-mm-dd')"
		},
		{
			name : 'create_con_date_from',
			queryexpression : "trunc(t1.create_con_date) >= to_date(${@create_con_date_from},'yyyy-mm-dd')"
		},
		{
			name : 'create_con_date_to',
			queryexpression : "trunc(t1.create_con_date) <= to_date(${@create_con_date_to},'yyyy-mm-dd')"
		} ];
var add_datafilters = [ {
	name : 'project_status',
	expression : "t1.project_status not in ('CLOSED')"
} ];

add_datafilter();
override();
