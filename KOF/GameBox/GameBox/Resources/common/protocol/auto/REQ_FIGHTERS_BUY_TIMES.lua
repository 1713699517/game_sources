
require "common/RequestMessage"

-- [55840]购买挑战次数 -- 拳皇生涯 

REQ_FIGHTERS_BUY_TIMES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIGHTERS_BUY_TIMES
	self:init(0, nil)
end)

function REQ_FIGHTERS_BUY_TIMES.serialize(self, writer)
	writer:writeInt16Unsigned(self.times)  -- {要购买的次数}
end

function REQ_FIGHTERS_BUY_TIMES.setArguments(self,times)
	self.times = times  -- {要购买的次数}
end

-- {要购买的次数}
function REQ_FIGHTERS_BUY_TIMES.setTimes(self, times)
	self.times = times
end
function REQ_FIGHTERS_BUY_TIMES.getTimes(self)
	return self.times
end
