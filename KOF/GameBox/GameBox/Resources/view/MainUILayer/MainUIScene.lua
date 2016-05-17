--MainUILayer  主界面

require "view/MainUILayer/VipView"
require "view/MainUILayer/FunctionMenu"
require "view/MainUILayer/ActivityIcon"
require "view/Chat/ChatWindowedView"
require "mediator/ChatWindowedMediator"
require "mediator/VipMediator"
require "mediator/ActivityIconMediator"
require "mediator/FunctionMenuMediator"
--require "view/SkillsUI/SkillsUIView"
require "view/view"
require "common/Network"

require "view/FriendUI/RecommendFriendView"
require "view/Guide/GuideManager"

CMainUIScene = class( view, function(self)
    _G.pCGuideManager = CGuideManager()
end)

function CMainUIScene.initParams( self )
    --self :unregisterMainMediator()
    
    require "mediator/MainUIMediator"
    _G.pMainMediator = CMainUIMediator( self)
    controller :registerMediator( _G.pMainMediator)

    CMainUIScene.backpackParams( self )
    --2013.07.09
    self :requestTaskList()

    --好友缓存  0922.11:44 注释掉
    --require "proxy/FriendDataProxy"         --好友proxy
  
    --日常任务缓存 0922.11:44 注释掉
    --require "proxy/DailyTaskProxy"
    
    local mainProperty  = _G.g_characterProperty : getMainPlay()
    local nlv = mainProperty : getLv() or 0
    if _G.Constant.CONST_TASK_DAILY_ENTER_LV <= nlv then
        require "common/protocol/auto/REQ_DAILY_TASK_REQUEST"
        local msgDialyTask = REQ_DAILY_TASK_REQUEST()
        CNetwork :send( msgDialyTask)
    end

    
end



--请求任务
function CMainUIScene.requestTaskList( self )
    --任务缓存 0922.11:44 注释掉
    --require "proxy/TaskNewDataProxy"
    if _G.g_CTaskNewDataProxy ~= nil and _G.g_CTaskNewDataProxy :getInitialized() == true then
        print("_G.g_CTaskNewDataProxy有数据不请求", _G.g_CTaskNewDataProxy, _G.g_CTaskNewDataProxy :getInitialized())
        --CCMessageBox("CMainUIScene.requestTaskList", "")
        return true
    end
    --require "common/Network"
    require "common/protocol/auto/REQ_TASK_REQUEST_LIST"
    local msg = REQ_TASK_REQUEST_LIST()
    CNetwork :send( msg)
    
    print("=====请求任务=====\n")
end


--背包
function CMainUIScene.backpackParams( self)
    require "controller/TaskNewDataCommand"
end

--技能    ------2013.07.09  
function CMainUIScene.requestSkillParams( self)

    require "mediator/SkillDataMediator"
    
    require "common/protocol/auto/REQ_SKILL_REQUEST"
    local msg = REQ_SKILL_REQUEST()
    CNetwork :send( msg)
end

