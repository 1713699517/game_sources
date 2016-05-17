
require "common/RequestMessage"

-- [10720]启用称号 -- 称号 

REQ_TITLE_USE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TITLE_USE
	self:init(0, nil)
end)

function REQ_TITLE_USE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {类型(见常量)}
	writer:writeInt16Unsigned(self.tid)  -- {称号id}
end

function REQ_TITLE_USE.setArguments(self,type,tid)
	self.type = type  -- {类型(见常量)}
	self.tid = tid  -- {称号id}
end

-- {类型(见常量)}
function REQ_TITLE_USE.setType(self, type)
	self.type = type
end
function REQ_TITLE_USE.getType(self)
	return self.type
end

-- {称号id}
function REQ_TITLE_USE.setTid(self, tid)
	self.tid = tid
end
function REQ_TITLE_USE.getTid(self)
	return self.tid
end
