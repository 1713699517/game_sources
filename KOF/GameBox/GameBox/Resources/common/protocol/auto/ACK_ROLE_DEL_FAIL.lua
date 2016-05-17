
require "common/AcknowledgementMessage"

-- [1063]销毁角色(失败) -- 角色 

ACK_ROLE_DEL_FAIL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_DEL_FAIL
	self:init()
end)

function ACK_ROLE_DEL_FAIL.deserialize(self, reader)
	self.error_code = reader:readInt16Unsigned() -- {错误代码}
end

-- {错误代码}
function ACK_ROLE_DEL_FAIL.getErrorCode(self)
	return self.error_code
end
