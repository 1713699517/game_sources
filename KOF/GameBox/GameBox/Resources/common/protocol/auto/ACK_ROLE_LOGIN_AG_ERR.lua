
require "common/AcknowledgementMessage"

-- [1012]断线重连返回 -- 角色 

ACK_ROLE_LOGIN_AG_ERR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LOGIN_AG_ERR
	self:init()
end)

function ACK_ROLE_LOGIN_AG_ERR.deserialize(self, reader)
	self.result = reader:readBoolean() -- {0:失败|1:成功}
end

-- {0:失败|1:成功}
function ACK_ROLE_LOGIN_AG_ERR.getResult(self)
	return self.result
end
