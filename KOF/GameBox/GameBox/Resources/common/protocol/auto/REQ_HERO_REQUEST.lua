
require "common/RequestMessage"

-- [39010]请求英雄副本 -- 英雄副本 

REQ_HERO_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_REQUEST
	self:init(1 ,{ 39070,700 })
end)

function REQ_HERO_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.chap)  -- {章节ID 0：默认章节}
end

function REQ_HERO_REQUEST.setArguments(self,chap)
	self.chap = chap  -- {章节ID 0：默认章节}
end

-- {章节ID 0：默认章节}
function REQ_HERO_REQUEST.setChap(self, chap)
	self.chap = chap
end
function REQ_HERO_REQUEST.getChap(self)
	return self.chap
end
