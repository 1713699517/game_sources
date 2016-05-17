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
				  "-export([get/1,get_ids/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	$total_ids 	= array();
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
		
		$erl_str[] = "get({$v['id']})->\n\t#d_sales_total{\n".$s ."\t}";
		$total_ids[$v['id']] = $v['id'];
	}
	$erl_str[] = "get(_)-> ?null.\n\n\n%% 集合";
	$erl_str[]  = "get_ids()->[".implode(',', $total_ids)."].\n\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}

if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
	$xml_str   = \funs\tools\data2xml($VALUE_XML,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}

 if($FILE_PLIST)
 {
 	$file_name  = $export_dir_xml.$FILE_PLIST;


 	$data    	= array();
 	foreach ($VALUE_PLIST as $v)
 	{
 		$data[]			  = $v;
 	}

 	$data2	    = array();
 	foreach ($VALUE as $v)
 	{
 		$data2[$v['id']]  = array('tag'=>$v['tag'],'time'=>$v['time']);
 	}

 	// 	$pl					 = new \plugins\ToPList($data);
 	// 	$xml_plist_data		 = $pl->xml();

 	// 	echo $file_name,"<br />\n";
 	// 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, array('pc'=>$data));

 	if(file_exists(Dir_Data_Cp_Root))
 	{
 		$filename       = Dir_Data_Cp_Root.'sales_id.ini.php';
 		$str		    = var_export($data2,true);
 		file_put_contents($filename,'<?php '."\n\$GLOBALS['sales_id']={$str};\n".'?>');
 	}
 }
?>