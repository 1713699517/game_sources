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


$country   = array();
$city      = array();
$city2     = array();
foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$country[$v['country_id']] 				= $v['country_name'];
		$city[$v['country_id']][$v['city_id']] 	= $v['city_name'];
		$city2[$v['city_id']] 					= $v['city_name'];
	}
}
// 写入PHP数据
\funs\tools\php_data_write('scene','country',	 $country);
\funs\tools\php_data_write('scene','city', 		 $city);
\funs\tools\php_data_write('scene','city2', 	 $city2);
?>