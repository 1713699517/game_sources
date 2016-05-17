<?php 
$KEY		= false;
$KEY_INDEX	= false;
$KEY_DATA	= false;

$OUT_XML	= false;
$OUT_YRL	= false;

$XML		= false;
$YRL		= false;

$FIELDS		= false;
$NAME		= false;	 

$VALUE_YRL	= array();
$VALUE_XML	= array();

foreach($sheets as &$sheet)
{
	//echo '$sheet:';
	//var_dump($sheet);
	foreach ($sheet['data'] as &$rs) 
	{
		$rs[0] 								= trim($rs[0]);	 
		//echo '$rs[0]:',$rs[0],'<br />';
		switch($rs[0])
		{
			case 'VALUE': //属性值所在行
				$_xml 	= array();
				$_yrl 	= array();
				foreach ($rs as $k => $v){					
					if($k > 0){
						$v	= trim($v);
						$v  = preg_replace('/\s/','',$v);
						//echo "\$_xml{$FIELDS['xml'][$k]} = \$v;","<br />";
						if($OUT_XML && 'yes' == $XML[$k]){
							eval("\$_xml{$FIELDS['xml'][$k]} = \$v;");
						}
						if($OUT_YRL && 'yes' == $YRL[$k]){
							$_yrl[$FIELDS['yrl'][$k]] = $v;
						}
					}
				}
				if($KEY_INDEX){
					$_key		 = 0;				
					eval("\$_key = \$_xml{$KEY_INDEX};");
					if(!$VALUE_XML[$_key])
					{
						$VALUE_XML[$_key]   			= $_xml;
						$VALUE_XML[$_key][$KEY_DATA]	= array();
					}			 
					$VALUE_XML[$_key][$KEY_DATA][]      = $_xml[$KEY_DATA];
				}else{					
					$VALUE_XML[] = $_xml;
				}
				$VALUE_YRL[] = $_yrl;
				// $VALUE[] = array('xml'=>$_xml,'yrl'=>$_yrl);
				break;
//			case '-' : 	  //注释
//				$VALUE[] 					= trim($rs[1]);
//				break;
			case 'NAME' :
				if(!$NAME){
					foreach ($rs as $k=>$v){
						$NAME[$FIELDS['yrl'][$k]] = trim($v);
					}
				}
				break;
			case 'FIELDS':
				if(!$FIELDS)
				{
					$fields_xml   = array();
					foreach ($rs as $k=>$v){
						$fields_xml[$k] = xml2key($v);
					}
					$FIELDS['yrl'] 	 	= $rs;
					$FIELDS['xml'] 	 	= $fields_xml;				
				}					
				break;
			case 'KEY':
				if(!$KEY) 		$KEY      	= trim($rs[1]);
				break;
			case 'KEY_INDEX':
				if(!$KEY_INDEX) $KEY_INDEX  = xml2key($rs[1]);
				break;
			case 'KEY_DATA':
				if(!$KEY_DATA) 	$KEY_DATA   = trim($rs[1]);
				break;
			case 'OUT_XML' :
				if(!$OUT_XML)   $OUT_XML  	= trim($rs[1]);
				break;
			case 'OUT_YRL' :
				if(!$OUT_YRL)   $OUT_YRL  	= trim($rs[1]);
				break;
			case 'XML' :
				if(!$XML){
					foreach ($rs as $k=>$v) 
						$XML[$k]	= strtolower(trim($v));
				}
				break;
			case 'YRL' :
				if(!$YRL){
					foreach ($rs as $k=>$v) 
						$YRL[$k]	= strtolower(trim($v));
				}
				break;
			default : //空行或其他
				break;
		}
	}
}
// echo $_GET['f'],"<br />\n";
// echo $OUT_XML,"<br />\n";
// echo $OUT_YRL,"<br />\n"; 
if($OUT_XML)
{
	$VALUE_XML2 = array();
	foreach ($VALUE_XML as $v) 
	{
	    if('activity/panel.xlsx' == $_GET['f'])
	    {
	        $goods = activity_panel_goods_str2array($v['reward']['goods']);
	        if($goods)
	        {
	            $v['reward']['goods'] = $goods;
	        }else {
	            unset($v['reward']['goods']);
	            $v['reward']['goodss'] = array();
	        }
	        $v['week'] = activity_panel_week_xml($v['week']);
	        $v['time'] = activity_panel_time_xml($v['time']);
	        $v['open'] = activity_panel_open_xml($v['open']);
        }elseif('activity/activity_boss.xlsx' == $_GET['f'])
        {
            $pos = strpos($v['#']['scene'], '{');
            if ($pos === false)
            {
                $v['#']['scene0']       = (int)$v['#']['scene'];
                $v['#']['scene1']       = (int)$v['#']['scene'];
                $v['#']['scene2']       = (int)$v['#']['scene'];
                $v['#']['scene3']       = (int)$v['#']['scene'];               
            }else{
                $scene = trim($v['#']['scene'],"{}");
                $scene = explode(',', $scene);
                $v['#']['scene0']       = (int)$scene[0];
                $v['#']['scene1']       = (int)$scene[0];
                $v['#']['scene2']       = (int)$scene[1];
                $v['#']['scene3']       = (int)$scene[2];
            }            
            unset($v['#']['scene']);            
            $v['reward']['goods']  = activity_panel_goods_str2array($v['reward']['goods']);
            $v['week']             = activity_panel_week_xml($v['week']);
            $v['time']             = activity_panel_time_xml_single($v['time']); 
	    }elseif('maidservant.xlsx' == $_GET['f'] || 
	             'maidservant_attr.xlsx' == $_GET['f'])
	    {
	        $item = array();
	        foreach ($v['item'] as $v2)
	        {
	            $v2['open'] = activity_panel_open_xml($v2['open']);
	            $item[]     = $v2;
	        }
	        $v['item']      = $item;
	    }
		$VALUE_XML2[] = $v;
	}
	$xml_str   = data2xml($VALUE_XML2,$KEY);
	$xml_str   = '<'.'?xml version="1.0" encoding="UTF-8"?'.">\r\n".$xml_str;
	$file_name = Dir_Data_Root.$OUT_XML;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$xml_str);
}

