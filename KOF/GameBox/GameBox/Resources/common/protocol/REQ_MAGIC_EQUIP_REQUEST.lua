
require "common/RequestMessage"

-- [52210]请求神器面板 -- 神器 

REQ_MAGIC_EQUIP_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_REQUEST
	self:init()
end)

function REQ_MAGIC_EQUIP_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.type)  -- {请求类型（1为神器强化，2神器进阶，3神器商店）}
end

function REQ_MAGIC_EQUIP_REQUEST.setArguments(self,type)
	self.type = type  -- {请求类型（1为神器强化，2神器进阶，3神器商店）}
end

-- {请求类型（1为神器强化，2神器进阶，3神器商店）}
function REQ_MAGIC_EQUIP_REQUEST.setType(self, type)
	self.type = type
end
function REQ_MAGIC_EQUIP_REQUEST.getType(self)
	return self.type
end
