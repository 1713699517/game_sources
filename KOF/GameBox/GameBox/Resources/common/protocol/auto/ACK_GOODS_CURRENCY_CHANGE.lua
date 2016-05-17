
require "common/AcknowledgementMessage"

-- [2070]获得|失去货币通知 -- 物品/背包 

ACK_GOODS_CURRENCY_CHANGE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_CURRENCY_CHANGE
	self:init()
end)

function ACK_GOODS_CURRENCY_CHANGE.deserialize(self, reader)
	self.type = reader:readBoolean() -- {true:获得 | false:失去}
	self.money_type = reader:readInt8Unsigned() -- {货币类型}
	self.money_num = reader:readInt32Unsigned() -- {货币数量}
end

-- {true:获得 | false:失去}
function ACK_GOODS_CURRENCY_CHANGE.getType(self)
	return self.type
end

-- {货币类型}
function ACK_GOODS_CURRENCY_CHANGE.getMoneyType(self)
	return self.money_type
end

-- {货币数量}
function ACK_GOODS_CURRENCY_CHANGE.getMoneyNum(self)
	return self.money_num
end