if($OUT_YRL)
{
    if('activity/panel.xlsx' == $_GET['f'])
    {
        $VALUE_YRL2 = array();
        $crontab_string = '';
        foreach ($VALUE_YRL as $v)
        {
            //print_r($v);
            $activity_id     = $v['#id'];
            $v_time          = activity_panel_activity_time_yrl($v['time']);
            //print_r($v_time);
            
            if($v['time'] && '[]' != $v['time']  && $v_time
               && $v['tip'] && '[]' != $v['tip']
               && $v['api#pre'] && '-' != $v['api#pre'] )
            {
                $datas            = activity_panel_activity_pre_yrl($v_time, $v['tip']);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{activityp{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api#pre']} , 	[{$activity_id},{$data['pre']}] } } .\n";
                }                
            }
            if($v['time'] && '[]' != $v['time']  && $v_time
               && $v['api#start'] && '-' != $v['api#start'] )
            {
                $datas            = activity_panel_activity_start_yrl($v_time);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{activitys{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api#start']} , 		[{$activity_id}] } } .\n";
                }
            }
            if($v['time'] && '[]' != $v['time']  && $v_time
               && $v['api#end'] && '-' != $v['api#end'] )
            {
                $datas            = activity_panel_activity_end_yrl($v_time);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{activitye{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api#end']} , 		[{$activity_id}] } } .\n";
                }
            }
            if($v['time'] && '[]' != $v['time']  && $v_time
               && $v['api#hide'] && '-' != $v['api#hide'] 
               && $v['#show'] == '0' 
               && $v['hide'] > 0)
            {
                $datas            = activity_panel_activity_hide_yrl($v_time, $v['hide']);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{activityh{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   {$v['api#hide']} , 		[{$activity_id}] } } .\n";
                }
            }
            unset($v['api#pre']);
            unset($v['api#start']);
            unset($v['api#end']);
            unset($v['api#hide']);
            $VALUE_YRL2[]    = $v;            
        }
        $yrl_str   = data2yrl($VALUE_YRL2,$NAME);
        clock_system_write($crontab_string, 'ACTIVITY');
    }else if('activity/activity_boss.xlsx' == $_GET['f'])
    {
        $VALUE_YRL2 = array();
        $crontab_string = '';
        foreach ($VALUE_YRL as $v)
        {
            //print_r($v);
            $activity_id     = $v['#id'];
            $v_time          = activity_panel_activity_time_yrl_single($v['time']);
            //print_r($v_time);
        
            if($v['time'] && '[]' != $v['time']  && $v_time
                    && $v['tip']  && '[]' != $v['tip']
                    && $v['hide'] > 0 )
            {
                $datas            = activity_panel_activity_pre_yrl($v_time, $v['tip']);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{a_bossp{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   boss_pre,    [{$activity_id},{$data['pre']}] } } .\n";
                }
                $datas            = activity_panel_activity_start_yrl($v_time);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{a_bosss{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   boss_start,    [{$activity_id}] } } .\n";
                }
                $datas            = activity_panel_activity_hide_yrl_single($v_time, $v['hide']);
                foreach ($datas as $kk=>$data)
                {
                    $crontab_string .= "{a_bossh{$kk}_{$activity_id},[{$data['minute']}] ,							[{$data['hour']}] ,				[] ,				[] ,		{$v['week']} ,			{ activity_api,   boss_hide,    [{$activity_id}] } } .\n";
                }
            }
            $VALUE_YRL2[]    = $v;
        }
        $yrl_str   = data2yrl($VALUE_YRL2,$NAME);
        clock_system_write($crontab_string, 'BOSS');        
    }else
    {
        $yrl_str   = data2yrl($VALUE_YRL,$NAME);
    }	
	$file_name = Dir_Data_Root.$OUT_YRL;
	echo $file_name,"<br />\n";
	file_put_contents($file_name,$yrl_str);
}
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
        $rs[] = array('#' => array('id'=>$v[1],'count'=>$v[2],'streng'=>$v[3],'bind'=>$v[5],
                                    'name_color'=>$v[4],'expiry_type'=>$v[6],'expiry'=>$v[7],));
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


