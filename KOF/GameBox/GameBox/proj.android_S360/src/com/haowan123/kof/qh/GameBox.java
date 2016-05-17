/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.haowan123.kof.qh;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import com.haowan123.kof.qh.R;
import com.ptola.GameApp;
import com.ptola.GameUserData;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
import com.qihoo.gamecenter.sdk.common.IDispatcherCallback;
import com.qihoo.gamecenter.sdk.protocols.pay.ProtocolConfigs;
import com.qihoo.gamecenter.sdk.protocols.pay.ProtocolKeys;
import com.qihoopay.insdk.activity.ContainerActivity;
import com.qihoopay.insdk.matrix.Matrix;
import com.test.sdk.appserver.TokenInfo;
import com.test.sdk.appserver.QihooUserInfo;
import com.test.sdk.common.SdkUserBaseActivity;


//import com.wws.sdk.WwsLoginActivity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Toast;

public class GameBox extends Cocos2dxActivity 
{

	
	public static Activity getCurrentActivity()
	{
		return m_ctxActivity;
	}
	
	public static GameWebViewHandler getHandler()
	{
		return m_handler;
	}
	
	//video
	public static GameVideoHandler getVideoHandler()
	{
		return m_videoHandler;
	}

	public static void setTokenInfo(TokenInfo info)
	{
		m_tokenInfo = info;
	}
	public static TokenInfo getTokenInfo()
	{
		return m_tokenInfo;
	}

	public static void setUserInfo(QihooUserInfo info)
	{
		m_UserInfo = info;
		
	}
	public static QihooUserInfo getUserInfo()
	{
		return m_UserInfo;
	}
	
	public static void setUserId( String strId )
	{
		m_360UserId = strId;
	}
	
	public static String getUserId()
	{
		return m_360UserId;
	}
	
	private static TokenInfo m_tokenInfo;
	private static QihooUserInfo m_UserInfo;
	private static final String TAG = "GameBox";
	//360用户id
	private static String m_360UserId;
	// 登录响应模式：CODE模式。
    protected static final String RESPONSE_TYPE_CODE = "code";
	
	private String m_QihooUserId;
	private String m_AccessToken;
	private String m_MoneyAmount;
	private String m_ExchangeRate;
	private String m_ProductName;
	private String m_ProductId;
	private String m_NotifyUri;
	private String m_AppName;
	private String m_AppUserName;
	private String m_AppUserId;
	private String m_AppExt1;
	private String m_AppExt2;
	private String m_AppOrderId;
	
	protected void onCreate(Bundle savedInstanceState)
	{
		m_ctxActivity = this;
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		super.onCreate(savedInstanceState);
		m_handler = new GameWebViewHandler();
		
		//video
		m_videoHandler = new GameVideoHandler();
		ViewGroup group = (ViewGroup)getWindow().getDecorView();
		m_videoHandler.setViewGroup(group);
		
		if (getUserInfo() != null && getTokenInfo() != null )
		{
			Log.i("浮窗显示啊-->", "sdfsfdsfdsfsfdsds");
			//显示悬浮窗
			doSdkSettings( true );
		}
	}
	
	 /*
     * 悬浮窗设置
     */
    protected void doSdkSettings( boolean isLandScape )
    {
    	Intent intent = getSettingIntent( isLandScape );
    	Matrix.execute( GameBox.this, intent, new IDispatcherCallback(){
    		@Override
    		public void onFinished(String data)
    		{
//    			Log.i("protected void doSdkSettings( boolean isLandScape )","" );
    		}
    		
    	});
    	
    }
  
