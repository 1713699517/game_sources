
require "common/RequestMessage"

-- [5140]被怪物击中 -- 场景 

REQ_SCENE_HIT_TIMES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_HIT_TIMES
	self:init(0, nil)
end)

function REQ_SCENE_HIT_TIMES.serialize(self, writer)
	writer:writeInt16Unsigned(self.times)  -- {击中次数}
end

function REQ_SCENE_HIT_TIMES.setArguments(self,times)
	self.times = times  -- {击中次数}
end

-- {击中次数}
function REQ_SCENE_HIT_TIMES.setTimes(self, times)
	self.times = times
end
function REQ_SCENE_HIT_TIMES.getTimes(self)
	return self.times
end
