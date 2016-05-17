--*********************************
--2013-9-22 by 陈元杰
--服务器公告 子界面-CServerNoticView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"


CServerNoticView = class(view, function(self)
	self.webView = nil
end)

CServerNoticView.TAG_KNOWN = 101
CServerNoticView.PRI       = -100

function CServerNoticView.initView( self, _mainSize )
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CServerNoticView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_mainBg = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_mainBg : setControlName( "this CServerNoticView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 562,518 ) )
	self.m_mainBg : setFullScreenTouchEnabled( true )
	self.m_mainBg : setTouchesEnabled( true )
	self.m_mainBg : setTouchesPriority( CServerNoticView.PRI )
	self.m_mainContainer : addChild( self.m_mainBg )

	local function local_btnCallBack( eventType, obj, x, y )
		return self:BtnCallBack( eventType, obj, x, y )
	end

	self.m_surebutton = CButton :createWithSpriteFrameName("确定","login_button_click_02.png")
    self.m_surebutton : setControlName( "this CAllServerScene self.m_surebutton 43 ")
    self.m_surebutton : setTag( CServerNoticView.TAG_KNOWN )
    self.m_surebutton : setTouchesPriority( CServerNoticView.PRI - 1 )
    self.m_surebutton : registerControlScriptHandler( local_btnCallBack, "this CServerNoticView self.m_surebutton 43" )
    self.m_mainContainer : addChild( self.m_surebutton )

    self.m_titleImg = CSprite :createWithSpriteFrameName("login_word_yxwhgg.png")
    self.m_titleImg : setControlName( "this CServerNoticView self.m_titleImg 39 ")
    self.m_mainContainer : addChild( self.m_titleImg )

    self:createWebView()
 
end

function CServerNoticView.layout(self, _mainSize)

	self.m_mainBg : setPosition( ccp( _mainSize.width/2, _mainSize.height/2 ) )

	self.m_surebutton : setPosition( ccp( _mainSize.width/2, _mainSize.height*0.16 ) )
	self.m_titleImg   : setPosition( ccp( _mainSize.width/2, _mainSize.height*0.855 ) )

end

function CServerNoticView.getUrl( self )

	-- local url = "http://".._G.netWorkUrl.."/api/PhoneSDK/UpdateLogs?"
	-- local cid = _G.LoginConstant.CID
	-- local versions = CApplication:sharedApplication():getBundleVersion()
	-- local source = "testSource"
	-- local source_sub = "testSourceSub"
	-- local os

	-- if tonumber( CDevice:sharedDevice():getOS() ) == 0 then
	-- 	os = "iOS"
	-- else
	-- 	os = "Android"
	-- end
	-- -- local versions = 1.34

	-- local key  = _G.LoginConstant.KEY
	-- local strTempWithKey = "os=".."os".."&key="..key
	-- local sign = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )

	-- url = url.."&cid="..cid.."os="..os.."&source="..source.."&source_sub="..source_sub.."&versions="..versions..","..LUA_GET_VERSION()

	-- print("getGMUrl-------> "..url)

	-- return url

	local url = _G.netWorkUrl.."/api/PhoneSDK/Repair?"
	local cid = _G.LoginConstant.CID
	local sid = self.m_serverId

	url = url.."cid="..cid.."&sid="..sid

	print("getGMUrl-------> "..url)

	return url

end

function CServerNoticView.createWebView( self )

	if self.webView ~= nil then
		return
	end

	local strUrl = self:getUrl()
	self.webView = CWebView:create()
	self.webView : loadGet(strUrl)

	local size       = CCSizeMake( 515, 385 )
	local deviceSize = CDevice:sharedDevice():getScreenSize()
	local winSize    = CCDirector:sharedDirector():getVisibleSize()
	local w_Scale    = size.width/winSize.width
	local h_Scale    = size.height/winSize.height
	local os = CDevice:sharedDevice():getOS()
	local myDevSize  
	if tonumber( os ) == 0 then
		-- ios
		myDevSize = CCSizeMake( deviceSize.height, deviceSize.width )
	else 
		-- android
		myDevSize = CCSizeMake( deviceSize.width, deviceSize.height )
	end

	local _nWidth   = myDevSize.width/2 - myDevSize.width*w_Scale/2
	local _nHeight  = myDevSize.height/2 - myDevSize.height*((size.height+18)/winSize.height)/2

	self.webView : setScale( 0.5 )
	self.webView : setPreferredSize( CCSizeMake( myDevSize.width*w_Scale, myDevSize.height*h_Scale ) )
	self.webView : setPosition( ccp( _nWidth, _nHeight ) )
	
	self.m_mainContainer : addChild( self.webView )

end

function CServerNoticView.removeWebView( self )
	if self.webView ~= nil then
		self.webView : removeFromParentAndCleanup( true )
		self.webView = nil
	end
end







function CServerNoticView.init(self, _mainSize)

    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CServerNoticView.layer(self, _sid)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_serverId = _sid

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CServerNoticView self.m_viewContainer 39 ")

    self:init(_mainSize)

	return self.m_viewContainer
end

function CServerNoticView.BtnCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
        	local tag = obj:getTag()
        	if tag == CServerNoticView.TAG_KNOWN then
        		
        		if self.webView ~= nil then
        			self.webView : removeFromParentAndCleanup( true )
        			self.webView = nil
        		end

        		self.m_viewContainer : removeFromParentAndCleanup( true )

        		_G.g_CServerNoticView = nil
        	end
        end
    end

end
