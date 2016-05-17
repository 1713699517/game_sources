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
				  "-export([chap/1,get/1]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$chap_list  = array();
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		$chap_list[$v['chap']][$v['id']] = $v['id'];
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		
		$erl_str[] = "get({$v['id']})->\n\t#d_circle{\n".$s ."\t};\n"; 	
	}
	$erl_str[] = "get(_)->?null.\n\n";
	
	$erl_str[] = "% chap(ChapID)->[Ids,..]\n";
	foreach ($chap_list as $k=>$v)
	{
		$erl_str[] = "chap({$k})->[".implode(',', $v)."];\n"; 
	}
	$erl_str[]  ="chap(_)->[].\n\n";
	
	$erl_str    = implode("\n",$erl_str);
	
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
// 		$v['id']
		$data[$v['chap']]=$data_sub;
	}

// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();

// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}
?>