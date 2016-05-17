--[[
 --CStartView
 --VS start主界面
 --]]


require "view/view"
require "mediator/mediator"
require "controller/command"

CStartView = class(view, function( self)
    print("CStartView:VS start主界面")
end)

_G.g_StartView = CStartView()
--Constant:
CStartView.FONT_SIZE      = 24
CStartView.SIZE_MAIN      = CCSizeMake( 854,640 )

--加载资源
function CStartView.loadResource( self)
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/effects_vs.plist")
end
--释放资源
function CStartView.unloadResource( self)
    if self.m_ccbiViewContainer ~= nil then
        print("释放资源1")
        self.m_role1CCBI : removeFromParentAndCleanup( true)
        self.m_role2CCBI : removeFromParentAndCleanup( true)
        self.m_VSCCBI : removeFromParentAndCleanup( true)
        self.m_role1CCBI = nil
        self.m_role2CCBI = nil
        self.m_VSCCBI = nil
        print("释放资源2")
        self.m_ccbiViewContainer : removeAllChildrenWithCleanup( true)
        print("释放资源3")
    end
    -- CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ChallengeResources/effects_vs.plist")
    -- CCTextureCache :sharedTextureCache():removeTextureForKey("ChallengeResources/effects_vs.pvr.ccz")

    for i,v in ipairs(self.m_createResStrList) do
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

--初始化数据成员
function CStartView.initParams( self, layer)
    print("CStartView.initParams")
    --self.m_mediator = CChallengePanelMediator( self)
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --倒计时回调注册
    --self :registerEnterFrameCallBack()
    local mainplay = _G.g_characterProperty :getMainPlay()
    self.m_role1namestr = mainplay :getName()
    self.m_role1lvstr   = mainplay :getLv()      --玩家声望
    self.m_role1powerstr= mainplay :getPowerful()
    self.m_role1prostr  = mainplay :getPro()

    self.m_role2namestr = self.m_roledata.name -- :getName()
    self.m_role2lvstr   = self.m_roledata.lv   -- :getLv()      --玩家声望
    self.m_role2powerstr= self.m_roledata.power-- :getPowerful()
    self.m_role2prostr  = self.m_roledata.pro  -- :getPro()

    self.m_createResStrList = {}
end

--释放数据成员
function CStartView.realeaseParams( self)

    -- if self.m_mediator ~= nil then
    --     _G.controller :unregisterMediator( self.m_mediator )
    -- end
end

--布局成员
function CStartView.layout( self, winSize)
    --背景
    self.m_background : setPreferredSize( winSize )
    self.m_background : setPosition( ccp( winSize.width/2, winSize.height/2 ) )
    
end

--主界面初始化
function CStartView.init(self, winSize, layer)
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

--返回界面 Scene
function CStartView.scene(self, _roledata)
    self.m_roledata = _roledata
    -------------------------------------
    print("create scene")
    self.m_scene  = CCScene :create()
    self.m_scene :addChild( self : layer())
    return self.m_scene
end

