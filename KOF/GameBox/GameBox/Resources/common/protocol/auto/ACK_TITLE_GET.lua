
require "common/AcknowledgementMessage"

-- [10740]更新称号 -- 称号 

ACK_TITLE_GET = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_GET
	self:init()
end)

function ACK_TITLE_GET.deserialize(self, reader)
	self.flag = reader:readInt8Unsigned() -- {(1:添加 | 0:删除)}
	self.state = reader:readInt8Unsigned() -- {1:启用中 | 0:未启用}
	self.tid = reader:readInt16Unsigned() -- {称号ID}
end

-- {(1:添加 | 0:删除)}
function ACK_TITLE_GET.getFlag(self)
	return self.flag
end

-- {1:启用中 | 0:未启用}
function ACK_TITLE_GET.getState(self)
	return self.state
end

-- {称号ID}
function ACK_TITLE_GET.getTid(self)
	return self.tid
end
