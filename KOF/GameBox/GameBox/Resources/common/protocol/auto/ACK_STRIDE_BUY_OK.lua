
require "common/AcknowledgementMessage"

-- [43670]购买成功 -- 跨服战 

ACK_STRIDE_BUY_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_BUY_OK
	self:init()
end)

function ACK_STRIDE_BUY_OK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {返回剩余次数}
end

-- {返回剩余次数}
function ACK_STRIDE_BUY_OK.getCount(self)
	return self.count
end
