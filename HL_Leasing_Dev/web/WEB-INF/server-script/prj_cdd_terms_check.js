var config = $config();
var tabs = CompositeUtil.findChild(config, 'tabs');
var events = CompositeUtil.findChild(config, 'events');
var prj_cdd_terms_check_bp_path = $ctx
		.get('/model/prj_cdd_terms_check_bp_path').getChildren();
function newMap(name) {
	return new CompositeMap("a", 'http://www.aurora-framework.org/application',
			name);
}
function bind(s) {
	var ss = s.split('?');
	var sss = [];
	sss[0] = ss[0];
	for ( var i = 1; i < ss.length; i++) {
		sss.push(arguments[i]);
		sss.push(ss[i]);
	}
	return sss.join('');
}
function cm(obj, m) {
	var m = m ? m : new CompositeMap();
	for ( var k in obj)
		m[k] = obj[k];
	return m;
}

function create_tab_ref(r) {
	var s = bind(
			"${/request/@context_path}/modules/prj/PRJ517/prj_cdd_terms_check_detail.screen?project_id=?&bp_id=?&bp_category=?&winid=?&bp_seq=?&function_code=?",
			'?', r.project_id, r.bp_id, r.bp_category, $ctx.parameter.winid,r.bp_seq,$ctx.parameter.function_code);
	return s;
}

function create_tab(r) {
	var tab = newMap('tab');
	tab.prompt = r.tab_desc + r.bp_seq;
	tab.width = '120';
	tab.ref = create_tab_ref(r);
	tabs.addChild(tab.getData());
}
var tenant_bp_seq = 0;
var guarantor_bp_seq = 0;
var actual_controller_bp_seq = 0;
for ( var i = 0; i < prj_cdd_terms_check_bp_path.length; i++) {
	var r = prj_cdd_terms_check_bp_path[i];
	if (r.bp_category == 'TENANT') {
		tenant_bp_seq = tenant_bp_seq + 1;
		r.bp_seq = tenant_bp_seq;
		r.tab_desc = '承租人';
		create_tab(r);
	} else if (r.bp_category == 'GUARANTOR') {
		guarantor_bp_seq = guarantor_bp_seq + 1;
		r.bp_seq = guarantor_bp_seq;
		r.tab_desc = '担保人';
		create_tab(r);
	} else if (r.bp_category == 'ACTUAL_CONTROLLER') {
		actual_controller_bp_seq = actual_controller_bp_seq + 1;
		r.bp_seq = actual_controller_bp_seq;
		r.tab_desc = '自然人';
		create_tab(r);
	}
}