
require "common/AcknowledgementMessage"

-- [34522]玩家积分数据 -- 商城 

ACK_SHOP_INTEGRAL_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_INTEGRAL_BACK
	self:init()
end)

function ACK_SHOP_INTEGRAL_BACK.deserialize(self, reader)
	self.integral = reader:readInt32Unsigned() -- {积分}
end

-- {积分}
function ACK_SHOP_INTEGRAL_BACK.getIntegral(self)
	return self.integral
end
