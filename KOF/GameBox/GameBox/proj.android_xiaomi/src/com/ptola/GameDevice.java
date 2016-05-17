package com.ptola;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.haowan123.kof.mi.GameBox;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Vibrator;
import android.util.DisplayMetrics;
import android.util.Log;


@SuppressLint("DefaultLocale")
public class GameDevice
{
	public static int getNetworkStatus()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		try
		{
			ConnectivityManager cm = (ConnectivityManager)activity.getSystemService(Context.CONNECTIVITY_SERVICE);
			if( cm == null )
				return 0;
			NetworkInfo netInfo = cm.getActiveNetworkInfo();
			if( netInfo == null || !netInfo.isConnected() )
				return 0;
			if( netInfo.getType() == ConnectivityManager.TYPE_WIFI )
				return 1;
			if( netInfo.getType() == ConnectivityManager.TYPE_MOBILE )
				return 2;
			return 0;
		}	
		catch(Exception e)
		{
			Log.e("getNetworkStatus Error", e.getMessage());
			return 0;
		}
	}
	
	
	public static int getDeviceOrientation()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return -1;
		return activity.getWindowManager().getDefaultDisplay().getOrientation();
		//return activity.getWindowManager().getDefaultDisplay().getRotation();
		//0 degree-0   1 degree-90   2 degree-180   3 degree-270 
	}
	
	public static Point getScreenSize()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return new Point(0,0);
		DisplayMetrics outMetrics = new DisplayMetrics();
		activity.getWindowManager().getDefaultDisplay().getMetrics(outMetrics);
		return new Point(outMetrics.widthPixels, outMetrics.heightPixels);
	}
	
	public static void setDeviceOrientation(int orientation)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return;
		activity.setRequestedOrientation(orientation);
	}
	
	public static String getDeviceIMEI()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return null;
		return android.provider.Settings.System.getString(activity.getContentResolver(),
				android.provider.Settings.System.ANDROID_ID);
	}

	public static String getDeviceMAC()
	{
		try
		{
			BufferedReader reader = new BufferedReader(new FileReader("/proc/net/arp"));
			String currentLine = null;
			String wlan0_mac = null;
			String en0_mac = null;
			Pattern reg = Pattern.compile("([0-9a-f]+:[0-9a-f]+:[0-9a-f]+:[0-9a-f]+:[0-9a-f]+:[0-9a-f]+)");
			while( true )
			{
				currentLine = reader.readLine();
				if( currentLine == null )
					break;
				if( currentLine.indexOf("wlan0") > -1 )
				{
					Matcher wlan0_m = reg.matcher(currentLine);
					if( wlan0_m.find() )
					{
						wlan0_mac = wlan0_m.group(1);
					}
					continue;
				}
				if( currentLine.indexOf("en0") > -1 )
				{
					Matcher en0_m = reg.matcher(currentLine);
					if( en0_m.find() )
					{
						en0_mac = en0_m.group(1);
					}
					continue;
				}
			}
			reader.close();
			if( en0_mac != null )
				return en0_mac;
			if( wlan0_mac != null )
				return wlan0_mac;
			return "";
			//wlan0
			//en0
			//ret = buffer.toString().toUpperCase().substring(0, 17);
		}
		catch(java.io.FileNotFoundException e)
		{
			
		}
		catch(java.io.IOException e2)
		{
			
		}
		return "";
	}
	
	public static String getOSVersion()
	{
		return android.os.Build.VERSION.RELEASE;
	}
	
	public static String getModel()
	{
		return android.os.Build.MODEL;
	}
	
	public static void vibrate(int ms)
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return;
		Vibrator _vibrator = (Vibrator)activity.getSystemService(Context.VIBRATOR_SERVICE);
		_vibrator.vibrate((long)ms);
	}
}
