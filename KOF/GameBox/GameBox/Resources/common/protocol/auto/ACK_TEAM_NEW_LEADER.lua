
require "common/AcknowledgementMessage"

-- [3670]新队长通知 -- 组队系统 

ACK_TEAM_NEW_LEADER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_NEW_LEADER
	self:init()
end)
