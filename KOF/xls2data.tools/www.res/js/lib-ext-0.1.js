// JavaScript Document
Array.prototype.indexOf = function(o) {
	var l = this.length;
	for ( var i = 0; i < l; i++) {
		if (this[i] == o) {
			return i;
		}
	}
	return -1;
};
Array.prototype.remove = function(n) {
	this.splice(n, 1);
};
Array.prototype.replace = function(n, vars) {
	this.splice(n, 1, vars);
};
String.prototype.trim = function(t) {
	return (t || this || "").replace(/^\s+|\s+$/g, "");
};
Function.prototype.defer = function(C, A) {
	var B = this;
	if (A) {
		window.setTimeout( function() {
			B.call(A);
		}, C);
	} else {
		window.setTimeout(this, C);
	}
};
if (window.addEventListener) {
	function __element_style() {
		return (this.style);
	}
	function __window_event() {
		return (__window_event_constructor());
	}
	function __event_srcElement() {
		return this.target;
	}
	function __window_event_constructor() {
		if (document.all)
			return (window.event);

		var _caller = __window_event_constructor.caller;
		while (_caller != null) {
			var _argument = _caller.arguments[0];
			if (_argument) {
				var _temp = _argument.constructor;
				if (_temp.toString().indexOf("Event") != -1)
					return (_argument);
			}
			_caller = _caller.caller;
		}
		return (null);
	}
	function __firefox() {
		HTMLElement.prototype.__defineGetter__("runtimeStyle", __element_style);
		window.constructor.prototype.__defineGetter__("event", __window_event);
		Event.prototype.__defineGetter__("srcElement", __event_srcElement);
	}
	__firefox();
}
/**
 * include javascript
 * 
 * @examples include js include(url,js);
 */
var include = function(url, type, o, unasync) {
	if (typeof type == 'object' || typeof type == 'boolean') {
		o = type;
		type = 'script';
	}
	if (typeof o == 'boolean') {
		unasync = o;
		o = {};
	}
	type = type || 'script';
	o = o || {};
	if (type == 'script') {
		o.src = url || o.src || null;
		if (unasync) {
			var rs = [], k;
			for (k in o)
				if (o[k])
					rs.push(k + '="' + o[k] + '"');
			document
					.write('<script type="text/javascript" ' + rs.join(' ') + '></script>');
		} else {
			var rs = document.createElement('script');
			for ( var k in o)
				rs[k] = o[k];
			rs["type"] = "text/javascript";
			document.getElementsByTagName('head')[0].appendChild(rs);
		}
	} else {
		o.href = url || o.href || null;
		if (unasync) {
			var rs = [], k;
			for (k in o)
				if (o[k])
					rs.push(k + '="' + o[k] + '"');
			document.write('<link rel="stylesheet" type="text/css" ' + rs
					.join(' ') + ' />');
		} else {
			var rs = document.createElement('link');
			for ( var k in o)
				rs[k] = o[k];
			rs["type"] = "text/css";
			rs["rel"] = "stylesheet";
			document.getElementsByTagName('head')[0].appendChild(rs);
		}
	}
};
/**
 * cookie ext $.cookie('the_cookie'); // get cookie $.cookie('the_cookie', 'the
 * value'); // set cookie $.cookie('the_cookie', 'the value', {expires: 7}); //
 * set cookie with an expiration date seven days in the future
 * $.cookie('the_cookie', '', {expires: -1}); // delete cookie
 */
