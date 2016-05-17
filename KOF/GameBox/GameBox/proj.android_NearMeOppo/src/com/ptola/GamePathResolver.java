package com.ptola;

import com.haowan123.kof.oppo.nearme.gamecenter.GameBox;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

public class GamePathResolver
{
	public static String getApplicationStartupPath()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return "";
		return activity.getApplication().getApplicationInfo().sourceDir;
	}
	
	public static String getApplicationResourcePath()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return "";
		return activity.getApplication().getApplicationInfo().dataDir + "/assets/";
	}
	
	public static String getApplicationBundleVersion() throws NameNotFoundException
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return "";
		PackageInfo info = activity.getPackageManager().getPackageInfo(activity.getPackageName(), PackageManager.GET_ACTIVITIES);
		return ( info != null ) ? info.versionName: "1.0";
	}
}
