
require "common/RequestMessage"

-- [46210]请求魔王副本 -- 魔王副本 

REQ_FIEND_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIEND_REQUEST
	self:init(1 ,{ 46270,700 })
end)

function REQ_FIEND_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_FIEND_REQUEST.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_FIEND_REQUEST.setChap(self, chap)
	self.chap = chap
end
function REQ_FIEND_REQUEST.getChap(self)
	return self.chap
end
