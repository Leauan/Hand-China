var override_queryfields = [
{
	name:'mortgage_code',
	queryexpression:"t1.mortgage_code like ${@mortgage_code}"
},
{
	name:'mortgage_name',
	queryexpression:"t1.mortgage_name like ${@mortgage_name}"
},
{
	field:'mortgage_type',
	queryoperator:'='
},
{
	field:'mortgage_ast_classfication',
	queryoperator:'='
},
{
	field:'mortgage_asset_detail',
	queryoperator:'='
},
{
	field:'mortgage_contract_no',
	queryoperator:'='
},
{
	field:'mortgage_register_no',
	queryoperator:'='
},
{
	field:'bp_id_mortgagor',
	queryoperator:'='
},
{
	field:'bp_id_evaluator',
	queryoperator:'='
}

];

override();
