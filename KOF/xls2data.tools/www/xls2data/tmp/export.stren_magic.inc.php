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
	$str_head   = "-module(data_stren_magic).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/4]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    	= array();
	$erl_str_lv 	= array();
	$erl_str_color 	= array();
	$erl_str_typesub= array();
	
	$erl_str[]	= "% get(lv,color,typesub,class)->#d_{$KEY}{}.\n";
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
		
		//$erl_str[] = "get({$v['lv']},{$v['color']},{$v['typesub']},{$v['class']})->\n\t#d_equip_stren{\n".$s ."\t};";
		
		$erl_str[$v['lv']] 															= "get({$v['lv']},Color,TypeSub,Class)->get_{$v['lv']}(Color,TypeSub,Class);";
		$erl_str_lv[$v['lv']][$v['color']] 											= "get_{$v['lv']}({$v['color']},TypeSub,Class)->get_{$v['lv']}_{$v['color']}(TypeSub,Class);";
		$erl_str_color["{$v['lv']}_{$v['color']}"][$v['typesub']] 					= "get_{$v['lv']}_{$v['color']}({$v['typesub']},Class)->get_{$v['lv']}_{$v['color']}_{$v['typesub']}(Class);";
		$erl_str_typesub["{$v['lv']}_{$v['color']}_{$v['typesub']}"][$v['class']] 	= "get_{$v['lv']}_{$v['color']}_{$v['typesub']}({$v['class']})->\n\t#d_{$KEY}{\n".$s ."\t};";
	}
	$erl_str[] = "get(_,_,_,_)->?null.\n";
	// $erl_str_lv
	$erl_str2 = array();
	foreach ($erl_str_lv as $k=>$v)
	{
		$erl_str2[] = implode("\n",$v)."\nget_{$k}(_,_,_)->?null.\n";
	}
	$erl_str[] = implode("\n",$erl_str2);
	// $erl_str_color
	$erl_str2 = array();
	foreach ($erl_str_color as $k=>$v)
	{
		$erl_str2[] = implode("\n",$v)."\nget_{$k}(_,_)->?null.\n";
	}
	$erl_str[] = implode("\n",$erl_str2);
	//  $erl_str_typesub
	$erl_str2 = array();
	foreach ($erl_str_typesub as $k=>$v)
	{
		$erl_str2[] = implode("\n",$v)."\nget_{$k}(_)->?null.\n";
	}
	$erl_str[] = implode("\n",$erl_str2);
	// -------------------------------------------------------
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
// 	$data    = array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data[$v['color'].'_'.$v['lv'].'_'.$v['typesub'].'_'.$v['class']]=$v;
// 	}
	
// // 	$pl					 = new \plugins\ToPList($data);
// // 	$xml_plist_data		 = $pl->xml();
	
// // 	echo $file_name,"<br />\n";
// // 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, $data,20);
// }
?>