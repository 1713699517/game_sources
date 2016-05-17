
require "common/RequestMessage"

-- [39050]购买英雄副本次数 -- 英雄副本 

REQ_HERO_BUY_TIMES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_BUY_TIMES
	self:init(0 ,{ 39060,700 })
end)

function REQ_HERO_BUY_TIMES.serialize(self, writer)
	writer:writeInt16Unsigned(self.times)  -- {购买的次数}
end

function REQ_HERO_BUY_TIMES.setArguments(self,times)
	self.times = times  -- {购买的次数}
end

-- {购买的次数}
function REQ_HERO_BUY_TIMES.setTimes(self, times)
	self.times = times
end
function REQ_HERO_BUY_TIMES.getTimes(self)
	return self.times
end
