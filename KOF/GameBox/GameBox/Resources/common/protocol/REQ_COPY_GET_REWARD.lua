
require "common/RequestMessage"

-- (手动) -- [7830]领取副本通关奖励 -- 副本 

REQ_COPY_GET_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_GET_REWARD
	self:init()
end)

function REQ_COPY_GET_REWARD.serialize(self, writer)
	writer:writeInt8Unsigned(self.chest_pos)  -- {}
end

function REQ_COPY_GET_REWARD.setArguments(self,chest_pos)
	self.chest_pos = chest_pos  -- {}
end

-- {}
function REQ_COPY_GET_REWARD.setChestPos(self, chest_pos)
	self.chest_pos = chest_pos
end
function REQ_COPY_GET_REWARD.getChestPos(self)
	return self.chest_pos
end
