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

print_r($ERL);


if($FILE_ERL)
{
	$file_name  = $export_dir_erl.$FILE_ERL;
	$str_head   = "-module(data_{$KEY}).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str			= array();
	$erl_funs			= array();
	foreach ($VALUE_ERL as $v)
	{
			$erl_funs[] = "{{$v['fun_id']},{$v['type']}}";
	}
	$erl_str[] = "get()->\n\t[".implode(','."\n\t ", $erl_funs)."].";
	$erl_str    = implode ( "\n", $erl_str );
// 	print_r($erl_str);echo"<br />\n";
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}

//if($FILE_XML)
//{
//    $file_name  		 = $export_dir_realxml.$FILE_XML;
//    //print_r($VALUE_XML);
//    $xml       = array();
//    foreach ($VALUE_XML as $v)
//    {
//        $xml[] = $v;
//    }
//    $data 		= array();
//    foreach ($VALUE as $v)
//    {
//        $data[$v['fun_id']] = array('fun_name'=>$v['fun_name'],'type' =>$v['type']);
//    }
//
//    $xml_str   = \funs\tools\data2xml($xml,$KEY);
//    $xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
//    echo $file_name,"<br />\n";
//    file_put_contents($file_name,$xml_str);
//
//    // echo $filename;
//    if(file_exists(Dir_Data_Cp_Root))
//    {
//        $filename       = Dir_Data_Cp_Root.'is_funs.ini.php';
//        $str		    = var_export($data,true);
//        print_r($str);
//        echo $filename,"<br />\n";
//        file_put_contents($filename,'<?php '."\n\$GLOBALS['fun_id'] = {$str};\n".'?>');
//    }
//}

?>