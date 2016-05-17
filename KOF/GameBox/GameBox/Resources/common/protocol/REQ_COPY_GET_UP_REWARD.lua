
require "common/RequestMessage"

-- (手动) -- [7860]领取挂机通关奖励 -- 副本 

REQ_COPY_GET_UP_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_GET_UP_REWARD
	self:init()
end)

function REQ_COPY_GET_UP_REWARD.serialize(self, writer)
	writer:writeInt16Unsigned(self.upcopy_id)  -- {挂机副本ID}
	writer:writeInt8Unsigned(self.upchestpos)  -- {宝箱位置(1,2,3)}
end

function REQ_COPY_GET_UP_REWARD.setArguments(self,upcopy_id,upchestpos)
	self.upcopy_id = upcopy_id  -- {挂机副本ID}
	self.upchestpos = upchestpos  -- {宝箱位置(1,2,3)}
end

-- {挂机副本ID}
function REQ_COPY_GET_UP_REWARD.setUpcopyId(self, upcopy_id)
	self.upcopy_id = upcopy_id
end
function REQ_COPY_GET_UP_REWARD.getUpcopyId(self)
	return self.upcopy_id
end

-- {宝箱位置(1,2,3)}
function REQ_COPY_GET_UP_REWARD.setUpchestpos(self, upchestpos)
	self.upchestpos = upchestpos
end
function REQ_COPY_GET_UP_REWARD.getUpchestpos(self)
	return self.upchestpos
end
