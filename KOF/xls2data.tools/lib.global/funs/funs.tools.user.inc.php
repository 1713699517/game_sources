<?php
/** 命名空间 */
namespace funs\user;
/**
 * 登录
 * @param string $admin
 * @param int $admin_id
 * @param int $admin_type
 */
function login($admin,$admin_id,$admin_type)
{
	$_SESSION['admin'] 		 = $admin;
	$_SESSION['admin_id']	 = $admin_id;
	$_SESSION['admin_type']  = $admin_type;
}
/**
 * 通出登录
 */
function out()
{
	$_SESSION['admin'] 		 = '';
	$_SESSION['admin_id']	 = '';
	$_SESSION['admin_type']  = '';
	session_destroy();
}
/**
 * admin
 * @return string
 */
function get_admin()
{
	return $_SESSION['admin'];
}
/**
 * admin_id
 * @return int
 */
function get_admin_id()
{
	return $_SESSION['admin_id'];
}
/**
 * admin_type
 * @return int
 */
function get_admin_type()
{
	return $_SESSION['admin_type'];
}
?>