
require "common/AcknowledgementMessage"

-- [10725]设置称号成功 -- 称号 

ACK_TITLE_USE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_USE_OK
	self:init()
end)

function ACK_TITLE_USE_OK.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1:启用中 | 0:未启用}
	self.tid = reader:readInt16Unsigned() -- {称号id}
end

-- {1:启用中 | 0:未启用}
function ACK_TITLE_USE_OK.getState(self)
	return self.state
end

-- {称号id}
function ACK_TITLE_USE_OK.getTid(self)
	return self.tid
end
