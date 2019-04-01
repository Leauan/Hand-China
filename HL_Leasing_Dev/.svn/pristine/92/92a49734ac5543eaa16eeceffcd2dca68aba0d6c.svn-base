/*!
 * Ext Core Library $version&#xD;&#xA;http://extjs.com/&#xD;&#xA;Copyright(c) 2006-2009, $author.&#xD;&#xA;&#xD;&#xA;The MIT License&#xD;&#xA;&#xD;&#xA;Permission is hereby granted, free of charge, to any person obtaining a copy&#xD;&#xA;of this software and associated documentation files (the &quot;Software&quot;), to deal&#xD;&#xA;in the Software without restriction, including without limitation the rights&#xD;&#xA;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell&#xD;&#xA;copies of the Software, and to permit persons to whom the Software is&#xD;&#xA;furnished to do so, subject to the following conditions:&#xD;&#xA;&#xD;&#xA;The above copyright notice and this permission notice shall be included in&#xD;&#xA;all copies or substantial portions of the Software.&#xD;&#xA;&#xD;&#xA;THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR&#xD;&#xA;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,&#xD;&#xA;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE&#xD;&#xA;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER&#xD;&#xA;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,&#xD;&#xA;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN&#xD;&#xA;THE SOFTWARE.&#xD;&#xA;
 */
Ext.ns('Ext.ux');

