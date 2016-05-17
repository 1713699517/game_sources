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
$npc						= array();
foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$npc_id			    	= $v['npc_id'];
		$npc[$npc_id]   		= $v;
		// --
		$bind['scene_id']		= $v['scene_id'];
		$bind['npc_name']  		= $v['npc_name'];
		$bind['show']			= $v['show'];
		
		$bind['skin']	    = $v['skin'];
		$bind['head']	    = $v['head'];
		$bind['fun_icon']	= $v['fun_icon'];
		
		
		$rs = $db->rows('SELECT * FROM `map_npc` where npc_id = ? ',(int)$npc_id);
		if($rs)
		{
			$db->update('`map_npc`',$bind, ' `npc_id` = ? ',(int)$npc_id);
		}else
		{
			$bind['npc_id']		= $v['npc_id'];
			$bind['skin']	    = $v['skin'];
			$bind['head']	    = $v['head'];
			
			$bind['fun_icon']	= $v['fun_icon'];
			$bind['type']		= 0;
			
			$bind['says1']		= '';
			$bind['says2']		= '';
			$bind['says3']		= '';
			$db->insert('`map_npc`',$bind);
		}
		echo $npc_id,"\n .";
		// echo $db->getSql(),"\n";
	}
}
\funs\tools\php_data_write('scene',	'npc',  $npc);
echo '<br />';
?>