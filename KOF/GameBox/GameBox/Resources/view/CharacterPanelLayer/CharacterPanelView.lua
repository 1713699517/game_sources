--[[
 --CCharacterPanelView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "mediator/CharacterMediator"

require "view/CharacterPanelLayer/CharacterBackpackView"
require "view/CharacterPanelLayer/CharacterInfoView"
require "view/CharacterPanelLayer/CharacterEquipInfoView"

require "view/SkillsUI/SkillNewUI"
require "controller/GuideCommand"

CCharacterPanelView = class(view, function( self)
    print("CCharacterPanelView:角色信息主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_characterPageContainer= nil   --4个标签容器公用
    self.m_equipmentViewContainer = nil
    self.m_characterPanelViewContainer  = nil  --人物面板的容器层
    self.m_partnerId             = 0     --主角属性
    self.m_touchType             = 201
    --local function P()
    --end
    --print = P
    --CCLOG = P
end)

_G.g_CharacterPanelView = CCharacterPanelView()
--Constant:
CCharacterPanelView.TAG_ATTRIBUTE    = 201
CCharacterPanelView.TAG_BACKPACK     = 202
CCharacterPanelView.TAG_ARTIFACT     = 204
CCharacterPanelView.TAG_SKILL        = 203
CCharacterPanelView.TAG_CLOSED       = 205

CCharacterPanelView.FONT_SIZE        = 25
CCharacterPanelView.TAB_BUTTON_SIZE  = CCSizeMake( 130, 60)



--加载资源
function CCharacterPanelView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("PeopleInfoResources/PeopleInfo.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("PeopleInfoResources/RoleResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")    --货币

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("skillsResources/skillResources.plist")

end
--释放资源
function CCharacterPanelView.unloadResource( self)


    CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()


    -- CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("PeopleInfoResources/PeopleInfo.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("CharacterPanelResources/RoleResurece.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ImageBackpack/backpackUI.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("PeopleInfoResources/RoleResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("skillsResources/skillResources.plist")
    
    -- CCTextureCache :sharedTextureCache():removeTextureForKey("PeopleInfoResources/PeopleInfo.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("CharacterPanelResources/RoleResurece.pvr.ccz")
    -- CCTextureCache :sharedTextureCache():removeTextureForKey("PeopleInfoResources/RoleResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("skillsResources/skillResources.pvr.ccz")

    for i,v in ipairs(self.m_createResStrList) do
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end

    _G.Config:unload("config/partner_init.xml")

    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

end

function CCharacterPanelView.insertCreateResStr( self, _str )
    if self.m_createResStrList ~= nil then 
        table.insert( self.m_createResStrList, _str )
    end
end

--初始化数据成员
function CCharacterPanelView.initParams( self, layer)
    print("CCharacterPanelView.initParams")
    if self.m_uid == nil then
        self.m_uid       = _G.g_LoginInfoProxy :getUid()  --玩家自己， 否则查看其他玩家
    else
        --向服务器请求玩家信息
    print(" 人物属性面板请求其他玩家属性 UID:",self.m_uid)
    local msg = REQ_ROLE_PROPERTY()
    msg: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg: setUid( self.m_uid )
    msg: setType( 0)  --角色本身，伙伴自动请求
    --_G.CNetwork : send( msg)
    end
    self.m_partnerId = 0
    self.m_mymediator  = CCharacterPanelMediator( self)
    controller :registerMediator( self.m_mymediator)--先注册后发送 否则会报错
    local mainplay = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    self.m_rolelv  = mainplay :getLv()

    self.m_createResStrList = {}
end
--释放成员
function CCharacterPanelView.realeaseParams( self)
    if self.m_characterPageContainer ~= nil then
        self.m_characterPageContainer :removeAllChildrenWithCleanup( true)
    end
end

--布局成员
function CCharacterPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面5")
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst                  = self.m_characterPanelViewContainer :getChildByTag( 99)
        local characterpanelbackgroundfirst    = self.m_characterPanelViewContainer :getChildByTag( 100)
        local closeButtonSize                  = self.m_closedButton: getPreferredSize()

        characterpanelbackgroundfirst :setPreferredSize( backgroundSize)
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        self.m_characterTab : setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height-closeButtonSize.height*0.7+1))
        --默认显示属性
        self.m_characterTab : setSelectedTabIndex( 0)

        characterpanelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        self.m_closedButton: setPosition( ccp(winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

--主界面初始化
function CCharacterPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
    
    --初始化指引
    local function runInitGuide()
        _G.pCGuideManager:initGuide( layer , _G.Constant.CONST_FUNC_OPEN_ROLE)
    end
    _G.pCGuideManager:lockScene() --initGuide( self.m_scene,self.m_npcId)
    layer:performSelector(0.08,runInitGuide)
end



function CCharacterPanelView.scene(self, _uid, _flag, _isBackType)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self.m_uid = _uid
    self.m_isBackType = _isBackType
    if self.m_isBackType == nil then
        self.m_isBackType = false
    else
        self.m_isBackType = true
    end
    -----------------------------------------------------------------
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)

    if _flag ~= nil then
        self :createViewByTag( CCharacterPanelView.TAG_BACKPACK)
        self.m_characterTab : setSelectedTabIndex( 1)
    end   

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_scenelayer :registerControlScriptHandler(local_onEnter,"CCharacterPanelView scene self.m_scenelayer 136")

    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CCharacterPanelView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CCharacterPanelView.onEnter  ")
        -- _G.pCGuideManager:initGuide( self.m_scenelayer , _G.Constant.CONST_FUNC_OPEN_ROLE)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_ROLE )
    end
end

function CCharacterPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CCharacterPanelView.getSceneContainer( self)
    return self.m_scenelayer
end

--初始化背包界面
function CCharacterPanelView.initView(self, layer)
    print("CCharacterPanelView.initView")
    --副本界面容器
    self.m_characterPanelViewContainer = CContainer :create()
    self.m_characterPanelViewContainer : setControlName("this is CCharacterPanelView self.m_characterPanelViewContainer 94 ")
    layer :addChild( self.m_characterPanelViewContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local backgroundfirst                 = CSprite :createWithSpriteFrameName( "peneral_background.jpg")
    local characterpanelbackgroundfirst   = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    backgroundfirst : setControlName( "this CCharacterPanelView backgroundfirst 124 ")
    characterpanelbackgroundfirst : setControlName( "this CCharacterPanelView characterpanelbackgroundfirst 124 ")
    self.m_closedButton                   = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
    self.m_closedButton : setControlName( "this CCharacterPanelView self.m_closedButton 134 " )
    self.m_closedButton :registerControlScriptHandler( CallBack, "this CCharacterPanelView self.m_closedButton 147")

    self.m_characterPanelViewContainer :addChild( backgroundfirst, -1, 99)
    self.m_characterPanelViewContainer :addChild( characterpanelbackgroundfirst, -1, 100)    
    self.m_characterPanelViewContainer :addChild( self.m_closedButton, 2, CCharacterPanelView.TAG_CLOSED)

    --默认属性界面
    --add:
    local tempinfoview            = CCharacterInfoView()
    self.m_mediator               = CCharacterMediator( tempinfoview)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    self.m_characterPageContainer = tempinfoview :layer( self.m_uid, self.m_partnerId)
    self.m_characterPanelViewContainer :addChild( self.m_characterPageContainer)
    self.m_clickButtonTag = CCharacterPanelView.TAG_ATTRIBUTE --保存上次点击TAG
    --装备
    self :createEquipmentView( _G.Constant.CONST_GOODS_EQUIP )

---------------------------------------------------------------------------------------
    ----[[
    --Tab
    self.m_characterTab = CTab : create (eLD_Horizontal, CCharacterPanelView.TAB_BUTTON_SIZE)--按钮间距
    self.m_characterPanelViewContainer : addChild (self.m_characterTab)

    
    --self.m_characterTab : addTab(self.m_characterInfomationPage,m_GemInlayPageContainer)
    --self.m_characterTab : addTab(self.ComposePage,m_ComposePageContainer)
    --self.m_characterTab : addTab(self.EnchantsPage,m_EnchantsPageContainer)

    local tempTabPage        = nil
    local tempPageContainer  = nil
    local tempPageView       = nil
    --角色属性页面
    tempTabPage         = self :createTabPage( "角色", CallBack, CCharacterPanelView.TAG_ATTRIBUTE, "characterInfomationPage")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    --tempPageView        = CCharacterInfoView()
    --self.m_mediator     = CCharacterMediator( tempinfoview)
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --tempPageContainer :addChild( tempinfoview :layer( self.m_uid, self.m_partnerId))
    self.m_characterTab : addTab( tempTabPage, tempPageContainer)

    --角色背包页面
    tempTabPage         = self :createTabPage( "道具", CallBack, CCharacterPanelView.TAG_BACKPACK, "characterInfomationPage")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_characterTab : addTab( tempTabPage, tempPageContainer)
    --角色技能页面
    tempTabPage         = self :createTabPage( "技能", CallBack, CCharacterPanelView.TAG_SKILL, "characterInfomationPage")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_characterTab : addTab( tempTabPage, tempPageContainer)
    --神器
    tempTabPage         = self :createTabPage( "神器", CallBack, CCharacterPanelView.TAG_ARTIFACT, "characterInfomationPage")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_characterTab : addTab( tempTabPage, tempPageContainer)
    --]]

end

--创建TabPage   general_label_normal
function CCharacterPanelView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CCharacterPanelView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CCharacterPanelView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end

--创建CContainer
function CCharacterPanelView.createContainer( self, _controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( _controlname)
    return _itemcontainer
end

--更新本地list数据
function CCharacterPanelView.setLocalList( self)
    print("CCharacterPanelView.setLocalList")

end
--清空公共界面容器和相应的mediator
function CCharacterPanelView.resetPageContainer( self)
    if self.m_characterPageContainer ~= nil then
        self.m_characterPageContainer :removeFromParentAndCleanup( true)
        print("删除公共容器")
        self.m_characterPageContainer = nil
    end
    if self.m_mediator ~= nil then
        controller :unregisterMediator( self.m_mediator)
        self.m_mediator = nil
    end
    if _G.g_CSkillMediator ~= nil then
        controller :unregisterMediator( _G.g_CSkillMediator)
        _G.g_CSkillMediator = nil
    end
    self :resetEquipmentView()
end

function CCharacterPanelView.resetEquipmentView( self)
    if self.m_equipmentViewContainer ~= nil then
        print("删除装备容器")
        controller :unregisterMediatorByName( "CCharacterEquipInfoMediator")
        self.m_equipmentViewContainer :removeFromParentAndCleanup( true)
        self.m_equipmentViewContainer = nil
    end
end

function CCharacterPanelView.createEquipmentView( self, _type )
    self :resetEquipmentView()
    -- local tempequipinfoview       = CCharacterEquipInfoView(_type)
    -- self.m_equipmentViewContainer = tempequipinfoview :layer( self.m_uid , self.m_partnerId)
    self.tempequipinfoview       = CCharacterEquipInfoView(_type)
    self.m_equipmentViewContainer = self.tempequipinfoview :layer( self.m_uid , self.m_partnerId)
    self.m_characterPanelViewContainer :addChild( self.m_equipmentViewContainer, 1000)
end


--创建与标签相对于的View
function CCharacterPanelView.createViewByTag( self, _tag)
    self : useRemoveCCBIMethond()
    self :resetPageContainer()
    local tempinfoview = nil
    local nlayer = -1
    self.Bagtempinfoview = nil 
    local function func_create()
        if _tag == CCharacterPanelView.TAG_ATTRIBUTE then
            print(" 属性界面")
            self :createEquipmentView( _G.Constant.CONST_GOODS_EQUIP )
            tempinfoview = CCharacterInfoView()
            self.m_mediator = CCharacterMediator( tempinfoview)
            controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
            self.m_characterPageContainer = tempinfoview :layer( self.m_uid, self.m_partnerId)

            self.m_characterTab:setSelectedTabIndex( 0 )
        elseif _tag == CCharacterPanelView.TAG_BACKPACK then
            print(" 背包界面")
            self :createEquipmentView( _G.Constant.CONST_GOODS_EQUIP )
            -- tempinfoview = CCharacterBackpackView()
            -- self.m_mediator = CCharacterPropsMediator( tempinfoview)
            -- controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
            -- self.m_characterPageContainer = tempinfoview :layer( 2, self.m_partnerId)
            self.Bagtempinfoview = CCharacterBackpackView()
            self.m_mediator = CCharacterPropsMediator( self.Bagtempinfoview)
            controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
            self.m_characterPageContainer = self.Bagtempinfoview :layer( 2, self.m_partnerId)
            nlayer = 100

            self.m_characterTab:setSelectedTabIndex( 1 )
        elseif _tag == CCharacterPanelView.TAG_ARTIFACT then
            print(" 神器界面")
            self :createEquipmentView( _G.Constant.CONST_GOODS_MAGIC )
            tempinfoview = CCharacterBackpackView()
            self.m_mediator = CCharacterPropsMediator( tempinfoview)
            controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
            self.m_characterPageContainer = tempinfoview :layer( 3, self.m_partnerId)  
            self.m_characterTab:setSelectedTabIndex( 3 )
        elseif _tag == CCharacterPanelView.TAG_SKILL then
            print(" 技能界面")
            local tempinfoview = CSkillNewUI()
            self.m_characterPageContainer = tempinfoview :layer( self.m_uid, self.m_partnerId)
            nlayer = 100

            self.m_characterTab:setSelectedTabIndex( 2 )
        end
        self.m_characterPanelViewContainer :addChild( self.m_characterPageContainer, nlayer)
    end
    self.m_clickButtonTag = _tag
    ----[[
    local actarr = CCArray :create()
    local dela = CCDelayTime :create( 0.01 )
    local temp = CCCallFunc : create( func_create )
    actarr :addObject( dela)
    actarr :addObject( temp)
    local seq = CCSequence:create(actarr)
    self.m_scenelayer:runAction(seq)
    --]]
end

--切换伙伴时更新属性界面
function CCharacterPanelView.updateViewByPartnerId( self, _uid, _partnerid)
    self.m_uid       = _uid
    self.m_partnerId = _partnerid
    self :createViewByTag( self.m_clickButtonTag)
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CCharacterPanelView.clickCellCallBack(self,eventType, obj, x, y)
    --删除Tips
    _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        -- self : useRemoveCCBIMethond()
        print(" 神器界面")
        if obj :getTag() == CCharacterPanelView.TAG_ARTIFACT then
            if self.m_rolelv >= _G.Constant.CONST_MAGIC_EQUIP_GOD_OPENLV then                    
                obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
            else
                require "view/ErrorBox/ErrorBox"
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("神器开放等级为".._G.Constant.CONST_MAGIC_EQUIP_GOD_OPENLV,func1)
                self.m_scenelayer: addChild(BoxLayer,1000)
                return false
            end
        end
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CCharacterPanelView.TAG_CLOSED then
            print("关闭")
            self :closeAll()
            if self.m_isBackType == true then --如果是出售时打开界面 弹出玩家信息
                require "view/BackpackPanelLayer/BackpackPanelView"
                CCDirector :sharedDirector() :pushScene( _G.g_CBackpackPanelView :scene())
            end
        elseif obj :getTag() ~= self.m_clickButtonTag then
            if obj :getTag() == CCharacterPanelView.TAG_ATTRIBUTE then
                print(" 属性界面")
                self :createViewByTag( CCharacterPanelView.TAG_ATTRIBUTE)
            elseif obj :getTag() == CCharacterPanelView.TAG_BACKPACK then
                print(" 背包界面")
                self :createViewByTag( CCharacterPanelView.TAG_BACKPACK)
            elseif obj :getTag() == CCharacterPanelView.TAG_ARTIFACT then
                print(" 神器界面")
                self :createViewByTag( CCharacterPanelView.TAG_ARTIFACT)
            elseif obj :getTag() == CCharacterPanelView.TAG_SKILL then
                print(" 技能界面")
                self :createViewByTag( CCharacterPanelView.TAG_SKILL)
                self:setGuideStepFinish()
            end
        end     
    end
end

function CCharacterPanelView.closeAll( self)
    if self ~= nil then
        self :resetPageContainer()
        controller :unregisterMediatorByName( "CCharacterEquipInfoMediator")

        self : useRemoveCCBIMethond()

        CCDirector :sharedDirector() :popScene( )
        self:unloadResource()
    else
        print("objSelf = nil", self)
    end    
end

function CCharacterPanelView.useRemoveCCBIMethond( self)

    if self.tempequipinfoview ~= nil then
        self.tempequipinfoview : removeAllCCBI()
    end 
    if self.Bagtempinfoview  ~= nil then
        self.Bagtempinfoview : removeAllCCBI()
    end 
end


--新手引导点击命令
function CCharacterPanelView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end



















