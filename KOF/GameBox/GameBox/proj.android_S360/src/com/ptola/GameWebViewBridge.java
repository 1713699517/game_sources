package com.ptola;


import java.io.UnsupportedEncodingException;

import android.app.Activity;
import android.os.Message;
import android.util.Log;

import com.haowan123.kof.qh.GameBox;

public class GameWebViewBridge
{	
	public static final int MSG_CREATE_WEB_VIEW = 1;
	public static final int MSG_WEBVIEW_SET_POSITION = 2;
	public static final int MSG_WEBVIEW_SET_PERFERRED_SIZE = 3;
	public static final int MSG_WEBVIEW_LOAD_GET = 4;
	public static final int MSG_WEBVIEW_LOAD_POST = 5;
	
	public static final int MSG_DESTORY_WEB_VIEW = 7;
	
	
	
	public static int createWebView()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{
			Message createWebViewMsg = new Message();
			createWebViewMsg.what = MSG_CREATE_WEB_VIEW;
			GameBox.getHandler().sendMessage(createWebViewMsg);
			return 1;
		}
		else
		{
			return 0;
		}
	}

	public static void setPosition(int nId, float fX, float fY)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{
			Message setPositionMsg = new Message();
			setPositionMsg.obj = nId;
			setPositionMsg.arg1 = (int)fX;
			setPositionMsg.arg2 = (int)fY;
			setPositionMsg.what = MSG_WEBVIEW_SET_POSITION;
			GameBox.getHandler().sendMessage(setPositionMsg);
		}
	}
	
	public static void setPerferredSize(int nId, float fWidth, float fHeight)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{
			Message setPerferedSizeMsg = new Message();
			setPerferedSizeMsg.obj = nId;
			setPerferedSizeMsg.arg1 = (int)fWidth;
			setPerferedSizeMsg.arg2 = (int)fHeight;
			setPerferedSizeMsg.what = MSG_WEBVIEW_SET_PERFERRED_SIZE;
			GameBox.getHandler().sendMessage(setPerferedSizeMsg);
		}
	}
	
	public static void loadGet(int nId, String url)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{	
			Message loadGetMsg = new Message();
			loadGetMsg.obj = url;
			loadGetMsg.arg1 = nId;
			loadGetMsg.what = MSG_WEBVIEW_LOAD_GET;
			
			GameBox.getHandler().sendMessage(loadGetMsg);
		}
	}
	
	public static void loadPost(int nId, String url, byte[] data)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{
			GameWebViewPostData wvpd = new GameWebViewPostData(url, data);
			
			Message loadPostMsg = new Message();
			loadPostMsg.arg1 = nId;
			loadPostMsg.obj = wvpd;
			loadPostMsg.what = MSG_WEBVIEW_LOAD_POST;
			GameBox.getHandler().sendMessage(loadPostMsg);
		}
	}
		
	public static void destoryWebView(int nId)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity != null )
		{	
			Message destoryWebViewMsg = new Message();
			destoryWebViewMsg.arg1 = nId;
			destoryWebViewMsg.what = MSG_DESTORY_WEB_VIEW;
			GameBox.getHandler().sendMessage(destoryWebViewMsg);
		}
	}
	//private static GameWebViewHandler m_Handler = new GameWebViewHandler();
	
	
	public static String urlEncode(String url)
	{
		String ret = null;
		try {
			ret = java.net.URLEncoder.encode(url, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return ret;
	}
	
	public static String urlDecode(String url)
	{
		String ret = null;
		try {
			ret = java.net.URLDecoder.decode(url, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return ret;
	}
}