jQuery.cookie = function(name, value, options) {
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
				var cookie = jQuery.trim(cookies[i]);
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
/**
 * Json Class
 * 
 * @param object:Object
 *            string:String script:Element error :Array
 * @member en() de() load();
 */
function Json(o) {
	if (typeof o == "undefined")
		return false;
	if (o.url) {
		this.load(o.url, o.callback, o.charset);
		return this;
	} else if (typeof o == "object") {
		this.object = o;
	} else if (typeof o == "string") {
		this.string = o;
	}
};
Json.prototype = {
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
/*
 * xyp
 */
var _ = {
	go : function(url, top, note) {
		if (note)
			if (!window.confirm(note))
				return;
		if (top) {
			top.document.location.href = url;
		} else {
			document.location.href = url;
		}
	},
	r : function(vars) {
		document.write(vars);
	},
	getTime : function() {
		return Math.floor((new Date()).getTime() / 1000);
	},
	e : function() {
		var elements = [];
		for ( var i = 0; i < arguments.length; i++) {
			var element = arguments[i];
			if (typeof element == 'string')
				element = document.getElementById(element);
			if (arguments.length == 1)
				return element;
			elements.push(element);
		}
		return elements;
	},
	get : function(name) {
		var get = [ location.search, location.hash ].join('&');
		var start = get.indexOf(name + '=');
		if (start == -1)
			return '';
		var len = start + name.length + 1;
		var end = get.indexOf('&', len);
		if (end == -1)
			end = get.length;
		return decodeURIComponent(get.substring(len, end));
	},
	copy : function(vars, note) {
		if (window.clipboardData) {
			window.clipboardData.setData("Text", vars);
			return true;
		} else {
			return false;
		}
	},
	time : function(a, b) {
		var s, d, y;
		d = new Date(a * 1000);
		y = d.getYear();
		s = (jQuery.browser.msie ? y : (y + 1900)) + "-" + (d.getMonth() + 1)
				+ "-" + d.getDate();
		if (b != 1) {
			s += " " + d.getHours() + ":" + d.getMinutes() + ":"
					+ d.getSeconds();
		}
		return s;
	},
	size : function(a) {
		var b;
		if (a < 1024) {
			b = 'Bit';
		} else if (a < 1024 * 1024 && a > 1024) {
			a = a / 1024;
			b = 'K';
		} else if (a < 1024 * 1024 * 1024 && a > 1024 * 1024) {
			a = a / 1024 / 1024;
			b = 'M';
		} else {
			a = a / 1024 / 1024 / 1024;
			b = 'G';
		}
		;
		return (Math.round(a * 100) / 100) + b;
	},
	rand : function(begin, end) {
		if (typeof begin != 'undefined') {
			end = end ? end : 2147483648;
			return Math.floor(Math.random() * (end - begin) + begin);
		} else {
			return (new Date()).getTime();
		}
	}
};
var url = {
	en : function(o, url) {
		var rs = [];
		for ( var k in o)
			rs.push(k + '=' + encodeURIComponent(o[k]));
		return (url ? url + (url.indexOf('?') == -1 ? '?' : '&') : '')
				+ rs.join('&');
	},
	de : function(str) {
		str = (str.indexOf('?') == -1 ? str : str.split("?")[1]).split("&");
		var rs = {}, a, c = str.length;
		for ( var i = 0; i < c; i++) {
			a = str[i].split("=");
			rs[a[0]] = decodeURIComponent(a[1]);
		}
		return rs;
	},
	"get" : function(name) {
		var get = [ location.search, location.hash ].join('&');
		var start = get.indexOf(name + '=');
		if (start == -1)
			return '';
		var len = start + name.length + 1;
		var end = get.indexOf('&', len);
		if (end == -1)
			end = get.length;
		return unescape(get.substring(len, end));
	}
};
/**
 * Player
 */
var Player = {
	flash : function(e, p, v, w, h) {
		if (typeof e == "string" && e != "__return__")
			e = _.e(e);
		p = p || 'http://www.56.com/flashApp/v_player_site_fp7_5_20061219.swf';
		w = w || '100%';
		h = h || '100%';
		var wl = _.get('wl') || 0, rs;
		rs = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" '
				+ 'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" '
				+ 'width="' + w + '" ' + 'height="' + h + '">'
				+ '<param name="movie" value="' + (wl ? p + '?' + v : p) + '">'
				+ '<param name="quality" value="high">'
				+ '<param name="allowScriptAccess" value="always" />'
				+ '<param name="wmode" value="transparent" />'
				+ '<param name="allowFullScreen" value="true" />'
				+ (wl ? '' : '<param name="FlashVars" value="' + v + '" />')
				+ '<embed src="' + (wl ? p + '?' + v : p) + '"  '
				+ (wl ? '' : 'flashvars="' + v + '"') + ' '
				+ 'quality="high" wmode="transparent" '
				+ 'pluginspage="http://www.macromedia.com/go/getflashplayer" '
				+ 'type="application/x-shockwave-flash"  ' + 'width="' + w
				+ '" ' + 'height="' + h + '"></embed>' + '</object>';
		if (e == "__return__")
			return rs;
		e.innerHTML = rs;
	},
	image : function(e, w, h, b, src, url) {
		if (typeof e == "string" && e != "__return__")
			e = _.e(e);
		w = w || 85;
		h = h || w;
		b = b || ' target="_blank" ';
		src = src || e.getAttribute('src');
		url = url || e.getAttribute('href');
		if (src) {
			swf = (__scfg__.staticUrl || "http://www.pailego.com/static/")
					+ "swf/f.swfoto.swf";
			var rs = this.flash("__return__", swf, 'image=' + src
					+ '&ima-geLink=' + url, w, h);
			if (url)
				url = '<div style="margin:3px auto;border:solid #cecece 1px;position:relative;width:'
						+ w
						+ 'px; height:'
						+ h
						+ 'px;">'
						+ (url ? '<a style="display:block;background:#FFFFFF;filter:alpha(opacity=0);opacity:0;position:absolute;left:0px;top:0px;width:'
								+ w
								+ 'px; height:'
								+ h
								+ 'px;z-index:2;" href="'
								+ url
								+ '" '
								+ b
								+ '></a>'
								: '') + rs + '</div>';
			if (e == "__return__")
				return rs;
			e.innerHTML = rs;
		}
	}
};