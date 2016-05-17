
require "common/AcknowledgementMessage"

-- [33370]训练成功[33305] -- 社团 

ACK_CLAN_OK_STRENGTH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_STRENGTH
	self:init()
end)
