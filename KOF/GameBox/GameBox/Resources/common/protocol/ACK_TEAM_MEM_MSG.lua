
require "common/AcknowledgementMessage"

-- [3590]队伍成员信息块 -- 组队系统 

ACK_TEAM_MEM_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_MEM_MSG
	self:init()
end)

function ACK_TEAM_MEM_MSG.deserialize(self, reader)
	self.uid = reader:readInt8Unsigned() -- {队员Uid}
	self.name = reader:readInt8Unsigned() -- {队员姓名}
	self.name_color = reader:readInt8Unsigned() -- {队员姓名颜色}
	self.power = reader:readInt32Unsigned() -- {队员战斗力}
end

-- {队员Uid}
function ACK_TEAM_MEM_MSG.getUid(self)
	return self.uid
end

-- {队员姓名}
function ACK_TEAM_MEM_MSG.getName(self)
	return self.name
end

-- {队员姓名颜色}
function ACK_TEAM_MEM_MSG.getNameColor(self)
	return self.name_color
end

-- {队员战斗力}
function ACK_TEAM_MEM_MSG.getPower(self)
	return self.power
end
