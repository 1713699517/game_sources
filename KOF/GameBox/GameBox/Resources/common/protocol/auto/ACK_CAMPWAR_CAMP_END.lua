
require "common/AcknowledgementMessage"

-- [45850]活动结束 -- 活动-阵营战 

ACK_CAMPWAR_CAMP_END = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_CAMP_END
	self:init()
end)
