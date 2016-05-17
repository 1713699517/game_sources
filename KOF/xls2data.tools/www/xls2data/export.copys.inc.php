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

$db							= new \ounun\Mysql($GLOBALS['scfg']['db']['tool']);
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$copy_id		   		= $v['copy_id'];
		// --
		$bind['copy_name']		= $v['copy_name'];
		$bind['copy_type']  	= $v['copy_type'];
		
		$bind['type_sub']		= $v['type_sub'];
		$bind['difficulty']		= $v['difficulty'];
		$bind['belong_id']		= $v['belong_id'];
		
		$bind['lv']				= $v['lv'];
		$bind['desc']			= $v['desc'];
		
		$bind['ext']			= $str_v;
		
		$rs = $db->rows('SELECT * FROM `map_copy2` where copy_id = ? ',(int)$copy_id);
		if($rs)
		{
			$db->update('`map_copy2`',$bind, ' `copy_id` = ? ',(int)$copy_id);
		}else
		{
			$bind['copy_id']		= $copy_id;
			$bind['reward']	    	= '';
			$bind['reward_show']	= '';
			$bind['drama']			= '';
			$db->insert('`map_copy2`',$bind);
		}
		echo $copy_id,"\n .";
		//echo $db->getSql(),"\n";
	}
}
echo '<br />';
?>