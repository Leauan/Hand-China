var override_queryfields = [
{
	name : 'lease_start_date_from',
	queryexpression : "trunc(t1.lease_start_date) >= to_date(${@lease_start_date_from},'yyyy-mm-dd')"
},
{
	name : 'lease_start_date_to',
	queryexpression : "trunc(t1.lease_start_date) <= to_date(${@lease_start_date_to},'yyyy-mm-dd')"
},
{
	name : 'lease_end_date_from',
	queryexpression : "trunc(t1.lease_end_date) >= to_date(${@lease_end_date_from},'yyyy-mm-dd')"
},
{
	name : 'lease_end_date_to',
	queryexpression : "trunc(t1.lease_end_date) <= to_date(${@lease_end_date_to},'yyyy-mm-dd')"
}
		 ];
var add_datafilters = [ {
	name : 'contract_status',
	expression : "t1.data_class = 'NORMAL' and t1.contract_status in ('INCEPT','ET','AD','TERMINATE') and t1.lease_channel='00'"
} ];

add_datafilter();
override();
