
require "common/AcknowledgementMessage"

-- (手动) -- [47240]处理打造数据请求 -- 藏宝阁系统 

ACK_TREASURE_GOODS_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_GOODS_INFO
	self:init()
end)

function ACK_TREASURE_GOODS_INFO.deserialize(self, reader)
	self.state = reader:readBoolean() -- {打造成功与否的状态}
end

-- {打造成功与否的状态}
function ACK_TREASURE_GOODS_INFO.getState(self)
	return self.state
end
