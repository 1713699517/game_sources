--[[
 --CBuildTeamView
 --组队主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/BuildTeamMediator"


CBuildTeamView = class(view, function( self)
print("CBuildTeamView:组队主界面")

end)
--Constant:
--副本类型 ：普通  英雄  魔王
CBuildTeamView.TAG_GENERAL      = 201
CBuildTeamView.TAG_HERO         = 202
CBuildTeamView.TAG_DEVILKING    = 203

CBuildTeamView.TAG_CLOSED       = 205
CBuildTeamView.TAG_BUILDTEAM    = 206
CBuildTeamView.TAG_SELECTLEVEL  = 207
CBuildTeamView.TAG_ENTERPOINTS  = 208
CBuildTeamView.TAG_ALLTEAM      = 209

CBuildTeamView.TAG_TEAMINFOCELL = 300

CBuildTeamView.PER_PAGE_COUNT   = 4

--加载资源
function CBuildTeamView.loadResource( self)

    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TeamViewResources/TeamViewResources.plist")
end

--释放资源
function CBuildTeamView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TeamViewResources/TeamViewResources.plist")
    CCTextureCache :sharedTextureCache()        :removeTextureForKey("TeamViewResources/TeamViewResources.plist")
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end
--初始化数据成员
function CBuildTeamView.initParams( self, layer)

    --mediator注册
    _G.g_CBuildTeamMediator = CBuildTeamMediator (self)
    controller :registerMediator(  _G.g_CBuildTeamMediator )

    print("self.taskType ",self.taskType )
    if self.taskType ~= nil  and self.taskType > 0 then
        self : NetWorkSend(self.taskType)             --请求队伍面板
        self : TeamPassReqNetWorkSend (self.taskType) --通过副本 给那个scrollview弹出框用的
    end


    local id       = self.sceneId
    if id ~= nil and id > 0 then
        local CopyName,CopyType = self : getTaskName(id)
        self.m_selectLevelButton : setText(CopyName)
        
        self : setNowTheCopyType(CopyType) --获取副本的大类型 普通 精英 魔王
    else
         self.m_selectLevelButton : setText("--所有--")
    end

    -- self.isSceneType   = 0  --初始化判断是否是大类 默认为0 场景副本ID
    self.CopyListData     = {} --副本数据初始化
    self.CopyListCount    = 0
    self.isSelectOrClosed = 0  --点击一次开一个关
    self.isSelectOpen     = 0  --判断如果下啦列表打开就不让他进组队的队伍

end

 --获取副本的大类型 普通 精英 魔王
function CBuildTeamView.setNowTheCopyType( self ,_CopyType)
    self.NowTheCopyType = tonumber(_CopyType) 
end
function CBuildTeamView.getNowTheCopyType( self )
    return self.NowTheCopyType 
end

--释放成员
function CBuildTeamView.realeaseParams( self)

end

--布局成员
function CBuildTeamView.layout( self, winSize)
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640

    if winSize.height == 640 then
        print("640--组队主界面")
        self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)              --总底图

        local buildteambackgroundfirst  = self.m_buildTeamViewContainer :getChildByTag( 100)
        local teamlistbackground        = self.m_buildTeamViewContainer :getChildByTag( 101)
        local fieldNameLabel            = self.m_teamContainer :getChildByTag( 104)

        local closedButtonSize          = self.m_closedButton :getContentSize()
        --local tagButtonSize             = self.m_heroButton :getContentSize()

        buildteambackgroundfirst  : setPreferredSize(CCSizeMake(854,640))
        teamlistbackground        : setPreferredSize(CCSizeMake(800,460))
        fieldNameLabel            : setPreferredSize(CCSizeMake(800,55))

        self.m_selectLevelButton  : setPreferredSize( CCSizeMake( 300,45))

        buildteambackgroundfirst  : setPosition(IpadSizeWidth/2,IpadSizeheight/2)
        teamlistbackground        : setPosition(IpadSizeWidth/2,460/2+90)
        fieldNameLabel            : setPosition( IpadSizeWidth/2,IpadSizeheight-100)

        --self.m_tagLayout          : setPosition( 50, IpadSizeheight-tagButtonSize.height/2-10)

        self.m_closedButton       : setPosition( ccp( IpadSizeWidth-closedButtonSize.width/2, IpadSizeheight-closedButtonSize.height/2))

        self.m_selectLevelButton  : setPosition( ccp( IpadSizeWidth*0.5,IpadSizeheight-10-30))
        -- self.m_selectLevelButton  : setPosition( ccp( IpadSizeWidth*0.7,IpadSizeheight-tagButtonSize.height/2-10))
        self.m_buildTeamButton    : setPosition( ccp( IpadSizeWidth*0.7, IpadSizeheight*0.08))
        self.m_AllTeamButton      : setPosition( ccp( IpadSizeWidth*0.9, IpadSizeheight*0.08))
        --self.m_enterPointsButton  : setPosition( ccp( IpadSizeWidth*0.9, IpadSizeheight*0.08))

    elseif winSize.height == 768 then
        CCLOG("768--组队主界面")
    end
end

--主界面初始化
function CBuildTeamView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化界面
    self.initView(self, layer,winSize)
    --布局成员
    self.layout(self, winSize)
    --初始化数据
    self.initParams(self,layer)
end

function CBuildTeamView.scene(self,_sceneId,_taskType,_isunregisterMediator)
    print("CBuildTeamView create scene")
    self.sceneId       = tonumber(_sceneId)
    self.transSceneId  = tonumber(_sceneId)
    self.taskType      = tonumber(_taskType)
    self.isunregisterMediator = _isunregisterMediator
    self.isSceneType   = 0  --初始化判断是否是大类 默认为0 场景副本ID
    if  self.sceneId == nil and self.taskType ~= nil then
        self.isSceneType   = 1 --初始化判断是否是大类 默认为0 场景副本ID
    end

    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self._scene       = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CBuildTeamView self.m_scenelayer 105")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBuildTeamView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CBuildTeamView self.m_scenelayer 116")

    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CBuildTeamView.initView(self, layer,winSize)
    print("CBuildTeamView.initHangupView")

    local IpadWidthSize =854
    local function BackGroundCellCallBack(eventType, obj, touches)
        return self : BackGroundCellCallBack(eventType, obj, touches)
    end
    --底图
    self.m_allBackGroundSprite   = CSprite : createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_allBackGroundSprite   : setTouchesPriority(-10)
    self.m_allBackGroundSprite   : setTouchesEnabled( true)
    self.m_allBackGroundSprite   : registerControlScriptHandler( BackGroundCellCallBack, "this CBuildTeamView self.m_allBackGroundSprite 193")
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(winSize.width,winSize.height))
    layer :addChild(self.m_allBackGroundSprite,-2)

    --副本界面容器
    self.m_buildTeamViewContainer = CContainer :create()
    self.m_buildTeamViewContainer : setPosition(winSize.width/2-IpadWidthSize/2,0)

    self.m_buildTeamViewContainer : setControlName( "this is CBuildTeamView self.m_buildTeamViewContainer 127")

    layer :addChild( self.m_buildTeamViewContainer)

    local function CellCallBack( eventType, obj, x, y)
        print("callbacak come in ")
        return self : clickCellCallBack( eventType, obj, x, y)
    end
    local buildteambackgroundfirst  = CSprite :createWithSpriteFrameName( "general_first_underframe.png")    --背景Img
    local teamlistbackground        = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img

    buildteambackgroundfirst        : setControlName( "this CBuildTeamView buildteambackgroundfirst 138 ")
    teamlistbackground              : setControlName( "this CBuildTeamView teamlistbackground 139 ")

    -- self.m_generalButton            = CButton :createWithSpriteFrameName( "普通", "general_label_normal.png")
    -- self.m_heroButton               = CButton :createWithSpriteFrameName( "英雄", "general_label_normal.png")
    -- self.m_devilkingButton          = CButton :createWithSpriteFrameName( "魔王", "general_label_normal.png")
    self.m_closedButton             = CButton :createWithSpriteFrameName( "", "general_close_normal.png")

    self.m_closedButton : setTag(CBuildTeamView.TAG_CLOSED)

    -- self.m_generalButton   : setControlName( "this CBuildTeamView self.m_generalButton 146 " )
    -- self.m_heroButton      : setControlName( "this CBuildTeamView self.m_heroButton 147 " )
    -- self.m_devilkingButton : setControlName( "this CBuildTeamView self.m_devilkingButton 148 " )
    self.m_closedButton    : setControlName( "this CBuildTeamView self.m_closedButton 149 " )

    -- self.m_generalButton   : setFontSize( 24)
    -- self.m_heroButton      : setFontSize( 24)
    -- self.m_devilkingButton : setFontSize( 24)

    -- self.m_generalButton   : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_generalButton 155")
    -- self.m_heroButton      : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_heroButton 156")
    -- self.m_devilkingButton : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_devilkingButton 157")
    self.m_closedButton    : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_closedButton 158")

    --self.m_tagLayout     = CHorizontalLayout :create()
    --local cellButtonSize = self.m_generalButton :getContentSize()
    -- self.m_tagLayout :setVerticalDirection(false)
    -- self.m_tagLayout :setCellHorizontalSpace( 20)
    -- self.m_tagLayout :setLineNodeSum(3)
    -- self.m_tagLayout :setCellSize( CCSizeMake(110,55))

    -- self.m_tagLayout :addChild( self.m_generalButton, 1, CBuildTeamView.TAG_GENERAL)
    -- self.m_tagLayout :addChild( self.m_heroButton, 1, CBuildTeamView.TAG_HERO)
    -- self.m_tagLayout :addChild( self.m_devilkingButton, 1, CBuildTeamView.TAG_DEVILKING)
    self.m_buildTeamViewContainer :addChild( buildteambackgroundfirst, -1, 100)
    self.m_buildTeamViewContainer :addChild( teamlistbackground, -1, 101)
    --self.m_buildTeamViewContainer :addChild( self.m_tagLayout)
    self.m_buildTeamViewContainer :addChild( self.m_closedButton, 2, CBuildTeamView.TAG_CLOSED)

    --TeamList界面
    self.m_teamContainer = CContainer :create()
    self.m_teamContainer : setControlName( "this is CBuildTeamView self.m_teamContainer 168")
    self.m_buildTeamViewContainer :addChild( self.m_teamContainer)

    self.m_selectLevelButton = CButton :createWithSpriteFrameName( "是大魔王", "general_second_underframe.png")
    self.m_buildTeamButton   = CButton :createWithSpriteFrameName( "创建队伍", "general_button_normal.png")
    self.m_AllTeamButton     = CButton :createWithSpriteFrameName( "所有关卡", "general_button_normal.png")

    -- self.m_enterPointsButton = CButton :createWithSpriteFrameName( "进入关卡", "general_button_normal.png")
    self.m_selectLevelButton : setControlName( "this CBuildTeamView self.m_selectLevelButton 178 " )
    self.m_buildTeamButton   : setControlName( "this CBuildTeamView self.m_buildTeamButton 179 " )
    self.m_AllTeamButton     : setControlName( "this CBuildTeamView self.m_AllTeamButton 179 " )
    --self.m_enterPointsButton : setControlName( "this CBuildTeamView self.m_enterPointsButton 179 " )

    -- self.m_selectLevelButtonSprite = CSprite : createWithSpriteFrameName("team_dropdown_click.png")
    -- self.m_selectLevelButtonSprite : setPosition(130,0)
    -- self.m_selectLevelButton : addChild(self.m_selectLevelButtonSprite,10)

    --local selectLevelLabel   = CCLabelTTF :create( "关卡", "Arial", 30)-- string.format("%d/%d",tonumber(self.m_curgoodsnum),tonumber(self.m_maxgoodsnum))
    --local partingLineSprite  = CSprite :createWithSpriteFrameName( "general_dividing_line.png") --我是无耻的分割线
    --partingLineSprite        : setControlName( "this CBuildTeamView partingLineSprite 187 ")
    --local fieldNameLabel     = CCLabelTTF :create( string.format( "        队长名                  队长等级                  关卡名                  队伍人数"), "Arial", 27)
    local fieldNameLabel     = CButton :createWithSpriteFrameName("        队长名                  队长等级                  关卡名                  队伍人数", "team_titlebar_underframe.png")
    fieldNameLabel           : setFontSize(24)
    fieldNameLabel           : setColor(ccc4(90,152,225,255))

    self.m_selectLevelButton : setFontSize( 24)
    self.m_buildTeamButton   : setFontSize( 24)
    self.m_AllTeamButton     : setFontSize( 24)
    --self.m_enterPointsButton : setFontSize( 24)

    --self.m_selectLevelButton : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_selectLevelButton 193")
    self.m_buildTeamButton   : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_buildTeamButton 194")
    self.m_AllTeamButton     : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_buildTeamButton 194")
    --self.m_enterPointsButton : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_enterPointsButton 194")

    self.m_teamContainer :addChild( self.m_selectLevelButton, 1, CBuildTeamView.TAG_SELECTLEVEL)
    self.m_teamContainer :addChild( self.m_buildTeamButton, 1, CBuildTeamView.TAG_BUILDTEAM)
    self.m_teamContainer :addChild( self.m_AllTeamButton, 1, CBuildTeamView.TAG_ALLTEAM)
    --self.m_teamContainer :addChild( self.m_enterPointsButton, 1, CBuildTeamView.TAG_ENTERPOINTS)
    --self.m_teamContainer :addChild( selectLevelLabel, 1, 102)
    --self.m_teamContainer :addChild( partingLineSprite, 1, 103)
    self.m_teamContainer :addChild( fieldNameLabel, 100, 104)

    --TeamList 的Page ScrollView
    local teamListContainer = CContainer :create()
    teamListContainer : setPosition( ccp( IpadWidthSize*0.130,640*0.55))
    teamListContainer : setControlName( "this is CBuildTeamView teamListContainer 191")
    teamListContainer :setTag( 105)
    self.m_teamContainer :addChild( teamListContainer)

    -- local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local checkpointImgSize  = CCSizeMake( 240, 180)
    local viewSize     = CCSizeMake( 854, 390+5)
    self.m_pScrollView = CPageScrollView :create(2,viewSize)
    --self.m_pScrollView : setPosition( ccp( -winSize.width*0.3+15, winSize.height*0.1-40 ))
    self.m_pScrollView : setPosition( ccp( -90, -250)) ---winSize.width*0.1, winSize.height*0.1
    teamListContainer  : addChild( self.m_pScrollView)

