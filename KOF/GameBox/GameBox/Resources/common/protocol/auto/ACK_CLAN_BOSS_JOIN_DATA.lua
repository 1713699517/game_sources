
require "common/AcknowledgementMessage"

-- [54240]界面信息返回--BOSS信息 -- 社团BOSS 

ACK_CLAN_BOSS_JOIN_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_JOIN_DATA
	self:init()
end)

function ACK_CLAN_BOSS_JOIN_DATA.deserialize(self, reader)
	self.boss_id = reader:readInt16Unsigned() -- {BOSS ID}
	self.boss_hp = reader:readInt32Unsigned() -- {BOSS 当前血量}
	self.boss_name = reader:readString() -- {开启者名字}
end

-- {BOSS ID}
function ACK_CLAN_BOSS_JOIN_DATA.getBossId(self)
	return self.boss_id
end

-- {BOSS 当前血量}
function ACK_CLAN_BOSS_JOIN_DATA.getBossHp(self)
	return self.boss_hp
end

-- {开启者名字}
function ACK_CLAN_BOSS_JOIN_DATA.getBossName(self)
	return self.boss_name
end
