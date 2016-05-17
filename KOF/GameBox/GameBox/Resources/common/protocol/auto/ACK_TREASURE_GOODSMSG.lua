
require "common/AcknowledgementMessage"

-- [47215]物品信息块 -- 珍宝阁系统 

ACK_TREASURE_GOODSMSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_GOODSMSG
	self:init()
end)

function ACK_TREASURE_GOODSMSG.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品id}
	self.state = reader:readInt8Unsigned() -- {打造状态1：成功|0：没打造完}
end

-- {物品id}
function ACK_TREASURE_GOODSMSG.getGoodsId(self)
	return self.goods_id
end

-- {打造状态1：成功|0：没打造完}
function ACK_TREASURE_GOODSMSG.getState(self)
	return self.state
end
