require "mediator/mediator"
require "common/MessageProtocol"

CWorldBossMediator = class(mediator, function(self, _view)
    self.name = "CWorldBossMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CWorldBossMediator.getView(self)
    return self.view
end

function CWorldBossMediator.getName(self)
    return self.name
end

function CWorldBossMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_ACTIVITY_OK_ACTIVE_DATA   then -- [30520]活动数据返回 -- 活动面板 
            print("-- [30520]活动数据返回 -- 活动面板")
            self :ACK_ACTIVITY_OK_ACTIVE_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_ACTIVITY_ACTIVE_DATA then  -- (手动) -- [30501]活动状态改变 -- 活动面板 
            print( "-- (手动) -- [30501]活动状态改变 -- 活动面板 ")
            self :ACK_ACTIVITY_ACTIVE_DATA( ackMsg)
        end
    end
    return false
end
-- 
-- [30520]活动数据返回 -- 活动面板 
function CWorldBossMediator.ACK_ACTIVITY_OK_ACTIVE_DATA( self, _ackMsg)
    local count       = _ackMsg :getCount()
    local activeData  = _ackMsg :getActiveMsg()
    self :getView() :setLocalList( _ackMsg :getCount(), _ackMsg :getActiveMsg())
end
-- (手动) -- [30501]活动状态改变 -- 活动面板 
function CWorldBossMediator.ACK_ACTIVITY_ACTIVE_DATA( self, _ackMsg)
    local active = {}
    active.id         = _ackMsg :getId()
    active.is_new     = _ackMsg :getIsNew()
    active.start_time = _ackMsg :getStartTime()
    active.end_time   = _ackMsg :getEndTime()
    active.state      = _ackMsg :getState()
    self :getView() :setActiveStateChange( active )
end