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


$table_name		= '`material_effect_skill`';
$db				= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);

$data			= $db->dataArray("select * from {$table_name} ");
$material_sbg	= array();
foreach ($data as $v)
{
	$material_sbg[$v['effect_id']] = (int)$v['sound_id'];
}
 
// ------------------------------------------
$db->conn("TRUNCATE {$table_name};");
$ids			= array();
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$bind['effect_id']		= $v['effect_id'];
		// --
		$bind['effect_name']	= $v['effect_name'];
		$bind['sound_id']  		= (int)$material_sbg[$v['effect_id']];
		$bind['type_id']  		= $v['type_id'];
		$bind['ext']			= $str_v;
		
		$db->insert($table_name,$bind);
		echo $bind['effect_id'],"\n .";
		//echo $db->getSql(),"\n";
	}
}
//\funs\tools\php_data_write('scene',	'material',  $material);
echo '<br />';
?>