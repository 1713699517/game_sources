<?php 
if($_GET['m_img_type'])
{
	setcookie('m_img_type',$_GET['m_img_type'],time()+3600*30*24);
	header('Location: '.($_SERVER['HTTP_REFERER']?$_SERVER['HTTP_REFERER']:'/')  );
}

session_start();
/** 制表符 **/
define('Tabs',                       	"\t");

/** 换行符 **/
define('Newline',                  		"\r\n");

/** 现在秒数 **/
define('Now_Time',              		time());
/**
 * 应用程序与根目录 *
 */
define('Dir_Root',   					realpath( dirname(__FILE__). '/../' ). '/');
/**
 * PHPExcel目录 *
 */
define('Dir_PHPExcel',             		Dir_Root . 'lib.excel/');
/**
 * config.tools目录 *
 */
define('Dir_Config',             		Dir_Root . 'config.tools/');
/**
 * lib.cmd目录 *
 */
define('Dir_Lib',             			Dir_Root . 'lib.global/');
/**
 * www目录 *
 */
define('Dir_App',             			Dir_Root . 'www/');
/**
 * www.res目录 *
 */
define('Dir_Res',             			Dir_Root . 'www.res/');
/**
 * Cache_Excel目录 *
 */
define('Dir_Cache',             		Dir_Root . 'cache/');
/**
 * Cache_Excel目录 *
 */
define('Dir_Cache_Data',             	Dir_Cache . 'data/');
/**
 * Cache_Excel目录 *
 */
define('Dir_Cache_Excel',             	Dir_Cache . 'xls/');



/**
 * 加载funs.comm.inc.php文件
 */
require Dir_Lib    		. 'funs/funs.comm.inc.php';
/**
 * 加载funs.tools.inc.php文件
 */
require Dir_Lib    		. 'funs/funs.tools.inc.php';
/**
 * 加载funs.tools.cmd.inc.php文件
 */
require Dir_Lib    		. 'funs/funs.tools.cmd.inc.php';
/**
 * 加载funs.tools.excel.inc.php文件
 */
require Dir_Lib    		. 'funs/funs.tools.excel.inc.php';
/**
 * 加载funs.tools.user.inc.php文件
 */
require Dir_Lib    		. 'funs/funs.tools.user.inc.php';


/**
 * 加载funs.comm.inc.php文件
 */
require Dir_Config    	. 'tools.globals.php';
/**
 * 加载tools.filedir.inc.php文件
 */
require Dir_Config    	. 'tools.filedir.inc.php';

/**
 * 加载Db.class.php文件
 */
require Dir_Lib    		. 'ounun/Mysql.class.php';
/**
 * 加载Page.class.php文件
 */
require Dir_Lib    		. 'ounun/Page.class.php';
/**
 * 加载Page.class.php文件
 */
require Dir_Lib    		. 'plugins/ToPList.class.php';
/**
 * 加载Ounun.php文件
 */
require Dir_Lib    		. 'Ounun.php';



/**
 * 导入Dir_PHP_PHPExcel
 */
require Dir_PHPExcel       . 'PHPExcel/Reader/Excel2007.php';

/** 接口域名 */
/*
 define('Const_Domain_HyAPI',  	 		  'jjapi.gamecore.cn:89');
/*/
define('Const_Domain_HyAPI',  	 		  'jjapi.gamecore.cn:89');
// */
//define('Const_Domain_HyAPI',  	 	  'jjapi.gamecore.cn:89');


/** 本项目的静态地址根目录(CDN) */
//define('Const_Url_Static',  	 		 'http://hyr2.gamecore.cn/');
define('Const_Url_Static_CDN',  	 	 'http://jj.gamecore.cn:89/');

/** 本项目的静态地址根目录(Local) */
//define('Const_Url_Static_Local',  	 'http://hyr2.gamecore.cn/');
define('Const_Url_Static_Local',  	 	 'http://jj.gamecore.cn:89/');

/** 本项目的静态地址根目录(下载文件包CDN) */
define('Const_Url_Static_File_CDN',  	 'http://j.7pk.cn/');

/** 本项目的静态地址根目录(下载文件包Local) */
define('Const_Url_Static_File_Local',  	 'http://jj.gamecore.cn:89/');

/** 本项目的静态地址根目录(后台图片) */
define('Const_Url_Static_Web',  	 	'/r/');
/**
 * 本项目的静态地址根目录(公共)
 */
define('URL_STATIC',  	    			'/r/');
/**
 * 素材目录
*/
define('URL_MATERIAL',  	    		'/m/');
/**
 * 素材目录(图片)
*/
define('URL_MATERIAL_IMAGE_TYPE',  	    $_COOKIE['m_img_type']?$_COOKIE['m_img_type']:'640');
/**
 * 素材目录(图片)(WEB)
 */
define('URL_MATERIAL_IMAGE_TYPE_WEB',  	'web');
/**
 * 素材目录(图片)
*/
define('URL_MATERIAL_IMAGE',  	    	'/1r1/'.URL_MATERIAL_IMAGE_TYPE.'/');
/**
 * 素材目录(图片)(WEB)
 */
define('URL_MATERIAL_IMAGE_WEB',  	    '/1r1/web/');
/**
 * 素材目录(音效)
*/
define('URL_MATERIAL_SOUND',  	    	'/1s1/mp3/');
/**
 * 素材目录(图片)
 */
define('Dir_Material_Root_Image',  	    Dir_Material_Root.'Image@'.URL_MATERIAL_IMAGE_TYPE.'/');
/**
 * 素材目录(图片)(WEB)
 */
define('Dir_Material_Root_Image_Web',  	Dir_Material_Root.'Image@web/');
/**
 * 素材目录(音效)
*/
define('Dir_Material_Root_Sound',  	    Dir_Material_Root.'Sound@mp3/');
/**
 * 数据库
 */
$GLOBALS['scfg']['db']['tool'] = array(
	/* 游戏服务器数据库主机: s<SerID>.<GameCode>.db.gamecore.cn 	*/
    'host'       => 'localhost:3306',
    /* 数据库: gc_serv_<GameCode>_<SerID> 							*/
    'database'   => 'gc_jjxy_tool',
    /* 用户名: 数据库  	*/
    'username'   => 'root',
    /* 用户密码			*/
    'password'   => 'root',
    /* 数据库编码 		*/
    'charset'    => 'utf8'
);

/** 目录转到/index.php下了 */

