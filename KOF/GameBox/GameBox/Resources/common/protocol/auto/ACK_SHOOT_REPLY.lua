
require "common/AcknowledgementMessage"

-- (手动) -- [51220]每日一箭返回 -- 每日一箭 

ACK_SHOOT_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_REPLY
	self:init()
end)

function ACK_SHOOT_REPLY.deserialize(self, reader)
    print("ACK_SHOOT_REPLY.deserialize")
    print("-----------------AUTO-----------------")
    print("尼玛!!!改错协议")
	self.freetime = reader:readInt16Unsigned() -- {射箭免费次数}
	self.money = reader:readInt32Unsigned() -- {奖池金额}
	self.have_get = reader:readInt16() -- {已经射中的面板}
end

-- {射箭免费次数}
function ACK_SHOOT_REPLY.getFreetime(self)
	return self.freetime
end

-- {奖池金额}
function ACK_SHOOT_REPLY.getMoney(self)
	return self.money
end

-- {已经射中的面板}
function ACK_SHOOT_REPLY.getHaveGet(self)
	return self.have_get
end
