
require "common/AcknowledgementMessage"

-- [24920]领取成功 -- 新手卡 

ACK_CARD_SUCCEED = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_SUCCEED
	self:init()
end)

-- {物品数量}
function ACK_CARD_SUCCEED.getGoodsCount(self)
	return self.goods_count
end

-- {物品信息块(2001)}
function ACK_CARD_SUCCEED.getGoodsMsgNo(self)
	return self.goods_msg_no
end
