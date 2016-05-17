
require "common/RequestMessage"

-- [3720]查询队伍是否存在 -- 组队系统 

REQ_TEAM_LIVE_REQ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_LIVE_REQ
	self:init(0.5 ,{ 3730,700 })
end)

function REQ_TEAM_LIVE_REQ.serialize(self, writer)
	writer:writeInt32Unsigned(self.team_id)  -- {队伍ID}
	writer:writeInt8Unsigned(self.invite_type)  -- {0：招募|1：邀请}
end

function REQ_TEAM_LIVE_REQ.setArguments(self,team_id,invite_type)
	self.team_id = team_id  -- {队伍ID}
	self.invite_type = invite_type  -- {0：招募|1：邀请}
end

-- {队伍ID}
function REQ_TEAM_LIVE_REQ.setTeamId(self, team_id)
	self.team_id = team_id
end
function REQ_TEAM_LIVE_REQ.getTeamId(self)
	return self.team_id
end

-- {0：招募|1：邀请}
function REQ_TEAM_LIVE_REQ.setInviteType(self, invite_type)
	self.invite_type = invite_type
end
function REQ_TEAM_LIVE_REQ.getInviteType(self)
	return self.invite_type
end
