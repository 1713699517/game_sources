package com.ptola;

import java.io.FileDescriptor;
import java.io.IOException;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import com.haowan123.kof.nd.GameBox;

/**
 * 
 * @author Yichou
 *
 * create data:2013-4-22 22:19:49
 */
public class GameVideo extends SurfaceView implements 
			SurfaceHolder.Callback, 
			View.OnTouchListener, 
			MediaPlayer.OnPreparedListener, 
			MediaPlayer.OnErrorListener, 
			MediaPlayer.OnInfoListener,
			MediaPlayer.OnCompletionListener {
	private static final String TAG = "VideoView";
	
	private MediaPlayer mPlayer; // MediaPlayer锟斤拷锟斤拷��斤拷锟姐��锟�
	private Activity gameActivity;
	private Uri resUri;
	private AssetFileDescriptor fd;
	private boolean surfaceCreated;
	private OnFinishListener onFinishListener;
	

	public GameVideo(Activity context) {
		super(context);

		this.gameActivity = context;

		final SurfaceHolder holder = getHolder();
		holder.addCallback(this); // 锟斤拷锟斤拷��斤拷锟斤拷锟界喊锟斤拷锟斤拷锟斤拷���锟�
		holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS); // 锟斤拷锟斤拷��斤拷锟姐��锟芥��锟�uffer锟斤拷锟斤拷��斤拷锟界��锟斤拷��斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟姐��锟芥０锟�Camera妫帮拷锟斤拷���锟斤拷锟斤拷锟斤拷		
		setOnTouchListener(this);

		mPlayer = new MediaPlayer();
//		mPlayer.setDisplay(getHolder()); //锟斤拷锟斤拷���锟�holder锟斤拷锟斤拷���锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟斤拷锟芥�����锟斤拷锟斤拷锟界�斤拷锟姐��锟�
		mPlayer.setScreenOnWhilePlaying(true);

		mPlayer.setOnPreparedListener(this);
		mPlayer.setOnCompletionListener(this);
		mPlayer.setOnErrorListener(this);
		mPlayer.setOnInfoListener(this);
	}
	
	public GameVideo setOnFinishListener(OnFinishListener onFinishListener) {
		this.onFinishListener = onFinishListener;
		
		return this;
	}

	public void setVideo(Uri resUri) {
		this.resUri = resUri;

		try {
			mPlayer.setDataSource(gameActivity, resUri);
		} catch (Exception e) {
		}
	}
	
	public void setVideo(AssetFileDescriptor fd) {
		this.fd = fd;

		try {
			//锟芥��锟斤拷��э拷锟界�斤拷锟姐��锟� fd.getFileDescriptor() 锟斤拷锟界����锟斤拷锟斤拷绾帮拷锟�
			mPlayer.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
	}

	@Override
	public void surfaceCreated(final SurfaceHolder holder) {
		Log.i(TAG, "surfaceCreated");

		surfaceCreated = true;

		mPlayer.setDisplay(holder); // 锟斤拷锟斤拷���锟�SurfaceHolder
		try {
			mPlayer.prepare();
		} catch (Exception e1) {
		}
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		Log.i(TAG, "surfaceDestroyed");
		surfaceCreated = false;
		
		if(mPlayer != null){
			mPlayer.stop();
			mPlayer.reset();
		}
	}

	@Override
	public void onPrepared(MediaPlayer player) {
		Log.i(TAG, "onPrepared");

		int wWidth = getWidth();
		int wHeight = getHeight();

		/* 锟斤拷锟斤拷��斤拷锟姐��锟斤拷锟斤拷绾帮拷锟�? */
		int vWidth = mPlayer.getVideoWidth();
		int vHeight = mPlayer.getVideoHeight();

		/* 锟斤拷锟斤拷��斤拷锟姐��锟斤拷锟斤拷锟藉嘲锟� */
		float wRatio = (float) vWidth / (float) wWidth; // 锟斤拷锟斤拷椋�宸憋拷锟芥��
		float hRatio = (float) vHeight / (float) wHeight; // 锟斤拷锟芥�达拷锟斤拷锟�		
		float ratio = Math.max(wRatio, hRatio); // 锟斤拷锟芥�����锟界��锟斤拷���锟�		
		vWidth = (int) Math.ceil((float) vWidth / ratio); // 锟斤拷锟斤拷��斤拷锟姐��锟芥０锟斤拷锟姐��锟斤拷锟芥��
		vHeight = (int) Math.ceil((float) vHeight / ratio); // 锟斤拷锟斤拷��斤拷锟姐��锟芥０锟斤拷缁�锟斤拷锟斤拷
		// 锟斤拷���锟斤拷锟�SurfaceHolder锟斤拷锟斤拷宄帮拷
		getHolder().setFixedSize(vWidth, vHeight);
		mPlayer.seekTo(posttion);
		mPlayer.start();
	}
	
	private void dispose() {
		mPlayer.release();
		mPlayer = null;
		resUri = null;
		if (fd != null) {
			try {
				fd.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			fd = null;
		}
	}

	@Override
	public void onCompletion(MediaPlayer mp) {
		Log.i(TAG, "onCompletion");

		dispose();
		
		if(onFinishListener != null)
			onFinishListener.onVideoFinish();
	}

	@Override
	public boolean onInfo(MediaPlayer mp, int what, int extra) {
		return true;
	}

	@Override
	public boolean onError(MediaPlayer mp, int what, int extra) {
		return true;
	}

	@Override
	public boolean onTouch(View v, MotionEvent event) {
		if (event.getAction() == MotionEvent.ACTION_DOWN) {
			GameBox.getVideoHandler().onVideoTouch();
//			stop();
		}

		return true;
	}

	public void stop() {
		mPlayer.stop(); // 锟斤拷锟斤拷���锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟斤拷MediaPlayer.onCompletion
		dispose();
		if(onFinishListener != null)
			onFinishListener.onVideoFinish();
	}
	
	int posttion;
	public void pause() {
		posttion = mPlayer.getCurrentPosition();
		mPlayer.pause();
	}

	/**
	 * 锟斤拷锟斤拷宄帮拷锟斤拷锟斤拷���锟斤拷锟斤拷锟介����寸��锟斤拷锟姐��锟斤拷锟斤拷锟界�斤拷���锟�urfaceView 锟斤拷锟斤拷��斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟姐��锟�resume锟斤拷锟斤拷���锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟界�斤拷锟姐��锟斤拷锟斤拷锟界�斤拷���锟�diaPlayer
	 */
	public void resume() {
		if(surfaceCreated){
			mPlayer.start();
		}else {
			try {
				if(resUri != null)
					mPlayer.setDataSource(gameActivity, resUri);
				else if (fd != null) {
					mPlayer.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
				}
			} catch (Exception e) {
			}
		}
	}
	
	public interface OnFinishListener {
		public void onVideoFinish();
	}
}
