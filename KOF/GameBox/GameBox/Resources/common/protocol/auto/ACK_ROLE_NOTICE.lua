
require "common/AcknowledgementMessage"

-- [1330]提醒签到 -- 角色 

ACK_ROLE_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_NOTICE
	self:init()
end)
