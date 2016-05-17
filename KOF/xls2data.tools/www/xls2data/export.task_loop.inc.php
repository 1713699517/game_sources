<?php 
$val        = \funs\excel\parser_array($sheets);
 
//print_r($val);

$REM		= $val['rem'];
$KEY		= $val['key'];
$FILE_PLIST = $val['file_plist'];
$FILE_ERL	= $val['file_erl'];
$PLIST		= $val['plist'];
$ERL		= $val['erl'];
$NAME		= $val['name'];
$VALUE			= $val['value'];
$VALUE_PLIST	= $val['value_plist'];
$VALUE_ERL		= $val['value_erl'];


$task_loop  = array();
foreach ($VALUE as $v)
{
	if(is_array($v))
	{
		$task_loop[$v['type']][$v['id']]  =  array(
					'name' => $v['name'],
					'lv'   => $v['lv'],
					'times'=> $v['times'],
				);
	}
}
\funs\tools\php_data_write('task','task_loop',$task_loop);
?>