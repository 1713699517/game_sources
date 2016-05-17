function gm_table()
{
	var titles = gc.config.titles;
	var subareas = gc.config.subareas;
	var datas = gc.config.datas;
	var html = '';
	
	for(var i in subareas)
	{
		var subarea = subareas[i];
		var data = datas[subarea['subarea_id']];
		
		html += '<div style="margin:5px 0px 0px 10px;">';
		html += '<a href="?subarea_id='+subarea['subarea_id']+'" style="font-size:18px;color:#F39;">'+subarea['name']+'</a>&nbsp';
		html += '<a href="#" onclick="add_data('+subarea['subarea_id']+');" style="font-size:12px;">添加命令</a>&nbsp<br/></div>'; 
		if(data != undefined)
		{
			html += '<table width="98%" cellpadding="0" cellspacing="1" style="border:#666 solid 1px;margin:0px 0px 0px 10px;">';
			html += '<tr>';
			html += '<td width="20%" >'+titles['name']+'</td>';
			html += '<td width="35%" >'+titles['effect']+'</td>';
			html += '<td width="35%" >'+titles['method']+'</td>';
			html += '<td width="" align="center">'+titles['ope']+'</td>';
			html += '</tr>';
			
			var c_index = 0;
			for(var j in data)
			{
				var d = data[j];
				var c = c_index%2?'CDFFCD':'FFCD99';
				html += '<tr bgcolor="'+c +'">';
				html += '<td><a style="font-size:15px;color:#F39;">'+d['name']+'</a></td>';
				html += '<td>'+d['effect']+'</td>';
				html += '<td>'+d['method']+'</td>';
				html += '<td align="center">';
				html += '<a href="#" onclick="modify_data('+d['subarea_id']+','+d['id']+');" style="font-size:12px;">修改</a>&nbsp';
				html += '<a href="?act=del&id='+d['id']+'" onclick="return msgYn();" style="font-size:12px;">删除</a>&nbsp';
				html += '</td>';
				html += '</tr>';
				
				c_index++;
			}
			html += '</table>';
		}
		html += '<br/>';
	}
	
	return html;
}
function gm_subarea()
{
	var html = '';
	var ope_container = document.getElementById('ope');
	ope_container.innerHTML='';
	html += '<a style="font-size:18px;">主要模块</a>&nbsp';
	html += '<a href="/gm.php" style="font-size:12px;">显示全部</a> &nbsp';
	html += '<a href="/" 	   style="font-size:12px;">返回主页</a>&nbsp'; 
	html += '<a href="#" onclick="add_subarea();" style="font-size:12px;">添加模块</a>&nbsp'; 
	ope_container.innerHTML=html;
	
	html = '';
	var sub_container = document.getElementById('subarea');
	sub_container.innerHTML='';
	var subareas = gc.config.subareas;
	
	for(var i in subareas)
	{
		var subarea = subareas[i];
		html += '<a href="?subarea_id='+subarea['subarea_id']+'" style="font-size:12px;">'+subarea['name']+'</a> ';
		html += '<a href="#" style="font-size:12px;color:#999;" onclick="modify_subarea('+i+');">改</a>&nbsp';
	}
	sub_container.innerHTML= html;
	   
}
function add_subarea()
{
	gc.dialog.open_add_sub();
}
function modify_subarea(i)
{
	gc.dialog.open_modify_sub(i);
}
function add_data(sub_id)
{
	gc.dialog.open_add_data(sub_id);
}
function modify_data(sub_id,id)
{
	gc.dialog.open_modify_data(sub_id,id);
}
var gc = {
		// 配制
		config:{},
		/**
		 * 弹出窗口相关
		 */
		dialog:{
			/** 初始化窗口			 **/
			init:function(){
				$('#add_dialog').dialog({
					autoOpen: false,
					width: '90%',
					buttons: {}
				});
				$('#modify_dialog').dialog({
					autoOpen: false,
					width: '90%',
					buttons: {}
				});
			},
			open_add_sub:function(){
				$('#add_sub_dialog').dialog('open');
				var container				= document.getElementById('add_sub_div');
				var div		 				= document.createElement("div");
				container.innerHTML='';
				var html = '';
				html += '<a>模块名称:</a><input id="add_sub_name" name="add_sub_name" type="text"  size="10" value="" maxlength="32"/><br/><br/>';
				div.innerHTML= html;
				container.appendChild(div);
			},
			open_modify_sub:function(i){
				var subarea = gc.config.subareas[i];
				$('#modify_sub_dialog').dialog('open');
				var container				= document.getElementById('modify_sub_div');
				var div		 				= document.createElement("div");
				container.innerHTML='';
				var html = '';
				html += '<input type="hidden" id="modify_sub_id" name="modify_sub_id" value="'+subarea['subarea_id']+'"/>';
				html += '<a>模块名称:</a><input id="modify_sub_name" name="modify_sub_name" type="text"  size="10" value="'+subarea['name']+'" maxlength="32"/><br/><br/>';
				div.innerHTML= html;
				container.appendChild(div);
			},
			open_add_data:function(sub_id){
				$('#add_data_dialog').dialog('open');
				var subarea = gc.config.subareas[sub_id];
				var container				= document.getElementById('add_data_div');
				var div		 				= document.createElement("div");
				container.innerHTML='';
				var html = '';
				html += '<input type="hidden" id="add_data_sub_id" name="add_data_sub_id" value="'+sub_id+'"/>';
				html += subarea['name']+'模块';
				html += '<table>';
				html += '<tr><td>命令:</td><td><input id="add_data_name" name="add_data_name" type="text"  size="20" value="@" maxlength="32"/></td></tr>';
				html += '<tr><td>作用:</td><td><textarea id="add_data_effect" name="add_data_effect" type="text" cols="24" rows="6" value=""></textarea></td></tr>'; 	
				html += '<tr><td>用法:</td><td><textarea id="add_data_method" name="add_data_method" type="text" cols="24" rows="6" value=""></textarea></td></tr>'; 	
				html += '</table>';
				div.innerHTML= html;
				container.appendChild(div);
			},
			open_modify_data:function(sub_id,id){
				var subarea = gc.config.subareas[sub_id];
				var data = gc.config.datas[sub_id][id];
				$('#modify_data_dialog').dialog('open');
				var container				= document.getElementById('modify_data_div');
				var div		 				= document.createElement("div");
				container.innerHTML='';
				var html = '';
				html += '<input type="hidden" id="modify_data_id" name="modify_data_id" value="'+data['id']+'"/>';
				html += subarea['name']+'模块';
				html += '<table>';
				html += '<tr><td>命令:</td><td><input id="modify_data_name" name="modify_data_name" type="text"  size="20" value="'+data['name']+'" maxlength="32"/></td></tr>';
				html += '<tr><td>作用:</td><td><textarea id="modify_data_effect" name="modify_data_effect" type="text" cols="24" rows="6"  value="'+data['effect']+'">'+data['effect']+'</textarea></td></tr>'; 	
				html += '<tr><td>用法:</td><td><textarea id="modify_data_method" name="modify_data_method" type="text" cols="24" rows="6"  value="'+data['method']+'">'+data['method']+'</textarea></td></tr>'; 	
				html += '</table>';	
				
				div.innerHTML= html;
				container.appendChild(div);
			}
		}
};