function activity_panel_time_xml($str)
{
    if('[]' == $str || !$str)
    {
        return '全天';
    }else 
    {
        //        [{{12,30},{12,46}}]
        $rs      = array();
        $matches = array(); //     1     2         3     4
        $pattern =          '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
        preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
        foreach ($matches as $v)
        {
            $rs[] = "{$v[1]}:{$v[2]}-{$v[3]}:{$v[4]}";         
        }
        if($rs)
        {
            return implode(',', $rs);
        }
        return '全天';
    }
}

function activity_panel_time_xml_single($str)
{
    if('[]' == $str || !$str)
    {
        return '全天';
    }else
    {
        //        [{{12,30},{12,46}}]
        $rs      = array();
        $matches = array(); //   1     2
        $pattern =          '/\{(\d*),(\d*)\}/';
        preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
        foreach ($matches as $v)
        {
            $rs[] = "{$v[1]}:{$v[2]}";
        }
        if($rs)
        {
            return implode(',', $rs);
        }
        return '全天';
    }
}

function activity_panel_open_xml($open)
{
    // print_r($open);
    $rs      = array();
    $pos = strpos($open['#']['arg'], '{');
    if ($pos === false) 
    {
        $rs[] = array('#' => array('country'=>0,'event'=>$open['#']['event'],'scene'=>$open['#']['scene'],'x'=>$open['#']['scene_x'],'y'=>$open['#']['scene_y'],'arg'=>$open['#']['arg'],));
        $rs[] = array('#' => array('country'=>1,'event'=>$open['#']['event'],'scene'=>$open['#']['scene'],'x'=>$open['#']['scene_x'],'y'=>$open['#']['scene_y'],'arg'=>$open['#']['arg'],));
        $rs[] = array('#' => array('country'=>2,'event'=>$open['#']['event'],'scene'=>$open['#']['scene'],'x'=>$open['#']['scene_x'],'y'=>$open['#']['scene_y'],'arg'=>$open['#']['arg'],));
        $rs[] = array('#' => array('country'=>3,'event'=>$open['#']['event'],'scene'=>$open['#']['scene'],'x'=>$open['#']['scene_x'],'y'=>$open['#']['scene_y'],'arg'=>$open['#']['arg'],));
    }else
    {
        $scene = trim($open['#']['scene'],"{}");
        $scene = explode(',', $scene);
        $scene_x = trim($open['#']['scene_x'],"{}");
        $scene_x = explode(',', $scene_x);
        $scene_y = trim($open['#']['scene_y'],"{}");
        $scene_y = explode(',', $scene_y);
        $arg   = trim($open['#']['arg'],"{}");
        $arg   = explode(',', $arg);        
        $rs[] = array('#' => array('country'=>0,'event'=>$open['#']['event'],'scene'=>(int)$scene[0],'x'=>(int)$scene_x[0],'y'=>(int)$scene_y[0],'arg'=>(int)$arg[0],));
        $rs[] = array('#' => array('country'=>1,'event'=>$open['#']['event'],'scene'=>(int)$scene[0],'x'=>(int)$scene_x[0],'y'=>(int)$scene_y[0],'arg'=>(int)$arg[0],));
        $rs[] = array('#' => array('country'=>2,'event'=>$open['#']['event'],'scene'=>(int)$scene[1],'x'=>(int)$scene_x[1],'y'=>(int)$scene_y[1],'arg'=>(int)$arg[1],));
        $rs[] = array('#' => array('country'=>3,'event'=>$open['#']['event'],'scene'=>(int)$scene[2],'x'=>(int)$scene_x[2],'y'=>(int)$scene_y[2],'arg'=>(int)$arg[2],));
    }
    return $rs;
}
// unset($v['api#pre']);
// unset($v['api#start']);
// unset($v['api#end']);
// unset($v['api#hide']);
function activity_panel_activity_time_yrl($str)
{
    $rs      = array();
    $matches = array(); //     1     2         3     4
    $pattern = '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
    preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
    foreach ($matches as $v)
    {
        $rs[] = array('start_h'=>(int)$v[1],'start_i'=>(int)$v[2],'end_h'=>(int)$v[3],'end_i'=>(int)$v[4],);
    }
    return $rs;
}
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
function activity_panel_activity_start_yrl($time)
{
    $rs    = array();
    foreach ($time as $t)
    {
        $rs[]         = array('minute'=>$t['start_i'],'hour'=>$t['start_h']);
    }    
    return $rs;
}
function activity_panel_activity_end_yrl($time)
{
    $rs    = array();
    foreach ($time as $t)
    {
        $rs[]         = array('minute'=>$t['end_i'],'hour'=>$t['end_h']);
    }
    return $rs;
}
function activity_panel_activity_hide_yrl($time,$hide)
{
    $rs    = array();
    foreach ($time as $t)
    {
        $rs[]         = activity_panel_activity_time_difference($t['end_h'],$t['end_i'],$hide);
    }
    return $rs;
}
function activity_panel_activity_time_yrl_single($str)
{
    $rs      = array();
    $matches = array(); //    1     2
    $pattern =           '/\{(\d*),(\d*)\}/';
    preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
    foreach ($matches as $v)
    {
        $rs[] = array('start_h'=>(int)$v[1],'start_i'=>(int)$v[2],);
    }
    return $rs;
}
function activity_panel_activity_hide_yrl_single($time,$hide)
{
    $rs    = array();
    foreach ($time as $t)
    {
        $rs[]         = activity_panel_activity_time_difference($t['start_h'],$t['start_i'],$hide);
    }
    return $rs;
}


//var_dump($VALUE);
?>