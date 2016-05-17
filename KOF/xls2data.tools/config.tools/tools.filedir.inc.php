<?php 
if(file_exists('E:/www_auto/'))
{
	/** 数据输入输出目录 0**/
	define('Dir_Data_Root',   		'E:/www_auto/');
	/** 素材目录 **/
	define('Dir_Material_Root',   	'E:/lib_material/');
	/** 资源目录(前端data) **/
	define('Dir_Resource_Root',     'E:/www/jjxy.res.update/');
	/** 资源目录(web发布) **/
	define('Dir_Release_Root',    	'E:/lib_release/');
}
else 
{
	/** 数据输入输出目录 **/
	define('Dir_Data_Root',   		'/Users/dreamxyp/Desktop/jjxy/www_auto/');
	/** 素材目录 **/
	define('Dir_Material_Root',     '/Users/dreamxyp/Desktop/jjxy/cpp/code/material/');
	/** 资源目录(前端data) **/
	define('Dir_Resource_Root',   	'/Users/dreamxyp/Desktop/jjxy/cpp/code/update/');
	/** 资源目录(web发布) **/
	define('Dir_Release_Root',      '/Users/dreamxyp/Desktop/jjxy/lib/release/');
}

/** 资源目录 **/
define('File_Htpasswd_EXE',     'E:/AppServ/Apache2.2/bin/htpasswd.exe');
/** 资源目录 **/
define('File_Htpasswd_Config',  'E:/sdk/Repositories/htpasswd');
/** 后台数据目录 **/
define('Dir_Data_Cp_Root',		'E:/www/cn.gamecore.jjapi/data/');
