
require "common/RequestMessage"

-- (手动) -- [3600]创建队伍 -- 组队系统 

REQ_TEAM_CREATE_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_CREATE_TEAM
	self:init()
end)

function REQ_TEAM_CREATE_TEAM.serialize(self, writer)
	writer:writeInt16Unsigned(self.battle_id)  -- {取经之路战役ID}
end

function REQ_TEAM_CREATE_TEAM.setArguments(self,battle_id)
	self.battle_id = battle_id  -- {取经之路战役ID}
end

-- {取经之路战役ID}
function REQ_TEAM_CREATE_TEAM.setBattleId(self, battle_id)
	self.battle_id = battle_id
end
function REQ_TEAM_CREATE_TEAM.getBattleId(self)
	return self.battle_id
end
