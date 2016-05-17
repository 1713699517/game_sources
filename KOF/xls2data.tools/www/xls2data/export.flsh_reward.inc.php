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
	
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		
		$erl_str[] = "get({$v['sz_num']},{$v['same_num']},{$v['dz_num']})->\n\t#d_flsh_reward{\n".$s ."\t};\n"; 	
	}
	$erl_str[] = "get(_,_,_)->\n\t?null.\n";
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	$_data_xml			 = array();
	//print_r($VALUE_XML[0]);
	foreach ($VALUE_XML as $v)
	{
		$sz_num = $v['#']['sz_num'];
		$same_num = $v['#']['same_num'];
		$dz_num = $v['#']['dz_num'];
		unset($v['#']['sz_num']);
		unset($v['#']['same_num']);
		unset($v['#']['dz_num']);
		$key = $sz_num . '_' . $same_num . '_' . $dz_num;
		$_data_xml[$key]['#']['reward_name'] = $v['#']['reward_name'];
		$_data_xml[$key]['#']['money'] = $v['#']['money'];
		$_data_xml[$key]['#']['renown'] = $v['#']['renown'];
		$_data_xml[$key]['#']['id'] = $key;
	}
	$_data_xml2[]	= array();
	foreach ($_data_xml as $v)
	{
		$_data_xml2[] = $v;
	}
	$_data_xml3 = array($KEY=>$_data_xml2);
	$xml_str   = \funs\tools\data2xml($_data_xml3,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
?>