end

function CBuildTeamView.showCheckPointView( self, _checkpoints)

end

--更新本地list数据
function CBuildTeamView.setLocalList( self)
    print("CBuildTeamView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CBuildTeamView.clickCellCallBack(self,eventType,obj,x,y)
    print("come in  the clickCellCallBack ")
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        local Value_Tag =  obj: getTag()
        if Value_Tag == CBuildTeamView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                if _G.g_CBuildTeamMediator ~= nil then
                    controller :unregisterMediator(_G.g_CBuildTeamMediator)
                    _G.g_CBuildTeamMediator = nil
                end
                if self.isunregisterMediator ~= nil and self.isunregisterMediator == 1 then
                    if _G.g_DuplicateMediator ~= nil then --此为主界面组队按钮的副本mediator注销
                        _G.controller : unregisterMediator( _G.g_DuplicateMediator )
                        _G.g_DuplicateMediator = nil
                    end
                end
                --self.m_scenelayer : removeFromParentAndCleanup(true)
                CCDirector :sharedDirector() :popScene( self._scene)

                self:unloadResource()
            else
                print("objSelf = nil", self)
            end
        elseif Value_Tag == CBuildTeamView.TAG_SELECTLEVEL then
            print( "选择关卡啦")
            if self.isSelectOrClosed == 0 then
                if self.CopyListData ~= nil and self.CopyListCount > 0  then
                    self : removeSelectLevelViewlayer() --删除那个什么下啦列表
                    require "view/DuplicateLayer/SelectLevelView"
                    self.pSelectLevelView         = CSelectLevelView()
                    self.pSelectLevelViewlayer    = nil
                    self.pSelectLevelViewlayer    = self.pSelectLevelView : layer(self.CopyListData,self.CopyListCount)
                    self.pSelectLevelViewlayer    : setPosition(120-1,50)
                    self.m_buildTeamViewContainer : addChild(self.pSelectLevelViewlayer ,10)
                else
                    local msg = "没有其他开启副本数据"
                    self : createMessageBox(msg)
                end
                self.isSelectOrClosed = 1
                self.isSelectOpen     = 1
            elseif self.isSelectOrClosed == 1 then

                self : removeSelectLevelViewlayer() --删除那个什么下啦列表
                self.isSelectOrClosed = 0
                self.isSelectOpen     = 0
            end

        elseif Value_Tag == CBuildTeamView.TAG_ENTERPOINTS then
            print( "进入关卡")
            --self : EnterPointsBtnNetWorkSend()
            if self.sceneId ~= nil  and  self.sceneId > 0 then
                local value = self : compareEnengyByCopyId(self.sceneId)
                if value  == 1 then
                    self : EnterPointsBtnNetWorkSend(self.sceneId)
                elseif value  == 1 then
                    local msg = "精力不足,不能进入关卡"
                    self : createMessageBox(msg)
                end
            else
                local msg = "暂未选择关卡，无法进入"
                self : createMessageBox(msg)
            end
        elseif Value_Tag == CBuildTeamView.TAG_BUILDTEAM then
            print( " 创建队伍",self.sceneId)

            if self.sceneId ~= nil  and tonumber(self.sceneId)  > 0 then
                require "view/DuplicateLayer/GenerateTeamView"
                local pGenerateTeamView = CGenerateTeamView()
                CCDirector : sharedDirector () : pushScene( pGenerateTeamView :scene(1,self.sceneId))

                print("创建队伍协议发送11")
                self : TeamCreateBtnNetWorkSend(self.sceneId)
            else
                local msg = "请先选择一个副本才可创建队伍"
                self : createMessageBox(msg)
            end
        elseif Value_Tag == CBuildTeamView.TAG_ALLTEAM then
            print( " 所有关卡,关卡类型")
            self.m_buildTeamButton : setTouchesEnabled(false)

            local nowCopyType = self : getNowTheCopyType()
            if nowCopyType ~= nil then
                self : NetWorkSend(nowCopyType)
                self.isSceneType = 1 --判断是否是大类
                self : setCopyBtnName(nowCopyType) --设置副本名称
            end
        elseif Value_Tag == CBuildTeamView.TAG_GENERAL then
            print(" 普通副本队伍")
            self : removeSelectLevelViewlayer() --删除那个什么下啦列表
            self : NetWorkSend(1)
            self : TeamPassReqNetWorkSend (_G.Constant.CONST_COPY_TYPE_NORMAL) --通过副本 给那个scrollview弹出框用的
            self.isSceneType = 1 --判断是否是大类
        elseif Value_Tag == CBuildTeamView.TAG_HERO then
            print(" 英雄副本队伍")
            self : removeSelectLevelViewlayer() --删除那个什么下啦列表
            self : NetWorkSend(2)
            self : TeamPassReqNetWorkSend (_G.Constant.CONST_COPY_TYPE_HERO)   --通过副本 给那个scrollview弹出框用的
            self.isSceneType = 1 --判断是否是大类
        elseif Value_Tag == CBuildTeamView.TAG_DEVILKING then
            print(" 魔王副本队伍")
            self : removeSelectLevelViewlayer() --删除那个什么下啦列表
            self : NetWorkSend(3)
            self : TeamPassReqNetWorkSend (_G.Constant.CONST_COPY_TYPE_FIEND)  --通过副本 给那个scrollview弹出框用的
            self.isSceneType = 1 --判断是否是大类
        elseif Value_Tag ~= nil then
            self : removeSelectLevelViewlayer() --删除那个什么下啦列表
            print("XXXXXXXX413")
            -- print("XXXXXXXX进入",obj :getTag(), "的队伍")
            ----[[
            -- require "view/DuplicateLayer/GenerateTeamView"
            -- local pGenerateTeamView = CGenerateTeamView()
            -- CCDirector : sharedDirector () : pushScene( pGenerateTeamView :scene( 0))
            --]]
        end

    end
end

function CBuildTeamView.setCopyBtnName( self,_Type )
    local msg = nil 
    if _Type == 1 then
        msg = "普通副本"
    elseif _Type == 2 then
        msg = "精英副本"
    elseif _Type == 3 then
        msg = "魔王副本"
    end
    self.m_selectLevelButton : setText(msg)
    print("名字更完",_Type,msg)
end

function CBuildTeamView.removeSelectLevelViewlayer(self)
    if self.pSelectLevelView  ~= nil then
        self.pSelectLevelView : removeMySelf()
        self.pSelectLevelView = nil
    end
end


function CBuildTeamView.NetWorkSend(self,_taskType)
    local  taskType =tonumber(_taskType)
    if taskType ~= nil  and  taskType > 0 then
        --向服务器发送制作请求
        require "common/protocol/auto/REQ_TEAM_REQUEST"
        local msg = REQ_TEAM_REQUEST()
        msg : setType(taskType)  --类型
        CNetwork : send(msg)
        print("CBuildTeamView REQ_TEAM_REQUEST send,完毕 325")
    end
end

--多点触控
function CBuildTeamView.m_teamInfoBtnCallBack(self, eventType, obj, touches)
    print("m_teamInfoBtnCallBack eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)
                    self.transfId = obj:getTag()

                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end

        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    print ("多点触控～～",self.transfId,self.theTeamNum[self.transfId].num)
                    if self.isSelectOpen == 0 then
                        if self.transfId ~= nil and  self.transfId > 0 then
                            if self.theTeamNum[self.transfId].num < 3 then
                                self : TeamJoinNetWorkSend(self.transfId)

                                require "view/DuplicateLayer/GenerateTeamView"
                                local pGenerateTeamView = CGenerateTeamView()
                                CCDirector : sharedDirector () : pushScene( pGenerateTeamView :scene(0,self.theTeamNum[self.transfId].copy_id))
                            elseif self.theTeamNum[self.transfId].num == 3 then
                                local msg = "队伍人数已满，不能进入"
                                self : createMessageBox(msg)
                            end
                        end
                    end
                end
            end
        end
        self.touchID = nil
    end
end


function CBuildTeamView.pushData(self,_Type,_Count,_TeamListData)
    print("CBuildTeamView.pushData 刷一刷",_Type,_Count,_TeamListData)
    local Type          = _Type          --副本类型
    local Count         = _Count         --队伍数量
    local TeamListData  = _TeamListData  --队伍数据
    local sceneId       = self.sceneId   --初始化点击进来的副本id


    self : cleanViewData()           --清除旧数据
    if self.isSceneType == 0 and sceneId ~=nil and sceneId > 0 then    --判断是否是大类 1是大类 0是某副本id
       local selectedTeamCount,selectedTeamData = self : selectedTeam(sceneId,TeamListData) --挑选出所在副本的队伍
       print("selectedTeamCount",selectedTeamCount)
        if selectedTeamCount > 0 then
            self : initScrollView(selectedTeamCount) --初始化ScrollView界面
            for k,v in pairs(selectedTeamData) do
                print("某副本--->",k,v)
            end
            self : initScrollViewData(selectedTeamData)
        end

    elseif self.isSceneType == 1 then --判断是否是大类 1是大类 0是某副本id
        if Count > 0 then
            self : initScrollView(Count)             --初始化ScrollView界面
            for k,v in pairs(TeamListData) do
                print("某大类--->",k,v)
            end
            self : initScrollViewData(TeamListData)
        end
    end
end

function CBuildTeamView.pushTransfData(self,_Type,_Count,_TeamListData,_transfSceneId)
    print("CBuildTeamView.pushTransfData 刷一刷",_Type,_Count,_TeamListData,_transfSceneId)
    local Type          = _Type          --副本类型
    local Count         = _Count         --队伍数量
    local TeamListData  = _TeamListData  --队伍数据
    local transfSceneId = _transfSceneId --通过SelectLevelView传递过来的场景id
    self.sceneId        = _transfSceneId

    self : cleanViewData()           --清除旧数据
    if transfSceneId > 0 then
        local selectedTeamCount,selectedTeamData = self : selectedTeam(transfSceneId,TeamListData) --挑选出所在副本的队伍

        if selectedTeamCount > 0 then
            self : initScrollView(selectedTeamCount) --初始化ScrollView界面
            self : initScrollViewData(selectedTeamData)

            for k,v in pairs(selectedTeamData) do
                print("传递过来的副本--->",k,v)
            end
        end
    end

    local CopyName,CopyType = self : getTaskName(transfSceneId)
    self.m_selectLevelButton : setText(CopyName)
    print("为什么是你你你你你",transfSceneId,CopyName)
end

function CBuildTeamView.getCopyListDataFromSever(self,_Type,_Count,_CopyListData)
    print("CBuildTeamView.getCopyListDataFromSever 刷一刷1011",_Type,_Count,_CopyListData)
    local Type         = _Type          --副本类型
    self.CopyListCount = _Count         --副本数量
    self.CopyListData  = _CopyListData  --副本数据

    if self.transSceneId ~= nil then
        print("fuck")
        self.transSceneId = nil
    else
        if _Count ~= nil and tonumber(_Count) > 0 then
            local CopyName,CopyType = self : getTaskName(_CopyListData[1].copy_id)
            self.m_selectLevelButton : setText(CopyName)
            self.sceneId = _CopyListData[1].copy_id
        end
    end
end

function CBuildTeamView.selectedTeam(self,_sceneId,_TeamListData) --选中的副本的队伍
    local  Teamcount  = 0
    local  TeamData   = {}
    for k,v in pairs(_TeamListData) do
        if v.copy_id == _sceneId then
            Teamcount   = Teamcount + 1
            TeamData[k] = v
        end
    end
    return Teamcount,TeamData
end

function CBuildTeamView.cleanViewData(self) --数据请除
    if self.m_pScrollView ~= nil then
        --self.m_pScrollView : removeAllChildrenWithCleanup( true)
        --local m_pageCount, m_lastPageCount = self :getPageAndLastCount( _Count, CBuildTeamView.PER_PAGE_COUNT)
        local  counts = self.m_pScrollView : getPageCount()
        if counts > 0 then
            for i=1,counts do
                self.m_pScrollView : removePageByIndex(0)
            end
        end
    end
end

function CBuildTeamView.initScrollViewData(self,_data) --初始化ScrollView数据
    -- local LeaderName   = nil  --队长名字
    -- local LeaderLv     = nil  --队长等级
    -- local TaskName     = nil  --关卡名字
    -- local TeamPeoCount = nil  --队伍人数
    local text      = nil
    self.theTeamNum = {}
    for k,v in pairs(_data) do

        local Copyid      = v.copy_id --副本id
        local CopyName = self : getTaskName(Copyid)
        --team_id --队伍id
       -- text = v.leader_name.."            "..v.leader_lv.."            "..CopyName.."            "..v.num.."/3"
        --self.m_teamInfoBtn[k] : setText (text)
        self.theLeaderName[k]    : setString(v.leader_name)
        self.theLeaderLv[k]      : setString(v.leader_lv)
        self.theCopyName[k]      : setString(CopyName)
        self.theCopyTeamCount[k] : setString(v.num.."/3")

        print("the team id = ",v.team_id)
        self.m_teamInfoBtn[k] : setTag (v.team_id)
        self.theTeamNum[v.team_id]     = {}
        self.theTeamNum[v.team_id].num = v.num
        self.theTeamNum[v.team_id].copy_id = v.copy_id

    end
end

function CBuildTeamView.initScrollView(self,_Count) --初始化ScrollView界面
    local function CellCallBack(eventType, obj, touches)
        return self : m_teamInfoBtnCallBack(eventType, obj, touches)
    end

    self.m_teamInfoBtn  = {}
    self.theLeaderName     = {}
    self.theLeaderLv       = {}
    self.theCopyName       = {}
    self.theCopyTeamCount  = {}
    local pageContiner   = {}
    self.m_lastPageCount = 0
    self.m_pageCount     = 1
    local num            = 0
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local teaminfoCellSize = CCSizeMake( 800, 65)
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( _Count, CBuildTeamView.PER_PAGE_COUNT)
    print("self.m_pageCount--->",self.m_pageCount,"self.m_lastPageCount-->",self.m_lastPageCount)
    for i=tonumber(self.m_pageCount),1,-1  do

        pageContiner[i] = CContainer : create()
        pageContiner[i] : setControlName( "this is CEquipEnchantView pageContainer[i] 74" )

        local layout = CHorizontalLayout :create()
        pageContiner[i] : addChild( layout)
        layout       : setPosition( -420, 165) --460 -175 -winSize.width/2*0.9583, -winSize.height/2*0.546875
        layout       : setVerticalDirection( false)
        layout       : setCellVerticalSpace( 5)
        layout       : setLineNodeSum( 1)
        layout       : setCellSize( teaminfoCellSize)

        if i == self.m_pageCount  then
            local tempnum = self.m_lastPageCount
            for j=1,tempnum do
                num = (i-1)*4+j
                --self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."我是大魔王            梁山好汉            我是小黄            0／3", "general_second_underframe.png")
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( "", "general_second_underframe.png")
                self.m_teamInfoBtn[num] : setControlName( "this CBuildTeamView self.m_teamInfoBtn[num] 383 "..tostring(i).."  "..tostring(j) )
                self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setTouchesPriority(-20)
                self.m_teamInfoBtn[num] : setFontSize( 30)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])

                self.theLeaderName[num]    = CCLabelTTF : create("我是大魔王", "Arial", 27)
                self.theLeaderLv[num]      = CCLabelTTF : create("梁山好汉", "Arial", 27)
                self.theCopyName[num]      = CCLabelTTF : create("我是小黄", "Arial", 27)
                self.theCopyTeamCount[num] = CCLabelTTF : create("0／3", "Arial", 27)


                self.theLeaderName[num]    : setPosition(-300,0)
                self.theLeaderLv[num]      : setPosition(-90,0)
                self.theCopyName[num]      : setPosition(130,0)
                self.theCopyTeamCount[num] : setPosition(340,0)

                self.m_teamInfoBtn[num]    : addChild( self.theLeaderName[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theLeaderLv[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theCopyName[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theCopyTeamCount[num],10)

            end
        else
            local tempnum = CBuildTeamView.PER_PAGE_COUNT
            for j=1,tempnum do
                num = (i-1)*4+j
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( "", "general_second_underframe.png")
                --self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."我是大魔王            梁山好汉            我是小黄            0／3", "general_second_underframe.png")
                self.m_teamInfoBtn[num] : setControlName( "this CBuildTeamView self.m_teamInfoBtn[num] 396 "..tostring(i).."  "..tostring(j) )
                self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setFontSize( 30)
                --self.m_teamInfoBtn[num] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*4+j)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CBuildTeamView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])

                self.theLeaderName[num]    = CCLabelTTF : create("我是大魔王", "Arial", 27)
                self.theLeaderLv[num]      = CCLabelTTF : create("梁山好汉", "Arial", 27)
                self.theCopyName[num]      = CCLabelTTF : create("我是小黄", "Arial", 27)
                self.theCopyTeamCount[num] = CCLabelTTF : create("0／3", "Arial", 27)


                self.theLeaderName[num]    : setPosition(-320,0)
                self.theLeaderLv[num]      : setPosition(-100,0)
                self.theCopyName[num]      : setPosition(150,0)
                self.theCopyTeamCount[num] : setPosition(370,0)

                self.m_teamInfoBtn[num]    : addChild( self.theLeaderName[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theLeaderLv[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theCopyName[num],10)
                self.m_teamInfoBtn[num]    : addChild( self.theCopyTeamCount[num],10)
            end
        end
    end

    for k=tonumber(self.m_pageCount),1,-1 do
        self.m_pScrollView : addPage(pageContiner[k])
    end

    self.m_pScrollView : setPage(self.m_pageCount-1, true)--设置起始页[0,1,2,3...]
end



function CBuildTeamView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    return pageCount,lastPageCount
end

function CBuildTeamView.getTaskName( self,_id )

    local id = _id
    local _checkpoint  = _G.g_DuplicateDataProxy : getDuplicateNameByCopyId( id)
    return _checkpoint:getAttribute("copy_name"),_checkpoint:getAttribute("copy_type")
end

function CBuildTeamView.compareEnengyByCopyId( self,_id ) --返回1则有精力 0 则无
    local value = 0
    local id    = _id
    local _checkpoint  = _G.g_DuplicateDataProxy : getDuplicateNameByCopyId( id)
    local use_energy   = tonumber(_checkpoint:getAttribute("use_energy"))
    print("_checkpoint.copy_name 425",_checkpoint.copy_name)

    local mainProperty  = _G.g_characterProperty : getMainPlay()
    local m_nCurStr     =   mainProperty :getSum() or 0      --当前体力值

    if tonumber(m_nCurStr)  > use_energy then
        value = 1
    end

    return value
end

function CBuildTeamView.EnterPointsBtnNetWorkSend(self,_Sceneid) --进入副本协议发送
    require "common/protocol/auto/REQ_COPY_CREAT"
    local msg = REQ_COPY_CREAT()
    msg : setCopyId(_Sceneid)   -- {副本ID}
    CNetwork : send(msg)

    print("CBuildTeamView 进入副本协议发送 send,完毕 539",  _Sceneid )
end

function CBuildTeamView.TeamCreateBtnNetWorkSend(self,_Sceneid) --创建队伍协议发送
    require "common/protocol/auto/REQ_TEAM_CREAT"
    local msg = REQ_TEAM_CREAT()
    msg : setCopyId(_Sceneid)  --场景副本ID
    CNetwork : send(msg)
    print("TeamCreateBtnNetWorkSend REQ_TEAM_CREAT send,完毕 294",_Sceneid)
end

function CBuildTeamView.TeamPassReqNetWorkSend(self,_Type) --请求通过的副本的发送
    require "common/protocol/auto/REQ_TEAM_PASS_REQUEST"
    local msg = REQ_TEAM_PASS_REQUEST()
    msg : setType(_Type)  --副本类型  1普通 2 英雄 3魔王
    CNetwork : send(msg)
    print("TeamPassReqNetWorkSend REQ_TEAM_PASS_REQUEST send,完毕 294",_Type)
end


function CBuildTeamView.TeamJoinNetWorkSend(self,_TeamId) ----- [3600]加入队伍 -- 组队系统
    require "common/protocol/auto/REQ_TEAM_JOIN"
    local msg = REQ_TEAM_JOIN()
    msg : setTeamId(_TeamId)
    CNetwork : send(msg)
    print("TeamJoinNetWorkSend REQ_TEAM_JOIN send,完毕 294",_Type)
end


function CBuildTeamView.BackGroundCellCallBack(self, eventType, obj, touches)
    print("BackGroundCellCallBack eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        -- local touchesCount = touches:count()
        -- for i=1, touchesCount do
        --     local touch = touches :at( i - 1 )
        --     if obj:getTag() > 0 then
        --         local touchPoint = touch :getLocation()
        --         if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
        --             self.thetouchID = touch :getID()
        --             print( "XXXXXXXXSs"..self.thetouchID,obj:getTag(),obj)
        --             self.transfTag = obj:getTag()
        --             _G.pDateTime :reset()
        --             self.touchTime = _G.pDateTime:getTotalMilliseconds()
        --             break
        --         end
        --     end
        -- end
         print("800800800")
    elseif eventType == "TouchesEnded" then
        print("801801801")
    end
end

function CBuildTeamView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)
end
























