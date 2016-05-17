
require "common/AcknowledgementMessage"

-- [40538]玩家死亡状态 -- 天宫之战 

ACK_SKYWAR_ROLE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_ROLE_STATE
	self:init()
end)

function ACK_SKYWAR_ROLE_STATE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.die = reader:readInt32Unsigned() -- {死亡状态(0:正常|非零:死亡时间戳)}
	self.cost = reader:readInt32Unsigned() -- {复活消耗金元}
end

-- {玩家uid}
function ACK_SKYWAR_ROLE_STATE.getUid(self)
	return self.uid
end

-- {死亡状态(0:正常|非零:死亡时间戳)}
function ACK_SKYWAR_ROLE_STATE.getDie(self)
	return self.die
end

-- {复活消耗金元}
function ACK_SKYWAR_ROLE_STATE.getCost(self)
	return self.cost
end
