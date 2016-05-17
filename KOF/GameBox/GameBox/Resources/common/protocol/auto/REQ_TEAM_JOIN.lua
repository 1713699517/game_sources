
require "common/RequestMessage"

-- [3600]加入队伍 -- 组队系统 

REQ_TEAM_JOIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_JOIN
	self:init(0 ,{ 3580,700 })
end)

function REQ_TEAM_JOIN.serialize(self, writer)
	writer:writeInt32Unsigned(self.team_id)  -- {队伍ID}
end

function REQ_TEAM_JOIN.setArguments(self,team_id)
	self.team_id = team_id  -- {队伍ID}
end

-- {队伍ID}
function REQ_TEAM_JOIN.setTeamId(self, team_id)
	self.team_id = team_id
end
function REQ_TEAM_JOIN.getTeamId(self)
	return self.team_id
end
