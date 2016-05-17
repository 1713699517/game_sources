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


if($FILE_ERL)
{
	$file_name  = $export_dir_erl.$FILE_ERL;
	$str_head   = "-module(data_{$KEY}).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/2]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		$v['activity_id'] = (int)$v['activity_id'];
		$v['activity_id'] = $v['activity_id'] == 0 ? '_':$v['activity_id'];
		$erl_str[] = "get({$v['goods_id']},{$v['activity_id']})-> {$v['state']} ;  %% {$v['msg']}"; 
	}
	$erl_str[] = "get(_,_)-> 1.\n";
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
?>