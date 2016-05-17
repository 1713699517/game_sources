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
package com.haowan123.kof.oppo.nearme.gamecenter;

import java.util.Random;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.nearme.gamecenter.open.api.ApiCallback;
import com.nearme.gamecenter.open.api.FixedPayInfo;
import com.nearme.gamecenter.open.api.GameCenterSDK;
import com.nearme.gamecenter.open.api.RatePayInfo;
import com.nearme.gamecenter.open.core.util.Util;

import com.haowan123.kof.oppo.nearme.gamecenter.R;

import com.nearme.oauth.model.NDouProductInfo;
import com.nearme.oauth.model.UserInfo;
import com.ptola.GameApp;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
import com.ptola.GameUserData;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class GameBox extends Cocos2dxActivity //implements OnPayProcessListener
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
	
	private View mHeadView;
	
	private static int Ymoney;
	private static String YcoInfo;
	
	public int  getYmoney()
	{
		return Ymoney;
	}
	public String getYcoInfo()
	{
		return YcoInfo;
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
    /*********************oppo支付**********************************************************************************************/

	private void callFixedKebiPayment(int amount) {
		final FixedPayInfo payInfo = new FixedPayInfo(
				System.currentTimeMillis() + new Random().nextInt(1000) + "",
				"自定义字段", amount);
		payInfo.setProductDesc("商品描述");
		payInfo.setOrder(getYcoInfo());
		payInfo.setProductName("钻石");
		payInfo.setCallbackUrl("http://jjapi.appqj.com/api/CReturn/OppoAndroid");
		payInfo.setGoodsCount(amount*10);
		GameCenterSDK.getInstance().doFixedKebiPayment(kebiPayment, payInfo,
				this);
	}
	
	private void callRateKebiPayment(int amount) {
		final RatePayInfo payInfo = new RatePayInfo(System.currentTimeMillis()
				+ new Random().nextInt(1000) + "", getYcoInfo()+"-"+GameUserData.getValue("userName"));
		payInfo.setProductDesc("商品描述");
		payInfo.setProductName("钻石");
		
		payInfo.setOrder(UUID.randomUUID().toString());
		
		payInfo.setCallbackUrl("http://jjapi.appqj.com/api/CReturn/OppoAndroid");
		payInfo.setRate(10);
		payInfo.setDefaultShowCount(amount*10);
		GameCenterSDK.getInstance().doRateKebiPayment(kebiPayment, payInfo,
				this);
	}
	
	private ApiCallback kebiPayment = new ApiCallback() {
		@Override
		public void onSuccess(String content, int code) {
			Util.makeToast("消耗可币成功:" + content + "#" + code,
					GameBox.this);
			//refreshHeadView();
		}

		@Override
		public void onFailure(String content, int code) {
			Util.makeToast("消耗可币失败:" + content, GameBox.this);
		}
	};
	

	
    /*********************oppo支付*********************************************************************************************************/
	
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
    
    

    
    private Handler handler = new Handler()
	{
		@Override
		public void handleMessage( android.os.Message msg )
		{
			switch( msg.what )
			{
				case 100:
					((GameBox) GameBox.getCurrentActivity()).callRateKebiPayment(getYmoney());
				default:
				break;
			}
		};
	};
	
	public static void recharge(int money, String coInfo)
    {
    	if ( money == 0 )
		{
//			Toast.makeText( OnlineSecActivity.this, "请选择充值金额", Toast.LENGTH_SHORT ).show();
			return;
		}
    	
    	//final int _money = money;
    	Ymoney  = money;
    	YcoInfo = coInfo;
    	
    	Log.i("342342342341242342342--->", coInfo);
		try
		{
			Message createWebViewMsg = new Message();
			createWebViewMsg.what = 100;
			((GameBox) GameBox.getCurrentActivity()).handler.sendMessage(createWebViewMsg);
			
		}
		catch ( Exception e )
		{
			e.printStackTrace();
		}
    }
	
  
    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();
}
