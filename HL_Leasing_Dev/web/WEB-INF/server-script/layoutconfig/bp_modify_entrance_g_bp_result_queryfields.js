var override_queryfields = [
{
	name:'bp_code',
	queryexpression:"t1.bp_code=${@bp_code}"
},

{
	name:'bp_name',
	queryexpression:"t1.bp_name like ${@bp_name}"
},
{
	field:'bp_category',
	queryoperator:"="
},
{
	name:'contract_id',
	queryexpression:"exists (select 1 from con_contract_bp b where b.contract_id = ${@contract_id} and t1.bp_id=b.bp_id )"
},
{
	name:'contract_name',
	queryexpression:"exists (select 1 from con_contract_bp bp,con_contract cc where bp.contract_id=cc.contract_id and cc.contract_name like ${@contract_name} and bp.bp_id=t1.bp_id)"
},
{
	name:'contract_number',
	queryexpression:"exists (select 1 from con_contract_bp bp,con_contract cc where bp.contract_id=cc.contract_id and cc.contract_number = ${@contract_number} and bp.bp_id=t1.bp_id)"
},
{
	name:'class_desc',
	queryexpression:"t1.bp_class = ${@class_desc}"
},
{	
	name:'enabled_flag_query',
	queryexpression:"(t1.enabled_flag=${@enabled_flag_query} or ${@enabled_flag_query}='ALL')"
}






 ];

override();
