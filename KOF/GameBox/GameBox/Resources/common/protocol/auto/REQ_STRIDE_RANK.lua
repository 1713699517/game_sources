
require "common/RequestMessage"

-- [43540]请求排行榜 -- 跨服战 

REQ_STRIDE_RANK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_RANK
	self:init(0, nil)
end)

function REQ_STRIDE_RANK.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {2:三界榜3:巅峰榜5:三界挑战榜}
end

function REQ_STRIDE_RANK.setArguments(self,type)
	self.type = type  -- {2:三界榜3:巅峰榜5:三界挑战榜}
end

-- {2:三界榜3:巅峰榜5:三界挑战榜}
function REQ_STRIDE_RANK.setType(self, type)
	self.type = type
end
function REQ_STRIDE_RANK.getType(self)
	return self.type
end
