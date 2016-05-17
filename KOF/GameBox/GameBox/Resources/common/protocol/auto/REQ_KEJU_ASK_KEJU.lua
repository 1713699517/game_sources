
require "common/RequestMessage"

-- [44510]请求答题面板 -- 御前科举 

REQ_KEJU_ASK_KEJU = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KEJU_ASK_KEJU
	self:init(0, nil)
end)

function REQ_KEJU_ASK_KEJU.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {答题类型0每日|1周末}
end

function REQ_KEJU_ASK_KEJU.setArguments(self,type)
	self.type = type  -- {答题类型0每日|1周末}
end

-- {答题类型0每日|1周末}
function REQ_KEJU_ASK_KEJU.setType(self, type)
	self.type = type
end
function REQ_KEJU_ASK_KEJU.getType(self)
	return self.type
end
