
require "common/RequestMessage"

-- [55810]请求拳皇信息 -- 拳皇生涯 

REQ_FIGHTERS_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_REQUEST
	self:init(1 ,{ 55820,700 })
end)

function REQ_FIGHTERS_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_FIGHTERS_REQUEST.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_FIGHTERS_REQUEST.setChap(self, chap)
	self.chap = chap
end
function REQ_FIGHTERS_REQUEST.getChap(self)
	return self.chap
end
