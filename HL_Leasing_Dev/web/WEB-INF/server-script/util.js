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
function newMap(name, data) {
	return cm(data, new CompositeMap(name));
}