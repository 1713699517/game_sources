require "mediator/mediator"
--[[
场景跑马灯文字
]]

require "controller/LogsCommand"

CMarqueeMediator = class(mediator, function(self, _view)
    self.name = "CMarqueeMediator"
    self.view = _view
end)


function CMarqueeMediator.processCommand(self, _command)
    if _command:getType() == CNetworkCommand.TYPE then
        local msgID = _command:getProtocolID()
        local ackMsg = _command:getAckMessage()
        if msgID == _G.Protocol["ACK_SYSTEM_NOTICE"] then -- (手动) -- [800]系统通知 -- 系统 跑马灯
            self : ACK_SYSTEM_NOTICE( ackMsg )
            --return true
        end
    elseif _command :getType() == CMarqueeCommand.TYPE then
        self : ACK_SYSTEM_BROADCAST( _command :getData() )
    end
    return false
end

-- (手动) -- [800]系统通知 -- 系统 
function CMarqueeMediator.ACK_SYSTEM_NOTICE( self, _ackMsg )
    local result = {}
    result.showtime = _ackMsg : getShowTime()
    result.position = _ackMsg : getPosition()
    result.msgdata  = _ackMsg : getMsgData()
    print("_系统通知: ",result.showtime,result.position,result.msgdata)
    self : getView() : pushOne( result )
end

-- [810]游戏广播 -- 系统 
function CMarqueeMediator.ACK_SYSTEM_BROADCAST( self, _data )
    print("-- [810]游戏广播 -- 系统 ")
    local result = {}
    result.showtime = 1
    result.position = 0
    result.msgdata  = _data or "_command Error"
    print("_系统通知: ",result.showtime,result.position,result.msgdata)
    self : getView() : pushOne( result )
end
