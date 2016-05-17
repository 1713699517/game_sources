
require "common/AcknowledgementMessage"

-- (手动) -- [37053]自己伤害（废除） -- 世界BOSS 

ACK_WORLD_BOSS_SELF_HARM = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_SELF_HARM
	self:init()
end)

function ACK_WORLD_BOSS_SELF_HARM.deserialize(self, reader)
	self.harm = reader:readInt32Unsigned() -- {伤害}
	self.hp = reader:readInt32Unsigned() -- {当前血量}
end

-- {伤害}
function ACK_WORLD_BOSS_SELF_HARM.getHarm(self)
	return self.harm
end

-- {当前血量}
function ACK_WORLD_BOSS_SELF_HARM.getHp(self)
	return self.hp
end
