
require "common/AcknowledgementMessage"

-- (手动) -- [3645]解散队伍通知 -- 组队系统 

ACK_TEAM_DISMISS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_DISMISS
	self:init()
end)
