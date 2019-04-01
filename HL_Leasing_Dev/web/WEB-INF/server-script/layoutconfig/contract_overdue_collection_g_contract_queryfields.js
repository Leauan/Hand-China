var override_queryfields = [ 
{
	name : 'first_pay_date_from',
	queryexpression : "trunc(t1.first_pay_date) >= to_date(${@first_pay_date_from},'yyyy-mm-dd')"
},
{
	name : 'first_pay_date_to',
	queryexpression : "trunc(t1.first_pay_date) <= to_date(${@first_pay_date_to},'yyyy-mm-dd')"
},
{
	name : 'overdue_times_from',
	queryexpression : "t1.overdue_times >= ${@overdue_times_from}"
},
{
	name : 'overdue_times_to',
	queryexpression : "t1.overdue_times <= ${@overdue_times_to}"
},
{
	name:  'overdue_flag',
	queryexpression : "t1.overdue_times > decode(${@overdue_flag},'Y',-1,0)"
},
{
	name : 'overdue_max_days_f',
	queryexpression : "t1.overdue_max_days >= ${@overdue_max_days_f}"
},
{
	name : 'overdue_max_days_t',
	queryexpression : "t1.overdue_max_days <= ${@overdue_max_days_t}"
}
];

override();
