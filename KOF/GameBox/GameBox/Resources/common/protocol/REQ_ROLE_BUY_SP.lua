
require "common/RequestMessage"

-- (手动) -- [1250]购买体力值 -- 角色 

REQ_ROLE_BUY_SP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_BUY_SP
	self:init()
end)

function REQ_ROLE_BUY_SP.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {购买类型(见常量定义)}
end

function REQ_ROLE_BUY_SP.setArguments(self,type)
	self.type = type  -- {购买类型(见常量定义)}
end

-- {购买类型(见常量定义)}
function REQ_ROLE_BUY_SP.setType(self, type)
	self.type = type
end
function REQ_ROLE_BUY_SP.getType(self)
	return self.type
end
