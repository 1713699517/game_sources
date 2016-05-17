<?php 
/** 命名空间 */
namespace funs\tools;

function data2record($v)
{
//	\print_r($v);
	$s = array();
	foreach ($v as $k2=>$v2)
	{
		$s[] = "{$k2}={$v2}";
	}
	return implode(',', $s);
}

function data2xml($data,$key,$t='',$is_only = false)
{
	$xml 		 = '';
	if ('#' == $key)
    {
		return  $xml;
	}elseif(!is_array($data))
    {
		if(strstr($key,'$'))
        {
			$key  	 = substr($key,1);
			$data    = stripslashes($data);
			$xml	.= "{$t}<{$key}><![CDATA[{$data}]]></{$key}>\n";
		}else
        {
			if(is_numeric($data))
            {
				// $data = printf("%s",$data);
				$data = number_format($data,0,'','');
			}
			$xml	.= "{$t}<{$key}>{$data}</{$key}>\n";
		}		
	}elseif(array_keys($data) === range(0, count($data) - 1))
	{		
		$key2	 = strstr($key,'$')?substr($key,1):$key;
		if('' == $t || false == $is_only)
        {
			$xml	.= "{$t}<{$key2}s>\n";
			foreach ($data as $data2)
            {
				$xml.= \funs\tools\data2xml($data2,$key,"{$t}\t");
			}    	
			$xml	.= "{$t}</{$key2}s>\n";
		}else
        {
			foreach ($data as $data2)
            {
				$xml.= \funs\tools\data2xml($data2,$key,"{$t}");
			} 
		}		
	}else
	{		
		$is_only_c 	 = 0;
		$is_only 	 = true; // 是否唯一子结节，唯一子结点就不包 
		foreach ($data as $key2=>$data2)
        {
            if(!is_numeric($key2))
            {
                $is_only_c = 2;
            }elseif('#' != $key2)
            {
				$is_only_c ++;
			}
		}
		if($is_only_c > 1)
        {
			$is_only = false;
		}
		//////////////////////////////////////////////////////
		$v		 	= '';
		foreach ($data as $key2=>$data2)
        {
			$v	.= \funs\tools\data2xml($data2,$key2,"{$t}\t",$is_only);
		}
		if(is_array($data['#']))
		{
			$a   = '';
			foreach ($data['#'] as $key2=>$data2)
            {
				if(is_numeric($data2))
                {
					// $data2 = printf("%s",$data2);
					//$data2 = number_format($data2,3,'.','');
					if((int)$data2 != $data2)
                    {
						$data2 = number_format($data2,3,'.','');
					}else
                    {
						$data2 = number_format($data2,0,'','');
					}
				}
				$a .=" {$key2}=\"{$data2}\"";		
			}
			if($v)
            {
				$xml .= "{$t}<{$key}{$a}>\n";
				$xml .= $v;
				$xml .= "{$t}</{$key}>\n";
			}else
            {
				$xml .= "{$t}<{$key}{$a} />\n";
			}			
		}else
        {
			if($v)
            {
				$xml .= "{$t}<{$key}>\n";
				$xml .= $v;
				$xml .= "{$t}</{$key}>\n";
			}else{
				$xml .= "{$t}<{$key} />\n";
			}									
		}
	}
	return $xml;
}


function data2xml2($data,$key,$t='',$is_only = false)
{
	$xml 		 = '';
	if ('#' == $key)
	{
		return  $xml;
	}elseif(!is_array($data))
	{
		if(strstr($key,'$'))
		{
			$key  	 = substr($key,1);
			$data    = stripslashes($data);
			$xml	.= "{$t}<{$key}><![CDATA[{$data}]]></{$key}>\n";
		}else
		{
			if(is_numeric($data))
			{
				// $data = printf("%s",$data);
				$data = number_format($data,0,'','');
			}
			$xml	.= "{$t}<{$key}>{$data}</{$key}>\n";
		}
	}elseif(array_keys($data) === range(0, count($data) - 1))
	{
		$key2	 = strstr($key,'$')?substr($key,1):$key;
		if('' == $t || false == $is_only)
		{
			$xml	.= "{$t}<{$key2}s>\n";
			foreach ($data as $data2)
			{
				$xml.= \funs\tools\data2xml2($data2,$key,"{$t}\t");
			}
			$xml	.= "{$t}</{$key2}s>\n";
		}else
		{
			foreach ($data as $data2)
			{
				$xml.= \funs\tools\data2xml2($data2,$key,"{$t}");
			}
		}
	}else
	{
		$is_only_c 	 = 0;
		$is_only 	 = true; // 是否唯一子结节，唯一子结点就不包
		foreach ($data as $key2=>$data2)
		{
			if('#' != $key2)
			{
				$is_only_c ++;
			}
		}
		if($is_only_c > 1)
		{
			$is_only = false;
		}
		//////////////////////////////////////////////////////
		$v		 	= '';
		foreach ($data as $key2=>$data2)
		{
			$v	.= \funs\tools\data2xml2($data2,$key2,"{$t}\t",$is_only);
		}
		if(is_array($data['#']))
		{
			$a   = '';
			foreach ($data['#'] as $key2=>$data2)
			{
				if(is_numeric($data2))
				{
					// $data2 = printf("%s",$data2);
					//$data2 = number_format($data2,3,'.','');
					if((int)$data2 != $data2)
					{
						$data2 = number_format($data2,3,'.','');
					}else
					{
						$data2 = number_format($data2,0,'','');
					}
				}
				$a .=" {$key2}=\"{$data2}\"";
			}
			if($v)
			{
				$xml .= "{$t}<{$key}{$a}>\n";
				$xml .= $v;
				$xml .= "{$t}</{$key}>\n";
			}else
			{
				$xml .= "{$t}<{$key}{$a} />\n";
			}
		}else
		{
			if($v)
			{
				$xml .= "{$t}<{$key}>\n";
				$xml .= $v;
				$xml .= "{$t}</{$key}>\n";
			}else{
				$xml .= "{$t}<{$key} />\n";
			}
		}
	}
	return $xml;
}

