
require "common/AcknowledgementMessage"

-- [3660]申请队长通知 -- 组队系统 

ACK_TEAM_APPLY_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_APPLY_NOTICE
	self:init()
end)

function ACK_TEAM_APPLY_NOTICE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {队员Uid}
	self.name = reader:readString() -- {队员姓名}
	self.name_color = reader:readInt8Unsigned() -- {队员姓名颜色}
end

-- {队员Uid}
function ACK_TEAM_APPLY_NOTICE.getUid(self)
	return self.uid
end

-- {队员姓名}
function ACK_TEAM_APPLY_NOTICE.getName(self)
	return self.name
end

-- {队员姓名颜色}
function ACK_TEAM_APPLY_NOTICE.getNameColor(self)
	return self.name_color
end
