var con_print_path = {
	'con_print_path' : 'D:/KAIFA/eclipse/workspace/Rd_Leasing/save_path'
    
	//'con_print_path'  : '//128.1.12.135/c/project/bcml_hls/print_save'
		
   //'con_print_path'	: '//128.1.18.17/bcml_hls/save_print'	
};



function print_insert_fnd_atm(type) {
	var guid_file_name_path = $ctx.get('/model/guid_file_name_path')
			.getChildren();
	var file_name = $ctx.parameter.file_name + '.' + type;
	var file_path = con_print_path['con_print_path']
			+ guid_file_name_path[0].guid_file_name;
	$bm('cont.CON500.con_sign_content_update').update( {
		table_name : 'CON_CONTRACT_CONTENT',
		content_id : $ctx.parameter.content_id,
		file_name : file_name.toString(),
		file_path : file_path.toString()
	});
}