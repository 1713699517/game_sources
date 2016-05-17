
require "common/RequestMessage"

-- (手动) -- [39035]花费元宝加进入次数(单人)或者奖励次数(多人) -- 英雄副本 

REQ_HERO_ADD_TIMES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_ADD_TIMES
	self:init()
end)

function REQ_HERO_ADD_TIMES.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {取经战役Id}
	writer:writeInt16Unsigned(self.times)  -- {增加的次数}
end

function REQ_HERO_ADD_TIMES.setArguments(self,copy_id,times)
	self.copy_id = copy_id  -- {取经战役Id}
	self.times = times  -- {增加的次数}
end

-- {取经战役Id}
function REQ_HERO_ADD_TIMES.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_HERO_ADD_TIMES.getCopyId(self)
	return self.copy_id
end

-- {增加的次数}
function REQ_HERO_ADD_TIMES.setTimes(self, times)
	self.times = times
end
function REQ_HERO_ADD_TIMES.getTimes(self)
	return self.times
end
