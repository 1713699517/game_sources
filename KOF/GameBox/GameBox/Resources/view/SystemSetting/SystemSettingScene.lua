--*********************************
--2013-9-14 by 陈元杰
--系统设置主界面-CSystemSettingScene
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "view/SystemSetting/SystemSettingView"
require "view/SystemSetting/LogUpdataView"
require "view/SystemSetting/RecommendView"
require "view/SystemSetting/GMContactView"

CSystemSettingScene = class(view, function(self)
end)

--************************
--常量定义
--************************
-- button的Tag值
CSystemSettingScene.TAG_CLOSE           = 201

-- ccColor4B 常量
CSystemSettingScene.RED   = ccc4(255,0,0,255)
CSystemSettingScene.GOLD  = ccc4(255,255,0,255)
CSystemSettingScene.GREEN = ccc4(120,222,66,255)

CSystemSettingScene.FONT_SIZE = 20


--tab 页面Tag值
CSystemSettingScene.TAG_SETTING   = 301
CSystemSettingScene.TAG_LOGUPDATA = 302
CSystemSettingScene.TAG_RECOMMEND = 303
CSystemSettingScene.TAG_GM        = 304
CSystemSettingScene.TAG_PPGRZX    = 401
CSystemSettingScene.TAG_360ACCOUNT = 501


