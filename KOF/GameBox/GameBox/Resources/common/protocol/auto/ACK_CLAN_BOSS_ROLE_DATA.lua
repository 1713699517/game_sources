
require "common/AcknowledgementMessage"

-- [54255]玩家信息块 -- 社团BOSS 

ACK_CLAN_BOSS_ROLE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_ROLE_DATA
	self:init()
end)

function ACK_CLAN_BOSS_ROLE_DATA.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.name = reader:readString() -- {玩家名字}
	self.name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.integer = reader:readInt32Unsigned() -- {玩家攻击总伤害}
	self.rank = reader:readInt16Unsigned() -- {排行}
end

-- {玩家Uid}
function ACK_CLAN_BOSS_ROLE_DATA.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_CLAN_BOSS_ROLE_DATA.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_CLAN_BOSS_ROLE_DATA.getNameColor(self)
	return self.name_color
end

-- {玩家攻击总伤害}
function ACK_CLAN_BOSS_ROLE_DATA.getInteger(self)
	return self.integer
end

-- {排行}
function ACK_CLAN_BOSS_ROLE_DATA.getRank(self)
	return self.rank
end
