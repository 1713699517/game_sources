package com.haowan123.kof.wdj;

import java.net.URLEncoder;

import com.haowan123.kof.wdj.GameBox;
import com.haowan123.kof.wdj.R;
import com.ptola.GameUserData;
import com.wandoujia.login.AccountHelper;
import com.wandoujia.paydef.LoginCallBack;
import com.wandoujia.paydef.MSG;
import com.wandoujia.paydef.User;
import com.wandoujia.paydef.WandouAccount;
import com.wandoujia.paysdk.PayConfig;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class StartupActivity extends Activity
{
	private static final int requestCode_wws = 998;
	public static StartupActivity instance = null;
	private static final Long appkey_id = 100000545L;
	private static final String seckey = "b4fe169dfbd3ee9dc30d11fa0b18d1c0";
	 // 初始化账户实例
    WandouAccount account = new AccountHelper();
	protected void onCreate(Bundle savedInstanceState)
	{
		instance = this;
		
		super.onCreate(savedInstanceState);
		
		this.setContentView(R.layout.bg);
		
		PayConfig.init(this, appkey_id, seckey);
		
		account.doLogin(this, new LoginCallBack() {

            @Override
            public void onError(int code, String info) {
                Log.d("wdj", "Demo中登陆失败:" + info);
            }

            @Override
            public void onSuccess(User user, int type) {
                Log.d("wdj", "登陆:" + user);
                //请在游戏创建角色时调用，不要每次登录都使用
                //account.createRole(appContext, user, "gameZone", "roleName");
                
                String uid = String.valueOf( user.getUid() ); 
				GameUserData.setValue( "userName", uid );

			    StartupActivity.instance.finish();
			    
			    Intent cc2dContext = new Intent(StartupActivity.instance, com.haowan123.kof.wdj.GameBox.class);
                startActivity(cc2dContext);
            }
        });
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
                Intent cc2dContext = new Intent(this, com.haowan123.kof.wdj.GameBox.class);
                startActivity(cc2dContext);
			}
		}
		
		super.onActivityResult(requestCode, resultCode, data);
		*/
	}
}
