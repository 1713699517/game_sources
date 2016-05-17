
require "common/RequestMessage"

-- [10730]停用称号 -- 称号 

REQ_TITLE_STOP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TITLE_STOP
	self:init(0, nil)
end)

function REQ_TITLE_STOP.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {类型(见常量)}
	writer:writeInt16Unsigned(self.tid)  -- {称号id}
end

function REQ_TITLE_STOP.setArguments(self,type,tid)
	self.type = type  -- {类型(见常量)}
	self.tid = tid  -- {称号id}
end

-- {类型(见常量)}
function REQ_TITLE_STOP.setType(self, type)
	self.type = type
end
function REQ_TITLE_STOP.getType(self)
	return self.type
end

-- {称号id}
function REQ_TITLE_STOP.setTid(self, tid)
	self.tid = tid
end
function REQ_TITLE_STOP.getTid(self)
	return self.tid
end
