MultiGrid = Ext.extend($A.Component,function(){
	var ROW_ALT = 'row-alt',
		ITEM_FOCUS = 'item-focus',
		ITEM_INVALID = 'item-invalid',
		ITEM_NOT_BLANK = 'item-notBlank',
		ROW_SELECTED = 'row-selected',
		ON = 'on',
		LOV_TRIGGER_TPL = '<div class="item-trigger item-lovButton" atype="triggerfield.trigger" style="margin-top:2px"></div>';
	return {
		initComponent:function(config){
			MultiGrid.superclass.initComponent.call(this,config);
			var sf = this,
				wrap = sf.wrap,
				head = wrap.child('.grid-uh'),
				body = sf.body = wrap.child('.grid-ub'),
				hl = head.child('.grid-hl'),
				clone = hl.dom.cloneNode(true);
			clone.removeChild(clone.lastChild);
			sf.fb = wrap.child('.grid-footerbar');
			sf.linetpl = ['<table cellpadding="0" cellspacing="0" border="0">',clone.outerHTML].concat(sf.linetpl).concat('</table>');
			head.select('.add-btn')[ON]('click',function(){
				sf.ds.create();
			});
			if(Ext.isIE7||Ext.isIE6){
				body.setStyle({position:'relative'});
				hl.setStyle({display:'none'});
				$A.onReady(function(){
					var tds = head.select('tr[class!=grid-hl] td');
					tds.each(function(td){
						if(td.dom.rowSpan==1){
							tds.set({height:td.getHeight()-4});
							return true;
						}
					});
				})
			}
		},
		bind : function(ds){
			if(Ext.isString(ds)){
				ds = $(ds)
			}
			var sf = this;
			sf.ds = ds;
			sf.processDataSetListener(ON);
			$A.onReady(function(){
				sf.onLoad();
			})
		},
		destroy : function(){
			MultiGrid.superclass.destroy.call(this);
			this.processDataSetListener('un');
		},
		processDataSetListener : function(ou){
			var sf = this,ds = sf.ds;
			if(ds){
				ds[ou]('add',sf.onAdd,sf);
				ds[ou]('load',sf.onLoad,sf);
				ds[ou]('update',sf.onUpdate,sf);
				ds[ou]('remove',sf.onRemove,sf);
				ds[ou]('clear',sf.onClear,sf);
				ds[ou]('indexchange',sf.onIndexChange,sf);
				ds[ou]('fieldchange',sf.onFieldChange,sf);
				ds[ou]('valid',sf.onValid,sf);
			}
		},
		onAdd : function(ds,record,row){
			var sf = this,ds = sf.ds,
				tr = new Ext.Template(sf.linetpl)
				.append(sf.body,{row:row+1},true)
				.addClass(row%2?ROW_ALT:'')
				.set({id:sf.id+'-'+record.id})[ON]('mousedown',function(){
					ds.locate.defer(5,ds,[(ds.currentPage-1)*ds.pagesize + sf.getDataIndex(record.id)+1]);
				});
				tr.select('.close-btn')[ON]('click',function(){
					$A.showConfirm('警告','是否确认删除？',function(){
						ds.remove(record);
					})
				});
				tr.select('input')[ON]('focus',function(e,t){
					Ext.fly(t).addClass(ITEM_FOCUS);
					if(Ext.isDefined(t._value))t.value = t._value;
					ds.locate.defer(5,ds,[(ds.currentPage-1)*ds.pagesize + row+1]);
				}).setWidth(10).addClass(['item-wrap','cell-editor','item-tf'])[ON]('blur',function(e,t){
					t.value = sf.renderText(record,Ext.fly(t).getAttribute('dataindex'),t,t.value);
					Ext.fly(t).removeClass(ITEM_FOCUS);
				})[ON]('change',function(e,t){
					var _t = Ext.fly(t),
						v = t.value;
					if((_t.getAttribute('atype')||'').toLowerCase() == 'numberfield'){
						var decimalprecision = _t.getAttribute('decimalprecision');
						decimalprecision = Ext.isEmpty(decimalprecision)?2:decimalprecision;
						if(isNaN(v)){
							v = '';
						}else if(decimalprecision>=0 && decimalprecision<20){
							v = Number(Number(v).toFixed(decimalprecision));
						}
					}
					record.set(_t.getAttribute('dataindex'),t._value = v);
				})[ON]('keydown',function(e,t){
					var keyCode = e.keyCode;
					if(keyCode === 8 && t.readOnly){
						e.stopEvent();
					}
				}).each(function(input){
					var name = input.getAttribute('dataindex'),
						atype = (input.getAttribute('atype')||'').toLowerCase();
					if(name){
						if(atype == 'lov'){
//							input.dom.readOnly = true;
//							input.addClass('item-readOnly')
							new Ext.Template(LOV_TRIGGER_TPL).append(input.parent().setStyle({position:'relative'}),{},true)
								[ON]('click',function(){
									var ctx = sf.context,
										field = record.getField(name),
										lovurl = field.get('lovurl'),
						    			svc = field.get('lovservice'),
						    			title = field.get('title'),
						    			w = field.get('lovwidth')||400,
						    			lovautoquery = field.get('lovautoquery')==='false'?false:true,
				    					para={};
									if(svc){
							        	var li = svc.indexOf('?');
								        if(li!=-1){
								            para = Ext.urlDecode(svc.substring(li+1,svc.length));
								            svc =  svc.substring(0,li);
								        }
									}
									if(!Ext.isEmpty(lovurl)){
							            url = Ext.urlAppend(lovurl,Ext.urlEncode(Ext.apply({},field.get('lovpara'))));
							        }else if(!Ext.isEmpty(svc)){
							//              url = sf.context + 'sys_lov.screen?url='+encodeURIComponent(sf.context + 'sys_lov.svc?svc='+sf.lovservice + '&'+ Ext.urlEncode(sf.getLovPara()))+'&service='+sf.lovservice+'&';
							            url = ctx+'sys_lov.screen?url='+encodeURIComponent(Ext.urlAppend(ctx + 'autocrud/'+svc+'/query',Ext.urlEncode(Ext.urlEncode(Ext.apply({},field.get('lovpara'),para)))))+'&service='+svc;
							    	}
							        if(url) {
							            sf.win = new $A.Window({title:title||'Lov', url:Ext.urlAppend(url,"lovid="+sf.id+"&gridheight="+(field.get('lovgridheight')||350)+"&innerwidth="+(w-30)+"&lovautoquery="+lovautoquery+"&lovlabelwidth="+(field.get('lovlabelwidth')||75)), height:field.get('lovheight')||400,width:w});
							        	sf.record = record;
							        	sf.mapping = field.get('mapping');
							        }
								},sf);
						}else if(atype == 'numberfield'){
							var restrict = '0123456789';
							if(input.getAttribute('allowdecimals')!='false')restrict+='.';
							if(input.getAttribute('allownegative')!='false')restrict+='-';
							input.on('keypress',function(e){
						    	var sf = this,k = e.getCharCode();
						        if((Ext.isGecko || Ext.isOpera) && (e.isSpecialKey() || k == 8 || k == 46)){//BACKSPACE or DELETE
						            return;
						        }
						    	if(restrict && !new RegExp('['+restrict+']').test(String.fromCharCode(k))){
						            e.stopEvent();
						            return;
						    	}
						    })
						}
						record.getField(name).get('required') && input.addClass(ITEM_NOT_BLANK);
//						input.set({id:[sf.id,name,record.id].join('_')});
					}
					if(Ext.isIE7||Ext.isIE6)input.setStyle({float:'left'});
				});
				tr.select('td>*:first-child').each(function(item){
					item.setWidth(item.parent().getWidth()-5).addClass('grid-cell');
				});
				if(Ext.isIE7)tr.select('.grid-hl').setStyle({display:'none'});
			Ext.iterate(record.data,function(key,value){
				if(!Ext.isEmpty(value)){
					sf.setValue(tr,record,key,value);
				}
			});
			sf.drawFootBar();
		},
		onRemove : function(ds,record,index){
			var sf=this,next = Ext.fly(sf.id+'-'+record.id);
			while(next = next.next()){
				next[next.hasClass(ROW_ALT)?'removeClass':'addClass'](ROW_ALT);
				var seq = next.child('[dataindex='+sf.sequencefield+']');
					seq && seq.update(Number(seq.dom.innerHTML)-1);
			}
	        Ext.fly(sf.id+'-'+record.id).remove();
			sf.drawFootBar();
		},
		onClear : function(){
			var sf = this,dom = sf.body.dom
			while(dom.childNodes.length){
				dom.removeChild(dom.firstChild);
			}
			sf.selectTr = null;;
		},
		onUpdate : function(ds,record, name, value){
			var sf = this;
			sf.setValue(Ext.fly(sf.id+'-'+record.id),record,name,value);
			sf.drawFootBar();
		},
		onIndexChange:function(ds, r){
	        this.selectRow(ds,r);
	    },
	    onFieldChange : function(ds, record, field, type, value){
	    	var div = Ext.fly(this.id+'-'+record.id).select('[dataindex='+field.name+']');
	    	if(div) {
		        if(type == 'required'){
		               div[value==true?'addClass':'removeClass'](ITEM_NOT_BLANK);
		        }else if(type == 'readonly'){
		               div[value==true?'addClass':'removeClass']('item-readOnly');
		               div.each(function(el){
		            	   el.dom.readOnly = value;
		               });
		        }
	    	}
	    },
	    onValid : function(ds, record, name, valid){
	        var div = Ext.fly(this.id+'-'+record.id);
	        div && (div=div.select('[dataindex='+name+']')) && div[valid?'removeClass':'addClass'](ITEM_INVALID);
	    },
	    onLoad : function(){
	    	var sf = this,ds = sf.ds,records = ds.getAll();
	    	sf.onClear();
	    	if(records.length){
		    	Ext.each(records,function(record,row){
		            sf.onAdd(ds,record,row);
		        });
		        sf.selectRow(ds);
	    	}
			sf.drawFootBar();
	    },
	    getDataIndex : function(rid){
	        for(var i=0,data = this.ds.data,l=data.length;i<l;i++){
	            if(data[i].id == rid){
	                return i;
	            }
	        }
	        return -1;
	    },
	    selectRow : function(ds,record){
	        var sf = this,
	            record = record||ds.getCurrentRecord();
	        if(sf.selectTr) sf.selectTr.removeClass(ROW_SELECTED);
	        if(sf.selectTr = Ext.get(sf.id+'-'+record.id))sf.selectTr.addClass(ROW_SELECTED);
	    },
	    commit : function(r){
	    	var sf = this,record = sf.record;
	        if(sf.win) sf.win.close();
	        if(record && r){
	        	Ext.each(sf.mapping,function(map){
	        		var from = r.get(map.from);
	                record.set(map.to,Ext.isEmpty(from)?'':from);
	        	});
	        }
	    },
	    renderText : function(record,name,el,value){
    		var renderer = el.getAttribute('renderer'),
            value = $A.escapeHtml(value);
	        if(renderer){//&&!IS_EMPTY(value)  去掉对value是否为空的判断
	            var rder = $A.getRenderer(renderer);
	            if(rder == null){
	                alert('未找到'+renderer+'方法!');
	                return value;
	            }
	            value = rder(value,record, name);
	        }
	        return value == null ? '' : value;
	    },
	    setValue : function(tr,record,name,value){
	    	if(tr){
	    		var el = tr.select('[dataindex='+name+']');
				if(el && el.item(0)){
					var valueStr = this.renderText(record,name,el.item(0),value);
					el.each(function(item){
						if(item.dom.nodeName.toUpperCase() == 'DIV'){
							item.update(valueStr)
						}else{
							item.dom.value = valueStr
							item.dom._value = value;
						}
					});
				}
	    	}
	    },
	    drawFootBar : function(){
	        var sf = this;
	        if(!sf.fb) return;
	        sf.fb.update(sf.linetpl.join('')).select('[dataindex]').each(function(el){
	        	var footerrenderer = el.getAttribute('footerrenderer'),
	        		v='';
        		if(footerrenderer){
	                var fder = $A.getRenderer(footerrenderer);
	                if(fder == null){
	                    alert('未找到'+footerrenderer+'方法!')
	                    return;
	                }
                    v = fder(sf.ds.data, el.getAttribute('dataindex'));
	            }
	            el.parent('td').setStyle({
	            	'border-top': '1px solid #fff',
					'border-bottom': '1px solid #ccc',
					height:'21px'
	            }).update('<div>'+v+'</div>');
	        });
	        sf.fb.select('.close-btn').remove();
	    }
    }
}());