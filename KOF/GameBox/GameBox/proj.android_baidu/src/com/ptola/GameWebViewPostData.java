package com.ptola;

public class GameWebViewPostData
{
	public GameWebViewPostData()
	{
		
	}
	
	public GameWebViewPostData(String _url, byte[] _data)
	{
		url = _url;
		data = _data;
	}
	
	public byte[] data;
	public String url;
}
