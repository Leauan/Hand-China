var override_queryfields = [ 
{
	name : 'start_date',
	queryexpression : "t1.start_date between to_date(${@start_date},'yyyy-mm-dd') and nvl(to_date(${@end_date},'yyyy-mm-dd'),t1.start_date)"
},
{
	name : 'end_date',
	queryexpression : "t1.end_date between nvl(to_date(${@start_date},'yyyy-mm-dd'),t1.end_date) and to_date(${@end_date},'yyyy-mm-dd')"
}
];

override();
