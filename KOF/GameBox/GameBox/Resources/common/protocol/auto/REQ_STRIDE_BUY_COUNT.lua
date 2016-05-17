
require "common/RequestMessage"

-- [43660]购买挑战次数 -- 跨服战 

REQ_STRIDE_BUY_COUNT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_BUY_COUNT
	self:init(0, nil)
end)

function REQ_STRIDE_BUY_COUNT.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:三界挑战 2:巅峰挑战}
end

function REQ_STRIDE_BUY_COUNT.setArguments(self,type)
	self.type = type  -- {1:三界挑战 2:巅峰挑战}
end

-- {1:三界挑战 2:巅峰挑战}
function REQ_STRIDE_BUY_COUNT.setType(self, type)
	self.type = type
end
function REQ_STRIDE_BUY_COUNT.getType(self)
	return self.type
end
