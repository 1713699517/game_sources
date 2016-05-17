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
$data_cp        = array();
//print_r($ERL);
foreach ($VALUE as $v)
{
    $data_cp[$v['gas_id']] = array
    (
        'id' => $v['gas_id'],
        'name'=> $v['gas_name']
    );
//    print_r($data_cp);
}

if($FILE_ERL)
{
	$file_name  = $export_dir_erl.$FILE_ERL;
	$str_head   = "-module(data_{$KEY}).\n".
				  "-include(\"../include/comm.hrl\").\n\n".
				  "-export([get/1]).\n\n".
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


  		
		$erl_str[] = "get({{$v['gas_id']},{$v['lv']}})->\n\t#d_fight_gas_total{\n".$s ."\t}";
	}
	
	$erl_str[] = "get(_)->?null.\n";
	
	$erl_str    = implode(";\n",$erl_str);
	
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
// 		$v['id']
		$data[$v['gas_id'],$v['lv']]=$data_sub;
	}

	$pl					 = new \plugins\ToPList($data);
	$xml_plist_data		 = $pl->xml();

	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_plist_data);
}
*/

if($FILE_XML)
{
	$file_name = $export_dir_realxml.$FILE_XML;
	$xml_str   = \funs\tools\data2xml($VALUE_XML,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}

if(file_exists(Dir_Data_Cp_Root))
{
    $filename       = Dir_Data_Cp_Root.'gas.ini.php';
    $str		    = var_export($data_cp,true);
    file_put_contents($filename,'<?php '."\n\$GLOBALS['gas']={$str};\n".'?>');
}

?>