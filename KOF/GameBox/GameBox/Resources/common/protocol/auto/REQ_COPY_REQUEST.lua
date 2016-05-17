
require "common/RequestMessage"

-- [7010]请求普通副本 -- 副本 

REQ_COPY_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_REQUEST
	self:init(1 ,{ 7022,700 })
end)

function REQ_COPY_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_COPY_REQUEST.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_COPY_REQUEST.setChap(self, chap)
	self.chap = chap
end
function REQ_COPY_REQUEST.getChap(self)
	return self.chap
end
