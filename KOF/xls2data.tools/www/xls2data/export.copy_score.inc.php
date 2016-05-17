<?php

$val        = \funs\excel\parser_array($sheets);
 
// print_r($val);

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
				  "-export([get/3,gets_unscatch/0,gets_time/0,gets_combo/0,gets_kill/0,gets_score/0]).\n\n".
				  "% ".implode(";\n% ",$REM). "\n";
	
	$list_unscatch	= array();
	$list_time		= array();
	$list_combo		= array();
	$list_kill		= array();
	$list_score		= array();
	$erl_str    = array();
	foreach ($VALUE_ERL as $v)
	{
		switch ($v['type'])
		{
			case 1:
				$list_unscatch[$v['level']] = $v['level'];
				break;
			case 2:
				$list_time[$v['level']] = $v['level'];
				break;
			case 3:
				$list_combo[$v['level']] = $v['level'];
				break;
			case 4:
				$list_kill[$v['level']] = $v['level'];
				break;
			case 5:
				echo $v['type'] . "_" . $v['level'] . "</br>";
				$list_score[$v['level']] = $v['level'];
				break;
			default:
				;
		}
		$s = "";
		foreach ($v as $k2=>$v2)
		{
			if ($PLIST[$k2] != 'no' && ! is_array($v2) )
			{
				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
			}
		}
		$idx = strrpos($s,',');
		$s   = substr($s,0,$idx).substr($s,$idx+1);
		
		$erl_str[] = "get({$v['id']},{$v['type']},{$v['level']})->\n\t#d_copy_score{\n".$s ."\t};\n"; 	
	}
	$erl_str[] = "get(_,_,_)->\n\t?null.\n";
	
	
	$erl_str[] = "% gets_unscatch()->[Level,..]\n";
	
	$erl_str[] = "gets_unscatch()->[".implode(',', array_keys($list_unscatch))."].\n";
	
	$erl_str[] = "% gets_time()->[Level,..]\n";
	
	$erl_str[] = "gets_time()->[".implode(',', array_keys($list_time))."].\n";
	
	$erl_str[] = "% gets_combo()->[Level,..]\n";
	
	$erl_str[] = "gets_combo()->[".implode(',', array_keys($list_combo))."].\n";
	
	$erl_str[] = "% gets_kill()->[Level,..]\n";
	
	$erl_str[] = "gets_kill()->[".implode(',', array_keys($list_kill))."].\n";
	
	$erl_str[] = "% gets_score()->[Level,..]\n";
	
	$erl_str[] = "gets_score()->[".implode(',', array_keys($list_score))."].\n";
	
	
	$erl_str    = implode("\n",$erl_str);
	
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$str_head.$erl_str);
}
?>