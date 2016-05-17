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
				  "-export([attr_base/1]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
	
		$erl_str[] = "attr_base({$v['type_sub_id']})->{$v['attr_base']}";
	}
	
	$erl_str[]	= "attr_base(_)->0.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
//if($FILE_XML)
//{
//	$file_name  		 = $export_dir_realxml.$FILE_XML;
//	$_data_xml			 = array();
//	foreach ($VALUE_XML as $v)
//	{
//		$id	= $v['#']['id'];
//		$v['#']['base'] = $v['base'];
//		unset($v['#']['id']);
//		$_data_xml[$id]['sub_id'][] = array('#'=>$v['#']);
//		$_data_xml[$id]['#']['name'] 	= $v['name'];
//		$_data_xml[$id]['#']['id']		= $id;
//	}
//	$_data_xml2[]	= array();
//	foreach ($_data_xml as $v)
//	{
//		$_data_xml2[] = $v;
//	}
//	//print_r($VALUE_XML);
//	$xml_str   = \funs\tools\data2xml($_data_xml2,$KEY);
//	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
//	echo $file_name,"<br />\n";
//	file_put_contents($file_name,$xml_str);
//}
if($FILE_PLIST)
{
	$file_name  		 = $export_dir_xml.$FILE_PLIST;
	
	$data_type    	 	 = array();
	$data_type_sub   	 = array();
	$data_type_sub_php   = array();
	$data_attr_base  	 = array();
	foreach ($VALUE_PLIST as $v)
	{
		//echo $v['type_name'],$data_type[$v['type_id']],'<br />';
		if( $data_type[$v['type_id']] 
				&& $v['type_name'] != $data_type[$v['type_id']] )
		{
			if( strpos($data_type[$v['type_id']], '(') === false )
			{
				$data_type[$v['type_id']]				="{$data_type[$v['type_id']]}({$v['type_name']})";
			}
		}else
		{
			$data_type[$v['type_id']]				=$v['type_name'];
		}
		
		$data_type_sub[$v['type_sub_id']]		=$v['type_sub_name'];
		$data_type_sub_php[$v['type_id']][$v['type_sub_id']]=$v['type_sub_name'];
		$data_attr_base[$v['type_sub_id']]		=$v['attr_base'];
	}
	$data   = array(
						'type' 		=> $data_type,
						'type_sub'  => $data_type_sub,
						'attr_base' => $data_attr_base,
					);
// 	$pl		= new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}
//var_dump($data_type); 
// 写入PHP数据
\funs\tools\php_data_write('goods','goods_category_type',	 $data_type);
\funs\tools\php_data_write('goods','goods_category_type_sub',$data_type_sub_php);
?>