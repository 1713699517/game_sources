
require "common/RequestMessage"

-- (手动) -- [3611]请求队伍战役信息 -- 组队系统 

REQ_TEAM_BATTLE_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_BATTLE_ASK
	self:init()
end)

function REQ_TEAM_BATTLE_ASK.serialize(self, writer)
	writer:writeInt32Unsigned(self.team_id)  -- {队伍ID}
end

function REQ_TEAM_BATTLE_ASK.setArguments(self,team_id)
	self.team_id = team_id  -- {队伍ID}
end

-- {队伍ID}
function REQ_TEAM_BATTLE_ASK.setTeamId(self, team_id)
	self.team_id = team_id
end
function REQ_TEAM_BATTLE_ASK.getTeamId(self)
	return self.team_id
end
