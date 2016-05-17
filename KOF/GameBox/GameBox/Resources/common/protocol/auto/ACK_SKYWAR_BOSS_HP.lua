
require "common/AcknowledgementMessage"

-- [40541]守城大将气血数据(广播) -- 天宫之战 

ACK_SKYWAR_BOSS_HP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_BOSS_HP
	self:init()
end)

function ACK_SKYWAR_BOSS_HP.deserialize(self, reader)
	self.hp_c = reader:readInt32Unsigned() -- {当前气血值}
	self.hp_max = reader:readInt32Unsigned() -- {最大气血值}
end

-- {当前气血值}
function ACK_SKYWAR_BOSS_HP.getHpC(self)
	return self.hp_c
end

-- {最大气血值}
function ACK_SKYWAR_BOSS_HP.getHpMax(self)
	return self.hp_max
end
