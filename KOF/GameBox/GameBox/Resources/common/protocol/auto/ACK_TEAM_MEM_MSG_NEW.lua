
require "common/AcknowledgementMessage"

-- [3574]队伍成员信息块(new) -- 组队系统 

ACK_TEAM_MEM_MSG_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_MEM_MSG_NEW
	self:init()
end)

function ACK_TEAM_MEM_MSG_NEW.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {队员Uid}
	self.name = reader:readString() -- {队员姓名}
	self.name_color = reader:readInt8Unsigned() -- {队员姓名颜色}
	self.lv = reader:readInt16Unsigned() -- {队员等级}
	self.pos = reader:readInt8Unsigned() -- {队员队伍位置}
	self.power = reader:readInt32Unsigned() -- {队员战斗力}
	self.clan_name = reader:readString() -- {队员帮派名字}
	self.pro = reader:readInt8Unsigned() -- {队员职业}
end

-- {队员Uid}
function ACK_TEAM_MEM_MSG_NEW.getUid(self)
	return self.uid
end

-- {队员姓名}
function ACK_TEAM_MEM_MSG_NEW.getName(self)
	return self.name
end

-- {队员姓名颜色}
function ACK_TEAM_MEM_MSG_NEW.getNameColor(self)
	return self.name_color
end

-- {队员等级}
function ACK_TEAM_MEM_MSG_NEW.getLv(self)
	return self.lv
end

-- {队员队伍位置}
function ACK_TEAM_MEM_MSG_NEW.getPos(self)
	return self.pos
end

-- {队员战斗力}
function ACK_TEAM_MEM_MSG_NEW.getPower(self)
	return self.power
end

-- {队员帮派名字}
function ACK_TEAM_MEM_MSG_NEW.getClanName(self)
	return self.clan_name
end

-- {队员职业}
function ACK_TEAM_MEM_MSG_NEW.getPro(self)
	return self.pro
end
