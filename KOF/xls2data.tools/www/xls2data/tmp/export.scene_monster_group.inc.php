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


$db					= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
$monster_group		= array();
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$group_id			    	= $v['group_id'];
		$monster_group[$group_id]   = $v;
		// --
		$bind['group_name']	= $v['group_name'];
		$bind['scene_id']  	= $v['scene_id'];
		$bind['lv']  		= $v['lv'];
		
		$bind['exts']	= $str_v;
		$rs = $db->rows('SELECT * FROM `map_monster_group` where group_id = ? ',(int)$group_id);
		if($rs)
		{
			$db->update('`map_monster_group`',$bind, ' `group_id` = ? ',(int)$group_id);
		}else
		{
			$bind['group_id']		= $group_id;
			$bind['head']			= 0;
			$bind['flop']			= '';
			$db->insert('`map_monster_group`',$bind);
		}
		echo $group_id,"\n .";
		//echo $db->getSql(),"\n";
	}
}
\funs\tools\php_data_write('scene',	'monster_group',  $monster_group);
echo '<br />';
?>