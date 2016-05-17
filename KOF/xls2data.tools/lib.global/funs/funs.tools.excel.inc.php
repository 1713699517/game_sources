<?php 
/** 命名空间 */
namespace funs\excel;

/**
 * 把Excel2007文件读成数组
 * @param String $pFilename
 */
function read($pFilename)
{
	if(!file_exists($pFilename)){
		exit("File \"{$pFilename}\" Not Found");
	}
	$xls_cache_file = Dir_Cache_Excel.md5($pFilename).sha1($pFilename).'.c';
	$sheets	   		= array();
	if(file_exists($xls_cache_file) 
		&& filesize($xls_cache_file)  > 5 
		&& filemtime($xls_cache_file) > filemtime($pFilename) )
	{
		require $xls_cache_file;
	}else
	{
		//$objReader = new PHPExcel_Reader_Excel2007();
		$objReader = new \PHPExcel_Reader_Excel2007();
		$objExcel  = $objReader->load ( $pFilename );
		foreach($objExcel ->getAllSheets() as $sheet)
		{
			$sheets[] = array('title' => $sheet->getTitle(),
							  'data'  => $sheet->toArray() );
		}
		$str = var_export($sheets,true);
		file_put_contents($xls_cache_file,'<?php  $sheets = '.$str.';?>');
	}
	return $sheets;
}

/**
 * 把数组解析成数据
 * @param String $pFilename
 */
function parser_array($sheets)
{
	$REM		= array();
	$NAME		= array();
	$KEY		= '';
	
	$FILE_PLIST = '';
	$FILE_ERL   = '';
	$FILE_XML   = '';
	
	$FIELDS		= array();
	$FIELDS_V	= array();
	$FIELDS_XML	= array();
	
	$PLIST		= array();
	$ERL        = array();
	$XML        = array();
	
	$VALUE			= array();
	$VALUE_PLIST	= array();
	$VALUE_ERL		= array();
	$VALUE_XML		= array();
	foreach($sheets as $sheet)
	{
		//echo '$sheet:';
		//var_dump($sheet);
		foreach ($sheet['data'] as &$rs) 
		{
			$rs[0] 				 = trim($rs[0]);	 
			//echo '$rs[0]:',$rs[0],'<br />';
			switch($rs[0])
			{
				case 'REM':
					$REM[]  	 = trim($rs[1]);
					break;
				case 'KEY':
					$KEY  		 = trim($rs[1]);
					break;
				case 'FILE_PLIST':
					$FILE_PLIST  = trim($rs[1]);
					break;
				case 'FILE_ERL':
					$FILE_ERL    = trim($rs[1]);
					break;
				case 'FILE_XML':
					$FILE_XML    = trim($rs[1]);
					break;
				case 'PLIST':
					foreach ($rs as $k=>$v)
					{
						if($k > 0 && $FIELDS[$k])
						{
							$PLIST[$FIELDS[$k]] = trim($v);
						}
					}
					break;
				case 'ERL':
					foreach ($rs as $k=>$v)
					{
						if($k > 0 && $FIELDS[$k])
						{
							$ERL[$FIELDS[$k]] = trim($v);
						}
					}
					break;
				case 'XML':
					foreach ($rs as $k=>$v)
					{
						$v		= trim($v);
						$v  	= preg_replace('/\s/','',$v);
						if($v)
						{
							$XML[$FIELDS[$k]] = trim($v);
							$FIELDS_XML[$k]   = \funs\tools\xml2key($v);
						}
					};
					break;
				case 'NAME':
					foreach ($rs as $k=>$v)
					{
						if($k > 0 && $FIELDS[$k])
						{
							$NAME[$FIELDS[$k]] = trim($v);
						}
					}
					break;
				case 'FIELDS':
					foreach ($rs as $k=>$v)
					{
						$v				= trim($v);
						if($v)
						{
							$FIELDS[$k]	  = strtolower($v);
							$FIELDS_V[$k] = '["'.str_replace('.', '"]["', $FIELDS[$k]).'"]';
						}
					};
					break;
				case 'VALUE': //属性值所在行
					$_vs 		= array();
					$_vs_plist 	= array();
					$_vs_erl 	= array();
					$_vs_xml 	= array();
					foreach ($rs as $k => $v)
					{					
						if($k > 0 && $FIELDS[$k])
						{
							//$_vs[$FIELDS[$k]] = trim($v);
							//$vk = '["'.str_replace('.', '"]["', $FIELDS[$k]).'"]';
							eval("\$_vs{$FIELDS_V[$k]} = trim(\$v);");
							
							if($PLIST[$FIELDS[$k]] != 'no')
							{
								eval("\$_vs_plist{$FIELDS_V[$k]} = trim(\$v);");
							}
							if($ERL[$FIELDS[$k]] != 'no')
							{
								eval("\$_vs_erl{$FIELDS_V[$k]}	 = trim(\$v);");
							}
							if($XML[$FIELDS[$k]] != 'no')
							{
								eval("\$_vs_xml{$FIELDS_XML[$k]} = trim(\$v);");
							}
						}
					}				
					$VALUE[] 		= $_vs;
					$VALUE_PLIST[] 	= $_vs_plist;
					$VALUE_ERL[] 	= $_vs_erl;
					$VALUE_XML[] 	= $_vs_xml;
					break;
				default : //空行或其他
					break;
			}
		}
	}
	return array(
			'rem'		 => $REM,
			'key'		 => $KEY,
			'name'		 => $NAME,
			
			'file_plist' => $FILE_PLIST,
			'file_erl'   => $FILE_ERL,
			'file_xml'   => $FILE_XML,
			
			'plist'		 => $PLIST,
			'erl'		 => $ERL,
			'xml'		 => $XML,
			
			'value'		 	=> $VALUE,
			'value_plist'	=> $VALUE_PLIST,
			'value_erl'		=> $VALUE_ERL,
			'value_xml'		=> $VALUE_XML,
		);
}