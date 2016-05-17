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
$monster		= array();
foreach ($VALUE as $v)
{
	
	if(is_array($v))
	{
		$str_v  				= serialize($v);
		// --
		$monster_id			    = $v['monster_id'];
		$monster[$monster_id]   = $v;
		// --
		$bind['monster_name']	= $v['monster_name'];
		$bind['monster_type']  	= $v['monster_type'];
		
		$bind['attack_type']		= $v['attack_type'];
		$bind['attack_distance']	= $v['attack_distance'];
		$bind['scene_id']			= $v['scene_id'];
		$bind['says1']	= $v['says1'];
		$bind['says2']	= $v['says2'];
		$bind['says3']	= $v['says3'];
		
		$bind['skin']	    	= $v['skin'];
		$bind['head']			= $v['head'];
		
			
		$bind['exts']	= $str_v;
		$rs = $db->rows('SELECT * FROM `map_monster` where monster_id = ? ',(int)$monster_id);
		if($rs)
		{
			$db->update('`map_monster`',$bind, ' `monster_id` = ? ',(int)$monster_id);
		}else
		{
			$bind['monster_id']		= $v['monster_id'];
			$bind['skin']	    	= $v['skin'];
			$bind['head']			= $v['head'];
			$bind['flop']			= '';
			$bind['effect_out']		= 0;
			$bind['effect_by']		= 0;
			$bind['effect_screen']	= 0;
			$db->insert('`map_monster`',$bind);
		}
		echo $monster_id,"\n .";
		//echo $db->getSql(),"\n";
	}
}
\funs\tools\php_data_write('scene',	'monster',  $monster);
echo '<br />';
?>