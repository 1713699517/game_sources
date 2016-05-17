
require "common/AcknowledgementMessage"

-- [47230]触发属性加成 -- 珍宝阁系统 

ACK_TREASURE_ATTRIBUTE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_ATTRIBUTE
	self:init()
end)

function ACK_TREASURE_ATTRIBUTE.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {id}
	self.state = reader:readBoolean() -- {打造成功与否的状态1:成功 0：失败}
end

-- {id}
function ACK_TREASURE_ATTRIBUTE.getId(self)
	return self.id
end

-- {打造成功与否的状态1:成功 0：失败}
function ACK_TREASURE_ATTRIBUTE.getState(self)
	return self.state
end
