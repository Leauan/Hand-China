//组织机构代码校验
function check_org_code(code){
	var ws = [3, 7, 9, 10, 5, 8, 4, 2];
	var str = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var reg = /^([0-9A-Z]){8}-[0-9|X]$/;
	if (!reg.test(code)) {
	   return -1;
	}

	var sum = 0;
	for (var i = 0; i < 8; i++) {
	sum += str.indexOf(code.charAt(i)) * ws[i];
	}
	var c9 = 11 - (sum % 11);
	if(c9==10){
//	   c9='X';
	}else if(c9==11){
	   c9='0';
	}

	if(c9 != code.charAt(9)){
	  return -1;
	}
	return 0;
}