
require "common/RequestMessage"

-- [6090]怪物击倒 -- 战斗 

REQ_WAR_DOWN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_DOWN
	self:init(0, nil)
end)

function REQ_WAR_DOWN.serialize(self, writer)
	writer:writeInt32Unsigned(self.monster_id)  -- {怪物ID}
	writer:writeInt16Unsigned(self.monster_mid)  -- {怪物唯一ID}
end

function REQ_WAR_DOWN.setArguments(self,monster_id,monster_mid)
	self.monster_id = monster_id  -- {怪物ID}
	self.monster_mid = monster_mid  -- {怪物唯一ID}
end

-- {怪物ID}
function REQ_WAR_DOWN.setMonsterId(self, monster_id)
	self.monster_id = monster_id
end
function REQ_WAR_DOWN.getMonsterId(self)
	return self.monster_id
end

-- {怪物唯一ID}
function REQ_WAR_DOWN.setMonsterMid(self, monster_mid)
	self.monster_mid = monster_mid
end
function REQ_WAR_DOWN.getMonsterMid(self)
	return self.monster_mid
end
