var override_queryfields = [
		{
			name : 'tax_type_rate',
			queryexpression : "t1.tax_type_rate=${@tax_type_rate}"
		},
		{
			name : 'invoice_date_from',
			queryexpression : "t1.invoice_date between to_date(${@invoice_date_from},'yyyy-mm-dd') and nvl(to_date(${@invoice_date_to},'yyyy-mm-dd'),t1.invoice_date)"
		},
		{
			name : 'invoice_date_to',
			queryexpression : "t1.invoice_date between nvl(to_date(${@invoice_date_from},'yyyy-mm-dd'),t1.invoice_date) and to_date(${@invoice_date_to},'yyyy-mm-dd')"
		}

];

var add_datafilters = [];
override();
add_datafilter();
