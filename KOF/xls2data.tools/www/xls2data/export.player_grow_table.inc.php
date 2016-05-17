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

function rate($rate)
{
	$rs = "case Rate of ";
	foreach ($rate as $k=>$v)
	{
		$rs .= " {$k}->{$v};";
	}
	$rs .= " _->0 end";
	return $rs;
}

if($FILE_ERL)
{
	$file_name  = $export_dir_erl.$FILE_ERL;
	$str_head   = "-module(data_{$KEY}).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/3]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    	= array();
	$erl_str_level	= array();
	$erl_str_rate	= array();
	foreach ($VALUE_ERL as $v)
	{
		$erl_str[] = "get({$v['table']},{$v['level']},Rate)->".rate($v['rate']).";";
		
// 		$erl_str[$v['table']] 					 = "get({$v['table']},Level,Rate)->get_{$v['table']}(Level,Rate);";
// 		$erl_str_level[$v['table']][$v['level']] = "get_{$v['table']}({$v['level']},Rate)->get_{$v['table']}_{$v['level']}(Rate);";
// 		foreach ($v['rate'] as $k2=>$v2)
// 		{
// 			$erl_str_rate["{$v['table']}_{$v['level']}"][$k2]   = "get_{$v['table']}_{$v['level']}({$k2})->{$v2};";
// 		}
	}
	$erl_str[] = "get(_,_,_)->0.\n\n";
	// ---------------
// 	$erl_str_level2 = array();
// 	foreach ($erl_str_level as $k=>$v)
// 	{
// 		$erl_str_level2[] = implode("\n",$v)."\nget_{$k}(_,_)->0.\n";
// 	}
// 	$erl_str[] = implode("\n",$erl_str_level2);
// 	// ---------------
// 	$erl_str_rate2 = array();
// 	foreach ($erl_str_rate as $k=>$v)
// 	{
// 		$erl_str_rate2[] = implode("\n",$v)."\nget_{$k}(_)->0.\n";
// 	}
// 	$erl_str[] = implode("\n",$erl_str_rate2);
	
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
?>