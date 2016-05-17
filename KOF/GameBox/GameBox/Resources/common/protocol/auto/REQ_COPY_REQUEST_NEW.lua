
require "common/RequestMessage"

-- (手动) -- [7010]请求普通副本 -- 副本 

REQ_COPY_REQUEST_NEW = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_REQUEST_NEW
	self:init()
end)

function REQ_COPY_REQUEST_NEW.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_COPY_REQUEST_NEW.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_COPY_REQUEST_NEW.setChap(self, chap)
	self.chap = chap
end
function REQ_COPY_REQUEST_NEW.getChap(self)
	return self.chap
end
