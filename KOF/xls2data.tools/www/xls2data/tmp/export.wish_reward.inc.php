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

// print_r($ERL);



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
			if($ERL[$k2] != 'no')
			{
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
			}
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		
		$erl_str[] = "get({$v['type']})->\n\t#data_wish_reward{\n".$s ."\t}";
	}
	$erl_str[] = "get(_)-> ?null.\n\n\n%% ";
	
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
		$data_sub		= array();
		foreach ($v as $k2=>$v2)
		{
			if($PLIST[$k2] != 'no')
			{
				$data_sub[$k2] = $v2;
			}
		}
// 		print_r($data_sub);echo "<br />\n";
		$data[$v['type']]=$data_sub;
	}
	
	\funs\tools\php_plist_write($file_name, $data);
}
?>