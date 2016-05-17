
require "common/AcknowledgementMessage"

-- (手动) -- [31187]刀数据 -- 客栈 

ACK_INN_KNIFEXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_KNIFEXX1
	self:init()
end)

function ACK_INN_KNIFEXX1.deserialize(self, reader)
	self.color_knife = reader:readInt8Unsigned() -- {刀的颜色}
	self.golds = reader:readInt32Unsigned() -- {刀的价格}
end

-- {刀的颜色}
function ACK_INN_KNIFEXX1.getColorKnife(self)
	return self.color_knife
end

-- {刀的价格}
function ACK_INN_KNIFEXX1.getGolds(self)
	return self.golds
end
