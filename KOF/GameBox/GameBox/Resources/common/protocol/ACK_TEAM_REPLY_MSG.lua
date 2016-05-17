
require "common/AcknowledgementMessage"

-- [3530]队伍信息块 -- 组队系统 

ACK_TEAM_REPLY_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_REPLY_MSG
	self:init()
end)

function ACK_TEAM_REPLY_MSG.deserialize(self, reader)
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.leader_name = reader:readString() -- {队长姓名}
	self.num = reader:readInt16Unsigned() -- {队员数量}
end

-- {队伍ID}
function ACK_TEAM_REPLY_MSG.getTeamId(self)
	return self.team_id
end

-- {副本ID}
function ACK_TEAM_REPLY_MSG.getCopyId(self)
	return self.copy_id
end

-- {队长姓名}
function ACK_TEAM_REPLY_MSG.getLeaderName(self)
	return self.leader_name
end

-- {队员数量}
function ACK_TEAM_REPLY_MSG.getNum(self)
	return self.num
end
