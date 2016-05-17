<?php
/** 命名空间 */
namespace ounun;

/** 制表符 **/
define('Tabs',                   "\t");

/** 换行符 **/
define('Newline',                "\r\n");

/** 现在秒数 **/
define('Now_Time',               time());

/** Ounun根目录 */
define('Ounun_Dir', 		 	 \Dir_Lib . 'ounun/');

/** 模板存放目录 */
define('Ounun_Dir_Tpl', 		 \Dir_App . 'templates/');

/** 模块所在目录 */
define('Ounun_Dir_Module', 		 \Dir_App . 'module/');

/**
 * Convert special characters to HTML safe entities.
 *
 * @param string $string to encode
 * @return string
 */
function h($string)
{
	return htmlspecialchars($string, ENT_QUOTES, 'utf-8');
}

/**
 * 得到访客的IP
 *
 * @return string IP
 */
function ip()
{
	if(isset($_SERVER['HTTP_CLIENT_IP']))
	{
		$hdr_ip = stripslashes($_SERVER['HTTP_CLIENT_IP']);
	}
	else
	{
		if(isset($_SERVER['HTTP_X_FORWARDED_FOR']))
		{
			$hdr_ip = stripslashes($_SERVER['HTTP_X_FORWARDED_FOR']);
		}
		else
		{
			$hdr_ip = stripslashes($_SERVER['REMOTE_ADDR']);
		}
	}
	return $hdr_ip;
}
/**
 * 输出URL
 */
function url($url,$data)
{
	$rs = array();
	if(is_array($data))
	{
		foreach ($data as $key => $value)
			$rs[] = $key.'='.urlencode($value);
	}
	return $url.(strstr('?',$url)?'&':'?').implode('&',$rs);
}

/**
 * 得到 原生 URL(去问号后的 QUERY_STRING)
 */
function url_original($uri)
{
	$t = explode('?', $uri, 2);
	return $t[0];
}

/**
 * 通过uri得到mod
 */
function url_to_mod($uri,$root = '/')
{
	// 
	$uri 	= explode($root, $uri, 					2);	
	$uri 	= explode('.', 	 urldecode($uri[1]),	2);
	$uri	= explode('/', 	 $uri[0]);	
	
	$mod	= array();
	foreach ($uri as $v) 
	{
		$v !== '' && $mod[] = $v;
	}
	return $mod;
}
/**
 * iE缓存控制
 *
 * @param int 		$expires		缓存时间 0:为不缓存 单位:s
 * @param string 	$etag			ETag
 * @param int 		$LastModified	最后更新时间
 */
function expires($expires = 0, $etag = '', $LastModified = 0)
{
	if($expires)
	{
		header("Expires: " . gmdate("D, d M Y H:i:s", Now_Time + $expires) . " GMT");
		header("Cache-Control: max-age=" . $expires);
		$LastModified && header("Last-Modified: " . gmdate("D, d M Y H:i:s", $LastModified) . " GMT");
		if($etag)
		{
			if($etag == $_SERVER["HTTP_IF_NONE_MATCH"])
			{
				header("Etag: " . $etag, true, 304);
				exit();
			}
			else
			{
				header("Etag: " . $etag);
			}
		}
	}
	else
	{
		header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
		header("Cache-Control: no-cache, must-revalidate");
		header("Pragma: no-cache");
	}
}

/**
 * Send a HTTP header redirect using "location" or "refresh".
 *
 * @param string $url the URL string
 * @param int $c the HTTP status code
 * @param string $method either location or redirect
 */
/**
 * 頁面跳轉
 *
 * @param string|array $link
 * @param string|boolean $top
 * @param string $note
 */
function gouri($link = '', $top = '', $note = '') //err
{
    if(!$link || $top || $note)
    {
        $note = $note?$note:(($top && strlen($top) > 6)?$top:'');
        $top  = Tabs . (($top && ($top === true || $top == 'top' || $top == 1))?'window.top.':'');
        echo '<script type="text/javascript">' . Newline;
        if(is_array($link))
        {
            $link[0] = $top . "location.href='{$link[0]}';" . Newline;
            $link[1] = $top . "location.href='{$link[1]}';" . Newline;
            $note = $note?$note:'点击“确定”继续操作  点击“取消” 中止操作';
            echo 'if(window.confirm(' . json_encode($note) . ')){' . Newline . $link[0] . '}else{' . Newline . $link[1] . '}' . Newline;
        }
        else
       {
            $replace = $top . "location.href='{$link}';" . Newline;
            echo $link?($note?'if(window.confirm(' . json_encode($note) . ')){' . Newline . $replace . '};':$replace):'window.history.go(-1);' . Newline;
        }
        echo '</script>' . Newline;
    }
    else
   {
    	if(!headers_sent())
    	{
    		header('Location: ' . $link);   
    	}
    	else
    	{
    		echo '<meta http-equiv="refresh" content="0;url=' . $link . '">';
        	//echo '<script type="text/javascript">location.href="'.$link.'"</script>';
    	}
    }
    exit();
}
/**
 * 彈出對話框
 *
 * @param string $msg
 * @param boolean $outer
 * @return string
 */
