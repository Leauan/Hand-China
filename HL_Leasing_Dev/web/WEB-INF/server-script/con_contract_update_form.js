var config = $config();
function isEmpty(v) {
	return v == null || typeof (v) == 'undefined';
}

function newMap(name) {
	return new CompositeMap("a", 'http://www.aurora-framework.org/application',
			name);
}

function createFields() {
	var fields = newMap('fields');
	var layout_config_path = $ctx.get('/model/layout_config_path');
//	println(layout_config_path.toXML())
//	println("------------")
	var layout_configs = layout_config_path.getChildren();
	for ( var i = 0; i < layout_configs.length; i++) {
		var f = newMap('field');
		f.name = layout_configs[i].column_name;
		if (f.name == 'DIV')
			continue;
		if (!isEmpty(layout_configs[i].default_value))
			f.defaultvalue = layout_configs[i].default_value;
		if (layout_configs[i].validation_type == 'LOV') {
			var f1 = newMap('field');
			f1.name = layout_configs[i].column_name + '_lovname';
			if (!isEmpty(layout_configs[i].default_value_name))
				f1.defaultvalue = layout_configs[i].default_value_name;
			f1.lovgridheight = '350';
			f1.lovheight = '500';
			f1.lovservice = 'hls.HLS500.hls_parameters_lov';
			f1.lovwidth = '500';
			f1.readonly = String(layout_configs[i].readonly_input_mode);
			f1.required = String(layout_configs[i].required_input_mode);
			f1.title = layout_configs[i].prompt;
			fields.addChild(f1);
		} else if (layout_configs[i].validation_type == 'COMBOBOX') {
			var f1 = newMap('field');
			f1.name = layout_configs[i].column_name + "_comboboxname";
			if (!isEmpty(layout_configs[i].default_value_name))
				f1.defaultvalue = layout_configs[i].default_value_name;
			f1.options = $ctx.get('/parameter/@form_tab_code') + "_"
					+ layout_configs[i].column_name + "_combobox_ds";
			f1.readonly = String(layout_configs[i].readonly_input_mode);
			f1.required = String(layout_configs[i].required_input_mode);
			f1.title = layout_configs[i].prompt;
			fields.addChild(f1);
		} else if (layout_configs[i].validation_type == 'CHECKBOX') {
			f.checkedvalue = 'Y';
			f.uncheckedvalue = 'N';
		} else {
			f.readonly = String(layout_configs[i].readonly_input_mode);
			f.required = String(layout_configs[i].required_input_mode);
		}
		fields.addChild(f);
	}
	return fields;
}

function createDs_1() {
	var dataSet = newMap("dataSet");
	dataSet.id = "temp_ds";
	dataSet.processfunction = "temp_processfunction";
	dataSet.autocreate = 'true'
	var fs = createFields();

	dataSet.addChild(fs);

	var events = newMap('events');
	var event = newMap('event');
	event.name = 'add';
	event.handler = 'temp_Load';
	events.addChild(event);
	dataSet.addChild(events);
	return dataSet;
}

function createDs_2(parent_table_flag) {
	var dataSet = newMap('dataSet');
	dataSet.id = $ctx.get('/model/tab_layout_detail_path/record/@base_table')
			+ "_ds";
	dataSet.autocreate = 'true';
	if (parent_table_flag == 'Y') {
		dataset.bindname = $ctx.get('/parameter/@form_tab_code') + "_"
				+ $ctx.get('/model/tab_layout_detail_path/record/@base_table');
		dataSet.bindtarget = $ctx
				.get('/model/tab_layout_detail_path/record/@parent_table')
				+ "_ds";
	}
	dataSet.queryurl = $ctx.get('/request/@context_path')
			+ "/modules/cont/CON500/con_contract_base_query.svc"
			+ "?document_id=" + $ctx.get('/parameter/@document_id')
			+ "&document_category=" + $ctx.get('/parameter/@document_category')
			+ "&document_type=" + $ctx.get('/parameter/@document_type')
			+ "&tab_code=" + $ctx.get('/parameter/@form_tab_code')
			+ "&layout_code=" + $ctx.get('/parameter/@layout_code');
	dataSet.submiturl = $ctx.get('/request/@context_path')
			+ "/modules/cont/CON500/con_contract_save.svc" + "?base_table="
			+ $ctx.get('/model/base_table_path/record/@base_table')
			+ "&tab_code=" + $ctx.get('/parameter/@form_tab_code');
	var fields = createFields();
	dataSet.addChild(fields);
	var events = newMap('events');
	var event = newMap('event');
	// event.name = 'load';
	// event.handler = 'on_con_header_form_load';
	// events.addChild(event);
	event = newMap('event');
	event.name = 'add';
	event.handler = 'on_con_header_form_add';
	events.addChild(event);
	dataSet.addChild(events);
	return dataSet;
}

var dataSets = CompositeUtil.findChild(config, 'dataSets', 'id', 'dataSets');
var parent_tab_code_flag = $ctx
		.get('/model/tab_layout_detail_path/record/@parent_tab_code_flag');
if (parent_tab_code_flag == 'N') {
	var ds = createDs_1();
	dataSets.addChild(ds.getData());
} else if (parent_tab_code_flag == 'Y') {
	var parent_table_flag = $ctx
			.get('/model/tab_layout_detail_path/record/@parent_table_flag');
	var ds = createDs_2(parent_table_flag);
	dataSets.addChild(ds.getData());
}
