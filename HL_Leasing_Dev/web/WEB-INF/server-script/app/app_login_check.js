var login_check_bm = $bm('app.app_check_login');
var check_result;
try {
	login_check_bm.update({
		access_token : $ctx.parameter.access_token,
		user_id : $ctx.parameter.user_id
	});
	if ($ctx.parameter.error_message) {
		$ctx.parameter.return_status = 'TIMEOUT';
	} else {
		$ctx.parameter.return_status = 'S';
	}
	$ctx.parameter.return_message = $ctx.parameter.error_message;

} catch (e) {
	$ctx.success = "true";
	$ctx.parameter.return_status = 'E';
	$ctx.parameter.return_message = String(e);
}
if ($ctx.parameter.return_status == 'TIMEOUT') {
	check_result = {
		result : $ctx.parameter.return_status,
		message : $ctx.parameter.return_message
	};
	$ctx.parameter.json = JSON.stringify(check_result);
}
