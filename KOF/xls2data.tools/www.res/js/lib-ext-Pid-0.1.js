var load_Pid  = new Json();
var load_call = function(arr)
{
	var eid = arr.eid,o=arr.data;
	if(typeof o[0] != "undefined")
	{
		var len = o.length,i,rs=[],v,color,note;
		for(i=0;i<len;i++)
		{
			v = o[i];
			if(v['state']>=3)
			{
				color ="#990000";
				note  ="投放中..";
			}else if(v['state']==2)
			{
				color ="#333333";
				note  ="已下单..";
			}else if(v['state']==1)
			{
				color ="#666666";
				note  ="预定..";
			}else if(v['state']==0)
			{
				color ="#999999";
				note  ="备定..";
			}else if(v['state']==-1)
			{
				color ="#FF9900";
				note  ="冲突..";
			}
			rs.push('<font color="'+color+'">'+v["begin"]+'-'+v["end"]+' 编号:'+v["OYmd"]+v["Oid"]+' 状态:'+note+'</font>');
		}		
	}else
	{
		rs=['<font color="#990000">还没人预定...</font>'];
	}
	_.e("eid_"+eid).innerHTML=rs.join("<br />");
};
var load_func = function(a,eid)
{
	eid = eid || a;
	var url = urlcode.en({act:"query_clash",Pid:a,eid:eid,r:_.rand()},"dwr/load.php");
	load_Pid.load(url,"load_call","utf-8");
};