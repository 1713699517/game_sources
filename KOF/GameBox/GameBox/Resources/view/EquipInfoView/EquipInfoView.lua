require "view/EquipInfoView/EquipStrengthenLayer"
require "view/EquipEnchant/EquipEnchantView"
require "view/EquipInfoView/EquipComposeLayer"
require "view/GemInlay/GemInlayView"
require "controller/command"

require "view/view"

require "view/EquipInfoView/EquipTipsBox"

require "controller/GuideCommand"

-- require "common/unLoadIconSources"



CEquipInfoView = class(view,function (self)
                          end)

CEquipInfoView.TAG_StrengthenPage = 1
CEquipInfoView.TAG_GemInlayPage   = 2
CEquipInfoView.TAG_ComposePage    = 3
CEquipInfoView.TAG_EnchantsPage   = 4

function CEquipInfoView.scene(self)
    --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_layer :registerControlScriptHandler(local_onEnter,"CEquipInfoView scene self.m_layer 136")

    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CEquipInfoView.layer(self,_winSize)
    
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CEquipInfoView.loadResources(self)
    print("附魔仪式的开始=")
   -- CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
    CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("EquipmentResources/equipSystemResource.plist")
end

function CEquipInfoView.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :removeSpriteFramesFromFile("EquipmentResources/equipSystemResource.plist")
    CCTextureCache :sharedTextureCache()         :removeTextureForKey("EquipmentResources/equipSystemResource.pvr.ccz")

    _G.Config:unload("config/pearl_com.xml")
    _G.Config:unload("config/equip_make.xml")
    --CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CEquipInfoView.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

          self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)      --总底图
          -- self.m_allSecondBackGroundSprite: setPosition(winSize.width/2,winSize.height/2)   --总底图
          local closeSize                  = self.CloseBtn: getContentSize()
          self.CloseBtn                    : setPosition(IpadSize-closeSize.width/2, winSize.height-closeSize.height/2)  --关闭按钮
          self.tab                         : setPosition(20+10,winSize.height-50+4)
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CEquipInfoView.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : initParameter()                       --参数初始化
    self : layout(_winSize)                      --适配布局初始化

    --初始化指引
    _G.pCGuideManager:initGuide( _layer , _G.Constant.CONST_FUNC_OPEN_STRENGTHEN)
end

function CEquipInfoView.initParameter(self)
    
    self.nPlayLv   = 0
    self.nPlayVip  = 0
    local mainplay = _G.g_characterProperty :getMainPlay()
    --人物等级
    self.nPlayLv   = tonumber(mainplay : getLv()) 
    --人物vIP等级
    self.nPlayVip  = tonumber(mainplay : getVipLv()) 

    self.isRealClosed = 0

    self.isNowTAG_StrengthenPage = 0
    self.isNowTAG_GemInlayPage   = 0
    self.isNowTAG_ComposePage    = 0
    self.isNowTAG_EnchantsPage   = 0
end

function CEquipInfoView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CEquipInfoView.onEnter  ")
        -- _G.pCGuideManager:initGuide( self.m_scenelayer , _G.Constant.CONST_FUNC_OPEN_ROLE)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_STRENGTHEN )
    end
end