--返回界面 Container
function CStartView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CStartView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化界面
function CStartView.initView(self, layer)
    print("CStartView.initView")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --背景
    self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CFirstTopupGiftView self.m_background 26 ")    
    layer : addChild( self.m_background )
    --CCBI 容器
    self.m_ccbiViewContainer = CContainer :create()
    self.m_ccbiViewContainer : setControlName("this is CStartView self.m_ccbiViewContainer 94 ")
    layer :addChild( self.m_ccbiViewContainer)
    --Attr Label 容器
    self.m_attrLabelContainer = CContainer :create()
    self.m_attrLabelContainer : setControlName("this is CStartView self.m_attrLabelContainer 94 ")
    layer :addChild( self.m_attrLabelContainer)

    -- VS CCBI 事件 
    local function local_VSCCBICallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_VSCCBICallFunc  "..eventType )
            arg0 : play("run")
        elseif eventType == "AnimationComplete" then
            --移动CCBI
            print("关闭VS界面，进入战斗界面")
            self :unloadResource()
            local comm = CStageREQCommand(_G.Protocol["REQ_ARENA_BATTLE"])
            comm : setOtherData( {uid = self.m_roledata.uid, rank = self.m_roledata.ranking})  --{uid=obj :getTag(),rank=role.ranking}
            controller : sendCommand( comm )
        end
    end
    -- 主角自己 CCBI 事件 
    local function local_role1CCBICallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run"..(self.m_role1prostr or 1))
        end
    end
    -- 主角对手 CCBI 事件 
    local function local_role2CCBICallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run"..(self.m_role2prostr or 2))
        end
    end

    -- 创建all CCBI
    local function local_createAllCCBI()
        print("创建all CCBI")
        --猪脚
        self.m_role1CCBI = CMovieClip:create( "ccbResources/effects_vs1.ccbi" )
        self.m_role1CCBI : setControlName( "this CSelectServerScene self.m_role1CCBI 84")
        self.m_role1CCBI : registerControlScriptHandler( local_role1CCBICallFunc )
        self.m_role1CCBI : setScaleX( -1)
        self.m_role1CCBI : setPosition( 25, winSize.height*0.7-15)
        self.m_ccbiViewContainer : addChild( self.m_role1CCBI )
        --猪脚对头
        self.m_role2CCBI = CMovieClip:create( "ccbResources/effects_vs1.ccbi" )
        self.m_role2CCBI : setControlName( "this CSelectServerScene self.m_role2CCBI 84")
        self.m_role2CCBI : registerControlScriptHandler( local_role2CCBICallFunc )
        self.m_role2CCBI : setPosition( winSize.width-25, winSize.height*0.1+15)
        self.m_ccbiViewContainer : addChild( self.m_role2CCBI )
        --VS
        self.m_VSCCBI = CMovieClip:create( "ccbResources/effects_vs2.ccbi" )
        self.m_VSCCBI : setControlName( "this CSelectServerScene self.m_VSCCBI 84")
        self.m_VSCCBI : registerControlScriptHandler( local_VSCCBICallFunc )
        self.m_VSCCBI : setPosition( winSize.width*0.5, winSize.height*0.5)
        self.m_ccbiViewContainer : addChild( self.m_VSCCBI )
    end
    -- 创建人物属性
    local function local_createAttr()
        print("local_createAttr")
        --猪脚
        self.m_role1name = self :createLabel( "姓名: "..(self.m_role1namestr or "无名猪脚"))
        self.m_role1lv   = self :createLabel( "等级: "..(self.m_role1lvstr or "E 99"))
        self.m_role1power= self :createLabel( "战斗力: "..(self.m_role1powerstr or "E 99999"))

        self.m_role1name :setPosition( ccp( winSize.width*0.5-50, winSize.height*0.8+55))
        self.m_role1lv   :setPosition( ccp( winSize.width*0.5, winSize.height*0.8+10))
        self.m_role1power:setPosition( ccp( winSize.width*0.5+30, winSize.height*0.8-35))

        self.m_attrLabelContainer : addChild( self.m_role1name, 2)
        self.m_attrLabelContainer : addChild( self.m_role1lv, 2)
        self.m_attrLabelContainer : addChild( self.m_role1power, 2)
        --猪脚的对头
        self.m_role2name = self :createLabel( "姓名: "..(self.m_role2namestr or "无名猪脚"))
        self.m_role2lv   = self :createLabel( "等级: "..(self.m_role2lvstr or "E 99"))
        self.m_role2power= self :createLabel( "战斗力: "..(self.m_role2powerstr or "E 99999"))

        self.m_role2name :setPosition( ccp( winSize.width*0.5+50, winSize.height*0.25+55))
        self.m_role2lv   :setPosition( ccp( winSize.width*0.5, winSize.height*0.25+10))
        self.m_role2power:setPosition( ccp( winSize.width*0.5, winSize.height*0.25-35))

        self.m_attrLabelContainer : addChild( self.m_role2name, 2)
        self.m_attrLabelContainer : addChild( self.m_role2lv, 2)
        self.m_attrLabelContainer : addChild( self.m_role2power, 2)        
    end
    local function local_deleteAttr()
        print("local_deleteAttr")
        self.m_attrLabelContainer : removeFromParentAndCleanup( true)
    end

    -- local function local_pauseAction()
    --     print("暂停所有动作")
    --     layer : pauseAllTargets()
    -- end
    -- local function local_resumeAction()
    --     print("继续所有动作")
    --     local_deleteAttr()
    --     layer : update()
    -- end
    -- 延迟
    print("延迟 time 创建CCBI")
    layer : performSelector( 0, local_createAllCCBI )
    layer : performSelector( 0.66, local_createAttr)
    layer : performSelector( 1.76, local_deleteAttr)
    -- layer : performSelector( 1.76, local_pauseAction)
    -- layer : performSelector( 3.76, local_resumeAction)
end

--创建Label ，可带颜色
function CStartView.createLabel( self, _string, _color)
    print("CStartView.createLabel:".._string)
    if _string == nil then
        _string = " "
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CStartView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

-----------------------------------------------------
--help func 逻辑相关
-----------------------------------------------------
--通过_uid查找数据，错误返回false
function CStartView.getRoleByUid( self, _uid)
    for k,v in pairs( self.m_challengeplayerlist) do
        print("XXXXXX:",k,_uid,v.uid,v.name)
        if v.uid == _uid then
            return v
        end
    end
    return false
end

-----------------------------------------------------
--mediator返回数据更新界面
-----------------------------------------------------
--更新界面
function CStartView.setLocalList( self)
    print("CStartView.setLocalList")

end
-----------------------------------------------------
--回调函数
-----------------------------------------------------
--单击回调
function CStartView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if obj : getTag() == CStartView.TAG_CLOSED then

            end
        end
    end
end

