
require "common/AcknowledgementMessage"

-- (手动) -- [3710]招募队友返回 -- 组队系统 

ACK_TEAM_RECRUIT_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_RECRUIT_NOTICE
	self:init()
end)

function ACK_TEAM_RECRUIT_NOTICE.deserialize(self, reader)
	self.uname = reader:readString() -- {玩家名字}
	self.uname_color = reader:readInt8Unsigned() -- {名字颜色}
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
end

-- {玩家名字}
function ACK_TEAM_RECRUIT_NOTICE.getUname(self)
	return self.uname
end

-- {名字颜色}
function ACK_TEAM_RECRUIT_NOTICE.getUnameColor(self)
	return self.uname_color
end

-- {副本ID}
function ACK_TEAM_RECRUIT_NOTICE.getCopyId(self)
	return self.copy_id
end

-- {队伍ID}
function ACK_TEAM_RECRUIT_NOTICE.getTeamId(self)
	return self.team_id
end
