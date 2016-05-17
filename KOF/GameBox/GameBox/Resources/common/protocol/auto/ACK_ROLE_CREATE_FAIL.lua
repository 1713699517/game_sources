
require "common/AcknowledgementMessage"

-- [1050]创建失败 -- 角色 

ACK_ROLE_CREATE_FAIL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_CREATE_FAIL
	self:init()
end)

function ACK_ROLE_CREATE_FAIL.deserialize(self, reader)
	self.error_code = reader:readInt16Unsigned() -- {错误代码}
end

-- {错误代码}
function ACK_ROLE_CREATE_FAIL.getErrorCode(self)
	return self.error_code
end
