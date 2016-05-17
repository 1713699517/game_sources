// JavaScript Document
/**
 * GM工具库文件
 */
function Gm(data,config)
{
    this.data 	    = data;
    this.config	= config;
}


function msgYn(msg)
{
	msg = msg ? msg : '提示:删除将无法恢复!你确认要删除吗?';
	var i = window.prompt(msg,'请在这里输入:yes 确认操作');
	//if(window.confirm(msg))
	if(i == 'yes'){
		return true;
	}else
	{
		return false;	
	}
};

// cookie
function cookie(name, value, options) 
{
	if (typeof value != 'undefined') { // name and value given, set cookie
		options = options || {};
		options.expires = options.expires || 1;
		options.path = options.path || "\/";
		options.domain = options.domain || document.domain;
		var expires = '';
		if (options.expires
				&& (typeof options.expires == 'number' || options.expires.toGMTString)) {
			var date;
			if (typeof options.expires == 'number') {
				date = new Date();
				date.setTime(date.getTime()
						+ (options.expires * 60 * 60 * 1000));
			} else {
				date = options.expires;
			}
			expires = '; expires=' + date.toGMTString(); // use expires
			// attribute,
			// max-age is not
			// supported by IE
		}
		var path = options.path ? '; path=' + options.path : '';
		var domain = options.domain ? '; domain=' + options.domain : '';
		var secure = options.secure ? '; secure' : '';
		document.cookie = [ name, '=', encodeURIComponent(value), expires,
				path, domain, secure ].join('');
	} else { // only name given, get cookie
		var cookieValue = '';
		if (document.cookie && document.cookie != '') {
			var cookies = document.cookie.split(';');
			for ( var i = 0; i < cookies.length; i++) {
				var cookie = trim(cookies[i]);
				// Does this cookie string begin with the name we want?
				if (cookie.substring(0, name.length + 1) == (name + '=')) {
					cookieValue = decodeURIComponent(cookie
							.substring(name.length + 1));
					break;
				}
			}
		}
		return cookieValue;
	}
};
function mp3_player(url,w,h)
{
	w = w?w:350;
	h = h?h:20;
	//var url = 'http://hydb9.gamecore.cn/s1/mp'+type+'/'+mp3id+'.mp3';
	return '<object align="absmiddle" type="application/x-shockwave-flash" ' +
				   'data="/r/dewplayer/dewplayer-vol.swf?mp3='+url+'" width="'+w+'" height="'+h+'" id="dewplayer-vol">' +
				   '<param name="wmode" value="transparent" />' +
				   '<param name="movie" value="/r/dewplayer/dewplayer-vol.swf?mp3='+url+'" />' +
		   '</object>';
}
//
function trim( text )
{
	var trimLeft = /^\s+/,trimRight = /\s+$/;
	return text == null ? "" : text.toString().replace( trimLeft, "" ).replace( trimRight, "" );
};

function parseInt2(v)
{
	v = parseFloat(v);
	if(isNaN(v))
	{
		return 0;
	}else
	{
		return v;
	}
};

