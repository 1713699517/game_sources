
require "common/AcknowledgementMessage"

-- [7002]副本信息返回 -- 副本 

ACK_COPY_REVERSE_OLD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_REVERSE_OLD
	self:init()
end)

function ACK_COPY_REVERSE_OLD.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {副本数量}
	self.data = reader:readXXXGroup() -- {副本信息块(7003)}
end

-- {副本数量}
function ACK_COPY_REVERSE_OLD.getCount(self)
	return self.count
end

-- {副本信息块(7003)}
function ACK_COPY_REVERSE_OLD.getData(self)
	return self.data
end
