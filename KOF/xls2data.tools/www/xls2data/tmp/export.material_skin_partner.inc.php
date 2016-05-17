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


$table_name		= '`material_skin_partner`';
$db				= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
$db->conn("TRUNCATE {$table_name};");
$material		= array();
foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		//$str_v  				= serialize($v);
		// --
		$bind['skin_id']		= $v['skin_id'];
		// --
		$bind['skin_name']		= $v['skin_name'];
		//$bind['material_id']  = $v['material_id'];
		
		$db->insert($table_name,$bind);
		echo $bind['skin_id'],"\n .";
		//echo $db->getSql(),"\n";
	}
}
//\funs\tools\php_data_write('scene',	'material',  $material);
echo '<br />';
?>