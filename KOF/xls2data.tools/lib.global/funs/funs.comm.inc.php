<?php
namespace funs\comm;
/**
 * 404
 */
function error_page_404()
{
    header('HTTP/1.1 404 Not Found');
    exit('<html>
            <head><title>404 Not Found</title></head>
            <body bgcolor="white">
            <center><h1>404 Not Found</h1></center>
            <hr><center>nginx</center>
            </body>
            </html>
            <!-- a padding to disable MSIE and Chrome friendly error page -->
            <!-- a padding to disable MSIE and Chrome friendly error page -->
            <!-- a padding to disable MSIE and Chrome friendly error page -->
            <!-- a padding to disable MSIE and Chrome friendly error page -->
            <!-- a padding to disable MSIE and Chrome friendly error page -->
            <!-- a padding to disable MSIE and Chrome friendly error page -->');
}
/**
 * 是否可以上传的文件
 * @param string $loadfilename
 * @return boolean
 */
function is_file_exts($loadfilename)
{
	$ext_name = end(explode(".",strtolower($loadfilename)));
	if (in_array($ext_name,array("png","gif","jpg","swf") ))
	{
		return true;
	}
	return false;
}
/**
 * 创建文件夹
 * @param string $dir
 * @return boolean
 */
function is_dir_check($dir)
{
	return is_dir($dir) || mkdir($dir,0777,true);
}

/**
 * Yrl解析
 * @param string $str
 * @param string $pattern  //  '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/'
 * @param string $fields   //  
 * @return array
 */
function decode_yrl($str,$pattern,$field,$is_attr=true)
{
	$rs      = array();
	$matches = array(); //     1     2         3     4
	//$pattern = '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
	//$pattern = '/\{\{(\d*),(\d*)\},\{(\d*),(\d*)\}\}/';
	$fields	 = explode(',', $field);
	preg_match_all($pattern, $str, $matches, PREG_SET_ORDER);
	foreach ($matches as $v)
	{
		$vs   = array();
		foreach ($fields as $k=>$v2)
		{
			if($v[$k+1] !== "")
			{
				$vs[$v2] = $v[$k+1];
			}
		}
		if($vs)
		{
			$rs[] = $is_attr?array('#'=>$vs):$vs;
		}
	}
	return $rs;
}
