
require "common/AcknowledgementMessage"

-- [18025]开始钓鱼 -- 活动-钓鱼达人 

ACK_FISHING_OK_GO_FISHING = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FISHING_OK_GO_FISHING
	self:init()
end)
