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

$db = new \ounun\Mysql ( $GLOBALS ['scfg'] ['db'] ['tool'] );

foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$str_v = array (
				'exts' => serialize ( $v ) 
		);
		$bind['id']	  	  = $v['id'];
		$bind['lv']	      = $v['lv'];
		$bind['exts']	  = $str_v;
		$rs 	 = $db->rows('SELECT * FROM `skill_lv` where `id` = :id and lv = :lv ',array('id'=>(int)$v['id'],'lv'=>(int)$v['lv']) );
		if($rs)
		{
			unset($bind['id']);
			$db->update('skill_lv',$bind,' `id` = :id and lv = :lv ',array('id'=>(int)$v['id'],'lv'=>(int)$v['lv']));
		} else 
		{
			$bind ['id'] = $v['id'];
			$bind ['lv'] = $v['lv'];
			$db->insert ( 'skill_lv', $bind );
		}
		echo $v['id'],"\n .";
		//echo $db->getSql(),"\n";
	}
}
echo '<br />';
?>