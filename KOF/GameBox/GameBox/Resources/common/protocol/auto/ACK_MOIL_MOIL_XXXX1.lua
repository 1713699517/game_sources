
require "common/AcknowledgementMessage"

-- [35026]玩家信息块(抓捕,求救) -- 苦工 

ACK_MOIL_MOIL_XXXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_MOIL_XXXX1
	self:init()
end)

function ACK_MOIL_MOIL_XXXX1.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {玩家姓名}
	self.sex = reader:readInt8Unsigned() -- {玩家性别}
	self.pro = reader:readInt8Unsigned() -- {玩家职业}
	self.lv = reader:readInt16Unsigned() -- {玩家等级}
	self.clan_name = reader:readString() -- {帮派名字}
	self.type_id = reader:readInt8Unsigned() -- {身份id}
end

-- {玩家uid}
function ACK_MOIL_MOIL_XXXX1.getUid(self)
	return self.uid
end

-- {玩家姓名}
function ACK_MOIL_MOIL_XXXX1.getName(self)
	return self.name
end

-- {玩家性别}
function ACK_MOIL_MOIL_XXXX1.getSex(self)
	return self.sex
end

-- {玩家职业}
function ACK_MOIL_MOIL_XXXX1.getPro(self)
	return self.pro
end

-- {玩家等级}
function ACK_MOIL_MOIL_XXXX1.getLv(self)
	return self.lv
end

-- {帮派名字}
function ACK_MOIL_MOIL_XXXX1.getClanName(self)
	return self.clan_name
end

-- {身份id}
function ACK_MOIL_MOIL_XXXX1.getTypeId(self)
	return self.type_id
end
