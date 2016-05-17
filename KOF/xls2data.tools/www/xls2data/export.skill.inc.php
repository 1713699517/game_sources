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
		$str_v  		  = serialize($v);
		$primary['id']	  = $v['id'];
		$bind['name']	  = $v['name'];
		//		if($v['remark']){
// 		$bind['battle_remark']	  = $v['battle_remark'];
		$bind['remark']	  = $v['remark'];
		$bind['lv_must']  = (int)$v['lv_must'];
		$bind['lv_max']   = (int)$v['lv_max'];
		$bind['type']	  = $v['type'];
		
		$bind['distance'] = $v['distance'];
		$bind['range']	  = $v['range'];
 		
		$bind['pro']	  = $v['pro'];
		$bind['sex']	  = $v['sex'];
		$bind['icon']	  = $v['icon'];
		$bind['ext']	  = $str_v;
		$rs = $db->rows('SELECT * FROM `skill` where id = ? ',(int)$v['id']);
		if($rs)
		{
			unset($bind['id']);
			$db->update('`skill`',$bind, ' `id` = ? ',(int)$v['id']);
		}else
		{
			$bind = $primary+$bind;
			$db->insert('`skill`',$bind);
		}
		echo $v['id'],"\n .";
		// echo $db->getSql(),"<br />\n";
	}
}
echo '<br />';
?>