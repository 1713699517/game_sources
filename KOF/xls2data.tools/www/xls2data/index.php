<?php 
/**
 * 加载tools.inc.php文件
 */
require __DIR__.'/../../config.tools/tools.inc.php';


$sheets	= array();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<?php 
/** 同步svn */
\funs\cmd\cmd_exl_data_update();
/**  执行 */
if(empty($_GET['f']))
{
	exit('$_GET[\'f\'] not null');
}
$pFilename					 = Dir_Data_Root . 'data.exl/'.$_GET['f'];
/** 读取xls表里的数据   */
$sheets	   		= \funs\excel\read($pFilename); 
$sheet_count 	= count($sheets);
$export_file	= Dir_App . "xls2data/export.{$_GET['type']}.inc.php";

//echo $export_file;
$export_dir_erl = Dir_Data_Root.'erl.data/';
$export_dir_yrl = Dir_Data_Root.'erl.yrl/';
$export_dir_xml = Dir_Data_Root.'cpp.xml/';
$export_dir_realxml = Dir_Data_Root.'lua.xml/';

if('make' == $_GET['act']  && $_GET['type'] && file_exists($export_file) )
{	 
	echo '<title></title></head><body>';
	/***  同步svn */
	\funs\cmd\cmd_data_update();
	\funs\cmd\cmd_material_update();
	
	require $export_file;
	
	\funs\cmd\cmd_data_xml_zip();
	\funs\cmd\cmd_data_commit($_GET['configc']);
	echo "完成 <a href=\"{$_GET['back']}\" style=\"font-size:12px;\">点击返回</a></body></html>";
	
	exit();
}
/**
 * 加载xls.view.inc.php文件
 */
require Dir_App    		. 'xls2data/view.inc.php';
?>
