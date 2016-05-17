
require "common/AcknowledgementMessage"

-- [3580]队伍信息返回 -- 组队系统 

ACK_TEAM_TEAM_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_TEAM_REPLY
	self:init()
end)

function ACK_TEAM_TEAM_REPLY.deserialize(self, reader)
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.leader_uid = reader:readInt32Unsigned() -- {队长Uid}
	self.count = reader:readInt16Unsigned() -- {成员数量}
	self.msg = reader:readXXXGroup() -- {成员信息块(3590)}
end

-- {队伍ID}
function ACK_TEAM_TEAM_REPLY.getTeamId(self)
	return self.team_id
end

-- {副本ID}
function ACK_TEAM_TEAM_REPLY.getCopyId(self)
	return self.copy_id
end

-- {队长Uid}
function ACK_TEAM_TEAM_REPLY.getLeaderUid(self)
	return self.leader_uid
end

-- {成员数量}
function ACK_TEAM_TEAM_REPLY.getCount(self)
	return self.count
end

-- {成员信息块(3590)}
function ACK_TEAM_TEAM_REPLY.getMsg(self)
	return self.msg
end
