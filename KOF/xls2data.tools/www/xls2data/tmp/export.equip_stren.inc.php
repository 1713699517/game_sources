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
				  "-export([get/4]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			if($ERL[$k2] != 'no' && !is_array($v2))
			{
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
			}
		}
		$s .= "\t\t%% 属性#attr{} \n";
		$s .= "\t\tattr = #attr{".\funs\tools\data2record($v['attr'])."}\n";
		//$s .= "\t\t%% 属性#make2{} \n";
		//$s .= "\t\tmake2 = #d_make{".\funs\tools\data2record($v['make2'])."} \n";
		
		$erl_str[] = "get({$v['typesub']},{$v['lv']},{$v['color']},{$v['class']})->\n\t#d_equip_stren{\n".$s ."\t}";
	}
	
	$erl_str[] = "get(_,_,_,_)->?null.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
	$data    = array();
	foreach ($VALUE_PLIST as $v)
	{
		$data[$v['typesub'].'_'.$v['lv'].'_'.$v['color']]=$v;
	}
	
// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}
?>