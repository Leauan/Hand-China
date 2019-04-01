var override_queryfields = [ 
{
	name : 'journal_num_from',
	queryexpression : "t1.journal_header_id>=${@journal_num_from}"
},
{
	name : 'journal_num_to',
	queryexpression : "t1.journal_header_id<=${@journal_num_to}"
},
{
	name : 'journal_date_from',
	queryexpression : "t1.journal_date >= to_date(${@journal_date_from},'YYYY-MM-DD')"
},
{
	name : 'journal_date_to',
	queryexpression : "t1.journal_date <= to_date(${@journal_date_to},'YYYY-MM-DD')"
}

];

override();
