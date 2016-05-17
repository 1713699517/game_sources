package com.ptola;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import com.haowan123.kof.uc.GameBox;

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
		super.handleMessage(msg);
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
		case GameWebViewBridge.MSG_UCCONNECTVERIFY:
			String sid = (String) msg.obj;
			//confirmConnect(sid);
			break;
		}
	}
	
	/*public String MD5(String string) {
		byte[] hash;
		try {
		hash = MessageDigest.getInstance("MD5").digest(
		string.getBytes("UTF-8"));
		} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
		return null;
		} catch (UnsupportedEncodingException e) {
		e.printStackTrace();
		return null;
		}


		StringBuilder hex = new StringBuilder(hash.length * 2);
		for (byte b : hash) {
		if ((b & 0xFF) < 0x10)
		hex.append("0");
		hex.append(Integer.toHexString(b & 0xFF));
		}
		return hex.toString();// 32浣�	
	}
	
	private void confirmConnect(String sid)
	{
		URL url = null;
		long time =System.currentTimeMillis() / 1000;
		String urlStr = "http://jjapi.gamecore.cn:89/api/CReturn/UcAndroidLogin?cid=23184&uc_sid="+sid+"&time="+Long.toString(time)+"&sign=";

		String signStr = "cid=23184&uc_sid=" + sid + "&time=" + Long.toString(time) + "&key=7c3b2b17bba0bc56cef3ef0444ef7562";
		String MD5Str = MD5(signStr);
		urlStr += MD5Str;
		
		System.out.println("connectionURLconnectionURLconnectionURL");
		System.out.println(urlStr);
		
		try {
			url = new URL(urlStr);
			System.out.println("connectionURLconnectionURLconnectionURL1111");
		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		HttpURLConnection connection = null;
		try {
			connection = (HttpURLConnection) url.openConnection();
			System.out.println("connectionURLconnectionURLconnectionURL2222");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			connection.setRequestMethod("GET");
			System.out.println("connectionURLconnectionURLconnectionURL4444");
		} catch (ProtocolException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
			connection.connect();
			System.out.println("connectionURLconnectionURLconnectionURL3333");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
	
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
