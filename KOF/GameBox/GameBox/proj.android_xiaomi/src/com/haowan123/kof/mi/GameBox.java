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
package com.haowan123.kof.mi;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.ptola.GameApp;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
import com.xiaomi.gamecenter.sdk.MiCommplatform;
import com.xiaomi.gamecenter.sdk.MiErrorCode;
import com.xiaomi.gamecenter.sdk.OnPayProcessListener;
import com.xiaomi.gamecenter.sdk.entry.MiBuyInfoOnline;
//import com.wws.sdk.WwsLoginActivity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.ViewGroup;
import android.widget.Toast;

public class GameBox extends Cocos2dxActivity implements OnPayProcessListener
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
	
	protected void onCreate(Bundle savedInstanceState)
	{
		m_ctxActivity = this;
		super.onCreate(savedInstanceState);
		
		
		//判断wifi是否开启中
//		boolean isWifi = isWifiActive(this);
//		if(isWifi==false)
//		{
//			wifiNotic();
//		}
//		else
//		{
//			m_handler = new GameWebViewHandler();
//		}
		
		m_handler = new GameWebViewHandler();
		
		//video
		m_videoHandler = new GameVideoHandler();
		ViewGroup group = (ViewGroup)getWindow().getDecorView();
		m_videoHandler.setViewGroup(group);
	}
	
	
	public static boolean isWifiActive(Context icontext){
		Context context = icontext.getApplicationContext();    
        ConnectivityManager connectivity = (ConnectivityManager) context    
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo[] info;
        if (connectivity != null) {    
            info = connectivity.getAllNetworkInfo();    
            if (info != null) {    
                for (int i = 0; i < info.length; i++) {    
                    if (info[i].getTypeName().equals("WIFI") && info[i].isConnected()) {    
                        return true;    
                    }    
                }    
            }    
        }    
        return false;   
	}
	
	private void wifiNotic()
	{
		AlertDialog.Builder confirmDialog = new AlertDialog.Builder(this);
		confirmDialog.setTitle("退出");
		confirmDialog.setMessage("wifi没有开启,是否继续?");
		confirmDialog.setPositiveButton("确定", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				//nativeClose();
				m_handler = new GameWebViewHandler();
			}
		});
		confirmDialog.setNegativeButton("退出", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				new GameApp().nativeClose();
			}
		});
		confirmDialog.show();
	}
	
	
	
	private long mExitTime;
	private void confirmExit()
	{
		AlertDialog.Builder confirmDialog = new AlertDialog.Builder(this);
		confirmDialog.setTitle("退出");
		confirmDialog.setMessage("你确定要退出拳皇咆哮?");
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
			  //confirmExit();
			  //return true;
			if(System.currentTimeMillis() - mExitTime > 2000)
			{
				Toast.makeText(this, "再按一次返回键退出拳皇咆哮", Toast.LENGTH_SHORT).show();
				mExitTime = System.currentTimeMillis();
			}
			else
			{
				confirmExit();
			}
			return true;	
		}
		return super.dispatchKeyEvent(event);
	}
	
    static
    {
        System.loadLibrary("game");
    }
    
    public static void recharge(int money, String coInfo)
    {
    	if ( money == 0 )
		{
			return;
		}
    	
    	Log.i("342342342341242342342--->", coInfo);

		MiBuyInfoOnline online = new MiBuyInfoOnline();
		online.setCpOrderId( UUID.randomUUID().toString() );
		online.setCpUserInfo( coInfo );
		online.setMiBi( money );

		try
		{
			MiCommplatform.getInstance().miUniPayOnline( GameBox.getCurrentActivity(), online, (OnPayProcessListener) GameBox.getCurrentActivity() );
		}
		catch ( Exception e )
		{
			e.printStackTrace();
		}
    }
    
    private Handler handler = new Handler()
	{
		@Override
		public void handleMessage( android.os.Message msg )
		{
			switch( msg.what )
			{
				case 10000:
					Toast.makeText( GameBox.this, "购买成功", Toast.LENGTH_SHORT ).show();
				break;
				case 20000:
					Toast.makeText( GameBox.this, "取消购买", Toast.LENGTH_LONG ).show();
				break;
				case 30000:
					Toast.makeText( GameBox.this, "购买失败", Toast.LENGTH_LONG ).show();
				break;
				case 40000:
					Toast.makeText( GameBox.this, "正在执行，不要重复操作", Toast.LENGTH_LONG ).show();
				break;
				case 50000:
					Toast.makeText( GameBox.this, "您还没有登陆，请先登陆", Toast.LENGTH_LONG ).show();
				break;
				default:
				break;
			}
		};
	};
	
	@Override
	public void finishPayProcess(int arg0) {
		// TODO Auto-generated method stub
		if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_SUCCESS )// 成功
		{
			handler.sendEmptyMessage( 10000 );
		}
		else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_CANCEL || arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_PAY_CANCEL )// 取消
		{
			handler.sendEmptyMessage( 20000 );
		}
		else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_PAY_FAILURE )// 失败
		{
			handler.sendEmptyMessage( 30000 );
		}
		else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_ACTION_EXECUTED )
		{
			handler.sendEmptyMessage( 40000 );
		}
		else if( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGIN_FAIL )
		{
			handler.sendEmptyMessage( 50000 );
		}
	}
  
    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	//video
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();
	
}
