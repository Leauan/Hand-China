var config = $config();
var columns = CompositeUtil.findChild(config, 'columns');
var aging_bucket_lines_path = $ctx.get('/model/aging_bucket_lines_path').getChildren();

function newMap(name) {
	return new CompositeMap("a",'http://www.aurora-framework.org/application',
			name);
}

function create_column(r,num,max_flag){
	var column = newMap('column');
	column.name='aging_bucket_'+num;
	if(!max_flag){
		column.prompt=r.description;
	}else{
		column.prompt=r.days+'天以上';
	}
	column.width=120;
	column.align='right';
	column.renderer='see_aging_bucket_line_renderer';
	columns.addChild(column.getData());
}

for(var i=0,length=aging_bucket_lines_path.length;i<length;i++){
	var r=aging_bucket_lines_path[i];
	create_column(r,i+1);
	if(i==length-1){
		create_column(r,i+2,true);
	}
}