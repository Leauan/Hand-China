//$Version : 1.1
//$Author : DJ
if(!window.f_zjwfl){
	function ZJWFL (props) {
		this.context_path = props['context_path'];
	}
	ZJWFL.prototype.getImgDesc = function (map_key_value,key,desc) {
		var url = this.context_path + '/images/zjwfl/';
	    if(Ext.isEmpty(desc))
	    {
	    	desc = '';
	    }
	    var fileName = map_key_value[key];
	    if(!Ext.isEmpty(fileName))
	    {
	        return '<img src="' + url + fileName + '"/>' + ' ' + desc;
	    }
	    return desc;
	};
	ZJWFL.prototype.getStatusImg = function (status,desc) {
		return this.getImgDesc({
	        '1':'zjwfl_running.png',
	        '10':'zjwfl_ok.png',
	        '-1':'zjwfl_no.png',
	        '-1000':'zjwfl_cancel.png'
	    },status,desc);
	};
	ZJWFL.prototype.getApproveImg = function (type,desc) {
		return this.getImgDesc({
	    	'OK':'zjwfl_ok.png',
	    	'NO':'zjwfl_no.png',
	    	'TRANSFER':'zjwfl_transfer.png',
	    	'ADD_APPROVER':'zjwfl_add_approver.png',
	    	'JUMP':'zjwfl_jump.png'
	    },type,desc);
	};
	ZJWFL.prototype.winMask = function (win,desc) {
		if(Ext.isEmpty(desc))
		{
			desc = '正在提交...';
		}
		if(Ext.isEmpty(win))
		{
			Aurora.Masker.mask(Ext.getBody(),desc);
		}
		else
		{
			Aurora.Masker.mask(win.wrap,desc);
		}
	}
	ZJWFL.prototype.winNoMask = function (win) {
		if(Ext.isEmpty(win))
		{
			Aurora.Masker.unmask(Ext.getBody());
		}
		else
		{
			Aurora.Masker.unmask(win.wrap);
		}
	}
}