function msg($msg, $outer = true)
{
	$rs = Newline . 'alert(' . Json_encode($msg) . ');' . Newline;
	if($outer)
	{
		$rs = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' . Newline . '<script type="text/javascript">' . Newline . $rs . Newline . '</script>' . Newline;
	}
	return $rs;
}
/**
 * Filter a valid UTF-8 string so that it contains only words, numbers,
 * dashes, underscores, periods, and spaces - all of which are safe
 * characters to use in file names, URI, XML, JSON, and (X)HTML.
 *
 * @param string $string to clean
 * @param bool $spaces TRUE to allow spaces
 * @return string
 */
function sanitize($string, $spaces = TRUE)
{
	$search = array(
			'/[^\w\-\. ]+/u',			// Remove non safe characters
			'/\s\s+/',					// Remove extra whitespace
			'/\.\.+/', '/--+/', '/__+/'	// Remove duplicate symbols
	);

	$string = preg_replace($search, array(' ', ' ', '.', '-', '_'), $string);

	if( ! $spaces)
	{
		$string = preg_replace('/--+/', '-', str_replace(' ', '-', $string));
	}

	return trim($string, '-._ ');
}


/**
 * Create a SEO friendly URL string from a valid UTF-8 string.
 *
 * @param string $string to filter
 * @return string
 */
function sanitize_url($string)
{
	return urlencode(mb_strtolower(sanitize($string, FALSE)));
}


/**
 * Filter a valid UTF-8 string to be file name safe.
 *
 * @param string $string to filter
 * @return string
 */
function sanitize_filename($string)
{
	return sanitize($string, FALSE);
}

/**
 * Encode a string so it is safe to pass through the URL
 *
 * @param string $string to encode
 * @return string
 */
function base64_url_encode($string = NULL)
{
	return strtr(base64_encode($string), '+/=', '-_~');
}


/**
 * Decode a string passed through the URL
 *
 * @param string $string to decode
 * @return string
 */
function base64_url_decode($string = NULL)
{
	return base64_decode(strtr($string, '-_~', '+/='));
}


/**
 * 基类的基类
 */
class Base
{
	/**
	 * 默认方法
	 */
	public $default_method = Ounun_Default_Method;
	/**
	 * 没定的方法
	 * @param String $method
	 * @param String $arg
	 */
	public function __call($method, $arg)
	{
		header('HTTP/1.1 404 Not Found');
		$default_method = $this->default_method;
		$this->$default_method($arg[0], $method);
	}
	/**
	 * DB 相关
	 * @param sting $key enum:member,goods,admin,msg,help
	 */
	private static $_db = array();
	/**
	 * 返回数据库连接对像
	 *
	 * @param string $key
	 * @return \ounun\Mysql 
	 */
	public static function db($key)
	{
		self::$_db[$key] || self::$_db[$key] = new \ounun\Mysql($GLOBALS['scfg']['db'][$key]);
		self::$_db[$key]->active();
		return self::$_db[$key];
	}
}

/**
 * 构造模块基类 *
 */
class ViewBase extends Base
{
	public function __construct($mod)
	{
		if(!$mod)
		{
			$mod = array($this->default_method);
		}
		$this->$mod [0] ( $mod );		
	}
	/**
	 * Template句柄容器
	 * @var Object
	 */
	protected $_stpl;

	public function Template()
	{
		require  Ounun_Dir. 'Tpl.class.php';
		$this->_stpl = new Tpl(Ounun_Dir_Tpl);
	}
	/**
	 * 赋值
	 * @param string $name
	 * @param mix    $value
	 */
	public function assign($name, $value = '')
	{
		$this->_stpl->assign($name, $value);
	}
	/**
	 * 输出
	 * @param string $filename
	 */
	public function import($filename)
	{
		$this->_stpl->import($filename);
	}
}

/**
 * 世界从这里开始
 */
function start($mod)
{
	// 设时区
	date_default_timezone_set('Asia/Chongqing');
	// 重定义头
	header('Server: IIS7.26');
	header('X-Powered-By: ASP.net/XiaYP');
	// 设定 模块与方法
	if(is_array($mod) && $mod[0])
	{
		$Module				= 'View'.$mod[0];
		$filename 			= Ounun_Dir_Module . $Module . '.class.php';
		if(file_exists($filename))
		{
			array_shift($mod);
		}
		else
		{   // 默认模块
			$Module			= 'View'.Ounun_Default_Module;
			$filename 		= Ounun_Dir_Module . $Module . '.class.php';
		}	
	}
	else
	{ // 默认模块 与 默认方法
		$mod				= array(Ounun_Default_Method);
		$Module				= 'View'.Ounun_Default_Module;
		$filename 			= Ounun_Dir_Module . $Module . '.class.php';
	}
	// 包括模块文件
	require $filename;
	// 初始化类
	$Module  				= '\\module\\'.$Module;
	if(class_exists($Module,false))
	{
		new $Module($mod);
	}
	else
	{
		header('HTTP/1.1 404 Not Found');
		trigger_error("ERROR! Can't find Module:'{$Module}'.", E_USER_ERROR);
	}
}




