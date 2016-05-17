
require "common/RequestMessage"

-- [24810]请求排行版 -- 排行榜 

REQ_TOP_RANK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TOP_RANK
	self:init(1 ,{ 24820,700 })
end)

function REQ_TOP_RANK.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {排行类型(见常量?CONST_TOP_TYPE_)}
end

function REQ_TOP_RANK.setArguments(self,type)
	self.type = type  -- {排行类型(见常量?CONST_TOP_TYPE_)}
end

-- {排行类型(见常量?CONST_TOP_TYPE_)}
function REQ_TOP_RANK.setType(self, type)
	self.type = type
end
function REQ_TOP_RANK.getType(self)
	return self.type
end
