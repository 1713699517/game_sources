<?php
/** 命名空间 */
namespace funs\cmd; 
/**
 * 应用程序与根目录 *
 */
define('Dir_CMD_Root',          'E:\www_cmd');
//define('Dir_CMD_Res_File',   	'E:\www_auto\material\res_script.cmd');
define('Dir_CMD_Res_File',   	'E:\www_auto\material\copy.script.stop.cmd');
/**
 * 内部
 * @param unknown_type $filename
 * @param unknown_type $msg
 */
function cmd_run($filename,$msg)
{
	if (file_exists($filename))
	{
        $retval = '';
		echo '<pre>';
		echo "\n{$msg}:\n";
		$last_line = system($filename); 
		echo '</pre>';
		'<hr />output: ' . $last_line . ' <hr />Return value: ' . $retval;
	}
}
/**
 * 提交exl表文件
 */
function cmd_exl_data_commit()
{
	$filename = Dir_CMD_Root.'\exl_data_commit.cmd';
	cmd_run($filename,'Commit Exl File');
}
/**
 * 同步exl表文件
 */
function cmd_exl_data_update()
{
	$filename = Dir_CMD_Root.'\exl_data_update.cmd'; 
	cmd_run($filename,'Update Exl File');
}
/**
 * 提交生成好的as3代码
 */
//function cmd_data_code_as3_commit()
function cmd_data_commit($is_configc=false)
{
    if($is_configc)
    {
        /**
         * 加载Db.class.php文件
         */
        require Dir_Lib    		. 'ounun/Xxtea.class.php';

        echo "encode working.......................................<br />\n";
        flush();
        $dir_root = Dir_Data_Root.'lua.xml/';
        $dir_out  = $dir_root.'configc/';
        if(is_dir($dir_root))
        {
            if (false !== ($handle = opendir($dir_root)))
            {
                while (false !== ($file = readdir($handle)))
                {
                    if ( $file != '.' && $file != '..' )
                    {
                        $file_ext  = explode('.',$file);
                        if($file_ext && is_array($file_ext) && count($file_ext) > 1)
                        {
                            $file_ext = $file_ext[count($file_ext)-1];
                        }else
                        {
                            $file_ext = '';
                        }
                        if(!is_dir( $dir_root . $file ) && 'xml' == $file_ext )
                        {
                            $filename	    = $dir_root . $file;
                            $filename_out	= $dir_out . $file;
                            $content        = file_get_contents($filename);
                            $content        = \ounun\Xxtea::encode($content." \n ",'xia1ping85524547');
                            file_put_contents($filename_out,'x'.$content);
                            echo "encode {$file} done! <br />\n";
                            flush();
//                        $content        = file_get_contents($filename_out);
//                        $content        = substr($content,1);
//                        echo \ounun\Xxtea::decode($content,'xia1ping85524547');
//                        exit();
                        }
                    }
                }
            }
        }
    } // end if
    //
	$filename = Dir_CMD_Root.'\data_commit.cmd';
	cmd_run($filename,'Commit Data');
}
/**
 * 同步as3代码
 */
//function cmd_data_code_as3_update()
function cmd_data_update()
{
	$filename = Dir_CMD_Root.'\data_update.cmd';
	cmd_run($filename,'Update Data');
}
/**
 * 提交资源皮肤等
 */
function cmd_resource_commit()
{
	$filename = Dir_CMD_Root.'\resource_commit.cmd';
	cmd_run($filename,'Commit Resource');
}
/**
 * 同步资源皮肤等
 */
function cmd_resource_update()
{
	$filename = Dir_CMD_Root.'\resource_update.cmd';
	cmd_run($filename,'Update Resource');
}
/**
 * 提交美术资源素材
 */
function cmd_material_commit()
{
	$filename = Dir_CMD_Root.'\material_commit.cmd';
	cmd_run($filename,'Commit Material');
}
/**
 * 更新美术资源素材
 */
function cmd_material_update()
{
	$filename = Dir_CMD_Root.'\material_update.cmd';
	cmd_run($filename,'Update Material');
}
/**
 * 编译 服务器data数据
 */
function cmd_make_dev_data()
{
	$filename = Dir_CMD_Root.'\make_dev_data.cmd';
	cmd_run($filename,'Compile Server Data');
}
/**
 * 分批打包xml文件
 */
function cmd_data_xml_zip()
{
	$filename = Dir_CMD_Root.'\zip_data_xml.cmd';
	//cmd_run($filename,'分批打包xml');
}

/**
 * 资源同步
 */
function cmd_res($arg)
{
    if (file_exists(Dir_CMD_Res_File))
    {
        $retval = '';
        echo '<pre>';
        echo "\nUpdate {$arg} Edition Resource:\n";
        $last_line = system(Dir_CMD_Res_File.' '.$arg);
        echo '</pre>';
        '<hr />output: ' . $last_line . ' <hr />Return value: ' . $retval;
    }
}

function cmd_res_android()
{
     cmd_res("ANDROID");
}

function cmd_res_itouch()
{
    cmd_res("ITOUCH");
}

function cmd_res_iphone()
{
    cmd_res("IPHONE");
}

function cmd_res_ipad()
{
    cmd_res("IPAD");
}

?>