package com.ptola;

import java.util.HashMap;
import java.util.Map;

import com.haowan123.kof.oppo.nearme.gamecenter.GameBox;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;

@SuppressLint("UseSparseArrays")
public class GameWebViewHandler extends Handler
{
	private Map<Integer, GameWebView> m_mapWebViews;
	private int m_IdCreator;
	public GameWebViewHandler()
	{
		super();
		m_IdCreator = 1;
		m_mapWebViews = new HashMap<Integer, GameWebView>();
	}
	
	public void destory()
	{
		
	}
	
	public int getCount()
	{
		return m_mapWebViews.size();
	}
	
	public void handleMessage(Message msg)
	{
		switch(msg.what)
		{
		case GameWebViewBridge.MSG_CREATE_WEB_VIEW:
			createWebView();
			break;
		case GameWebViewBridge.MSG_WEBVIEW_SET_POSITION:
			int nIdsetPos = (Integer)msg.obj;
			setPosition(nIdsetPos, (float)msg.arg1, (float)msg.arg2);
			break;
		case GameWebViewBridge.MSG_WEBVIEW_SET_PERFERRED_SIZE:
			int nIdsetSize = (Integer)msg.obj;
			setPreferredSize(nIdsetSize, (float)msg.arg1, (float)msg.arg2);
			break;
		case GameWebViewBridge.MSG_WEBVIEW_LOAD_GET:
			int nIdLoadGet = msg.arg1;
			loadGet(nIdLoadGet, (String)msg.obj);
			break;
		case GameWebViewBridge.MSG_WEBVIEW_LOAD_POST:
			int nIdLoadPost = msg.arg1;
			GameWebViewPostData gwvpd2 = (GameWebViewPostData)msg.obj;
			loadPost(nIdLoadPost, gwvpd2.url, gwvpd2.data);
			break;
		case GameWebViewBridge.MSG_DESTORY_WEB_VIEW:
			int nIdDestory = msg.arg1;
			destoryWebView( nIdDestory );
			break;
		}
	}
	
	private void createWebView()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return;
		GameWebView gwv = new GameWebView(activity);
		m_mapWebViews.put(m_IdCreator, gwv);
		m_IdCreator++;
	}
	
	private void setPreferredSize(int nId, float fWidth, float fHeight)
	{
		GameWebView gwv = m_mapWebViews.get(nId);
		if( gwv != null )
		{
			gwv.setPreferredSize(fWidth, fHeight);
		}
	}
	
	private void setPosition(int nId, float fX, float fY)
	{
		GameWebView gwv = m_mapWebViews.get(nId);
		if( gwv != null )
		{
			gwv.setPosition(fX, fY);
		}
	}
	
	private void loadGet(int nId, String url)
	{
		GameWebView gwv = m_mapWebViews.get(nId);
		if( gwv != null )
		{
			gwv.loadGet(url);
		}
	}
	
	private void loadPost(int nId, String url, byte[] data)
	{
		GameWebView gwv = m_mapWebViews.get(nId);
		if( gwv != null )
		{
			gwv.loadPost(url, data);
		}
	}
		
	private void destoryWebView(int nId)
	{
		GameWebView gwv = m_mapWebViews.get( nId );
		if( gwv != null )
		{
			gwv.destory();
			m_mapWebViews.remove(nId);
		}
	}
}
