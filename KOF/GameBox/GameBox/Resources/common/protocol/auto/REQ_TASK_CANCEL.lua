
require "common/RequestMessage"

-- [3240]放弃任务 -- 任务 

REQ_TASK_CANCEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_CANCEL
	self:init(0, nil)
end)

function REQ_TASK_CANCEL.serialize(self, writer)
	writer:writeInt32Unsigned(self.id)  -- {任务id}
end

function REQ_TASK_CANCEL.setArguments(self,id)
	self.id = id  -- {任务id}
end

-- {任务id}
function REQ_TASK_CANCEL.setId(self, id)
	self.id = id
end
function REQ_TASK_CANCEL.getId(self)
	return self.id
end
