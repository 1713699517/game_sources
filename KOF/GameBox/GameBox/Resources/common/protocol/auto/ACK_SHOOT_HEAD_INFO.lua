
require "common/AcknowledgementMessage"

-- [51230]头像信息块 -- 每日一箭 

ACK_SHOOT_HEAD_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_HEAD_INFO
	self:init()
end)

function ACK_SHOOT_HEAD_INFO.deserialize(self, reader)
	self.position = reader:readInt16Unsigned() -- {位置}
	self.type = reader:readInt8Unsigned() -- {奖品的类别（1：美刀，2：钻石，3：道具）}
	self.award = reader:readInt16Unsigned() -- {获得的奖品}
end

-- {位置}
function ACK_SHOOT_HEAD_INFO.getPosition(self)
	return self.position
end

-- {奖品的类别（1：美刀，2：钻石，3：道具）}
function ACK_SHOOT_HEAD_INFO.getType(self)
	return self.type
end

-- {获得的奖品}
function ACK_SHOOT_HEAD_INFO.getAward(self)
	return self.award
end
