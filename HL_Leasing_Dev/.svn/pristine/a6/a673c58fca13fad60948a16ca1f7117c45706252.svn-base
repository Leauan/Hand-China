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
var add_datafilters = [ {
	name : 'contract_status',
	expression : "t1.data_class = 'NORMAL' and exists (select 1 from yonda_doc_status_history t where t.document_category = 'CONTRACT' and t.document_id=t1.contract_id and t.status = '280') and t1.contract_status in ('TERMINATE','ET','AD')"
} ];

add_datafilter();
override();
