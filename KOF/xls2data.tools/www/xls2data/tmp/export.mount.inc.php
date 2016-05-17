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
				  "-export([get/2]).\n\n".
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
  		
		$erl_str[]             = "get({$v['mount_id']},{$v['lv']})->\n\t#d_mount{\n".$s ."\t}";
		
	}
	
	$erl_str[] = "get(_,_)->\n\t?null.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
	
	
	
	
}
if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
	$data    = array();
	$data2   = array();
	foreach ($VALUE_PLIST as $v)
	{
		$data[$v['mount_id'] . '_' . $v['lv']] = $v;
		$data2[$v['mount_id']]                 = $v;
	}
	
// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
	
	if(file_exists(Dir_Data_Cp_Root))
	{
		// export.mount.inc.php
		$filename       = Dir_Data_Cp_Root.'mount.ini.php';
		$str		    = var_export($data2,true);
		file_put_contents($filename,'<?php '."\n\$GLOBALS['mount']={$str};\n".'?>');
	}
}
?>