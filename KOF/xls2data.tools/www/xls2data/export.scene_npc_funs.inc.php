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
$npc_funs		= array();
foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$funs_id		    	= $v['funs_id'];
		$npc_funs[$funs_id]   	= $v;
	}
	echo $funs_id,"\n .";
}
\funs\tools\php_data_write('scene',	'npc_funs',  $npc_funs);
echo '<br />';
?>