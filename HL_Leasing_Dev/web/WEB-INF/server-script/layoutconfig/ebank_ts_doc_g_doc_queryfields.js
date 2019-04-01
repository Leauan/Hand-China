var override_queryfields = [
		
		{
			name : 'new_date_from',
			queryexpression : "trunc(t1.t_new_date) >= to_date(${@new_date_from},'YYYY-MM-DD')"
		},
		{
			name : 'new_date_to',
			queryexpression : "trunc(t1.t_new_date) <= to_date(${@new_date_to},'YYYY-MM-DD')"
		},
		{
			name : 'contract_id',
			queryexpression : "exists (select 1 from hls_ebank_document_detail d where d.doc_id = t1.document_id and d.contract_id = ${@contract_id})"
		}
		
];

override();
