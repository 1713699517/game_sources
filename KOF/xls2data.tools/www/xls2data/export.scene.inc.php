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


$db			= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
$scene		= array();
foreach ($VALUE as $v)
{

	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$scene_id				= $v['scene_id'];
		$scene[$scene_id] 		= $v;
		// --
		$bind['scene_name']		= $v['scene_name'];
		$bind['scene_type']  	= $v['scene_type'];

		$bind['copy_id']		= $v['copy_id'];
		$bind['material_id']	= $v['material_id'];
			
		
		$bind['lv']				= $v['lv'];
		
		$bind['ext_xls']		= $str_v;
		$rs = $db->rows('SELECT * FROM `map_scenes` where scene_id = ? ',(int)$scene_id);
		if($rs)
		{
			$db->update('`map_scenes`',$bind, ' `scene_id` = ? ',(int)$scene_id);
		}else
		{
			$bind['scene_id']	= $scene_id;
			$bind['city_id']	= 0;
			$bind['country_id']	= 0;
			$bind['ext_xml']	= '';
			$db->insert('`map_scenes`',$bind);
		}
		echo $scene_id,"\n .";
		//echo $db->getSql(),"\n";
	}
}
\funs\tools\php_data_write('scene',	'scene', 		 $scene);

echo '<br />';

?>