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
				  "-export([get/1]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n".
				  "get(Sex)->\n".
				  "\tSurname = surname(),\n".
				  "\tcase Sex of\n".
				  "\t	?CONST_SEX_GG -> Name = name_gg();\n".
				  "\t	_			  -> Name = name_mm()\n".
				  "\tend,\n".	
				  "\t<<Surname/binary,Name/binary>>.\n\n";
	
	$data    = array();
	foreach ($VALUE_ERL as $v)
	{
		if($v['data'])
		{
			$data[$v['type']][] = $v['data'];
		}
	}
	
	$erl_str  = "surname()->\n\tutil:rand_list([<<\"".implode('">>,<<"', $data[0])."\">>]).\n";
	$erl_str .= "name_mm()->\n\tutil:rand_list([<<\"".implode('">>,<<"', $data[1])."\">>]).\n";
	$erl_str .= "name_gg()->\n\tutil:rand_list([<<\"".implode('">>,<<"', $data[2])."\">>]).\n";
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
?>