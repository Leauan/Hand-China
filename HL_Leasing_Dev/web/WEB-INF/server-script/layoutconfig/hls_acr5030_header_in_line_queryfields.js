var override_queryfields = [
{
	name:'deadline_date',
	queryexpression:"t1.deadline_date=to_date(${@deadline_date},'YYYY-MM-DD')"
},
{
	name:'actual_amount',
	queryexpression:"t1.actual_amount=${@actual_amount}"
},
{
	name:'handle_flag_n',
	queryexpression:"t1.handle_flag_n=${@handle_flag_n}"
}
 ];

override();
