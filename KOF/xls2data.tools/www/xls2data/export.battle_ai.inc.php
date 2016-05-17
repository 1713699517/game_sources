<?php

$val        = \funs\excel\parser_array($sheets);

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
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
			}
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		$erl_str[] = "get({$v['ai_id']})->\n\t#d_battle_ai{\n".$s ."\t}";
	}
	
	$erl_str[] = "get(_)->?null.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
	$xml       = array();
	foreach ($VALUE_XML as $v)
	{
		// [{101,600,{100,200,200}},{106,200,{100,200,200}},{111,400,{100,200,200}}]
		// <skill id="133" weight="600" width="100" range="200" height="200"/>
		$v['attack_skill']  = \funs\comm\decode_yrl($v['attack_skill'], '/\{(\d*),(\d*),(\d*),(\d*),\{(\d*),(\d*),(\d*)\}\}/', 'id,id2,id3,odds,x,y,z', true);
		// [{101,600,{100,200,200}},{106,200,{100,200,200} }]
		// <get_up_skill id="135" weight="600" width="100" range="200" height="200"/>
		$v['get_up_skill']  = \funs\comm\decode_yrl($v['get_up_skill'], '/\{(\d*),(\d*),(\d*),(\d*),\{(\d*),(\d*),(\d*)\}\}/', 'id,id2,id3,odds,x,y,z', true);
        print_r($v['special_area']);
		$v['special_area']  = \funs\comm\decode_yrl($v['special_area'], '/\{(\d*),(\d*),(\d*),(\d*),(\d*)\}/', 'x,y,w,h,ti', true);
        $v['rand_type']     = \funs\comm\decode_yrl($v['rand_type'], '/(\d*),(\d*),(\d*),(\d*)/', 'r1,r2,r3,r4', true);
        $xy="[".$v['rand_x'].",".$v['rand_y']."]";
        $v['rand_zuo']     = \funs\comm\decode_yrl($xy, '/(\d*),(\d*)/', 'x,y', true);
		if(!$v['attack_skill']) unset($v['attack_skill']);
		if(!$v['get_up_skill']) unset($v['get_up_skill']);
		if(!$v['special_area']) unset($v['special_area']);
        if(!$v['rand_type'])    unset($v['rand_type']);
        unset($v['rand_x']);
        unset($v['rand_y']);
		$xml[] = $v;
	}
	$xml_str   = \funs\tools\data2xml($xml,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
// 	$data    = array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data[$v['goods_id']]=$v;
// 	}
	
// // 	$pl					 = new \plugins\ToPList($data);
// // 	$xml_plist_data		 = $pl->xml();
	
// // 	echo $file_name,"<br />\n";
// // 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, $data);
// }
?>