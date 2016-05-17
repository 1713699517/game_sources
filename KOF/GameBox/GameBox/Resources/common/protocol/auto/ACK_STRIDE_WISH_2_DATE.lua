
require "common/AcknowledgementMessage"

-- [43571]返回许愿日志块 -- 跨服战 

ACK_STRIDE_WISH_2_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_WISH_2_DATE
	self:init()
end)

function ACK_STRIDE_WISH_2_DATE.deserialize(self, reader)
	self.name = reader:readUTF() -- {玩家姓名}
	self.name_colcor = reader:readInt8Unsigned() -- {名字颜色}
	self.type = reader:readInt8Unsigned() -- {许愿类型}
end

-- {玩家姓名}
function ACK_STRIDE_WISH_2_DATE.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_STRIDE_WISH_2_DATE.getNameColcor(self)
	return self.name_colcor
end

-- {许愿类型}
function ACK_STRIDE_WISH_2_DATE.getType(self)
	return self.type
end
