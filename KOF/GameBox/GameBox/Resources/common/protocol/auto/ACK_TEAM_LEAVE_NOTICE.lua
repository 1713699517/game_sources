
require "common/AcknowledgementMessage"

-- [3620]离队通知 -- 组队系统 

ACK_TEAM_LEAVE_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_LEAVE_NOTICE
	self:init()
end)

function ACK_TEAM_LEAVE_NOTICE.deserialize(self, reader)
	self.reason = reader:readInt8Unsigned() -- {离队原因(CONST_TEAM_OUT_*)}
end

-- {离队原因(CONST_TEAM_OUT_*)}
function ACK_TEAM_LEAVE_NOTICE.getReason(self)
	return self.reason
end