function CEquipInfoView.initView(self,_winSize,_layer)
    self.BackContainer = CContainer : create()
    _layer             : addChild(self.BackContainer)

    --底图
    local IpadSize =854
    self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    _layer : addChild(self.m_allBackGroundSprite,-1)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    --self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.height/3*4,_winSize.height))  
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,_winSize.height)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite)  

    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)       
    self.m_allSecondBackGroundSprite   : setPosition(IpadSize/2,_winSize.height/2) 


    -- self.m_guideButton = CButton :createWithSpriteFrameName( "", "transparent.png")
    -- self.m_guideButton : setTouchesPriority( -101 )
    -- self.m_guideButton : setControlName( "this CEquipInfoView self.m_guideButton 134 " )
    -- -- self.m_guideButton :registerControlScriptHandler( CallBack, "this CEquipInfoView self.m_guideButton 147")
    -- _layer : addChild(self.m_guideButton, 2000)  

    --关闭按钮
    local function closeBtnCallBack(eventType, obj, x, y)
       return self : closeLayer_CallBack(eventType,obj,x,y)
    end
    self.CloseBtn               = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn : setTouchesPriority( -100 )
    self.CloseBtn : setControlName( "this is CEquipInfoView self.CloseBtn 77" )
    self.CloseBtn               : registerControlScriptHandler(closeBtnCallBack)
    self.BackContainer          : addChild (self.CloseBtn)

    local function PageCallBack(eventType, obj, x, y)
       return self : Page_CallBack(eventType,obj,x,y)
    end
    ---------Tab-------
    --强化页面
    self.StrengthenPage       = CTabPage : createWithSpriteFrameName("强化","general_label_normal.png","强化","general_label_click.png")
    self.StrengthenPage       : setFontSize(24)
    self.StrengthenPage       : setTag (CEquipInfoView.TAG_StrengthenPage)
    self.StrengthenPage       : registerControlScriptHandler(PageCallBack)
    self.StrengthenPage: setControlName( "this is CEquipInfoView self.StrengthenPage 77" )
    self.StrengthenPage : setTouchesPriority( -100 )
    self.m_StrengthenPageContainer = CContainer : create()
    self.m_StrengthenPageContainer : setControlName( "this is CEquipInfoView m_StrengthenPageContainer 77" )

    self.Strengthen = CEquipStrengthenLayer() --初始化
    StrengthenLayer = self.Strengthen :layer()
    StrengthenLayer : setPosition(-60,-590+1)
    self.m_StrengthenPageContainer : addChild(StrengthenLayer) 
    self.Strengthen :loadResources()
    
    --镶嵌页面
    self.GemInlayPage       = CTabPage : createWithSpriteFrameName("镶嵌","general_label_normal.png","镶嵌","general_label_click.png")
    self.GemInlayPage       : setFontSize(24)
    self.GemInlayPage       : setTouchesPriority( -100 )
    self.GemInlayPage       : setTag (CEquipInfoView.TAG_GemInlayPage)
    self.GemInlayPage       : registerControlScriptHandler(PageCallBack)
    self.GemInlayPage: setControlName( "this is CEquipInfoView self.GemInlayPage 77" )
    self.GemInlayPage : setTouchesPriority( -100 )
    self.m_GemInlayPageContainer = CContainer : create()
    self.m_GemInlayPageContainer : setControlName( "this is CEquipInfoView m_GemInlayPageContainer 95" )

    self.GemInlays = CGemInlayView() --初始化
    -- GemInlayLayer  = self.GemInlays :layer()
    -- GemInlayLayer : setPosition(-60,-590+1)
    -- m_GemInlayPageContainer : addChild(GemInlayLayer)
    -- self.GemInlays :loadResources()

    --合成页面
    self.ComposePage       = CTabPage : createWithSpriteFrameName("合成","general_label_normal.png","合成","general_label_click.png")
    self.ComposePage       : setFontSize(24)
    self.ComposePage       : setTouchesPriority( -100 )
    self.ComposePage       : setTag (CEquipInfoView.TAG_ComposePage)
    self.ComposePage       : registerControlScriptHandler(PageCallBack)
    self.ComposePage: setControlName( "this is CEquipInfoView self.ComposePage 77" )
    self.m_ComposePageContainer = CContainer : create()
    self.m_ComposePageContainer : setControlName( "this is CEquipInfoView m_ComposePageContainer 111" )
 
    self.CEquipCompose = CEquipComposeLayer() --初始化
    -- EquipComposeLayer = self.CEquipCompose :layer()
    -- EquipComposeLayer : setPosition(-60,-590+1)
    -- m_ComposePageContainer : addChild(EquipComposeLayer)
    -- self.CEquipCompose :loadResources()

    --附魔页面
    self.EnchantsPage       = CTabPage : createWithSpriteFrameName("附魔","general_label_normal.png","附魔","general_label_click.png")
    self.EnchantsPage       : setFontSize(24)
    self.EnchantsPage       : setTouchesPriority( -100 )
    self.EnchantsPage       : setTag (CEquipInfoView.TAG_EnchantsPage)
    self.EnchantsPage       : registerControlScriptHandler(PageCallBack)
    self.EnchantsPage: setControlName( "this is CEquipInfoView self.EnchantsPage 77" )
    self.m_EnchantsPageContainer = CContainer : create()
    self.m_EnchantsPageContainer : setControlName( "this is CEquipInfoView m_EnchantsPageContainer 126" )

    self.EquipEnchant = CEquipEnchantView() --初始化
    -- EquipEnchantLayer = self.EquipEnchant :layer()
    -- EquipEnchantLayer : setPosition(-60,-590+1)
    -- m_EnchantsPageContainer : addChild(EquipEnchantLayer)
    -- self.EquipEnchant :loadResources()

    --Tab
    self.tab = CTab : create (eLD_Horizontal, CCSizeMake(self.IpadSize/2*0.3044,_winSize.height/2*0.1875))--按钮间距
    self.BackContainer : addChild (self.tab)

    self.tab : addTab(self.StrengthenPage,self.m_StrengthenPageContainer)
    self.tab : addTab(self.GemInlayPage,self.m_GemInlayPageContainer)
    self.tab : addTab(self.ComposePage,self.m_ComposePageContainer)
    self.tab : addTab(self.EnchantsPage,self.m_EnchantsPageContainer)

    self.tab : onTabChange(self.StrengthenPage) --默认页面
    self.isNowTagPage = CEquipInfoView.TAG_StrengthenPage
    self.Strengthen : mediatorRegister()        --默认页面的mediator注册
    print("默认强化系统页面的mediator注册 143")
