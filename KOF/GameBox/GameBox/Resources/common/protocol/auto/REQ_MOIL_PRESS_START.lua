
require "common/RequestMessage"

-- [35060]请求压榨/互动 -- 苦工 

REQ_MOIL_PRESS_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_PRESS_START
	self:init(0, nil)
end)

function REQ_MOIL_PRESS_START.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {3:互动4:压榨}
end

function REQ_MOIL_PRESS_START.setArguments(self,type)
	self.type = type  -- {3:互动4:压榨}
end

-- {3:互动4:压榨}
function REQ_MOIL_PRESS_START.setType(self, type)
	self.type = type
end
function REQ_MOIL_PRESS_START.getType(self)
	return self.type
end
