
require "common/AcknowledgementMessage"

-- [54305]复活成功 -- 社团BOSS 

ACK_CLAN_BOSS_OK_RELIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_OK_RELIVE
	self:init()
end)
