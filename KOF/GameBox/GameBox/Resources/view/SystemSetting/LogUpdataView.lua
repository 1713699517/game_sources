--*********************************
--2013-9-14 by 陈元杰
--更新日志 子界面-CLogUpdataView
--*********************************

require "view/view"
require "controller/command"

CLogUpdataView = class(view, function(self)
	self.webView = nil
end)


function CLogUpdataView.initView( self, _mainSize )
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CLogUpdataView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CLogUpdataView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 824,554 ) )
	self.m_mainContainer : addChild( self.m_mainBg )

end

function CLogUpdataView.getGMUrl( self )

	local url = _G.netWorkUrl.."/api/PhoneSDK/UpdateLogs?"
	local cid = _G.LoginConstant.CID
	local source = "testSource"
	local source_sub = "testSourceSub"
	local versions = CApplication:sharedApplication():getBundleVersion()
	local os

	if tonumber( CDevice:sharedDevice():getOS() ) == 0 then
		os = "iOS"
	else
		os = "Android"
	end

	url = url.."cid="..cid.."&os="..os.."&source="..source.."&source_sub="..source_sub.."&versions="..(versions.."_"..LUA_GET_VERSION())

	print("getGMUrl-------> "..url)

	return url

end

function CLogUpdataView.createWebView( self )

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

	self.webView : setPreferredSize( CCSizeMake( myDevSize.width*w_Scale, myDevSize.height*h_Scale ) )
	self.webView : setPosition( ccp( _nWidth, _nHeight ) )
	
	self.m_mainContainer : addChild( self.webView )

end

function CLogUpdataView.removeWebView( self )
	if self.webView ~= nil then
		self.webView : removeFromParentAndCleanup( true )
		self.webView = nil
	end
end

function CLogUpdataView.layout(self, _mainSize)

	self.m_mainBg : setPosition( ccp( _mainSize.width/2, 292 ) )

end




function CLogUpdataView.init(self, _mainSize)

    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CLogUpdataView.layer(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CLogUpdataView self.m_viewContainer 39 ")

    self:init(_mainSize)

	return self.m_viewContainer
end















--[[
require "view/view"
require "controller/command"
require "mediator/mediator"

CLogUpdataView = class(view, function(self)
end)


-- ccColor4B 常量
CLogUpdataView.RED   = ccc4(255,0,0,255)
CLogUpdataView.GOLD  = ccc4(255,215,0,255)
CLogUpdataView.GREEN = ccc4(120,222,66,255)

CLogUpdataView.FONT_SIZE = 24

CLogUpdataView.SCO_SIZE = CCSizeMake( 800, 538 )
CLogUpdataView.TIME_LABEL_HEIGHT = 35


function CLogUpdataView.initView( self, _mainSize )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CLogUpdataView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

	self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CLogUpdataView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 824,554 ) )
	self.m_mainContainer : addChild( self.m_mainBg )

	local logList     = _G.Config.update_notices
	local count  	  = #logList.update_notice
	local init_height = 0

	local timeLabelList  = {}
	local infoLabelList  = {}
	local timeHeightList = {}
	for i=1,count do
		print("----CLogUpdataView-----",i,count)
		local logInfo = logList.update_notice[count-i+1]
		local info = self:getNewInfoByStr(logInfo.notice)
		local time = logInfo.date

		timeLabelList[i] = CCLabelTTF :create( time, "Arial", CLogUpdataView.FONT_SIZE )
		infoLabelList[i] = CCLabelTTF :create( info, "Arial", CLogUpdataView.FONT_SIZE )

		timeLabelList[i] : setAnchorPoint( ccp( 0,1 ) )
		timeLabelList[i] : setHorizontalAlignment( kCCTextAlignmentLeft )
		timeLabelList[i] : setColor( CLogUpdataView.GOLD )

		infoLabelList[i] : setAnchorPoint( ccp( 0,1 ) )
		infoLabelList[i] : setHorizontalAlignment( kCCTextAlignmentLeft )
		infoLabelList[i] : setDimensions( CCSizeMake( CLogUpdataView.SCO_SIZE.width-20,0 ) )

		timeHeightList[i] = init_height + CLogUpdataView.TIME_LABEL_HEIGHT

		local infoSize = infoLabelList[i] : getContentSize()

		-- local size = CFontMetric:measureTextSize( info, "Arial", CLogUpdataView.FONT_SIZE, CLogUpdataView.SCO_SIZE.width-20 )
		print("---infoSize--------------->>>"..infoSize.height)
		init_height = init_height + CLogUpdataView.TIME_LABEL_HEIGHT + infoSize.height + 35


	end

	if init_height < CLogUpdataView.SCO_SIZE.height then 
		init_height = CLogUpdataView.SCO_SIZE.height
	end

	self.m_scrollViewContainer = CContainer :create()
    self.m_scrollViewContainer : setControlName( "this CActivitiesView self.m_scrollViewContainer 39 ")
    self.m_scrollViewContainer : setPosition( ccp( 0, -(init_height-CLogUpdataView.SCO_SIZE.height) ) )

    self.m_ScrollView = CCScrollView :create()
    self.m_ScrollView : setDirection(kCCScrollViewDirectionVertical)
    self.m_ScrollView : setContentOffset( CCPointMake( 0,-init_height ) )
    self.m_ScrollView : setContainer( self.m_scrollViewContainer )
    self.m_ScrollView : setViewSize( CLogUpdataView.SCO_SIZE )
    self.m_ScrollView : setContentSize(CCSizeMake( 542,init_height ))
    self.m_mainContainer : addChild( self.m_ScrollView,100 )

    for i=1,count do
    	timeLabelList[i] : setPosition( ccp( 20, init_height + 30 - timeHeightList[i] ) )
    	infoLabelList[i] : setPosition( ccp( 20, init_height + 30 - timeHeightList[i] - CLogUpdataView.TIME_LABEL_HEIGHT ) )

    	self.m_scrollViewContainer : addChild( timeLabelList[i] )
    	self.m_scrollViewContainer : addChild( infoLabelList[i] )
    end

end

function CLogUpdataView.getNewInfoByStr( self, _str )

	local newString = ""

	local pos = 1
	local endpos = 1
	while pos ~= nil do
		pos = string.find(_str,"{", pos)
		endpos = string.find(_str,"}", pos)

		if pos == nil then
			break
		end

		newString = newString..string.sub( _str, pos+1, endpos-1 ).."\n"

		pos = endpos + 1
	end

	return newString

end

function CLogUpdataView.layout(self, _mainSize)

	self.m_mainBg : setPosition( ccp( _mainSize.width/2, 292 ) )

	self.m_ScrollView : setPosition( ccp( 25,21 ) )
end


--初始化数据成员
function CLogUpdataView.initParams( self)
	self:loadXml()
end

function CLogUpdataView.loadXml( self )
	if _G.Config.update_notices == nil then
		CConfigurationManager :sharedConfigurationManager() :load( "config/update_notice.xml")
	end
end


--释放成员
function CLogUpdataView.realeaseParams( self)
    --反注册mediator
    -- if _G.pCActivitiesMediator ~= nil then
    --     controller :unregisterMediator(_G.pCActivitiesMediator)
    --     _G.pCActivitiesMediator = nil
    -- end
end




function CLogUpdataView.init(self, _mainSize)

	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CLogUpdataView.layer(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CLogUpdataView self.m_viewContainer 39 ")

    self:init(_mainSize)

	return self.m_viewContainer
end
]]




