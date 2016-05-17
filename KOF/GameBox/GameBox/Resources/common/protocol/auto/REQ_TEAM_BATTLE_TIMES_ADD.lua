
require "common/RequestMessage"

-- (手动) -- [3680]增加战役剩余奖励次数 -- 组队系统 

REQ_TEAM_BATTLE_TIMES_ADD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_BATTLE_TIMES_ADD
	self:init()
end)

function REQ_TEAM_BATTLE_TIMES_ADD.serialize(self, writer)
	writer:writeInt16Unsigned(self.battle_id)  -- {战役ID}
	writer:writeInt16Unsigned(self.count)  -- {增加次数}
end

function REQ_TEAM_BATTLE_TIMES_ADD.setArguments(self,battle_id,count)
	self.battle_id = battle_id  -- {战役ID}
	self.count = count  -- {增加次数}
end

-- {战役ID}
function REQ_TEAM_BATTLE_TIMES_ADD.setBattleId(self, battle_id)
	self.battle_id = battle_id
end
function REQ_TEAM_BATTLE_TIMES_ADD.getBattleId(self)
	return self.battle_id
end

-- {增加次数}
function REQ_TEAM_BATTLE_TIMES_ADD.setCount(self, count)
	self.count = count
end
function REQ_TEAM_BATTLE_TIMES_ADD.getCount(self)
	return self.count
end
