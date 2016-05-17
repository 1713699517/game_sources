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
				  "-export([get/1]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			if($ERL[$k2] != 'no' && !is_array($v2))
			{
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME['r.'.$k2]."\n";
			}
		}
		$s .= "\t\t%% 属性#attr{} \n";
		$s .= "\t\tattr = #attr{".\funs\tools\data2record($v['a'])."} \n";
		
		$erl_str[] = "get({$v['pro']})->\n\t#d_player_initial{\n".$s ."\t}";
	}
	
	$erl_str[] = "get(_)->?null.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	//print_r($erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
?>