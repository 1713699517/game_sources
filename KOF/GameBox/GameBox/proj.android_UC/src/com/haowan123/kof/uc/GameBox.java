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
package com.haowan123.kof.uc;

import org.cocos2dx.lib.Cocos2dxActivity;

import cn.uc.gamesdk.UCCallbackListener;
import cn.uc.gamesdk.UCCallbackListenerNullException;
import cn.uc.gamesdk.UCFloatButtonCreateException;
import cn.uc.gamesdk.UCGameSDK;
import cn.uc.gamesdk.UCGameSDKStatusCode;
import cn.uc.gamesdk.info.OrderInfo;
import cn.uc.gamesdk.info.PaymentInfo;
import com.haowan123.kof.uc.StartupActivity;

import com.ninegame.ucgamesdk.UCSdkConfig;
import com.ptola.GameApp;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;

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
		
		///视频播放
		m_videoHandler = new GameVideoHandler();
		ViewGroup group = (ViewGroup)getWindow().getDecorView();
		m_videoHandler.setViewGroup(group);
		
		ucSdkFloatButton();
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
				UCGameSDK.defaultSDK().exitSDK();
				System.out.println("exit SDK");
				new GameApp().nativeClose();
				//finish();
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
	
	private void ucSdkFloatButton() {
		this.runOnUiThread(new Runnable() {
			public void run() {
				try {
					// 创建悬浮按钮。该悬浮按钮将悬浮显示在GameActivity页面上，点击时将会展开悬浮菜单，菜单中含有
					// SDK 一些功能的操作入口。
					// 创建完成后，并不自动显示，需要调用showFloatButton(Activity,
					// double, double, boolean)方法进行显示或隐藏。
					UCGameSDK.defaultSDK().createFloatButton(GameBox.this,
							new UCCallbackListener<String>() {

								@Override
								public void callback(int statuscode, String data) {
									Log.d("SelectServerActivity`floatButton Callback",
											"statusCode == " + statuscode
													+ "  data == " + data);
								}
							});
					// 显示悬浮图标，游戏可在某些场景选择隐藏此图标，避免影响游戏体验
					UCGameSDK.defaultSDK().showFloatButton(GameBox.this,
							0, 100, true);

				} catch (UCCallbackListenerNullException e) {
					e.printStackTrace();
				} catch (UCFloatButtonCreateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
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
  
    public static void recharge(int money, String coInfo)
    {
    	if ( money == 0 )
		{
//			Toast.makeText( OnlineSecActivity.this, "请选择充值金额", Toast.LENGTH_SHORT ).show();
			return;
		}

    	Log.i("pay--->", coInfo);
    	
    	float money1 = 0.1f;
    	
    	ucSdkPay(money,coInfo);
    	
    }
    
    private static void ucSdkPay(float money,String coinfo) {
		PaymentInfo pInfo = new PaymentInfo(); // 创建Payment对象，用于传递充值信息

		// 设置充值自定义参数，此参数不作任何处理，
		// 在充值完成后，sdk服务器通知游戏服务器充值结果时原封不动传给游戏服务器传值，字段为服务端回调的callbackInfo字段
		pInfo.setCustomInfo(coinfo);
		

		// 游戏服务器。此参数为可选参数，默认为空。此参数应使用UC分配的serverID进行传值。
		// 或当设置为0 时，会使用初始化时设置的服务器ID。
		// 如此值传入错误，会导致支付界面无法正常打开。
		pInfo.setServerId(UCSdkConfig.serverId);

		/*pInfo.setRoleId("102"); // 设置用户的游戏角色的ID，此为可选参数
		pInfo.setRoleName("游戏角色名"); // 设置用户的游戏角色名字，此为可选参数
		pInfo.setGrade("12"); // 设置用户的游戏角色等级，此为可选参数
		*/

		// 当传入一个amount作为金额值进行调用支付功能时，SDK会根据此amount可用的支付方式显示充值渠道
		// 如你传入6元，则不显示充值卡选项，因为市面上暂时没有6元的充值卡，建议使用可以显示充值卡方式的金额
		pInfo.setAmount(money);// 设置充值金额，此为可选参数

		try {
			UCGameSDK.defaultSDK().pay(m_ctxActivity, pInfo,
					payResultListener);
		} catch (UCCallbackListenerNullException e) {
			// 异常处理
		}

	}
    
    private static UCCallbackListener<OrderInfo> payResultListener = new UCCallbackListener<OrderInfo>() {
		@Override
		public void callback(int statudcode, OrderInfo orderInfo) {
			if (statudcode == UCGameSDKStatusCode.NO_INIT) {
				// 没有初始化就进行登录调用，需要游戏调用SDK初始化方法
			}
			if (statudcode == UCGameSDKStatusCode.SUCCESS) {
				// 成功充值
				if (orderInfo != null) {
					String ordereId = orderInfo.getOrderId();// 获取订单号
					float orderAmount = orderInfo.getOrderAmount();// 获取订单金额
					int payWay = orderInfo.getPayWay();
					String payWayName = orderInfo.getPayWayName();
					System.out.print(ordereId + "," + orderAmount + ","
							+ payWay + "," + payWayName);
				}
			}
			if (statudcode == UCGameSDKStatusCode.PAY_USER_EXIT) {
				// 用户退出充值界面。
			}
		}

	};
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();
}
