
require "common/AcknowledgementMessage"

-- [12160]坐骑吃仙果返回结果 -- 坐骑 

ACK_MOUNT_MOUNT_FRUIT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_MOUNT_FRUIT
	self:init()
end)

function ACK_MOUNT_MOUNT_FRUIT.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {增加属性类型：见 CONST_MOUNT_PROP_*}
	self.sum = reader:readInt16Unsigned() -- {增加属性数量}
end

-- {增加属性类型：见 CONST_MOUNT_PROP_*}
function ACK_MOUNT_MOUNT_FRUIT.getType(self)
	return self.type
end

-- {增加属性数量}
function ACK_MOUNT_MOUNT_FRUIT.getSum(self)
	return self.sum
end
