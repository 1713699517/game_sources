
require "common/AcknowledgementMessage"

-- [500]重置连接hex -- 系统 

ACK_SYSTEM_RESET_IDX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_RESET_IDX
	self:init()
end)
