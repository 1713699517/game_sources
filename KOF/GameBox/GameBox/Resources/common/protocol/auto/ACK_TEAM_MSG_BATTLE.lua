
require "common/AcknowledgementMessage"

-- (手动) -- [3613]战役信息块 -- 组队系统 

ACK_TEAM_MSG_BATTLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_MSG_BATTLE
	self:init()
end)

function ACK_TEAM_MSG_BATTLE.deserialize(self, reader)
	self.battle_id = reader:readInt16Unsigned() -- {战役Id}
	self.status = reader:readInt8Unsigned() -- {战役状态(1：当前选择 | 0：未选择)}
end

-- {战役Id}
function ACK_TEAM_MSG_BATTLE.getBattleId(self)
	return self.battle_id
end

-- {战役状态(1：当前选择 | 0：未选择)}
function ACK_TEAM_MSG_BATTLE.getStatus(self)
	return self.status
end
