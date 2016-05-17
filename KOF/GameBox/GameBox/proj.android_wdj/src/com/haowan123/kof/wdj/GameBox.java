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
package com.haowan123.kof.wdj;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.ptola.GameApp;
import com.ptola.GameUUID;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
import com.wandoujia.paydef.PayCallBack;
import com.wandoujia.paydef.User;
import com.wandoujia.paydef.WandouOrder;
import com.wandoujia.paydef.WandouPay;
import com.wandoujia.paysdkimpl.WandouPayImpl;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.KeyEvent;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

public class GameBox extends Cocos2dxActivity
{
	static WandouPay wandoupay = new WandouPayImpl();
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
	
	protected void onCreate(Bundle savedInstanceState)
	{
		m_ctxActivity = this;
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		super.onCreate(savedInstanceState);
		m_handler = new GameWebViewHandler();
		
		//视频播放
		m_videoHandler = new GameVideoHandler();
		ViewGroup group = (ViewGroup)getWindow().getDecorView();
		m_videoHandler.setViewGroup(group);
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

	money *= 100;

    	Log.i("pay--->", coInfo);
    	
    	WandouOrder order = new WandouOrder(String.valueOf(money), coInfo, (long) money);
        order.out_trade_no = coInfo;
         wandoupay.pay(m_ctxActivity, order, new PayCallBack() {

             @Override
             public void onSuccess(User user, WandouOrder order) {
                 Log.w("DemoPay", "onSuccess:" + order + " status:" + order.status(order.TRADE_SUCCESS));
                 handler.sendEmptyMessage( 10000 );
             }

             @Override
             public void onError(User user, WandouOrder order) {
                 Log.w("DemoPay", "onError:" + order);
                 handler.sendEmptyMessage( 30000 );
             }
         });
    	
    	/*
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
		*/
    }
    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();
}
