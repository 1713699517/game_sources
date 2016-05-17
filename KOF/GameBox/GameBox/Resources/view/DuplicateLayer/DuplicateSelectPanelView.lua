--[[
 --CDuplicateSelectPanelView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "view/DuplicateLayer/DuplicateView"
require "view/DuplicateLayer/DuplicatePromptView"
require "view/DuplicateLayer/DuplicateAllSView"

CDuplicateSelectPanelView = class(view, function( self)
    print("CDuplicateSelectPanelView:角色信息主界面")
    self.m_copyButton            = nil   --普通按钮
    self.m_heroButton            = nil   --英雄按钮
    self.m_fiendButton           = nil   --魔王按钮
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --3种Tag按钮的水平布局
    self.m_characterPanelViewContainer  = nil  --人物面板的容器层
end)
--Constant:
CDuplicateSelectPanelView.TAG_COPY         = _G.Constant.CONST_COPY_TYPE_NORMAL  --1
CDuplicateSelectPanelView.TAG_HERO         = _G.Constant.CONST_COPY_TYPE_HERO    --2
CDuplicateSelectPanelView.TAG_FIEND        = _G.Constant.CONST_COPY_TYPE_FIEND   --3
CDuplicateSelectPanelView.TAG_CLOSED       = 210
CDuplicateSelectPanelView.BUTTON_CLICK     = 211

CDuplicateSelectPanelView.FONT_SIZE        = 25
CDuplicateSelectPanelView.TAB_BUTTON_SIZE  = CCSizeMake( 130, 60)

--加载资源
function CDuplicateSelectPanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("DuplicateResources/DuplicateResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KofCareerResource/KofCareer.plist")
end
--释放资源
function CDuplicateSelectPanelView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("DuplicateResources/DuplicateResources.plist")
    
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("KofCareerResource/KofCareer.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("DuplicateResources/DuplicateResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("BarResources/BarResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("KofCareerResource/KofCareer.pvr.ccz")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end
--初始化数据成员
function CDuplicateSelectPanelView.initParams( self, layer)
    print("CDuplicateSelectPanelView.initParams")
    local mainplay = _G.g_characterProperty :getMainPlay()
    self.m_rolelv  = mainplay :getLv()        --玩家等级
    local taskType, taskCopyId, chapterId = mainplay :getTaskInfo()
    --self.m_duplicatetype = 101
    if taskCopyId ~= nil then
        _G.Config:load("config/scene_copy.xml")
        local sceneCopys = _G.Config.scene_copys : selectSingleNode("scene_copy[@copy_id="..taskCopyId.."]")
        if sceneCopys :isEmpty() == false then
            self.m_duplicatetype = 101+tonumber(sceneCopys:getAttribute("copy_type") )-1
        end
    end

end
--释放成员
function CDuplicateSelectPanelView.realeaseParams( self)
end

--布局成员
function CDuplicateSelectPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面5")
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local characterpanelbackgroundfirst    = self.m_characterPanelViewContainer :getChildByTag( 200)
        local characterpanelbackground         = self.m_characterPanelViewContainer :getChildByTag( 201)
        local closeButtonSize                  = self.m_closedButton: getPreferredSize()     

        characterpanelbackground :setPreferredSize( CCSizeMake( winSize.width, winSize.height))
        characterpanelbackgroundfirst :setPreferredSize( backgroundSize) 

        self.m_buttonTab : setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height-closeButtonSize.height*0.7))
        --默认显示属性
        --显示相应副本类型
        self.m_currentTag  = self.m_duplicatetype-100
        self.m_buttonTab : setSelectedTabIndex( self.m_duplicatetype - 101 )

        characterpanelbackground :setPosition( ccp( winSize.width/2, winSize.height/2))
        characterpanelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        self.m_closedButton: setPosition( ccp(winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")
        
    end
end

--主界面初始化
function CDuplicateSelectPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)  
end

function CDuplicateSelectPanelView.scene(self, _duplicatetype)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self.m_duplicatetype = _duplicatetype or 101   --默认打开普通副本
    -------------------------------------------------------------
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CDuplicateSelectPanelView self.m_scenelayer 94 ")
    local function viewCallBack( eventType, obj, touches)
        if eventType == "TouchesBegan" then
            --删除Tips
            _G.pDuplicatePromptView :reset()
            _G.pDuplicateAllSView  :reset()
        elseif eventType == "TouchesEnded" then

        end
    end
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( viewCallBack, "this is CBarPanelView.createParnterItem self.m_scenelayer viewCallBack")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CDuplicateSelectPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CDuplicateSelectPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CDuplicateSelectPanelView.initView(self, layer)
    print("CDuplicateSelectPanelView.initView")
    --副本界面容器
    self.m_characterPanelViewContainer = CContainer :create()
    self.m_characterPanelViewContainer : setControlName("this is CDuplicateSelectPanelView self.m_characterPanelViewContainer 94 ")
    layer :addChild( self.m_characterPanelViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local characterpanelbackground        = self :createSprite( "peneral_background.jpg", "characterpanelbackground")
    local characterpanelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "characterpanelbackgroundfirst")
    self.m_closedButton                   = self :createButton( "", "general_close_normal.png", CallBack, CDuplicateSelectPanelView.TAG_CLOSED, "self.m_closedButton") 
         
    ----[[--Tab
    self.m_buttonTab = CTab : create (eLD_Horizontal, CDuplicateSelectPanelView.TAB_BUTTON_SIZE)--按钮间距   

    local tempTabPage        = nil
    local tempPageContainer  = nil

    --普通副本页面
    tempTabPage         = self :createTabPage( "普通", CallBack, CDuplicateSelectPanelView.TAG_COPY, "普通副本")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_buttonTab : addTab( tempTabPage, tempPageContainer)
    --英雄副本页面
    tempTabPage         = self :createTabPage( "精英", CallBack, CDuplicateSelectPanelView.TAG_HERO, "精英副本")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_buttonTab : addTab( tempTabPage, tempPageContainer)
    --魔王副本页面
    tempTabPage         = self :createTabPage( "魔王", CallBack, CDuplicateSelectPanelView.TAG_FIEND, "魔王副本")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_buttonTab : addTab( tempTabPage, tempPageContainer)
    --]]
    --self.m_currentTag    = CDuplicateSelectPanelView.TAG_COPY
    local pduplicateview = CDuplicateView()     
    self.m_pageContainer = pduplicateview :layer( self.m_duplicatetype )

    self.m_characterPanelViewContainer :addChild (self.m_buttonTab)
    self.m_characterPanelViewContainer :addChild( self.m_pageContainer)
    self.m_characterPanelViewContainer :addChild( characterpanelbackground, -1, 201)
    self.m_characterPanelViewContainer :addChild( characterpanelbackgroundfirst, -1, 200)
    self.m_characterPanelViewContainer :addChild( self.m_closedButton, 2)

end


--创建TabPage
function CDuplicateSelectPanelView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CDuplicateSelectPanelView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CDuplicateSelectPanelView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end

--创建按钮Button
function CDuplicateSelectPanelView.createButton( self, _string, _normalimage, _func, _tag, _controlname)
    print( "CDuplicateSelectPanelView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _normalimage)
    _itembutton :setControlName( "this CDuplicateSelectPanelView createButton:".._controlname)
    _itembutton :setFontSize( CDuplicateSelectPanelView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CDuplicateSelectPanelView ".._controlname.."CallBack")
    return _itembutton
end

--创建CSprite
function CDuplicateSelectPanelView.createSprite( self, _image, _controlname)
    print( "CDuplicateSelectPanelView.createSprite:".._image)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this is CDuplicateSelectPanelView createSprite:".._controlname)
    return _itemsprite
end

--创建CContainer
function CDuplicateSelectPanelView.createContainer( self, _controlname)
    print( "CDuplicateSelectPanelView.createContainer:".._controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( _controlname)
    return _itemcontainer
end

-----------------------------------------------------
--mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CDuplicateSelectPanelView.setLocalList( self)
    print("CDuplicateSelectPanelView.setLocalList")

end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CDuplicateSelectPanelView.clickCellCallBack(self,eventType, obj, x, y)   
    print( "eventType:",eventType," Type :",self.m_currentTag, obj :getTag())  
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pDuplicatePromptView :reset()
        _G.pDuplicateAllSView  :reset()
        if obj :getTag() == CDuplicateSelectPanelView.TAG_HERO then
            if self.m_rolelv < _G.Constant.CONST_COPY_HERO_LV_OPEN then                    
                print( "你等级不足:".._G.Constant.CONST_COPY_HERO_LV_OPEN.." 无法进入精英副本！")
                --CCMessageBox("你等级不足:",_G.Constant.CONST_COPY_HERO_LV_OPEN.." 无法进入精英副本！")
                require "view/ErrorBox/ErrorBox"
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("精英副本".._G.Constant.CONST_COPY_HERO_LV_OPEN.." 级开启！",func1)
                self.m_scenelayer: addChild(BoxLayer,1000)
                return false
            end
        elseif obj :getTag() == CDuplicateSelectPanelView.TAG_FIEND then
            if self.m_rolelv < _G.Constant.CONST_COPY_FIEND_LV_OPEN then                    
                print( "你等级不足:".._G.Constant.CONST_COPY_FIEND_LV_OPEN.." 无法进入魔王副本！")      
                --CCMessageBox("你等级不足:",_G.Constant.CONST_COPY_FIEND_LV_OPEN.." 无法进入魔王副本！") 
                require "view/ErrorBox/ErrorBox"
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("魔王副本".._G.Constant.CONST_COPY_FIEND_LV_OPEN.." 级开启！" ,func1)
                self.m_scenelayer: addChild(BoxLayer,1000)
                return false
            end
        end
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CDuplicateSelectPanelView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                print("关闭副本界面,开心")
                if _G.g_DuplicateMediator ~= nil then
                    _G.controller : unregisterMediator( _G.g_DuplicateMediator )
                    _G.g_DuplicateMediator = nil
                end
                CCDirector :sharedDirector() :popScene( )
                self:unloadResource()
            else
                print("objSelf = nil", self)
            end
        else
            if obj :getTag() ~= self.m_currentTag then
                self.m_currentTag    = obj :getTag()
                self.m_pageContainer :removeAllChildrenWithCleanup( true)
                local function func_create( )
                    local pduplicateview = CDuplicateView()
                    if obj :getTag() == CDuplicateSelectPanelView.TAG_COPY then
                        print(" 普通副本")                   
                        self.m_pageContainer = pduplicateview :layer( 101)                    
                    elseif obj :getTag() == CDuplicateSelectPanelView.TAG_HERO then
                        print(" 英雄副本")
                        self.m_pageContainer = pduplicateview :layer( 102)
                    elseif obj :getTag() == CDuplicateSelectPanelView.TAG_FIEND then
                        print(" 魔王副本")    
                        self.m_pageContainer = pduplicateview :layer( 103)       
                    end
                    self.m_characterPanelViewContainer :addChild( self.m_pageContainer)
                end
                ----[[
                local actarr = CCArray :create()
                local dela = CCDelayTime :create( 0.01 )
                local temp = CCCallFunc : create( func_create )
                actarr :addObject( dela)
                actarr :addObject( temp)
                local seq = CCSequence:create(actarr)
                self.m_scenelayer:runAction(seq)
                --]]
            else
                print( "两次选择了相同副本！")
            end
        end 
    end
end





















