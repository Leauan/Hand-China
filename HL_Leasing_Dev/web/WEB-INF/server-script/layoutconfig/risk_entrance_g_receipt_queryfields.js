var override_queryfields = [ 
{
	name : 'receipt_date_from',
	queryexpression : "t1.receipt_date between to_date(${@receipt_date_from},'yyyy-mm-dd') and nvl(to_date(${@receipt_date_to},'yyyy-mm-dd'),t1.receipt_date)"
},
{
	name : 'receipt_date_to',
	queryexpression : "t1.receipt_date between nvl(to_date(${@receipt_date_from},'yyyy-mm-dd'),t1.receipt_date) and to_date(${@receipt_date_to},'yyyy-mm-dd')"
}
];

override();
