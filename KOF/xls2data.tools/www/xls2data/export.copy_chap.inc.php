<?php

$val        = \funs\excel\parser_array($sheets);
 
// print_r($val);

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
				  "-export([get/2,gets_normal/0,gets_hero/0,gets_fiend/0,gets_fighters/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$list_normal	= array();
	$list_hero		= array();
	$list_fiend		= array();
	$list_fighters	= array();
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		switch ($v['type'])
		{
			case 1:
				$list_normal[$v['chap_id']] = $v['chap_id'];
				break;
			case 2:
				$list_hero[$v['chap_id']] = $v['chap_id'];
				break;
			case 3:
				$list_fiend[$v['chap_id']] = $v['chap_id'];
				break;
			case 4:
				$list_fighters[$v['chap_id']] = $v['chap_id'];
				break;
			default:
				;
		}
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			if ($PLIST[$k2] != 'no' && ! is_array($v2) )
			{
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
			}
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		
		$erl_str[] = "get({$v['type']},{$v['chap_id']})->\n\t#d_copy_chap{\n".$s ."\t};\n"; 	
	}
	$erl_str[] = "get(_,_)->\n\t?null.\n";
	
	
	$erl_str[] = "% gets_normal()->[ChapId,..]\n";
	
	$erl_str[] = "gets_normal()->[".implode(',', array_keys($list_normal))."].\n";
	
	$erl_str[] = "% gets_hero()->[ChapId,..]\n";
	
	$erl_str[] = "gets_hero()->[".implode(',', array_keys($list_hero))."].\n";
	
	$erl_str[] = "% gets_fiend()->[ChapId,..]\n";
	
	$erl_str[] = "gets_fiend()->[".implode(',', array_keys($list_fiend))."].\n";
	
	$erl_str[] = "% gets_fighters()->[ChapId,..]\n";
	
	$erl_str[] = "gets_fighters()->[".implode(',', array_keys($list_fighters))."].\n";
	
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}


if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	$_data_xml			 = array();
	//echo "haha</br>";
	//print_r($VALUE_XML[0]);
	foreach ($VALUE_XML as $v)
	{
		//print_r($v);
		//echo "</br>";
		$type = $v['#']['type'];
		$chap_id = $v['#']['chap_id'];
		$key = $type . '_' . $chap_id;
		$_data_xml[$key]['#']['id'] = $key;
		$_data_xml[$key]['#']['type'] = $v['#']['type'];
		$_data_xml[$key]['#']['chap_id'] = $v['#']['chap_id'];
		$_data_xml[$key]['#']['chap_name'] = $v['#']['chap_name'];
		$_data_xml[$key]['cids']['cid'] = \funs\comm\decode_yrl($v['#']['copy_id'], '/(\d*)/', 'id', true);
		$_data_xml[$key]['#']['per_chap_id'] = $v['#']['pre_chap_id'];
		$_data_xml[$key]['#']['next_chap_id'] = $v['#']['next_chap_id'];
		$_data_xml[$key]['#']['reset_rmb'] = $v['#']['reset_rmb'];
		$_data_xml[$key]['#']['chap_lv'] = $v['#']['chap_lv'];
		$_data_xml[$key]['rewards']['reward']  = \funs\comm\decode_yrl($v['#']['chap_reward'], '/\{(\d*),(\d*)\}/', 'goods_id,goods_count', true);
	}
	//print_r($_data_xml);
 	$_data_xml2	= array();
	foreach ($_data_xml as $v)
	{

		$_data_xml2[] = $v;
	}
	$xml_str   = \funs\tools\data2xml2($_data_xml2,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
?>