function data2yrl($data,$name)
{
	// 得到长度
	$len_field	   = array();	
	$vs            = $data[0];
	foreach ($vs as $k=>$v){
		$cn 		   = mb_convert_encoding($name[$k],'GBK','UTF-8');
		$len_field[$k] = max(strlen($k),strlen($cn));
	}	
	foreach($data as $vs){
		foreach ($vs as $k=>$v){
			$cn 		   = mb_convert_encoding("<<\"{$v}\">>",'GBK','UTF-8');
			$len_field[$k] = max(strlen($cn),$len_field[$k]);
		}
	}
	// 得到注释
	$str_field 	   = array();
	$str_name  	   = array();
	$vs            = $data[0];
	foreach ($vs as $k=>$v){
		$str_name[]	 = str_pad(\funs\tools\word2head($k),	$len_field[$k]);
		$str_field[] = str_pad(preg_replace('/\s/', '', $name[$k]),		$len_field[$k]);
	}
	$str_rem	  = "\n% ".implode("\t,",$str_field)."\n% ".implode("\t,",$str_name)."\n";
	// 得到数据
	$str_yrl	  = '';
	foreach($data as $ks=>$vs){
		$str_t	  = array();
		foreach ($vs as $k=>$v){	
			if(!is_numeric($v)  
			   && $v[0] != '[' && $v[0] != '{'  
			   && $v != 'null' && $v != 'true' && $v != 'false' )
			{
				$v = "<<\"{$v}\">>";
			}elseif(is_numeric($v)){
				//$v = printf("%s",$v);
				if((int)$v != $v){
					$v = number_format($v,3,'.','');
				}else{
					$v = number_format($v,0,'','');
				}				
			}
			$str_t[] = str_pad($v,		 $len_field[$k]);
		}
		if(0==$ks%30){
			$str_yrl .= $str_rem;
		}
		$str_yrl .= " {".implode("\t,",$str_t)."}.\n";
	}
	return $str_yrl;
}
/**
 * 每个单词第一个字母大写
 * @param string $word
 * @return mixed
 */
function word2head($word)
{
	$word = strtolower($word);
	return str_replace(' ','',ucwords(str_replace(array('_','$','.','#','[',']'),' ',$word)));
}

function php_data_read($mod,$keys)
{
	$filename 	= Dir_Cache_Data."{$mod}/{$keys}.data.inc.php";
	//echo $filename,'<br />';
	$rs       	= null;
	if (file_exists($filename)){
		require $filename;
	}
	return $rs;
}
/**
 * 
 * @param $mod
 * @param $keys
 */
function php_data_delete($mod,$keys)
{
	$filename 	= Dir_Cache_Data."{$mod}/{$keys}.data.inc.php";
	if (file_exists($filename)){
		unlink($filename);
	}
	file_put_contents($filename,'<?php '."\n\$rs=array();\n".'?>');
}

/**
 * 写
 * @param string $mod
 * @param string $keys
 * @param mix $data
 */
function php_data_write($mod,$keys,$data)
{
	$filedir    = Dir_Cache_Data."{$mod}/";
	if(is_dir($filedir)){
		$ok = true;
	}
    if(!$ok && file_exists($filedir)){
    	unlink($filedir);
    }
    if(!$ok){
    	mkdir($filedir, 0777, true);
    }
    $filename	= "{$filedir}{$keys}.data.inc.php";
    $str		= var_export($data,true);
    file_put_contents($filename,'<?php '."\n\$rs={$str};\n".'?>');
}

