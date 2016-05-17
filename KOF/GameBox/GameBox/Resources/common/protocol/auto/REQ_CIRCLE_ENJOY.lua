
require "common/RequestMessage"

-- [36010]请求三界杀 -- 三界杀 

REQ_CIRCLE_ENJOY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CIRCLE_ENJOY
	self:init(0, nil)
end)

function REQ_CIRCLE_ENJOY.serialize(self, writer)
	writer:writeInt8Unsigned(self.chap)  -- {章节0：为默认章节}
end

function REQ_CIRCLE_ENJOY.setArguments(self,chap)
	self.chap = chap  -- {章节0：为默认章节}
end

-- {章节0：为默认章节}
function REQ_CIRCLE_ENJOY.setChap(self, chap)
	self.chap = chap
end
function REQ_CIRCLE_ENJOY.getChap(self)
	return self.chap
end
