<?php

$val        = \funs\excel\parser_array($sheets);
 
//print_r($val);

$REM		= $val['rem'];
$KEY		= $val['key'];
$NAME		= $val['name'];

$FILE_PLIST = $val['file_plist'];
$FILE_ERL	= $val['file_erl'];
$FILE_XML	= $val['file_xml'];

$PLIST		= $val['plist'];
$ERL		= $val['erl'];
$XML		= $val['xml'];

$VALUE			= $val['value'];
$VALUE_PLIST	= $val['value_plist'];
$VALUE_ERL		= $val['value_erl'];
$VALUE_XML		= $val['value_xml'];


$db				= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
$material		= array();
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$material_id			= $v['material_id'];
		$material[$material_id] = $v;
		// --
		$bind['material_name']	= $v['material_name'];
		$bind['material_type']  = (int)$v['material_type'];
		$bind['move_y']  		= (int)$v['move_y'];
		$bind['excess_bottom']  = (int)$v['excess_bottom'];
		
		$bind['scale']  		= (int)$v['scale'];
		
		$bind['background']		= (int)$v['background'];
		$bind['foreground']		= (int)$v['foreground'];
		$bind['war_pos']		= serialize($v['war']);
			
		$bind['ext']			= $str_v;
		$rs = $db->rows('SELECT * FROM `map_material` where material_id = ? ',(int)$material_id);
		if($rs)
		{
			$db->update('`map_material`',$bind, ' `material_id` = ? ',(int)$material_id);
		}else
		{
			$bind['material_id']	= $material_id;
			$bind['mapxx']			= '';
			$bind['weight']			= 0;
			$bind['height']			= 0;
			$bind['state']			= 0;
			$db->insert('`map_material`',$bind);
		}
		echo $material_id,"\n .";
		//echo $db->getSql(),"\n";
	}
}
\funs\tools\php_data_write('scene',	'material',  $material);
echo '<br />';
?>