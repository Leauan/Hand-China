(function() {
	var POW = Math.pow;
	// 乘法
	mul = function(a, b) {
		var m = 0, s1 = String(a), s2 = String(b), l1 = s1.indexOf('.'), l2 = s2
				.indexOf('.'), e1 = s1.indexOf('e'), e2 = s2.indexOf('e');
		if (e1 != -1) {
			m -= Number(s1.substr(e1 + 1));
			s1 = s1.substr(0, e1);
		}
		if (e2 != -1) {
			m -= Number(s2.substr(e2 + 1));
			s2 = s2.substr(0, e2);
		}
		if (l1 != -1)
			m += s1.length - l1 - 1;
		if (l2 != -1)
			m += s2.length - l2 - 1;
		return Number(s1.replace('.', '')) * Number(s2.replace('.', ''))
				/ POW(10, m);
	}

	// 除法
	div = function(a, b) {
		var re = String(a / b), i = re.indexOf('.');
		if (i != -1) {
			re = Number(re).toFixed(16 - i - 1)
		}
		return Number(re);
	}

	// 加法
	plus = function(a, b) {
		var m1 = 0, m2 = 0, m3, s1 = String(a), s2 = String(b), l1 = s1
				.indexOf('.'), l2 = s2.indexOf('.'), e1 = s1.indexOf('e'), e2 = s2
				.indexOf('e');
		if (e1 != -1) {
			m1 -= Number(s1.substr(e1 + 1));
			s1 = s1.substr(0, e1);
		}
		if (e2 != -1) {
			m2 -= Number(s2.substr(e2 + 1));
			s2 = s2.substr(0, e2);
		}
		if (l1 != -1)
			m1 += s1.length - l1 - 1;
		if (l2 != -1)
			m2 += s2.length - l2 - 1;
		if (m2 > m1) {
			m3 = m2;
			m1 = m2 - m1;
			m2 = 0;
		} else if (m1 > m2) {
			m3 = m1;
			m2 = m1 - m2;
			m1 = 0;
		} else {
			m3 = m1;
			m1 = m2 = 0;
		}
		return (Number(s1.replace('.', '')) * POW(10, m1) + Number(s2.replace(
				'.', ''))
				* POW(10, m2))
				/ POW(10, m3);
	}

	// 减法
	minus = function(a, b) {
		return plus(a, -b);
	}

	pow = function(a, b) {
		var re = String(POW(a, b)), i = re.indexOf('.');
		if (i != -1) {
			re = Number(re).toFixed(16 - i - 1)
		}
		return Number(re);
	}

	if (!Ext.isIE && !Ext.isIE9 && !Ext.isIE10) {
		var _toFixed = Number.prototype.toFixed;
		Number.prototype.toFixed = function(deci) {
			var sf = this,
				s = sf+'',
				fix = new Array(deci).join('0')+1;
			if(s.indexOf('e') != -1){
				var arr = s.split('e');
				if(arr[1]<0){
					if(arr[0].indexOf('.') == -1){
						arr[1]-=-arr[0].length;
					}
					return _toFixed.call(Number('.'+arr[0]+fix+'e'+arr[1]),deci);
				}else{
					return _toFixed.call(sf,deci);
				}
			}else if(s.indexOf('.') == -1){
				return _toFixed.call(sf,deci);
			}else{
				return _toFixed.call(Number(s+fix),deci);
			}
		}
	}
})();