package com.haowan123.kof.nd;

import com.nd.commplatform.NdCommplatform;
import com.nd.commplatform.OnInitCompleteListener;
import com.nd.commplatform.entry.NdAppInfo;
import com.nd.commplatform.gc.widget.NdToolBar;
import com.nd.commplatform.gc.widget.NdToolBarPlace;

import android.app.Application;
import android.content.res.Configuration;



public class InheritApp extends Application {
	
@Override
	public void onConfigurationChanged(Configuration newConfig)
	{
	  super.onConfigurationChanged(newConfig);
	}

	@Override
	public void onCreate() 
	{
	  super.onCreate();
	  initSDK91();
//	  MiAppInfo appInfo = new MiAppInfo();
//	  appInfo.setAppId( 20573 );			//20573
//	  appInfo.setAppKey("1d2ec4d6-dbf5-9568-9afa-5255352b2e42"); 		//1d2ec4d6-dbf5-9568-9afa-5255352b2e42
//	  appInfo.setAppType( MiGameType.online );
//	  appInfo.setPayMode(PayMode.custom); //…Ë÷√Œ™øÏΩ›÷ß∏∂∑Ω Ω(º¥√◊±“”‡∂Ó≤ª◊„ ±,÷±Ω”Ã· æ”√ªß π”√÷ß∏∂±¶≥‰÷µ) //appInfo.setPayMode(PayMode.simple); //»Ù≤ª…Ë÷√,ƒ¨»œŒ™¥Û÷⁄÷ß∏∂
//	  appInfo.setOrientation( ScreenOrientation.horizontal );
//	  MiCommplatform.Init( this, appInfo );
	  //System.out.println("MyApp is called");
	}
	
	// /////////////////////////////////////////////////////////////////////////////
	// 这里开始定义91市场的接入
	// 变量定义，初始化等

	/* 初始化完成监听端口 */
	private OnInitCompleteListener m_onInitCompleteListener = null;
	/* 91的toolbar */
	private NdToolBar m_NDToolBar = null;

	/**
	 * 初始化91SDK，在 onCreate 中调用
	 */
	private void initSDK91() {
		// if(AppPreferences.isDebugMode(this)){
		NdCommplatform.getInstance().ndSetDebugMode(0);// 设置调试模式
		// }

		NdCommplatform.getInstance().ndSetScreenOrientation(
				NdCommplatform.SCREEN_ORIENTATION_AUTO);

		m_onInitCompleteListener = new OnInitCompleteListener() {

			@Override
			protected void onComplete(int ndFlag) {
				switch (ndFlag) {
				case OnInitCompleteListener.FLAG_NORMAL:
					// initActivity(); // 初始化自己的游戏
					int orient = NdCommplatform.SCREEN_ORIENTATION_LANDSCAPE; // 横屏
					NdCommplatform.getInstance().ndSetScreenOrientation(orient);

					break;
				case OnInitCompleteListener.FLAG_FORCE_CLOSE:
				default:
					// 如果还有别的Activity或资源要关闭的在这里处理
					break;
				}
			}

		};

		NdAppInfo appInfo = new NdAppInfo();
		appInfo.setCtx(this);
		appInfo.setAppId(11111);// 应用ID
		appInfo.setAppKey("121212121");// 应用Key
		/*
		 * NdVersionCheckLevelNormal 版本检查失败可以继续进行游戏 NdVersionCheckLevelStrict
		 * 版本检查失败则不能进入游戏 默认取值为NdVersionCheckLevelStrict
		 */
		appInfo.setNdVersionCheckStatus(NdAppInfo.ND_VERSION_CHECK_LEVEL_STRICT);

		StartupActivity m_StartupActivity = new StartupActivity();
		// 初始化91SDK
		NdCommplatform.getInstance().ndInit(m_StartupActivity, appInfo,m_onInitCompleteListener);

		// 创建Toolbar
		if (m_NDToolBar == null) {
			m_NDToolBar = NdToolBar.create(this,
					NdToolBarPlace.NdToolBarRightMid);
		}
		m_NDToolBar.show();
	}

	/**
	 * 清理91数据
	 */
	private void cleanSDK91() {

		// 移除监听
		if (m_onInitCompleteListener != null)
			m_onInitCompleteListener.destroy();

		// 清理工具条
		if (m_NDToolBar != null)
			m_NDToolBar.recycle();
	}
	
	
	@Override
	public void onLowMemory()
	{
	  super.onLowMemory();
	}
	
	@Override
	public void onTerminate()
	{
	  super.onTerminate();
	}
}