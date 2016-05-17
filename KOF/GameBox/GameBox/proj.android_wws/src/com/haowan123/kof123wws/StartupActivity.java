package com.haowan123.kof123wws;

import com.ptola.GameUserData;
import com.wws.sdk.WwsLoginActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class StartupActivity extends Activity
{
	private static final int requestCode_wws = 998;
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

	    Intent intent = new Intent(this, WwsLoginActivity.class);
	    intent.putExtra("icon", R.drawable.wws_sdk_download);
	    startActivityForResult(intent, requestCode_wws);
	}
	
	protected void onActivityResult(int requestCode, int resultCode,Intent data)
	{
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
                Intent cc2dContext = new Intent(this, com.haowan123.kof123wws.GameBox.class);
                startActivity(cc2dContext);
			}
		}
		
		super.onActivityResult(requestCode, resultCode, data);
	}
}
