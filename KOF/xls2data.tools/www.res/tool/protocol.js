// JavaScript Document
var js_subarea_state_type;
var div_subarea;
function js_subarea(type,subarea_id)
{
	js_cancel();
	div_subarea  = window.document.getElementById('div_subarea');
	if(js_subarea_state_type == type+subarea_id){
		js_subarea_state_type = null;
		return;
	}
	js_subarea_state_type   = type+subarea_id;
	
	if('modify' == type){
		div_subarea.innerHTML 	= html_from_subarea[0]+html_from_subarea[2]+html_from_subarea[3];
		var from_subarea  		= window.document.getElementById('from_subarea');
		from_subarea['name'].value 		  	= subarea[subarea_id]['name'];
		from_subarea['subarea_keys'].value 	= subarea[subarea_id]['subarea_keys'];
		from_subarea['start'].value 		= subarea[subarea_id]['start'];
		from_subarea['end'].value 			= subarea[subarea_id]['end'];
		from_subarea['subarea_id'].value 	= subarea_id;
	}else{
		div_subarea.innerHTML 	= html_from_subarea[0]+html_from_subarea[1]+html_from_subarea[3];
		var from_subarea  		= window.document.getElementById('from_subarea');
		from_subarea['start'].value 		= pid_max+1;
		from_subarea['end'].value 			= pid_max+1000;
	}	
}
var js_protocol_state_type;
var div_protocol;
function js_protocol(type,subarea_id,protocol_id)
{
	js_cancel();
	div_protocol  = window.document.getElementById('div_protocol_'+subarea_id);
	if(js_protocol_state_type == type+subarea_id+protocol_id){
		js_protocol_state_type = null;
		return;
	}
	js_protocol_state_type	= type+subarea_id+protocol_id;	
	var html_header			= html_from_protocol[0]+subarea_id+html_from_protocol[1]+subarea_id+html_from_protocol[2]+subarea_id+html_from_protocol[3]+subarea_id+html_from_protocol[4];
	var html,field_ids=[];
	if('modify' == type){
		var data				= subarea[subarea_id]['protocols'][protocol_id];
		var fields				= data['fields'];
		html 					= [];
		for(var field_index in fields){
			html.push(js_fields(fields[field_index]));
			field_ids.push(fields[field_index]['id']);
		}
		html					= html.join('');
		field_ids				= field_ids.join(',');
		div_protocol.innerHTML 	= html_header+html+html_from_protocol[5]+subarea_id+html_from_protocol[6]+html_from_protocol[8]+html_from_protocol[9];
		var from_protocol  		= window.document.getElementById('from_protocol_'+subarea_id);
		from_protocol['name'].value 		= data['name'];
		from_protocol['main_keys'].value 	= data['main_keys'];
		from_protocol['pid'].value 			= data['pid'];
		from_protocol['pid_old'].value 		= data['pid'];
		from_protocol['ptype'].value 		= data['ptype'];
		from_protocol['isauto'].value 		= data['isauto'];
		from_protocol['ptype'].value 		= data['ptype'];
		from_protocol['callback_pid'].value = data['callback_pid'];
		from_protocol['callback_timeout'].value = data['callback_timeout'];
		from_protocol['fields'].value 		= field_ids;
		from_protocol['subarea_id'].value 	= subarea_id;
	}else{
		html 					= js_fields(null)+js_fields(null)+js_fields(null);
		div_protocol.innerHTML 	= html_header+html+html_from_protocol[5]+subarea_id+html_from_protocol[6]+html_from_protocol[7]+html_from_protocol[9];
		var from_protocol  		= window.document.getElementById('from_protocol_'+subarea_id);
		from_protocol['subarea_id'].value 	= subarea_id;
		from_protocol['callback_pid'].value = 0;
		from_protocol['callback_timeout'].value = 500;
	}	
	window.document.getElementById('span_protocol_'+subarea_id).innerHTML = '(从'+subarea[subarea_id]['start']+'-到'+subarea[subarea_id]['end']+')';
	//return true;
}
function js_cancel()
{
	if(div_protocol)
		div_protocol.innerHTML  = '';
	if(div_subarea)
		div_subarea.innerHTML 	= '';
	div_protocol = null;
	div_subarea  = null;
}
function js_protocol_add_fields(subarea_id)
{
	var div_protocol  = window.document.getElementById('div_fields_'+subarea_id);
	if(div_protocol){
		var fields    = document.createElement("div");
		fields.innerHTML		= js_fields2(null);
		div_protocol.appendChild(fields);
	}
}
function js_fields(field)
{
	return '<div>'+js_fields2(field)+'</div>';
}
function js_fields2(field)
{
	if(!field){
		field = {field:'',type:'int8u',explain:'','sort':0,option:'none',parent:'',group:''};
	}
	return  '字段:<input name="field[]"  value="'+field['field']+'" type="text" size="8" maxlength="32" />'+
	        '类型:<select name="type[]">'+
					(function(){
							  var rs = '',k,data=protocol_fields_data_type;
							  for(k in data){
								  rs += '<option value="'+k+'"  '+(k  == field['type']?'selected="selected"':'')+'>'+data[k][1]+'('+data[k][0]+')</option>'
							  }
							  return rs;
					})()+
				 '</select>'+
	        '备注:<input name="explain[]" value="'+field['explain']+'" type="text" size="12" maxlength="64" />'+
	        '排序:<input name="sort[]"    value="'+field['sort']+'"    type="text" size="2" maxlength="5" />'+
	        '选项:<select name="option[]" >'+
					'<option value="none"  '+('none'  == field['option']?'selected="selected"':'')+'>默认</option>'+
					'<option value="select"'+('select'== field['option']?'selected="selected"':'')+'>选择</option>'+
					'<option value="loop"  '+('loop'  == field['option']?'selected="selected"':'')+'>循环</option>'+
	             '</select> '+
	        '父级:<input name="parent[]" value="'+field['parent']+'" type="text" size="8" maxlength="32" />'+
	        '分组:<input name="group[]"  value="'+field['group']+'" type="text" value="0" size="2" maxlength="32" />';
}