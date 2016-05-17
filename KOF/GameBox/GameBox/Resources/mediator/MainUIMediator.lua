require "mediator/mediator"
require "controller/command"
require "controller/RecommendFriendCommand"
require "controller/TaskEffectsCommand"
require "common/MessageProtocol"
require "view/DuplicateLayer/HangupView"

CMainUIMediator = class( mediator, function( self, _view )
	self.m_name = "CMainUIMediator"
	self.m_view = _view

	print("CMainUIMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CMainUIMediator.getView( self )
	-- body
	return self.m_view
end


function CMainUIMediator.getName( self )
	return self.m_name
end

function CMainUIMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        print("CMainUIMediator.processCommand",msgID)

        if msgID == _G.Protocol["ACK_COPY_LOGIN_NOTICE"] then
            self : ACK_COPY_LOGIN_NOTICE( ackMsg )
            --return true
        end
        --jun  2013.10.11
        if msgID == _G.Protocol["ACK_TEAM_LIVE_REP"] then  -- (手动) -- [3730]查询队伍返回 -- 组队系统
            self : ACK_TEAM_LIVE_REP( ackMsg )
        end
        
        --{升级特效} effects_levelup.ccbi
        if msgID == _G.Protocol["ACK_ROLE_PROPERTY_UPDATE"] then
            self : addLvEffect( ackMsg )
        end
	end
    
    if _command :getType() == CRecommendDataCommand.TYPE then
        if _command :getData() == CRecommendDataCommand.OPEN then
            self : getView() : openFriendRecommendUI()
        end
    end
    
    --jun 2013.10.11 好友邀请
    if _command :getType() == CRecommendDataCommand.TYPE then
        if _command :getData() == CRecommendDataCommand.INVITE then
            self : getView() : openFriendInviteIcon()
        end
    end
    
    --jun 2013.10.28 接受任务特效添加
    if _command :getType() == CTaskEffectsCommand.TYPE then
       if _command :getData() == 1 then
            self : getView() : AcceptTaskEffectsAdd()
       end
       if _command :getData() == 2 then
            self : getView() : OkTaskEffectsAdd()
       end
    end
    --删除所有CCBI
    if _command:getType() == CGotoSceneCommand.TYPE then
        print("准备跳场景所以要删除所有的ccbi")
        self :getView() : removeAllIconCCBI()     
    end
    
    
    if _command :getType() == CEmailUpdataCommand.TYPE then
        if _command :getData() == CEmailUpdataCommand.ICON then
            if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
                self :getView() :addEmailIcon()
            end
        elseif _command :getData() == CEmailUpdataCommand.CLEAN then
            self :getView() :cleanEmailIcon()
        end
    end
    

    return false
	--判断需要处理的type self:getView()
end


function CMainUIMediator.ACK_COPY_LOGIN_NOTICE( self, _ackMsg )
    _G.g_CHangupView = CHangupView( _ackMsg:getData() )
    print("7865 process CHangupView pushScene")
    CCDirector:sharedDirector():pushScene(_G.g_CHangupView:scene(_ackMsg:getCopyId() , _ackMsg:getUseAll() , _ackMsg:getTime() , _ackMsg:getSumtimes() , _ackMsg:getNowtimes()))
end

function CMainUIMediator.ACK_TEAM_LIVE_REP(self,ackMsg)
    local rep        = tonumber(ackMsg : getRep()) --队伍是否存在 0:不存在|1:存在
    local InviteType = tonumber(ackMsg : getInviteType()) ---- {0：招募|1：邀请}

    print("CMainUIMediator.ACK_TEAM_LIVE_REP 队伍是否存在",rep)
    self : getView() : NetWorkReturn_TEAM_LIVE_REP(rep,InviteType) --sever methond
    
end

function CMainUIMediator.addLvEffect( self, _ackMsg )
    if _ackMsg ~= nil then
        if _ackMsg :getType() == _G.Constant.CONST_ATTR_LV then
            print("开始添加升级特效->", _ackMsg :getType(), _ackMsg :getId(), _ackMsg:getValue())
            local curScenesType = _G.g_Stage :getScenesType()
            if curScenesType ~= nil and curScenesType== _G.Constant.CONST_MAP_TYPE_CITY and _ackMsg :getId() == 0 then
                self :getView() :playLvEffect( )    --播放升级特效
            end
        end
    else
        CCLOG( "空的 addlv_effect" )
    end
end


