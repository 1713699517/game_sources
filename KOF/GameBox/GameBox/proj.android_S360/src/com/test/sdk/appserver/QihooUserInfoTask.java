
package com.test.sdk.appserver;

import org.json.JSONObject;
import org.json.JSONException;

import com.haowan123.kof.qh.GameBox;
import com.test.sdk.Constants;
import com.test.sdk.common.SdkHttpListener;
import com.test.sdk.common.SdkHttpTask;

import android.content.Context;
import android.util.Log;

/***
 * 此类使用Access Token，请求您的应用服务器，获取QihooUserInfo。
 * （注：应用服务器由360SDK使用方自行搭建，用于和360服务器进行安全交互，具体协议请查看文档中，服务器端接口）。
 */
public class QihooUserInfoTask {

    private static final String TAG = "QihooUserInfoTask";

    private SdkHttpTask sSdkHttpTask;
    
    public static QihooUserInfoTask newInstance(){
        return new QihooUserInfoTask();
     }

    public void doRequest(Context context, String accessToken, String appKey,
            final QihooUserInfoListener listener) {

        // DEMO使用的应用服务器url仅限DEMO示范使用，禁止正式上线游戏把DEMO应用服务器当做正式应用服务器使用，请使用方自己搭建自己的应用服务器。
        //String url = Constants.DEMO_APP_SERVER_URL_GET_USER + accessToken + "&appkey=" + appKey;
    	
    	//fields 不传递此参数则缺省返回id, name, avatar
    	String url = Constants.DEMO_APP_SERVER_URL_GET_USER + "access_token=" + accessToken + "&fields=" ;
    	Log.d( TAG, "url===" + url  );
    	
        // 如果存在，取消上一次请求
        if (sSdkHttpTask != null) {
            sSdkHttpTask.cancel(true);
        }
        // 新请求
        sSdkHttpTask = new SdkHttpTask(context);
        sSdkHttpTask.doGet(new SdkHttpListener() {

            @Override
            public void onResponse(String response) {
            	
                Log.d(TAG, "onResponse22=" + response);
                
                //解析json 串
                try
                {
                	JSONObject jsn = new JSONObject( response );
                	
                	Log.d(TAG, "--->"+ jsn.getString("id") );
                	
                	GameBox.setUserId( jsn.getString("id") );
                	
                	QihooUserInfo userInfo = QihooUserInfo.parseJson(response);
                    listener.onGotUserInfo(userInfo);
                }
                catch (JSONException e) {
    				// TODO Auto-generated catch block
    				e.printStackTrace();
    			}
                
                sSdkHttpTask = null;
            }

            @Override
            public void onCancelled() {
                listener.onGotUserInfo(null);
                sSdkHttpTask = null;
            }

        }, url);
        
        Log.d(TAG, "url=" + url);
    }

    public boolean doCancel() {
        return (sSdkHttpTask != null) ? sSdkHttpTask.cancel(true) : false;
    }

}
