var override_queryfields = [ 
{
	name : 'lease_start_date_from',
	queryexpression : "trunc(t1.lease_start_date) >= to_date(${@lease_start_date_from},'yyyy-mm-dd')"
},
{
	name : 'lease_start_date_to',
	queryexpression : "trunc(t1.lease_start_date) <= to_date(${@lease_start_date_to},'yyyy-mm-dd')"
}
];

override();
