package com.haowan123.kof.oppo.nearme.gamecenter;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
import android.widget.Toast;

public class Util {
	private static boolean DEVELOPMENT_LOGGING_ENABLED = true;
	private static final String SEP_TAG = ":::";

	public static boolean isMobileActive(Context ctx) {
		ConnectivityManager cm = (ConnectivityManager) ctx
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo mobileNet = cm.getActiveNetworkInfo();
		if (mobileNet != null
				&& mobileNet.getType() == ConnectivityManager.TYPE_MOBILE) {
			return true;
		} else {
			return false;
		}
	}

	public static void dout(String TAG, String content) {
		if (DEVELOPMENT_LOGGING_ENABLED) {
			try {
				Throwable th = new Throwable();
				StackTraceElement stack[] = th.getStackTrace();
				StackTraceElement ste = stack[1];
				final String className = ste.getClassName();
				final String methodName = ste.getMethodName();
				Log.v(TAG, appendLogInfo(className, methodName, content));
			} catch (Exception e) {

			}
		}
	}

	public static String appendLogInfo(String className, String method,
			String content) {
		return new StringBuilder(className).append(SEP_TAG).append(method)
				.append(SEP_TAG).append(content).toString();
	}

	public static String getGameVersion(Context ctx, String packageName) {
		if (packageName == null) {
			return null;
		}
		String mVersonName = null;
		PackageManager manager = ctx.getPackageManager();
		PackageInfo info = null;
		try {
			info = manager.getPackageInfo(packageName, 0);
			mVersonName = info.versionName;
		} catch (Exception e) {
			mVersonName = null;
		}

		return mVersonName;
	}

	public static void makeToast(String content, Context context) {
		try {
			Toast.makeText(context, content, Toast.LENGTH_LONG).show();
		} catch (Exception e) {
		}
	}


}
