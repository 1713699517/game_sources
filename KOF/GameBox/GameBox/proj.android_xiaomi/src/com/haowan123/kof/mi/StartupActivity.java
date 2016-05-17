package com.haowan123.kof.mi;

//import com.haowan123.kof123wws.R;
import com.ptola.GameUserData;
//import com.wws.sdk.WwsLoginActivity;
import com.xiaomi.gamecenter.sdk.MiCommplatform;
import com.xiaomi.gamecenter.sdk.MiErrorCode;
import com.xiaomi.gamecenter.sdk.entry.MiAccountInfo;
import com.xiaomi.gamecenter.sdk.OnLoginProcessListener;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class StartupActivity extends Activity implements OnLoginProcessListener
{
	private static final int requestCode_wws = 998;
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		/*
	    Intent intent = new Intent(this, WwsLoginActivity.class);
	    intent.putExtra("icon", R.drawable.wws_sdk_download);
	    startActivityForResult(intent, requestCode_wws);
	    */
		this.setContentView(R.layout.bg);
		MiCommplatform.getInstance().miLogin( this, this );
	}
	
	
	
	@Override
	public void finishLoginProcess( int arg0, MiAccountInfo arg1)
	{
		switch( arg0 ) 
		{
			case MiErrorCode.MI_XIAOMI_GAMECENTER_SUCCESS : 			// 
				String uid = String.valueOf( arg1.getUid() ); 
				String session = arg1.getSessionId();					// 
				GameUserData.setValue( "userName", uid );		//±£¥Êuid
				
				Intent intent = new Intent( this, GameBox.class);
			    //intent.putExtra("icon", R.drawable.wws_sdk_download);
			    startActivityForResult(intent, requestCode_wws);
			    
			    this.finish();
			    
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGIN_FAIL: 	// µ«¬Ω ß∞‹
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_CANCEL:			// »°œ˚µ«¬º 
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_ACTION_EXECUTED:// µ«¬º≤Ÿ◊˜’˝‘⁄Ω¯––÷– 
				break;
			default :													// µ«¬º ß∞‹
				break;
		}
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
                Intent cc2dContext = new Intent(this, com.haowan123.kof.mi.GameBox.class);
                startActivity(cc2dContext);
			}
		}
		
		super.onActivityResult(requestCode, resultCode, data);
		*/
	}
}
