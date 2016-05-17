
require "common/AcknowledgementMessage"

-- [45695]属性加成信息块 -- 活动-阵营战 

ACK_CAMPWAR_ATTR_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_ATTR_MSG
	self:init()
end)

function ACK_CAMPWAR_ATTR_MSG.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型：CONST_ATTR_**}
	self.value = reader:readInt16Unsigned() -- {数值5000=50%}
end

-- {类型：CONST_ATTR_**}
function ACK_CAMPWAR_ATTR_MSG.getType(self)
	return self.type
end

-- {数值5000=50%}
function ACK_CAMPWAR_ATTR_MSG.getValue(self)
	return self.value
end
