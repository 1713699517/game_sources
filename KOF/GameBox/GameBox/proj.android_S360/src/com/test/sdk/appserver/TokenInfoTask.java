
package com.test.sdk.appserver;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.json.JSONException;
import org.json.JSONObject;

import com.test.sdk.Constants;
import com.test.sdk.common.SdkHttpListener;
import com.test.sdk.common.SdkHttpTask;

import android.content.Context;
import android.util.Log;

/***
 * 此类使用AuthorizationCode，请求您的应用服务器，以获取AccessToken。
 * （注：应用服务器由360SDK使用方自行搭建，用于和360服务器进行安全交互，具体协议请查看文档中，服务器端接口）。
 */
public class TokenInfoTask {

    private static final String TAG = "TokenInfoTask";

    private SdkHttpTask sSdkHttpTask;
    
    public static TokenInfoTask newInstance(){
       return new TokenInfoTask();
    }

    public String MD5(String string) {
		byte[] hash;
		try {
		hash = MessageDigest.getInstance("MD5").digest(
		string.getBytes("UTF-8"));
		} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
		return null;
		} catch (UnsupportedEncodingException e) {
		e.printStackTrace();
		return null;
		}
		StringBuilder hex = new StringBuilder(hash.length * 2);
		for (byte b : hash) {
		if ((b & 0xFF) < 0x10)
		hex.append("0");
		hex.append(Integer.toHexString(b & 0xFF));
		}
		return hex.toString();
	}
    
    public void doRequest(Context context, String authorizationCode,
            String appKey,
            final TokenInfoListener listener) {

    	/*
    	 * auth_code	string	2	authorization code 或 refresh_token
refresh	string	3	参数 oob:登录 basic:刷新或重连
time	uint	4	时间戳
sign	string	N	数字签名(见注)
    	 * */
    	
        // DEMO使用的应用服务器url仅限DEMO示范使用，禁止正式上线游戏把DEMO应用服务器当做正式应用服务器使用，请使用方自己搭建自己的应用服务器。
    	long time =System.currentTimeMillis() / 1000;
    	String surl = "cid=360&auth_code="+authorizationCode+"&refresh=oob&time="+Long.toString(time);
        String url = Constants.DEMO_APP_SERVER_URL_GET_TOKEN + surl +"&sign=" + MD5(surl+"&key="+appKey);

        Log.i( TAG, url );
        
        // 如果存在，取消上一次请求
        if (sSdkHttpTask != null) {
            sSdkHttpTask.cancel(true);
        }
        
        // 新请求
        sSdkHttpTask = new SdkHttpTask(context);
        sSdkHttpTask.doGet(new SdkHttpListener() {

            @Override
            public void onResponse(String response) {
            	try
            	{
            		JSONObject jsn = new JSONObject(response);
            		JSONObject data = jsn.getJSONObject("data");
                    Log.d(TAG, "onResponse=" + response);
                    Log.d(TAG, "json_Data="+data.toString());
                    TokenInfo tokenInfo = TokenInfo.parseJson(data.toString());
                    listener.onGotTokenInfo(tokenInfo);
            	} catch (JSONException e) {
    				// TODO Auto-generated catch block
    				e.printStackTrace();
    			}
                sSdkHttpTask = null;
            }

            @Override
            public void onCancelled() {
                listener.onGotTokenInfo(null);
                sSdkHttpTask = null;
            }

        }, url);
        
        Log.d(TAG, "doRequest completed, url=" + url);
    }

    public boolean doCancel() {
        return (sSdkHttpTask != null) ? sSdkHttpTask.cancel(true) : false;
    }

}
