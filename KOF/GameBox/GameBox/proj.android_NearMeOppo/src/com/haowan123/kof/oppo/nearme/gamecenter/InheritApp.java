package com.haowan123.kof.oppo.nearme.gamecenter;

import com.nearme.gamecenter.open.api.GameCenterSDK;
import com.nearme.gamecenter.open.api.GameCenterSettings;

import android.app.Application;
import android.content.res.Configuration;
import android.util.Log;

//import com.xiaomi.gamecenter.sdk.entry.MiAppInfo;
//import com.xiaomi.gamecenter.sdk.entry.MiGameType;
//import com.xiaomi.gamecenter.sdk.entry.PayMode;
//import com.xiaomi.gamecenter.sdk.entry.ScreenOrientation;
//import com.xiaomi.gamecenter.sdk.MiCommplatform;

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
	  initSDK();
//	  MiAppInfo appInfo = new MiAppInfo();
//	  appInfo.setAppId( 20573 );			//20573
//	  appInfo.setAppKey("1d2ec4d6-dbf5-9568-9afa-5255352b2e42"); 		//1d2ec4d6-dbf5-9568-9afa-5255352b2e42
//	  appInfo.setAppType( MiGameType.online );
//	  appInfo.setPayMode(PayMode.custom); //…Ë÷√Œ™øÏΩ›÷ß∏∂∑Ω Ω(º¥√◊±“”‡∂Ó≤ª◊„ ±,÷±Ω”Ã· æ”√ªß π”√÷ß∏∂±¶≥‰÷µ) //appInfo.setPayMode(PayMode.simple); //»Ù≤ª…Ë÷√,ƒ¨»œŒ™¥Û÷⁄÷ß∏∂
//	  appInfo.setOrientation( ScreenOrientation.horizontal );
//	  MiCommplatform.Init( this, appInfo );
	  //System.out.println("MyApp is called");
	}
	
	private void initSDK() {
		// 测试用的appkey和secret
		// TODO 这个里的为测试key和secret，请务必替换为正式的！
		GameCenterSettings gameCenterSettings = new GameCenterSettings(
				"7BGWf5D6Yh44k4wsC8CKw80sc", "Eb502D28519107e86166331F33511042") {

			@Override
			public void onForceReLogin() {
				// sdk由于某些原因登出,此方法通知cp,cp需要在此处清理当前的登录状态并重新请求登录.
				// 可以发广播通知页面重新登录
			}
			
			@Override 
			public void onForceUpgradeCancel() {
				// 游戏自升级，后台有设置为强制升级，用户点击取消时的回调函数。
				// 若开启强制升级模式 ，  一般要求不更新则强制退出游戏并杀掉进程。
				// System.exit(0) or kill this process
			}
		};
		// TODO for test old
//		AccountAgent.useNewApi = true;
		GameCenterSettings.isDebugModel = false;// 测试log开关 //
		GameCenterSettings.isOritationPort = false;// 控制SDK activity的横竖屏 true为竖屏
		// 游戏自身 虚拟货币和人民币的 汇率  当申请的支付类型为人民币直冲时将起作用
		
		GameCenterSettings.rate = "10"; // 1元人民币兑换1000虚拟货币
		Log.i("god god","---->"+GameCenterSettings.rate);
		GameCenterSDK.init(gameCenterSettings, this);
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