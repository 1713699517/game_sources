
require "common/RequestMessage"

-- [22210]请求福利数据 -- 福利 

REQ_WELFARE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WELFARE_REQUEST
	self:init(0, nil)
end)

function REQ_WELFARE_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {奖励类型(见常量定义)}
end

function REQ_WELFARE_REQUEST.setArguments(self,type)
	self.type = type  -- {奖励类型(见常量定义)}
end

-- {奖励类型(见常量定义)}
function REQ_WELFARE_REQUEST.setType(self, type)
	self.type = type
end
function REQ_WELFARE_REQUEST.getType(self)
	return self.type
end
