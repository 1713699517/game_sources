
require "common/AcknowledgementMessage"

-- [7805]副本物品信息块 -- 副本 

ACK_COPY_MSG_GOOD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_MSG_GOOD
	self:init()
end)

function ACK_COPY_MSG_GOOD.deserialize(self, reader)
	self.goods_id = reader:readInt16Unsigned() -- {物品ID}
	self.count = reader:readInt16Unsigned() -- {数量}
end

-- {物品ID}
function ACK_COPY_MSG_GOOD.getGoodsId(self)
	return self.goods_id
end

-- {数量}
function ACK_COPY_MSG_GOOD.getCount(self)
	return self.count
end
