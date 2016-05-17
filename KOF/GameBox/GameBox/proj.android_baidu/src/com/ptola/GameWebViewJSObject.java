package com.ptola;

public class GameWebViewJSObject
{
	private GameWebViewClient m_gameWebViewClient;
	public GameWebViewJSObject(GameWebViewClient gameWebViewClient)
	{
		m_gameWebViewClient = gameWebViewClient;
	}
	
	public void destory()
	{
		m_gameWebViewClient = null;
	}
	
	public void onWebViewPageLoad(int nId, String url,String text, String html)
	{
		m_gameWebViewClient.nativeWebViewPageLoaded(nId, url, text, html);
	}
	
	
	
}
