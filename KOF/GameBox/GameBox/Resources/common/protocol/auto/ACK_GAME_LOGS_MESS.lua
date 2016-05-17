
require "common/AcknowledgementMessage"

-- [22770]信息组协议块 -- 日志 

ACK_GAME_LOGS_MESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GAME_LOGS_MESS
	self:init()
end)

function ACK_GAME_LOGS_MESS.deserialize(self, reader)
	self.states = reader:readInt8Unsigned() -- {状态[得|失 增|减]}
	self.id = reader:readInt32Unsigned() -- {具体事件}
	self.value = reader:readInt32Unsigned() -- {数量}
end

-- {状态[得|失 增|减]}
function ACK_GAME_LOGS_MESS.getStates(self)
	return self.states
end

-- {具体事件}
function ACK_GAME_LOGS_MESS.getId(self)
	return self.id
end

-- {数量}
function ACK_GAME_LOGS_MESS.getValue(self)
	return self.value
end
