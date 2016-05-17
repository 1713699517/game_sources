
require "common/RequestMessage"

-- [3250]提交任务 -- 任务 

REQ_TASK_SUBMIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_SUBMIT
	self:init(1 ,{ 3220,700 })
end)

function REQ_TASK_SUBMIT.serialize(self, writer)
	writer:writeInt32Unsigned(self.id)  -- {任务id}
	writer:writeInt32Unsigned(self.arg)  -- {任务参数}
end

function REQ_TASK_SUBMIT.setArguments(self,id,arg)
	self.id = id  -- {任务id}
	self.arg = arg  -- {任务参数}
end

-- {任务id}
function REQ_TASK_SUBMIT.setId(self, id)
	self.id = id
end
function REQ_TASK_SUBMIT.getId(self)
	return self.id
end

-- {任务参数}
function REQ_TASK_SUBMIT.setArg(self, arg)
	self.arg = arg
end
function REQ_TASK_SUBMIT.getArg(self)
	return self.arg
end
