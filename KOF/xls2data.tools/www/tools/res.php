<?php
/**
 * 加载tools.inc.php文件
 */
require __DIR__.'/../../config.tools/tools.inc.php';

echo '<html><head><meta http-equiv="Content-Type" content="text/html; char'.'set=gb2'.'312" /></head><body>';
if('ANDROID' == $_GET['act'])
{
    \funs\cmd\cmd_res_android();
}else if('ITOUCH' == $_GET['act'])
{
    \funs\cmd\cmd_res_itouch();
}else if('IPHONE' == $_GET['act'])
{
    \funs\cmd\cmd_res_iphone();
}else if('IPAD' == $_GET['act'])
{
    \funs\cmd\cmd_res_ipad();
}
echo 'Complete  <a href="/index.php" style="font-size:12px;">Go Back </a></body></html>';
exit();