function CSystemSettingScene.initView( self, _mainSize )

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CSystemSettingScene self.m_mainContainer 39 ")
    self.m_scenceLayer   : addChild( self.m_mainContainer )

    self.m_mainBackground = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBackground : setControlName( "this CSystemSettingScene self.m_mainBackground 39 ")
	self.m_mainBackground : setPreferredSize( _winSize )
	self.m_mainContainer  : addChild( self.m_mainBackground )

	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CSystemSettingScene self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer  : addChild( self.m_background )


	local function local_BtnCallback(eventType,obj,x,y)
		return self:touchBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this CSystemSettingScene self.m_closeBtn 70 ")
    self.m_closeBtn   :setTag( CSystemSettingScene.TAG_CLOSE )
    self.m_closeBtn   :registerControlScriptHandler( local_BtnCallback, "this CSystemSettingScene self.m_closeBtn 72 ")
    self.m_mainContainer :addChild( self.m_closeBtn )


    ----------------------------
    --主界面
    ----------------------------
    local function local_pageCallBack(eventType, obj, x, y)
    	print("eventType="..eventType)
        return self : pageCallBack(eventType,obj,x,y)
    end

    --系统设置界面
    self.m_settingPage       = CTabPage : createWithSpriteFrameName("系统设置","general_label_normal.png","系统设置","general_label_click.png")
    self.m_settingPage       : setTag (CSystemSettingScene.TAG_SETTING)
    self.m_settingPage       : setFontSize(24)
    self.m_settingPage       : registerControlScriptHandler(local_pageCallBack)
    local settingPageContainer = CContainer : create()
    settingPageContainer : setControlName( "this is CSystemSettingScene settingPageContainer 73" )

    self.m_settingView   = CSystemSettingView() --初始化
    self.m_settingLayer  = self.m_settingView:layer()
    self.m_settingLayer  : setPosition(-23,-598)
    settingPageContainer : addChild(self.m_settingLayer)
    print("------self.m_settingView=",self.m_settingView)

    --日志更新界面
    self.m_logUpdataPage       = CTabPage : createWithSpriteFrameName("日志更新","general_label_normal.png","日志更新","general_label_click.png")
    self.m_logUpdataPage       : setTag (CSystemSettingScene.TAG_LOGUPDATA)
    self.m_logUpdataPage       : setFontSize(24)
    self.m_logUpdataPage       : registerControlScriptHandler(local_pageCallBack)
    local logUpdataPageContainer = CContainer : create()
    logUpdataPageContainer : setControlName( "this is CSystemSettingScene logUpdataPageContainer 87" )

    self.m_logUpdataPageView  = CLogUpdataView() --初始化
    self.m_logUpdataPageLayer = self.m_logUpdataPageView:layer()
    self.m_logUpdataPageLayer : setPosition(-23,-598)
    logUpdataPageContainer    : addChild(self.m_logUpdataPageLayer)

    --推荐有奖界面
    self.m_recommendPage    = CTabPage : createWithSpriteFrameName("推荐有奖","general_label_normal.png","推荐有奖","general_label_click.png")
    self.m_recommendPage    : setTag (CSystemSettingScene.TAG_RECOMMEND)
    self.m_recommendPage    : setFontSize(24)
    self.m_recommendPage    : registerControlScriptHandler(local_pageCallBack)
    local recommendPageContainer = CContainer : create()
    recommendPageContainer  : setControlName( "this is CSystemSettingScene recommendPageContainer 100" )

    self.m_recommendPageView  = CRecommendView() --初始化
    self.m_recommendPageLayer = self.m_recommendPageView:layer()
    self.m_recommendPageLayer : setPosition(-23,-598)
    recommendPageContainer    : addChild(self.m_recommendPageLayer)

    --联系GM界面
    self.m_GMContactPage    = CTabPage : createWithSpriteFrameName("联系GM","general_label_normal.png","联系GM","general_label_click.png")
    self.m_GMContactPage    : setTag (CSystemSettingScene.TAG_GM)
    self.m_GMContactPage    : setFontSize(24)
    self.m_GMContactPage    : registerControlScriptHandler(local_pageCallBack)
    local GMContactPageContainer = CContainer : create()
    GMContactPageContainer  : setControlName( "this is CSystemSettingScene GMContactPageContainer 100" )

    self.m_GMContactPageView  = CGMContactView() --初始化
    self.m_GMContactPageLayer = self.m_GMContactPageView:layer()
    self.m_GMContactPageLayer : setPosition(-23,-598)
    GMContactPageContainer    : addChild(self.m_GMContactPageLayer)


    self.m_tab = CTab : create (eLD_Horizontal, CCSizeMake(130, 60))--按钮间距
    self.m_tab        : registerControlScriptHandler(local_pageCallBack)
    self.m_mainContainer : addChild (self.m_tab)

    local tabPageCount = 0
    self.m_tab : addTab(self.m_settingPage,settingPageContainer)
    tabPageCount = tabPageCount + 1
    self.m_tab : addTab(self.m_logUpdataPage,logUpdataPageContainer)
    tabPageCount = tabPageCount + 1
    -- self.m_tab : addTab(self.m_recommendPage,recommendPageContainer)
    -- tabPageCount = tabPageCount + 1
    self.m_tab : addTab(self.m_GMContactPage,GMContactPageContainer)
    tabPageCount = tabPageCount + 1
    self.m_tab : onTabChange(self.m_settingPage)

    -- self.m_logUpdataPageView:createWebView()

    if LUA_AGENT() == 5 then
        self.m_ppGeRenZX   = CButton :createWithSpriteFrameName( "个人中心", "general_label_normal.png")
        self.m_ppGeRenZX   :setControlName( "this CSystemSettingScene self.m_ppGeRenZX 70 ")
        self.m_ppGeRenZX   :setTag( CSystemSettingScene.TAG_PPGRZX )
        self.m_ppGeRenZX   :registerControlScriptHandler( local_BtnCallback, "this CSystemSettingScene self.m_ppGeRenZX 72 ")
        self.m_mainContainer :addChild( self.m_ppGeRenZX )


        local buttonSize = self.m_ppGeRenZX:getPreferredSize()
        self.m_ppGeRenZX : setPosition( ccp( 23 + buttonSize.width/2 + tabPageCount*(10+buttonSize.width), _mainSize.height-43 ) )
    elseif LUA_AGENT() == 2 then
        --
        self.m_ppGeRenZX   = CButton :createWithSpriteFrameName( "切换帐号", "general_label_normal.png")
        self.m_ppGeRenZX   :setControlName( "this CSystemSettingScene self.m_ppGeRenZX 70 ")
        self.m_ppGeRenZX   :setTag( CSystemSettingScene.TAG_360ACCOUNT )
        self.m_ppGeRenZX   :registerControlScriptHandler( local_BtnCallback, "this CSystemSettingScene self.m_ppGeRenZX 172 ")
        self.m_mainContainer :addChild( self.m_ppGeRenZX )
        
        
        local buttonSize = self.m_ppGeRenZX:getPreferredSize()
        self.m_ppGeRenZX : setPosition( ccp( 23 + buttonSize.width/2 + tabPageCount*(10+buttonSize.width), _mainSize.height-43 ) )
    end

