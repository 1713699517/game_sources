
require "common/RequestMessage"

-- [36030]请求重置 -- 三界杀 

REQ_CIRCLE_RESET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CIRCLE_RESET
	self:init(0, nil)
end)

function REQ_CIRCLE_RESET.serialize(self, writer)
	writer:writeInt16Unsigned(self.type)  -- {0:全部重置|武将ID}
end

function REQ_CIRCLE_RESET.setArguments(self,type)
	self.type = type  -- {0:全部重置|武将ID}
end

-- {0:全部重置|武将ID}
function REQ_CIRCLE_RESET.setType(self, type)
	self.type = type
end
function REQ_CIRCLE_RESET.getType(self)
	return self.type
end
