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


// if($FILE_ERL)
// {
// 	$file_name  = $export_dir_erl.$FILE_ERL;
// 	$str_head   = "-module(data_{$KEY}).\n".
// 				  "-include(\"../include/comm.hrl\").\n\n".
// 				  "-export([get/2,get_ids/0]).\n\n".
// 				  "% ".implode(";\n% ",$REM). "\n";
	
// $lvs		= array();
// $erl_str    = array();
// 	foreach ($VALUE_ERL as $v )
// 	 {
// 		$s = "";
// 		foreach ( $v as $k2 => $v2 ) 
// 		{
// 			if ($PLIST[$k2] != 'no' && ! is_array($v2) )
// 			{
// 				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
				
// 			}
// // 			$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
// 			// print_r($s);
// 		}
// 		print_r($s);
// 		$s .= "\t\t%% 属性#attr{} \n";
// 		print_r($s);
// 		$s .= "\t\tattr = #attr{".\funs\tools\data2record ( $v ['a'] )."}\n";
// 		$erl_str[] = "get({$v['hidden_layer_id']},{$v['open_lv']})->\n\t#d_hidden_treasure{\n".$s ."\t}";
// 	 }
		
		
// 		$idx = strrpos($s,',');
// 		$s   = substr($s,0,$idx).substr($s,$idx+1);
// 		$lvs[$v['hidden_layer_id']] = $v['hidden_layer_id'];
// 	$erl_str[] = "get(_,_)-> ?null.\n\n\n%% 集合";
// 	$erl_str[]  = "get_ids()->[".implode(',', $lvs)."].\n\n";
	
// 	$erl_str    = implode(";\n",$erl_str);
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$str_head.$erl_str);
// }
// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;
// 	// 	$data    = array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data[$v['hidden_layer_id'].'_'.$v['open_lv']]=$v;
// 	}

// 	// 	$pl					 = new \plugins\ToPList($data);
// 	// 	$xml_plist_data		 = $pl->xml();

// 	// 	echo $file_name,"<br />\n";
// 	// 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, $data);
// }

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