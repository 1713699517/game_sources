
require "common/AcknowledgementMessage"

-- [56830]状态信息块 -- 系统设置 

ACK_SYS_SET_XXXXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_SET_XXXXX
	self:init()
end)

function ACK_SYS_SET_XXXXX.deserialize(self, reader)
	self.type = reader:readInt16Unsigned() -- {功能}
	self.state = reader:readInt8Unsigned() -- {状态 0:为勾选1:已勾选}
end

-- {功能}
function ACK_SYS_SET_XXXXX.getType(self)
	return self.type
end

-- {状态 0:为勾选1:已勾选}
function ACK_SYS_SET_XXXXX.getState(self)
	return self.state
end
