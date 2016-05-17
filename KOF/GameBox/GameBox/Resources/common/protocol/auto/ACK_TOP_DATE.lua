
require "common/AcknowledgementMessage"

-- (手动) -- [24820]排行榜信息 -- 排行榜 

ACK_TOP_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_DATE
	self:init()
end)

function ACK_TOP_DATE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {排行类型(见常量?CONST_TOP_TYPE_)}
	self.count = reader:readInt16Unsigned() -- {数量}
end

-- {排行类型(见常量?CONST_TOP_TYPE_)}
function ACK_TOP_DATE.getType(self)
	return self.type
end

-- {数量}
function ACK_TOP_DATE.getCount(self)
	return self.count
end
