
require "common/AcknowledgementMessage"

-- [23910]退出成功 -- 逐鹿台 

ACK_ARENA_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_OK
	self:init()
end)
