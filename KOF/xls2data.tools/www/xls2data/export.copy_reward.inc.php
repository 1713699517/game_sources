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
  			if($ERL[$k2] != 'no' && !is_array($v2))
  			{
  				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
  			}
  		}
  		$idx = strrpos($s,',');
  		$s   = substr($s,0,$idx).substr($s,$idx+1);
		$erl_str[]             = "get({$v['copy_id']})->\n\t#d_copy_reward{\n".$s ."\t}";
	}
	$erl_str[] = "get(_)->\n\t?null.\n";
	
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
		$data[$v['copy_id']]=$data_sub;
	}

	$pl					 = new \plugins\ToPList($data);
	$xml_plist_data		 = $pl->xml();

	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_plist_data);
}

if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
	$xml       = array();
	foreach ($VALUE_XML as $v)
	{
		
		$v['a_goods']['goods']  = \funs\comm\decode_yrl($v['#']['a_goods'], '/\{(\d*),(\d*),(\d*)\}/', 'goods_id,goods_count,goods_odds', true);
		$v['b_goods']['goods']  = \funs\comm\decode_yrl($v['#']['b_goods'], '/\{(\d*),(\d*),(\d*)\}/', 'goods_id,goods_count,goods_odds', true);
		$v['c_goods']['goods']  = \funs\comm\decode_yrl($v['#']['c_goods'], '/\{(\d*),(\d*),(\d*)\}/', 'goods_id,goods_count,goods_odds', true);
		unset($v['#']['a_goods']);
		unset($v['#']['b_goods']);
		unset($v['#']['c_goods']);
		$xml[] = $v;
	}
	$xml_str   = \funs\tools\data2xml2($xml,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
?>