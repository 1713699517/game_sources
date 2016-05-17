package com.ptola;


import java.io.UnsupportedEncodingException;

import com.haowan123.kof.qh.GameBox;

import android.annotation.SuppressLint;
import android.content.Context;
import android.app.Activity;
import android.graphics.Point;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;

import android.widget.FrameLayout;

@SuppressLint("SetJavaScriptEnabled")
public class GameWebView extends FrameLayout {
	private WebView m_webView;
	private GameWebViewClient m_webViewClient;
	private GameWebViewJSObject m_webViewJSObject;
	private int m_Id;
	public static int s_IdCreator = 0;

	
	public GameWebView(Context context) {
		super(context);
		Activity activity = (Activity) GameBox.getCurrentActivity();
		activity.addContentView(this, new FrameLayout.LayoutParams(
				android.view.ViewGroup.LayoutParams.FILL_PARENT,
				android.view.ViewGroup.LayoutParams.FILL_PARENT));
		m_webView = new WebView(activity);
		m_webView.setOnTouchListener(new View.OnTouchListener()
		{
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				switch(event.getAction())
				{
				case MotionEvent.ACTION_DOWN:
				case MotionEvent.ACTION_UP:
					if( !v.hasFocus() )
					{
						v.requestFocus();
					}
					break;
				}
				return false;
			}
		});
		m_webViewClient = new GameWebViewClient(this);
		m_webViewJSObject = new GameWebViewJSObject(m_webViewClient);
		addView(m_webView);
		m_webView.setWebViewClient(m_webViewClient);
		m_webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		m_webView.getSettings().setAppCacheEnabled(false);
		m_webView.getSettings().setJavaScriptEnabled(true);
		m_webView.addJavascriptInterface(m_webViewJSObject, "AndroidWebView");
		s_IdCreator++;
		m_Id = s_IdCreator;
	}

	public int getId()
	{
		return m_Id;
	}
	
	public void destory() {
		m_webViewJSObject.destory();
		m_webViewClient.destory();
		removeView(m_webView);
		m_webView.destroy();
		setVisibility(View.GONE);
	}

	public void loadGet(String url) {
		m_webView.loadUrl(url);
	}

	public void loadPost(String url, byte[] buffer) {
		m_webView.postUrl(url, buffer);
	}

	public String getResponseText() {
		return "";
	}

	public String getResponseHTML() {
		return "";
	}

	public void setPosition(float fX, float fY) {
		FrameLayout.LayoutParams param = (FrameLayout.LayoutParams) m_webView
				.getLayoutParams();
		param.leftMargin = (int) fX;
		param.topMargin = (int) fY;
		m_webView.setLayoutParams(param);
	}

	public void setPreferredSize(float fWidth, float fHeight) {
		FrameLayout.LayoutParams param = (FrameLayout.LayoutParams) m_webView
				.getLayoutParams();
		param.width = (int) fWidth;
		param.height = (int) fHeight;
		m_webView.setLayoutParams(param);
	}

	public Point getPreferredSize() {
		FrameLayout.LayoutParams param = (FrameLayout.LayoutParams) m_webView
				.getLayoutParams();
		return new Point(param.width, param.height);
	}

}