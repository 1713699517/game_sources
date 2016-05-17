package com.haowan123.kof.qh;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.haowan123.kof.qh.R;
import com.ptola.GameUserData;
//import com.wws.sdk.WwsLoginActivity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.DialogInterface.OnCancelListener;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View.OnClickListener;
import android.widget.Toast;

import com.qihoo.gamecenter.sdk.common.IDispatcherCallback;
import com.qihoo.gamecenter.sdk.protocols.pay.ProtocolConfigs;
import com.qihoo.gamecenter.sdk.protocols.pay.ProtocolKeys;
import com.qihoopay.insdk.activity.ContainerActivity;
import com.qihoopay.insdk.matrix.Matrix;

import com.test.sdk.Constants;
import com.test.sdk.appserver.QihooUserInfo;
import com.test.sdk.appserver.QihooUserInfoListener;
import com.test.sdk.appserver.QihooUserInfoTask;
import com.test.sdk.appserver.TokenInfo;
import com.test.sdk.appserver.TokenInfoListener;
import com.test.sdk.appserver.TokenInfoTask;
import com.test.sdk.common.CmccSmsPayInfo;
import com.test.sdk.common.QihooPayInfo;
import com.test.sdk.common.SdkUserBaseActivity;
import com.test.sdk.common.SdkAccountListener;
import com.test.sdk.utils.ProgressUtil;

public class StartupActivity extends Activity implements TokenInfoListener, QihooUserInfoListener, SdkAccountListener
{
	private static final String TAG = "StartupActivity";
	private boolean mIsLandscape;
	 // 
    protected static final String RESPONSE_TYPE_CODE = "code";
    
    private TokenInfoTask mTokenTask;
    private QihooUserInfoTask mUserInfoTask;
    