end

function CEquipInfoView.chuangePageByTag( self, _type )

    if _type == nil or self.tab == nil then
        return
    end

    local pageTag = tonumber( _type )

    if pageTag == CEquipInfoView.TAG_StrengthenPage then
        --_G.g_PopupView :reset()
        self.Strengthen : mediatorRegister()
    elseif pageTag == CEquipInfoView.TAG_GemInlayPage then
        --_G.g_PopupView :reset()
        if  self.isNowTAG_GemInlayPage   == 0 then
            self.isNowTAG_GemInlayPage   = 1
            -- self.GemInlays = CGemInlayView() --初始化
            GemInlayLayer  = self.GemInlays :layer()
            GemInlayLayer : setPosition(-60,-590+1)
            self.m_GemInlayPageContainer : addChild(GemInlayLayer)
        end

        self.GemInlays     : mediatorRegister()
        if self.isNowTAG_ComposePage == 1 then
            self.CEquipCompose : mediatorRegister()
        end
    elseif pageTag == CEquipInfoView.TAG_ComposePage  then
       -- _G.g_PopupView :reset()
        if  self.isNowTAG_ComposePage == 0 then
            self.isNowTAG_ComposePage = 1
            -- self.CEquipCompose = CEquipComposeLayer() --初始化
            EquipComposeLayer = self.CEquipCompose :layer()
            EquipComposeLayer : setPosition(-60,-590+1)
            self.m_ComposePageContainer : addChild(EquipComposeLayer)
        end
        self.CEquipCompose : mediatorRegister()
        if self.isNowTAG_GemInlayPage  == 1 then
            self.GemInlays     : mediatorRegister()
        end
    elseif pageTag == CEquipInfoView.TAG_EnchantsPage then
        --_G.g_PopupView :reset()
        if  self.isNowTAG_EnchantsPage  == 0 then
            self.isNowTAG_EnchantsPage = 1
            -- self.EquipEnchant = CEquipEnchantView() --初始化
            EquipEnchantLayer = self.EquipEnchant :layer()
            EquipEnchantLayer : setPosition(-60,-590+1)
            self.m_EnchantsPageContainer : addChild(EquipEnchantLayer)
        end
        self.EquipEnchant : mediatorRegister()
    end

    if _type == CEquipInfoView.TAG_StrengthenPage then
        self.tab : onTabChange(self.StrengthenPage) 

    elseif _type == CEquipInfoView.TAG_GemInlayPage then
        self.tab : onTabChange(self.GemInlayPage) 

    elseif _type == CEquipInfoView.TAG_ComposePage then
        self.tab : onTabChange(self.ComposePage) 

    elseif _type == CEquipInfoView.TAG_EnchantsPage then
        self.tab : onTabChange(self.EnchantsPage) 
    end
