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

// echo $_GET['f'],"<br />\n";
// echo $OUT_XML,"<br />\n";
// echo $OUT_YRL,"<br />\n"; 
$file_name  = $export_dir_xml.$FILE_PLIST;
$VALUE_XML2 = array();
foreach ($VALUE_PLIST as $v) 
{
// 	$goods = activity_panel_goods_str2array($v['reward']['goods']);
// 	if($goods)
// 	{
// 		$v['reward']['goods'] = $goods;
// 	}else {
// 		unset($v['reward']['goods']);
// 		$v['reward']['goodss'] = array();
// 	}
	$v['week'] = activity_panel_week_xml($v['week']);
	//$v['time'] = activity_panel_time_xml($v['time']);
	$v['open'] = activity_panel_open_xml($v['open']);
	$VALUE_XML2[$v['id']] = $v;
}
// $pl					 = new \plugins\ToPList($VALUE_XML2);
// $xml_plist_data		 = $pl->xml();

// echo $file_name,"<br />\n";
// file_put_contents($file_name,$xml_plist_data); 
\funs\tools\php_plist_write($file_name, $VALUE_XML2);

///////////////////////////////////////////////////////////////////

$file_name  = $export_dir_erl.$FILE_ERL;
$str_head   = "-module(data_{$KEY}).\n".
			  "-include(\"../include/comm.hrl\").\n\n".
			  "-export([get/1,get_ids/0]).\n\n".
			  "% ".implode(";\n% ",$REM). "\n";
$erl_str    = array();
$list 		= array();

$crontab_string = '';
foreach ($VALUE as $v)
{
	//print_r($v);
	$activity_id     = $v['id'];
	//$v_time          = activity_panel_activity_time_yrl2($v['time']);
	//print_r($v_time);
	
	if($v['time'] && '[]' != $v['time']
			&& $v['enter'] && '-' != $v['enter'] )
	{
		$datas            = activity_panel_activity_time_yrl2($v['time']);
		foreach ($datas as $kk=>$data)
		{
			$crontab_string .= "{activity{$kk}_{$activity_id},			[0] ,     [{$data['i']}] ,							[{$data['h']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['enter']} , 	[{$activity_id},{$data['state']},{$data['args']}] } } .\n";
		}
	}
// 	if($v['time'] && '[]' != $v['time']  && $v_time
// 			&& $v['tip'] && '[]' != $v['tip']
// 			&& $v['api']['pre'] && '-' != $v['api']['pre'] )
// 	{
// 		$datas            = activity_panel_activity_pre_yrl($v_time, $v['tip']);
// 		foreach ($datas as $kk=>$data)
// 		{
// 			$crontab_string .= "{activityp{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api']['pre']} , 	[{$activity_id},{$data['pre']}] } } .\n";
// 		}
// 	}
// 	if($v['time'] && '[]' != $v['time']  && $v_time
// 			&& $v['api']['start'] && '-' != $v['api']['start'] )
// 	{
// 		$datas            = activity_panel_activity_start_yrl($v_time);
// 		foreach ($datas as $kk=>$data)
// 		{
// 			$crontab_string .= "{activitys{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api']['start']} , 		[{$activity_id}] } } .\n";
// 		}
// 	}
// 	if($v['time'] && '[]' != $v['time']  && $v_time
// 			&& $v['api']['end'] && '-' != $v['api']['end'] )
// 	{
// 		$datas            = activity_panel_activity_end_yrl($v_time);
// 		foreach ($datas as $kk=>$data)
// 		{
// 			$crontab_string .= "{activitye{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api']['end']} , 		[{$activity_id}] } } .\n";
// 		}
// 	}
// 	if($v['time'] && '[]' != $v['time']  && $v_time
// 			&& $v['api']['hide'] && '-' != $v['api']['hide']
// 			&& $v['show'] == '0'
// 			&& $v['hide'] > 0)
// 	{
// 		$datas            = activity_panel_activity_hide_yrl($v_time, $v['hide']);
// 		foreach ($datas as $kk=>$data)
// 		{
// 			$crontab_string .= "{activityh{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api']['hide']} , 		[{$activity_id}] } } .\n";
// 		}
// 	}
	$erl_str[]	= "get({$activity_id})->\n\t#d_activity_panel{\n"
				."\t\t id		=  {$activity_id},% 唯一ID\n"
				."\t\t type		=  {$v['type']},% 分类(任务)\n"
				."\t\t lv		=  {$v['lv']},% 等级\n"
				."\t\t times	=  {$v['times']},% 次数\n"
				."\t\t number	=  {$v['number']},% 人数\n"
				."\t\t week	=  {$v['week']},% 日期(星期)\n"
				."\t\t time	=  {$v['time']},% 时间\n"
				."\t\t enter=  {$v['enter']},% 函数入口\n"
				."\t\t show	=  {$v['show']},% 是否一直显示\n"
				."\t\t open_event	=  {$v['open']['event']},% 		打开#事件\n"
				."\t\t open_scene	=  {$v['open']['scene']},%  	打开#场景\n"
				."\t\t open_scene_x	=  {$v['open']['scene_x']},% 	打开#场景坐标X\n"
				."\t\t open_scene_y	=  {$v['open']['scene_y']},% 	打开#场景坐标Y\n"
				."\t\t open_arg		=  {$v['open']['arg']}% 		打开#参数\n"
				."\t};";
	$list[]=$activity_id;
}
\funs\tools\clock_system_write($crontab_string, 'ACTIVITY');

