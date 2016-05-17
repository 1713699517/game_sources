
require "common/AcknowledgementMessage"

-- [54210]伤害数据 -- 社团BOSS 

ACK_CLAN_BOSS_HARM_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_HARM_DATA
	self:init()
end)

function ACK_CLAN_BOSS_HARM_DATA.deserialize(self, reader)
	self.harm = reader:readInt32Unsigned() -- {伤害血量}
	self.boss_hp = reader:readInt32Unsigned() -- {BOSS剩余血量}
end

-- {伤害血量}
function ACK_CLAN_BOSS_HARM_DATA.getHarm(self)
	return self.harm
end

-- {BOSS剩余血量}
function ACK_CLAN_BOSS_HARM_DATA.getBossHp(self)
	return self.boss_hp
end
