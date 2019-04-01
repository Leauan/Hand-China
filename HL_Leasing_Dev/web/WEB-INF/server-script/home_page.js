var config = $config();
var home_page_table = CompositeUtil.findChild(config, 'table');
var role_home_page_function_path = $ctx.get(
		'/model/role_home_page_function_path').getChildren();

function newMap(name) {
	return new CompositeMap("a", 'http://www.aurora-framework.org/application',
			name);
}

function newHtmlMap(name) {
	return new CompositeMap(name);
}

function create_tr_td1(tr) {
	var td = newHtmlMap('td');
	td.colspan = '9';
	tr.addChild(td.getData());
}

function create_tr_td2(tr, r, i) {
	var td = newHtmlMap('td');
	td.align = 'center';
	td.colspan = '1';
	td.valign = 'middle';
	if ((i + 4) % 4 === 0) {
		td.width = '14%';
	} else {
		td.width = '4%';
	}
	tr.addChild(td.getData());
}

function create_tr_td3(tr, r) {
	var td = newHtmlMap('td');
	td.align = 'center';
	td.class = 'js-slide';
	td.style = 'padding-bottom:14px;';
	td.valign = 'middle';
	td.width = '15%';
	tr.addChild(td.getData());
	var a_href = newHtmlMap('a');
	a_href.href = "javascript:hitPage('" + r.function_code + "')";
	td.addChild(a_href.getData());
	if (r.count_number > 0) {
		var count_div = newHtmlMap('div');
		count_div.class = 'todo_icon_s1';
		a_href.addChild(count_div.getData());
		var count_div1 = newHtmlMap('div');
		count_div1.class = 'todo_icon_text';
		count_div.addChild(count_div1.getData());
		count_div1.setText(r.count_number);
	}
	var div = newHtmlMap('div');
	div.class = 'list_box_n';
	var style = 'background-color:' + r.background_color + ';';
	div.style = style;
	a_href.addChild(div.getData());
	var div1 = newHtmlMap('div');
	div1.class = 'list_box_n_d';
	var style1 = 'background:url(${/request/@context_path}/images/newmain/' + r.image + ') no-repeat bottom;';
	div1.style = style1;
	div.addChild(div1.getData());
	var div2 = newHtmlMap('div');
	div2.class = 'app_text';
	div.addChild(div2.getData());
	var b = newHtmlMap('b');
	b.setText(r.home_page_desc);
	div2.addChild(b.getData());
}

function create_tr_td4(tr) {
	var td = newHtmlMap('td');
	td.align = 'center';
	td.valign = 'middle';
	td.width = '14%';
	tr.addChild(td.getData());
	return null;
}

function create_table_tr(r, old_tr, i) {
	var tr = '';
	if (old_tr) {
		var tr = old_tr;
	} else {
		tr = newHtmlMap('tr');
	}
	if (r) {
		if (old_tr) {
			create_tr_td2(old_tr, r, i);
			create_tr_td3(old_tr, r);
		} else {
			create_tr_td2(tr, r, i);
			create_tr_td3(tr, r);
			home_page_table.addChild(tr.getData());
		}
	} else {
		tr.height = '40';
		create_tr_td1(tr);
		if (!old_tr) {
			home_page_table.addChild(tr.getData());
		}
	}
	return tr;
}

function create_height_table_tr() {
	var tr = newHtmlMap('tr');
	tr.height = '30px';
	home_page_table.addChild(tr.getData());
}

var current_tr = '';

for ( var i = 0, length = role_home_page_function_path.length; i < length; i++) {
	var r = role_home_page_function_path[i];
	if (i == 0) {
		create_table_tr();
		current_tr = create_table_tr(r, null, i);
	} else {
		if (!current_tr) {
			create_height_table_tr();
		}
		current_tr = create_table_tr(r, current_tr, i);
	}

	if (i == length - 1 && length < 4) {
		for ( var j = 0; j < 4 - length; j++) {
			current_tr = create_table_tr(null, current_tr, i);
		}
	}
	if ((i + 1) % 4 == 0) {
		current_tr = create_tr_td4(current_tr);
	}
}