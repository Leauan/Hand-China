var config = $config();
var tabs = CompositeUtil.findChild(config, 'tabs');
var events = CompositeUtil.findChild(config, 'events');
var tabpanel_layout_type_path = $ctx.get('/model/tabpanel_layout_type_path').getChildren();
function newMap(name) {
	return new CompositeMap("a",'http://www.aurora-framework.org/application',
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

function create_screen_include(r){
	var s=newMap('screen-include');
	s.screen=bind("modules/prj/PRJ500/prj_project_create_tree_detail.screen?tab_tab_code=?&layout_code=?&document_id=?&document_category=?&document_type=?&tree_code=?&winid=?&_vh=?&_vw=?&number_of_tenant=?&number_of_guarantor=?&number_of_actual_controller=?&number_of_quotation=?&bp_seq=?&function_usage=?&function_code=?&cdd_list_id=?&calc_type=?&maintain_type=?&declare_flag=?&default_value_dsid=?", 
        	'?', r.tab_code, $ctx.parameter.layout_code, $ctx.parameter.document_id, $ctx.parameter.document_category,$ctx.parameter.document_type,$ctx.parameter.tree_code, $ctx.parameter.winid,$ctx.parameter._vh,$ctx.parameter._vw,$ctx.parameter.number_of_tenant,$ctx.parameter.number_of_guarantor,$ctx.parameter.number_of_actual_controller,$ctx.parameter.number_of_quotation,r.bp_seq,$ctx.parameter.function_usage,$ctx.parameter.function_code,$ctx.parameter.cdd_list_id,$ctx.parameter.calc_type,$ctx.parameter.maintain_type,$ctx.parameter.declare_flag,$ctx.parameter.default_value_dsid);
	return s;
}

function create_tab_ref(r){
	var s=bind("${/request/@context_path}/modules/prj/PRJ500/prj_project_create_tree_detail.screen?tab_tab_code=?&layout_code=?&document_id=?&document_category=?&document_type=?&tree_code=?&winid=?&_vh=?&_vw=?&number_of_tenant=?&number_of_guarantor=?&number_of_actual_controller=?&number_of_quotation=?&bp_seq=?&function_usage=?&function_code=?&cdd_list_id=?&calc_type=?&maintain_type=?&declare_flag=?&default_value_dsid=?", 
        	'?', r.tab_code, $ctx.parameter.layout_code, $ctx.parameter.document_id, $ctx.parameter.document_category,$ctx.parameter.document_type,$ctx.parameter.tree_code, $ctx.parameter.winid,$ctx.parameter._vh,$ctx.parameter._vw,$ctx.parameter.number_of_tenant,$ctx.parameter.number_of_guarantor,$ctx.parameter.number_of_actual_controller,$ctx.parameter.number_of_quotation,r.bp_seq,$ctx.parameter.function_usage,$ctx.parameter.function_code,$ctx.parameter.cdd_list_id,$ctx.parameter.calc_type,$ctx.parameter.maintain_type,$ctx.parameter.declare_flag,$ctx.parameter.default_value_dsid);
    return s;
}

function create_tab(r){
    var tab = newMap('tab');
    tab.prompt = r.tab_desc+r.bp_seq;
    tab.width = '120';
    tab.id=r.bp_seq+r.tab_code+'##'+(r.parent_loaded_object||'');
	if(r.bp_seq&&r.bp_seq!=1){
	   tab.ref=create_tab_ref(r);
    }
    tabs.addChild(tab.getData());
    if(!r.bp_seq||r.bp_seq==1){
	    var screen_include=create_screen_include(r);
	    tab.addChild(screen_include.getData());
    }
}

for(var i = 0;i < tabpanel_layout_type_path.length;i++){
	var r = tabpanel_layout_type_path[i];
	if(r.repeat_object=='TENANT'){
		for(var m=1;m<=$ctx.parameter.number_of_tenant;m++){
			if(!$ctx.parameter.bp_seq){
				r.bp_seq=m;
			}else{
				r.bp_seq=$ctx.parameter.bp_seq;
			}
			create_tab(r);
		}
	}else if(r.repeat_object=='GUARANTOR'){
		for(var n=1;n<=$ctx.parameter.number_of_guarantor;n++){
			if(!$ctx.parameter.bp_seq){
				r.bp_seq=n;
			}else{
				r.bp_seq=$ctx.parameter.bp_seq;
			}
			create_tab(r);
		}
	}else if(r.repeat_object=='ACTUAL_CONTROLLER'){
		for(var p=1;p<=$ctx.parameter.number_of_actual_controller;p++){
			if(!$ctx.parameter.bp_seq){
				r.bp_seq=p;
			}else{
				r.bp_seq=$ctx.parameter.bp_seq;
			}
			create_tab(r);
		}
	}else if(r.repeat_object=='QUOTATION'){
		for(var q=1;q<=$ctx.parameter.number_of_quotation;q++){
			if(!$ctx.parameter.bp_seq){
				r.bp_seq=q;
			}else{
				r.bp_seq=$ctx.parameter.bp_seq;
			}
			create_tab(r);
		}
	}else{
		if(!$ctx.parameter.bp_seq){
			r.bp_seq='';
		}else{
			r.bp_seq=$ctx.parameter.bp_seq;
		}
		create_tab(r);
	}
}