    /***
    * 生成设置接口的 Intent *
    * @return Intent
    */
    private Intent getSettingIntent(boolean isLandScape) {
    	Bundle bundle = new Bundle();
    	
    	// 界面相关参数,360SDK 界面是否以横屏显示。 
    	bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);
    	bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SETTINGS);
    	
    	Intent intent = new Intent(this, ContainerActivity.class);
    	intent.putExtras(bundle);
    	
    	return intent;
    }
	
    public static void recharge(int money, String sid, String uid)
    {
    	Log.i("entry ->", "sssdfsfsdfdss  recharge!" + sid + uid);
    	if ( money == 0 )
		{
			return;
		}

		 try
		 {
		 	//MiCommplatform.getInstance().miUniPayOnline( GameBox.getCurrentActivity(), online, (OnPayProcessListener) GameBox.getCurrentActivity() );
			 ((GameBox) GameBox.getCurrentActivity()).doSdkPay( Integer.toString(money), sid, uid);
		 }
		 catch ( Exception e )
		 {
		 	e.printStackTrace();
		 }

    }
	
	private void doSdkPay(String money, String sid, String uid) 
	{ // 支付基础参数
		Intent intent = getPayIntent(money, sid, uid);
		// 必需参数,使用 360SDK 的支付模块。 
		intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_PAY);
		// 界面相关参数,360SDK 登录界面背景是否透明。 
		//intent.putExtra(ProtocolKeys.IS_LOGIN_BG_TRANSPARENT, isBgTransparent);
		Matrix.invokeActivity(this, intent, mPayCallback); 
	}
	
	/***
	* 生成调用 360SDK 支付接口基础参数的 Intent * * @param isLandScape
	* @param pay
	* @return Intent
	*/
	protected Intent getPayIntent(String money, String sid, String uid) 
	{ 
		Bundle bundle = new Bundle();
		m_MoneyAmount = String.valueOf( Integer.valueOf(money).intValue() * 100 );	//
		m_AppUserId   = uid;
		
		//Log.i("冲值金额", money + "  uid->" + uid +" appuserid->" + UUID.randomUUID().toString() + "  -->userid->" +getUserId() );
		//QihooPayInfo qihooPay = new QihooPayInfo();//getQihooPayInfo(isFixed);
		bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, false);
		// *** 以下非界面相关参数 *** 
		bundle.putString(ProtocolKeys.ACCESS_TOKEN, GameBox.getTokenInfo().getAccessToken());
		bundle.putString(ProtocolKeys.QIHOO_USER_ID, GameUserData.getValue("userName"));
		bundle.putString(ProtocolKeys.AMOUNT, m_MoneyAmount);
		bundle.putString(ProtocolKeys.RATE, "10");
		bundle.putString(ProtocolKeys.PRODUCT_NAME, String.valueOf(  Integer.valueOf(m_MoneyAmount).intValue() / 10 ) + "钻石");
		bundle.putString(ProtocolKeys.PRODUCT_ID, m_MoneyAmount);
		bundle.putString(ProtocolKeys.NOTIFY_URI, "http://jjapi.appqj.com/api/CReturn/P360Android");
		bundle.putString(ProtocolKeys.APP_NAME, "拳皇咆哮");
		bundle.putString(ProtocolKeys.APP_USER_NAME, GameUserData.getValue("name"));
		bundle.putString(ProtocolKeys.APP_USER_ID, uid);//GameUserData.getValue("userName")
		bundle.putString(ProtocolKeys.APP_EXT_1, sid);
		//bundle.putString(ProtocolKeys.APP_EXT_2, m_AppExt2);
		bundle.putString(ProtocolKeys.APP_ORDER_ID, UUID.randomUUID().toString());
		//bundle.putAll(getCmccSmsPayBundle());
		Intent intent = new Intent(this, ContainerActivity.class); 
		intent.putExtras(bundle);
		return intent; 
	}
	
	// 支付的回调
	private IDispatcherCallback mPayCallback = new IDispatcherCallback() 
	{
		@Override
		public void onFinished(String data) 
		{
			Log.d("aaa", "mPayCallback, data is " + data); 
			JSONObject jsonRes;
			try {
				jsonRes = new JSONObject(data);
				// error_code 状态码:0 支付成功, 1 支付失败,-1 支付取消,-2 支付进行中。 // error_msg 状态描述
				int errorCode = jsonRes.getInt("error_code");
				String errorMsg = jsonRes.getString("error_msg");
				String text = getString(R.string.pay_callback_toast, errorCode, errorMsg);
				Toast.makeText(GameBox.getCurrentActivity(), text, Toast.LENGTH_SHORT).show(); 
			} catch (JSONException e) {
				e.printStackTrace(); 
			}
		} 
	};
	
	
	private long mExitTime;
	private void confirmExit()
	{
		AlertDialog.Builder confirmDialog = new AlertDialog.Builder(this);
		confirmDialog.setTitle("退出");
		confirmDialog.setMessage("确定要退出拳皇咆哮?");
		confirmDialog.setPositiveButton("确定", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				//nativeClose();
				new GameApp().nativeClose();
			}
		});
		confirmDialog.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
		});
		confirmDialog.show();
	}
	
	//public native void nativeClose();
	
	public boolean dispatchKeyEvent(KeyEvent event)
	{
		if( event.getKeyCode() == KeyEvent.KEYCODE_BACK 
				&& event.getAction() == KeyEvent.ACTION_UP )
		{
			if(System.currentTimeMillis() - mExitTime > 2000)
			{
				Toast.makeText(this, "再按一次返回键退出拳皇咆哮", Toast.LENGTH_SHORT).show();
				mExitTime = System.currentTimeMillis();
			}
			else
			{
				//confirmExit();
				doSdkQuit( true );
			}
			return true;
		}
		return super.dispatchKeyEvent(event);
	}
	
    static
    {
        System.loadLibrary("game");
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        Matrix.destroy(this);
        
    }
    
    /**
     * 使用360SDK的退出接口
     *
     * @param isLandScape 是否横屏显示支付界面
     */
    protected void doSdkQuit(boolean isLandScape) {

        Intent intent = getQuitIntent(isLandScape);

        Matrix.invokeActivity(this, intent, mQuitCallback);
    }
    
    /***
     * 生成调用360SDK退出接口的Intent
     *
     * @param isLandScape
     * @return Intent
     */
    private Intent getQuitIntent(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的退出模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_QUIT);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }
    
 // 退出的回调
    private IDispatcherCallback mQuitCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            Log.d(TAG, "mQuitCallback, data is " + data);
            JSONObject json;
            try {
                json = new JSONObject(data);
                int which = json.optInt("which", -1);
                String label = json.optString("label");

//                Toast.makeText(GameBox.this, "按钮标识：" + which + "，按钮描述:" + label,
//                        Toast.LENGTH_LONG).show();

                switch (which) {
                    case 0: // 用户关闭退出界面
                        return;
                    case 1: // 进入论坛
                        // 注意：此处代码模拟游戏finish并杀进程退出的场景，对于不杀进程退出的游戏，直接finish即可。
                    	new GameApp().nativeClose();
                        //finish();
                        break;
                    case 2: // 退出游戏
                        // 注意：此处代码模拟游戏finish并杀进程退出的场景，对于不杀进程退出的游戏，直接finish即可。
                        //doGameKillProcessExit();
                    	new GameApp().nativeClose();
                        break;
                    default:
                        break;
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };
    
    public static void doSdkAccountManager()
    {
    	//切换帐号
    	//doSdkSwitchAccount( true, true );
//    	Toast.makeText(GameBox.this, "切换帐号", Toast.LENGTH_LONG).show();
    	Log.d(TAG, "切换帐号-->");
    }
    
//    /**
//    * 使用 360SDK 的切换账号接口
//    *
//    * @param isLandScape 是否横屏显示登录界面
//    * @param isBgTransparent 是否以透明背景显示登录界面 
//    * 
//    */
//    protected void doSdkSwitchAccount(boolean isLandScape, boolean isBgTransparent)
//    { 
//    	Intent intent = getSwitchAccountIntent(isLandScape, isBgTransparent); 
//    	
//    	Matrix.invokeActivity(this, intent, mAccountSwitchCallback);
//    }
//    
//    /***
//     * 生成调用360SDK切换账号接口的Intent
//     *
//     * @param isLandScape 是否横屏
//     * @param isBgTransparent 是否背景透明
//     * @return Intent
//     */
//    private Intent getSwitchAccountIntent(boolean isLandScape, boolean isBgTransparent) {
//
//        Bundle bundle = new Bundle();
//
//        // 界面相关参数，360SDK界面是否以横屏显示。
//        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);
//
//        // 界面相关参数，360SDK登录界面背景是否透明。
//        bundle.putBoolean(ProtocolKeys.IS_LOGIN_BG_TRANSPARENT, isBgTransparent);
//
//        // *** 以下非界面相关参数 ***
//
//        // 必需参数，登录回应模式：CODE模式，即返回Authorization Code的模式。
//        bundle.putString(ProtocolKeys.RESPONSE_TYPE, RESPONSE_TYPE_CODE);
//
//        // 必需参数，使用360SDK的切换账号模块。
//        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SWITCH_ACCOUNT);
//
//        Intent intent = new Intent(this, ContainerActivity.class);
//        intent.putExtras(bundle);
//
//        return intent;
//    }
//    
// // 切换账号的回调
//    private IDispatcherCallback mAccountSwitchCallback = new IDispatcherCallback() {
//
//        @Override
//        public void onFinished(String data) {
//            Log.d(TAG, "mAccountSwitchCallback, data is " + data);
//            String authorizationCode = parseAuthorizationCode(data);
//            onGotAuthorizationCode(authorizationCode);
//        }
//    };

    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	//video
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();

}
