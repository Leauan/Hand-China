(function(A){
	if(!A)return;
	//override $A.Window
   	var temp = A.Window;
   	A.Window = function(config){
   	    var draggable = config.draggable,
   	    	win = new temp(config);
   	    if(win.wrap && draggable){
   	        win.processListener('un');
   	        win.draggable = draggable;
   	        win.initDraggable();
   	        win.processListener('on');
   	    }
   	    return win;
   	};
   	A.Window.superclass = temp.superclass;
   	
   	//override $A.TriggerField
   	A.TriggerField.prototype.onFocus = function(){
   		var sf = this;
        A.TriggerField.superclass.onFocus.call(sf);
        if(!sf.readonly && !sf.isExpanded() && !sf.hasExpanded && Ext.isEmpty(sf.value))sf.expand();
        sf.hasExpanded = false;
    };
	
	//override $A.Record
	var temp2 = $A.Record.prototype.validate;
	$A.Record.prototype.validate = function(name){
		var valid = temp2.call(this,name);
		if(valid == true){
			var v = this.get(name);
			if(Ext.isString(v) && v.search(/<script|<\/script/)!=-1){
				this.valid[name]='恶意代码注入！'
				valid = false;
			}
		}
		return valid;
    }
})($A);