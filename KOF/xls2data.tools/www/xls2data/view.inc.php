
<title>预览Excel:<?php  echo $_GET['f'];?></title>
<link href="<?php echo URL_STATIC?>tool/css/excel.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
var sheet_data  = <?php  echo json_encode($sheets);?>;
var sheet_count = <?php  echo $sheet_count;?>;
function make_alpha_from_numbers(number)
{
	var numeric = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	if(number<numeric.length)
	{
		return numeric[number];
	}else
	{
		var dev = Math.floor(number/numeric.length);
		return make_alpha_from_numbers(dev-1) + make_alpha_from_numbers(number-(dev*numeric.length) );
	}
}
function center_tags(data)
{
	var html = ['<table border="0" cellpadding="0" cellspacing="1" class="table_body" name="tab_table">'];
	html.push('<tr> <td>&nbsp;</td>');
	for(var i=0;i<data[0].length;i++)
	{
		html.push('<td class="table_sub_heading" align="center">'+make_alpha_from_numbers(i)+'</td>');
	}
	html.push('</tr>');
	for(var i=0;i<data.length;i++)
	{
		html.push('<tr><td class="table_sub_heading">'+(i)+'</td>');
		var rows = data[i];
		for(var j=0;j<rows.length;j++)
		{
			var d = null == rows[j] ?'':rows[j] ;
			html.push('<td class="table_data">'+d+'</td>');
		}
		html.push('</tr>');
	}
	html.push('</table>');
	return html.join('');
}
function change_tabs(sheet)
{
	//alert('sheet_tab_' + sheet);
	for(i=0;i<sheet_count;i++)
	{
		document.getElementById('sheet_tab_' + i).className	= 'tab_base';
	}
	document.getElementById('table_loader_div').innerHTML	= center_tags(sheet_data[sheet]['data']);
	document.getElementById('sheet_tab_' + sheet).className	= 'tab_loaded';
}
</script>
<style type="text/css">
body
{
	background-color:#9CF;
}
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


<body>
<div class="master">
	<div>
		<strong>操作：</strong> 
		<?php  
		$back = $_SERVER['HTTP_REFERER']?$_SERVER['HTTP_REFERER']:'/';
		?>
		<a href="<?php  echo $back?>">返回</a> &nbsp;&nbsp;
		<a href="?act=make&type=<?php  echo $_GET['type']?>&f=<?php  echo $_GET['f']?>&back=<?php  echo urlencode($back)?>&configc=0">导入/生成数据(快)</a>
        <a href="?act=make&type=<?php  echo $_GET['type']?>&f=<?php  echo $_GET['f']?>&back=<?php  echo urlencode($back)?>&configc=1">导入/生成数据(并刷新加密文件慢)</a>
	</div>
</div>
<table border="0" cellpadding="0" cellspacing="1" class="table_body" name="tab_table">
  <tr>
  	<?php  foreach($sheets as $id => $sheet){?>
    <td class="tab_base" id="sheet_tab_<?php  echo $id?>" align="center" onmousedown="change_tabs(<?php  echo $id?>);"><?php  echo $sheet['title']?>&nbsp;</td>
    <?php  }?>
  </tr>
</table>
<div id="table_loader_div"></div>
<script type="text/javascript">
change_tabs(0);
</script>
</body>
</html>