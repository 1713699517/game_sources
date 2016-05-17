
require "common/AcknowledgementMessage"

-- [43600]返回橙色精魄数量 -- 跨服战 

ACK_STRIDE_SOUL_COUNT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_SOUL_COUNT
	self:init()
end)

-- {数量}
function ACK_STRIDE_SOUL_COUNT.getCount(self)
	return self.count
end

-- {信息块( 31110)}
function ACK_STRIDE_SOUL_COUNT.getData(self)
	return self.data
end
