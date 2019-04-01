var config = $config();
var table = CompositeUtil.findChild(config, 'table', 'id', 'showbutton');
var td = CompositeUtil.findChild(table, 'td', 'id', 'showbuttongroup');
var td_hbox;
var dataSets = CompositeUtil.findChild(config, 'dataSets', 'id',
		'zjwfl_approve_datasets_id');
var node_action_path = $ctx.get('/model/node_action').getChildren();
var node_action_group_path = $ctx.get('/model/node_action_group').getChildren();
function newMap(name) {
	return new CompositeMap("a", 'http://www.aurora-framework.org/application',
			name);
}

function create_td_hbox() {
	td_hbox = newMap("hBox");
	td.addChild(td_hbox.getData());
}

function create_node_action_dataset() {
	for (var i = 0; i < node_action_path.length; i++) {
		var r = node_action_path[i];
		var sequence_num = r.sequence_num;
		var ds_id = "zjwfl_approve_dataset_" + sequence_num + '_ds';
		var dataSet = CompositeUtil.findChild(dataSets, 'dataSet', 'id', ds_id);
		if (!dataSet) {
			dataSet = newMap("dataSet");
			dataSet.id = "zjwfl_approve_dataset_" + sequence_num + '_ds';
			dataSets.addChild(dataSet.getData());
			var datas = newMap("datas");
			dataSet.addChild(datas.getData());
		}
		var datasRecord = newMap("record");
		datasRecord.code_value = r.node_action_id;
		datasRecord.code_value_name = r.node_action_desc;
		datasRecord.action_type = r.action_type;
		datasRecord.node_action_prompt = r.node_action_prompt;
		datas.addChild(datasRecord.getData());
	}
}

function create_comboBox_dataSet(r) {
	var dataSet = newMap("dataSet");
	dataSet.id = "zjwfl_approve_combobox_dataset_" + r.sequence_num + '_ds';
	dataSet.autocreate = "true";
	dataSets.addChild(dataSet.getData());
	var fields = newMap("fields");
	dataSet.addChild(fields.getData());
	var field = newMap("field");
	field.name = "action_type_desc" + r.sequence_num;
	field.displayfield = "code_value_name";
	field.options = "zjwfl_approve_dataset_" + r.sequence_num + '_ds';
	field.returnfield = "node_action_id";
	field.valuefield = "code_value";
	field.required = "true";
	fields.addChild(field.getData());
	var mapping = newMap("mapping");
	field.addChild(mapping.getData());
	var map = newMap("map");
	map.from = "action_type";
	map.to = "action_type";
	mapping.addChild(map.getData());
	var map1 = newMap("map");
	map1.from = "node_action_prompt";
	map1.to = "node_action_prompt";
	mapping.addChild(map1.getData());
}

function create_comboBox(r) {
	create_comboBox_dataSet(r);
	var hBox = newMap('hBox');
	hBox.style = "border:dashed 1px #8470FF";
	td_hbox.addChild(hBox.getData());
	var comboBox = newMap('comboBox');
	comboBox.name = "action_type_desc" + r.sequence_num;
	comboBox.width = '120';
	comboBox.bindtarget = "zjwfl_approve_combobox_dataset_" + r.sequence_num
			+ '_ds';
	var button = newMap('button');
	button.text = "确定";
	button.click = "function(){zjwfl5110_onButtonGroup&&zjwfl5110_onButtonGroup(null,"
			+ "'"
			+ comboBox.bindtarget
			+ "'"
			+ ","
			+ r.action_type
			+ ","
			+ r.service_id + ");}";
	hBox.addChild(comboBox.getData());
	hBox.addChild(button.getData());
}

function create_single_button(r) {
	var hBox = newMap('hBox');
	td_hbox.addChild(hBox.getData());
	var button = newMap('button');
	button.text = r.node_action_desc;
	var recordData = [];
	for ( var name in r) {
		recordData[name] = r[name];
	}
	button.click = "function(){zjwfl5110_onButtonGroup&&zjwfl5110_onButtonGroup(null,null,"
			+ r.node_action_id
			+ ","
			+ "'"
			+ r.node_action_prompt
			+ "'"
			+ ","
			+ r.action_type + "," + r.service_id + ");}";
	hBox.addChild(button.getData());
}

var node_action_group = [];

function create_button_group() {
	for (var j = 0; j < node_action_group_path.length; j++) {
		var rg = node_action_group_path[j];
		var group_sequence_num = rg.sequence_num;
		var count_num = rg.count_num;
		for (var i = 0; i < node_action_path.length; i++) {
			var r = node_action_path[i];
			var sequence_num = r.sequence_num;
			if (count_num > 1) {
				if (sequence_num == group_sequence_num
						&& !node_action_group[group_sequence_num]) {
					create_comboBox(r);
					node_action_group[group_sequence_num] = true;
				}
			} else {
				if (sequence_num == group_sequence_num) {
					create_single_button(r);
				}
			}
		}

	}
}
create_td_hbox();
create_node_action_dataset();
create_button_group();
