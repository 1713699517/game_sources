
require "common/AcknowledgementMessage"

-- [51230]头像信息块 -- 每日一箭 

ACK_SHOOT_HEAD_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_HEAD_INFO
	self:init()
end)

function ACK_SHOOT_HEAD_INFO.deserialize(self, reader)
	self.position = reader:readInt16Unsigned() -- {位置}
	self.is_shooted = reader:readInt8Unsigned() -- {是否被射中(0：没被射中1：已被射中)}
end

-- {位置}
function ACK_SHOOT_HEAD_INFO.getPosition(self)
	return self.position
end

-- {是否被射中(0：没被射中1：已被射中)}
function ACK_SHOOT_HEAD_INFO.getIsShooted(self)
	return self.is_shooted
end
