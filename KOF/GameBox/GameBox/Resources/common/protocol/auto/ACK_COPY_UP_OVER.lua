
require "common/AcknowledgementMessage"

-- [7860]挂机完成 -- 副本 

ACK_COPY_UP_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_OVER
	self:init()
end)

function ACK_COPY_UP_OVER.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.type = reader:readInt8Unsigned() -- {完成类型,见CONST_COPY_UPTYPE_*}
end

-- {副本ID}
function ACK_COPY_UP_OVER.getCopyId(self)
	return self.copy_id
end

-- {完成类型,见CONST_COPY_UPTYPE_*}
function ACK_COPY_UP_OVER.getType(self)
	return self.type
end
