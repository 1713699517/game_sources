
require "common/AcknowledgementMessage"

-- [2338]特定活动物品是否可使用 -- 物品/背包 

ACK_GOODS_ACTY_USE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_ACTY_USE_STATE
	self:init()
end)

function ACK_GOODS_ACTY_USE_STATE.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品ID}
	self.state = reader:readBoolean() -- {true:可使用 | false:不可使用}
end

-- {物品ID}
function ACK_GOODS_ACTY_USE_STATE.getGoodsId(self)
	return self.goods_id
end

-- {true:可使用 | false:不可使用}
function ACK_GOODS_ACTY_USE_STATE.getState(self)
	return self.state
end
