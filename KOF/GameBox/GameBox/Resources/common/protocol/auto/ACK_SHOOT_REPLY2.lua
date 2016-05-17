
require "common/AcknowledgementMessage"

-- (手动) -- [51220]111 -- 每日一箭 

ACK_SHOOT_REPLY2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_REPLY2
	self:init()
end)

function ACK_SHOOT_REPLY2.deserialize(self, reader)
	self.freetime = reader:readInt16Unsigned() -- {射箭免费次数}
	self.money = reader:readInt32Unsigned() -- {奖池金额}
	self.have_get = reader:readInt16() -- {已经射中的面板}
end

-- {射箭免费次数}
function ACK_SHOOT_REPLY2.getFreetime(self)
	return self.freetime
end

-- {奖池金额}
function ACK_SHOOT_REPLY2.getMoney(self)
	return self.money
end

-- {已经射中的面板}
function ACK_SHOOT_REPLY2.getHaveGet(self)
	return self.have_get
end
