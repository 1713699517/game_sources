
require "common/AcknowledgementMessage"

-- [33160]退出帮派成功 -- 社团 

ACK_CLAN_OK_OUT_CLAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_OUT_CLAN
	self:init()
end)
