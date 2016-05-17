
require "common/AcknowledgementMessage"

-- [1023]登录成功(没有角色) -- 角色 

ACK_ROLE_LOGIN_OK_NO_ROLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LOGIN_OK_NO_ROLE
	self:init()
end)

function ACK_ROLE_LOGIN_OK_NO_ROLE.deserialize(self, reader)
	self.pro = reader:readInt8Unsigned() -- {默认职业}
end

-- {默认职业}
function ACK_ROLE_LOGIN_OK_NO_ROLE.getPro(self)
	return self.pro
end
