require "mediator/mediator"
require "controller/command"

CServerTime = class(function(self)
	self.m_timeOffset = 0
    self.m_chatJTime  = 0  --聊天  世界频道发送时的时间(秒)
    self.m_hangupTime = 0  --挂机  挂机  完成时的时间(秒)
end)


--------------------------------------------------     聊天间隔  STAT
function CServerTime.resetChatJTime(self)
	_G.pDateTime:reset()
	self.m_chatJTime = (_G.pDateTime:getTotalSeconds())
	print(self.m_chatJTime)
end

function CServerTime.getChatJTime(self)
	_G.pDateTime:reset()

    print("        ")
	return (_G.pDateTime:getTotalSeconds()) - self.m_chatJTime
end
--------------------------------------------------     聊天间隔  END


--------------------------------------------------     挂机倒计时 START
function CServerTime.setHangUpTime(self, value)
	_G.pDateTime:reset()
	self.m_hangupTime = (_G.pDateTime:getTotalSeconds()) + value
	print(self.m_chatJTime)
end

function CServerTime.getHangUpTime(self)
	_G.pDateTime:reset()
	return self.m_hangupTime - (_G.pDateTime:getTotalSeconds())
end
--------------------------------------------------     挂机倒计时 END




function CServerTime.setServerTime(self, value)
	_G.pDateTime:reset()
	self.m_timeOffset = (_G.pDateTime:getTotalSeconds()) - value
	print(self.m_timeOffset)
    self : onheart()
end

function CServerTime.onheart( self )
    if self.dispHandle ~= nil then
        _G.Scheduler : unschedule( self.dispHandle )
        self.dispHandle = nil
    end
    local function disapper()
        if _G.CNetwork:isConnected() then
            _G.CNetwork:disconnect()
        else
            CCNotificationCenter:sharedNotificationCenter():postNotification("DISCONNECT_MESSAGE")
        end
    end
    self.dispHandle = _G.Scheduler : performWithDelay( 16, disapper )
end

function CServerTime.getServerTimeSeconds(self)
	_G.pDateTime:reset()
	return (_G.pDateTime:getTotalSeconds()) - self.m_timeOffset
end

function CServerTime.getServerTimeMilliseconds(self)
	_G.pDateTime:reset()
	return (_G.pDateTime:getTotalMilliseconds()) - self.m_timeOffset * 1000
end

CServerTimeMediator = class(mediator, function(self, _view)
    self.name = "CServerTimeMediator"
    self.view = _view
end)

function CServerTimeMediator.getView(self)
	return self.view
end

function CServerTimeMediator.getName(self)
	return self.name
end

function CServerTimeMediator.processCommand(self, _command)
	if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_SYSTEM_TIME then -- [510]时间校正 -- 系统
            self:getView():setServerTime( ackMsg:getSrvTime() )
			return true
		end
	end
	return false
end


_G.pDateTime = CDateTime:create()
_G.pDateTime:retain()

_G.g_ServerTime = CServerTime()