--加载资源
function CMainUIScene.loadResource(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")    --新的
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
end 

function CMainUIScene.realeaseParams( self )
    -- body
    self.m_pFuncMenuView = nil
    self.m_pLayer = nil
end

--主界面初始化
function CMainUIScene.init(self, winSize, layer)
    require "mediator/GuideMediator"
    CMainUIScene.initParams( self )
    
    CMainUIScene.loadResource(self) 
    
    --vip头像
    _G.pVipView = CVipView()
    if _G.pVipMediator ~= nil then
        controller :unregisterMediator( _G.pVipMediator )
        _G.pVipMediator = nil
    end
    _G.pVipMediator = CVipMediator( _G.pVipView )
    controller :registerMediator( _G.pVipMediator )
    
    layer :addChild( _G.pVipView :scene() ,1)
    ----------------------------------------------------------------
    --活动图标
    _G.pCActivityIconView = CActivityIcon()
    if _G.pActivityIconMediator ~= nil then
        controller :unregisterMediator( _G.pActivityIconMediator )
        _G.pActivityIconMediator = nil
    end
    _G.pActivityIconMediator = CActivityIconMediator( _G.pCActivityIconView )
    controller :registerMediator( _G.pActivityIconMediator )
    
    layer :addChild( _G.pCActivityIconView :scene() )
    ----------------------------------------------------------------
    --功能按钮
    _G.pCFunctionMenuView = CFunctionMenu()
    if _G.g_CFunctionMenuMediator ~= nil then
        controller :unregisterMediator( _G.g_CFunctionMenuMediator )
        _G.g_CFunctionMenuMediator = nil
    end
    _G.g_CFunctionMenuMediator = CFunctionMenuMediator( _G.pCFunctionMenuView )
    controller :registerMediator( _G.g_CFunctionMenuMediator )
    
    layer :addChild( _G.pCFunctionMenuView :scene() )
    ----------------------------------------------------------------
    --聊天(测试)
    _G.pChatWindowedView = CChatWindowedView()
    if _G.pChatWindowedMediator ~= nil then
        controller:unregisterMediator(_G.pChatWindowedMediator)
        _G.pChatWindowedMediator = nil
    end
    _G.pChatWindowedMediator = CChatWindowedMediator( _G.pChatWindowedView )
    controller:registerMediator(_G.pChatWindowedMediator )

    layer :addChild( _G.pChatWindowedView:container() )
    ----------------------------------------------------------------
    
    --技能注册  0906注释掉
    --self :requestSkillParams()

    --好友推荐界面弹出判断
    self : openFriendRecommendUI()
    --好友邀请图标弹出
    self : openFriendInviteIcon()
    
end


function CMainUIScene.scene(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CCScene :create()
    
    self.m_pLayer = CCLayer :create()
    self :init(winSize, self.m_pLayer)
    
    scene :addChild( self.m_pLayer)
    return scene
end

function CMainUIScene.container(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CContainer :create()
    scene : setControlName( "this is CMainUIScene scene 125  " )
    
    self.m_pLayer = CCLayer :create()
    --徐敏飞临时加上
    print("到了mainUiScene CContainer 创建的函数")
    _G.tmpMainUi = self.m_pLayer
    
    self :init(winSize, self.m_pLayer)
    scene :addChild( self.m_pLayer)
    return scene
end

function CMainUIScene.getMainLayer( self )
    return self.m_pLayer
end

--关闭 右下角的系统按钮
function CMainUIScene.setMenuStatus(self, _bValue)
    if _G.pCFunctionMenuView ~= nil then
        _G.pCFunctionMenuView :setMenuStatus( _bValue)
    else
        CCLOG("_G.pCFunctionMenuView为空,怎摸回事?")
        print("self==="..self.."   _G.pCFunctionMenuView===".._G.pCFunctionMenuView)
    end
    
end

function CMainUIScene.unregisterMainMediator( self)
    if _G.pChatWindowedMediator ~= nil then
        controller:unregisterMediator(_G.pChatWindowedMediator)
        _G.pChatWindowedMediator = nil
    end
    if _G.pVipMediator ~= nil then
        controller :unregisterMediator( _G.pVipMediator )
        _G.pVipMediator = nil
    end
    if _G.pActivityIconMediator ~= nil then
        controller :unregisterMediator( _G.pActivityIconMediator )
        _G.pActivityIconMediator = nil
    end
    
    if _G.g_CFunctionMenuMediator ~= nil then
        controller :unregisterMediator( _G.g_CFunctionMenuMediator )
        _G.g_CFunctionMenuMediator = nil
    end
    if _G.pMainMediator then
        controller :unregisterMediator( _G.pMainMediator)
        _G.pMainMediator = nil
    end
end

--打开好友推荐界面 
function CMainUIScene.openFriendRecommendUI( self )

    local issFriendRecommend = _G.g_GameDataProxy : getIsFriendRecommend()

    if issFriendRecommend == 0 then --是否有打开过
        if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then --是否再主场景
            print("好友推荐在主场景了")
            local data = _G.g_GameDataProxy : getFriendRecommendData()
            if data ~= nil then
                local recommendView = CRecommendFriendView(data)
                print("_G.tmpMainUi222", self.m_pLayer)
                if self.m_pLayer then
                    self.m_pLayer : addChild ( recommendView :scene(), 10000)
                    _G.g_GameDataProxy : setIsFriendRecommend(1)
                end
            end
        end
    end
end
--打开好友邀请小图标 jun 2013.10.11------------------------------------------------------------
function CMainUIScene.openFriendInviteIcon( self )

    if  _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_TEAM) == 1 then

        local function FriendInviteCallback( eventType, obj, x, y )
            return self :onFriendInviteCallback( eventType, obj, x, y )
        end
        local data    = _G.g_GameDataProxy : getInviteFriendsData()
        local winSize = CCDirector :sharedDirector() :getVisibleSize()

        if data ~= nil  then
            self.m_InviteFriendIcon = {}
            local count = tonumber(#data)  
            for i=1,count do
                print("打开好友邀请小图标的判断",i,data[i].State)
                if  data[i].State == 0 then 
                    if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then --是否再主场景
                        print("CMainUIScene.openFriendInviteIcon 好友邀请小图标在主场景了",data,no)
                        
                        self.m_InviteFriendIcon[i] = CButton :create( "", "FriendListViewResources/team_icon.png" )
                        self.m_InviteFriendIcon[i] : setTouchesEnabled( true)
                        self.m_InviteFriendIcon[i] : setTag(i)
                        self.m_InviteFriendIcon[i] : registerControlScriptHandler( FriendInviteCallback, "this CMainUIScene.addEmailIcon. self.m_lpEmailIcon 259" )

                        _G.tmpMainUi : addChild( self.m_InviteFriendIcon[i],10000)
                        self.m_InviteFriendIcon[i]  : setPosition( ccp( winSize.width /2+(i-1)*50,  150) )
                        
                        data[i].State = 1 --已经创建过了的
                        _G.g_CTaskNewDataProxy :playMusicByName( "point_out" )
                    end
                end 
            end
            self.transInviteFriendsData = data
            _G.g_GameDataProxy : setInviteFriendsData(data)
        end

    end
end


function CMainUIScene.onFriendInviteCallback(self,eventType, obj, x, y)
            print("小图标按钮回调进来了了了了",obj: getTag())
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("小图标按钮回调进来了了了了2222",obj: getTag())
        local no     = obj: getTag()
        local data   = self.transInviteFriendsData
        local TeamId = data[no].TeamId
        if TeamId ~=nil then
            print("小图标按钮回调",TeamId,no)
            self : TeamIsLiveNetWorkSend(TeamId) --判断队伍是否存在
            self.transTeamInviteIconNo = no
            obj : removeFromParentAndCleanup(true)
        end
        return true
    end
end

function CMainUIScene.TeamIsLiveNetWorkSend( self,_TeamId)  --队伍是否存在协议发送
    require "common/protocol/auto/REQ_TEAM_LIVE_REQ" 
    local msg = REQ_TEAM_LIVE_REQ()
    msg       : setTeamId(_TeamId)  
    msg       : setInviteType(1)
    CNetwork  : send(msg)
    print("CMainUIScene TeamIsLiveNetWorkSend REQ_TEAM_LIVE_REQ send,完毕")
end

function CMainUIScene.NetWorkReturn_TEAM_LIVE_REP( self ,rep,inviteType)
    if  inviteType == 1 then
        print("队伍是否存在协议返回",rep)
        local no   = nil 
        local data = self.transInviteFriendsData
        if self.transTeamInviteIconNo ~= nil then
            no = tonumber(self.transTeamInviteIconNo) 
        end
        -- print("nonno ",no,self.m_InviteFriendIcon[no],#self.m_InviteFriendIcon)
        -- if self.m_InviteFriendIcon[no] ~= nil then
        --     self.m_InviteFriendIcon[no] : removeFromParentAndCleanup(true)
        --     self.m_InviteFriendIcon[no] = nil 
        --     print("删了你了了了yes",data[no].State,no)
        --     data[no].State = 1 --已经点击过的
        --     print("删了你了了了yes1111",data[no].State,no)
        --     _G.g_GameDataProxy : setInviteFriendsData(data)
        -- end

        if rep == 1 then
            if self.transInviteFriendsData ~=nil then
                local teamid = data[no].TeamId 
                local copyid = data[no].CopyId 
                self : TeamJoinNetWorkSend(teamid)  --加入队伍协议发送

                require "view/DuplicateLayer/GenerateTeamView"
                local pGenerateTeamView = CGenerateTeamView()
                CCDirector : sharedDirector () : pushScene( pGenerateTeamView :scene(0,copyid)) 
            end
        elseif rep == 0 then
            local _msg = "队伍进入副本或队伍已解散"
            require "view/ErrorBox/ErrorBox"
            local ErrorBox  = CErrorBox()
            local BoxLayer  = ErrorBox : create(_msg)
            self.m_pLayer   : addChild(BoxLayer,1000)
        end
    end
end

function CMainUIScene.TeamJoinNetWorkSend( self,_TeamId)
    require "common/protocol/auto/REQ_TEAM_JOIN" 
    local msg = REQ_TEAM_JOIN()
    msg       : setTeamId(_TeamId)  
    CNetwork  : send(msg)
    print("CChatView TeamJoinNetWorkSend REQ_TEAM_JOIN send,完毕")
end
------------------------------------------------------------------------------------------

--{新邮件 提示图标}
function CMainUIScene.addEmailIcon( self )
    self :cleanEmailIcon()
    
    if self :getMainLayer() == nil then
        return
    end
    
    local function cleanCallback( eventType, obj, x, y )
        return self :onCleanCallback( eventType, obj, x, y )
    end
    
    self.m_lpEmailIcon  = CButton :create( "", "VipResources/menu_Email_new.png" )
    self.m_lpEmailIcon   :setControlName( "this CMainUIScene.addEmailIcon. self.m_lpEmailIcon 256" )
    self :getMainLayer() :addChild( self.m_lpEmailIcon )
    
    self.m_lpEmailIcon   :registerControlScriptHandler( cleanCallback, "this CMainUIScene.addEmailIcon. self.m_lpEmailIcon 259" )
    
    local sizeIcon = self.m_lpEmailIcon :getPreferredSize()
    local winSize  = CCDirector :sharedDirector() :getVisibleSize()
    
    self.m_lpEmailIcon :setPosition( ccp( winSize.width / 2, 150 + sizeIcon.height / 2))--winSize.height * 0.671875 - sizeIcon.height / 2 ) )
    
    _G.g_CTaskNewDataProxy :playMusicByName( "point_out" )
end

function CMainUIScene.cleanEmailIcon( self )
    if self.m_lpEmailIcon ~= nil then
        self.m_lpEmailIcon :removeFromParentAndCleanup( true )
        self.m_lpEmailIcon = nil
    end
end

function CMainUIScene.onCleanCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        require "view/EmailUI/EmailView"
        local emailView = CEmailView()
        CCDirector :sharedDirector() :pushScene( emailView :scene())
        
        self :cleanEmailIcon()
        return true
    end
end

--任务接受特效添加
function CMainUIScene.AcceptTaskEffectsAdd( self )
    print("主场景添加接受任务特效")
    if self.AcceptTHEccbi ~= nil then
        if self.AcceptTHEccbi  : retainCount() >= 1 then
            self.AcceptTHEccbi : removeFromParentAndCleanup(true)
            self.AcceptTHEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
            if self.AcceptTHEccbi ~= nil then
                if self.AcceptTHEccbi  : retainCount() >= 1 then
                    self.AcceptTHEccbi : removeFromParentAndCleanup(true)
                    self.AcceptTHEccbi = nil 
                end
            end
        end
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.AcceptTHEccbi ~= nil then
        if self.AcceptTHEccbi  : retainCount() >= 1 then
            self.AcceptTHEccbi : removeFromParentAndCleanup(true)
            self.AcceptTHEccbi = nil 
        end
    end
    self.AcceptTHEccbi = CMovieClip:create( "CharacterMovieClip/effects_task_begin.ccbi" )
    self.AcceptTHEccbi : setPosition( ccp( winSize.width /2,  350) )
    self.AcceptTHEccbi : setControlName( "this CCBI CMainUIScene.TaskEffectsAdd CCBI")
    self.AcceptTHEccbi : registerControlScriptHandler( animationCallFunc)
    _G.tmpMainUi : addChild( self.AcceptTHEccbi,10000)
    print("添加完毕")
end
--完成任务特效添加
function CMainUIScene.OkTaskEffectsAdd( self )
    print("主场景添加接受任务特效")
    if self.OkTHEccbi ~= nil then
        if self.OkTHEccbi  : retainCount() >= 1 then
            self.OkTHEccbi : removeFromParentAndCleanup(true)
            self.OkTHEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
            if self.OkTHEccbi ~= nil then
                if self.OkTHEccbi  : retainCount() >= 1 then
                    self.OkTHEccbi : removeFromParentAndCleanup(true)
                    self.OkTHEccbi = nil 
                end
            end
        end
    end
    if self.OkTHEccbi ~= nil then
        if self.OkTHEccbi  : retainCount() >= 1 then
            self.OkTHEccbi : removeFromParentAndCleanup(true)
            self.OkTHEccbi = nil 
        end
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.OkTHEccbi = CMovieClip:create( "CharacterMovieClip/effects_task_end.ccbi" )
    self.OkTHEccbi : setPosition( ccp( winSize.width /2,  350) )
    self.OkTHEccbi : setControlName( "this CCBI CMainUIScene.TaskEffectsAdd CCBI")
    self.OkTHEccbi : registerControlScriptHandler( animationCallFunc)
    _G.tmpMainUi : addChild( self.OkTHEccbi,10000)
    print("添加完毕")
end

function CMainUIScene.removeAllIconCCBI( self )
    if self.OkTHEccbi ~= nil then
        if self.OkTHEccbi  : retainCount() >= 1 then
            self.OkTHEccbi : removeFromParentAndCleanup(true)
            self.OkTHEccbi = nil 
        end
    end
    if self.AcceptTHEccbi ~= nil then
        if self.AcceptTHEccbi  : retainCount() >= 1 then
            self.AcceptTHEccbi : removeFromParentAndCleanup(true)
            self.AcceptTHEccbi = nil 
        end
    end
    self :removeLevelCCBI()
    print("删除完毕")
end

function CMainUIScene.removeLevelCCBI( self )
    if self.m_lpLevelUpCCbi ~= nil then
        self.m_lpLevelUpCCbi :removeFromParentAndCleanup( true )
        self.m_lpLevelUpCCbi = nil
    end
    
    print( "删除任务－－－>", self.m_lpLevelUpCCbi )
end

function CMainUIScene.playLvEffect( self )
    
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
            
        elseif eventType == "AnimationComplete" then
            self :removeLevelCCBI()
        end
        
    end
   
    self :removeLevelCCBI()
    
    --local _winSize = CCDirector :sharedDirector() :getVisibleSize()
    
    self.m_lpLevelUpCCbi = CMovieClip :create( "CharacterMovieClip/effects_levelup.ccbi" )
    self.m_lpLevelUpCCbi : setControlName( "this CCBI self.m_lpLevelUpCCbi CCBI 504")
    self.m_lpLevelUpCCbi : registerControlScriptHandler( animationCallFunc)
    --self.m_lpLevelUpCCbi : setPosition( ccp( _winSize.width / 2, _winSize.height / 2))
    _G.g_Stage :getPlay() :getContainer() :addChild( self.m_lpLevelUpCCbi, 1000 )
        
end



