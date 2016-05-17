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
package com.haowan.kof;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.ptola.GameApp;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
//import com.wws.sdk.WwsLoginActivity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Toast;

public class GameBox extends Cocos2dxActivity// implements OnPayProcessListener
{

	public static Activity getCurrentActivity()
	{
		return m_ctxActivity;
	}
	
	public static GameWebViewHandler getHandler()
	{
		return m_handler;
	}

	public static GameVideoHandler getVideoHandler()
	{
		return m_videoHandler;
	}

	private static GameVideoHandler m_videoHandler;
	
	
	@Override
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
		
		m_ctxActivity = this;
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		super.onCreate(savedInstanceState);
		m_handler = new GameWebViewHandler();
		
		//视频播放
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
	
	@Override
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

    private static Handler handler = new Handler()
	{
		@Override
		public void handleMessage( android.os.Message msg )
		{
			switch( msg.what )
			{
				case 10000:
					Toast.makeText( m_ctxActivity, "购买成功", Toast.LENGTH_SHORT ).show();
				break;
				case 20000:
					Toast.makeText( m_ctxActivity, "取消购买", Toast.LENGTH_LONG ).show();
				break;
				case 30000:
					Toast.makeText( m_ctxActivity, "购买失败", Toast.LENGTH_LONG ).show();
				break;
				case 40000:
					Toast.makeText( m_ctxActivity, "正在执行，不要重复操作", Toast.LENGTH_LONG ).show();
				break;
				case 50000:
					Toast.makeText( m_ctxActivity, "您还没有登陆，请先登陆", Toast.LENGTH_LONG ).show();
				break;
				case 60000:
					recharge_internal(msg.arg1, (String)msg.obj);
				break;
				default:
				break;
			}
		};
	};
  
	public static void recharge(int money, String coInfo)
	{
		android.os.Message msg = new android.os.Message();
		msg.what = 60000;
		msg.arg1 = money;
		msg.obj = coInfo;
		handler.sendMessage(msg);
	}
	
    public static void recharge_internal(int money, String coInfo)
    {
    	if ( money == 0 )
		{
//			Toast.makeText( OnlineSecActivity.this, "请选择充值金额", Toast.LENGTH_SHORT ).show();
			return;
		}
    	
    	/*
    	if (mBuyCallback == null) {
			mBuyCallback = new NdCallbackListener<NdVirtualPayResult>() {
				@Override
				public void callback(int responseCode, NdVirtualPayResult t) {
					
					//91SDK 支付结果的代码片段
					if (responseCode == NdErrorCode.ND_COM_PLATFORM_SUCCESS) {
						if (t.getErrorCode() == 0) {
							//购买成功
							Toast.makeText( m_ctxActivity, "购买成功", Toast.LENGTH_SHORT ).show();
						} else {
							//显示错误描述 ,也可以显示 ErrorCode
							Toast.makeText(m_ctxActivity, t.getErrDesc(), Toast.LENGTH_LONG).show();
						}
					} else {
						if (t != null) {
							//显示错误描述 ,也可以显示 ErrorCode
							Toast.makeText(m_ctxActivity, t.getErrDesc(), Toast.LENGTH_LONG).show();
						} else {
							if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_CANCEL) {
								Toast.makeText(m_ctxActivity, "取消购买", Toast.LENGTH_LONG).show();
							}  else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_FAILURE) {
								Toast.makeText(m_ctxActivity, "购买失败", Toast.LENGTH_SHORT).show(); 
							} else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_ASYN_SMS_SENT) {
								Toast.makeText(m_ctxActivity, "订单已提交，充值短信已发送", Toast.LENGTH_SHORT).show(); 
							} else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_REQUEST_SUBMITTED) {
								Toast.makeText(m_ctxActivity, "订单已提交", Toast.LENGTH_SHORT).show(); 
							} else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_QUERY_BALANCE_FAIL) {
								Toast.makeText(m_ctxActivity, "虚拟币余额查询失败", Toast.LENGTH_SHORT).show(); 
							} else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_REQUEST_SERIAL_FAIL) {
								Toast.makeText(m_ctxActivity, "获取虚拟商品订单号失败", Toast.LENGTH_SHORT).show(); 
							} else if (responseCode == NdErrorCode.ND_COM_PLATFORM_ERROR_EXIT_FROM_RECHARGE) {
								Toast.makeText(m_ctxActivity, "退出充值界面", Toast.LENGTH_SHORT).show(); 
							} else {
								Toast.makeText(m_ctxActivity, "购买失败", Toast.LENGTH_SHORT).show(); 
							}
						}
					}
				}
			};
		}
		*/
		
    }
    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	
}
