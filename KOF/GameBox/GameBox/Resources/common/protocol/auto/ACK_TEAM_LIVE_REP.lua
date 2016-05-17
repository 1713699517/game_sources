
require "common/AcknowledgementMessage"

-- [3730]查询队伍返回 -- 组队系统 

ACK_TEAM_LIVE_REP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_LIVE_REP
	self:init()
end)

function ACK_TEAM_LIVE_REP.deserialize(self, reader)
	self.rep = reader:readInt8Unsigned() -- {0:不存在|1:存在}
	self.invite_type = reader:readInt8Unsigned() -- {0：招募|1：邀请}
end

-- {0:不存在|1:存在}
function ACK_TEAM_LIVE_REP.getRep(self)
	return self.rep
end

-- {0：招募|1：邀请}
function ACK_TEAM_LIVE_REP.getInviteType(self)
	return self.invite_type
end