$erl_str[]	= "get(_)->?null.\n";
$erl_str[]  = "get_ids()->\n\t[".implode(',',$list)."].\n\n";
$erl_str    = implode("\n",$erl_str);

echo $file_name,"<br />\n";
file_put_contents($file_name,$str_head.$erl_str);
/////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

function activity_panel_goods_str2array($str)
{
    // {give,{$goods_id},{$count},{$streng},{$name_color},{$bind},{$expiry_type},{$expiry}}
    $rs      = array();
    $matches = array(); // 1     2     3     4     5    6     7 
    $pattern = '/\{give,(\d*),(\d*),(\d*),(\d*),(\d*),(\d*),(\d*)\}/';
    preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
    foreach ($matches as $v)
    {
        $rs[] = array('id'=>$v[1],'count'=>$v[2],'streng'=>$v[3],'bind'=>$v[5],
                                    'name_color'=>$v[4],'expiry_type'=>$v[6],'expiry'=>$v[7],);
    }
    return $rs;
}

function activity_panel_week_xml($str)
{
    if('[]' == $str || '[1,2,3,4,5,6,7]' == $str || !$str)
    {
        return '每天';
    }else 
    {
        $rs      = array();
        $matches = array(); // 1     2     3     4     5    6     7
        $pattern = '/(\d*)/';
        preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
        $data    = array(1=>'周一',2=>'周二',3=>'周三',4=>'周四',5=>'周五',6=>'周六',7=>'周日');
        
        foreach ($matches as $v)
        {
            
            if($data[$v[0]])
            {
                $rs[] = $data[$v[0]];
            }           
        }
        if($rs)
        {
            return implode(',', $rs);
        }
        return '每天';
    }    
}


// function activity_panel_time_xml($str)
// {
//     if('[]' == $str || !$str)
//     {
//         return '全天';
//     }else 
//     {
//         //        [{{12,30},{12,46}}]
//         $rs      = array();
//         $matches = array(); //     1     2         3     4
//         $pattern =          '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
//         preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
//         foreach ($matches as $v)
//         {
//             $rs[] = "{$v[1]}:{$v[2]}-{$v[3]}:{$v[4]}";         
//         }
//         if($rs)
//         {
//             return implode(',', $rs);
//         }
//         return '全天';
//     }
// }

// function activity_panel_time_xml_single($str)
// {
//     if('[]' == $str || !$str)
//     {
//         return '全天';
//     }else
//     {
//         //        [{{12,30},{12,46}}]
//         $rs      = array();
//         $matches = array(); //   1     2
//         $pattern =          '/\{(\d*),(\d*)\}/';
//         preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
//         foreach ($matches as $v)
//         {
//             $rs[] = "{$v[1]}:{$v[2]}";
//         }
//         if($rs)
//         {
//             return implode(',', $rs);
//         }
//         return '全天';
//     }
// }