	private static final int requestCode_wws = 360;
	
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.bg);
		Log.i(TAG, "go on11111 ");
		mIsLandscape = getIntent().getBooleanExtra(Constants.IS_LANDSCAPE, true);
        setRequestedOrientation(mIsLandscape ? ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                : ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        
        if (savedInstanceState == null) {
            Matrix.init(this, false, new IDispatcherCallback() {
                @Override
                public void onFinished(String data) {
                    Log.d(TAG, "matrix startup callback,result is " + data);
                }
            });
        }
        Log.i(TAG, "go on22222 ");
        Intent intent = getLoginIntent(mIsLandscape, true);

        Log.i(TAG, "go on33333 ");
        Matrix.invokeActivity(this, intent, mLoginCallback);
        Log.i(TAG, "go on44444 ");
	}
	
	@Override
    protected void onDestroy() {
        super.onDestroy();
        //Matrix.destroy(this);
        if (mTokenTask != null) {
            mTokenTask.doCancel();
        }

        if (mUserInfoTask != null) {
            mUserInfoTask.doCancel();
        }
    }
	
	// 登录、注册的回调 
    private IDispatcherCallback mLoginCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            Log.d(TAG, "mLoginCallback, data is " + data);
            String authorizationCode = parseAuthorizationCode(data);
            Log.i(TAG, "loginSuccessloginSuccess" + data);
            onGotAuthorizationCode(authorizationCode);
            Log.i(TAG, "onGotAuthorizationCode-->Code-->" + authorizationCode);
        }
    };
	
	protected void onActivityResult(int requestCode, int resultCode,Intent data)
	{
		if( requestCode == requestCode_wws )
		{

		}
		
		super.onActivityResult(requestCode, resultCode, data);
	}
	
	/***
     * 生成调用360SDK登录接口的Intent
     *
     * @param isLandScape 是否横屏
     * @param isBgTransparent 是否背景透明
     * @param appKey 应用或游戏的AppKey
     * @param appChannel 应用或游戏的自定义子渠道
     * @return Intent
     */
    private Intent getLoginIntent(boolean isLandScape, boolean isBgTransparent) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 界面相关参数，360SDK登录界面背景是否透明。
        bundle.putBoolean(ProtocolKeys.IS_LOGIN_BG_TRANSPARENT, isBgTransparent);

        // *** 以下非界面相关参数 ***

        // 必需参数，登录回应模式：CODE模式，即返回Authorization Code的模式。
        bundle.putString(ProtocolKeys.RESPONSE_TYPE, RESPONSE_TYPE_CODE);

        // 必需参数，使用360SDK的登录模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_LOGIN);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }
    
    /**
     * 从Json字符中获取授权码
     *
     * @param data Json字符串
     * @return 授权码
     */
    private String parseAuthorizationCode(String data) {
        String authorizationCode = null;
        if (!TextUtils.isEmpty(data)) {
            boolean isCallbackParseOk = false;
            try {
                JSONObject json = new JSONObject(data);
                int errCode = json.getInt("errno");
                if (errCode == 0) {
                	// 只支持code登陆模式
                    JSONObject content = json.getJSONObject("data");
                    if (content != null) {
                    	// 360SDK登录返回的Authorization Code（授权码，60秒有效）。
                        authorizationCode = content.getString("code");
                        isCallbackParseOk = true;
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }

            // 用于测试数据格式是否异常。
            if (!isCallbackParseOk) {
//                Toast.makeText(StartupActivity.this, getString(R.string.data_format_error),
//                        Toast.LENGTH_LONG).show();
            }
        }
        Log.d(TAG, "parseAuthorizationCode=" + authorizationCode);
        return authorizationCode;
    }
    
    @Override
    public void onGotUserInfo(QihooUserInfo userInfo){
    	// do something
    	Log.i(TAG, "onGotUserInfo-->");
        if (userInfo != null && userInfo.isValid()) {
        	 GameBox.setUserInfo(userInfo);
             // start game
             String uid = String.valueOf( userInfo.getId() ); 
             GameUserData.setValue( "name", userInfo.getName() );
 			 GameUserData.setValue( "userName", uid );
 			 Log.i(TAG, "tage onGotUserInfo-->" + uid);
        	 Log.i(TAG, "翻沉迷请求--" + GameBox.getTokenInfo().getAccessToken() + "  " + userInfo.getId());
 			 //防沉迷
        	 doSdkAntiAddictionQuery( GameBox.getUserInfo().getId(), GameBox.getTokenInfo().getAccessToken());
             //
             Toast.makeText(this, "登陆成功!", Toast.LENGTH_LONG).show();
           
		     //显示悬浮窗
	         doSdkSettings( true );
		    
        } else {
            Toast.makeText(this, "登陆失败!", Toast.LENGTH_LONG).show();
        }
    }
    
    
    @Override
    public void onGotError(int errCode){
    	// do something
    	
    }
    
    /**
     * 应用服务器通过此方法返回AccessToken
     */
    @Override
    public void onGotTokenInfo(TokenInfo tokenInfo){
    	// do something
    	Log.i(TAG, "tage onGotTokenInfo-->" + tokenInfo.getAccessToken());
        mUserInfoTask = QihooUserInfoTask.newInstance();
        
        GameBox.setTokenInfo(tokenInfo);
        Log.i(TAG, "sssss");
        // 请求应用服务器，用AccessToken换取UserInfo
        mUserInfoTask.doRequest(this, tokenInfo.getAccessToken(), Matrix.getAppKey(this),
                    this);
    }
    
    /**
     * 360SDK登录，通过此方法返回授权码（授权码生存期只有60秒，必需立即请求应用服务器，以得到AccessToken）
     */
    @Override
    public void onGotAuthorizationCode(String code) {
    	    Log.i(TAG, "------->ttttsssss" + code);
    		mTokenTask = TokenInfoTask.newInstance();
            // 
    		Log.i(TAG, "360SDK登录，通过此方法返回授权码（授权码生存期只有60秒，必需立即请求应用服务器，以得到AccessToken）" + code );

    		// 请求应用服务器，用AuthorizationCode换取AccessToken
            mTokenTask.doRequest(this, code, Matrix.getAppKey(this), this);
            Log.i("on1GotAuthorizationCode", "请求应用服务器，用AuthorizationCode换取AccessToken");
    }
    
    /*
     * 悬浮窗设置
     */
    protected void doSdkSettings( boolean isLandScape )
    {
    	Intent intent = getSettingIntent( isLandScape );
    	Matrix.execute(StartupActivity.this, intent, new IDispatcherCallback(){
    		@Override
    		public void onFinished(String data)
    		{
    			
    		}
    		
    	});
    	
    }
  
    /***
    * 生成设置接口的 Intent *
    * @return Intent
    */
    private Intent getSettingIntent(boolean isLandScape) {
    	Bundle bundle = new Bundle();
    	
    	// 界面相关参数,360SDK 界面是否以横屏显示。 
    	bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);
    	bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SETTINGS);
    	
    	Intent intent = new Intent(this, ContainerActivity.class);
    	intent.putExtras(bundle);
    	
    	return intent;
    }
    
    /**
     * 使用360SDK实名注册接口
     *
     * @param isLandScape 是否横屏显示登录界面
     * @param isBgTransparent 是否以透明背景显示登录界面
     */
    protected void doSdkRealNameRegister(boolean isLandScape, boolean isBgTransparent,
            String qihooUserId) {

        Intent intent = getRealNameRegisterIntent(isLandScape, isBgTransparent, qihooUserId);

        Matrix.invokeActivity(this, intent, mRealNameRegisterCallback);
    }
    
    /***
     * 生成实名注册登录接口的Intent
     *
     * @param isLandScape 是否横屏
     * @param isBgTransparent 是否背景透明
     * @param qihooUserId 奇虎UserId
     * @return Intent
     */
    private Intent getRealNameRegisterIntent(boolean isLandScape, boolean isBgTransparent,
            String qihooUserId) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 背景是否透明
        bundle.putBoolean(ProtocolKeys.IS_LOGIN_BG_TRANSPARENT, isBgTransparent);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qihooUserId);

        // 必需参数，使用360SDK的实名注册模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_REAL_NAME_REGISTER);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }
    
    // 实名注册的回调
    private IDispatcherCallback mRealNameRegisterCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            Log.d(TAG, "mRealNameRegisterCallback, data is " + data);
            enterGame();
        }
    };
    
    private void enterGame()
    {
    	Intent intent = new Intent( StartupActivity.this, GameBox.class);
	    startActivityForResult(intent, requestCode_wws);
	    StartupActivity.this.finish();
    	
    }
    
 // -----------------------------------------防沉迷查询接口----------------------------------------

    /**
     * 本方法中的callback实现仅用于测试, 实际使用由游戏开发者自己处理
     *
     * @param qihooUserId
     * @param accessToken
     * 返回例子：{"content":{"ret":[{"qid":"199062142","status":"2"}]},"error_code":"0","error_msg":""}
     */
    protected void doSdkAntiAddictionQuery(String qihooUserId, String accessToken) {
        Intent intent = getAntiAddictionIntent(qihooUserId, accessToken);
        Matrix.execute(this, intent, new IDispatcherCallback() {
        	
            @Override
            public void onFinished(String data) {
            	Log.d(TAG, "进入防沉迷查询" + data);
                Log.d("demo,anti-addiction query result = ", data);
                if (!TextUtils.isEmpty(data)) {
                    try {
                        JSONObject resultJson = new JSONObject(data);
                        
                        int errorCode = resultJson.getInt("error_code");
                        if (errorCode == 0) {
                            JSONObject contentData = resultJson.getJSONObject("content");
                            // 保存登录成功的用户名及密码
                            JSONArray retData = contentData.getJSONArray("ret");
                            Log.d(TAG, "ret data = " + retData);
                            int status = retData.getJSONObject(0).getInt("status");
                            Log.d(TAG, "status = " + status);
                            if (status == 0) {
                            	//调用实名注册
                            	//实名注册
                            	
                            	Log.d(TAG, " qid 年龄" + retData.getJSONObject(0).getString("qid"));
                            	doSdkRealNameRegister( true, true, retData.getJSONObject(0).getString("qid"));
                            	return;
                            } else if (status == 1) {
                            	// TODO 您也许可以采取防沉迷策略
                            	GameUserData.setValue( "fcm", "0");
          
                               
                            } else if (status == 2) {
                            	// TODO 您也许可以适当提醒用户
                            	GameUserData.setValue( "fcm", "1");  

                            }
                        } else {
//                            Toast.makeText(SdkUserBaseActivity.this,
//                                    resultJson.getString("error_msg"), Toast.LENGTH_SHORT).show();
                        }

                    } catch (JSONException e) {
//                        Toast.makeText(SdkUserBaseActivity.this,
//                                getString(R.string.anti_addiction_query_exception),
//                                Toast.LENGTH_LONG).show();
                        e.printStackTrace();

                    }
                }
                //进入游戏
                enterGame();
            }
        });
    }

    /**
     * 生成防沉迷查询接口的Intent参数
     *
     * @param qihooUserId
     * @param accessToken
     * @return Intent
     */
    private Intent getAntiAddictionIntent(String qihooUserId, String accessToken) {

        Bundle bundle = new Bundle();

        // 必需参数，用户access token，要使用注意过期和刷新问题，最大64字符。
        bundle.putString(ProtocolKeys.ACCESS_TOKEN, accessToken);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qihooUserId);

        // 必需参数，使用360SDK的防沉迷查询模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_ANTI_ADDICTION_QUERY);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }
    
}
