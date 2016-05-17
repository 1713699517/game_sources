
require "common/AcknowledgementMessage"

-- [3700]邀请好友返回 -- 组队系统 

ACK_TEAM_INVITE_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_INVITE_NOTICE
	self:init()
end)

function ACK_TEAM_INVITE_NOTICE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型,详见CONST_TEAM_INVITE_*}
	self.uname = reader:readString() -- {好友名字}
	self.name_color = reader:readInt8Unsigned() -- {名字颜色}
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
end

-- {类型,详见CONST_TEAM_INVITE_*}
function ACK_TEAM_INVITE_NOTICE.getType(self)
	return self.type
end

-- {好友名字}
function ACK_TEAM_INVITE_NOTICE.getUname(self)
	return self.uname
end

-- {名字颜色}
function ACK_TEAM_INVITE_NOTICE.getNameColor(self)
	return self.name_color
end

-- {副本ID}
function ACK_TEAM_INVITE_NOTICE.getCopyId(self)
	return self.copy_id
end

-- {队伍ID}
function ACK_TEAM_INVITE_NOTICE.getTeamId(self)
	return self.team_id
end
