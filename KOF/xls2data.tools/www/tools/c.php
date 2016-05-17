<?php 
$textarea2 = '';
if($_POST['textarea'])
{
	$textarea = str_replace(array('<','>','"'), '', $_POST['textarea']);
	$textarea = explode(',', $textarea);
	
	foreach ($textarea as $v)
	{
		$textarea2 .= chr((int)$v);
	}
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>binary_to_string</title>
</head>
<body>
<form id="form1" name="form1" method="post" action="">
  <?php if($textarea2){?>
  <div style="margin:5px; padding:5px; border:1px #03F solid; background-color:#FFC;"><?php echo $textarea2?></div>
  <?php }?>
  <p>
    <textarea name="textarea" id="textarea" cols="45" rows="5"><?php echo $_POST['textarea']?></textarea>
  </p>
  <p>
    <input type="submit" name="button" id="button" value="提交" />
  </p>
  <p>&nbsp;</p>
</form>
<p>&nbsp;</p>
<p style="margin:5px; padding:5px; border:1px #03F solid; background-color:#FCF;">
  <textarea rows="20" cols="80" id="iffff"></textarea>
  <br />
  <button onclick="up()">转大写</button>
  <button onclick="lower()">转小写</button>
  <script type="text/javascript">
function up()
{
	document.getElementById('iffff').value = document.getElementById('iffff').value.toUpperCase();//转大写
}
function lower()
{
	document.getElementById('iffff').value = document.getElementById('iffff').value.toLowerCase();//转小写
}
</script>
</p>
</body>
</html>