function activity_panel_open_xml($open)
{
    // print_r($open);
    $rs      = array();
    $pos = strpos($open['arg'], '{');
    if ($pos === false) 
    {
        $rs[] = array('country'=>0,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>$open['scene'],'x'=>$open['scene_x'],'y'=>$open['scene_y'],'arg'=>$open['arg'],);
        $rs[] = array('country'=>1,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>$open['scene'],'x'=>$open['scene_x'],'y'=>$open['scene_y'],'arg'=>$open['arg'],);
        $rs[] = array('country'=>2,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>$open['scene'],'x'=>$open['scene_x'],'y'=>$open['scene_y'],'arg'=>$open['arg'],);
        $rs[] = array('country'=>3,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>$open['scene'],'x'=>$open['scene_x'],'y'=>$open['scene_y'],'arg'=>$open['arg'],);
    }else
    {
        $scene = trim($open['scene'],"{}");
        $scene = explode(',', $scene);
        $scene_x = trim($open['scene_x'],"{}");
        $scene_x = explode(',', $scene_x);
        $scene_y = trim($open['scene_y'],"{}");
        $scene_y = explode(',', $scene_y);
        $arg   = trim($open['arg'],"{}");
        $arg   = explode(',', $arg);        
        $rs[] = array('country'=>0,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>(int)$scene[0],'x'=>(int)$scene_x[0],'y'=>(int)$scene_y[0],'arg'=>(int)$arg[0],);
        $rs[] = array('country'=>1,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>(int)$scene[0],'x'=>(int)$scene_x[0],'y'=>(int)$scene_y[0],'arg'=>(int)$arg[0],);
        $rs[] = array('country'=>2,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>(int)$scene[1],'x'=>(int)$scene_x[1],'y'=>(int)$scene_y[1],'arg'=>(int)$arg[1],);
        $rs[] = array('country'=>3,'txt'=>$open['txt'],'event'=>$open['event'],'scene'=>(int)$scene[2],'x'=>(int)$scene_x[2],'y'=>(int)$scene_y[2],'arg'=>(int)$arg[2],);
    }
    return $rs[0];
}
// unset($v['api#pre']);
// unset($v['api#start']);
// unset($v['api#end']);
// unset($v['api#hide']);

function activity_panel_activity_time_yrl2($str)
{
	$rs      = array();
	$matches = array(); 
			 //      1     2     3     4
	$pattern = '/\{(\d*),(\d*),(\d*),(.*?)\}/';
	preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
	foreach ($matches as $v)
	{
		$rs[] = array('h'=>(int)$v[1],'i'=>(int)$v[2],'state'=>(int)$v[3],'args'=>$v[4],);
	}
	return $rs;
}
// function activity_panel_activity_time_yrl($str)
// {
//     $rs      = array();
//     $matches = array(); //     1     2         3     4
//     $pattern = '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
//     preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
//     foreach ($matches as $v)
//     {
//         $rs[] = array('start_h'=>(int)$v[1],'start_i'=>(int)$v[2],'end_h'=>(int)$v[3],'end_i'=>(int)$v[4],);
//     }
//     return $rs;
// }
function activity_panel_activity_time_difference($hour,$minute,$diff)
{
    $total = $hour*60+$minute+$diff;
    $total = $total < 0 ? 0 : $total;
    $hour  = floor($total/60);    
    $minute= $total % 60;
    return array('minute'=>$minute,'hour'=>$hour);
}
// minute  hour  pre
function activity_panel_activity_pre_yrl($time,$tip)
{
    $tip   = trim($tip,"{}[]");
    $tip   = explode(',', $tip);
    $rs    = array();
    foreach ($time as $t)
    {
        foreach ($tip as $diff)
        {
            $data         = activity_panel_activity_time_difference($t['start_h'],$t['start_i'],-$diff);
            $data['pre']  = $diff;
            $rs[]         = $data;
        }
    }    
    return $rs;
}
// function activity_panel_activity_start_yrl($time)
// {
//     $rs    = array();
//     foreach ($time as $t)
//     {
//         $rs[]         = array('minute'=>$t['start_i'],'hour'=>$t['start_h']);
//     }    
//     return $rs;
// }
// function activity_panel_activity_end_yrl($time)
// {
//     $rs    = array();
//     foreach ($time as $t)
//     {
//         $rs[]         = array('minute'=>$t['end_i'],'hour'=>$t['end_h']);
//     }
//     return $rs;
// }
// function activity_panel_activity_hide_yrl($time,$hide)
// {
//     $rs    = array();
//     foreach ($time as $t)
//     {
//         $rs[]         = activity_panel_activity_time_difference($t['end_h'],$t['end_i'],$hide);
//     }
//     return $rs;
// }
// function activity_panel_activity_time_yrl_single($str)
// {
//     $rs      = array();
//     $matches = array(); //    1     2
//     $pattern =           '/\{(\d*),(\d*)\}/';
//     preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
//     foreach ($matches as $v)
//     {
//         $rs[] = array('start_h'=>(int)$v[1],'start_i'=>(int)$v[2],);
//     }
//     return $rs;
// }
// function activity_panel_activity_hide_yrl_single($time,$hide)
// {
//     $rs    = array();
//     foreach ($time as $t)
//     {
//         $rs[]         = activity_panel_activity_time_difference($t['start_h'],$t['start_i'],$hide);
//     }
//     return $rs;
// }


//var_dump($VALUE);
?>