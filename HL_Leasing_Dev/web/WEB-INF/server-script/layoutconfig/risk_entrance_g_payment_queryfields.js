var override_queryfields = [ 
{
	name : 'pay_date_from',
	queryexpression : "t1.pay_date between to_date(${@pay_date_from},'yyyy-mm-dd') and nvl(to_date(${@pay_date_to},'yyyy-mm-dd'),t1.pay_date)"
},
{
	name : 'pay_date_to',
	queryexpression : "t1.pay_date between nvl(to_date(${@pay_date_from},'yyyy-mm-dd'),t1.pay_date) and to_date(${@pay_date_to},'yyyy-mm-dd')"
}
];

override();
