package com.haowan123.kof.mi;

import android.app.Application;
import android.content.res.Configuration;

import com.xiaomi.gamecenter.sdk.entry.MiAppInfo;
import com.xiaomi.gamecenter.sdk.entry.MiGameType;
import com.xiaomi.gamecenter.sdk.entry.PayMode;
import com.xiaomi.gamecenter.sdk.entry.ScreenOrientation;
import com.xiaomi.gamecenter.sdk.MiCommplatform;

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
	  
	  MiAppInfo appInfo = new MiAppInfo();
	  appInfo.setAppId( 20573 );			//20573
	  appInfo.setAppKey("1d2ec4d6-dbf5-9568-9afa-5255352b2e42"); 		//1d2ec4d6-dbf5-9568-9afa-5255352b2e42
	  appInfo.setAppType( MiGameType.online );
	  appInfo.setPayMode(PayMode.custom); //…Ë÷√Œ™øÏΩ›÷ß∏∂∑Ω Ω(º¥√◊±“”‡∂Ó≤ª◊„ ±,÷±Ω”Ã· æ”√ªß π”√÷ß∏∂±¶≥‰÷µ) //appInfo.setPayMode(PayMode.simple); //»Ù≤ª…Ë÷√,ƒ¨»œŒ™¥Û÷⁄÷ß∏∂
	  appInfo.setOrientation( ScreenOrientation.horizontal );
	  MiCommplatform.Init( this, appInfo );
	  //System.out.println("MyApp is called");
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