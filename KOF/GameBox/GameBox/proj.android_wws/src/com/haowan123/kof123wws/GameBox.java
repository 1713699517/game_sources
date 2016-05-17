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
package com.haowan123.kof123wws;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.ptola.GameApp;
import com.ptola.GameVideoHandler;
import com.ptola.GameWebViewHandler;
import com.wws.sdk.WwsLoginActivity;

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
  
    
    private static Activity m_ctxActivity;
	private static GameWebViewHandler m_handler = new GameWebViewHandler();
	private static GameVideoHandler m_videoHandler = new GameVideoHandler();
}
