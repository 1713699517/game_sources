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


$db				= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
$partner		= array();
$data2			= array();
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$partner_id		    	= $v['partner_id'];
		$partner[$partner_id]   = $v;
		// --
		$bind['partner_name']	= $v['partner_name'];
		$bind['exts']			= $str_v;
		// --
		$data2[$partner_id]		= $v['partner_name'];
		
		$rs = $db->rows('SELECT * FROM `partner` where `partner_id` = ? ',(int)$partner_id);
		if($rs)
		{
			$db->update('`partner`',$bind, ' `partner_id` = ? ',(int)$partner_id);
		}else
		{
			$bind['partner_id']		= $v['partner_id'];
			$bind['skin']	    	= 0;
			$bind['head']			= 0;
			$bind['effect_out']		= 0;
			$bind['effect_by']		= 0;
			$bind['effect_screen']	= 0;
			$db->insert('`partner`',$bind);
		}
		echo $partner_id,"\n .";
		//echo $db->getSql(),"\n";
	}
	
	
}
if(file_exists(Dir_Data_Cp_Root))
{
	$filename       = Dir_Data_Cp_Root.'partner.ini.php';
	$str		    = var_export($data2,true);
	file_put_contents($filename,'<?php '."\n\$GLOBALS['partner']={$str};\n".'?>');
}

\funs\tools\php_data_write('partner',	'list',  	 $partner);
\funs\tools\php_data_write('partner',	'list_erl',  $ERL);
\funs\tools\php_data_write('partner',	'list_plist',$PLIST);
\funs\tools\php_data_write('partner',	'list_rem',  $REM);
\funs\tools\php_data_write('partner',	'list_name', $NAME);
echo '<br />';
// exit();

// if($FILE_ERL)
// {
// 	$file_name  = $export_dir_erl.$FILE_ERL;
// 	$str_head   = "-module(data_{$KEY}).\n".
// 				  "-include(\"../include/comm.hrl\").\n\n".
// 				  "-export([get/1]).\n\n".
// 				  "% ".implode(";\n% ",$REM). "\n";
	
// 	$erl_str    = array();
	
// 	foreach ($VALUE_ERL as $v)
// 	{
// 		$s = "";
// 		foreach ($v as $k2=>$v2)
// 		{
// 			if($ERL[$k2] != 'no' && !is_array($v2))
// 			{
// 				$s .="\t\t".str_pad(str_pad("{$k2}",12)." = {$v2},",32)."%% ".$NAME[$k2]."\n";
// 			}
// 		}
// 		$s .= "\t\t%% 属性#attr{} \n";
// 		$s .= "\t\tattr = #attr{".\funs\tools\data2record($v['a'])."} \n";
// 		// $idx = strrpos($s,',');
// 		// $s   = substr($s,0,$idx).substr($s,$idx+1);
		
// 		$erl_str[] = "get({$v['partner_id']})->\n\t#d_partner{\n".$s ."\t}";
// 	}
	
// 	$erl_str[] = "get(_)->?null.\n";
	
// 	$erl_str    = implode(";\n",$erl_str);
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$str_head.$erl_str);
// }
// if($FILE_PLIST)
// {
// 	$file_name  = $export_dir_xml.$FILE_PLIST;
// 	$data    	= array();
// 	foreach ($VALUE_PLIST as $v)
// 	{
// 		$data_sub		= array();
// 		foreach ($v as $k2=>$v2)
// 		{
// 			if($PLIST[$k2] != 'no')
// 			{
// 				$data_sub[$k2] = $v2;
// 			}
// 		}
// 		$data[$v['partner_id']]=$data_sub;
// 	}
	
// 	$pl					 = new \plugins\ToPList($data);
// 	$xml_plist_data		 = $pl->xml();
	
// 	echo $file_name,"<br />\n";
// 	file_put_contents($file_name,$xml_plist_data);
//  \funs\tools\php_plist_write($file_name, $data);
// }
?>