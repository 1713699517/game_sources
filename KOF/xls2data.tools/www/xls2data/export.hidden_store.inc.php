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
				  "-export([get/1,get_ids/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
$lvs		= array();
$lvs2    = array();
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
		
		$erl_str[] = "get({$v['goods_id']})->\n\t#d_hidden_store{\n".$s ."\t};\n";
		
// 		$erl_str[] = "get({$v['type']},{$v['level']})->\n\t#d_copy_score{\n".$s ."\t};\n";
		$lvs[] = "{".$v['goods_id'].",".$v['appear_odds']."}";
		//$lvs2[$v['appear_odds']] = $v['appear_odds'];
		//print_r($lvs);
		
	}
	$erl_str[] = "get(_)-> ?null.\n\n\n%% 集合";
	//$erl_str[]  = "get_appear_odds()->[".implode(',',$lvs2)."].\n\n";
	$erl_str[]  = "get_ids()->[".implode(',', $lvs)."].\n\n";
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;


	// 	$data    = array();
	foreach ($VALUE_PLIST as $v)
	{
		$data[$v['goods_id']]=$v;
	}

	// 	$pl					 = new \plugins\ToPList($data);
	// 	$xml_plist_data		 = $pl->xml();

	// 	echo $file_name,"<br />\n";
	// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}

if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
	$xml_str   = \funs\tools\data2xml($VALUE_XML, $KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
?>