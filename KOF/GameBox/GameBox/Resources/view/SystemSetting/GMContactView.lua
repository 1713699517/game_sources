--*********************************
--2013-9-22 by 陈元杰
--联系GM 子界面-CGMContactView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"


CGMContactView = class(view, function(self)
	self.webView = nil
end)


function CGMContactView.initView( self, _mainSize )
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CGMContactView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CGMContactView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 824,554 ) )
	self.m_mainContainer : addChild( self.m_mainBg )

end

function CGMContactView.getGMUrl( self )

	local url = _G.netWorkUrl.."/api/Gm?"
	local cid = _G.LoginConstant.CID
	local sid = _G.g_LoginInfoProxy:getServerId()
	local uid = _G.g_LoginInfoProxy:getUid()
	local versions = CApplication:sharedApplication():getBundleVersion()

	CCLOG("versions=>"..versions)


	local mainplay = _G.g_characterProperty :getOneByUid( tonumber(uid), _G.Constant.CONST_PLAYER)
	local uname = CWebView:urlEncode(mainplay :getName())
	local os

	if tonumber( CDevice:sharedDevice():getOS() ) == 0 then
		os = "iOS"
	else
		os = "Android"
	end

	local key  = _G.LoginConstant.KEY
	local strTempWithKey = "os=".."os".."&key="..key
	local sign = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )

	url = url.."os="..os.."&cid="..cid.."&sid="..sid.."&uid="..uid.."&uname="..uname.."&versions="..(versions.."_"..LUA_GET_VERSION()).."&sign="..sign
	-- url = url.."cid="..cid.."&sid="..sid.."&uid="..uid.."&uname="..uname.."&os="..os.."&versions="..versions.."&sign="..sign

	print("getGMUrl-------> "..url)

	return url

end

function CGMContactView.createWebView( self )

	if self.webView ~= nil then
		return
	end

	local strUrl = self:getGMUrl()
	self.webView = CWebView:create()
	self.webView : loadGet(strUrl)

	local size       = CCSizeMake( 800, 540 )
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

	local _nWidth   = myDevSize.width/2-myDevSize.width*w_Scale/2
	local _nHeight  = (winSize.height - 562)/winSize.height*myDevSize.height

	self.webView : setScale( 0.5 )
	self.webView : setPreferredSize( CCSizeMake( myDevSize.width*w_Scale, myDevSize.height*h_Scale ) )
	self.webView : setPosition( ccp( _nWidth, _nHeight ) )
	
	self.m_mainContainer : addChild( self.webView )

end

function CGMContactView.removeWebView( self )
	if self.webView ~= nil then
		self.webView : removeFromParentAndCleanup( true )
		self.webView = nil
	end
end


function CGMContactView.layout(self, _mainSize)

	self.m_mainBg : setPosition( ccp( _mainSize.width/2, 292 ) )

end




function CGMContactView.init(self, _mainSize)

    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CGMContactView.layer(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CGMContactView self.m_viewContainer 39 ")

    self:init(_mainSize)

	return self.m_viewContainer
end


