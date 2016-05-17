
require "common/AcknowledgementMessage"

-- (手动) -- [55875]物品信息块 -- 拳皇生涯 

ACK_FIGHTERS_MSG_GOOD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_MSG_GOOD
	self:init()
end)

function ACK_FIGHTERS_MSG_GOOD.deserialize(self, reader)
	self.goold_id = reader:readInt16Unsigned() -- {物品Id}
	self.count = reader:readInt16Unsigned() -- {物品数量}
end

-- {物品Id}
function ACK_FIGHTERS_MSG_GOOD.getGooldId(self)
	return self.goold_id
end

-- {物品数量}
function ACK_FIGHTERS_MSG_GOOD.getCount(self)
	return self.count
end
