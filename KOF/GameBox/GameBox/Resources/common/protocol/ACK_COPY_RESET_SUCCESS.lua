
require "common/AcknowledgementMessage"

-- (手动) -- [7998]重置副本成功(7005协议块) -- 副本 

ACK_COPY_RESET_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_RESET_SUCCESS
	self:init()
end)
