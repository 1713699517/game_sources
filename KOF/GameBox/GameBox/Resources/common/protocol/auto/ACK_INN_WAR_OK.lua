
require "common/AcknowledgementMessage"

-- (手动) -- [31180]出战成功 -- 客栈 

ACK_INN_WAR_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_WAR_OK
	self:init()
end)
