if(typeof XypForm == "undefined")
{
	/*
	t.dataType : nums|alpha|alphanum|cnaznum|email|url|twIdCard|cnIdCard
	*/
	XypForm = function(o)
	{
		$('div.xyp-form-invalid-div',o).remove();
		var aI = ['input','textarea','select'];
		var j,i,jl=aI.length,oI,l,t,c,d,f;
		for(j=0;j<jl;j++)
		{
			oI = o.getElementsByTagName(aI[j]);
			l = oI.length;
			for(i =0; i<l;i++)
			{
				t = oI[i];
				$(t).removeClass("xyp-form-invalid");
				if(t.getAttribute('require') == 1 || (t.getAttribute('require') == 2 && t.value))
				{
					if(t.type == 'radio')
					{
						c = XypForm.chkRadio(o,t);
						if(!c[1])
						{
							if(c[0] == 1)
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：请勾选此项!');
							}else
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：此项不能爲空，请勾选以其中一项!',1);
							} 
							return false;
						};
					}else if(t.type == 'checkbox')
					{
						var c = XypForm.chkCheckbox(o,t);
						if(c[0] == 1)
						{
							if(!c[1])
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：请勾选此项!');
								return false;
							}							
						}else
						{
							if(!c[1] && t.getAttribute('min') != 0)
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：此项不能爲空!',1);
								return false;							
							}else if(t.getAttribute('min') && c[1]<t.getAttribute('min'))
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：此项最少要選擇'+t.getAttribute('min')+'項!',1);
								return false;	
							}else if(t.getAttribute('max') && c[1]>t.getAttribute('max'))
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：此项最多只能選擇'+t.getAttribute('max')+'項!',1);
								return false;	
							};
						}						
					}else
					{
						if(t.value == "")
						{
							XypForm.msg(t);
							return false;
						}else if(t.getAttribute('min') && parseFloat(t.value)<parseFloat(t.getAttribute('min')))
						{
							XypForm.msg(t,t.getAttribute('msg')||'提示：此项值不能少于'+t.getAttribute('min')+'，请正确填写！');
							return false;	
						}else if(t.getAttribute('max') && parseFloat(t.value)>parseFloat(t.getAttribute('max')))
						{
							XypForm.msg(t,t.getAttribute('msg')||'提示：此项值最大不能大于'+t.getAttribute('max')+'，请正确填写！');
							return false;	
						}else if(t.getAttribute('minlen') && XypForm.len(t.value)<t.getAttribute('minlen'))
						{
							XypForm.msg(t,t.getAttribute('msg')||'提示：此项不能小于'+t.getAttribute('minlen')+'個字符！');
							return false;	
						}else if(t.getAttribute('maxlen') && XypForm.len(t.value)>t.getAttribute('maxlen'))
						{
							XypForm.msg(t,t.getAttribute('msg')||'提示：此项最多不能大于'+t.getAttribute('maxlen')+'個字符！');
							return false;	
						}else if(t.getAttribute('again') && t.value != o[t.getAttribute('again')].value)
						{
							XypForm.msg(t,t.getAttribute('msg')||'提示：請再次輸入此前項目！');
							return false;	
						}else if(t.getAttribute('dataType'))
						{
							d = t.getAttribute('dataType');
							f = XypForm.VType[d];
							if(f && !f(t.value))
							{
								XypForm.msg(t,XypForm.VType[d+'Text']);
								return false;
							}
						}else if(t.getAttribute('accept'))
						{
							var r = new RegExp("\\.(?:"+t.getAttribute('accept').replace(/:| |(：)|,/g,'|')+")$","i");
							if(!r.test(t.value))
							{
								XypForm.msg(t,t.getAttribute('msg')||'提示：文件类型不正确！');	
								return false;	
							}
						};
					}					
				}
			}
		}
		return true;
	};
	XypForm.chk   =function(t)
	{
		XypForm.remove(t);
		var f,d;
		d = t.getAttribute('dataType');
		f = XypForm.VType[d];
		if(t.value == '')
		{
			XypForm.msg(t);
			return false;
		}else if(f && !f(t.value))
		{
			XypForm.msg(t,XypForm.VType[d+'Text']);
			return false;
		}
		return true;
	}
	XypForm.VType = function()
	{
		// closure these in so they are only created once.
		var alpha = /^[a-zA-Z_]+$/;
		var nums = /^[\d\.\-]+$/;
		//var cnazunm  = /^(\w+)|([\u0391-\uFFE5]+)$/;//^[\u4E00-\u9FA5a-zA-Z0-9_]+$/;
		var cnazunm  = /^[\u4E00-\u9FA5a-zA-Z0-9_]+$/;
		var alphanum = /^[a-zA-Z0-9_]+$/;
		var email = /^([\w]+)(.[\w]+)*@([\w-]+\.){1,5}([A-Za-z]){2,4}$/;
		var url = /(((https?)|(ftp)):\/\/([\-\w]+\.)+\w{2,3}(\/[%\-\w]+(\.\w{2,})?)*(([\w\-\.\?\\\/+@&#;`~=%!]*)(\.\w{2,})?)*\/?)/i;
	
		// All these messages and functions are configurable
		return {
			'nums' : function(v){
				return nums.test(v);
			},
			'numsText' : '提示：這裡只能是数字',
			'numsMask' : /^\d+$/i,
			'email' : function(v){
				return email.test(v);
			},
			'emailText' : '提示：請輸入正確的EMAIL,如:"user@yahoo.com.tw"',
			'emailMask' : /[a-z0-9_\.\-@]/i,
			'url' : function(v){
				return url.test(v);
			},
			'urlText' : '提示：請輸入正確的網址,如:http:/'+'/www.pailego.com',
			'alpha' : function(v){
				return alpha.test(v);
			},
			'alphaText' : '提示：這裡只能是字母與"_"',
			'alphaMask' : /[a-z_]/i,
			'alphanum' : function(v){
				return alphanum.test(v);
			},
			'alphanumText' : '提示：這裡只能是字母,數字,"_"',
			'alphanumMask' : /[a-z0-9_]/i,
			'cnaznum' : function(v){
				return cnazunm.test(v);
			},
			'cnaznumText' : '提示：這裡只能是汉字,字母,數字,"_"',
			'twIdCard' : function(id) 
			{  //檢查身份證字號格式是否正確
				var checksum,tsum,check1,check2,check3
				var bid=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
				var vid=[1,10,19,28,37,46,55,64,39,73,82,2,11,20,48,29,38,47,56,65,74,83,21,3,12,30];			
				var txtid=id.toUpperCase();
				var re =/^[A-Z]\d{9}$/;
				if ( !re.test(txtid))
				{
					return false;
				}
				for (I=0;I<=26;I++)
				{
					if (bid[I]==txtid.substring(0,1))
					{
					   tsum=parseInt(vid[I]);
					}
				}
				checksum=tsum+parseInt(txtid.substring(1,2))*8+parseInt(txtid.substring(2,3))*7+parseInt(txtid.substring(3,4))*6+parseInt(txtid.substring(4,5))*5+parseInt(txtid.substring(5,6))*4+parseInt(txtid.substring(6,7))*3+parseInt(txtid.substring(7,8))*2+parseInt(txtid.substring(8,9))*1+parseInt(txtid.substring(9,10))*1;
				check1 = parseInt(checksum/10);
				check2 = checksum/10;
				check3 = (check2-check1)*10;
				if (checksum == check1*10) 
				{
				   return true;
				}else if (txtid.substring(9,10) == (10-check3)) 
				{
				   return true;
				}else 
				{
				   return false;
				}			
			},
			'twIdCardText' : '提示：身份證字號有误!',
			'cnIdCard' : function(idcard)
			{
				var Errors=["提示：验证通过!","提示：身份证号码位数不对!","提示：身份证号码出生日期超出范围或含有非法字符!","提示：身份证号码校验错误!","提示：身份证地区非法!"];
				var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}
				var idcard,Y,JYM;
				var S,M;
				var idcard_array = idcard.split("");
				if(area[parseInt(idcard.substr(0,2))]==null)
				{
					XypForm.VType.cnIdCardText = Errors[4];
					return false;
				}
				switch(idcard.length)
				{
					case 15:
						if ((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 ))
						{
							ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性
						}else
						{
							ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性
						}
						if(ereg.test(idcard))
						{
							return true;
						}else
						{
							XypForm.VType.cnIdCardText = Errors[2];
							return false;
						}
					break;
					case 18:
						if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 ))
						{
							ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式
						}else
						{
							ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式
						}
						if(ereg.test(idcard))
						{
							S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 + (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 + (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 + (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 + (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 + (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 + (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 + parseInt(idcard_array[7]) * 1 + parseInt(idcard_array[8]) * 6 + parseInt(idcard_array[9]) * 3 ;
							Y = S % 11;
							M = "F";
							JYM = "10X98765432";
							M = JYM.substr(Y,1);
							if(M == idcard_array[17])
							{
								return true;
							}else
							{
								XypForm.VType.cnIdCardText = Errors[3];
								return false;
							}
						}else
						{
							XypForm.VType.cnIdCardText = Errors[2];
							return false;
						}
					break;
					default:
						XypForm.VType.cnIdCardText = Errors[1];
						return false;
					break;
				}
			},
			'cnIdCardText' : '提示：身份證号码有误!'
		};
	}();
	XypForm.msg	  = function(o,msg,c)
	{
		c = c || 'addClass';
		msg = msg || o.getAttribute('msg') || (function(o){try{return "提示："+($(o).parent().find("label").html().replace(/:| |(：)|＊|\*/g,'')||"這裡")+"不能爲空！";}catch (e){return '';}; })(o) || '提示：此项不能爲空!';
		var t = $(o);
		if(c == 'addClass')
		{
			t.addClass("xyp-form-invalid");
			t.click(function(){$(this).removeClass("xyp-form-invalid").unbind();})
		}
		t.parent().append('<div class="xyp-form-invalid-div">'+msg+'</div>');
		try{o.focus();}catch (e){};
		return false;
	};
	XypForm.chkRadio = function(o,t)
	{
		var I = o[t.name];
		var l = I.length,i;
		if(typeof l == "undefined")
		{
			return [1,t.checked];
		}else
		{
			for(i=0;i<l;i++)
			{
				if(I[i].checked == true)return [l,true];
			}
		}
		return [l,false];
	};
	XypForm.remove =function(o)
	{
		$(o).removeClass("xyp-form-invalid").parent().find('.xyp-form-invalid-div').remove();
	};
	XypForm.len = function(str)
	{
		return str.replace(/[^\x00-\xff]/g,"00").length;
	};
	XypForm.chkCheckbox = function(o,t)
	{
		var I = o[t.name];
		var l = I.length,i,c=0;
		if(typeof l == "undefined")
		{
			return [1,t.checked];
		}else
		{
			for(i=0;i<l;i++)
			{
				if(I[i].checked == true)c++;
			}
			return [l,c];
		}
		return [l,false];
	}	
}