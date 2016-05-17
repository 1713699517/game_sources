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


if($FILE_PLIST)
{
	$file_name  = $export_dir_xml.$FILE_PLIST;


	$data    = array();
	foreach ($VALUE_PLIST as $v)
	{
		$data_sub		= array();
		foreach ($v as $k2=>$v2)
		{
// 			print_r($k2);echo "<br />\n";
// 			$data_sub[$k2] = $v2;
			if($PLIST[$k2] != 'no' && $k2 != 'face_id')
			{
				$data_sub[$k2] = $v2;
			}
		}
// 		print_r($data_sub);echo "<br />\n";
		$data[$v['face_id']]=$data_sub;
	}
	
	$pl					 = new \plugins\ToPList($data);
	$xml_plist_data		 = $pl->xml();

// 	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_plist_data);
}
?>