var override_queryfields = [
{
	name:'bp_id',
	queryexpression:"exists (select 1 from con_contract_bp cb where cb.contract_id = t1.contract_id  and cb.bp_id = ${@bp_id} and cb.bp_category in ('TENANT', 'GUARANTOR'))"
},
{
	field:'contract_id',
	queryoperator:"="
},


 ];

override();
