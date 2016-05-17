
require "common/AcknowledgementMessage"

-- [3605]队伍信息 -- 组队系统 

ACK_TEAM_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_INFO
	self:init()
end)

-- {队伍ID}
function ACK_TEAM_INFO.getTeamId(self)
	return self.team_id
end

-- {队长Sid}
function ACK_TEAM_INFO.getLeaderSid(self)
	return self.leader_sid
end

-- {队长Uid}
function ACK_TEAM_INFO.getLeaderUid(self)
	return self.leader_uid
end

-- {剩余奖励次数}
function ACK_TEAM_INFO.getRewardTimes(self)
	return self.reward_times
end

-- {队伍人数}
function ACK_TEAM_INFO.getCount(self)
	return self.count
end

-- {队伍人员信息块(3610)}
function ACK_TEAM_INFO.getDataMember(self)
	return self.data_member
end
