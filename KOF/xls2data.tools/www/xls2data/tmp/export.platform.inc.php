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

//print_r($ERL);

if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;
	
	
	$data    = array();
	// print_r($VALUE_PLIST);
	
	foreach ($VALUE_PLIST as $v)
	{
		$data[$v['cid']]['cid']=$v['cid'];
		$data[$v['cid']]['platform']=$v['platform'];
		$data[$v['cid']]['source'][]=array(
					'source'  => $v['source'],
					'explain' => $v['explain'],
					'all' 	  => $v['all'],
				);
	}
	
	$data  = array('p'=>array_values($data));
	
// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
	\funs\tools\php_plist_write($file_name, $data);
}
?>