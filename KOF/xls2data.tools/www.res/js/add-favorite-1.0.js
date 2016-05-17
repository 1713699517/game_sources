// JavaScript Document
var cookie = function(name, value, options) 
{
	if (typeof value != 'undefined') 
	{ // name and value given, set cookie
		options = options || {};
		options.expires = options.expires || 3*24;
		options.path = options.path || "\/";
		options.domain = options.domain || document.domain;
		var expires = '';
		if (options.expires && (typeof options.expires == 'number' || options.expires.toGMTString)) 
		{
			var date;
			if (typeof options.expires == 'number') 
			{
				date = new Date();
				date.setTime(date.getTime() + (options.expires * 60 * 60 * 1000));
			} else 
			{
				date = options.expires;
			}
			expires = '; expires=' + date.toGMTString(); // use expires attribute, max-age is not supported by IE
		}
		var path = options.path ? '; path=' + options.path : '';
		var domain = options.domain ? '; domain=' + options.domain : '';
		var secure = options.secure ? '; secure' : '';
		document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
	} else 
	{ // only name given, get cookie
		var cookieValue = '';
		if (document.cookie && document.cookie != '') 
		{
			var cookies = document.cookie.split(';');
			for (var i = 0; i < cookies.length; i++) 
			{
				var cookie = (cookies[i]||"").replace(/^\s+|\s+$/g,"");// jQuery.trim(cookies[i]);
				// Does this cookie string begin with the name we want?
				if (cookie.substring(0, name.length + 1) == (name + '=')) 
				{
					cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
					break;
				}
			}
		}
		return cookieValue;
	}
};
var add_favorite = function(key,tite,url)
{
	var c = parseInt(cookie('_add_fav_'+key));
	if(c == NaN) c = 0;
	if(c<3)
	{
		try{
			window.sidebar.addPanel(tite,url,"");
		}catch(e){
			try{
				window.external.AddFavorite(url,tite);
			}catch(e){
				alert(" 加入收藏失败，请使用Ctrl+D进行添加 "); 
			}
		};
		cookie('_add_fav_'+key,c+1);
	}
}