end

function CSystemSettingScene.loadResources(self)
    print("CSystemSettingScene -- 加载资源")
	-- CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("ActivitiesResources/ActivitiesResources.plist")
end

function CSystemSettingScene.unloadResources( self )
    
    _G.g_unLoadIconSources:unLoadCreateResByName( "LuckyResources/general_pages_normal.png" )
    _G.g_unLoadIconSources:unLoadCreateResByName( "LuckyResources/general_pages_pressing.png" )

end

function CSystemSettingScene.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBackground :setPosition(ccp( _mainSize.width/2 , _mainSize.height/2))
	self.m_mainContainer  :setPosition(ccp( _winSize.width/2 - _mainSize.width/2 , 0))

	----------------------------
	--活动背景
	----------------------------
	local backgroundSize = self.m_background : getPreferredSize()
	self.m_background    : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.5))

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(backgroundSize.width-closeBtnSize.width/2,backgroundSize.height-closeBtnSize.height/2)) 

	----------------------------
    --主界面
    ----------------------------
    self.m_tab : setPosition(23,_mainSize.height-42)
end

--初始化数据成员
function CSystemSettingScene.initParams( self)
	
	--注册mediator
    -- _G.pCActivitiesMediator = CActivitiesMediator(self)
    -- controller :registerMediator(_G.pCActivitiesMediator)--先注册后发送 否则会报错       

end

--释放成员
function CSystemSettingScene.realeaseParams( self)
    --反注册mediator
    -- if _G.pCActivitiesMediator ~= nil then
    --     controller :unregisterMediator(_G.pCActivitiesMediator)
    --     _G.pCActivitiesMediator = nil
    -- end
end



function CSystemSettingScene.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    -- self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--加载主界面
	-- self:loadMainView()
	--布局成员
	self:layout(_mainSize)
end

function CSystemSettingScene.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenceLayer = CCScene:create()
	self:init( _mainSize, _data)
	return self.m_scenceLayer
end


function CSystemSettingScene.getSceneLayer( self )
    return self.m_scenceLayer
end


--************************
--按钮回调
--************************
--关闭 单击回调
function CSystemSettingScene.touchBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            local tag = tonumber( obj:getTag() )
            if tag == CSystemSettingScene.TAG_CLOSE then
                print("------self.m_settingView=",self.m_settingView)
    			self.m_settingView : sendSaveSettingMessage()
    			self :realeaseParams()
    			CCDirector:sharedDirector():popScene()

                self :unloadResources()
            elseif tag == CSystemSettingScene.TAG_PPGRZX then
                print("------PP 个人中心-----")
                -- self.m_logUpdataPageView:removeWebView()
                -- self.m_GMContactPageView:removeWebView()
                LUA_EXECUTE_COMMAND( 5 )
            elseif tag == CSystemSettingScene.TAG_360ACCOUNT then
                print( "切换帐号 360" )
                LUA_EXECUTE_COMMAND( 2 )
            end
		end
	end
end



function CSystemSettingScene.pageCallBack(self,eventType,obj,x,y)   --Page页面按钮回调
    if eventType == "TouchBegan" then
        -- _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        print("更换界面了 tag="..pageTag)
        if pageTag == CSystemSettingScene.TAG_LOGUPDATA then
            self.m_GMContactPageView:removeWebView()
            self.m_logUpdataPageView:createWebView()
        elseif pageTag == CSystemSettingScene.TAG_GM then
            self.m_logUpdataPageView:removeWebView()
            self.m_GMContactPageView:createWebView()
        else
            self.m_logUpdataPageView:removeWebView()
            self.m_GMContactPageView:removeWebView()
        end
        -- if pageTag == CSystemSettingScene.TAG_SETTING then

        -- elseif pageTag == CSystemSettingScene.TAG_LOGUPDATA then
        	
        -- elseif pageTag == CSystemSettingScene.TAG_RECOMMEND  then
        	
        -- end
    end
end

