--[[
 --CGenerateTeamView
 --生成队伍主界面
 --1.队长创建队伍
 --2.队友加入队伍
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/GenerateTeamMediator"

CGenerateTeamView = class(view, function( self)
print("CGenerateTeamView:生成队伍")
end)
--Constant:
CGenerateTeamView.TAG_ADDFRINED       = 101  --加为好友
CGenerateTeamView.TAG_KICKEDOUT       = 102  --踢出队伍
CGenerateTeamView.TAG_APPOINTLEADER   = 103  --委任队长

CGenerateTeamView.TAG_CLOSED          = 201  --关闭界面
CGenerateTeamView.TAG_LEAVETEAM       = 202  --离开队伍

CGenerateTeamView.TAG_ENTERDUPLICATE   = 203  --进入副本(队长)
CGenerateTeamView.TAG_INVITETEAMMATES1 = 204  --邀请队友(队长)
CGenerateTeamView.TAG_INVITETEAMMATES2 = 205  --邀请队友(队长)
CGenerateTeamView.TAG_INVITETEAMMATES3 = 206  --邀请队友(队长)
CGenerateTeamView.TAG_APPOINTCAPTAIN   = 207  --委任队长(队长) appoint a captain

CGenerateTeamView.TAG_APPLYCAPTAIN    = 208  --申请队长(队友)
CGenerateTeamView.TAG_LEAVE           = 209  --离开   (队友)

CGenerateTeamView.TAG_DUPLICATECELL   = 300  --副本ID --人物排位顺序

--加载资源
function CGenerateTeamView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TeamViewResources/TeamViewResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
end

--释放资源
function CGenerateTeamView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TeamViewResources/TeamViewResources.plist")
    CCTextureCache :sharedTextureCache()        :removeTextureForKey("TeamViewResources/TeamViewResources.plist")

    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

--初始化数据成员
function CGenerateTeamView.initParams( self, layer)
    print("CGenerateTeamView.initParams")

    --mediator注册
    _G.g_CGenerateTeamMediator = CGenerateTeamMediator (self)
    controller :registerMediator(  _G.g_CGenerateTeamMediator )

    local id       = self.sceneId
    local CopyNode = self : getTaskNode(id)
    self.m_selectLevelButton : setText(CopyNode:getAttribute("copy_name"))

    self.TipBoxContiner = nil
    self.PlayerBodyList = {} --身体图片列表存储
end

--释放成员
function CGenerateTeamView.realeaseParams( self)

end

--布局成员
function CGenerateTeamView.layout( self, winSize)
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640

    if winSize.height == 640 then
        print("640--组队_创建队伍界面")
        self.m_allBackGroundSprite         : setPosition(winSize.width/2,winSize.height/2)              --总底图

        local generateteambackgroundfirst  = self.m_generateTeamViewContainer :getChildByTag( 100)
        --local teammatesbackground          = self.m_generateTeamViewContainer :getChildByTag( 101)

        local closedButtonSize      = self.m_closedButton :getContentSize()
        local tempButtonSize        = self.m_leaveTeamButton :getContentSize()

        generateteambackgroundfirst : setPreferredSize(CCSizeMake(854,640))
        self.m_generateTeamViewContainer : setPosition(winSize.width/2-IpadSizeWidth/2,0)
        --teammatesbackground         : setPreferredSize( CCSizeMake( winSize.width*0.96, winSize.height*0.86))
        self.m_selectLevelButton    : setPreferredSize( CCSizeMake( 300, 45))

        generateteambackgroundfirst : setPosition(IpadSizeWidth/2,IpadSizeheight/2)
        --teammatesbackground         : setPosition( ccp( winSize.width/2, winSize.height*0.45))

        self.m_leaveTeamButton    : setPosition( ccp( 635, 45))
        self.m_selectLevelButton  : setPosition( ccp( 480, 640-tempButtonSize.height/2-10))
        self.m_closedButton       : setPosition( ccp( IpadSizeWidth-closedButtonSize.width/2, IpadSizeheight-closedButtonSize.height/2))

    --768
    elseif winSize.height == 768 then
        CCLOG("768--组队_创建队伍")
        self.m_allBackGroundSprite         : setPosition(winSize.width/2,winSize.height/2)              --总底图

        local generateteambackgroundfirst  = self.m_generateTeamViewContainer :getChildByTag( 100)
        --local teammatesbackground          = self.m_generateTeamViewContainer :getChildByTag( 101)

        local closedButtonSize      = self.m_closedButton :getContentSize()
        local tempButtonSize        = self.m_leaveTeamButton :getContentSize()

        generateteambackgroundfirst : setPreferredSize(CCSizeMake(854,640))
        self.m_generateTeamViewContainer : setPosition(winSize.width/2-IpadSizeWidth/2,0)
        --teammatesbackground         : setPreferredSize( CCSizeMake( winSize.width*0.96, winSize.height*0.86))
        self.m_selectLevelButton    : setPreferredSize( CCSizeMake( 300, 45))

        generateteambackgroundfirst : setPosition(IpadSizeWidth/2,IpadSizeheight/2)
        --teammatesbackground         : setPosition( ccp( winSize.width/2, winSize.height*0.45))

        self.m_leaveTeamButton    : setPosition( ccp( 635, 45))
        self.m_selectLevelButton  : setPosition( ccp( 480, 640-tempButtonSize.height/2-10))
        self.m_closedButton       : setPosition( ccp( IpadSizeWidth-closedButtonSize.width/2, IpadSizeheight-closedButtonSize.height/2))
    end
end

--主界面初始化
function CGenerateTeamView.init(self, winSize, layer)
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

function CGenerateTeamView.scene(self, is_captain,_sceneId)
    print("create scene")
    self.sceneId       = _sceneId --传递过来的id
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()

    self.m_scenelayer : setControlName( "this is CGenerateTeamView self.m_scenelayer 119" )

    self.IS_CAPTAIN = is_captain or 1
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CGenerateTeamView.layer( self, is_captain)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CGenerateTeamView self.m_scenelayer 132" )
    self.IS_CAPTAIN = is_captain or 1
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CGenerateTeamView.initView(self, layer,winSize)
    print("CGenerateTeamView.initHangupView")
    local IpadWidthSize =854
    --底图
    self.m_allBackGroundSprite   = CSprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(winSize.width,winSize.height))
    layer :addChild(self.m_allBackGroundSprite,-2)

    --队友与队长共有UI
    --副本界面容器
    self.m_generateTeamViewContainer = CContainer :create()
    self.m_generateTeamViewContainer : setControlName( "this is CGenerateTeamView self.m_generateTeamViewContainer 144" )
    layer :addChild( self.m_generateTeamViewContainer)

    local function CellCallBack( eventType, obj, x, y)
       return self :clickCellCallBack( eventType, obj, x, y)
    end
    local generateteambackgroundfirst  = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    --local teammatesbackground          = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    generateteambackgroundfirst : setControlName( "this CGenerateTeamView generateteambackgroundfirst 153 ")
    --teammatesbackground : setControlName( "this CGenerateTeamView teammatesbackground 154 ")
    self.m_selectLevelButton           = CButton :createWithSpriteFrameName( "我是大魔王", "general_second_underframe.png")
    self.m_leaveTeamButton             = CButton :createWithSpriteFrameName( "离开队伍", "general_button_normal.png")
    self.m_closedButton                = CButton :createWithSpriteFrameName( "", "general_close_normal.png")

    self.m_selectLevelButton : setControlName( "this CGenerateTeamView self.m_selectLevelButton 158 " )
    self.m_leaveTeamButton   : setControlName( "this CGenerateTeamView self.m_leaveTeamButton 159 " )
    self.m_closedButton      : setControlName( "this CGenerateTeamView self.m_closedButton 160 " )

    self.m_selectLevelButton : setFontSize( 25)
    self.m_leaveTeamButton   : setFontSize( 25)

    self.m_leaveTeamButton : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_leaveTeamButton 167")
    self.m_closedButton    : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_closedButton 168")

    self.m_generateTeamViewContainer :addChild( generateteambackgroundfirst, -1, 100)
    --self.m_generateTeamViewContainer :addChild( teammatesbackground, -1, 101)
    self.m_generateTeamViewContainer :addChild( self.m_leaveTeamButton, 1, CGenerateTeamView.TAG_LEAVETEAM)
    self.m_generateTeamViewContainer :addChild( self.m_selectLevelButton)
    self.m_generateTeamViewContainer :addChild( self.m_closedButton, 2,CGenerateTeamView.TAG_CLOSED)

    local function teammatesBtnCallBack(eventType, obj, touches)
        return self:teammatesBtnCallBack(eventType, obj, touches)
    end
    --teammates
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_teammatesLayout     = CHorizontalLayout :create()
    local cellButtonSize = CCSizeMake( 270, 450)
    self.m_teammatesLayout :setPosition( 25,320)
    self.m_teammatesLayout :setVerticalDirection(false)
    self.m_teammatesLayout :setCellHorizontalSpace( 40)
    self.m_teammatesLayout :setLineNodeSum(3)
    self.m_teammatesLayout :setCellSize( CCSizeMake(240,450))

    self.m_generateTeamViewContainer :addChild( self.m_teammatesLayout)

    self.m_teammatesBtn            = {}
    self.teammatesimage            = {}
    self.teammatesNameSprite       = {}
    self.teammatesFrightSprite     = {}
    self.teammatesFrightSpr        = {}
    self.teammatesname             = {}
    self.teammatesdesignation      = {}
    self.teammatesfightingcapacity = {}
    self.teammateslv               = {}
    for i=1,3 do
        self.m_teammatesBtn[i] = {}
        self.m_teammatesBtn[i]       = CButton :createWithSpriteFrameName( "","general_second_underframe.png")
        self.m_teammatesBtn[i]       : setTouchesMode( kCCTouchesAllAtOnce )
        self.m_teammatesBtn[i]       : setControlName( "this CGenerateTeamView self.m_teammatesBtn[i] 191 "..tostring(i) )

        self.teammatesname[i]             = CCLabelTTF : create("", "Arial", 25)
        self.teammatesdesignation[i]      = CCLabelTTF : create("", "Arial", 25)
        self.teammatesfightingcapacity[i] = CCLabelTTF : create("", "Arial", 25)
        self.teammateslv[i]               = CCLabelTTF : create("", "Arial", 25)

        self.m_teammatesBtn[i]            : setPreferredSize( cellButtonSize)
        self.teammatesname[i]             : setColor(ccc3(255,255,0))
        self.teammateslv[i]               : setColor(ccc3(255,255,0))

        self.teammatesname[i]             : setPosition( ccp( -50, cellButtonSize.height*0.45))
        self.teammatesdesignation[i]      : setPosition( ccp( 0, cellButtonSize.height*0.35))
        self.teammatesfightingcapacity[i] : setPosition( ccp( 40, -cellButtonSize.height*0.44))
        self.teammateslv[i]               : setPosition( ccp( 60,cellButtonSize.height*0.45))

        self.m_teammatesBtn[i] : addChild( self.teammatesname[i], 3 )
        self.m_teammatesBtn[i] : addChild( self.teammatesdesignation[i], 3)
        self.m_teammatesBtn[i] : addChild( self.teammatesfightingcapacity[i], 3)
        self.m_teammatesBtn[i] : addChild( self.teammateslv[i], 3)

        self.m_teammatesBtn[i] : registerControlScriptHandler( teammatesBtnCallBack, "this CGenerateTeamView self.m_teammatesBtn[i] 219")
        self.m_teammatesLayout : addChild(self.m_teammatesBtn[i],1,CGenerateTeamView.TAG_DUPLICATECELL+i*10)
    end
end

function CGenerateTeamView.showCheckPointView( self, _checkpoints)
end

--更新本地list数据
function CGenerateTeamView.setLocalList( self)
    print("CGenerateTeamView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CGenerateTeamView.clickCellCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then

        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        local temptag = math.mod( math.mod( obj :getTag(), CGenerateTeamView.TAG_DUPLICATECELL), 10)
        if obj :getTag() == CGenerateTeamView.TAG_CLOSED then
            --关闭
            print("关闭")
            if self ~= nil then
                --self.m_scenelayer :removeAllChildrenWithCleanup(true)
                --controller :unregisterMediator( self.mediator)
                if _G.g_CGenerateTeamMediator ~= nil then
                    controller :unregisterMediator(_G.g_CGenerateTeamMediator)
                    _G.g_CGenerateTeamMediator = nil
                end
                self : LeaveTeamBtnNetWorkSend() --离开队伍协议发送
                CCDirector :sharedDirector() :popScene( self._scene)
                _G.g_unLoadIconSources: unLoadAllIconsByNameList(self.PlayerBodyList)
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CGenerateTeamView.TAG_LEAVETEAM then
            print(" 离开队伍")
            self : LeaveTeamBtnNetWorkSend() --离开队伍协议发送
            if _G.g_CGenerateTeamMediator ~= nil then
                controller :unregisterMediator(_G.g_CGenerateTeamMediator)
                _G.g_CGenerateTeamMediator = nil
            end
            CCDirector :sharedDirector() :popScene( self._scene)
            self : unloadResource()
            _G.g_unLoadIconSources: unLoadAllIconsByNameList(self.PlayerBodyList)
        --------------------------------------------------------------
        elseif obj :getTag() == CGenerateTeamView.TAG_ENTERDUPLICATE then
            print(" 进入副本",self.sceneId)
            if self.sceneId ~= nil and self.sceneId > 0 then
                self : EnterDuplicateBtnNetWorkSend(self.sceneId) --协议发送
            end
        elseif obj :getTag() == CGenerateTeamView.TAG_APPOINTCAPTAIN then
            print(" 发布招募")
            -- local msg = "找后端找后端"
            -- self : createMessageBox(msg)
            --obj : setTouchesEnabled( false )
            --obj :setVisible( false)
            --self : PostedRecruitedSend()

            local actarr = CCArray:create()
            local function t_callback1()
                self.m_appointCaptainButton:setTouchesEnabled(false)
                self : PostedRecruitedSend()
            end
            local function t_callback2()
                self.m_appointCaptainButton:setTouchesEnabled(true)
            end
            actarr:addObject( CCCallFunc:create(t_callback1) )
            local delayTime = _G.Constant.CONST_TEAM_RECRUIT_TIME --发布招募间隔时间（秒）
            actarr:addObject( CCDelayTime:create(delayTime) )
            actarr:addObject( CCCallFunc:create(t_callback2) )
            obj:runAction( CCSequence:create(actarr) )



        elseif obj :getTag() == CGenerateTeamView.TAG_APPLYCAPTAIN then
            print(" 申请队长")
            self : ApplyLeaderBtnNetWorkSend ()
        elseif obj :getTag() == CGenerateTeamView.TAG_LEAVE then
            print(" 离开(队友部分)")
        elseif obj :getTag() == CGenerateTeamView.TAG_INVITETEAMMATES1 then
            print(" 1邀请队友")
            if self.TipBoxContiner ~=nil then
                self.TipBoxContiner : removeFromParentAndCleanup(true)
                self.TipBoxContiner = nil
            end
            require "view/DuplicateLayer/InviteTeammatesView"
            local pInviteTeammatesView = CInviteTeammatesView()
            local InvitePopBox         = pInviteTeammatesView : layer()
            InvitePopBox               : setPosition(0,0)
            self.m_scenelayer          : addChild(InvitePopBox)

            self : requestFriendNetWorkSend(1) --请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）
        elseif obj :getTag() == CGenerateTeamView.TAG_INVITETEAMMATES2 then
            print(" 2邀请队友")
            if self.TipBoxContiner ~=nil then
                self.TipBoxContiner : removeFromParentAndCleanup(true)
                self.TipBoxContiner = nil
            end
            require "view/DuplicateLayer/InviteTeammatesView"
            local pInviteTeammatesView = CInviteTeammatesView()
            local InvitePopBox         = pInviteTeammatesView : layer()
            InvitePopBox               : setPosition(0,0)
            self.m_scenelayer          : addChild(InvitePopBox)

            self : requestFriendNetWorkSend(1) --请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）
        elseif obj :getTag() == CGenerateTeamView.TAG_INVITETEAMMATES3 then
            print(" 3邀请队友")
            if self.TipBoxContiner ~=nil then
                self.TipBoxContiner : removeFromParentAndCleanup(true)
                self.TipBoxContiner = nil
            end
            require "view/DuplicateLayer/InviteTeammatesView"
            local pInviteTeammatesView = CInviteTeammatesView()
            local InvitePopBox         = pInviteTeammatesView : layer()
            InvitePopBox               : setPosition(0,0)
            self.m_scenelayer          : addChild(InvitePopBox)

            self : requestFriendNetWorkSend(1) --请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）
        end
        --------------------------------------------------------------
        print("3个人物id====",self.palyer1Id,self.palyer2Id,self.palyer3Id)

        self.thePlayerId = 0
        if self.transfTipBoxId == 1 and tonumber(self.palyer1Id)> 0 and self.InviteTipsBox1 == 1 then
            self.thePlayerId = tonumber(self.palyer1Id)
        elseif self.transfTipBoxId == 2 and tonumber(self.palyer2Id) > 0 and self.InviteTipsBox2 == 1  then
            self.thePlayerId = tonumber(self.palyer2Id)
        elseif self.transfTipBoxId == 3 and tonumber(self.palyer3Id) > 0 and self.InviteTipsBox3 == 1  then
            self.thePlayerId = tonumber(self.palyer3Id)
        end

        print ("--->",self.thePlayerId,CGenerateTeamView.TAG_ADDFRINED,CGenerateTeamView.TAG_KICKEDOUT,CGenerateTeamView.TAG_APPOINTLEADER)

        if obj :getTag() == CGenerateTeamView.TAG_ADDFRINED and self.thePlayerId > 0 then
            print(" 加为好友 ")
            self : AddFriendBtnNetWorkSend(self.thePlayerId)
        elseif obj :getTag() == CGenerateTeamView.TAG_KICKEDOUT and self.thePlayerId > 0 then
            print(" 踢出队伍 ")
            self : KickedOutBtnNetWorkSend(self.thePlayerId)
        elseif obj :getTag() == CGenerateTeamView.TAG_APPOINTLEADER and self.thePlayerId > 0 then
            print(" 委任队长")
            self : AppointLeaderBtnNetWorkSend(self.thePlayerId)
        end
    end
end

function CGenerateTeamView.PostedRecruitedSend(self)
   -- require "model/VO_ChatDataModel"
   -- require "controller/ChatCommand"
    require "view/Chat/ChatView"
    print("准备发送发布招募命令")
    --格式化数据
    -- _G.pDateTime  : reset()
    -- local nowTime = _G.pDateTime : getTotalMilliseconds()

    local CopyNode = self : getTaskNode(self.sceneId)
    local CopyName = nil
    local CopyType = nil
    if CopyNode ~= nil then
        CopyName = CopyNode:getAttribute("copy_name")
        local Type = tonumber(CopyNode:getAttribute("copy_type"))
        if Type == _G.Constant.CONST_COPY_TYPE_NORMAL then
            CopyType = "普通"
        elseif Type == _G.Constant.CONST_COPY_TYPE_HERO then
            CopyType = "英雄"
        elseif Type == _G.Constant.CONST_COPY_TYPE_FIEND then
            CopyType = "魔王"
        end
    end

    local msg  = "创建了["..CopyName.."]副本,正在火热招募中,赶紧加入吧! "

    -- local vo_data = VO_ChatDataModel(nowTime)
    -- local _msgCommand = CChatReceivedCommand(vo_data)
    -- controller:sendCommand(_msgCommand)
    if self.TransTeamId ~= nil then
        local TeamId = self.TransTeamId
        local CopyId = self.sceneId
        print("11self.TransTeamId==",TeamId,CopyId)
        CChatView() : TeamPostedRecruited(msg,TeamId,CopyId)
    end
    print("发送发布招募命令完毕。。。。")

    --self : isTeamIconDelete() --倒计时
end
--到计时
function CGenerateTeamView.isTeamIconDelete(self)
    local time =5-- _G.Constant.CONST_TEAM_RECRUIT_TIME
    self : setReceiveAwardsTime(time)
    self : registerEnterFrameCallBack()
end

function CGenerateTeamView.setReceiveAwardsTime(self, _time)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
end

function CGenerateTeamView.registerEnterFrameCallBack(self)
    print( "CMyGameLayer.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        self :updataReceiveAwardsTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CGenerateTeamView.updataReceiveAwardsTime( self, _duration)
    if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
        return
    end
    self.m_receiveawardstime = self.m_receiveawardstime - _duration
    if self.m_receiveawardstime <= 0 then
        print("倒数完了")
        if self.m_appointCaptainButton ~= nil then
            self.m_appointCaptainButton :setTouchesEnabled( true )
           --self.m_appointCaptainButton :setVisible( true)
        end
    else
        local fomarttime = self.m_receiveawardstime
        print("将在"..fomarttime.."秒后停止")
    end
end

--多点触控
function CGenerateTeamView.teammatesBtnCallBack(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)

    if eventType == "TouchesBegan" then
        if self.TipBoxContiner ~=nil then
            self.TipBoxContiner : removeFromParentAndCleanup(true)
            self.TipBoxContiner = nil
        end

        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 300 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.transfBtnId = obj:getTag()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)

                    if self.TipBoxContiner ~=nil then
                        self.TipBoxContiner : removeFromParentAndCleanup(true)
                        self.TipBoxContiner = nil
                    end

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
                    local x = touch2Point.x
                    local y = touch2Point.y
                    self.transfTipBoxId = 0
                    if self.IS_CAPTAIN == 1 then
                        print("队长弹出框框11111111",self.transfBtnId,self.isInvite1,self.InviteTipsBox1)
                        if self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+10 and  self.isInvite1 == 0 and self.InviteTipsBox1 == 1 then
                            print("队长第二个人人物弹出框")
                            self : CreateLeaderTipBox(x,y)
                            self.transfTipBoxId = 1
                        elseif self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+20 and  self.isInvite2 == 0 and self.InviteTipsBox2 == 1 then
                            print("队长第二个人人物弹出框")
                            self : CreateLeaderTipBox(x,y)
                            self.transfTipBoxId = 2
                        elseif self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+30 and  self.isInvite3 == 0 and  self.InviteTipsBox3 == 1 then
                            print("队长第三个人人物弹出框")
                            self : CreateLeaderTipBox(x,y)
                            self.transfTipBoxId = 3
                        end
                    elseif self.IS_CAPTAIN == 0 then
                        print("队员弹出框框22222222",self.transfBtnId,self.isInvite1,self.InviteTipsBox1)
                        if self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+10  and  self.isInvite1 == 0  and  self.InviteTipsBox1 == 1 then
                            print("队员第一个人人物弹出框")
                            self : CreateTeamerTipBox(x,y)
                            self.transfTipBoxId = 1
                        elseif self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+20 and  self.isInvite2 == 0 and  self.InviteTipsBox2 == 1 then
                            print("队员第二个人人物弹出框")
                            self : CreateTeamerTipBox(x,y)
                            self.transfTipBoxId = 2
                        elseif self.transfBtnId == CGenerateTeamView.TAG_DUPLICATECELL+30 and  self.isInvite3 == 0 and  self.InviteTipsBox3 == 1 then
                            print("队员第二个人人物弹出框")
                            self : CreateTeamerTipBox(x,y)
                            self.transfTipBoxId = 3
                        end
                    end
                end
            end
        end
        self.touchID = nil
    end
end

function CGenerateTeamView.getTaskNode( self,_id ) --获取副本名字
    local id = _id
    local _checkpoint  = _G.g_DuplicateDataProxy : getDuplicateNameByCopyId( id)
    print("_checkpoint.copy_name 425",_checkpoint.copy_name)
    return _checkpoint
end

function CGenerateTeamView.pushData(self,_team_id,_leader_uid,_copy_id,_TeamListData)
    print("CGenerateTeamView.pushData 刷一刷",_copy_id,_TeamListData,_team_id)
    local winSize        = CCDirector :sharedDirector() :getVisibleSize()
    local leader_uid     = _leader_uid    --队长ID
    local copy_id        = _copy_id       --队伍数量
    local TeamListData   = _TeamListData  --队伍数据
    self.TransTeamId     = _team_id       --队伍id

    self.isInvite1 = 1  --判断是否有邀请按钮 1假设   有
    self.isInvite2 = 1  --判断是否有邀请按钮 1假设   有
    self.isInvite3 = 1  --判断是否有邀请按钮 1假设   有
    self.palyer1Id = 0  --队员ID初始化
    self.palyer2Id = 0  --队员ID初始化
    self.palyer3Id = 0  --队员ID初始化
    self.InviteTipsBox1 = 0 --邀请框 0假设没有
    self.InviteTipsBox2 = 0 --邀请框 0假设没有
    self.InviteTipsBox3 = 0 --邀请框 0假设没有


    self : cleanViewData() --数据清楚

    local ischangeCaptain = self : isInviteTipsBoxCreate(leader_uid) --判断是否需要更改队长弹出框
    if ischangeCaptain == 0 then
        self.IS_CAPTAIN = 1
    elseif ischangeCaptain == 1 then
        self.IS_CAPTAIN = 0
    end
    print("ischangeCaptain",ischangeCaptain)

    for k,v in pairs(TeamListData) do
        -- if leader_uid == v.uid then
        if v.uid ~= nil  then
            local no = tonumber(v.pos)
            print("循环--》", v.pos,v.name)
            self.teammatesname[no]             : setString(v.name)           --名字
            if tonumber(v.clan_name) ~= -1 then
                self.teammatesdesignation[no]  : setString(v.clan_name)      --社团名字
            else
                self.teammatesdesignation[no]  : setString("无社团")          --社团名字
            end
            self.teammatesfightingcapacity[no] : setString(v.power)          --战斗力
            self.teammateslv[no]               : setString("LV "..v.lv)      --等级

            self : CreateTeammatesimage(no,winSize,v.pro) --创建人物图像

            if no == 1 then
                self.isInvite1 = 0
                -- if ischangeCaptain == 1 then
                --     self.isInvite1 = 1
                -- end
                self.palyer1Id = v.uid --队员ID
                if  self.m_inviteTeammatesButton1 ~= nil then
                    self.m_inviteTeammatesButton1 : setVisible( false )
                end
                self.InviteTipsBox1 = self : isInviteTipsBoxCreate(v.uid)
                print("no == 1",self.isInvite1,self.palyer1Id)
            elseif no == 2 then
                self.isInvite2 = 0
                -- if ischangeCaptain == 1 then
                --     self.isInvite2 = 1
                -- end
                self.palyer2Id = v.uid --队员ID
                if  self.m_inviteTeammatesButton2 ~= nil then
                    self.m_inviteTeammatesButton2 : setVisible( false )
                end
                self.InviteTipsBox2 = self : isInviteTipsBoxCreate(v.uid)
                print("no == 2",self.isInvite2,self.palyer2Id)
            elseif no == 3 then
                self.isInvite3   = 0
                -- if ischangeCaptain == 1 then
                --     self.isInvite3 = 1
                --     print("不是对长 需要隐藏")
                -- end
                self.palyer3Id   = v.uid --队员ID
                if self.m_inviteTeammatesButton3 ~= nil then
                    self.m_inviteTeammatesButton3 : setVisible( false )
                end
                self.InviteTipsBox3 = self : isInviteTipsBoxCreate(v.uid)
                print("no == 3",self.isInvite3,self.palyer3Id)
            end
        end

        if leader_uid == v.uid then
            local no = tonumber(v.pos)
            self.isleaderImage      =  CSprite :createWithSpriteFrameName ( "team_captain.png" )
            self.isleaderImage      : setPosition(-90,100)
            self.m_teammatesBtn[no] : addChild( self.isleaderImage, 10)

        end
    end

    self : CreatePartInitView(winSize) --创建邀请按钮
end

-- self : isInviteTipsBoxCreate(v.uid)
function CGenerateTeamView.cleanViewData(self)
    for i=1,3 do
        if self.teammatesimage[i] ~= nil then
            self.teammatesimage[i] : removeFromParentAndCleanup(true)
            self.teammatesimage[i] = nil
            print("a1")
        end
        if  self.teammatesNameSprite[i] ~= nil then
            self.teammatesNameSprite[i] : removeFromParentAndCleanup(true)
            self.teammatesNameSprite[i] = nil
            print("a2")
        end
        if self.teammatesFrightSprite[i] ~= nil then
            self.teammatesFrightSprite[i] : removeFromParentAndCleanup(true)
            self.teammatesFrightSprite[i] = nil
            print("a3")
        end
        if self.teammatesFrightSpr[i] ~= nil then
            self.teammatesFrightSpr[i] : removeFromParentAndCleanup(true)
            self.teammatesFrightSpr[i] = nil
            print("a4")
        end
        self.teammatesname[i]             : setString("")
        self.teammatesdesignation[i]      : setString("")
        self.teammatesfightingcapacity[i] : setString("")
        self.teammateslv[i]               : setString("")
    end

    if self.isleaderImage ~= nil then
        self.isleaderImage : removeFromParentAndCleanup(true)
        self.isleaderImage = nil
        print("a5")
    end
    print("7777")
    if self.TipBoxContiner ~=nil then
        self.TipBoxContiner : removeFromParentAndCleanup(true)
        self.TipBoxContiner = nil
        print("a6")
    end

    -- if self.m_inviteTeammatesButton2 ~= nil then
    --     self.m_inviteTeammatesButton2 : setVisible( true )
    -- end
    -- if self.m_inviteTeammatesButton3 ~= nil then
    --     self.m_inviteTeammatesButton3 : setVisible( true )
    -- end

    if self.m_enterDuplicateButton ~= nil then
        self.m_enterDuplicateButton : removeFromParentAndCleanup(true)
        self.m_enterDuplicateButton = nil
        print("a7")
    end
    print("8888")
    if self.m_appointCaptainButton ~= nil then
        self.m_appointCaptainButton : removeFromParentAndCleanup(true)
        self.m_appointCaptainButton = nil
        print("a8")
    end
    print("9999")

    -- if self.m_inviteTeammatesButton2 ~= nil then
    --     print("m_inviteTeammatesButton2 remove ")
    --     self.m_inviteTeammatesButton2 : removeFromParentAndCleanup(true)
    -- end

    -- if self.m_inviteTeammatesButton3 ~= nil then
    --     print("m_inviteTeammatesButton3 remove ")
    --     self.m_inviteTeammatesButton3 : removeFromParentAndCleanup(true)
    -- end

end

function CGenerateTeamView.isInviteTipsBoxCreate( self,_id ) --判断那个队员有跟主角相同的id
    local value    = 1 --表示可以有
    local mainplay = _G.g_characterProperty :getMainPlay()
    local myuid    = mainplay :getUid()      --玩家Uid
    if myuid == _id then
        value = 0   --表示木有
    end

    return value
end

function CGenerateTeamView.CreatePartInitView(self,winSize)
    --队友和队长分别独有部分UI
    local function CellCallBack( eventType, obj, x, y)
       return self :clickCellCallBack( eventType, obj, x, y)
    end
    if self.IS_CAPTAIN == 1 then --队长部分
        print("队长队长")
        --add:
        self.m_enterDuplicateButton  = CButton :createWithSpriteFrameName( "进入副本", "general_button_normal.png")  --TAG_ENTERDUPLICATE
        self.m_appointCaptainButton  = CButton :createWithSpriteFrameName( "发布招募", "general_button_normal.png", "发布招募", "general_button_normal.png")  --TAG_APPOINTCAPTAIN
        self.m_appointCaptainLabel   = CCLabelTTF :create("发布招募间隔时间为".._G.Constant.CONST_TEAM_RECRUIT_TIME.."(秒)","Arial",18)

        self.m_enterDuplicateButton  : setControlName( "this CGenerateTeamView self.m_enterDuplicateButton 228 " )
        self.m_appointCaptainButton  : setControlName( "this CGenerateTeamView self.m_appointCaptainButton 230 " )

        self.m_enterDuplicateButton : setPosition( ccp( 770, 45))    --进入副本按钮
        self.m_appointCaptainButton : setPosition( ccp( 500-375,45)) --发布招募按钮
        self.m_appointCaptainLabel  : setPosition( ccp( 180,0))      --发布招募Label

        self.m_enterDuplicateButton  : setFontSize( 25)
        self.m_appointCaptainButton  : setFontSize( 25)

        self.m_appointCaptainButton : setVisible(true)
        self.m_enterDuplicateButton : setVisible(true)

        self.m_enterDuplicateButton  : setTag( CGenerateTeamView.TAG_ENTERDUPLICATE)
        self.m_appointCaptainButton  : setTag( CGenerateTeamView.TAG_APPOINTCAPTAIN)

        self.m_enterDuplicateButton  : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_enterDuplicateButton 243")
        self.m_appointCaptainButton  : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_appointCaptainButton 245")

        self.m_generateTeamViewContainer : addChild( self.m_enterDuplicateButton)
        self.m_generateTeamViewContainer : addChild( self.m_appointCaptainButton)
        self.m_appointCaptainButton      : addChild( self.m_appointCaptainLabel)
        -- --add:
        -- self.m_enterDuplicateButton   = CButton :createWithSpriteFrameName( "进入副本", "general_four_button_normal.png")  --TAG_ENTERDUPLICATE
        -- self.m_enterDuplicateButton   : setControlName( "this CGenerateTeamView self.m_enterDuplicateButton 228 " )
        -- self.m_enterDuplicateButton   : setFontSize( 30)
        -- self.m_enterDuplicateButton   : setTag( CGenerateTeamView.TAG_ENTERDUPLICATE)
        -- self.m_enterDuplicateButton   : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_enterDuplicateButton 243")
        -- self.m_generateTeamViewContainer : addChild( self.m_enterDuplicateButton)
        if self.isInvite1 == 1 then
            if self.m_inviteTeammatesButton1 == nil then
                self.m_inviteTeammatesButton1 = CButton :createWithSpriteFrameName( "邀请", "general_button_normal.png")     --TAG_INVITETEAMMATES
                self.m_inviteTeammatesButton1 : setPosition( ccp( 120, 320)) --邀请按钮
                self.m_inviteTeammatesButton1 : setControlName( "this CGenerateTeamView self.m_inviteTeammatesButton 229 " )
                self.m_inviteTeammatesButton1 : setFontSize( 24)
                self.m_inviteTeammatesButton1 : setTag( CGenerateTeamView.TAG_INVITETEAMMATES1)
                self.m_inviteTeammatesButton1 : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_inviteTeammatesButton 244")
                self.m_generateTeamViewContainer : addChild( self.m_inviteTeammatesButton1)
            else
                self.m_inviteTeammatesButton1 : setVisible( true )
            end
        elseif self.isInvite1 == 0 then
            print("692")
        end
        if self.isInvite2 == 1 then
            if self.m_inviteTeammatesButton2 == nil then
                self.m_inviteTeammatesButton2 = CButton :createWithSpriteFrameName( "邀请", "general_button_normal.png")     --TAG_INVITETEAMMATES
                self.m_inviteTeammatesButton2 : setPosition( ccp( 420, 320)) --邀请按钮
                self.m_inviteTeammatesButton2 : setControlName( "this CGenerateTeamView self.m_inviteTeammatesButton 229 " )
                self.m_inviteTeammatesButton2 : setFontSize( 24)
                self.m_inviteTeammatesButton2 : setTag( CGenerateTeamView.TAG_INVITETEAMMATES2)
                self.m_inviteTeammatesButton2 : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_inviteTeammatesButton 244")
                self.m_generateTeamViewContainer : addChild( self.m_inviteTeammatesButton2)
            else
                self.m_inviteTeammatesButton2 : setVisible( true )
            end
        elseif self.isInvite2 == 0 then
            print("692")
        end
        if self.isInvite3 == 1 then
            if self.m_inviteTeammatesButton3 == nil then
                self.m_inviteTeammatesButton3 = CButton :createWithSpriteFrameName( "邀请", "general_button_normal.png")     --TAG_INVITETEAMMATES
                self.m_inviteTeammatesButton3 : setPosition( ccp( 720, 320)) --邀请按钮
                self.m_inviteTeammatesButton3 : setControlName( "this CGenerateTeamView self.m_inviteTeammatesButton 229 " )
                self.m_inviteTeammatesButton3 : setFontSize( 24)
                self.m_inviteTeammatesButton3 : setTag( CGenerateTeamView.TAG_INVITETEAMMATES3)
                self.m_inviteTeammatesButton3 : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_inviteTeammatesButton 244")
                --self.m_appointCaptainButton   = CButton :createWithSpriteFrameName( "发布招募", "general_four_button_normal.png")  --TAG_APPOINTCAPTAIN
                self.m_generateTeamViewContainer : addChild( self.m_inviteTeammatesButton3)
            else
                self.m_inviteTeammatesButton3 : setVisible( true )
            end
        elseif self.isInvite3 == 0 then
            print("707")
        end
        print("队长队长队长队长",self.m_inviteTeammatesButton3,self.m_inviteTeammatesButton2)
        -- self.m_appointCaptainButton   : setControlName( "this CGenerateTeamView self.m_appointCaptainButton 230 " )
        -- self.m_appointCaptainButton   : setFontSize( 30)
        -- self.m_appointCaptainButton   : setTag( CGenerateTeamView.TAG_APPOINTCAPTAIN)
        -- self.m_appointCaptainButton   : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_appointCaptainButton 245")
        -- self.m_generateTeamViewContainer : addChild( self.m_appointCaptainButton)
    elseif self.IS_CAPTAIN == 0 then --队友部分
        print("队员队员",self.m_inviteTeammatesButton3,self.m_inviteTeammatesButton2)
        if self.m_inviteTeammatesButton3 ~= nil then
            print("assssd3")
            self.m_inviteTeammatesButton3 : setVisible( false )
            print("asss2255555---sd3")
        end
        if self.m_inviteTeammatesButton2 ~= nil then
            print("assssd2")
            self.m_inviteTeammatesButton2 : setVisible( false )
            print("asss2255555---sd2")
        end
        if self.m_inviteTeammatesButton1 ~= nil then
            print("assssd2")
            self.m_inviteTeammatesButton1 : setVisible( false )
            print("asss2255555---sd2")
        end
        -- if self.m_inviteTeammatesButton2 ~= nil then
        --     print("m_inviteTeammatesButton2 remove ")
        --     self.m_inviteTeammatesButton2 : removeFromParentAndCleanup(true)
        -- end
        -- if self.m_inviteTeammatesButton3 ~= nil then
        --     print("m_inviteTeammatesButton3 remove ")
        --     self.m_inviteTeammatesButton3 : removeFromParentAndCleanup(true)
        -- end

        -- if self.m_enterDuplicateButton ~= nil then

        --     self.m_enterDuplicateButton : setVisible(false)
        --     print ()
        -- end
        -- if self.m_appointCaptainButton ~= nil then
        --     self.m_appointCaptainButton : setVisible(false)
        -- end
        -- --add
        -- self.m_applyCaptainButton    = CButton :createWithSpriteFrameName( "申请队长", "general_four_button_normal.png")  --TAG_APPLYCAPTAIN
        -- self.m_leaveButton           = CButton :createWithSpriteFrameName( "离开", "general_four_button_normal.png")     --TAG_LEAVE
        -- self.m_applyCaptainButton    : setControlName( "this CGenerateTeamView self.m_applyCaptainButton 251 " )
        -- self.m_leaveButton           : setControlName( "this CGenerateTeamView self.m_leaveButton 252 " )

        -- self.m_applyCaptainButton : setFontSize( 30)
        -- self.m_leaveButton        : setFontSize( 30)

        -- self.m_applyCaptainButton : setTag( CGenerateTeamView.TAG_APPLYCAPTAIN)
        -- self.m_leaveButton        : setTag( CGenerateTeamView.TAG_LEAVE)

        -- self.m_applyCaptainButton : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_applyCaptainButton 263")
        -- self.m_leaveButton        : registerControlScriptHandler( CellCallBack, "this CGenerateTeamView self.m_leaveButton 264")

        -- self.m_generateTeamViewContainer : addChild( self.m_applyCaptainButton)
        -- self.m_generateTeamViewContainer : addChild( self.m_leaveButton)
    end
end

function CGenerateTeamView.CreateTeammatesimage(self,_no,winSize,_pro) --创建人物图像

    --local cellButtonSize     = CCSizeMake( 240, 430)
    --local iconurl = "HeadIconResources/role_body_0".._pro..".png"
    local iconurl = "role_body_0".._pro..".png"
    table.insert(self.PlayerBodyList,_no)
    self.teammatesimage[_no] = CSprite : createWithSpriteFrameName( iconurl )
    --self.teammatesimage[_no] : setPreferredSize( cellButtonSize)
    self.teammatesimage[_no] : setControlName( "this CGenerateTeamView teammatesimage 390 ")
    self.teammatesimage[_no] : setScale(0.5)
    self.teammatesimage[_no] : setPosition(0,-25)
    self.m_teammatesBtn[_no] : addChild( self.teammatesimage[_no], 1)

    self.teammatesNameSprite[_no]       = CSprite : createWithSpriteFrameName("team_team_name_underframe.png")
    self.teammatesFrightSprite[_no]     = CSprite : createWithSpriteFrameName("team_effective_underframe.png")
    self.teammatesFrightSpr[_no]        = CSprite : createWithSpriteFrameName("team_writing_zdl.png")

    self.teammatesNameSprite[_no]       : setPreferredSize( CCSizeMake(270,90))
    self.teammatesFrightSprite[_no]     : setPreferredSize( CCSizeMake(270,55))

    self.teammatesNameSprite[_no]       : setPosition(0,180)
    self.teammatesFrightSprite[_no]     : setPosition( 0,-195)
    self.teammatesFrightSpr[_no]        : setPosition( -50,-195)

    self.m_teammatesBtn[_no] : addChild( self.teammatesNameSprite[_no], 2)
    self.m_teammatesBtn[_no] : addChild( self.teammatesFrightSprite[_no], 2)
    self.m_teammatesBtn[_no] : addChild( self.teammatesFrightSpr[_no], 3)


end


function CGenerateTeamView.CreateLeaderTipBox(self,_x,_y) --创建队长专用面板

    local function CellCallBack( eventType, obj, x, y)
       return self :clickCellCallBack( eventType, obj, x, y)
    end

    self.TipBoxContiner  = CContainer : create ()
    self.TipBoxContiner   : setPosition(_x,_y)
    self.m_scenelayer     : addChild(self.TipBoxContiner,10)

    local backSprite      = CSprite : createWithSpriteFrameName("general_second_underframe.png")
    backSprite            : setPreferredSize(CCSizeMake(200,150))
    backSprite            : setPosition(0,0)
    self.TipBoxContiner   : addChild(backSprite,-1)

    self.AddFriendBtn     = CButton : create( "加为好友", "transparent.png")
    self.KickedOutBtn     = CButton : create( "踢出队伍", "transparent.png")
    self.AppointLeaderBtn = CButton : create( "委任队长", "transparent.png")

    self.AddFriendBtn     : setPreferredSize(CCSizeMake(200,40))
    self.KickedOutBtn     : setPreferredSize(CCSizeMake(200,40))
    self.AppointLeaderBtn : setPreferredSize(CCSizeMake(200,40))

    self.AddFriendBtn     : setTag(CGenerateTeamView.TAG_ADDFRINED )
    self.KickedOutBtn     : setTag(CGenerateTeamView.TAG_KICKEDOUT )
    self.AppointLeaderBtn : setTag(CGenerateTeamView.TAG_APPOINTLEADER )

    self.AddFriendBtn     : setTouchesPriority(-2)
    self.KickedOutBtn     : setTouchesPriority(-2)
    self.AppointLeaderBtn : setTouchesPriority(-2)

    self.AddFriendBtn     : registerControlScriptHandler(CellCallBack,"this CGenerateTeamView.CreateLeaderTipBox AddFriendBtn 568 ")
    self.KickedOutBtn     : registerControlScriptHandler(CellCallBack,"this CGenerateTeamView.CreateLeaderTipBox KickedOutBtn 569 ")
    self.AppointLeaderBtn : registerControlScriptHandler(CellCallBack,"this CGenerateTeamView.CreateLeaderTipBox AppointLeaderBtn 570 ")

    local partingLineSprite1  = CSprite :createWithSpriteFrameName( "team_dividing_line.png") --我是无耻的分割线
    partingLineSprite1        : setControlName( "this CGenerateTeamView partingLineSprite 565 ")
    local partingLineSprite2  = CSprite :createWithSpriteFrameName( "team_dividing_line.png") --我是无耻的分割线
    partingLineSprite2        : setControlName( "this CGenerateTeamView partingLineSprite 567 ")

    partingLineSprite1 : setPreferredSize(CCSizeMake(200,1))
    partingLineSprite2 : setPreferredSize(CCSizeMake(200,1))

    self.AddFriendBtn     : setFontSize(20)
    self.KickedOutBtn     : setFontSize(20)
    self.AppointLeaderBtn : setFontSize(20)

    self.AddFriendBtn     : setPosition(0,50)
    partingLineSprite1    : setPosition(0,25)
    self.KickedOutBtn     : setPosition(0,0)
    partingLineSprite2    : setPosition(0,-25)
    self.AppointLeaderBtn : setPosition(0,-50)

    self.TipBoxContiner : addChild(self.AddFriendBtn)
    self.TipBoxContiner : addChild(self.KickedOutBtn)
    self.TipBoxContiner : addChild(self.AppointLeaderBtn)
    self.TipBoxContiner : addChild(partingLineSprite1,1)
    self.TipBoxContiner : addChild(partingLineSprite2,1)
end

function CGenerateTeamView.CreateTeamerTipBox(self,_x,_y) --创建队员面板

    local function CellCallBack( eventType, obj, x, y)
       return self :clickCellCallBack( eventType, obj, x, y)
    end

    self.TipBoxContiner  = CContainer : create ()
    self.TipBoxContiner   : setPosition(_x,_y)
    self.m_scenelayer     : addChild(self.TipBoxContiner,10)

    local backSprite      = CSprite : createWithSpriteFrameName("general_second_underframe.png")
    backSprite            : setPreferredSize(CCSizeMake(120,50))
    backSprite            : setPosition(0,0)
    self.TipBoxContiner   : addChild(backSprite,-1)

    self.AddFriendBtn     = CButton : create( "加为好友", "transparent.png")
    self.AddFriendBtn     : setPreferredSize(CCSizeMake(120,40))
    self.AddFriendBtn     : setTag(CGenerateTeamView.TAG_ADDFRINED )
    self.AddFriendBtn     : setTouchesPriority(-2)
    self.AddFriendBtn     : registerControlScriptHandler(CellCallBack,"this CGenerateTeamView.CreateLeaderTipBox AddFriendBtn 568 ")
    self.AddFriendBtn     : setFontSize(20)
    self.AddFriendBtn     : setPosition(0,0)
    self.TipBoxContiner   : addChild(self.AddFriendBtn)
end
function CGenerateTeamView.AddFriendBtnNetWorkSend(self,_id) --加为好友协议发送
    local list = {}
    list[1]    = _id
    require "common/protocol/auto/REQ_FRIEND_ADD"
    local msg = REQ_FRIEND_ADD()
    msg : setType(1)       -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
    msg : setCount(1)      -- {添加的数量}
    msg : setDetail(list)  -- {请求添加好友详情}
    CNetwork : send(msg)
    print("CGenerateTeamView 加为好友协议发送 send,完毕 611")
end
function CGenerateTeamView.KickedOutBtnNetWorkSend(self,_id) --踢出队伍协议发送
    require "common/protocol/auto/REQ_TEAM_KICK"
    local msg = REQ_TEAM_KICK()
    msg : setUid(_id)  -- {请求添加好友详情}
    CNetwork : send(msg)
    print("CGenerateTeamView 踢出队伍协议发送 send,完毕 619")
end
function CGenerateTeamView.LeaveTeamBtnNetWorkSend(self) --离开队伍协议发送
    require "common/protocol/auto/REQ_TEAM_LEAVE"
    local msg = REQ_TEAM_LEAVE()
    CNetwork : send(msg)
    print("CGenerateTeamView 离开队伍协议发送 send,完毕 641")
end
function CGenerateTeamView.AppointLeaderBtnNetWorkSend(self,_id) --委任队长协议发送
    require "common/protocol/auto/REQ_TEAM_SET_LEADER"
    local msg = REQ_TEAM_SET_LEADER()
    msg : setUid(_id)  -- {请求添加好友详情}
    CNetwork : send(msg)
    print("CGenerateTeamView 委任队长协议发送 send,完毕 624")
end
function CGenerateTeamView.EnterDuplicateBtnNetWorkSend(self,_Sceneid) --进入副本协议发送
    require "common/protocol/auto/REQ_COPY_CREAT"
    local msg = REQ_COPY_CREAT()
    msg : setCopyId(_Sceneid)   -- {副本ID}
    CNetwork : send(msg)
    print("CGenerateTeamView 进入副本协议发送 send,完毕 624")
end

function CGenerateTeamView.ApplyLeaderBtnNetWorkSend(self) -- [3650]申请做队长 -- 组队系统
    require "common/protocol/auto/REQ_TEAM_APPLY_LEADER"
    local msg = REQ_TEAM_APPLY_LEADER()
    CNetwork : send(msg)
    print("CGenerateTeamView 申请做队长协议发送 send,完毕 671")
end

function CGenerateTeamView.requestFriendNetWorkSend( self, _nType)
    _nType = tonumber( _nType)
    print("请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）, _nType==", _nType)

    if _nType ~= nil then
        require "common/protocol/auto/REQ_FRIEND_REQUES"
        local msg = REQ_FRIEND_REQUES()
        msg :setType( _nType)
        CNetwork :send( msg)
    end
end

function CGenerateTeamView.leaveNotice( self,_Type )
    Type = tonumber( _Type)
    if Type == 1 then
        local msg = "你被被踢出队伍"
        self : createMessageBox(msg)
    end
    if self ~= nil then
        if _G.g_CGenerateTeamMediator ~= nil then
            controller :unregisterMediator(_G.g_CGenerateTeamMediator)
            _G.g_CGenerateTeamMediator = nil
        end
        -- self : LeaveTeamBtnNetWorkSend() --离开队伍协议发送
        CCDirector :sharedDirector() :popScene( self._scene)
        self : unloadResource()
        _G.g_unLoadIconSources: unLoadAllIconsByNameList(self.PlayerBodyList)
    else
        print("leaveNotice,objSelf = nil", self)
    end
end

function CGenerateTeamView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)
end










