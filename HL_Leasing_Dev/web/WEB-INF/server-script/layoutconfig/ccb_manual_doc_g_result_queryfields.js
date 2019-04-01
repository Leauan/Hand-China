var override_queryfields = [ 
{
	name : 'due_date_to',
	queryexpression : "t1.due_date <= to_date(${@due_date_to},'yyyy-mm-dd')"
},
{
	name : 'rent_received_flag',
	queryexpression : "(${@rent_received_flag} = 'N' OR NOT EXISTS (SELECT 1 FROM hls_ccb_manual_cashflow_lv t2 WHERE t2.cf_item = 1 AND t2.contract_id = (SELECT t3.contract_id   FROM hls_ccb_manual_cashflow_lv t3 WHERE t3.cf_item = 9 AND t3.cashflow_id = t1.cashflow_id)  AND t2.times = (SELECT t3.times   FROM hls_ccb_manual_cashflow_lv t3 WHERE t3.cf_item = 9   AND t3.cashflow_id = t1.cashflow_id)))"
},
{
	name : 'cup_channel',
	queryexpression : "t1.cup_channel=${@cup_channel}"
}
];
var add_datafilters = [ {
	name : 'contract_status',
	expression : "t1.contract_status in ('INCEPT','ET','ETING')"
} 
];

add_datafilter();

override();