/**
 * 写
 * @param string $mod
 * @param string $keys
 * @param mix $data
 */
function clock_system_write($crontab_string,$keys)
{
    $file_name           = Dir_Data_Root.'erl.yrl/crontab/task.clock.system.yrl';
	$file_name_str  	 = file_get_contents($file_name);
	$crontab_string_sub  = "% *** AUTO CODE BEGIN_{$keys} *************** don't touch this line **********/\n";
	$crontab_string_sub .= "% ** =============================== 自动生成的代码 =============================== **/\n";
	$crontab_string_sub .= $crontab_string;
	$crontab_string_sub .= "% ** =============================== 自动生成的代码 =============================== **/\n";
	$crontab_string_sub .= "% ***************** don't touch this line *********** AUTO CODE END_{$keys} ***/";
	$file_name_str		 = preg_replace('/% \*\*\* AUTO CODE BEGIN_'.$keys.'[\s\S]*AUTO CODE END_'.$keys.' \*\*\*\//m',$crontab_string_sub,$file_name_str);
	file_put_contents($file_name,$file_name_str);
}
/**
 * 代码替换
 * @param string $tab	
 * @param string $code
 * @param string $data
 * @param string $key
 * @param string $pre
 */
function code_replace($tab,$code,$data,$key,$pre='')
{
	$n		 = "\r\n";
	$code2 	 = "/** AUTO_CODE_BEGIN_{$key} **************** don't touch this line ********************/{$n}";
	$code2 	.= "{$tab}{$pre}/** =============================== 自动生成的代码 =============================== **/{$n}";
	$code2 	.=  $data;
	$code2 	.= "{$tab}{$pre}/** =============================== 自动生成的代码 =============================== **/{$n}";
	$code2 	.= "{$tab}{$pre}/*************************** don't touch this line *********** AUTO_CODE_END_{$key} **/";
	return preg_replace('/\/\*\* AUTO_CODE_BEGIN_'.$key.'[\s\S]*AUTO_CODE_END_'.$key.' \*\*\//m',$code2,$code);
}
/**
 * 得到give数据元组
 * @param uint $goods_id 	物品ID
 * @param uint $count    	数量
 * @param uint $streng	  	强化等级
 * @param uint $name_color  物品名称的颜色
 * @param uint $bind		是否绑定(0:不绑定 1:绑定)
 * @param uint $expiry_type 有效期类型，0:不失效，1：秒，  2：天，请多预留几个以后会增加
 * @param uint $expiry		有效期，到期后自动消失，并发系统邮件通知
 */
function goods_give($goods_id,$count=1,$streng=0,$name_color=1,$bind=1,$expiry_type=0,$expiry=0)
{
	return "{give,{$goods_id},{$count},{$streng},{$name_color},{$bind},{$expiry_type},{$expiry}}";
}
/**
 * xml2key
 * @param $string
 */
function xml2key($string) 
{
	$string	  = trim($string);
	$string	  = str_replace('[','\'][',$string);
	$string	  = str_replace(']','][\'',$string);
	$xv		  = str_replace('.','\'][\'',$string);
	if('#' == $xv[0]){
		$xv	  = '[\'#\'][\''.substr($xv,1).'\']';
	}else{
		$xv   = '[\''.str_replace('#','\'][\'#\'][\'',$xv).'\']';
	}
	$xv		  = str_replace('\'][\'[','\'][',$xv);
	$xv		  = str_replace('][\'\'][','][',$xv);
	//echo $xv,'<br />';
	return $xv;
}
/**
 * 数组
 * @param unknown_type $data
 * @return unknown|multitype:unknown |multitype:
 */
function array_format($data)
{
	if(is_array($data))
	{
		if(array_keys($data) === range(0, count($data) - 1)){
			return $data;
		}else{
			return array($data);
		}
	}else{
		return array();
	}
}

function php_plist_write($file_name,$data,$count=1)
{
	$count				 = ceil($count);
	if($count > 1)
	{
		$len				 = count($data);
		$size				 = ceil( $len / $count);
		$data2 				 = array_chunk($data, $size, true);
		foreach ($data2 as $k2=>$v2)
		{
			$file_name2 	 = str_replace('.plist', $k2.'.plist', $file_name);
			
			$pl					 = new \plugins\ToPList($v2);
			$xml_plist_data		 = $pl->xml();
			
			echo $file_name2,"<br />\n";
			file_put_contents($file_name2,$xml_plist_data);
		}
		
	}else 
	{
		$pl					 = new \plugins\ToPList($data);
		$xml_plist_data		 = $pl->xml();
		
		echo $file_name,"<br />\n";
		file_put_contents($file_name,$xml_plist_data);
	}
}
