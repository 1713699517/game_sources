
require "common/AcknowledgementMessage"

-- [24020]清除成功 -- 逐鹿台 

ACK_ARENA_CLEAN_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_CLEAN_OK
	self:init()
end)
