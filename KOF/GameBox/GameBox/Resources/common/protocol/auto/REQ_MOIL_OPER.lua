
require "common/RequestMessage"

-- [35030]苦工系统操作 -- 苦工 

REQ_MOIL_OPER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_OPER
	self:init(0, nil)
end)

function REQ_MOIL_OPER.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:抓捕6:求救(CONST_MOIL_FUNCTION*)}
end

function REQ_MOIL_OPER.setArguments(self,type)
	self.type = type  -- {1:抓捕6:求救(CONST_MOIL_FUNCTION*)}
end

-- {1:抓捕6:求救(CONST_MOIL_FUNCTION*)}
function REQ_MOIL_OPER.setType(self, type)
	self.type = type
end
function REQ_MOIL_OPER.getType(self)
	return self.type
end
