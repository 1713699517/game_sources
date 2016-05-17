
require "common/AcknowledgementMessage"

-- [37053]玩家当前血量 -- 世界BOSS 

ACK_WORLD_BOSS_SELF_HP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_SELF_HP
	self:init()
end)

function ACK_WORLD_BOSS_SELF_HP.deserialize(self, reader)
	self.hp = reader:readInt32Unsigned() -- {当前血量}
end

-- {当前血量}
function ACK_WORLD_BOSS_SELF_HP.getHp(self)
	return self.hp
end
