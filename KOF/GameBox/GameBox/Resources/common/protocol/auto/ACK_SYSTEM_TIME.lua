
require "common/AcknowledgementMessage"

-- [510]时间校正 -- 系统 

ACK_SYSTEM_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_TIME
	self:init()
end)

function ACK_SYSTEM_TIME.deserialize(self, reader)
	self.srv_time = reader:readInt32Unsigned() -- {服务器时间戳}
end

-- {服务器时间戳}
function ACK_SYSTEM_TIME.getSrvTime(self)
	return self.srv_time
end