var Json  = {
	en : function(v) {
		v = v || this.object || {};
		var m = {
			'\b' :'\\b',
			'\t' :'\\t',
			'\n' :'\\n',
			'\f' :'\\f',
			'\r' :'\\r',
			'"' :'\\"',
			'\\' :'\\\\'
		}, s = {
			'array' : function(x) {
				var a = [ '[' ], b, f, i, l = x.length, v;
				for (i = 0; i < l; i += 1) {
					v = x[i];
					f = s[typeof v];
					if (f) {
						v = f(v);
						if (typeof v == 'string') {
							if (b) {
								a[a.length] = ',';
							}
							a[a.length] = v;
							b = true;
						}
					}
				}
				a[a.length] = ']';
				return a.join('');
			},
			'boolean' : function(x) {
				return String(x);
			},
			'null' : function(x) {
				return "null";
			},
			'number' : function(x) {
				return isFinite(x) ? String(x) : 'null';
			},
			'object' : function(x) {
				if (x) {
					if (x instanceof Array) {
						return s.array(x);
					}
					var a = [ '{' ], b, f, i, v;
					for (i in x) {
						v = x[i];
						f = s[typeof v];
						if (f) {
							v = f(v);
							if (typeof v == 'string') {
								if (b) {
									a[a.length] = ',';
								}
								a.push(s.string(i), ':', v);
								b = true;
							}
						}
					}
					a[a.length] = '}';
					return a.join('');
				}
				return 'null';
			},
			'string' : function(x) {
				if (/["\\\x00-\x1f]/.test(x)) {
					x = x.replace(/([\x00-\x1f\\"])/g, function(a, b) {
						var c = m[b];
						if (c)
							return c;
						c = b.charCodeAt();
						return '\\u00' + Math.floor(c / 16).toString(16)
								+ (c % 16).toString(16);
					});
				}
				return '"' + x + '"';
			}
		};
		var f = isNaN(v) ? s[typeof v] : s['number'];
		if (f) {
			this.string = f(v);
			return this.string;
		} else {
			this.error = [ 1, "json en ing... error." ];
		}
	},
	$ : function(str) {
		str = str || this.string || "";
		if (!str)
			return '';
		var c1, c2, c3, c4, c5 = [ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1,
				-1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
				12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1,
				-1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
				38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1,
				-1, -1, -1 ], c6 = str.charCodeAt(0) % 2, c7, i, len, out;
		if (this['][']) {
			this[']['] = 0;
		} else {
			this[']['] = 1;
			c7 = this.$(str);
			str = c7.substr(c6);
		}
		;
		len = str.length;
		i = 1;
		out = "";
		while (i < len) {
			do {
				c1 = c5[str.charCodeAt(i++) & 0xff];
			} while (i < len && c1 == -1);
			if (c1 == -1)
				break;
			do {
				c2 = c5[str.charCodeAt(i++) & 0xff];
			} while (i < len && c2 == -1);
			if (c2 == -1)
				break;
			out += String.fromCharCode((c1 << 2) | ((c2 & 0x30) >> 4));
			do {
				c3 = str.charCodeAt(i++) & 0xff;
				if (c3 == 61)
					return out;
				c3 = c5[c3];
			} while (i < len && c3 == -1);
			if (c3 == -1)
				break;
			out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));
			do {
				c4 = str.charCodeAt(i++) & 0xff;
				if (c4 == 61)
					return out;
				c4 = c5[c4];
			} while (i < len && c4 == -1);
			if (c4 == -1)
				break;
			out += String.fromCharCode(((c3 & 0x03) << 6) | c4);
		}
		return out;
	},
	de : function(string, date) {
		string = string || this.string;
		if (typeof date != "undefined") {
			data = eval("(" + string + ")");
		} else {
			if (typeof jQuery != "undefined") {
				jQuery.globalEval(string);
			} else {
				eval.call(window, string);
			}
		}
	},
	load : function(url, callback, charset) {
		if (callback) {
			if (/{callback}/.test(url)) {
				url = url.replace(/{callback}/, callback);
			} else {
				url += (url.indexOf('?') == -1 ? '?' : '&') + 'callback='
						+ callback;
			}
		}
		if (jQuery.browser.msie && this.script) {
			var script = this.script;
			if (charset)
				script.charset = charset;
			script.src = url;
			return;
		} else {
			script = document.createElement('script');
			if (charset)
				script.charset = charset;
			script.type = 'text/javascript';
			script.src = url;
			document.getElementsByTagName('HEAD')[0].appendChild(script);
			this.script = script;
		}
		return script;
	}
};

function $id(id){
	return document.getElementById(id);
};

function $indexOf(array,val)
{
	for (var i = array.length - 1; i >= 0; i--){
		if(array[i]==val){
			return i;
		}
	};
	return -1;
};

function $remove(array,val)
{
	var index = $indexOf(array,val);
	if (index > -1){
		array.splice(index, 1);
	}
};
	