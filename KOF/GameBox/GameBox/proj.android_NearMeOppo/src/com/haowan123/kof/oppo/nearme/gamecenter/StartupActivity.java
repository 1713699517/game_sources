package com.haowan123.kof.oppo.nearme.gamecenter;

//import com.haowan123.kof123wws.R;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.nearme.gamecenter.open.api.ApiCallback;
import com.nearme.gamecenter.open.api.GameCenterSDK;


import com.haowan123.kof.oppo.nearme.gamecenter.Util;



import com.ptola.GameUserData;
//import com.wws.sdk.WwsLoginActivity;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class StartupActivity extends Activity 
{
	private List<Entry> mTestBeans = new ArrayList<Entry>();
	private Context mContext;
	private StartupActivity actInstance = this;
	
	private static final int requestCode_wws = 998;
	protected void onCreate(Bundle savedInstanceState)
	{
		
		super.onCreate(savedInstanceState);
		GameCenterSDK.setmCurrentContext(this);
		mContext = this;
		Log.i("001TAGjunjun","---->");

		initApi();

		
		/*
	    Intent intent = new Intent(this, WwsLoginActivity.class);
	    intent.putExtra("icon", R.drawable.wws_sdk_download);
	    startActivityForResult(intent, requestCode_wws);
	    */
//		this.setContentView(R.layout.bg);
		
		
		//MiCommplatform.getInstance().miLogin( this, this );
		
		
	}
	private abstract class ApiTestBean implements Entry {

		private String mDescription;

		private ApiTestBean(final String description) {
			mDescription = description;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see
		 * com.nearme.gamecenter.open.demo.nearme.gamecenter.OpenSDKDemoNewActivity
		 * .Entry#getDescription()
		 */
		@Override
		public String getDescription() {
			return mDescription;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see java.lang.Object#toString()
		 */
		@Override
		public String toString() {
			return getDescription();
		}

	}

	
	private interface Entry {

		public String toString();

		public String getDescription();

		public void run();
	}
	
	private final void makeToast(String message) {
		Toast.makeText(this, message, Toast.LENGTH_LONG).show();
	}

	private void initApi() {
		Log.i("002TAGjunjun","---->");
		//GameCenterSDK.setmCurrentContext(this);
		GameCenterSDK.getInstance().doLogin(new ApiCallback() {
		@Override
		public void onSuccess(String content, int code){
			initGetUserInfo();
					//登录成功,CP自行处理
		//网游登录逻辑(利用token验证用户的合法性为可选):
		//1.doLogin接口成功后调用doGetUerInfo获取用户信息和				获取accesstoken(doGetAccessToken())
		//2.利用返回用户信息中的ID和accesstoken登录或者注册到游戏服务器.
		//3.提示用户登录成功,开始游戏.
			}
			@Override
		public void onFailure(String content, int code){  
		//登录失败,CP自行处理
		}}, this);

	}
	
	private void initGetUserInfo() {
		Log.i("003TAGjunjun","---->");
		final String des = "API_doGetUserInfo_获取用户信息";
		
//		GameCenterSDK.getInstance().doGetUserInfo(new ApiCallback() {
//			@Override
//			public void onSuccess(String arg0, int arg1) {
//				makeToast("获取用户信息成功:" + arg0 + "#" + arg1);
//				try {
//					JSONObject jsonObject = new JSONObject(arg0);
//					@SuppressWarnings("unused")
//					String username = jsonObject.getJSONObject(
//							"BriefUser").getString("userName");
//					GameUserData.setValue("userName", username);
//					
//					Intent intent = new Intent(actInstance, GameBox.class);//( this, GameBox.class);
//				    //intent.putExtra("icon", R.drawable.wws_sdk_download);
//				    startActivityForResult(intent, requestCode_wws);
//				    
//				    actInstance.finish();
//					
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//
//			@Override
//			public void onFailure(String arg0, int code) {
//				makeToast("获取用户信息失败:" + arg0 + "#" + code);
//			}
//		});
		
		//final Entry bean = new ApiTestBean(des) {

			//@Override
			//public void run() {

				GameCenterSDK.getInstance().doGetUserInfo(new ApiCallback() {
					@Override
					public void onSuccess(String arg0, int arg1) {
						//makeToast("获取用户信息成功:" + arg0 + "#" + arg1);
						try {
							JSONObject jsonObject = new JSONObject(arg0);
							@SuppressWarnings("unused")
							String username = jsonObject.getJSONObject(
									"BriefUser").getString("userName");
							GameUserData.setValue("userName", username);
						    actInstance.finish();
							
							Intent intent = new Intent(actInstance, GameBox.class);//( this, GameBox.class);
						    //intent.putExtra("icon", R.drawable.wws_sdk_download);
						    //startActivityForResult(intent, requestCode_wws);
							Log.i("TAGjunjun","---->"+username);
						    startActivity(intent);
							
						} catch (Exception e) {
							e.printStackTrace();
						}
					}

					@Override
					public void onFailure(String arg0, int code) {
						makeToast("获取用户信息失败:" + arg0 + "#" + code);
					}
				}, StartupActivity.this);
		//	}
		//};
		//mTestBeans.add(bean);
	}
	
	
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
