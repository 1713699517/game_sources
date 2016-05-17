
require "common/RequestMessage"

-- [5120]杀怪连击 -- 场景 

REQ_SCENE_CAROM_TIMES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_CAROM_TIMES
	self:init(0, nil)
end)

function REQ_SCENE_CAROM_TIMES.serialize(self, writer)
	writer:writeInt16Unsigned(self.times)  -- {连击数}
end

function REQ_SCENE_CAROM_TIMES.setArguments(self,times)
	self.times = times  -- {连击数}
end

-- {连击数}
function REQ_SCENE_CAROM_TIMES.setTimes(self, times)
	self.times = times
end
function REQ_SCENE_CAROM_TIMES.getTimes(self)
	return self.times
end
