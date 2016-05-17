
require "common/RequestMessage"

-- (手动) -- [24850]请求排行榜 -- 排行榜 

REQ_TOP_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TOP_REQUEST
	self:init()
end)

function REQ_TOP_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {排行榜类型}
	writer:writeInt8Unsigned(self.page)  -- {页数}
end

function REQ_TOP_REQUEST.setArguments(self,type,page)
	self.type = type  -- {排行榜类型}
	self.page = page  -- {页数}
end

-- {排行榜类型}
function REQ_TOP_REQUEST.setType(self, type)
	self.type = type
end
function REQ_TOP_REQUEST.getType(self)
	return self.type
end

-- {页数}
function REQ_TOP_REQUEST.setPage(self, page)
	self.page = page
end
function REQ_TOP_REQUEST.getPage(self)
	return self.page
end
