
require "common/AcknowledgementMessage"

-- (手动) -- [3725]好友邀请返回 -- 组队系统 

ACK_TEAM_INVITE_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_INVITE_BACK
	self:init()
end)

function ACK_TEAM_INVITE_BACK.deserialize(self, reader)
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
	self.battle_id = reader:readInt16Unsigned() -- {战役ID}
end

-- {队伍ID}
function ACK_TEAM_INVITE_BACK.getTeamId(self)
	return self.team_id
end

-- {战役ID}
function ACK_TEAM_INVITE_BACK.getBattleId(self)
	return self.battle_id
end
