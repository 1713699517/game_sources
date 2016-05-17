
require "common/AcknowledgementMessage"

-- [1030]登录失败 -- 角色 

ACK_ROLE_LOGIN_FAIL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LOGIN_FAIL
	self:init()
end)
