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
				  "-export([get/3]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
// 	$erl_str    = array();
	$erl_str2   = array();
	foreach ($VALUE_ERL as $v)
	{
		$e         = $v['e'];
// 		$erl_str[] = "get({$v['suit_id']})->[{{$e['2']['count']},{$e['2']['effect']}},".
// 											"{{$e['3']['count']},{$e['3']['effect']}},".
// 											"{{$e['4']['count']},{$e['4']['effect']}},".
// 											"{{$e['5']['count']},{$e['5']['effect']}},".
// 											"{{$e['6']['count']},{$e['6']['effect']}}];";
		$erl_str2[] = "get({$v['suit_id']},{$e['2']['count']},{$e['2']['lv']})->{$e['2']['effect']};";
		$erl_str2[] = "get({$v['suit_id']},{$e['3']['count']},{$e['3']['lv']})->{$e['3']['effect']};";
		$erl_str2[] = "get({$v['suit_id']},{$e['4']['count']},{$e['4']['lv']})->{$e['4']['effect']};";
		$erl_str2[] = "get({$v['suit_id']},{$e['5']['count']},{$e['5']['lv']})->{$e['5']['effect']};";
		$erl_str2[] = "get({$v['suit_id']},{$e['6']['count']},{$e['6']['lv']})->{$e['6']['effect']};";
	}
// 	$erl_str[]   = "get(_)->?null.\n";
	$erl_str2[]  = "get(_,_,_)->?null.\n";
	
// 	$erl_str     = implode("\n",$erl_str);
	$erl_str2    = implode("\n",$erl_str2);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str2);
}
if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
	$data    = array();
	foreach ($VALUE_PLIST as $v)
	{
		$e         			= $v['e'];
		$data[$v['suit_id']][$e['2']['count']][$e['2']['lv']]=$e['2']['remark'];
		$data[$v['suit_id']][$e['3']['count']][$e['3']['lv']]=$e['3']['remark'];
		$data[$v['suit_id']][$e['4']['count']][$e['4']['lv']]=$e['4']['remark'];
		$data[$v['suit_id']][$e['5']['count']][$e['5']['lv']]=$e['5']['remark'];
		$data[$v['suit_id']][$e['6']['count']][$e['6']['lv']]=$e['6']['remark'];
		
		$data[$v['suit_id']]['name']=$v['suit_name'];
	}
// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	print_r($data);
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}
?>