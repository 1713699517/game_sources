
require "common/AcknowledgementMessage"

-- [7830]退出副本成功 -- 副本 

ACK_COPY_EXIT_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_EXIT_OK
	self:init()
end)
