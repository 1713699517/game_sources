<?php
/**
 * 加载tools.inc.php文件
 */
require __DIR__.'/../config.tools/tools.inc.php';

$menu = array();
/**
 * 加载comm.inc.php文件
 */
require Dir_Config .'tools.menu.inc.php';

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<?php echo URL_STATIC?>tool/tool.lib.js"></script>
<style type="text/css">
@charset "utf-8";
body {
	margin:0px;
	color:#F90;
	background-color:#9CF;
	color: #747d67;
	font:12px Arial, Helvetica, sans-serif;
	line-height:18px;
}
.group {
	float:left;
	width:400px;
	padding-top:10px;
	border:#333 dotted 1px;
	margin:10px;
	height:auto;
}
.item {
	border:#096 1px solid;
	margin:5px;
	background-color:#FFF;
	width:380px;
}
.item span {
	padding-left:8px;
}
.item div {
	border-bottom:#eee 2px solid;
	margin:0px;
	padding:8px;
	text-align:left;
}
.item div:hover {
	border-bottom:2px green solid;
	background:#e0e0e0;
	padding:8px;
}
.item input, button {
	border:0px;
	vertical-align:middle;
	margin:8px;
	line-height:18px;
	font-size:12px;
}
.item a:link, a:visited {
	color:grey;
	margin:0 5px 0 5px;
	text-decoration: none;
}
.item a:hover {
	color: #000;
	margin:0 5px 0 5px;
	text-decoration: none;
}
.item a:active {
	color: #528036;
	margin:0 5px 0 5px;
	text-decoration: none;
}
.head {
	padding-left:8px;
	color:#F00;
	font-size:14px;
	margin-top:10px;
	font-size:12px;
	font-weight:bold;
}
.title {
	padding-left:10px;
	color:#333;
	margin-top:10px;
	font-size:12px;
}
</style>
<title>《街机西游》GM工具集</title>
</head>
<body>
<div id="main">
 
  <?php
	foreach ($menu as $group){	
	?>
  <div class="group"> <span class="head"><?php  echo $group['group_name']?></span>
    <?php  foreach ($group as $item) {  if(is_array($item)){?>
    <div class="item">
      <div><font color="red"><?php  echo $item['tag_name']?></font>&nbsp;
        <?php  foreach ($item as $k=>$v) {  if(is_array($v)){?>
        <a href="<?php  echo $k?>" target="<?php  echo $v[0]?>"><?php  echo $v[1]?></a>
        <?php  } }?>
      </div>
    </div>
    <?php  }}?>
  </div>
  <?php  }?>
  <div style="clear:both;"></div>
</div>
</body>
<script>
function uri(url)
{
	document.location.href = url;	
}
</script>
</html>