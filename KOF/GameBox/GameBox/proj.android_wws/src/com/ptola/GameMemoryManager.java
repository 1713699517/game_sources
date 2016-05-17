package com.ptola;

import com.haowan123.kof123wws.GameBox;

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
	
	public static long getTotalMemory()			//全部内存
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		//Log.v("-&&-getTotalMemory", "&-getTotalMemory");
		String str1 = "/proc/meminfo";// 系统内存信息文件 
		String str2;
		long initial_memory = 0;

		try
		{
			FileReader localFileReader = new FileReader(str1);
			BufferedReader localBufferedReader = new BufferedReader(
			localFileReader, 8192);
			str2 = localBufferedReader.readLine();// 读取meminfo第一行，系统总内存大小 
	
			String[] arrayOfString = str2.split("\\s+");
	
			initial_memory = Long.valueOf(arrayOfString[1]).intValue() * 1024;// 获得系统总内存，单位是KB，乘以1024转换为Byte 
			localBufferedReader.close();

		}
		catch (IOException e) {
		}
		
		return initial_memory;
	}
	
	
	public static long getFreeMemory()  		//当前可用内存大小
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;

		ActivityManager am = (ActivityManager)activity.getSystemService(Context.ACTIVITY_SERVICE); 
		
		ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();  
		
	    am.getMemoryInfo(mi);  
	    // mi.availMem; 当前系统的可用内存
		return mi.availMem;
	}
	
	
	public static long getUsedMemory()		//获取当前任务使用内存
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		//如果出错会返回 100
		long longReturn = 0;
		
		
		//Log.v("--getUsedMemory", "-getUsedMemory");
		
		ActivityManager am = (ActivityManager)activity.getSystemService(ACTIVITY_SERVICE); 
		
		List<RunningAppProcessInfo> l = am.getRunningAppProcesses(); 
		
		Iterator<RunningAppProcessInfo> i = l.iterator(); 
		
		PackageManager pm = activity.getPackageManager(); 
		while(i.hasNext()) { 
		  ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo)(i.next()); 
		  
		  //通过processName确认为所选择任务
		  if(0 == info.processName.compareTo(activity.getPackageName()))
		  {
			  try { 
				  CharSequence c = pm.getApplicationLabel(pm.getApplicationInfo(info.processName, PackageManager.GET_META_DATA)); 
				  Log.w("LABEL", c.toString()); 
		    
				  int[] myMempid = new int[]{ info.pid };
		    
				  Debug.MemoryInfo[] memoryInfo = am.getProcessMemoryInfo(myMempid);
				  //dalvikPrivateDirty单位为kb
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
	
	//设置内存阈值
	public static void setMaxMemoryThreshold()
	{
		
		
	}
	
}
