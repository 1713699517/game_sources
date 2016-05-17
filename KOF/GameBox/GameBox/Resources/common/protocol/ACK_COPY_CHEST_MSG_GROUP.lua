
require "common/AcknowledgementMessage"

-- [7850]宝箱信息块 -- 副本 

ACK_COPY_CHEST_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_CHEST_MSG_GROUP
	self:init()
end)

-- {宝箱位置}
function ACK_COPY_CHEST_MSG_GROUP.getGoodspos(self)
	return self.goodspos
end

-- {物品信息块}
function ACK_COPY_CHEST_MSG_GROUP.getMsgGood(self)
	return self.msg_good
end
