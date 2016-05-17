
require "common/AcknowledgementMessage"

-- [7810]副本失败 -- 副本 

ACK_COPY_FAIL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_FAIL
	self:init()
end)
