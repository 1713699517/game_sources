<?php 
/**
 * 加载tools.inc.php文件
 */
require __DIR__.'/../../config.tools/tools.inc.php';
/**
 * 保存
 */
if('save' == $_POST['act'])
{
	\funs\tools\php_data_write('sys', 'update_logs', $_POST['content']);
	\ounun\gouri();
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<?php echo URL_STATIC?>ke/kindeditor-min.js" type="text/javascript" charset="utf-8"></script>
<script src="<?php echo URL_STATIC?>ke/lang/zh_CN.js" type="text/javascript" charset="utf-8"></script>
<style type="text/css">
.master{
	margin:5px 0px 10px 0px;
}
.master div {
	border-bottom:#F63 2px solid;
	background:#FFC;
	margin:0px;
	padding:8px;
	text-align:left;
}
.master div:hover {
	border-bottom:2px #F63 solid;
	background:#FFE;
	padding:8px;
}
</style>
</head>
<title>工具说明</title>
<body>
<div class="master">
	<div>
		<strong>操作：</strong> 
		<?php  
		if('e' == $_GET['act']){
			$back = $_SERVER['HTTP_REFERER']?$_SERVER['HTTP_REFERER']:'/';
		}else{
			$back = '/';
		}		
		?>
		<a href="<?php  echo $back?>">返回</a> &nbsp;&nbsp;
		<a href="?act=e">编辑(更新日志)</a>
	</div>
</div>
<div>
<?php

$c  = \funs\tools\php_data_read('sys', 'update_logs');

if('e' == $_GET['act'])
{
	$c = htmlspecialchars($c);
?>	
<script type="text/javascript">
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="content"]', {
		resizeType : 1,
		allowPreviewEmoticons : false,
		allowImageUpload : false,
		items : [
			'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
			'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
			'insertunorderedlist', '|', 'emoticons', 'image', 'link']
	});
});
</script>
<form method="post">
  <!-- 编辑器调用开始 -->
  <!-- 注意 TEXTAREA 的 NAME 应与 ID=??? 相对应-->
  <textarea name="content" style="width:100%;height:400px;visibility:hidden;"><?php echo $c ?></textarea>
  <!-- 编辑器调用结束 -->
  <input type="hidden" name="act" value="save" />
  <input type="submit" />
  <input type="reset" />
</form>
<?php 
}else
{
	echo $c;
}
?>
</div>
</body>
</html>