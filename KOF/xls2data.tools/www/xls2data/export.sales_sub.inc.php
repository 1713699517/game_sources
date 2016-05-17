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



if($FILE_ERL)
{
	$file_name  = $export_dir_erl.$FILE_ERL;
	$str_head   = "-module(data_{$KEY}).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/1,get_ids/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$erl_str    = array();
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
		
		$erl_str[] = "get({$v['id_sub']})->\n\t#d_sales_sub{\n".$s ."\t}";
		$lvs[$v['id_sub']] = "{".$v['id'].",".$v['id_sub']."}";
	}
	$erl_str[] = "get(_)-> ?null.\n\n\n%% 集合";
	$erl_str[]  = "get_ids()->[".implode(',', $lvs)."].\n\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}

if($FILE_XML)
{
	$file_name  		 = $export_dir_realxml.$FILE_XML;
	//print_r($VALUE_XML);
//    $VALUE_XML2		     = array($KEY=>$VALUE_XML);
	$xml       = array();
	foreach ($VALUE_XML as $v)
	{
		// [{43001,1},{43101,1},{43201,1}]
		// <goods id="43001" count="1"/>
		$v['virtue']  = \funs\comm\decode_yrl($v['virtue'], '/\{(\d*),(\d*)\}/', 'id,count', true);
		if(!$v['virtue']) unset($v['virtue']);
		if(!$v['value']) unset($v['value']);
		$xml[] = $v;

	}
    $xml	   = array($KEY=>$xml);
	$xml_str   = \funs\tools\data2xml($xml,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}
$data2 = array();
if($VALUE)
{
    print_r($VALUE);
    foreach($VALUE as $v)
    {
        $data2[$v['id_sub']] = $v['desc_value'];
    }

}
if(file_exists(Dir_Data_Cp_Root))
{
    $filename       = Dir_Data_Cp_Root.'sales_sub.ini.php';
    $str		    = var_export($data2,true);
    file_put_contents($filename,'<?php '."\n\$GLOBALS['sales_sub']={$str};\n".'?>');
}

// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;


// 	$data    = array();
// 	$data2   = array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data[$v['id_sub']] =$v;
// 		$data2[$v['id_sub']]=$v['desc_value'];
// 	}

// 	// 	$pl					 = new \plugins\ToPList($data);
// 	// 	$xml_plist_data		 = $pl->xml();

// 	// 	echo $file_name,"<br />\n";
// 	// 	file_put_contents($file_name,$xml_plist_data);
// 	\funs\tools\php_plist_write($file_name, array('pc'=>$data));
	
	


?>