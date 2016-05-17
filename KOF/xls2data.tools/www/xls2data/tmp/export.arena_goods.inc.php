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
	
	$erl_str    	  = array();
	$erl_arena_goods  = array();

	foreach ($VALUE_ERL as $v)
	{
		$erl_arena[] = "{{$v['rank_max']},{$v['rank_min']},{$v['lv_max']},{$v['lv_min']},{$v['give']}}";
	}
	
	$erl_str[] = "get()->\n\t[".implode(','."\n\t ", $erl_arena)."].";
	$erl_str    = implode ( "\n", $erl_str );
// 	print_r($erl_str);echo"<br />\n";
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}

if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;

	$data    = array();
	foreach ($VALUE_PLIST as $v)
	{
		$data_sub		= array();
		foreach ($v as $k2=>$v2)
		{
			if($PLIST[$k2] != 'no'&& $k2 != 'rank'&& $k2 != 'rank_max'&& $k2 != 'rank_min'&& $k2 != 'lv_max'&& $k2 != 'lv_min')
			{
				$data_sub[$k2] = $v2;
			}
		}
		// 		print_r($data_sub);echo "<br />\n";
		$data[$v['rank_max'].'_'.$v['rank_min'].'_'.$v['lv_max'].'_'.$v['lv_min']]=$data_sub;
	}
	
	\funs\tools\php_plist_write($file_name, $data);
}
?>