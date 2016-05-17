
require "common/AcknowledgementMessage"

-- [5930]场景广播-帮派 -- 场景 

ACK_SCENE_CHANGE_CLAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_CLAN
	self:init()
end)

function ACK_SCENE_CHANGE_CLAN.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.clan_id = reader:readInt16Unsigned() -- {帮派id}
	self.clan_name = reader:readString() -- {帮派名称}
end

-- {玩家uid}
function ACK_SCENE_CHANGE_CLAN.getUid(self)
	return self.uid
end

-- {帮派id}
function ACK_SCENE_CHANGE_CLAN.getClanId(self)
	return self.clan_id
end

-- {帮派名称}
function ACK_SCENE_CHANGE_CLAN.getClanName(self)
	return self.clan_name
end
