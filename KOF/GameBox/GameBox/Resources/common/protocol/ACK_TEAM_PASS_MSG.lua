
require "common/AcknowledgementMessage"

-- [3560]通关副本信息块 -- 组队系统 

ACK_TEAM_PASS_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_PASS_MSG
	self:init()
end)

function ACK_TEAM_PASS_MSG.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
end

-- {副本ID}
function ACK_TEAM_PASS_MSG.getCopyId(self)
	return self.copy_id
end
