
require "common/AcknowledgementMessage"

-- [54920]争霸信息返回 -- 格斗之王 

ACK_WRESTLE_ZHENGBA_REQUEST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_ZHENGBA_REQUEST
	self:init()
end)

function ACK_WRESTLE_ZHENGBA_REQUEST.deserialize(self, reader)
	self.name = reader:readString() -- {名字}
	self.lv = reader:readInt32Unsigned() -- {等级}
	self.power = reader:readInt32Unsigned() -- {战斗力}
	self.pro = reader:readInt32Unsigned() -- {职业}
end

-- {名字}
function ACK_WRESTLE_ZHENGBA_REQUEST.getName(self)
	return self.name
end

-- {等级}
function ACK_WRESTLE_ZHENGBA_REQUEST.getLv(self)
	return self.lv
end

-- {战斗力}
function ACK_WRESTLE_ZHENGBA_REQUEST.getPower(self)
	return self.power
end

-- {职业}
function ACK_WRESTLE_ZHENGBA_REQUEST.getPro(self)
	return self.pro
end
