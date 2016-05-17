
require "common/AcknowledgementMessage"

-- [33040]申请成功 -- 社团 

ACK_CLAN_OK_JOIN_CLAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_JOIN_CLAN
	self:init()
end)

function ACK_CLAN_OK_JOIN_CLAN.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {操作类型0取消| 1申请}
	self.clan_id = reader:readInt32Unsigned() -- {帮派ID}
end

-- {操作类型0取消| 1申请}
function ACK_CLAN_OK_JOIN_CLAN.getType(self)
	return self.type
end

-- {帮派ID}
function ACK_CLAN_OK_JOIN_CLAN.getClanId(self)
	return self.clan_id
end
