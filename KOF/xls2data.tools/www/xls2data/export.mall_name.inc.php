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

$mall   = array();


foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$mall[$v['mall_id']]	= $v;
	}
}

// 写入PHP数据
\funs\tools\php_data_write('mall','name',$mall);

if($FILE_XML)
{
	$file_name  = $export_dir_realxml.$FILE_XML;
	$xml_str   = \funs\tools\data2xml($VALUE_XML, $KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}

// if($FILE_XML)
// {
// 	$file_name  		 = $export_dir_realxml.$FILE_XML;
// 	//print_r($VALUE_XML);
// 	$xml       = array();
// 	foreach ($VALUE_XML as $v)
// 	{
// 		$v['#']['id'] = $v['#']['lv'].'_'.$v['#']['color'].'_'.$v['#']['typesub'].'_'.$v['#']['class'];
// 		$xml[] = $v;
// 	}
// 	$xml_str   = \funs\tools\data2xml($xml,$KEY);
// 	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_str);
// }

?>

