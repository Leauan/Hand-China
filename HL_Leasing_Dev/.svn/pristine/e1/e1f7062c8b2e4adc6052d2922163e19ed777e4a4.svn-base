var override_queryfields = [ 
{
	field : 'lease_item_id',
	queryoperator : "="
},
{
	name : 'lease_item_name',
	queryexpression : "e.short_name like ${@lease_item_name}"
},
{
	name : 'project_id',
	queryexpression : "exists (select 1 from prj_project_lease_item p where p.project_id=${@project_id} and p.lease_item_id=e.lease_item_id)"
},
{
	name : 'project_name',
	queryexpression : "exists (select 1 from prj_project_lease_item_lv p where p.project_id_n like ${@project_name} and p.lease_item_id=e.lease_item_id)"
},
{
	name : 'contract_id',
	queryexpression : "exists (select 1 from con_contract_lease_item c where c.contract_id=${@contract_id} and c.lease_item_id=e.lease_item_id)"
},
{
	name : 'contract_name',
	queryexpression : "exists (select 1 from con_contract_lease_item_lv c where c.contract_id_n like ${@contract_name} and c.lease_item_id=e.lease_item_id)"
}


];

override();