end

function CEquipInfoView.closeLayer_CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()
        if self.isRealClosed == 0 then
            self.isRealClosed = 1 --关闭只能按一次

            self : removeAllCCBI()

            self.Scenelayer : removeFromParentAndCleanup(true)

            self : allunregisterMediator() --反注册

            CCDirector : sharedDirector () : popScene()

            self:unloadResources() --释放资源

            self:setGuideStepFinish()
            
            _G.g_CEquipInfoView = nil

            self.Strengthen        : unloadHeadIcon()   --释放icon
            _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon
            print("附魔仪式的结束=")
            --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

            if self.isOpenCharacterPanelView == 1 then
                CCDirector :sharedDirector() :pushScene( _G.g_CharacterPanelView :scene())
            end
        end
    end
end

function CEquipInfoView.removeAllCCBI( self )
    if self.Strengthen ~= nil then
        self.Strengthen : removeeffectsCCBI()
    end
    if self.GemInlays ~= nil then
        self.GemInlays : removeeffectsCCBI()
    end
    if self.EquipEnchant ~= nil then
        self.EquipEnchant : removeeffectsCCBI()
    end
end



function CEquipInfoView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end

function CEquipInfoView.Page_CallBack(self,eventType,obj,x,y)   --Page页面按钮回调
    _G.g_PopupView :reset()
   if eventType == "TouchBegan" then

        print("CallBack TouchBegan",obj : getTag(),self.nPlayLv)
        local pageTag = obj : getTag()
        if pageTag == CEquipInfoView.TAG_EnchantsPage then
            local isOpen = 0 
            if self.nPlayLv >= _G.Constant.CONST_EQUIP_ENCHANT_OPEN then
                isOpen = isOpen + 1
            end
            if  self.nPlayVip >= _G.Constant.CONST_EQUIP_ENCHANT_VIP  then
                 isOpen = isOpen +  1
            end

            if  isOpen < 1 then
                local msg = "附魔开放人物等级达".._G.Constant.CONST_EQUIP_ENCHANT_OPEN.."级,或VIP等级达".._G.Constant.CONST_EQUIP_ENCHANT_VIP.."级"
                self : createMessageBox(msg)
                return false
            end
        end
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        
        --self : allunregisterMediator()

        self:chuangePageByTag( pageTag )

        _G.pCGuideManager:sendStepFinish()
    end
end

function CEquipInfoView.allunregisterMediator(self)

    if _G.g_CEquipStrengthenMediator ~= nil then
        controller :unregisterMediator(_G.g_CEquipStrengthenMediator)
        _G.g_CEquipStrengthenMediator = nil
        print("unregisterMediator.g_CEquipStrengthenMediator")
    end

    if _G.g_GemInlayMediator ~= nil then
        controller :unregisterMediator(_G.g_GemInlayMediator)
        _G.g_GemInlayMediator = nil
        print("unregisterMediator.g_GemInlayMediator")
    end

    if _G.g_EquipComposeMediator ~= nil then
        controller :unregisterMediator(_G.g_EquipComposeMediator)
        _G.g_EquipComposeMediator = nil
        print("unregisterMediator.g_EquipComposeMediator")
    end

    if _G.g_EquipEnchantMediator ~= nil then
        controller :unregisterMediator(_G.g_EquipEnchantMediator)
        _G.g_EquipEnchantMediator = nil
        print("unregisterMediator.g_EquipEnchantMediator")
    end
end

function CEquipInfoView.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end


function CEquipInfoView.setOpenCharacterPanelView( self,value)
    self.isOpenCharacterPanelView = value
end














