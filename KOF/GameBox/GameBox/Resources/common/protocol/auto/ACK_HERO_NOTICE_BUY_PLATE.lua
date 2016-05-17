
require "common/AcknowledgementMessage"

-- (手动) -- [39545]通知购买文牒 -- 英雄副本 

ACK_HERO_NOTICE_BUY_PLATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_NOTICE_BUY_PLATE
	self:init()
end)
