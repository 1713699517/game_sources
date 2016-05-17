
require "common/AcknowledgementMessage"

-- [10732]停用称号成功 -- 称号 

ACK_TITLE_STOP_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_STOP_OK
	self:init()
end)

function ACK_TITLE_STOP_OK.deserialize(self, reader)
	self.tid = reader:readInt16Unsigned() -- {称号id}
end

-- {称号id}
function ACK_TITLE_STOP_OK.getTid(self)
	return self.tid
end
