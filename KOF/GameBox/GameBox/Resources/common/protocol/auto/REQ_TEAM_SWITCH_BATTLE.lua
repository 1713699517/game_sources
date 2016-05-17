
require "common/RequestMessage"

-- (手动) -- [3665]切换队伍战役ID -- 组队系统 

REQ_TEAM_SWITCH_BATTLE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_SWITCH_BATTLE
	self:init()
end)

function REQ_TEAM_SWITCH_BATTLE.serialize(self, writer)
	writer:writeInt16Unsigned(self.battle_id)  -- {要切换的战役Id}
end

function REQ_TEAM_SWITCH_BATTLE.setArguments(self,battle_id)
	self.battle_id = battle_id  -- {要切换的战役Id}
end

-- {要切换的战役Id}
function REQ_TEAM_SWITCH_BATTLE.setBattleId(self, battle_id)
	self.battle_id = battle_id
end
function REQ_TEAM_SWITCH_BATTLE.getBattleId(self)
	return self.battle_id
end
