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
				  "-export([get/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str			= array();
	$erl_active			= array();
	foreach ($VALUE_ERL as $v)
	{
			$erl_active[] = "{{$v['active_id']},{$v['active_type']},{$v['date']},{$v['week']},{$v['time']},{$v['role_lv']},{$v['show']},{$v['in_host']}}";
	}
	$erl_str[] = "get()->\n\t[".implode(','."\n\t ", $erl_active)."].";
	$erl_str    = implode ( "\n", $erl_str );
// 	print_r($erl_str);echo"<br />\n";
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
/*if($FILE_PLIST)
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
		$data[$v['active_id']]=$data_sub;
	}

	$pl					 = new \plugins\ToPList($data);
	$xml_plist_data		 = $pl->xml();

	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_plist_data);
}

if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	$xml_str   = \funs\tools\data2xml($VALUE_XML,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
?>
*/
if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
	$xml       = array();
	foreach ($VALUE_XML as $v)
	{
		unset($v['#']['date']);
		unset($v['#']['week']);
		unset($v['#']['time']);
		$xml[] = $v;
	}
	$data 		= array();
	foreach ($VALUE as $v)
	{
		$data[$v['active_id']] = array('active_name'=>$v['active_name']);
	}
	
	$xml_str   = \funs\tools\data2xml($xml,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
	
	// echo $filename;
	if(file_exists(Dir_Data_Cp_Root))
	{
		$filename       = Dir_Data_Cp_Root.'game_id.ini.php';
		$str		    = var_export($data,true);
		print_r($str);
		echo $filename,"<br />\n";
		file_put_contents($filename,'<?php '."\n\$GLOBALS['game_id'] = {$str};\n".'?>');
	}
}
	

?>
