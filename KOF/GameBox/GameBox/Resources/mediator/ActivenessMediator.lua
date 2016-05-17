--------------------------
--活跃度 Mediator
--------------------------

require "mediator/mediator"
require "common/MessageProtocol"

CActivenessMediator = class(mediator, function(self, _view)
    self.name = "CActivenessMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CActivenessMediator.getView(self)
    return self.view
end

function CActivenessMediator.getName(self)
    return self.name
end

function CActivenessMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_ACTIVITY_OK_LINK_DATA   then -- 30620    活跃度数据返回
            self :ACK_ACTIVITY_OK_LINK_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_ACTIVITY_OK_GET_REWARDS then  -- 30660   领奖状态返回
            self :ACK_ACTIVITY_OK_GET_REWARDS( ackMsg)
        end
    end
    return false
end
-- 
-- 30620    活跃度数据返回
function CActivenessMediator.ACK_ACTIVITY_OK_LINK_DATA( self, _ackMsg)
    self :getView() :setRewardView( _ackMsg :getVitality(), _ackMsg:getCount2(), _ackMsg :getRewards())
    self :getView() :setActivityListView( _ackMsg :getActiveData() )
end
-- 30660   领奖状态返回
function CActivenessMediator.ACK_ACTIVITY_OK_GET_REWARDS( self, _ackMsg)
    -- body
    self :getView() :geRewardCallBack( _ackMsg :getId() )
end