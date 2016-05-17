
require "common/AcknowledgementMessage"

-- (手动) -- [47260]触发属性信息块 -- 藏宝阁系统 

ACK_TREASURE_ATTRIBUTE_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_ATTRIBUTE_INFO
	self:init()
end)

function ACK_TREASURE_ATTRIBUTE_INFO.deserialize(self, reader)
	self.keyid = reader:readInt16Unsigned() -- {属性id}
	self.value = reader:readInt8Unsigned() -- {属性数值}
end

-- {属性id}
function ACK_TREASURE_ATTRIBUTE_INFO.getKeyid(self)
	return self.keyid
end

-- {属性数值}
function ACK_TREASURE_ATTRIBUTE_INFO.getValue(self)
	return self.value
end
