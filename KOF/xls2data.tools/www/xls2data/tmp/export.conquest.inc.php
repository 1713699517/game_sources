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
	
	$erl_str    	= array();
	$arena_reward  	= array();
	foreach ($VALUE_ERL as $v)
	{
		$arena_reward[] = "{{$v['ranking_max']},{$v['ranking_min']},{$v['goods']}}";
	}
	
	$erl_str[] = "get()->\n\t[".implode(','."\n\t ", $arena_reward)."].";
	$erl_str    = implode ( "\n", $erl_str );
// 	print_r($erl_str);echo"<br />\n";
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;


// 	$data    = array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data_sub		= array();
// 		foreach ($v as $k2=>$v2)
// 		{
// 			if($PLIST[$k2] != 'no' && $k2 != 'ranking_max' && $k2 != 'ranking_min')
// 			{
// 				$data_sub[$k2] = $v2;
// 			}
// 		}
// // 				print_r($data_sub);echo "<br />\n";
// 		$data[$v['ranking_max'].'_'.$v['ranking_min']]=$data_sub;
// 	}

// // 	$pl					 = new \plugins\ToPList($data);
// // 	$xml_plist_data		 = $pl->xml();

// // 	echo $file_name,"<br />\n";
// // 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, $data);
// }
?>