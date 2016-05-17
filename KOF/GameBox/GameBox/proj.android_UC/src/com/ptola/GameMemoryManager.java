package com.ptola;

import com.haowan123.kof.uc.GameBox;

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
	
	public static long getTotalMemory()			//全锟斤拷锟节达拷
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		//Log.v("-&&-getTotalMemory", "&-getTotalMemory");
		String str1 = "/proc/meminfo";// 系统锟节达拷锟斤拷息锟侥硷拷 
		String str2;
		long initial_memory = 0;

		try
		{
			FileReader localFileReader = new FileReader(str1);
			BufferedReader localBufferedReader = new BufferedReader(
			localFileReader, 8192);
			str2 = localBufferedReader.readLine();// 锟斤拷取meminfo锟斤拷一锟叫ｏ拷系统锟斤拷锟节达拷锟叫�
	
			String[] arrayOfString = str2.split("\\s+");
	
			initial_memory = Long.valueOf(arrayOfString[1]).intValue() * 1024;// 锟斤拷锟较低筹拷锟斤拷诖妫�拷锟轿伙拷锟�B锟斤拷锟斤拷锟斤拷1024转锟斤拷为Byte 
			localBufferedReader.close();

		}
		catch (IOException e) {
		}
		
		return initial_memory;
	}
	
	
	public static long getFreeMemory()  		//锟斤拷前锟斤拷锟斤拷锟节达拷锟叫�	
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;

		ActivityManager am = (ActivityManager)activity.getSystemService(Context.ACTIVITY_SERVICE); 
		
		ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();  
		
	    am.getMemoryInfo(mi);  
	    // mi.availMem; 锟斤拷前系统锟侥匡拷锟斤拷锟节达拷
		return mi.availMem;
	}
	
	
	public static long getUsedMemory()		//锟斤拷取锟斤拷前锟斤拷锟斤拷使锟斤拷锟节达拷
	{
		Activity activity = GameBox.getCurrentActivity();
		if( activity == null )
			return 0;
		//锟斤拷锟斤拷锟斤拷岱碉拷锟�100
		long longReturn = 0;
		
		
		//Log.v("--getUsedMemory", "-getUsedMemory");
		
		ActivityManager am = (ActivityManager)activity.getSystemService(ACTIVITY_SERVICE); 
		
		List<RunningAppProcessInfo> l = am.getRunningAppProcesses(); 
		
		Iterator<RunningAppProcessInfo> i = l.iterator(); 
		
		PackageManager pm = activity.getPackageManager(); 
		while(i.hasNext()) { 
		  ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo)(i.next()); 
		  
		  //通锟斤拷processName确锟斤拷为锟斤拷选锟斤拷锟斤拷锟斤拷
		  if(0 == info.processName.compareTo(activity.getPackageName()))
		  {
			  try { 
				  CharSequence c = pm.getApplicationLabel(pm.getApplicationInfo(info.processName, PackageManager.GET_META_DATA)); 
				  Log.w("LABEL", c.toString()); 
		    
				  int[] myMempid = new int[]{ info.pid };
		    
				  Debug.MemoryInfo[] memoryInfo = am.getProcessMemoryInfo(myMempid);
				  //dalvikPrivateDirty锟斤拷位为kb
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
	
	//锟斤拷锟斤拷锟节达拷锟斤拷值
	public static void setMaxMemoryThreshold()
	{
		
		
	}
	
}
