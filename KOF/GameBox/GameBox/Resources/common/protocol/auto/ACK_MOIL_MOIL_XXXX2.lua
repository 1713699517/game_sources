
require "common/AcknowledgementMessage"

-- [35062]苦工信息 -- 苦工 

ACK_MOIL_MOIL_XXXX2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_MOIL_XXXX2
	self:init()
end)

function ACK_MOIL_MOIL_XXXX2.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {苦工uid}
	self.pro = reader:readInt8Unsigned() -- {苦工职业}
	self.sex = reader:readInt8Unsigned() -- {苦工性别}
	self.name = reader:readString() -- {苦工名字}
	self.lv = reader:readInt16Unsigned() -- {被抓捕时等级}
end

-- {苦工uid}
function ACK_MOIL_MOIL_XXXX2.getUid(self)
	return self.uid
end

-- {苦工职业}
function ACK_MOIL_MOIL_XXXX2.getPro(self)
	return self.pro
end

-- {苦工性别}
function ACK_MOIL_MOIL_XXXX2.getSex(self)
	return self.sex
end

-- {苦工名字}
function ACK_MOIL_MOIL_XXXX2.getName(self)
	return self.name
end

-- {被抓捕时等级}
function ACK_MOIL_MOIL_XXXX2.getLv(self)
	return self.lv
end
