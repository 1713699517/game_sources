package com.ptola;


public class GameUserData
{
	private static java.util.Hashtable<String, String> m_Dict = new java.util.Hashtable<String, String>();
	public GameUserData()
	{ 
	}
	
	public static String getValue(String key)
	{
		if(m_Dict.containsKey(key))
		{
			return m_Dict.get(key);	
		}
		else
		{
			return "";
		}
	}
	
	public static void setValue(String key, String value)
	{
		m_Dict.put(key, value);
	}
	
	public static void remove(String key)
	{
		m_Dict.remove(key);
	}
}
