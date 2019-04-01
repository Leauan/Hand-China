function request(args) {
	if (!args)
		args = {};
	var url = args.url || '';
	var para = args.para || {};
	var _success = args['success'] || function() {
	};
	var _failure = args['failure'] || function() {
	};

	var data = "_request_data=" + java.net.URLEncoder.encode(JSON.stringify({
		parameter : para
	}), "UTF-8")

	var ret;
	var ret_json;
	try {
		var is = Packages.aurora.plugin.util.HttpUtils.urlPost(url, data,
				'application/x-www-form-urlencoded;charset=utf8', "UTF-8");
		ret = Packages.aurora.plugin.util.IOUtilsEx.newString(is, "UTF-8");
		ret_json = JSON.parse(ret);
	} catch (e) {
		_failure({
			"success" : false,
			"error" : {
				"code" : "error",
				"message" : e.message
			}
		})
		return;
	}
	if (!ret_json.success) {
		_failure(ret_json);
	} else {
		_success(ret_json);
	}
}