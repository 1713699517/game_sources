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
		//print_r($v);
		$str_v  				= serialize($v);
		$primary['goods_id']	= $v['goods_id'];
		$bind['name']			= $v['name'];
//		if($v['remark']){
			$bind['remark']		= $v['remark'];
//		}		
		$bind['type']			= $v['type'];
		$bind['type_sub']		= $v['type_sub'];
		$bind['lv']				= $v['lv'];
		$bind['pro']			= $v['pro'];
		$bind['sex']			= $v['sex'];
		$bind['icon']			= $v['icon'];
		//$bind['sex']			= $v['sex'];
		$bind['flag']			= '';
		$bind['exts']			= $str_v;
		$bind['gift']			= '';
		$rs = $db->rows('SELECT * FROM `goods` where goods_id = ? ',(int)$v['goods_id']);
		if($rs){
			unset($bind['goods_id']);
			unset($bind['gift']);
			$db->update('`goods`',$bind, ' `goods_id` = ? ',(int)$v['goods_id']);
		}else{
			$bind = $primary+$bind;
			$db->insert('`goods`',$bind);
		}
		echo $v['goods_id'],"\n .";
		//echo $db->getSql(),"\n";
	}
}
echo '<br />';
?>