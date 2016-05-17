
require "common/AcknowledgementMessage"

-- (手动) -- [6023]战斗结束通知 -- 战斗 

ACK_WAR_OVER_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_OVER_NOTICE
	self:init()
end)
