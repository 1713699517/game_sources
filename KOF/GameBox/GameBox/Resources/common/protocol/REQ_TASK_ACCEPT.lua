
require "common/RequestMessage"

-- [3230]接受任务 -- 任务 

REQ_TASK_ACCEPT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_ACCEPT
	self:init()
end)

function REQ_TASK_ACCEPT.serialize(self, writer)
	writer:writeInt32Unsigned(self.id)  -- {任务id}
end

function REQ_TASK_ACCEPT.setArguments(self,id)
	self.id = id  -- {任务id}
end

-- {任务id}
function REQ_TASK_ACCEPT.setId(self, id)
	self.id = id
end
function REQ_TASK_ACCEPT.getId(self)
	return self.id
end
