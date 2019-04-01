//viewerjs插件引用
        function show_viewer_more(link , id , name ,value) {
                 var img ='';
                 var str = value.split(';;');
                 var div = document.createElement("div");
                 var initialViewIndex ='';
				 for (var i = 0;i < str.length;i++) {
					var temp = str[i].split('--');
					if (!Aurora.isEmpty(temp[0])) {
						var file_name = temp[0].toUpperCase();
						var file_suffix = temp[0].substr(temp[0].lastIndexOf('.') + 1).toUpperCase();
						if (file_suffix == 'BMP' || file_suffix == 'JPG' || file_suffix == 'JPEG' || file_suffix == 'PNG' || file_suffix == 'GIF') {
							img = img + '<li><img data-original="img/tibet-'+i+'.jpg" src="'+ link + temp[1] +'" alt="'+temp[0] +'"></li>';
						}
						if (id == temp[1]) {
							initialViewIndex = i;
						}
					}
				}
				 img = '<ul>'+img + '</ul>';
				div.innerHTML=img;
				div.id='view-imgs';
				var viewer = new Viewer(div, {
                    hidden: function() {
                        viewer.destroy();
                    },
                    toolbar: {
                        zoomIn: 3,
                        zoomOut: 3,
                        oneToOne: 3,
                        reset: 3,
                        prev: 3,
                        play: {
                            show: 3,
                            size: 'large',
                        },
                        next: 3,
                        rotateLeft: 3,
                        rotateRight: 3,
                        flipHorizontal: 3,
                        flipVertical: 3,
                    },
                    
                });
                //这个就是点开那张图片就是那张图片，从点开图片的那张开始
				viewer.view(initialViewIndex);
               //默认展示容器从第一张开始
				//viewer.show();
				
            }
        	
        		
        //附件预览页面，图片点击事件
        Ext.fly(document).on('click', function(ev){
        	//获取图片超链接
            var target = ev.getTarget('a[ref=img]');
            if (target) {
                ev.preventDefault();//取消事件的默认动作。
                //调用单张图片预览方法
                show_viewer_singer(target.href, target.title);
            }
       
        }, this);
        
        
        function show_viewer_singer(src, name) {
            var image = new Image();
            image.src = src;
            image.alt = name;
            var viewer = new Viewer(image, {
                hidden: function() {
                    viewer.destroy();
                },
                toolbar: {
                    zoomIn: 3,
                    zoomOut: 3,
                    oneToOne: 3,
                    reset: 3,
                    prev: 3,
                    play: {
                        show: 3,
                        size: 'large',
                    },
                    next: 3,
                    rotateLeft: 3,
                    rotateRight: 3,
                    flipHorizontal: 3,
                    flipVertical: 3,
                },
            });
            viewer.show();
        }

 