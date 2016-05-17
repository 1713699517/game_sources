
require "common/AcknowledgementMessage"

-- (手动) -- [7970]停止副本挂机成功 -- 副本 

ACK_COPY_STOP_UP_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_STOP_UP_SUCCESS
	self:init()
end)
