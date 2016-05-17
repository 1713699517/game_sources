
require "common/AcknowledgementMessage"

-- (手动) -- [7780]第一次杀死怪 -- 副本 

ACK_COPY_FIRST_OVER_MONS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_FIRST_OVER_MONS
	self:init()
end)
