package com.haowan123.kof.nd;

//import com.haowan123.kof123wws.R;
import org.json.JSONException;
import org.json.JSONObject;

import com.nd.commplatform.NdCommplatform;
import com.nd.commplatform.NdErrorCode;
import com.nd.commplatform.OnInitCompleteListener;
import com.nd.commplatform.NdMiscCallbackListener.OnLoginProcessListener;
import com.nd.commplatform.entry.NdAppInfo;
import com.nd.commplatform.gc.widget.NdToolBar;
import com.nd.commplatform.gc.widget.NdToolBarPlace;
import com.ptola.GameUserData;
import com.haowan123.kof.nd.R;
import com.haowan123.kof.nd.GameBox;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class StartupActivity extends Activity //implements OnLoginProcessListener
{
	private static final int requestCode_wws = 998;
	
	private StartupActivity actInstance = this;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		this.setContentView(R.layout.bg);
		initSDK91();
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
			
			Log.i("aaaaaaaaaaa", "------>>   1");
			
			NdCommplatform.getInstance().ndSetDebugMode(0);// 设置调试模式
			// }

			NdCommplatform.getInstance().ndSetScreenOrientation(
					NdCommplatform.SCREEN_ORIENTATION_AUTO);

			m_onInitCompleteListener = new OnInitCompleteListener() {

				@Override
				protected void onComplete(int ndFlag) {
					
					Log.i("aaaaaaaaaaa", "-----------  OK");
					
					
					switch (ndFlag) {
					case OnInitCompleteListener.FLAG_NORMAL:
						// initActivity(); // 初始化自己的游戏
						int orient = NdCommplatform.SCREEN_ORIENTATION_LANDSCAPE; // 横屏
						NdCommplatform.getInstance().ndSetScreenOrientation(orient);
						SDKND91AccountLogin();
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
			appInfo.setAppId(110228);// 应用ID
			appInfo.setAppKey("c55eb29737a11d96317d64b4d715831e8d5c166bcf3cadff");// 应用Key
			/*
			 * NdVersionCheckLevelNormal 版本检查失败可以继续进行游戏 NdVersionCheckLevelStrict
			 * 版本检查失败则不能进入游戏 默认取值为NdVersionCheckLevelStrict
			 */
			appInfo.setNdVersionCheckStatus(NdAppInfo.ND_VERSION_CHECK_LEVEL_NORMAL);

			// 初始化91SDK
			NdCommplatform.getInstance().ndInit(this, appInfo,m_onInitCompleteListener);

			// 创建Toolbar
			if (m_NDToolBar == null) {
				m_NDToolBar = NdToolBar.create(this,
						NdToolBarPlace.NdToolBarRightMid);
			}
			
			Log.i("aaaaaaaaaaa", "------>>   2");
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
		
	
	
	// 登录监听
	private OnLoginProcessListener m_onLoginProcessListener = null;

	/**
	 * 91帐号登录
	 * 
	 */
	private void SDKND91AccountLogin() {
		
		Activity act = this;
		m_onLoginProcessListener = new OnLoginProcessListener() {
			@Override
			public void finishLoginProcess(int code) {
				
				String tip = "";
				// hideLoading();
				JSONObject prms = new JSONObject();

				// 得到用户昵称
				try {
					// 设置请求业务类型为登录请求
					prms.put("requestType", 11);
					prms.put("retcode", "-1");
					// 登录的返回码检查
					if (code == NdErrorCode.ND_COM_PLATFORM_SUCCESS) {
						// 得到用户信息，返回到cocos2dx中
						tip = "登录成功";

						prms.put("retcode", "0");
						prms.put("nickname", NdCommplatform.getInstance()
								.getLoginNickName());
						prms.put("account", "91_"
								+ NdCommplatform.getInstance().getLoginUin());
						
						//保存userName
						String Uin = NdCommplatform.getInstance().getLoginUin();
						GameUserData.setValue( "userName", Uin );
			
						Intent intent = new Intent(actInstance, GameBox.class);//( this, GameBox.class);
					    //intent.putExtra("icon", R.drawable.wws_sdk_download);
					    //startActivityForResult(intent, requestCode_wws);
						startActivity(intent);
					    
					    actInstance.finish();
					    
						// 账号登录成功，测试可用初始化玩家游戏数据
						// 有购买漏单的此时可向玩家补发相关的道具
					} else if (code == NdErrorCode.ND_COM_PLATFORM_ERROR_CANCEL) {
						tip = "取消登录";
					} else {
						tip = "登录失败，错误代码：" + code;
					}
					// 把数据返回给客户端
//					AndroidNDKHelper.SendMessageWithParameters(Constants.SDKBussinessCallback, prms);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Toast.makeText(actInstance, tip, Toast.LENGTH_SHORT).show();
			}
		};
		// showLoading();
		NdCommplatform.getInstance().ndLogin(this, m_onLoginProcessListener);
	}
	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode,Intent data)
	{
	
		/*
		
		if( requestCode == requestCode_wws )
		{
			if( resultCode == com.wws.sdk.WwsLoginActivity.WWS_SDK_Longin_RESOUT )
			{
				Bundle bundle = data.getExtras();
				String userName= bundle.getString("userName");
				String time= bundle.getString("time");
				String url = bundle.getString("url");
				String stata = bundle.getString("stata");
                String serverData= bundle.getString("serverData");
                Log.i("TAG","---->"+userName+":"+time+":"+url+":"+stata+":"+serverData);
                this.finish();
                GameUserData.setValue("userName", userName);
                Intent cc2dContext = new Intent(this, com.haowan123.jjxy.mi.GameBox.class);
                startActivity(cc2dContext);
			}
		}
		
		super.onActivityResult(requestCode, resultCode, data);
		*/
	}
}
