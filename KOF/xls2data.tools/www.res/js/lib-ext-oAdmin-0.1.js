// JavaScript Document
oAdmin =
{
	"openFoot":function(url,p)
	{
		p = p?p:'50%';
		this.sysBar('*,'+p);
		window.parent.foot.document.location.replace(url);
	},
	"sysBar":function(v)
	{
		if(window.parent.main_foot.rows=='*,0')
		{
			window.parent.main_foot.rows=v;
		}else if(v == '*,0')
		{
			window.parent.main_foot.rows='*,0';
		}
	},
	"closeFoot":function()
	{
		try
		{
			if(window.parent.main_foot.rows!='*,0')
			{
				this.sysBar('*,0');
				window.parent.foot.document.location.replace('about:blank');
			}
		}catch(e){}
	},
	"get":function(url)
	{
	   fJson.get(url);    
	},
	"footGoWin":function(a)
	{
		a	=a?a:'about:blank';
		window.parent.data.document.location.replace(a);
	},
	"msgYn":function (msg)
	{
		msg = msg ? msg : '提示:删除将无法恢复!你确认要删除吗?';
		if(window.confirm(msg))
		{
			return true;
		}else
		{
			return false;	
		}
	},
	"menu":function()
	{
	    try
		{
			if(window.parent.left_main.cols=='0,*')
			{
				window.parent.toc.document.location.replace('s_menu.php');
				window.parent.left_main.cols='200,*';
			}else
			{
				window.parent.toc.document.location.replace('about:blank');
				window.parent.left_main.cols='0,*';
			}
		}catch(e){};
	}
};
var period_of_time = 
{
	id:0,
	bind:function(id)
	{
		Calendar.setup({
			inputField     :    "order_date_add_begin_"+id,
			ifFormat       :    "%Y%m%d00",
			showsTime      :    true,
			timeFormat     :    "24"
		});
		Calendar.setup({
			inputField     :    "order_date_add_end_"+id,
			ifFormat       :    "%Y%m%d24",
			showsTime      :    true,
			timeFormat     :    "24"
		});
	},
	make:function()
	{
		var rs = [],id = this.id;
		rs.push('<div id="order_date_add_id_'+id+'">');
		rs.push('<input type="text" name="order_date_add_begin['+id+']" onchange="period_of_time.compare(this,\'order_date_add_end_'+id+'\',\'begin\')" require="1" id="order_date_add_begin_'+id+'" size="16">');
		rs.push(' - ');
		rs.push('<input type="text" name="order_date_add_end['+id+']"   onchange="period_of_time.compare(this,\'order_date_add_begin_'+id+'\',\'end\')" require="1" id="order_date_add_end_'+id+'"   size="16">');
		rs.push('&nbsp;&nbsp;&nbsp;&nbsp; <input value="删除" type="button" onclick="period_of_time.deladd('+id+')" />');
		$("span#order_date_add").append(rs.join(""));
		period_of_time.bind(id);
		this.id = id + 1;
	},
	deladd:function(id)
	{
		$("#order_date_add_id_"+id).remove();
	},
	deldefault:function(id)
	{
		this.script = new Json();
		this.script.load(urlcode.en({"id":id,"act":"deldefault"},"dwr/load.php"),"period_of_time.deldefault_callback");
	},
	deldefault_callback:function(o)
	{
		var rs = o[0],id = o[1],msg = [2];
		if(rs)
		{
			$("#order_date_default_id_"+id).remove();
			alert("成功:删除成功");
		}else
		{
			alert(msg||"提示:系统忙，请重试!");
		}		
	},
	compare:function(o,el,type)
	{
		type = type || "begin";
		if(typeof el != "Object") el = _.e(el);
		if(type == "begin" && o.value.length == 10 && el.value.length == 10 && parseFloat(o.value) > parseFloat(el.value))
		{
			alert("提示：时段的开始时间不能大于结束时间");
			o.value = '';
		}else if(type == "end" && o.value.length == 10 && el.value.length == 10 && parseFloat(o.value) < parseFloat(el.value))
		{
			alert("提示：时段的结束时间不能小于开始时间");
			o.value = '';
		}
	}
};
/*****/
$(function(){
	$("tr._data_").mouseout(function(){							
		$(this).attr('class',this.onclick_class || this.oold_class || this.old_class || 'altbg1');
	}).mouseover(function(){
		var a = $(this);
		this.old_class = a.attr('class');
		a.attr('class','altbg_onchk');
	}).click(function(){
		if(this.c)
		{	
			this.c = 0;
			this.onclick_class = 0;
			$(this).attr('class',this.oold_class || 'altbg1');
		}else
		{	
			var a = $(this);
			this.c = 1;
			this.oold_class = this.old_class;
			this.onclick_class = 'altbg_onclick'; 
			a.attr('class','altbg_onclick');
		}
	}).each(function(i){
		if(i%2)
		{
			$(this).attr('class','altbg1');
		}else
		{
			$(this).attr('class','altbg2');
		}
	});
});
