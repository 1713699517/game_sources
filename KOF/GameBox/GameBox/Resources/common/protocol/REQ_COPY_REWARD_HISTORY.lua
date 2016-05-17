
require "common/RequestMessage"

-- (手动) -- [7650]请求副本奖励记录 -- 副本 

REQ_COPY_REWARD_HISTORY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_REWARD_HISTORY
	self:init()
end)

function REQ_COPY_REWARD_HISTORY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_REWARD_HISTORY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_REWARD_HISTORY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_REWARD_HISTORY.getCopyId(self)
	return self.copy_id
end
