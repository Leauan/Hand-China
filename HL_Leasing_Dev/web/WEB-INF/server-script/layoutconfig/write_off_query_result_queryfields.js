var override_queryfields = [ 
{
	name : 'write_off_date_from',
	//modified by 20834
	queryexpression : "trunc(t1.write_off_date) >= to_date(${@write_off_date_from},'yyyy-mm-dd')"
},
{
	name : 'write_off_date_to',
	queryexpression : "trunc(t1.write_off_date) <= to_date(${@write_off_date_to},'yyyy-mm-dd')"
}
];



override();
