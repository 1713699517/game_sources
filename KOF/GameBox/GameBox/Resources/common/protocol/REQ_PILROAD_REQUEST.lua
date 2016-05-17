
require "common/RequestMessage"

-- (手动) -- [39005]请求取经之路 -- 取经之路 

REQ_PILROAD_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_REQUEST
	self:init()
end)

function REQ_PILROAD_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_PILROAD_REQUEST.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_PILROAD_REQUEST.setChap(self, chap)
	self.chap = chap
end
function REQ_PILROAD_REQUEST.getChap(self)
	return self.chap
end
