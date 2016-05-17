package com.ptola;


import com.haowan123.kof.oppo.nearme.gamecenter.R;
import com.haowan123.kof.oppo.nearme.gamecenter.GameBox;
import com.ptola.GameVideo.OnFinishListener;
import com.ptola.GameVideo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;
import android.view.ViewGroup;

@SuppressLint("UseSparseArrays")
public class GameVideoHandler extends Handler implements OnFinishListener {
	
	private static int VIDEO_TYPE_NOTOUCH = 1;
	private static int VIDEO_TYPE_TOUCH   = 2;
	
	private GameVideo m_gameVedio;
	private ViewGroup m_group;
	private static int m_videoType = 1;
	private static boolean isPlayingVideo = false;
	
	public int getVideoType()
	{
		return m_videoType;
	}
	public void setVideoType(int type)
	{
		m_videoType = type;
	}
	
	public boolean getIsPlayingVideo()
	{
		return isPlayingVideo;
	}
	public void setIsPlayingVideo(boolean bool)
	{
		isPlayingVideo = bool;
	}
	
	public GameVideo getGameVideo()
	{
		return m_gameVedio;
	}
	public void setGameVideo(GameVideo video)
	{
		m_gameVedio = video;
	}
	
	public ViewGroup getViewGroup()
	{
		return m_group;
	}
	public void setViewGroup(ViewGroup group)
	{
		m_group = group;
	}
	
	
	public void playVideo(int type,String name) {
		Log.i("video", "playVideo--> type="+type+"   name="+name);
		
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				
				Activity activity2 = GameBox.getCurrentActivity();
				GameVideoHandler videoHandler = GameBox.getVideoHandler();
				
				Uri uri = Uri.parse("android.resource://" + activity2.getPackageName() + "/" + R.raw.piantou); //
				GameVideo video = new GameVideo(activity2);
				video.setOnFinishListener(GameBox.getVideoHandler());
				video.setVideo(uri);
				
				videoHandler.setIsPlayingVideo(true);
				videoHandler.setGameVideo(video);
				videoHandler.getViewGroup().addView(video);
				
				video.setZOrderMediaOverlay(true);
			}
		};
		
		GameBox.getVideoHandler().setVideoType(type);
		GameBox.getVideoHandler().post(runnable);
		
	}
	@Override
	public void onVideoFinish() {
		Log.i("video", "onVideoFinish");
		GameVideoHandler videoHandler = GameBox.getVideoHandler();
		videoHandler.getViewGroup().removeView(videoHandler.getGameVideo());
		videoHandler.setIsPlayingVideo(false);
		
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				nativeFirstFinish();
			}
		};
		GameBox.getVideoHandler().post(runnable);
	}
	
	public void onVideoTouch()
	{
		Log.i("video", "onVideoTouch  videoType---->"+GameBox.getVideoHandler().getVideoType());
		int videoType = GameBox.getVideoHandler().getVideoType();
		if(videoType == VIDEO_TYPE_TOUCH)
		{
			GameBox.getVideoHandler().onVideoFinish();
		}
	}
	
	public static Object isPlaying()
    {
		Log.i("video", "isPlaying");
		
		GameVideoHandler videoHandler = GameBox.getVideoHandler();
		boolean isplaying = videoHandler.getIsPlayingVideo();
    	if(isplaying == false){
    		Log.i("video", "false");
    		return null;
    	}
    	else{
    		Log.i("video", "true");
    		return 1;
    	}
    }
	
	
	
	public native void nativeFirstFinish();
	
	static
    {
        System.loadLibrary("game");
    }
	
}
