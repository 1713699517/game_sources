
require "common/RequestMessage"

-- (手动) -- [3615]加入队伍 -- 组队系统 

REQ_TEAM_JOIN_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_JOIN_TEAM
	self:init()
end)

function REQ_TEAM_JOIN_TEAM.serialize(self, writer)
	writer:writeInt32Unsigned(self.team_id)  -- {队伍ID}
end

function REQ_TEAM_JOIN_TEAM.setArguments(self,team_id)
	self.team_id = team_id  -- {队伍ID}
end

-- {队伍ID}
function REQ_TEAM_JOIN_TEAM.setTeamId(self, team_id)
	self.team_id = team_id
end
function REQ_TEAM_JOIN_TEAM.getTeamId(self)
	return self.team_id
end
