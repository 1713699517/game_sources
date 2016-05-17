
require "common/AcknowledgementMessage"

-- (手动) -- [39545]通知购买文牒 -- 取经之路 

ACK_PILROAD_NOTICE_BUY_PLATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_NOTICE_BUY_PLATE
	self:init()
end)
