
require "common/AcknowledgementMessage"

-- [33120]返回修改公告结果 -- 社团 

ACK_CLAN_OK_RESET_CAST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_RESET_CAST
	self:init()
end)
