package com.ptola;

import com.haowan123.kof.mi.GameBox;

import android.app.Activity;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.util.Log;
import android.os.Debug;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import android.app.ActivityManager;
//import android.app.ActivityManager.MemoryInfo;
import android.content.Context;
import android.content.pm.PackageManager; 
import java.util.List;
import java.util.Iterator;



public class GameMemoryManager extends Activity
{
	
	public static long getTotalMemory()	
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		//Log.v("-&&-getTotalMemory", "&-getTotalMemory");
		String str1 = "/proc/meminfo";
		String str2;
		long initial_memory = 0;

		try
		{
			FileReader localFileReader = new FileReader(str1);
			BufferedReader localBufferedReader = new BufferedReader(
			localFileReader, 8192);
			str2 = localBufferedReader.readLine();
	
			String[] arrayOfString = str2.split("\\s+");
	
			initial_memory = Long.valueOf(arrayOfString[1]).intValue() * 1024;
			localBufferedReader.close();

		}
		catch (IOException e) {
		}
		
		return initial_memory;
	}
	
	
	public static long getFreeMemory() 
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;

		ActivityManager am = (ActivityManager)activity.getSystemService(Context.ACTIVITY_SERVICE); 
		
		ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();  
		
	    am.getMemoryInfo(mi);  
		return mi.availMem;
	}
	
	
	public static long getUsedMemory()
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		long longReturn = 0;
		
		ActivityManager am = (ActivityManager)activity.getSystemService(ACTIVITY_SERVICE); 
		
		List<RunningAppProcessInfo> l = am.getRunningAppProcesses(); 
		
		Iterator<RunningAppProcessInfo> i = l.iterator(); 
		
		PackageManager pm = activity.getPackageManager(); 
		while(i.hasNext()) { 
		  ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo)(i.next()); 
		  
		  if(0 == info.processName.compareTo(activity.getPackageName()))
		  {
			  try { 
				  CharSequence c = pm.getApplicationLabel(pm.getApplicationInfo(info.processName, PackageManager.GET_META_DATA)); 
				  Log.w("LABEL", c.toString()); 
		    
				  int[] myMempid = new int[]{ info.pid };
		    
				  Debug.MemoryInfo[] memoryInfo = am.getProcessMemoryInfo(myMempid);
				  //dalvikPrivateDirty��λΪkb
				  longReturn = memoryInfo[0].dalvikPrivateDirty * 1024;
		   
				  return longReturn;
		    	
			  	}catch(Exception e) { 
			  		//Name Not FOund Exception 
			  	}
		  }
		  else
		  {
			  
			  
		  }
		}
		return longReturn;
	}
	
	public static void setMaxMemoryThreshold()
	{
		
		
	}
	
}
