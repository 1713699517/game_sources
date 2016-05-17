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
				  "-export([get/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	$erl_str2	= array();
	foreach ($VALUE_ERL as $v)
	{
		$begin    = 0 == $v['begin'] ? 0 : strtotime_c($v['begin']);
		$end      = 0 == $v['end']   ? 0 : strtotime_c($v['end']);
		$erl_str2[] = "\t { {$v['activity_id']} , {$begin}, {$end} }, %% {$v['msg']}  开始:{$v['begin']} 结束:{$v['end']} "; //  
	}
	
	$erl_str2 = implode("\n", $erl_str2);
	$idx      = strrpos($erl_str2,',');
	$erl_str2 = substr($erl_str2,0,$idx).' '.substr($erl_str2,$idx+1);
	
	$erl_str[] = "get()->\n[\n{$erl_str2}\n].\n";
	
	$erl_str   = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}

function strtotime_c($str)
{
	$time = strtotime($str);
	$str2 = date("Y-m-d H:i:s",$time);
	if ($str2 == $str)
	{
		return $time;
	}
	trigger_error($str." 时间格式有误 如:2013/2/2 8:4:9 或 2013-2-2 8:4:9  请写成:2013-02-02 08:04:09",E_USER_ERROR);
	return 0;
}
?>