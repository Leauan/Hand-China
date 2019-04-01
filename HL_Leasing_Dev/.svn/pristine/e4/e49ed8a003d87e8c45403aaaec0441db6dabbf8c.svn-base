var vcity = {
	11 : "����",
	12 : "���",
	13 : "�ӱ�",
	14 : "ɽ��",
	15 : "���ɹ�",
	21 : "����",
	22 : "����",
	23 : "������",
	31 : "�Ϻ�",
	32 : "����",
	33 : "�㽭",
	34 : "����",
	35 : "����",
	36 : "����",
	37 : "ɽ��",
	41 : "����",
	42 : "����",
	43 : "����",
	44 : "�㶫",
	45 : "����",
	46 : "����",
	50 : "����",
	51 : "�Ĵ�",
	52 : "����",
	53 : "����",
	54 : "����",
	61 : "����",
	62 : "����",
	63 : "�ຣ",
	64 : "����",
	65 : "�½�",
	71 : "̨��",
	81 : "���",
	82 : "����",
	91 : "����"
};

checkCard = function(card) {
	
	if (isCardNo(card) === false) {
		return false;
	}
	// ���ʡ��
	if (checkProvince(card) === false) {
		return false;
	}
	// У������
	if (checkBirthday(card) === false) {
		
		return false;
	}
	// ����λ�ļ��
	if (checkParity(card) === false) {
		return false;
	}
	return true;
};

// �������Ƿ���Ϲ淶���������ȣ�����
isCardNo = function(card) {
	// ���֤����Ϊ15λ����18λ��15λʱȫΪ���֣�18λǰ17λΪ���֣����һλ��У��λ������Ϊ���ֻ��ַ�X
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X)$)/;
	if (reg.test(card) === false) {
		return false;
	}

	return true;
};

// ȡ���֤ǰ��λ,У��ʡ��
checkProvince = function(card) {
	var province = card.substr(0, 2);
	if (vcity[province] == undefined) {
		return false;
	}
	return true;
};

// ��������Ƿ���ȷ
checkBirthday = function(card) {
	
	var len = card.length;
	var arr_data=new Array();
	var year;
	var month;
	var day;
	var birthday;
	// ���֤15λʱ������Ϊʡ��3λ���У�3λ���꣨2λ���£�2λ���գ�2λ��У��λ��3λ������Ϊ����
	if (len == '15') {
		var re_fifteen = /^(\d{6})(\d{2})(\d{2})(\d{2})(\d{3})$/;
		arr_data = card.match(re_fifteen);
		year = arr_data[2];
		month = arr_data[3];
		day = arr_data[4];
		birthday = new Date('19' + year + '/' + month + '/' + day);
		return verifyBirthday('19' + year, month, day, birthday);
	}
	// ���֤18λʱ������Ϊʡ��3λ���У�3λ���꣨4λ���£�2λ���գ�2λ��У��λ��4λ����У��λĩβ����ΪX
	if (len == '18') {
		
		var re_eighteen = /^(\d{6})(\d{4})(\d{2})(\d{2})(\d{3})([0-9]|X)$/;
		arr_data = card.match(re_eighteen);
		year = arr_data[2];
		month = arr_data[3];
		day = arr_data[4];
		birthday = new Date(year + '/' + month + '/' + day);
		return verifyBirthday(year, month, day, birthday);
	}
	return false;
};

// У������
verifyBirthday = function(year, month, day, birthday) {
	var now = new Date();
	var now_year = now.getFullYear();
	// �������Ƿ����
	if (birthday.getFullYear() == year && (birthday.getMonth() + 1) == month
			&& birthday.getDate() == day) {
		// �ж���ݵķ�Χ��3�굽100��֮��)
		var time = now_year - year;
		if (time >= 3 && time <= 100) {
			return true;
		}
		return false;
	}
	return false;
};

// У��λ�ļ��
checkParity = function(card) {
	// 15λת18λ
	card = changeFivteenToEighteen(card);
	var len = card.length;
	if (len == '18') {
		var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8,
				4, 2);
		var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3',
				'2');
		var cardTemp = 0, i, valnum;
		for (i = 0; i < 17; i++) {
			cardTemp += card.substr(i, 1) * arrInt[i];
		}
		valnum = arrCh[cardTemp % 11];
		if (valnum == card.substr(17, 1)) {
			return true;
		}
		return false;
	}
	return false;
};

// 15λת18λ���֤��
changeFivteenToEighteen = function(card) {
	if (card.length == '15') {
		var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8,
				4, 2);
		var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3',
				'2');
		var cardTemp = 0, i;
		card = card.substr(0, 6) + '19' + card.substr(6, card.length - 6);
		for (i = 0; i < 17; i++) {
			cardTemp += card.substr(i, 1) * arrInt[i];
		}
		card += arrCh[cardTemp % 11];
		return card;
	}
	return card;
};

function checkMobile(str) {
//	var re = /^1\d{10}$/;
	//var re=/^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\d{8}$)/;
	//var re=/^((0\d{2,3}-\d{7,8})|(1[35847]\d{9}))$/;
	//var re=/^((0\d{2,3}-\d{7,8})|(1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}))$/;
	 var re= /^\d{11}$/;
	//var re=/^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8}$/;
	//var re=/^0?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8}$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}

//У�鳵�ܺ� 17λ ��д�����ּ� ��ĸ
function checkVumber(str) {
	var re = /^[a-zA-Z0-9]{17}$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}

//У��������ô��� 18λ ��ĸ�������������
function checkSccode(str) {
	var re = /^[a-zA-Z0-9]{18}$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}


function checkPhone(str) {
	var re = /^0\d{2,3}-?\d{7,8}$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}

function checkEmail(str) {
	var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}

function checkPostCode(str) {
	var re = /^[a-zA-Z0-9 ]{3,12}$/;
	if (re.test(str)) {
		return true;
	} else {
		return false;
	}
}

