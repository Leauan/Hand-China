var override_queryfields = [
{
	name:'bp_code_from',
	queryexpression:"t1.bp_code between ${@bp_code_from} and nvl(${@bp_code_to},t1.bp_code)"
},
{
	name:'bp_code_to',
	queryexpression:"t1.bp_code between nvl(${@bp_code_from},t1.bp_code) and ${@bp_code_to}"
},
{
	name:'bp_name',
	queryexpression:"t1.bp_name like ${@bp_name}"
},
{
	name:'extra_nam',
	queryexpression:"t1.extra_nam like ${@extra_nam}"
},
{
	field:'bp_type',
	queryoperator:"="
},
{
	name:'project_id',
	queryexpression:"exists (select 1 from prj_project_bp b where b.project_id=${@project_id} and t1.bp_id=b.bp_id )"
},
{
	name:'project_name',
	queryexpression:"exists (select 1 from prj_project_bp_lv b where b.project_id_n like ${@project_name} and t1.bp_id=b.bp_id )"
},
{
	name:'contract_id',
	queryexpression:"exists (select 1 from con_contract_bp b where b.contract_id like ${@contract_id} and t1.bp_id=b.bp_id )"
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
	field:'bp_class',
	queryoperator:'='
},
{	
	name:'enabled_flag_query',
	queryexpression:"(t1.enabled_flag=${@enabled_flag_query} or ${@enabled_flag_query}='ALL')"
}






 ];

override();