Ext.ux.Lightbox = (function(){
    var els = {},
        images = [],
        activeImage,
        initialized = false,
        selectors = [];

    return {
        radian:0,
        horizontal:true,
        overlayOpacity: 0.85,
        animate: true,
        resizeSpeed: 8,
        borderSize: 10,
        toolbarSize:40,
        labelImage: "Image",
        labelOf: "of",

        init: function() {
            this.resizeDuration = this.animate ? ((11 - this.resizeSpeed) * 0.15) : 0;
            this.overlayDuration = this.animate ? 0.2 : 0;

            if(!initialized) {
                Ext.apply(this, Ext.util.Observable.prototype);
                Ext.util.Observable.constructor.call(this);
                this.addEvents('open', 'close');
                this.initMarkup();
                this.initEvents();
                initialized = true;
            }
            
            this.rotate = this.initRotate();
        },

        initMarkup: function() {
            els.shim = Ext.DomHelper.append(document.body, {
                tag: 'iframe',
                id: 'ux-lightbox-shim'
            }, true);
            els.overlay = Ext.DomHelper.append(document.body, {
                id: 'ux-lightbox-overlay'
            }, true);
            
            var navboxTpl = new Ext.Template(this.getNavTemplate());
            navboxTpl.append(els.overlay, {}, true);
            
            
            var lightboxTpl = new Ext.Template(this.getTemplate());
            els.lightbox = lightboxTpl.append(document.body, {}, true);

            var ids =
                ['outerImageContainer', 'imageContainer', 'image', 'hoverNav', 'navPrev', 'navNext', 'loading', 'loadingLink',
                'outerDataContainer', 'dataContainer', 'data', 'details', 'caption', 'imageNumber', 'bottomNav', 'navClose','leftRotate','rightRotate'];

            Ext.each(ids, function(id){
                els[id] = Ext.get('ux-lightbox-' + id);
            });
            Ext.each([els.overlay, els.lightbox, els.shim,els.navPrev,els.navNext], function(el){
                el.setVisibilityMode(Ext.Element.DISPLAY)
                el.hide();
            });

            var size = (this.animate ? 250 : 1) + 'px';
            els.outerImageContainer.setStyle({
                width: size,
                height: size
            });
        },
        
        getNavTemplate : function() {
            return [
                '<div id="ux-lightbox-outerDataContainer">',
                    '<div id="ux-lightbox-dataContainer">',
                        '<div id="ux-lightbox-data">',
                            '<div id="ux-lightbox-details">',
                                '<span id="ux-lightbox-caption"></span>',
                                '<span id="ux-lightbox-imageNumber"></span>',
                            '</div>',
                            '<div style="float:left">',
                                '<input type="button" id="ux-lightbox-leftRotate" style="margin-left:20px;" value="向左旋转"/>',
                                '<input type="button" id="ux-lightbox-rightRotate"  value="向右旋转"/>',
                                '<input type="button" id="ux-lightbox-navPrev" style="margin-left:20px;" value="上一张"/>',
                                '<input type="button" id="ux-lightbox-navNext"  value="下一张"/>',
                            '</div>',
                            '<div id="ux-lightbox-bottomNav">',
                                '<a href="#" id="ux-lightbox-navClose"></a>',
                            '</div>',
                        '</div>',
                    '</div>',
                '</div>'
            ];
        },
        getTemplate : function() {
            return [
//                '<div id="ux-lightbox">',
                    '<div id="ux-lightbox-outerImageContainer">',
                        '<div id="ux-lightbox-imageContainer">',
                            '<img id="ux-lightbox-image">',
//                            '<div id="ux-lightbox-hoverNav">',
//                                '<a href="#" id="ux-lightbox-navPrev"></a>',
//                                '<a href="#" id="ux-lightbox-navNext"></a>',
//                            '</div>',
                            '<div id="ux-lightbox-loading">',
                                '<a id="ux-lightbox-loadingLink"></a>',
                            '</div>',
                        '</div>',
                    '</div>'
//                '</div>'
            ];
        },
        resetRotate:function(){
            this.horizontal = true;
            this.radian=0;
            this.rotate.dispose();
        },        
        initRotate: function(){
            var css3Transform,container = els.outerImageContainer.dom,viewSize = this.getViewSize();
            function getMatrix(radian, x, y) {
                var Cos = Math.cos(radian.toFixed(5)), Sin = Math.sin(radian.toFixed(5));
                return {
                    M11: Cos.toFixed(10) , M12:-Sin.toFixed(10),
                    M21: Sin.toFixed(10), M22: Cos.toFixed(10)
                };
            }
            var fn =  {
                css3: {
                    support: function(){
                        var style = document.createElement("div").style,support = false;
                        Ext.each(
                            [ "transform", "MozTransform", "webkitTransform", "OTransform"],
                            function(css){ 
                                if ( css in style ) {
                                    css3Transform = css; 
                                    support = true;
                                    return false;
                                }
                            });   
                        return support;    
                    }(),
                    init: function(){},
                    load: function(){
                        Ext.fly(container).setStyle({
                            top: ( this.getViewSize()[1] - Ext.fly(container).getHeight() ) / 2 + "px",
                            left: ( this.getViewSize()[0] - Ext.fly(container).getWidth() ) / 2 + "px",
                            visibility: "visible"
                        });
                    },
                    show: function(obj) {
                        var matrix = getMatrix(obj.radian);
                        container.style[ css3Transform ] = "matrix("
                            + matrix.M11 + "," + matrix.M21 + ","
                            + matrix.M12 + "," + matrix.M22 + ", 0, 0)";
//                            Ext.fly(img).addClass('_refresh').removeClass('_refresh')
//                        if(callback)callback.call();    
                    },
                    dispose:function(){
                        container.style[ css3Transform ]=''
                    }
                },
                filter: {
//                    inited:false,
                    support: function(){return "filters" in document.createElement("div");}(),
                    init: function() {
//                        img.style.filter = "progid:DXImageTransform.Microsoft.Matrix(SizingMethod='auto expand')";
//                        this.inited = true;
                    },
                    show: function(obj) {
                        container.style.filter = "progid:DXImageTransform.Microsoft.Matrix(SizingMethod='auto expand')";
                        var m = getMatrix(obj.radian);
//                        if(this.inited){
                            container.filters.item(0).M11 = m.M11;
                            container.filters.item(0).M12 = m.M12;
                            container.filters.item(0).M21 = m.M21;
                            container.filters.item(0).M22 = m.M22;
//                        }
                        
                        if(obj.callback)obj.callback.call();
                    },
                    dispose:function(){
                        container.style.filter = "";
                    }
                },
                canvas: {//canvas设置
                    inited:false,
                    support: function(){ return "getContext" in document.createElement('canvas'); }(),
                    init: function() {
                        if(!this.inited){
                            var canvas = this._canvas =document.createElement('canvas'),
                                context = this._context = canvas.getContext('2d');
                            //样式设置
                            Ext.getBody().appendChild(canvas);
                            this.inited = true;                            
                        }

                    },
                    show: function(obj){
                        this.init();
                        var bs = Ext.ux.Lightbox.borderSize,ts = Ext.ux.Lightbox.toolbarSize,img = els.image.dom, context = this._context,canvas = this._canvas,
                            _left = (viewSize[0] - obj.w -bs*2 )/2,_top = (viewSize[1] - bs*2 - ts - obj.h)/2;
                            
                        Ext.fly(canvas).setStyle({'z-index':15000, position: "absolute", left: _left+'px', top:_top+'px'} );
                        canvas.width = obj.w+bs*2; 
                        canvas.height = obj.h+bs*2;
                            
                        //canvas变换
                        context.save();
                        context.clearRect( 0, 0, img.width+bs*2, img.height+bs*2);//清空内容
                        
                        
                        context.fillStyle="#f3efec";  //填充的颜色
                        context.fillRect(0,0,obj.w+bs*2,obj.h+bs*2);
                        
                        
                        context.translate(obj.w/2+bs , obj.h/2+bs );//中心坐标
                        context.rotate(obj.radian);//旋转
                        context.drawImage(img,obj.hor ? -obj.w/2 : -obj.h/2,obj.hor ? -obj.h/2 : -obj.w/2,obj.hor ? obj.w : obj.h,obj.hor ? obj.h : obj.w);//居中画图
                        context.restore();
                        els.outerImageContainer.setStyle('display','none');
                    },
                    dispose: function(){
                        this.inited = false;
                        if(this._canvas){
                            Ext.fly(this._canvas).remove();
                            this._canvas = this._context = null;
                        }
                        els.outerImageContainer.setStyle('display','block');
                    }
                }
            };
            
            var rtv = null;
            Ext.each("css3|filter|canvas".toLowerCase().split("|"),function(type){
                if(fn[type].support){
                    rtv = fn[type];
                    return false;
                }
            },this)
            return rtv;
        },
        rotateImage:function(radian){
            var h= this.preload.height,w = this.preload.width, viewSize = this.getViewSize(), pageScroll = Ext.fly(document).getScroll();
            this.horizontal = !this.horizontal;
            if(!this.horizontal){
                var t = h;
                h = w;
                w = t;
            }
            
            var size = this.adjustSize(w,h),w=size.w,h=size.h;
            
            this.resizeImage(this.horizontal ? w : h, this.horizontal ? h : w,function(){
                
                this.rotate.show({
                    hor:this.horizontal,
                    radian:radian,
                    sw:this.preload.width,
                    sh:this.preload.height,
                    w:w,
                    h:h,
                    callback:function(){
                        els.outerImageContainer.setStyle({
                           left: (pageScroll.left+(viewSize[0]-w-Ext.ux.Lightbox.borderSize*2)/2)+'px',
                           top: (pageScroll.top + (viewSize[1]-h-Ext.ux.Lightbox.borderSize*2-Ext.ux.Lightbox.toolbarSize)/2)+'px'
                        });                    
                    }
                });
                
                
                this.rotate.show(radian,function(){
                        els.outerImageContainer.setStyle({
                            left: (pageScroll.left+(vw-w-20)/2)+'px',
                           top: (pageScroll.top + (vh-60-h)/2)+'px'
                       });                    
                });
                
            });
            
        },
        
        initEvents: function() {
            var close = function(ev) {
                ev.preventDefault();
                this.close();
            };

            
            els.overlay.on('click',function(ev) {
                if(ev.getTarget().id == 'ux-lightbox-overlay') {
                    this.close();
                }
            }, this);
//            els.overlay.on('click', close, this);
            els.loadingLink.on('click', close, this);
            els.navClose.on('click', close, this);
            
            
            els.leftRotate.on('click',function(ev){
                ev.preventDefault();
                this.radian -= Math.PI/2;
                this.rotateImage(this.radian);
            },this);
            els.rightRotate.on('click',function(ev){
                ev.preventDefault();
                this.radian += Math.PI/2;
                this.rotateImage(this.radian);
            },this);
		
            els.lightbox.on('click', function(ev) {
                if(ev.getTarget().id == 'ux-lightbox') {
                    this.close();
                }
            }, this).on('mousewheel', function(ev) {
				var zoom = 1,
				image = els.image,
				width =  image.getWidth(),
				height =  image.getHeight();
        		var delta = ev.getWheelDelta();
        		if(width == 0 && height == 0){
					width =  image.getWidth(); 
					height =  image.getHeight();    		
        		}
            	if(delta > 0){
        			zoom += 0.1;
            	}else{
            		zoom -= 0.1;
            	}
            	if(zoom < 0.1)zoom = 0.1;
            	this.resizeImage(width * zoom,height * zoom,null,true);
            },this);

            els.navPrev.on('click', function(ev) {
                ev.preventDefault();
                this.setImage(activeImage - 1);
            }, this);

            els.navNext.on('click', function(ev) {
                ev.preventDefault();
                this.setImage(activeImage + 1);
            }, this);
          //add 20171113 增加拖拽--start-----------------------------------
		   els.outerImageContainer.on('mousedown', function(ev) {
				ev.preventDefault();				
				if(ev.button==0){
					var moving = false;
					setTimeout(function() {
                       
                    }, 1000);
					var moving = true; 
				}				
				var oldX = ev.browserEvent.clientX;
				var oldY = ev.browserEvent.clientY;
				var oldTop = els.outerImageContainer.getTop();
				var oldLeft = els.outerImageContainer.getLeft();
	
				//Ext.fly(document)
				els.outerImageContainer.on('mousemove', function (ev) {
					if(moving){
		                els.outerImageContainer.on('onclick', null, this);
						var newX = ev.browserEvent.clientX;
						var newY = ev.browserEvent.clientY;
	
						newTop = oldTop +  newY - oldY;
						newLeft = oldLeft +  newX - oldX;
				
						Ext.fly(els.outerImageContainer).setStyle({
							top:  newTop + "px",
							left: newLeft + "px"
						});
					}
				},this);
				
				els.outerImageContainer.on('mouseup', function (ev) {
					if(moving){
						moving=false; 
					}
				},this);
				els.outerImageContainer.on('mouseleave', function (ev) {
					if(moving){
						moving=false; 
						els.outerImageContainer.on('mousemove', null, this);
						els.outerImageContainer.on('onmouseup', null, this)
					}
				}, this);
				
			},this);
			//add 20171113 增加拖拽--end-------------------------------------
        },

        register: function(sel, group) {
            if(selectors.indexOf(sel) === -1) {
                selectors.push(sel);

                Ext.fly(document).on('click', function(ev){
                    var target = ev.getTarget(sel);

                    if (target) {
                        ev.preventDefault();
                        this.open(target, sel, group);
                    }
                }, this);
            }
        },

        open: function(image, sel, group) {
            group = group || false;
            this.setViewSize();
            els.overlay.fadeIn({
                duration: this.overlayDuration,
                endOpacity: this.overlayOpacity,
                callback: function() {
                    images = [];

                    var index = 0;
                    if(!group) {
                        images.push([image.href, image.title]);
                    }
                    else {
                        var setItems = Ext.query(sel);
                        Ext.each(setItems, function(item) {
                            if(item.href) {
                                images.push([item.href, item.title]);
                            }
                        });

                        while (images[index][0] != image.href) {
                            index++;
                        }
                    }

                    

                    this.setImage(index);
                    
                    this.fireEvent('open', images[index]);                                        
                },
                scope: this
            });
        },
        
        setViewSize: function(){
            var pageScroll = Ext.fly(document).getScroll();
            var viewSize = this.getViewSize();
            els.overlay.setStyle({
//                width: pageScroll.left + viewSize[0] + 'px',
                height: pageScroll.top+ viewSize[1] + 'px'
            });
            els.shim.setStyle({
//                width: pageScroll.left + viewSize[0] + 'px',
                height: pageScroll.top+viewSize[1] + 'px'
            }).show();
        },

       setImage : function(index) {

			// this.resetRotate();
			activeImage = index;

			this.disableKeyNav();
			if (this.animate) {
				// calculate top and left offset for the lightbox
				var pageScroll = Ext.fly(document).getScroll();
				var lightboxTop = pageScroll.top + Ext.lib.Dom.getViewHeight()
						/ 2 - 50;//(Ext.lib.Dom.getViewportHeight() / 10);
				var lightboxLeft = pageScroll.left + Ext.lib.Dom.getViewWidth()
						/ 2 - 50;
				// var lightboxLeft = pageScroll.left+
				// (Ext.lib.Dom.getViewportHeight() / 10);
				els.lightbox.setStyle({
					position : 'absolute',
					width : '100px',
					height : '100px',
					top : lightboxTop + 'px',
					left : lightboxLeft + 'px'
				}).show();
				els.image.setStyle({
					width : '100px',
					height : '100px'
				})

				els.loading.show();
			}

			els.image.hide();
			// els.hoverNav.hide();
			els.navPrev.hide();
			els.navNext.hide();
			els.dataContainer.setOpacity(0.0001);
			els.imageNumber.hide();

			this.preload = new Image();
			this.preload.onload = (function() {
				els.image.dom.src = images[activeImage][0];
				var as = this.adjustSize(this.preload.width,
						this.preload.height)
				this.resizeImage(as.w, as.h, this.resetRotate);
			}).createDelegate(this);
			this.preload.src = images[activeImage][0];
		},
        
        adjustSize:function(w,h){
            var wm = this.borderSize*4,hm = this.borderSize*4+this.toolbarSize,viewSize = this.getViewSize(),
                iw = w + wm,ih = h + hm, vw = viewSize[0], vh =  viewSize[1],vr = iw/vw, hr=ih/vh;
            if(vr>1 || hr>1){
                if(vr<hr){
                   w = w * ((vh-hm)/h);
                    h = vh-hm;
                }else {
                    h = h * ((vw-wm)/w);
                    w = vw-wm;
                }
            }
            return {w:w,h:h}
        },

        resizeImage: function(w, h,callback,noanimate){
            var viewSize = this.getViewSize();
            var wCur = els.outerImageContainer.getWidth();
            var hCur = els.outerImageContainer.getHeight();

            var wNew = (w + this.borderSize * 2);
            var hNew = (h + this.borderSize * 2);

           var wDiff = wCur - wNew;
           var hDiff = hCur - hNew;

            var afterResize = function(){
//                els.hoverNav.setWidth(els.imageContainer.getWidth() + 'px');

                els.image.setHeight(h + 'px');
                els.image.setWidth(w + 'px');
                
                if(callback)callback.call(this);
                
//                els.navPrev.setHeight(h + 'px');
//                els.navNext.setHeight(h + 'px');

                //els.outerDataContainer.setWidth(wNew + 'px');

                this.showImage(noanimate);
            };
            var pageScroll = Ext.fly(document).getScroll();
            if (hDiff != 0 || wDiff != 0) {
                els.outerImageContainer.setStyle({
                    height: hNew+'px',
                    width: wNew+'px',
                    left: (pageScroll.left + (viewSize[0]-wNew)/2) +'px',
                    top: (pageScroll.top + (viewSize[1]-40-hNew)/2)+'px'
                });
                afterResize.call(this);
            }
            else {
                afterResize.call(this);
            }
        },

        showImage: function(noanimate){
            els.loading.hide();
            if(noanimate){
            	els.image.show();
            }else{
	            els.image.fadeIn({
	                duration: this.resizeDuration,
	                scope: this,
	                callback: function(){
	                    this.updateDetails();
	                }
	            });
            }
            this.preloadImages();
        },

        updateDetails: function(){
            var detailsWidth = els.data.getWidth(true) - els.navClose.getWidth() - 10;
            //els.details.setWidth((detailsWidth > 0 ? detailsWidth : 0) + 'px');
            els.caption.update('<a title="下载" href="'+images[activeImage][0]+'" target="_self">'+images[activeImage][1]+'</a>');

            els.caption.show();
            if (images.length > 1) {
                els.imageNumber.update(this.labelImage + ' ' + (activeImage + 1) + ' ' + this.labelOf + '  ' + images.length);
                els.imageNumber.show();
            }

            els.dataContainer.fadeIn({
                duration: this.resizeDuration/2,
                scope: this,
                callback: function() {
                    var viewSize = this.getViewSize();
//                    els.overlay.setHeight(viewSize[1] + 'px');
                    this.updateNav();
                }
            });
        },

        updateNav: function(){
            this.enableKeyNav();

//            els.hoverNav.show();

            // if not first image in set, display prev image button
            if (activeImage > 0)
                els.navPrev.show();

            // if not last image in set, display next image button
            if (activeImage < (images.length - 1))
                els.navNext.show();
        },

        enableKeyNav: function() {
            Ext.fly(document).on('keydown', this.keyNavAction, this);
        },

        disableKeyNav: function() {
            Ext.fly(document).un('keydown', this.keyNavAction, this);
        },

        keyNavAction: function(ev) {
            var keyCode = ev.getKey();

            if (
                keyCode == 88 || // x
                keyCode == 67 || // c
                keyCode == 27
            ) {
                this.close();
            }
            else if (keyCode == 80 || keyCode == 37){ // display previous image
                if (activeImage != 0){
                    this.setImage(activeImage - 1);
                }
            }
            else if (keyCode == 78 || keyCode == 39){ // display next image
                if (activeImage != (images.length - 1)){
                    this.setImage(activeImage + 1);
                }
            }
        },

        preloadImages: function(){
            var next, prev;
            if (images.length > activeImage + 1) {
                next = new Image();
                next.src = images[activeImage + 1][0];
            }
            if (activeImage > 0) {
                prev = new Image();
                prev.src = images[activeImage - 1][0];
            }
        },

        close: function(){
            this.disableKeyNav();
            this.rotate.dispose();
            els.lightbox.hide();
            els.overlay.fadeOut({
                duration: this.overlayDuration
            });
            els.shim.hide();
            this.fireEvent('close', activeImage);
			var pageScroll = 0;
        },

        getViewSize: function() {
            return [Ext.lib.Dom.getViewWidth(), Ext.lib.Dom.getViewHeight()];
        }
		
    }
})();

Ext.onReady(Ext.ux.Lightbox.init, Ext.ux.Lightbox);