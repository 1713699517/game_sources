package com.ptola;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.haowan123.kof.mi.GameBox;
import com.ptola.GameWebView;

public class GameWebViewClient extends WebViewClient
{
	private GameWebView m_gameWebView;
	public GameWebViewClient(GameWebView view)
	{
		m_gameWebView = view;
	}
	
	public void destory()
	{
		m_gameWebView = null;
	}
	
	public native boolean nativeShouldOverrideUrl(int nId, String url);
	
	public boolean shouldOverrideUrlLoading(WebView view, String url)
	{
		if( m_gameWebView == null )
			return false;
		return nativeShouldOverrideUrl(m_gameWebView.getId(), url);
	}
	
	public void onReceivedError(WebView view, int errorCode, String description, String failingUrl)
	{
		AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(GameBox.getCurrentActivity());
		dialogBuilder.setTitle("Error! "+errorCode);
		dialogBuilder.setMessage(description);
		dialogBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface arg0, int arg1) {
				// TODO Auto-generated method stub
			}
		});
		dialogBuilder.show();
	}
	
	public native void nativeWebViewPageLoaded(int nId, String url, String responseText, String responseHTML);
	
	public void onPageFinished(WebView view, String url)
	{
		view.loadUrl("javascript:window.AndroidWebView.onWebViewPageLoad("+m_gameWebView.getId()+",'"+url+"', document.documentElement.innerText, document.documentElement.innerHTML);");
		//nativeWebViewPageLoaded(m_gameWebView.getId(), url, "aaaa", "bbbb");
		//super.onPageFinished(view, url);
	}
}
