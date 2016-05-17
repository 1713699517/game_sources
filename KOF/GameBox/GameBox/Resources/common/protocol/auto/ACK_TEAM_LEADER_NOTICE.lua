
require "common/AcknowledgementMessage"

-- (手动) -- [3637]队员向队长申请队长通知 -- 组队系统 

ACK_TEAM_LEADER_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_LEADER_NOTICE
	self:init()
end)

function ACK_TEAM_LEADER_NOTICE.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {队员Sid}
	self.uid = reader:readInt32Unsigned() -- {队员Uid}
	self.uname = reader:readString() -- {队员名字}
	self.name_color = reader:readInt8Unsigned() -- {队员姓名颜色}
end

-- {队员Sid}
function ACK_TEAM_LEADER_NOTICE.getSid(self)
	return self.sid
end

-- {队员Uid}
function ACK_TEAM_LEADER_NOTICE.getUid(self)
	return self.uid
end

-- {队员名字}
function ACK_TEAM_LEADER_NOTICE.getUname(self)
	return self.uname
end

-- {队员姓名颜色}
function ACK_TEAM_LEADER_NOTICE.getNameColor(self)
	return self.name_color
end
