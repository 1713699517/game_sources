
require "common/AcknowledgementMessage"

-- (手动) -- [1001]踢下线 -- 角色 

ACK_ROLE_OUT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OUT
	self:init()
end)

function ACK_ROLE_OUT.deserialize(self, reader)
	self.error_code = reader:readInt16Unsigned() -- {错误代码}
end

-- {错误代码}
function ACK_ROLE_OUT.getErrorCode(self)
	return self.error_code
end
