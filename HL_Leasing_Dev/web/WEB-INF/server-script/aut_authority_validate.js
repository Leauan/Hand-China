var error_message, script;

function create_error_script() {
	var config = $config();
	var view = CompositeUtil.findChild(config, 'view');
	var list = view.getChilds();
	list.clear();
	var vf = CompositeUtil.findChild(config, 'view-config');
	if (vf) {
		vf.getParent().removeChild(vf);
	}
	script = view.createChild('script');
}

function check_sub_error_messages(sub_error_messages) {
	var sub_error_message = sub_error_messages[0];
	if (sub_error_message.CHECK_MESSAGE
			|| sub_error_message.COMPANY_CHECK_MESSAGE) {
		create_error_script();
		if (sub_error_message.CHECK_MESSAGE
				&& sub_error_message.COMPANY_CHECK_MESSAGE) {
			error_message = sub_error_message.CHECK_MESSAGE + '-'
					+ sub_error_message.COMPANY_CHECK_MESSAGE;
		} else {
			if (sub_error_message.CHECK_MESSAGE) {
				error_message = sub_error_message.CHECK_MESSAGE;
			} else {
				error_message = sub_error_message.COMPANY_CHECK_MESSAGE;
			}
		}
		$ctx.parameter.continue_flag = 'N';
		script.setText("alert('" + error_message + "');$('"
				+ $ctx.parameter.winid + "').close();");
	}
}

if (!$ctx.parameter.tab_tab_code) {
	var document_authority_bm;
	if ($ctx.parameter.from_master_flag == 'Y') {
		document_authority_bm = $bm('basic.aut_master_authority');
	} else {
		document_authority_bm = $bm('basic.aut_document_authority');
	}
	var sub_document_authority = document_authority_bm.queryAsMap();
	var sub_error_messages = sub_document_authority.getChildren();
	check_sub_error_messages(sub_error_messages);
}